if &compatible
  set nocompatible               " Be iMproved
endif

set runtimepath+=/home/ucpr/.config/nvim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('/home/ucpr/.config/nvim/dein')
  call dein#begin('/home/ucpr/.config/nvim/dein')

  " call dein#add('/home/ucpr/.config/nvim/dein/repos/github.com/Shougo/dein.vim')

  let s:toml_parent_dir = '/home/ucpr/.config/nvim/toml/'
  let s:dein_toml = s:toml_parent_dir . 'dein.toml'
  let s:lazy_toml = s:toml_parent_dir . 'dein_lazy.toml'

  call dein#load_toml(s:dein_toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 0})

  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

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

set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set smartindent

inoremap <F5> <nop>
set pastetoggle=<F5>

syntax on
set background=dark
set t_Co=256
set laststatus=2

set backspace=eol,indent,start
inoremap <C-f><C-f> <ESC>

autocmd FileType python set tabstop=4 shiftwidth=4 expandtab
autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType c setl cindent
autocmd FileType cpp setl cindent
autocmd FileType go setl ts=4 sw=4 noet
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

