set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

let g:mapleader="\<Space>"
let mapleader=g:mapleader

" Definitions of autocmd groups.
augroup filetype_php
    au!
augroup end

augroup filetype_go
    au!
augroup end

nnoremap <Leader><Leader>i :PlugInstall<CR>
nnoremap <Leader><Leader>u :PlugUpdate<CR>

call plug#begin('~/.vim/bundle')

Plug 'Shougo/vimproc.vim'

Plug 'Shougo/unite.vim'
    let g:unite_split_rule = "botright"
    let g:unite_force_overwrite_statusline = 0
    let g:unite_enable_start_insert = 1

    let g:unite_source_history_yank_enable = 1
    let g:unite_source_history_yank_limit = 10000
    let g:unite_source_history_yank_file=expand('~'). "/.vim/tmp/yank"

    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
        \ '--nocolor --nogroup --hidden --ignore-dir vendor/cache ' .
        \ '--ignore-dir .git --ignore *.log --ignore *.bundle.* ' .
        \ '--ignore-dir .jhw-cache'
    let g:unite_source_grep_recursive_opt = ''

    au VimEnter * call unite#custom#source(
        \ 'file,file/new,buffer,file_rec,file_rec/async,'
        \  . 'git_cached,git_untracked,directory',
        \ 'matchers', 'matcher_fuzzy'
    \ )

    au VimEnter * call unite#custom#default_action(
        \ 'directory', 'cd'
    \ )

    au VimEnter * call unite#filters#sorter_default#use(['sorter_selecta'])

    au VimEnter * call unite#custom#source(
        \ 'file,file_rec,file_rec/async,git_cached,git_untracked',
        \ 'ignore_globs',
        \ split('*.png,*.zip,*.tar,*.gz,*.jpg,*.jpeg,*.chunks,*.gif', ',')
    \ )

    function! s:unite_my_settings()
        imap <buffer> <C-R> <Plug>(unite_redraw)

        imap <silent><buffer><expr> <C-T> unite#do_action('split')
        imap <silent><buffer><expr> <C-V> unite#do_action('vsplit')
        call unite#custom#alias('ash_review', 'split', 'ls')
    endfunction

    augroup unite_setting
        au!

        au FileType unite call s:unite_my_settings()
    augroup end

    nnoremap <C-E><C-R> :UniteResume<CR>
    nnoremap <C-E><C-G> :Unite -hide-source-names grep:.<CR>
    nnoremap <C-O> :Unite -hide-source-names buffer<CR>
    nnoremap <C-P> :Unite -hide-source-names buffer git_cached git_untracked<CR>
    nnoremap <C-Y> :Unite -hide-source-names history/yank<CR>

Plug 'morhetz/gruvbox'

Plug 'junegunn/seoul256.vim'

Plug 'bling/vim-airline'
    let g:airline_theme = 'lucius'
    let g:airline#extensions#whitespace#symbol = '☼'
    let g:airline_powerline_fonts = 1

Plug 'scrooloose/nerdcommenter'

Plug 'Valloric/YouCompleteMe'
    let g:ycm_key_list_previous_completion=['<UP>']
    let g:ycm_key_list_select_completion=['<DOWN>']

    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1

    let g:ycm_seed_identifiers_with_syntax = 1

Plug '2072/PHP-Indenting-for-VIm'

Plug 'fatih/vim-go', { 'for': 'go' }
    let g:go_fmt_fail_silently = 0
    let g:go_fmt_command = "goimports"
    let g:go_fmt_autosave = 0
    let g:go_bin_path = $GOPATH . "/bin"

    au filetype_go FileType go nmap <buffer> <Leader>e :GoRename<CR>
    au filetype_go FileType go nmap <buffer> <Leader>f :GoFmt<CR>:w<CR>
    au filetype_go FileType go nmap <buffer> <Leader>h :GoDoc<CR>

Plug 'elzr/vim-json', { 'for': 'json' }
    augroup filetype_json
        au!
        au BufNewFile,BufRead *.json set filetype=json
    augroup end

Plug 'mhinz/vim-startify'
    let g:startify_session_dir = '~/.vim/sessions'
    let g:startify_enable_special = 1
    let g:startify_list_order = ['sessions', 'dir', 'files']
    let g:startify_files_number = 20
    let g:startify_session_persistence = 1
    let g:startify_session_delete_buffers = 1
    let g:startify_change_to_dir = 0

Plug 'l9'

