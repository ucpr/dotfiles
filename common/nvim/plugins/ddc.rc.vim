call ddc#custom#patch_global('sources', [
    \ 'around',
    \ 'file',
    \ 'vsnip',
    \ 'nvim-lsp'
    \ ])
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
    \   'matchers': ['matcher_head'],
    \   'sorters': ['sorter_rank'],
    \   'converters': ['converter_remove_overlap'],
    \ },
    \ 'around': {'mark': 'Around'},
    \ 'file': {
    \   'mark': 'file',
    \   'isVolatile': v:true,
    \   'forceCompletionPattern': '\S/\S*',
    \ },
    \ 'vsnip': {
    \   'mark': 'vsnip',
    \   'minAutoCompleteLength': 1,
    \ },
    \ 'nvim-lsp': {
    \   'mark': 'LSP',
    \   'forceCompletionPattern': '\.\w*|:\w*|->\w*',
    \ },
    \ })

 call ddc#custom#patch_global('sourceParams', {
    \ 'around': {'maxSize': 500},
    \ })

 " Use Customized labels
 call ddc#custom#patch_global('sourceParams', {
    \ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
    \ })

" pum.vim setting
call ddc#custom#patch_global('completionMenu', 'pum.vim')
inoremap <silent><expr> <TAB>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#manual_complete()
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>

autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)

call ddc#enable()
