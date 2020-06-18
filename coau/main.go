package main

import (
	"flag"
	"log"
)

func main() {

	config_flag := flag.String("config", "coau.json", "config file")
	debug_flag := flag.Bool("debug", false, "debug mode")
	flag.Parse()

	if *debug_flag {
		log.SetFlags(log.Ltime | log.Lshortfile)
	} else {
		log.SetFlags(log.Ltime)
	}
	config := NewConfig(*config_flag)

	watcher := NewWatcher(config)

	watcher.Watch()
}
