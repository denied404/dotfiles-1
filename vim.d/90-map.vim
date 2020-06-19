map Q <nop>
map K <nop>

imap <C-F> tx<TAB>
vmap <C-O> <TAB>oo<TAB>

imap <C-D> context.

nnoremap <C-E><C-E> :cd %:p:h<CR>
nnoremap <C-E><C-R> :call _cd_root()<CR>

nnoremap <Leader>o o<ESC>
nnoremap <Leader>O O<ESC>

nnoremap X S<ESC>
vnoremap $ g_

nnoremap > >>
nnoremap < <<

nnoremap <Leader>` :tabedit ~/.vimrc<CR>

vnoremap <silent> > >gv
vnoremap <silent> < <gv

inoremap jk <ESC>

nnoremap g< '<
nnoremap g> '>

nnoremap g. '>
nnoremap g, '<

nnoremap <Leader>vs :vsp<CR>

nnoremap <Leader>e :e!<CR>

nnoremap <silent> ,q <ESC>:q<CR>
nnoremap <silent> <C-S> :w!<CR>
"
nnoremap <silent> <Leader>n <ESC>:call _close_it()<CR>
nnoremap <Leader>q <ESC>:qa!<CR>

nnoremap <Leader>d V"_d<Esc>
vnoremap <Leader>d "_d

vnoremap <Leader>s y<ESC>:%s/<C-r>"/

vnoremap <Leader><C-y> "kyy
vnoremap <Leader><C-d> "kdgvd
vnoremap <Leader><C-x> "kygvx
vnoremap <Leader><C-p> "kp
vnoremap <Leader><C-P> "kP
vnoremap <Leader><C-s> "ks

nnoremap <Leader><C-x> v"kx
nnoremap <Leader><C-p> "kp
nnoremap <Leader><C-P> "kP

nnoremap <Leader>] :tnext<CR>

imap <C-A> <C-O>A

nmap <C-_> <C-W>=
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

imap <C-J> <nop>
vmap <C-J> <nop>

imap <C-E> <C-R>=strpart(search("[)}\"'`\\]]", "c"), -1, 0)<CR><Right>

inoremap <C-H> <C-O>o

imap <C-U> <ESC>ua

imap <c-j> <nop>

nnoremap <c-b> :source ~/.vimrc<CR>:echom "vimrc sourced"<cr>

nnoremap Q qq
nnoremap @@ @q

tnoremap <Esc> <C-\><C-n>

nmap K :s///g<CR><C-O>i

let @k="^f=i:"
let @j="^t=x"

nmap @t :call _tab_space()<CR>

imap <c-y> <C-O>:call CocActionAsync('showSignatureHelp')<CR>
nmap <c-y> :call CocActionAsync('showSignatureHelp')<CR>
cmap <C-F> <NOP>

vmap <Leader> S<Space><Space>

nmap Y yy

map <leader>y "0y
map <leader>p "0p

nnoremap <Leader>w :e <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>
nnoremap <Leader>x :vsp <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>
nnoremap <Leader>t :sp <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>

cnoremap <C-E> <C-\>e_dir_up()<CR>

nnoremap <silent> <Leader>/ :noh<CR>

nnoremap <Leader>g :call _get_github_link()<CR>

nnoremap <Leader><Leader>r :noautocmd Rename<Space>
nnoremap <Leader><Leader>x :call _delete_file()<CR>


nnoremap M :%s/\C\V<C-R>=expand('<cword>')<CR>/
nnoremap H :%s/\v
vnoremap H :s/\v
nmap L VH

nmap ,d :call _cprev()<CR>
nmap ,f :call _cnext()<CR>

nnoremap <leader>sh :SidewaysLeft<cr>
nnoremap <leader>sl :SidewaysRight<cr>
nnoremap <leader>h :SidewaysJumpLeft<cr>
nnoremap <leader>l :SidewaysJumpRight<cr>

nnoremap <silent> <Leader><Leader>j :call DelEmptyLineBelow()<CR>
nnoremap <silent> <Leader><Leader>k :call DelEmptyLineAbove()<CR>
nnoremap <silent> <Leader>j :call AddEmptyLineBelow()<CR>
nnoremap <silent> <Leader>k :call AddEmptyLineAbove()<CR>

nmap <leader>m :Move<space>

nmap <leader>s :call _sidesearch()<CR>
nmap <leader>a :SideSearch<Space>
