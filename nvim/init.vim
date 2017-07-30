let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'

"dein Scripts---{{{
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/nve3pd/.config/nvim/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/nve3pd/.config/nvim')
  call dein#begin('/home/nve3pd/.config/nvim')

  let s:toml = '~/.config/nvim/dein/dein.toml'
  let s:toml_lazy = '~/.config/nvim/dein/dein_lazy.toml'

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:toml_lazy, {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif
"}}}End dein Scripts---

set number
set title
set cursorline
set cursorcolumn
set clipboard=unnamed
set foldmethod=marker
set tabstop=2
set shiftwidth=2
set expandtab
set cindent

set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set fencs=utf-8,iso-2022-jp,enc-jp,cp932

syntax on
set background=dark
colorscheme solarized
set t_Co=256
set laststatus=2

inoremap <C-j> <Esc>

language en_US.UTF-8
