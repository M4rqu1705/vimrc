set nocompatible                " vi compatible is LAME

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    "Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$")
                \           && expand("%") !~ "COMMIT_EDITMSG"
                \           && expand("%") !~ "MERGE_EDITMSG"
                \           && expand("%") !~ "ADD_EDIT.patch"
                \           && expand("%") !~ "addp-hunk-edit.diff"
                \           && expand("%") !~ "git-rebase-todo" |
                \   exe "normal g`\"" |
                \ endif

    autocmd BufNewFile,BufRead *.patch set filetype=diff
    autocmd BufNewFile,BufRead *.diff set filetype=diff

    autocmd Syntax diff
                \ highlight WhiteSpaceEOL ctermbg=red |
                \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/

    autocmd Syntax gitcommit setlocal textwidth=74

endif

" ================================================== User defined mappings ==================================================

" Make ',' leader for commands
let mapleader = ","

" Remap k to gk to intuitively jump lines upwards
nnoremap k gk

" Remap j to gj to intuitively jump lines downwards
nnoremap j gj

" Big jump up (move up one page)
nnoremap <leader>k <c-u>

" Big jump down (move down one page)
nnoremap <leader>j <c-d>

" <leader>u toggles the case of the current word
nnoremap <leader>u Bviw~<space><esc>

" Big jump left (to first non-blank character)
nnoremap <leader>h g^<space>

" Big jump right (to last non-blank character)
nnoremap <leader>l g_

" Remap ev to edit vimrc file
nnoremap <leader>ev :tabedit /c/Users/m4rc0/AppData/Local/Programs/cmder/vendor/git-for-windows/etc/vimrc<cr>

" Remap sv to "refresh" vimrc
nnoremap <leader>sv :source /c/Users/m4rc0/AppData/Local/Programs/cmder/vendor/git-for-windows/etc/vimrc<cr>

" Remap Ctrl+W for use in Cmder
nnoremap <c-w> <c-s-w>

" ================================================= Plugins ================================================= 
call plug#begin('$VIM/vim81/plugin')
" Declare list of plugins
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-repeat'
Plug 'junegunn/vim-emoji'
Plug 'ErichDonGubler/vim-sublime-monokai'
" Plug 'sirver/ultisnips'
" List ends here. Plugins become visible to VIM
call plug#end()

" ================================================== Vim Emoji ====================================================
set completefunc=emoji#complete

function ReplaceWithEmoji()
    %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
endfunction


" ================================================== Vim Surround ====================================================
if has("autocmd")
    augroup vim_surround
        autocmd!

        " Map change surrounding to <leader>cs and eliminate the cs command
        autocmd VimEnter * nmap <leader>cs cs " Map change surrounding to <leader>cs and eliminate the cs command

        " Map delete surrounding to <leader>ds and eliminate the ds command
        autocmd VimEnter * nmap <leader>ds ds

        " Map add surrounding to <leader>as and eliminate ysiw
        autocmd VimEnter * nmap <leader>as ys

        " Map surround line to <leader>sl and eliminate yss
        autocmd VimEnter * nmap <leader>sl yss

        " Map surround selection to <leader>s and eliminate S
        autocmd VimEnter * imap <leader>s S
    augroup END

endif

" ================================================== NERDtree ====================================================
if has("autocmd")
    " Close vim if the only window left open is a NERDTree?
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif "has("autocmd")

nnoremap <leader>pnt :NERDTreeToggle<cr>

" let g:NERDTreeDirArrowExpandable = '→'
" let g:NERDTreeDirArrowCollapsible = '↓'
let g:NERDTreeDirArrows=0

" ================================================== Emmet ====================================================
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_mode='n'    "only enable normal mode functions.
let g:user_emmet_leader_key= ',e'

" ================================================== Abbreviations ==================================================
" HTML files
func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

