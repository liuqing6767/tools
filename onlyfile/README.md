> onlyfile: one tool to compare file and choose the same files.

#### Get it
go get github.com/liuximu/gotool/onlyfile
go build github.com/liuximu/gotool/onlyfile


#### Usage

```
  -excludes string
        exculdes dir or files
  -root string
        root of files (default ".")
  -tmp string
        place where repeat files to put, if not set, delete them
```


#### Example
```
artist:onlyfile liuqing18$ onlyfile -root ~/Documents/Ebook -tmp ~/Desktop/tmp
root:  /Users/liuqing18/Documents/Ebook
time:1 secodes, 	watch:98,	 deal:0
time:2 secodes, 	watch:157,	 deal:0
time:3 secodes, 	watch:186,	 deal:0
time:4 secodes, 	watch:194,	 deal:0
mv: /Users/liuqing18/Documents/Ebook/fundation/.DS_Store to /Users/liuqing18/Desktop/tmp/fundation/.DS_Store succ
time:5 secodes, 	watch:211,	 deal:1
time:6 secodes, 	watch:227,	 deal:1
time:7 secodes, 	watch:235,	 deal:1
...
time:16 secodes, 	watch:601,	 deal:1
time:17 secodes, 	watch:608,	 deal:1
time:18 secodes, 	watch:621,	 deal:1
time:19 secodes, 	watch:802,	 deal:1
mv: /Users/liuqing18/Documents/Ebook/linux/.DS_Store to /Users/liuqing18/Desktop/tmp/linux/.DS_Store succ
time:20 secodes, 	watch:933,	 deal:2
time:21 secodes, 	watch:941,	 deal:2
mv: /Users/liuqing18/Documents/Ebook/manual/vim/vim_进阶.pdf to /Users/liuqing18/Desktop/tmp/manual/vim/vim_进阶.pdf succ
mv: /Users/liuqing18/Documents/Ebook/net/.DS_Store to /Users/liuqing18/Desktop/tmp/net/.DS_Store succ
time:22 secodes, 	watch:1004,	 deal:4
...
time:37 secodes, 	watch:1390,	 deal:6
finish:
	file count:  1400
	repeat count:  6
```
