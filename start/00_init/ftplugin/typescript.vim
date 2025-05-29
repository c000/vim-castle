function! s:enable_deno() abort
  call coc#config('deno.enable', v:true)
  call coc#config('tsserver.enable', v:false)
  call coc#config('prettier.enable', v:false)
  call timer_start(0, { -> execute('silent! CocRestart') })
endfunction

function! s:enable_tsserver() abort
  call coc#config('deno.enable', v:false)
  call coc#config('tsserver.enable', v:true)
  call coc#config('prettier.enable', v:true)
  call timer_start(0, { -> execute('silent! CocRestart') })
endfunction

command! CocTypescriptOnDeno call s:enable_deno()
command! CocTypescriptOnTsserver call s:enable_tsserver()
