let g:lightline = {
  \'colorscheme': 'gruvbox',
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
