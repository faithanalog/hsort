# hsort

sort haskell-style lists like this:

```
      [ "app-arch/pixz"
      , "app-arch/zip"
      , "app-backup/borgbackup"
      , "app-editors/nano"
      , "app-editors/neovim"
      ]
```

Sorts by the actual element, keeps brackets / commas in the right place so the
list continues to be a syntactically valid list, preserves indentation. Sorting
is lexical. There are no command line arguments right now.

Takes the list on stdin and prints the sorted list on stdout.

This is intended for use with vim-like workflows. For example, select the lines
you want to sort in line-visual-mode (`V`), then use `!hsort<ENTER>`.

hsort will probably product nonsensical results if you put in something that
isn't a prefix-delimited list.