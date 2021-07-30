set updatetime=100
set signcolumn=yes

function! s:show_docmentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader> rn <Plug>(coc-rename)
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gvd :vsp<CR><Plug>(coc-definition)
nmap <silent> gsd :sp<CR><Plug>(coc-definition)

nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)

nmap <silent> gr <Plug>(coc-references)
nmap <silent> gdr :vsp<CR><Plug>(coc-references)
nmap <silent> gsr :sp<CR><Plug>(coc-references)

" "nnoremap <silent> K :call CocAction('doHover')<CR>
nnoremap <silent> K :call <SID>show_docmentation()<CR>
nnoremap <silent> F :call CocAction('format')<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
set completeopt=menuone,noinsert
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"

""" coc-snipets
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'

imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
