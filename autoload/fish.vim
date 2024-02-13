function! fish#Format()
  if mode() =~# '\v^%(i|R)$'
    return 1
  else
    let l:command = v:lnum.','.(v:lnum+v:count-1).'!fish_indent'
    execute l:command
  endif
endfunction