Plug 'lyokha/vim-xkbswitch'
    let g:XkbSwitchLib = '/usr/local/lib/libxkbswitch.so'
    let g:XkbSwitchEnabled = 1

Plug 'Lokaltog/vim-easymotion'
    let g:EasyMotion_keys = "hjkluiopqweasd"

    hi link EasyMotionTarget ErrorMsg
    hi link EasyMotionTarget2First ErrorMsg
    hi link EasyMotionTarget2Second ErrorMsg

Plug 'SirVer/ultisnips'
    let g:UltiSnipsSmippetDirectories = [$HOME . '/.vim/Ultisnips/']
    let g:UltiSnipsEnableSnipMate = 0
    let g:UltiSnipsExpandTrigger="<TAB>"
    let g:UltiSnipsJumpForwardTrigger="<C-J>"
    let g:UltiSnipsJumpBackwardTrigger="<C-K>"
    let g:UltiSnipsEditSplit="vertical"

    nnoremap <C-S><C-E> :UltiSnipsEdit<CR>

Plug 'honza/vim-snippets'

Plug 'tpope/vim-fugitive'
    nnoremap <F10> :Gstatus<CR>

Plug 'tpope/vim-git'

Plug 'tpope/vim-surround'

Plug 'terryma/vim-multiple-cursors'

Plug 'yuku-t/unite-git'

Plug 'joonty/vim-phpqa', { 'for': 'php' }
    let g:phpqa_php_cmd='php'
    let g:phpqa_run_on_write=0
    let g:phpqa_codesniffer_cmd='phpcs'
    let g:phpqa_codesniffer_args="--encoding=utf8 --standard='" . expand('~') .
        \ "/repos/standards/CodeSniffer/Standards/NGS/ruleset.xml'"

    let g:phpqa_codesniffer_autorun=0
    let g:phpqa_messdetector_autorun=0

    au filetype_php FileType php nnoremap <buffer> <F2>  :Phpcs<CR>

Plug 'pangloss/vim-javascript', { 'for': 'js' }

Plug 'jelera/vim-javascript-syntax', { 'for': 'js' }

Plug 'rename', { 'on': 'Rename' }

Plug 't9md/vim-choosewin', { 'on': [ 'ChooseWin', 'ChooseWinSwap' ] }
    let g:choosewin_overlay_enable = 1
    let g:choosewin_overlay_clear_multibyte = 1
    let g:choosewin_label = 'QWEASDIOPJKL'

    nnoremap <C-W><C-E> :ChooseWin<CR>
    nnoremap <C-W><C-S> :ChooseWinSwap<CR>

Plug 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
    nnoremap L :OverCommandLine %s/<CR>
    vnoremap L :OverCommandLine s/<CR>

Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    augroup filetype_markdown
        au!
        au BufRead,BufNewFile *.md set filetype=markdown
    augroup end

Plug 'edsono/vim-matchit', { 'for': 'smarty'}
    augroup filetype_smarty
        au!

        au BufRead,BufNewFile *.tpl set filetype=smarty
    augroup end

Plug 'AndrewRadev/sideways.vim'

Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

Plug 'terryma/vim-multiple-cursors'

Plug 'majutsushi/tagbar', { 'for': 'php' }

Plug 'justinmk/vim-sneak'
    " bullshit
    nmap <NOP> <Plug>Sneak_s
    vmap <NOP> <Plug>Sneak_s
    nmap <NOP><NOP> <Plug>Sneak_S
    vmap <NOP><NOP> <Plug>Sneak_S

    nmap f <Plug>Sneak_f
    nmap F <Plug>Sneak_F
    xmap f <Plug>Sneak_f
    xmap F <Plug>Sneak_F
    omap f <Plug>Sneak_f
    omap F <Plug>Sneak_F
    "replace 't' with 1-char Sneak
    nmap t <Plug>Sneak_t
    nmap T <Plug>Sneak_T
    xmap t <Plug>Sneak_t
    xmap T <Plug>Sneak_T
    omap t <Plug>Sneak_t
    omap T <Plug>Sneak_T

Plug 'alvan/vim-php-manual', { 'for': 'php' }

Plug 'vim-scripts/smarty-syntax', { 'for': 'smarty' }

Plug 'SyntaxAttr.vim'

Plug 'BufOnly.vim'

Plug 'm2mdas/phpcomplete-extended', { 'for': 'php' }
    au filetype_php FileType php
        \ setlocal omnifunc=phpcomplete_extended#CompletePHP

Plug 'gregsexton/gitv'
    let g:Gitv_OpenHorizontal = 1

