if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('$HOME/.config/nvim/dein')

" Let dein manage dein
" Required:
call dein#add('$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim')

call dein#add('lewis6991/impatient.nvim')
let s:toml_dir = '$HOME/.config/nvim/tomls'
call dein#load_toml( s:toml_dir . '/dein.toml', {} )
call dein#load_toml( s:toml_dir . '/dein_lazy.toml', {'lazy': 0} )

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

set rtp+=/usr/local/opt/fzf

" general setting
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
set hlsearch
set wildmenu

set clipboard+=unnamed
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jpset
set fencs=utf-8,iso-2022-jp,enc-jp,cp932
language en_US.UTF-8

set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set smartindent
"set autochdir

inoremap <F5> <nop>
set pastetoggle=<F5>

syntax on
set background=dark
set t_Co=256
set laststatus=2
set showtabline=2

set statusline=%f\ %y%m\ %r%h%w%=[%{&fileencoding!=''?&fileencoding:&encoding},%{&ff}]\ [Pos\ %02l,%02c]\ [%p%%/%L]

set backspace=eol,indent,start
inoremap <C-f><C-f> <ESC>

filetype plugin on
let g:netrw_liststyle=1
"let g:netrw_banner=0
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_preview=1

autocmd FileType python set tabstop=4 shiftwidth=4 expandtab
autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType c setl cindent
autocmd FileType cpp setl cindent
"autocmd BufNewFile *.c 0r ~/.vim/template/c.c
"autocmd BufNewFile *.cpp 0r ~/.vim/templates/cpp.cpp
autocmd FileType go setl ts=4 sw=4 noet
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

" move buffer
nnoremap <silent> , :bprev<CR>
nnoremap <silent> . :bnext<CR>
nnoremap bd :bd <CR>

" move tab
nnoremap <silent> tl :tabn<CR>
nnoremap <silent> th :tabp<CR>
"nnoremap <silent> <Tab> :tabn<CR>
nnoremap <C-t> :tabnew<CR>

" move window
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" terminal mode mapping
tnoremap <C-@> <C-\><C-n>

" ctrl + qでq!を強制実行
nnoremap <C-q> :q!<CR>
" ctrl + qでterminalでexitして抜ける
tnoremap <C-q> exit<CR>
"tnoremap <C-q> <C-\><C-n>:q<CR>
" ctrl + wで保存して終了
" noremap <C-w> :wq<CR>

" split terminal
command Sterm :split | resize 20 | term
command Vterm :vsplit | term
