# vim largefile : performance options for large files

On BufReadPre, given the filesize (small < 24 KB, medium, large > 2 MB),
apply performance options (disable syntax events, folds, incsearch,
undo...) so huge files keep opening.

```vim
let g:LargeFileSize = 1024 * 1024 * 4   " customize the 'large' threshold
let g:LargeFileOpenShowMessage = 1
```

# Installation
```sh
mkdir -p ~/.vim/pack/ui/start
cp -r largefile ~/.vim/pack/ui/start/
```

License GPLv3.
