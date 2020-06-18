package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
)

type Config struct {
	WatchDir string `json:"watch_dir"`

	Excludes []string `json:"excludes"`

	CheckCmd string `json:"check_cmd"`
	RunCmd   string `json:"run_cmd"`
}

func NewConfig(path string) *Config {
	bs, err := ioutil.ReadFile(path)
	if err != nil {
		log.Fatalln("load config fail:", err)
	}

	config := &Config{}
	if err := json.Unmarshal(bs, config); err != nil {
		log.Fatalln("load config fail:", err)
	}

	if config.WatchDir == "" {
		log.Fatalln("load config fail: watch_dir can't be empty")
	}

	if config.RunCmd == "" {
		log.Fatalln("load config fail: run_cmd can't be empty")
	}

	return config
}
