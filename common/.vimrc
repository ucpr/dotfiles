" dein setting
if &compatible
  set nocompatible               " Be iMproved
endif

set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

call dein#begin('$HOME/.cache/dein')

call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

"set runtimepath^=/Users/s11591/.go/src/github.com/ucpr/denops-otesuki
"let g:denops#debug = 1
"
"call dein#add('vim-denops/denops.vim')

call dein#add('prabirshrestha/vim-lsp')
call dein#add('prabirshrestha/async.vim')
call dein#add('prabirshrestha/asyncomplete.vim')
call dein#add('prabirshrestha/asyncomplete-lsp.vim')
call dein#add('mattn/vim-lsp-settings')
call dein#add('hrsh7th/vim-vsnip')
call dein#add('hrsh7th/vim-vsnip-integ')

call dein#add('mattn/vim-goimports')
call dein#add('kyoh86/vim-go-coverage')
call dein#add('mattn/vim-goaddtags')
call dein#add('mattn/vim-goimpl')
call dein#add('mattn/vim-gomod')

call dein#add('joshdick/onedark.vim')

call dein#add('mattn/vim-sonictemplate')
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
  \    'buildFlags': ["-tags=integration,wireinject"],
  \  },
  \}

let g:sonictemplate_vim_template_dir = [
  \ '$HOME/.vim/template'
\]

let g:vsnip_snippet_dir = '$HOME/.vim/vsnip'
imap <expr> <C-j> vsnip#expandable() ? "<Plug>(vsnip-expand)" : "<C-j>"
" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

set completeopt+=menuone

autocmd BufWritePre *.go call execute(['LspCodeActionSync source.organizeImports', 'LspDocumentFormatSync'])

colorscheme onedark
set termguicolors

nmap s <Plug>(easymotion-overwin-f2)

" spelling check
let g:enable_spelunker_vim = 1
let g:spelunlker_check_type = 2

inoremap <C-l> <C-r>=lexima#insmode#leave(1, '<LT>C-G>U<LT>RIGHT>')<CR>

" setting for goimports
let g:goimports = 1
let g:goimports_show_loclist = 0
let g:goimports_local = 'github.com/ucpr'
" ---

" cursor上のgo testを実行するcommand (neovim依存なので修正しないと使えない)
"autocmd vimrc FileType go nnoremap <silent> gt :<C-u>silent call <SID>go_test_function()<CR>
"command GoTestOnTheCursor :call s:go_test_function()
"function! s:go_test_function() abort
"    let test_info = json_decode(system(printf('go-test-name -pos %s -file %s', s:cursor_byte_offset(), @%)))
"
"    for b in nvim_list_bufs()
"        if bufname(b) ==# 'vim-go-test-func'
"            execute printf('bwipe! %s', b)
"        endif
"    endfor
"
"    let dir = expand('%:p:h')
"
"    if len(test_info.sub_test_names) > 0
"        let cmd = printf("go test -coverprofile='/tmp/go-coverage.out' -count=1 -v -race -run='^%s$'/'^%s$' $(go list %s)", test_info.test_func_name, test_info.sub_test_names[0], dir)
"    else
"        let cmd = printf("go test -coverprofile='/tmp/go-coverage.out' -count=1 -v -race -run='^%s$' $(go list %s)", test_info.test_func_name, dir)
"    endif
"
"    let split = s:split_type()
"    execut printf('%s gotest', split)
"
"    if split ==# 'split'
"        execute(printf('resize %s', floor(&lines * 0.3)))
"    endif
"
"    call termopen(cmd)
"    setlocal bufhidden=delete
"    setlocal noswapfile
"    setlocal nobuflisted
"    file vim-go-test-func
"    wincmd p
"endfunction
"
"function! s:cursor_byte_offset() abort
"    return line2byte(line('.')) + (col('.') - 2)
"endfunction

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