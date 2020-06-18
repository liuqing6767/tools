/*
one tool to compare file and got the same file,
then you can delete or rename it.
Usage:
	onlyfile
		[-root path]
		[-excludes file,file]
		[-tmp recovery box]
*/

package main

import (
	"crypto/md5"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
)

type Result struct {
	fileMap map[string]int

	repeatCount int
	fileCount   int
}

var (
	root     string
	excludes []string
	tmp      string
	result   *Result

	wg sync.WaitGroup
)

func main() {
	root_flag := flag.String("root", ".", "root of files")
	tmp_flag := flag.String("tmp", "", "place where repeat files to put, if not set, delete them")
	exculdes_flag := flag.String("excludes", "", "exculdes dir or files")

	flag.Parse()

	var err error
	tmp = *tmp_flag
	if tmp != "" {
		tmp, err = filepath.Abs(tmp)
		if err != nil {
			fmt.Println("fail: ", err)
			return
		}
	}

	root, err = filepath.Abs(*root_flag)
	if err != nil {
		fmt.Println("fail: ", err)
		return
	}

	es := strings.Split(*exculdes_flag, ",")
	for _, v := range es {
		if v == "" {
			continue
		}
		r, err := filepath.Abs(v)
		if err != nil {
			fmt.Println("fail: ", err)
			return
		}
		excludes = append(excludes, r)
	}

	begin()

	go runing()

	if err := work(); err != nil {
		fmt.Println("fail: ", err)
		return
	}

	wg.Wait()
	finish()
}

func work() error {
	result = &Result{
		fileMap: map[string]int{},
	}

	return filepath.Walk(root, walk)
}

func walk(path string, fi os.FileInfo, e error) error {
	for _, v := range excludes {
		if v == path {
			return filepath.SkipDir
		}
	}

	if fi.IsDir() {
		return nil
	}
	result.fileCount++

	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()

	md5hash := md5.New()
	_, err = io.Copy(md5hash, f)
	if err != nil {
		return err
	}

	key := string(md5hash.Sum(nil))

	count := result.fileMap[key]
	result.fileMap[key] = count + 1
	if count != 0 {
		result.repeatCount++
		wg.Add(1)
		go handleRepeatFile(path)
	}

	return nil
}

func handleRepeatFile(path string) {
	defer wg.Done()
	if tmp == "" {
		if err := os.Remove(path); err != nil {
			fmt.Println("delete: ", path, " fail")
		}
		fmt.Println("delete: ", path, " succ")
		return
	}

	newPath := strings.Replace(path, root, tmp, -1)
	if err := os.MkdirAll(filepath.Dir(newPath), 0777); err != nil {
		fmt.Println(err)
		return
	}

	if err := os.Rename(path, newPath); err != nil {
		fmt.Printf("mv: %v to %v fail\n", path, newPath)
	} else {
		fmt.Printf("mv: %v to %v succ\n", path, newPath)
	}
}

func begin() {
	fmt.Println("root: ", root)

	if len(excludes) == 0 {
		return
	}
	fmt.Println("exclude:")
	for _, v := range excludes {
		fmt.Println("\t", v)
	}
}

func runing() {
	tick := time.Tick(time.Second)
	t := 1
	for {
		select {
		case <-tick:
			fmt.Printf("time:%v secodes, \twatch:%v,\t deal:%v\n",
				t, result.fileCount, result.repeatCount)
			t++
		}
	}
}

func finish() {
	fmt.Println("finish:")
	fmt.Println("\tfile count: ", result.fileCount)
	fmt.Println("\trepeat count: ", result.repeatCount)
}
