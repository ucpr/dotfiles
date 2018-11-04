" dein {{{
let s:dein_dir = expand('/home/nve3pd/.config/nvim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:toml_dir = s:dein_dir . '/../toml'

if !isdirectory(s:dein_repo_dir)
  echo 'install dein.vim'
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

set runtimepath^=s:dein_repo_dir

let &runtimepath = s:dein_repo_dir . ',' . &runtimepath

let s:toml_file = s:toml_dir . '/dein.toml'
let s:lazy_file = s:toml_dir . '/dein_lazy.toml'
let s:theme_file = s:toml_dir . '/theme.toml'
let s:syntax_file = s:toml_dir . '/syntax.toml'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:theme_file, {'lazy': 0})
  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#load_toml(s:syntax_file, {'lazy': 0})
  call dein#load_toml(s:lazy_file, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

"}}}

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

set backspace=eol,indent,start
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
"noremap <Up> <Nop>
"noremap <Down> <Nop>
"noremap <Left> <Nop>
"noremap <Right> <Nop>
"inoremap <Up> <Nop>
"inoremap <Down> <Nop>
"inoremap <Left> <Nop>
"inoremap <Right> <Nop>

syntax on
set t_Co=256
set laststatus=2
  autocmd ColorScheme * highlight Normal ctermbg=none
  autocmd ColorScheme * highlight LineNr ctermbg=none
  set background=dark

filetype on
filetype plugin indent on
autocmd FileType python set tabstop=4 shiftwidth=4
autocmd FileType python set cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType java set softtabstop=4 tabstop=4 shiftwidth=4
autocmd FileType c,cpp set cindent cinoptions+=:0,g0
autocmd FileType go set tabstop=4 shiftwidth=4 noexpandtab
autocmd FileType d set softtabstop=2 tabstop=2 shiftwidth=2 cindent cinoptions+=:0,g0
autocmd Filetype html setlocal indentexpr=""
