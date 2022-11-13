vim.cmd [[
let g:vsnip_snippet_dir = '$HOME/.vim/vsnip'
autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)

"function s:trigger_completedone()
"  let info = pum#complete_info()
"  let complete_item = info.items[info.selected]
"  call vsnip_integ#on_complete_done(complete_item)
"  if vsnip#available(1)
"    return "\<Plug>(vsnip-expand-or-jump)"
"  else
"    return "\<Tab>"
"  "return "\<Ignore>"
"endfunction
"
"imap <expr> <Tab> <SID>trigger_completedone()
"smap <expr> <Tab> <SID>trigger_completedone()
" imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
" smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

imap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
smap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
imap <expr> <C-f> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-f>'
smap <expr> <C-f> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-f>'
imap <expr> <C-b> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-b>'
smap <expr> <C-b> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-b>'
let g:vsnip_filetypes = {}

autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 10000)
]]
