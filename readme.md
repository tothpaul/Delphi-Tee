# Delphi tee

just a few Delphi lines to write a "[tee](https://en.wikipedia.org/wiki/Tee_%28command%29)" command.
```
  echo hello | tee hello.txt
```
or
```
  ConsoleProgram.exe | tee ConsoleProgram.log
```
This display the output on screen and log it into the provided filename

version 2:
- supports multiple files
- append is optional
- help is provided (-h or /?)
```
Delphi Tee (c)2022 Paul TOTH <contact@execute.fr>
copy standard input to each file, and also to standard output

tee [-a] filename [filename...]

  -a    append to the given files instead of overwriting them
```


Made with Delphi Alexandria 11.2

(select Project/Show Source, to view the source)