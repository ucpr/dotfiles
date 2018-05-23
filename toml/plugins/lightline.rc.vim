let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

let g:lightline = {
  \'colorscheme': 'solarized',
  \'active': {
  \  'left': [
  \    ['mode', 'paste'],
  \    ['fugitive', 'gitgutter' , 'readonly', 'filename', 'modified'],
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
  \  'ale': 'ALEGetStatusLine',
  \   'gitgutter': 'MyGitGutter'
  \}
\ }

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction
