if has("mouse")
    set mouse=a
endif

set number
set nowrap

set tabstop=4
set shiftwidth=4
set shiftround
set expandtab

set autoindent

set nobackup
set showmatch
set formatoptions+=mM

set shell=/bin/sh

set swapfile
set directory=$HOME/.vim/tmp/swap

if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" vim: set ft=vim:
