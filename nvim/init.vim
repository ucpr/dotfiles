" {{{dein.vim
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

  call dein#load_toml('~/.config/nvim/toml/dein.toml',{'lazy' : 0})
  call dein#load_toml('~/.config/nvim/toml/dein_lazy.toml',{'lazy' : 1})

call dein#end()
" }}}

" {{{color
"autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
"set background=dark
colorscheme onedark
syntax on
" }}}

" {{{setting
set number
set cursorline
set cursorcolumn
set showmatch

set noswapfile
set confirm
set title
set hidden
set nobackup
set writebackup
set foldmethod=marker
"set paste
set display=uhex
set clipboard&

set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jpset 
set fencs=utf-8,iso-2022-jp,enc-jp,cp932
language en_US.UTF-8

set tabstop=2
set shiftwidth=2
set expandtab

inoremap <F5> <nop>
set pastetoggle=<F5>

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
" }}}
