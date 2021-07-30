let g:lightline = {
  \'colorscheme': 'onedark',
  \'active': {
  \  'left': [
  \    ['mode', 'paste'],
  \    ['fugitive', 'readonly', 'filename', 'modified'],
  \  ],
  \  'right': [
  \    ['lineinfo', 'ale'],
  \    ['percent'],
  \    ['fileformat', 'fileencoding', 'filetype']
  \  ]
  \},
  \'component': {
  \   'readonly': '%{&filetype=="help"?"":&readonly?"✖︎":""}',
  \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
  \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
  \ },
  \'component_visible_condition': {
  \   'readonly': '(&filetype!="help"&& &readonly)',
  \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
  \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
  \ },
  \'component_function': {
  \  'ale': 'ALEGetStatusLine'
  \}
\ }

let g:lightline.tab = {
  \ 'active': [ 'tabnum', 'filename', 'modified' ],
  \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
  \ }

let g:lightline.tab_component_function = {
  \ 'filename': 'LightlineTabFilename',
  \ 'modified': 'lightline#tab#modified',
  \ 'readonly': 'lightline#tab#readonly',
  \ 'tabnum': 'lightline#tab#tabnum'
 \}

function! LightlineTabFilename(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let _ = pathshorten(expand('#'.buflist[winnr - 1].':f'))
  return _ !=# '' ? _ : '[No Name]'
endfunction
