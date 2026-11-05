if exists('g:loaded_largefile') || &cp || v:version < 700
  finish
endif
let g:loaded_largefile = 1

fu! s:ProcessCommandList(alist)
  for l:opt_set in a:alist
    exe l:opt_set
  endfor
endfu

" file is large over 2mb; small under 24kb
let g:LargeFileSize = 1024 * 1024 * 2
let g:MediumFileSize = 1024 * 24

let s:LargeFileMsg = 'The file is larger than '
      \. (g:LargeFileSize / 1048576)
      \. ' MB. Options are changed (see g:LargeFileSizeOpen).'

let g:SmallFileActionsOpen=[
      \ 'setlocal eventignore-=Filetype',
      \]
let g:SmallFileActionsEnter=[
      \]
let g:MediumFileActionsOpen=[
      \ 'setlocal eventignore-=Filetype',
      \ 'setlocal noincsearch',
      \ 'setlocal foldmethod=manual',
      \ 'setlocal nofoldenable',
      \ 'setlocal bufhidden=unload',
      \]
      " \ 'setlocal undolevels=64',
let g:MediumFileActionsEnter=[
      \]
let g:LargeFileActionsOpen=get(g:, 'LargeFileActionsOpen', [
      \ 'setlocal eventignore+=Filetype',
      \ 'setlocal bufhidden=unload',
      \ 'setlocal buftype=nowrite',
      \ 'setlocal noincsearch',
      \ 'setlocal foldmethod=manual',
      \ 'setlocal nofoldenable',
      \ 'setlocal undolevels=-1',
      \])
if get(g:, 'LargeFileOpenShowMessage', 0)
    call add(g:LargeFileActionsOpen, 
      \ 'au VimEnter * echo "'.s:LargeFileMsg.'"')
endif
let g:LargeFileActionsEnter=[
      \]

fu! s:LargeFileSupport(...)
  if len(a:000)
    let b:filesize=a:000[0]
    let l:event='Open'
  elseif exists('b:filesize')
    let l:event='Enter'
  else
    return
  endif
  let l:size = ((b:filesize > g:LargeFileSize
        \ || b:filesize == -2) ? 'Large' :
        \ (b:filesize > g:MediumFileSize ? 'Medium' : 'Small'))
  exe 'call s:ProcessCommandList(g:'.l:size.'FileActions'.l:event.')'
endfu

augroup LargeFile 
  autocmd BufReadPre * silent call s:LargeFileSupport(getfsize(expand("<afile>")))
  autocmd BufWinEnter * silent call s:LargeFileSupport()
augroup END

