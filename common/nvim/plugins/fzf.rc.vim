"set rtp+=~/.fzf
set rtp+=/opt/homebrew/opt/fzf

nnoremap <silent> <Space>. :<C-u>FZFFileList<CR>
nnoremap <silent> <Space>, :<C-u>FZFMru<CR>
nnoremap <silent> <Space>l :<C-u>Lines<CR>
nnoremap <silent> <Space>b :<C-u>Buffers<CR>
nnoremap <silent> <Space>k :<C-u>Rg<CR>
command! FZFFileList call fzf#run({
           \ 'source': 'rg --files --hidden',
           \ 'sink': 'e',
           \ 'options': '-m --border=none',
           \ 'down': '20%'})
command! FZFMru call fzf#run({
           \ 'source': v:oldfiles,
           \ 'sink': 'e',
           \ 'options': '-m +s --border=none',
           \ 'down':  '20%'})

let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'none' } }

augroup vimrc_fzf
autocmd!
autocmd FileType fzf tnoremap <silent> <buffer> <Esc> <C-g>
autocmd FileType fzf set laststatus=0 noshowmode noruler
     \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
augroup END

function! RipgrepFzf(query, fullscreen)
   let command_fmt = 'rg --column --hiddden --line-number --no-heading --color=always --smart-case %s || true'
   let initial_command = printf(command_fmt, shellescape(a:query))
   let reload_command = printf(command_fmt, '{q}"
   let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <leader>to :FZFTabOpen<CR>
command! FZFTabOpen call s:FZFTabOpenFunc()

function! s:FZFTabOpenFunc()
    call fzf#run({
            \ 'source':  s:GetTabList(),
            \ 'sink':    function('s:TabListSink'),
            \ 'options': '-m -x +s',
            \ 'down':    '40%'})
endfunction

function! s:GetTabList()
    let s:tabList = execute('tabs')
    let s:textList = []
    for tabText  in split(s:tabList, '\n')
        let s:tabPageText = matchstr(tabText, '^Tab page')
        if !empty(s:tabPageText)
            let s:pageNum = matchstr(tabText, '[0-9]*$')
        else
            let s:textList = add(s:textList, printf('%d %s',
                \ s:pageNum,
                \ tabText,
                \   ))
        endif
    endfor
    return s:textList
endfunction

function! s:TabListSink(line)
    let parts = split(a:line, '\s')
    execute 'normal ' . parts[0] . 'gt'
endfunction

