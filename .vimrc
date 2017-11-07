" {{{dein.vim
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#load_toml('~/.vim/toml/dein.toml',{'lazy' : 0})
call dein#load_toml('~/.vim/toml/dein_lazy.toml',{'lazy' : 1})

call dein#end()
" }}}

" {{{ setting
set number
set cursorline
set cursorcolumn
set showmatch
set confirm
set title
set hidden
set writebackup
set foldmethod=marker
set display=uhex
set list
set showmatch
set matchpairs& matchpairs+=<:>
set clipboard&
set listchars=tab:»-,eol:¬,extends:»,precedes:«,nbsp:%
set nocompatible
set writebackup
set infercase
set autoread
set nowrap

set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jpset 
set fencs=utf-8,iso-2022-jp,enc-jp,cp932
language en_US.UTF-8

set tabstop=2 "タブ文字幅
set shiftwidth=2 "インデント幅
set expandtab
set smarttab
set smartindent

inoremap <F5> <nop>
set pastetoggle=<F5>

syntax on
set t_Co=256
set laststatus=2

set backspace=eol,indent,start
inoremap <C-f><C-f> <ESC>

autocmd FileType python set tabstop=4 shiftwidth=4 expandtab
autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType c setl cindent
autocmd FileType cpp setl cindent
"autocmd BufNewFile *.c 0r ~/.vim/template/c.c
"autocmd BufNewFile *.cpp 0r ~/.vim/templates/cpp.cpp
autocmd FileType go setl ts=4 sw=4 sts=4 noet
" }}}
