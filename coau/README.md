> COAU: coding and auto do something。

this tool can watch file change than do something auto。


one example for golang coding:
```
{
    "watch_dir": "test/",
    "excludes": ["main", "test/b", ".swp$", "~$", ".swx$"],
    "check_cmd" : "go build -o main main.go",
    "run_cmd" : "./main"
}
```


### How to use it
- get the tool
- edit coau.json
    - watch_dir is the path to excute check_cmd and run_cmd
    - check_cmd can be empty
- run this tool
