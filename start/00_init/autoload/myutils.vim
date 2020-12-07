function! myutils#splitterm(...) abort
  let s:wnr = bufwinnr('term://')
  if s:wnr == -1
    vnew
  else
    execute s:wnr . 'wincmd w'
    enew
  end
  call termopen(a:000)
  setlocal nobuflisted
  wincmd p
endfunction
