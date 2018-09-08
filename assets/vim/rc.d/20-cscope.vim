" Cscope conf. Modified version of Jason Duell jduell@alumni.princeton.edu
if has("cscope")

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set cscopetagorder=0

    if exists("&cscoperelative")
        set cscoperelative
    endif

    if $CSCOPE_DB != ""
        for csdb in split($CSCOPE_DB, ":")
            if filereadable(csdb)
                execute("cs add " . csdb)
            endif
        endfor
    endif

    nmap <Leader><Leader>S :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>G :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>C :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>T :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>E :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>F :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <Leader><Leader>I :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <Leader><Leader>D :cs find d <C-R>=expand("<cword>")<CR><CR>

    nmap <Leader><Leader>sv :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>gv :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>cv :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>tv :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>ev :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>fv :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <Leader><Leader>iv :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <Leader><Leader>dv :vert scs find d <C-R>=expand("<cword>")<CR><CR>

    nmap <Leader><Leader>sh :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>gh :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>ch :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>th :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>eh :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>fh :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <Leader><Leader>ih :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <Leader><Leader>dh :scs find d <C-R>=expand("<cword>")<CR><CR>

    nmap <Leader><Leader>st :tab scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>gt :tab scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>ct :tab scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>tt :tab scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>et :tab scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <Leader><Leader>ft :tab scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <Leader><Leader>it :tab scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <Leader><Leader>dt :tab scs find d <C-R>=expand("<cword>")<CR><CR>

endif " End of cscope conf

