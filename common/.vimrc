" dein setting
if &compatible
  set nocompatible               " Be iMproved
endif

set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

call dein#begin('$HOME/.cache/dein')

call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#add('prabirshrestha/vim-lsp')
call dein#add('prabirshrestha/async.vim')
call dein#add('prabirshrestha/asyncomplete.vim')
call dein#add('prabirshrestha/asyncomplete-lsp.vim')
call dein#add('mattn/vim-lsp-settings')
"call dein#add('SirVer/ultisnips')
"call dein#add('thomasfaingnaert/vim-lsp-snippets')
"call dein#add('thomasfaingnaert/vim-lsp-ultisnips')

call dein#add('mattn/vim-goimports')
call dein#add('kyoh86/vim-go-coverage')
call dein#add('mattn/vim-goaddtags')
call dein#add('mattn/vim-goimpl')
call dein#add('mattn/vim-gomod')

call dein#add('joshdick/onedark.vim')

call dein#add('Shougo/context_filetype.vim')
call dein#add('ntpeters/vim-better-whitespace')
call dein#add('simeji/winresizer')
call dein#add('easymotion/vim-easymotion')
call dein#add('Shougo/echodoc.vim')
call dein#add('cohama/lexima.vim')
call dein#add('markonm/traces.vim')
call dein#add('kamykn/spelunker.vim')

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" ---
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=no
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_diagnostics_enabled = 1
    let g:lsp_diagnostics_signs_enabled = 1
    let g:lsp_document_highlight_enabled = 1
    let g:lsp_document_code_action_signs_enabled = 1

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction
    inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ asyncomplete#force_refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_settings = {}
let g:lsp_settings['gopls'] = {
  \  'workspace_config': {
  \    'usePlaceholders': v:true,
  \    'analyses': {
  \      'fillstruct': v:true,
  \    },
  \  },
  \  'initialization_options': {
  \    'usePlaceholders': v:true,
  \    'analyses': {
  \      'fillstruct': v:true,
  \    },
  \  },
  \}

" For snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

set completeopt+=menuone

autocmd BufWritePre *.go call execute(['LspCodeActionSync source.organizeImports', 'LspDocumentFormatSync'])

colorscheme onedark
set termguicolors

nmap s <Plug>(easymotion-overwin-f2)

let g:enable_spelunker_vim = 1
let g:spelunlker_check_type = 2

inoremap <C-l> <C-r>=lexima#insmode#leave(1, '<LT>C-G>U<LT>RIGHT>')<CR>

let g:goimports = 1
let g:goimports_show_loclist = 0
" ---

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
set autochdir

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
nnoremap <silent> <C-l> :tabn<CR>
nnoremap <silent> <C-h> :tabp<CR>
nnoremap <C-t> :tabnew<CR>

" terminal mode mapping
tnoremap <C-@> <C-\><C-n>

" ctrl + qでq!を強制実行
nnoremap <C-q> :q!<CR>
" ctrl + qでterminalでexitして抜ける
tnoremap <C-q> exit<CR>
"tnoremap <C-q> <C-\><C-n>:q<CR>
" ctrl + wで保存して終了
" noremap <C-w> :wq<CR>
