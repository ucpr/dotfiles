let $PATH = "~/.pyenv/shims:".$PATH

"""---dein scripts---"""
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

let s:dein_dir = '~/.vim/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

let s:toml_dir = s:dein_dir . '/../toml'

let &runtimepath = s:dein_repo_dir . ',' . &runtimepath

let s:toml_file = s:toml_dir . '/dein.toml'
let s:lazy_file = s:toml_dir . '/dein_lazy.toml'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#load_toml(s:lazy_file, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

"カラースキーム設定
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none

syntax on 
filetype plugin indent on
set background=dark
colorscheme solarized

"画面表示設定
set number
set cursorline
set cursorcolumn
set showmatch

"ファイル処理設定
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
set clipboard=unnamed,autoselect

"文字コード設定
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jpset 
set fencs=utf-8,iso-2022-jp,enc-jp,cp932
"language en_US.UTF-8

"タブとかの設定
set expandtab
set tabstop=2
set shiftwidth=2

"インデント設定
inoremap <F5> <nop>
set pastetoggle=<F5>

"ステータスライン設定
set t_Co=256
set laststatus=2

"キーマッピング
imap <C-j> <Down>
imap <C-k> <Esc><Up> i
imap <C-h> <Left>
imap <C-l> <Right>
"imap <C-x> <Del>
"imap <C-i> <BS>
imap <C-u> <Esc>:undo<CR> i
imap <C-d><C-d> <Esc>dd i

"いろいろ
set backspace=eol,indent,start
inoremap <C-f><C-f> <ESC>

"自動コメント挿入させない
augroup auto_comment_off
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=r
  autocmd BufEnter * setlocal formatoptions-=o
augroup END

"Python
autocmd Filetype python setl autoindent
autocmd FileType python setlocal completeopt-=preview
autocmd Filetype python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,pass,

"C & CPP
autocmd FileType c setl cindent
autocmd FileType cpp setl cindent
"autocmd BufNewFile *.c 0r ~/.vim/template/c.c
autocmd BufNewFile *.cpp 0r ~/.vim/templates/cpp.cpp

"augroup cpp-path
"    autocmd!
"    autocmd FileType cpp setlocal path=/usr/include/c++/5.4.0
"augroup END

"Go
autocmd FileType go setl ts=4 sw=4 sts=4 noet

"HTML & xml
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd FileType html inoremap <buffer> </ </<C-x><C-o>
augroup END
