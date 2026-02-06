function! myutils#splitterm(...) abort
  let s:wnr = bufwinnr('term://')
  if s:wnr == -1
    vnew
  else
    execute s:wnr . 'wincmd w'
    enew
  end
  call jobstart(a:0 ? a:000 : [&shell], {'term': v:true})
  setlocal nobuflisted
  wincmd p
endfunction
