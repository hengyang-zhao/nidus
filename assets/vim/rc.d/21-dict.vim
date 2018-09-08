function! Lookup()
    let l:word = expand("<cword>")
    let l:tmpfile = tempname()
    call system('dict "' . word . '" > ' . tmpfile)
    execute("tabedit " . tmpfile)
endfunction

map <Leader>d :call Lookup()<CR>