Plug 'bogado/file-line'

Plug 'godlygeek/tabular'
    " phpdoc block tabularize
    nnoremap <C-E><C-A> :Tabularize /* @\w\+/<CR>

Plug 'kovetskiy/vim-go-complete-note', { 'for': 'go' }
    inoremap <C-E> <C-O>:call GoCompleteNote()<CR><C-O>a

Plug 'kovetskiy/urxvt.vim'
    au filetype_go FileType go nmap <buffer>
        \ <Leader>t :call urxvt#put('go test')<CR>
    au filetype_go FileType go nmap <buffer>
        \ <Leader>r :call urxvt#put('./' . expand('%:p:h:t'))<CR>
    au filetype_go FileType go nmap <buffer>
    \ <Leader>b :GoFmt<CR>:w<CR>:call urxvt#put('go build')<CR>

" depends of Unite.vim
Plug 'kovetskiy/ash.vim'
    augroup ash_customisation
        au!
        au FileType diff syn match DiffAddedContent "^+.*" containedin=ALL
        au FileType diff hi! DiffAddedContent ctermbg=65 guibg=#719872 ctermfg=232
        au FileType diff syn match DiffRemovedContent "^-.*" containedin=ALL
        au FileType diff hi! DiffRemovedContent ctermbg=131 guibg=#be7572 ctermfg=232
    augroup end

    nnoremap <C-E><C-I> :Unite ash_inbox<CR>
    nnoremap <C-E><C-N> :Unite ash_lsreviews:ngs/auto<CR>

Plug 'seletskiy/vim-pythonx', { 'for': ['go', 'php']}
    au filetype_go FileType go
        \ inoremap <buffer> <C-L> <C-\><C-O>:py go.cycle_by_var_name()<CR>
    au filetype_go FileType go
        \ smap <buffer> <C-L> <BS><C-L>
    au filetype_go FileType go
        \ smap <buffer> <C-K> <BS><C-I>

    au filetype_php FileType php
        \ inoremap <buffer> <C-L> <C-\><C-O>:py php.cycle_by_var_name()<CR>
    au filetype_php FileType php
        \ smap <buffer> <C-L> <BS><C-L>

Plug 'kovetskiy/vim-empty-lines'
    nnoremap <Leader><Leader>j :call DelEmptyLineBelow()<CR>
    nnoremap <Leader><Leader>k :call DelEmptyLineAbove()<CR>
    nnoremap <Leader>j :call AddEmptyLineBelow()<CR>
    nnoremap <Leader>k :call AddEmptyLineAbove()<CR>

Plug 'kovetskiy/vim-reduce-line'
    nnoremap <Leader>m :call TryToReduce()<CR>

Plug 'kovetskiy/vim-plugvim-utils'
    nnoremap <Leader><Leader>c :call NewPlugFromClipboard()<CR>

Plug 'kovetskiy/vim-ternary'
    nnoremap <Leader>t :call RemoveTernaryOperator()<CR>

Plug 'bronson/vim-trailing-whitespace'
    let g:extra_whitespace_ignored_filetypes = [
        \ 'vim', 'unite'
    \ ]

Plug 'seletskiy/vim-nunu'

Plug 'ervandew/matchem'

call plug#end()

syntax on
filetype plugin indent on

set rtp-=~/.vim
set rtp^=~/.vim

set encoding=utf-8
set printencoding=cp1251
set fileformat=unix

set textwidth=80
set timeoutlen=400
set wildmenu

set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/
set backupdir=$HOME/.vim/tmp

set lazyredraw
set ttyfast

set number
set relativenumber

set history=500

set hlsearch
set incsearch

set ignorecase
set smartcase

set expandtab
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2

set laststatus=2
set gdefault
set completeopt-=preview
set nowrap
set updatetime=150
set showtabline=0
set cino=(s,m1,+0

set list
set lcs=eol:¶,trail:·,tab:\ \ "t

set pastetoggle=<F11>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

set nofoldenable

set tags=tags;/

augroup filetype_help
    au!
    au FileType help setlocal number
augroup end

augroup dir_autocreate
    au!
    au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

augroup vimrc
    au!
    au BufWritePost ~/.vimrc source % | AirlineRefresh
augroup end

augroup mcabberrc
    au!
    au BufWritePost ~/.mcabber/mcabberrc !echo "/source ~/.mcabber/mcabberrc" > ~/.mcabber/mcabber.fifo
augroup end

fu! SkeletonGitCommit()
    let l:line = getline(".")
    if l:line == ""
        let l:issue = system("git symbolic-ref HEAD 2>/dev/null | grep -oP '([A-Za-z]{1,}\-[0-9]{1,})'")

        if l:issue != ''
            execute 'normal I' . toupper(l:issue)
            execute 'normal gg$a: '
        endif
    endif
endfu!

augroup skeletons
    au!
    au FileType gitcommit exec "call SkeletonGitCommit()"
    au BufNewFile *.php exec "normal I<?php\r\rcl"
augroup end

augroup hilight_over
    au!
    au VimResized,VimEnter * set cc=80,120
augroup end

au filetype_php FileType php nnoremap <buffer> <F7>  :!time tags_php<CR>

" Ultisnips triggers.
au filetype_php FileType php imap <buffer> <C-S><C-P> ps<TAB>
au filetype_php FileType php imap <buffer> <C-G><C-P> pg<TAB>
au filetype_php FileType php imap <buffer> <C-S><C-V> vs<TAB>
au filetype_php FileType php imap <buffer> <C-G><C-V> vg<TAB>
au filetype_php FileType php imap <buffer> <C-S><C-U> us<TAB>
au filetype_php FileType php imap <buffer> <C-G><C-U> ug<TAB>

au filetype_php FileType php hi! def link phpDocTags  phpDefine
au filetype_php FileType php hi! def link phpDocParam phpType

nnoremap <F12> :noh<CR>

nnoremap <Leader>o o<ESC>
nnoremap <Leader>O O<ESC>

nnoremap X S<ESC>
vnoremap $ g_

nnoremap / /\v
vnoremap / /\v

nnoremap > >>
nnoremap < <<

nnoremap <Leader>` :tabedit ~/.vimrc<CR>
nnoremap <Leader>% :so ~/.vimrc<CR>

vnoremap <silent> > >gv
vnoremap <silent> < <gv

inoremap jk <ESC>

nnoremap g< '<
nnoremap g> '>

nnoremap g. '>
nnoremap g, '<

nnoremap <F4> :let &scrolloff=999-&scrolloff<CR>
nnoremap <Leader><Leader>q :bdelete!<CR>
nnoremap <Leader><Leader>q <Esc>:bdelete!<CR>

nnoremap <Leader>vs :vsp<CR>

nnoremap <Leader>e :e! 
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q!<CR>

nnoremap <Space> :noh<CR>

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

nnoremap <C-T><C-T> :retab<CR>

inoremap <C-A> <C-O>A

map <C-_> <C-W>_
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

imap <C-T> <C-R>=strpart(search("[)}\"'`\\]]", "c"), -1, 0)<CR><Right>

inoremap <C-K> <C-O>A;<C-O>o

fu! Background(val)
    let bg = a:val
    if bg == ""
        let bg = "light"
    endif

    if bg == "light"
        let g:seoul256_background = 255
        let g:colorscheme='seoul256'
    else
        let g:colorscheme='gruvbox'
    endif

    execute "colorscheme " . g:colorscheme
    execute "set background=" . bg

    hi! link WildMenu PmenuSel
    hi SPM1 ctermbg=1 ctermfg=7
    hi SPM2 ctermbg=2 ctermfg=7
    hi SPM3 ctermbg=3 ctermfg=7
    hi SPM4 ctermbg=4 ctermfg=7
    hi SPM5 ctermbg=5 ctermfg=7
    hi SPM6 ctermbg=6 ctermfg=7
    hi VertSplit cterm=none ctermbg=none ctermfg=16
    hi ErrorMsg term=none
    hi Todo term=none
    hi SignColumn term=none
    hi FoldColumn term=none
    hi Folded term=none
    hi WildMenu term=none
    hi WarningMsg term=none
    hi Question term=none

    if &background == "light"
        set background=light
        hi! underlined cterm=underline
        hi! CursorLineNr ctermfg=241 ctermbg=none
        hi! LineNr ctermfg=249 ctermbg=none
        hi! SignColumn ctermfg=none ctermbg=none
        hi! SpecialKey term=bold cterm=bold ctermfg=1 ctermbg=none
        hi! NonText ctermfg=254 cterm=none term=none
        hi! IncSearch cterm=none ctermfg=238 ctermbg=220
        hi! Cursor ctermbg=0 ctermfg=15
        hi! PmenuSel ctermbg=136 ctermfg=15 cterm=bold
    endif

    " for smarty
    hi htmlLink gui=none
endfu!

call Background($BACKGROUND)

noh
