highlight ColorColumn ctermbg=DarkGray
highlight CursorLine ctermbg=None cterm=None
set cursorline

if !exists("g:colorcolumn_in_edit")
    let g:colorcolumn_in_edit = "78,80,".join(range(100, 120), ",")
endif

function! EnterInsertModeHighlight()
    let &colorcolumn = g:colorcolumn_in_edit
    highlight CursorLineNr cterm=Bold ctermfg=White ctermbg=Magenta
endfunction

function! EnterNormalModeHighlight()
    let &colorcolumn = ""
    highlight CursorLineNr cterm=Bold ctermfg=Yellow ctermbg=DarkGray
endfunction

autocmd InsertEnter * call EnterInsertModeHighlight()
autocmd InsertLeave * call EnterNormalModeHighlight()

call EnterNormalModeHighlight()

if &term =~ "xterm" || &term =~ "putty" || &term =~ "tmux"
    set t_ZH=[3m
    set t_ZR=[23m
    highlight Comment cterm=Italic
endif

" Mangenta background for bad spells
highlight clear SpellBad
highlight SpellBad ctermbg=magenta ctermfg=white

" Highlight tabs and trailing spaces
highlight TrailingWhiteChars ctermbg=darkgray
highlight HardTabs ctermbg=darkblue
call matchadd('TrailingWhiteChars', "[\x0d \t]\\+$", 10)
call matchadd('HardTabs', "\t", 9)

" To remove these highlights:
" highlight clear TrailingWhiteChars
" highlight clear HardTabs

let g:loaded_matchparen = 0