if has("autocmd")

    " HTML tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <html> <html><cr><cr></html><up><left><left><left><c-r>=Eatchar('\s')<cr>

    " Head tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <head> <head><cr><cr></head><up><left><left><left><left>
    
    " Meta tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <meta> <meta name="" content=""/><left><left><left><left><left><left><left><left><left><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Title tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <title> <title></title><left><left><left><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Style tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <style> <style type="text/css"><cr><cr></style><up><left><left><left><left>

    " Body tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <body> <body><cr><cr></body><up><left><left><left><left>

    " Paragraph tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <p> <p></p><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Anchor tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <a> <a href="#"></a><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Image tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <img> <img src="" alt=""/><left><left><left><left><left><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Break line tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <br> <br/><c-r>=Eatchar('\s')<cr>

    " Horizontal rule tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <hr> <hr/><c-r>=Eatchar('\s')<cr>

    " Heading tags
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <h1> <h1></h1><left><left><left><left><left><c-r>=Eatchar('\s')<cr>
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <h2> <h2></h2><left><left><left><left><left><c-r>=Eatchar('\s')<cr>
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <h3> <h3></h3><left><left><left><left><left><c-r>=Eatchar('\s')<cr>
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <h4> <h4></h4><left><left><left><left><left><c-r>=Eatchar('\s')<cr>
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <h5> <h5></h5><left><left><left><left><left><c-r>=Eatchar('\s')<cr>
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <h6> <h6></h6><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Table tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <table> <table><cr><cr></table><up><left><left><left><left><left>

    " Table Head tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <thead> <thead><cr><cr></thead><up><left><left><left><left><left>

    " Table header tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <th> <th></th><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Table row tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <tr> <tr><cr><cr></tr><up><left><left>

    " Table Body tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <tbody> <tbody><cr><cr></tbody><up><left><left><left><left><left>

    " Table data tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <td> <td></td><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " JavaScript tag
    " autocmd BufRead,BufNewFile *.html iabbrev <silent> <script> <script><cr><cr></script><up><left><left><left><left><left><left>

    " No JavaScript tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <noscript> <noscript><cr><cr><noscript><up><left><left><left><left><left><left><left><left>

    " Div tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <div> <div><cr><cr></div><up><left><left><left>

    " Span tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <span> <span></span><left><left><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Input tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <input> <input type="" name="" placeholder=""/><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Label tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <label> <label></label><left><left><left><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Select tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <select> <select name=""><cr><cr></select><up><left><left><left><left><left><left>

    " Option tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <option> <option value=""></option><left><left><left><left><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Button tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <button> <button></button><left><left><left><left><left><left><left><left><left><c-r>=Eatchar('\s')<cr>

    " Text area tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <textarea> <textarea><cr><cr></textarea><up><left><left><left><left><left><left><left><left>

    " Comment tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <!-- <!-- --><left><left><left><left>

    " Header tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <header> <header><cr><cr></header><up><left><left><left><left><left><left>

    " Nav tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <nav> <nav><cr><cr></nav><up><left><left><left>

    " Article tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <article> <article><cr><cr></article><up><left><left><left><left><left><left><left>

    " Section tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <section> <section><cr><cr></section><up><left><left><left><left><left><left><left>

    " Aside tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <aside> <aside><cr><cr></aside><up><left><left><left><left><left>

    " Footer tag
    autocmd BufRead,BufNewFile *.html iabbrev <silent> <footer> <footer><cr><cr></footer><up><left><left><left><left><left><left>


" http://triin.net/2006/06/12/html AND https://www.w3schools.com/tags/default.asp

endif

" ================================================== Buffers ==================================================
set hidden
set viminfo='999,<50,s10,h,%,/0,:99,@99

" ================================================== Dictionaries ==================================================
set spell spelllang=en,es
set dictionary="$VIM/vim81/spell"
" For making everything UTF-8
" set encoding = utf-8
" set fileencodings = utf-8

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    "setglobal bomb
    set fileencodings=ucs-bom,utf-8,latin1
endif

" ================================================== Interface ================================================== 
set number                      " Add line numbers
set numberwidth=5               " Set line number width
set showmode                    " show the current mode
set title
syntax on                       " turn syntax highlighting on by default
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
" set background=dark             " Use colours that work well on a dark background (Console is usually black)
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P
colorscheme sublimemonokai

" ================================================== Whitespace ==================================================
set ai                          " set auto-indenting on for programming
set wrap
set linebreak
set showbreak=\.\.\.\ 
set nolist
set textwidth=0
set wrapmargin=0
set formatoptions=nB1lcw
set virtualedit=insert
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set noshiftround

" ================================================== Searching ==================================================
set incsearch
set ignorecase smartcase
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set ruler                       " show the cursor position all the time

" ================================================== History and file handling ==================================================
set history=999             " Increase history (default = 20)
set undolevels=999          " More undo (default=100)

" ================================================== Backup and Swap Files ==================================================
set nobackup
set nowritebackup
set noswapfile

" ================================================== Keys ==================================================
set backspace=indent,eol,start  " allow backspacing over everything.
set timeoutlen=2000              " how long it wait for mapped commands

" ================================================ Use TAB to autocomplete ================================================ 
function! Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfunction

inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

" ================================================== Code folding ==================================================
set foldmethod=manual       " manual fold

" ================================================= Auto commenting =================================================
let s:comment_map = { 
            \   "c": '\/\/\ ',
            \   "cpp": '\/\/\ ',
            \   "go": '\/\/\ ',
            \   "java": '\/\/\ ',
            \   "javascript": '\/\/\ ',
            \   "lua": '--',
            \   "scala": '\/\/\ ',
            \   "php": '\/\/\ ',
            \   "python": '#\ ',
            \   "ruby": '#\ ',
            \   "rust": '\/\/',
            \   "sh": '#',
            \   "desktop": '#',
            \   "fstab": '#',
            \   "conf": '#',
            \   "profile": '#',
            \   "bashrc": '#',
            \   "bash_profile": '#',
            \   "mail": '>',
            \   "eml": '>',
            \   "bat": 'REM',
            \   "ahk": ';',
            \   "vim": '"',
            \   "tex": '%',
            \ }

function! ToggleComment()
    if has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
        if getline('.') =~ "^\\s*" . comment_leader . " " 
            " Uncomment the line
            execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
        else 
            if getline('.') =~ "^\\s*" . comment_leader
                " Uncomment the line
                execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
            else
                " Comment the line
                execute "silent s/^\\(\\s*\\)/\\1" . comment_leader . " /"
            end
        end
    else
        echo "No comment leader found for filetype"
    end
endfunction

nnoremap <leader>cc :call ToggleComment()<cr>
vnoremap <leader>C :call ToggleComment()<cr>
