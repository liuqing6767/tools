package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/howeyc/fsnotify"
)

type Watcher struct {
	config *Config

	watchDir    string
	excludeRegs []*regexp.Regexp

	changeFile2Time map[string]time.Time

	fsWatcher *fsnotify.Watcher

	checkCmd       *exec.Cmd
	checkCmdParams []string
	runCmd         *exec.Cmd
	runCmdParams   []string
}

func NewWatcher(config *Config) *Watcher {
	watchDir, err := filepath.Abs(config.WatchDir)
	if err != nil {
		log.Fatalln("fail", err)
	}

	fsWatcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Fatalln("fail", err)
	}

	w := &Watcher{
		config:   config,
		watchDir: watchDir,

		excludeRegs: []*regexp.Regexp{},

		fsWatcher:       fsWatcher,
		changeFile2Time: map[string]time.Time{},

		checkCmdParams: strings.Split(config.CheckCmd, " "),
		runCmdParams:   strings.Split(config.RunCmd, " "),
	}

	stat, err := os.Stat(watchDir)
	if err != nil { // May be not exist
		log.Fatalln("fail", err)
	}
	if !stat.IsDir() {
		if err := fsWatcher.Watch(watchDir); err != nil {
			log.Fatalln("watch fail: \t", watchDir)
		}
		log.Println("watch add: \t", watchDir)

		return w
	}

	for _, v := range config.Excludes {
		r, err := regexp.Compile(v)
		if err != nil {
			log.Fatalln("fail", err)
		}

		w.excludeRegs = append(w.excludeRegs, r)
	}

	// register file system watch
	filepath.Walk(watchDir,
		func(path string, f os.FileInfo, err error) error {
			if err != nil {
				log.Fatalln("fail", err)
			}

			if !f.IsDir() {
				return nil
			}

			if !w.doWatch(path) {
				log.Println("watch skip: \t", path)
				return nil
			}

			w.addWatch(path)

			return nil
		})

	return w
}

func (w *Watcher) doWatch(path string) bool {
	for _, reg := range w.excludeRegs {
		if reg.MatchString(path) {
			return false
		}
	}

	return true
}

func (w *Watcher) Watch() {
	done := make(chan bool)

	go func(watcher *fsnotify.Watcher) {
		for {
			select {
			case ev := <-watcher.Event:
				w.handler(ev)
			case err := <-watcher.Error:
				log.Println("error:", err)
			}
		}
	}(w.fsWatcher)

	<-done
	w.fsWatcher.Close()
}

func (w *Watcher) addWatch(path string) {
	if err := w.fsWatcher.Watch(path); err != nil {
		log.Fatalln("watch fail: \t", path)
		return
	}
	log.Println("watch add: \t", path)
}

func (w *Watcher) removeWatch(path string) {
	w.fsWatcher.RemoveWatch(path)
	log.Println("watch reomve: \t", path)
}

func (w *Watcher) handler(ev *fsnotify.FileEvent) {
	if !w.doWatch(ev.Name) {
		return
	}

	now := time.Now()
	old := w.changeFile2Time[ev.Name]
	if now.Sub(old).Seconds() < 1 {
		return
	}
	log.Println(ev.Name)

	w.changeFile2Time[ev.Name] = now

	isDelete := false

	_, err := os.Stat(ev.Name)
	if err != nil {
		if os.IsNotExist(err) { // delete it
			isDelete = true
		} else {
			log.Println(err)
			return
		}
	}

	isDir := filepath.Ext(ev.Name) == ""

	if isDir {
		if isDelete {
			w.removeWatch(ev.Name)
		} else {
			w.addWatch(ev.Name)
		}
	}

	go w.restart()
}

func cmdString(cmd *exec.Cmd) string {
	if cmd == nil {
		return ""
	}
	return fmt.Sprint(cmd.Args)
}

// checkCmd: exec.Command(ccs[0], ccs[1:]...),
// runCmd:   exec.Command(rcs[0], rcs[1:]...),

func (w *Watcher) restart() {
	defer func() {
		w.checkCmd = nil
	}()

	if w.checkCmd != nil {
		log.Println("building...")
		return
	}

	w.checkCmd = exec.Command(w.checkCmdParams[0], w.checkCmdParams[1:]...)
	w.checkCmd.Dir = w.watchDir
	//w.checkCmd.Stderr = os.Stderr
	//w.checkCmd.Stdout = os.Stdout
	bs, err := w.checkCmd.CombinedOutput()
	log.Println(cmdString(w.checkCmd), "\n", string(bs))
	if err != nil {
		log.Println(cmdString(w.checkCmd), "fail:", err)
		return
	}
	log.Println(cmdString(w.checkCmd), "succ")

	if w.runCmd != nil && w.runCmd.Process != nil {
		log.Println("stop...")
		if err := w.runCmd.Process.Kill(); err != nil {
			log.Println(cmdString(w.runCmd), err)
			log.Println("stop fail")
		}
		log.Println("stop succ")
	}

	log.Println("start...")
	w.runCmd = exec.Command(w.runCmdParams[0], w.runCmdParams[1:]...)
	w.runCmd.Dir = w.watchDir
	//w.runCmd.Stderr = os.Stderr
	//w.runCmd.Stdout = os.Stdout

	bs, err = w.runCmd.CombinedOutput()
	log.Println(cmdString(w.runCmd), "\n", string(bs))
	if err != nil {
		log.Println(cmdString(w.runCmd), err)
	} else {
		log.Println("start succ")
	}
}
