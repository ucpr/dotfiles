let $PATH = "~/.pyenv/shims:".$PATH

"""---dein scripts---"""
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})

call dein#add('kana/vim-smartinput')
call dein#add('scrooloose/syntastic')
call dein#add('Shougo/neocomplete.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('itchyny/lightline.vim')

call dein#add('justmao945/vim-clang')
call dein#add('Shougo/neoinclude.vim')

call dein#add('nve3pd/nim.vim')

call dein#add('altercation/vim-colors-solarized')

call dein#add('davidhalter/jedi-vim', {
  \ 'autoload': {
  \ 'filetypes':['python']
  \}})

call dein#add('lambdalisue/vim-pyenv', {
  \  "depends": ["jedi-vim"], "merged": 0,"on_ft": ["python", "python3"]
  \})
call dein#add('fatih/vim-go', {
  \ 'autoload': {
  \ 'filetypes':['go']
  \}})

call dein#end()

filetype plugin indent on
syntax enable

"neocomplete
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

"jedi-vim
autocmd FileType python setlocal omnifunc=jedi#completions
autocmd FileType python setlocal completeopt-=preview
let g:jedi#force_py_version=3
let g:jedi#auto_vim_configuration = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'

"vim-clang
let g:clang_auto = 0
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_use_library = 1
let g:clang_c_completeopt   = 'menuone'
let g:clang_cpp_completeopt = 'menuone'
let g:clang_c_options = '-std=c11'
let g:clang_cpp_options = '-std=c++11 -I/usr/lib/gcc/x86_64-linux-gnu/5.4.0/include/c++'


"go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
autocmd FileType go setlocal completeopt-=preview

"nerdTree
nnoremap <silent><C-e> :NERDTreeToggle<CR> "ctrl-eで開く

"lightline
let g:lightline = {
 \ 'colorscheme': 'solarized', 
  \ 'active': {
    \   'right': [ [ 'syntastic', 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'component_expand': {
    \   'syntastic': 'SyntasticStatuslineFlag'
    \ },
    \ 'component_type': {
    \   'syntastic': 'error'
    \ }
  \ }

"""---end dein scripts---""""

"カラースキーム設定
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none

syntax on 
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
language en_US.UTF-8

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
