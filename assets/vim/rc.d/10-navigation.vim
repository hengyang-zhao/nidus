nmap <C-p> :tabprevious<CR>
nmap <C-n> :tabnext<CR>

nmap <Leader>x :close<CR>

nmap <Leader>sd :%s/[ \t\x0d]\+$//g<CR>

nmap <Leader>t~ :tabedit ~/<CR>
nmap <Leader>t. :tabedit .<CR>
nmap <Leader>tn :tabedit<CR>
nmap <Leader>tt :tabedit %<CR>
nmap <Leader>to :tabonly<CR>

nmap <Leader>h~ :split ~/<CR>
nmap <Leader>h. :split .<CR>
nmap <Leader>hh :split<CR>

nmap <Leader>v~ :vsplit ~/<CR>
nmap <Leader>v. :vsplit .<CR>
nmap <Leader>vv :vsplit<CR>

nmap <C-h> zh
nmap <C-L> zl

nmap <Up> 3<C-y>
nmap <Down> 3<C-e>
nmap <Left> 4zh
nmap <Right> 4zl

imap <C-f> <C-o>l
imap <C-b> <C-o>h

