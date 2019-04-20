set nocompatible                " vi compatible is LAME

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I. Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1) Buffers {{{
set hidden
set viminfo='999,<50,s10,h,%,/0,:99,@99
filetype plugin indent on


" }}}
" 2) Windows {{{
set splitbelow
set splitright


" }}}
" 3) Interface {{{
set number                      " Add line numbers
set numberwidth=5               " Set line number width
set noshowmode                  " Do not show the current mode
set showcmd                     " Show currently-typed command
set title                       " Show tab titles
syntax on                       " Turn syntax highlighting on by default
set visualbell                  " Use visual bell instead of beeping when doing something wrong
set laststatus=2                " Make the last line where the status is two lines deep so you can see status always
set background=dark             " use colours that work well on a dark background (Console is usually black)
set clipboard=unnamed           " Set clipboard to unnamed to access the system clipboard under windows
set sidescrolloff=2             " Add space beside the cursor when going off screen 
set scrolloff=2                 " Add space around the cursor when going off screen
set binary                      " Used to edit binary files
set ruler                       " show the cursor position all the time
set confirm                     " Confirm commands instead of throwing errors
set cmdheight=2                 " Make the ex command line 2 lines high
set foldcolumn=1                " Add a little margin to the left
set t_Co=256                    " Make sure Vim is using 256 colors
set ttyfast                     " Smoother screen redraw
set lazyredraw                  " The screen will not be redrawn so frequently 

" Enable the use of mice if they are available
if has('mouse')
    set mouse=a
endif

" source $VIMRUNTIME/mswin.vim
" behave mswin

" if has('autocmd')
" augroup Window
" autocmd!
" autocmd VimResized * wincmd =
" augroup END
" else
" echoerr "[×] ERROR: NO AUTOCMD - Could not optimize window's splits"
" endif


" }}}
" 4) GUI {{{
if has("gui_running")
    set guioptions=cRLhb            " Remove menubar and other disturbing items in gVIM
    set guifont=Lucida_Console:h16qANTIALIASED
    set t_Co=256
    set cursorline                  " Highlight line with cursor
    " Maximize the screen on enter if has autocmd
    if has('autocmd')
        augroup GUI
            autocmd!
            autocmd VimEnter * execute "simalt ~x"
        augroup END
    else
        echoerr "[×] ERROR: NO AUTOCMD - Did not maximize window"
    endif
endif


" }}}
" 5) Themes {{{
" colorscheme molokai
" let g:molokai_original = 1

if has('autocmd')
    augroup Themes
        autocmd!
        autocmd VimEnter * colorscheme tender
        autocmd VimEnter * colorscheme onehalfdark
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not set colorscheme"
endif



" }}}
" 6) Searching {{{
set incsearch           " Show temporary search results as being typed
set ignorecase          " Case of normal letters is ignored
set smartcase           " Ignore case when pattern contains lower-case letters
set showmatch           " Automatically show matching brackets.  
set magic               " Easier use of regex for searching


" }}}
" 7) Dictionaries {{{
if has('spell')
    set dictionary=$VIMRUNTIME/spell
    set spell spelllang=en,es
    set thesaurus+=$VIMRUNTIME/spell/en_thesaurus.txt
else
    echoerr "[×] ERROR: NO SPELL - Could not configure spell check"
endif

" For making everything UTF-8
set encoding=utf-8
let &termencoding = &encoding
let &fileencoding = &encoding
let &fileencodings = &encoding

" ]s - Next spell error
" [s - Previous spell error
" zg - Add word to dictionary
" zw - Remove word from dictionary


" }}}
" 8) History and file handling {{{
set history=999             " Increase history (default = 20)
set undolevels=999          " More undo (default=100)
if has('persistent_undo')

    let s:destination = fnameescape(expand("$VIMRUNTIME/temp/undos"))
    if !isdirectory(s:destination)
        execute "!mkdir " . s:destination
    endif
    set undodir=s:destination
    set undofile
else
    echoerr "[×] ERROR: NO PERSISTENT UNDO - Could not set up persistent undo"
endif


" }}}
" 9) Whitespace {{{
set autoindent                          " Set auto-indenting on for programming
set wrap
set wrapmargin=2
set textwidth=80 
set linebreak
set showbreak=\.\.\.\ 
set nolist 
set formatoptions=tcnBjq2     " Describes automatic formatting
" t - Auto-wrap text using textwidth
" c - Auto-wrap comments and insert comment leader in new line
" n - Recognize numbered lists: format listpat
" B - When joining lines do not add space between multi-byte characters 
" j - When joining lines remove comment leaders
" q - Format comments with gq
" a - Automatic formatting of paragraphs
" 2 - Indent second line of a paragraph for the rest of the paragraph 

set virtualedit=insert
set tabstop=4 softtabstop=4             " Show existing tab with 4 spaces width
set shiftwidth=4                        " When indenting with '>', use 4 spaces width
set expandtab                           " on pressing tab, insert 4 spaces
set noshiftround
set nostartofline


" }}}
" 10) Keys {{{
set backspace=indent,eol,start      " Allow backspacing over everything.
set timeoutlen=2000                 " How long it wait for mapped commands


" }}}
" 11) Autocomplete {{{
set omnifunc=syntaxcomplete#Complete
set complete=.,w,b,d,u,t
set completeopt=longest,menuone,preview

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
            \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <a-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

function! Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfunction

inoremap <silent> <Tab> <C-R>=Tab_Or_Complete()<CR>
inoremap <expr> <s-tab> pumvisible() ? "\<c-o>" : "\<c-x>\<c-o>"

" https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
" https://medium.com/usevim/vim-101-completion-compendium-97b4ebc3a45a
" https://news.ycombinator.com/item?id=13960147


" }}}
" 12) Code folding {{{
if has('folding')
    set foldenable              " Enable code folding and show all folds
    set foldmethod=manual       " Folds are based on indent level
    set foldlevelstart=10       " Number of fold levels to be opened at enter
    set foldnestmax=10
    set modeline
    set modelines=1
else
    echoerr "[×] ERROR: NO FOLDING Could not configure code folding"
endif
" zO opens current fold recursively
" zC closes current fold recursively
" zR opens all folds recursively
" zM closes all folds recursively
" zd deletes current fold
" zE deletes all folds


" }}}
" 13) Diff {{{
if has('autocmd')

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

set diffexpr=MyDiff()
function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    let cmd = '""' . $VIMRUNTIME . '\diff"'
    let eq = '"'
else
    let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" do - diff obtain
" dp - diff put
" [c - previous diff
" ]c - following diff


" }}}
" 14) Backup and Swap Files {{{
set nobackup
set nowritebackup
set noswapfile


" }}}
" 15) Sessions {{{
if has('mksession')
    if has('autocmd')
        augroup Sessions
            autocmd!
            autocmd VimEnter * set sessionoptions=blank
            autocmd VimEnter * set sessionoptions+=buffers
            autocmd VimEnter * set sessionoptions+=curdir
            autocmd VimEnter * set sessionoptions+=folds
            autocmd VimEnter * set sessionoptions+=globals
            autocmd VimEnter * set sessionoptions+=resize
            autocmd VimEnter * set sessionoptions+=tabpages
            autocmd VimEnter * set sessionoptions+=terminal
            autocmd VimEnter * set sessionoptions+=winpos
            autocmd VimEnter * set sessionoptions+=winsize
        augroup END
    else
        echoerr "[×] ERROR: NO AUTOCMD - Did not configure vim sessions"
    endif

    let g:sessions_dir = expand('$VIMRUNTIME/../../../Data/settings/sessions')
    execute 'cnoreabbrev mks mksession! ' . g:sessions_dir . '/'
else
    echoerr "[×] ERROR: NO SESSIONS - Could not configure vim sessions"
endif


" }}}
" 16) Templates {{{
if has("autocmd")
    augroup Templates
        autocmd!

        " Python files
        autocmd BufNewFile *.py 0r $VIMRUNTIME/templates/skeleton.py

    augroup END
endif


" }}}
" 17) Terminal {{{
function! DevelopmentEnvironment()
    if has("terminal")
        tabnew
        Startify
        execute "term ++kill=term ++close ++rows=" . winheight('%') / 4
        wincmd k
        execute "Vexplore " . &columns / 5
        endif
endfunction


if has("terminal")
    " Use escape key instead of strange combination
    tnoremap <esc> <C-\><C-n>
    tnoremap jk <C-\><C-n>

    " Prepare command mode mappings which make the use of 'term' less lengthy 
    cnoreabbrev term vert term ++kill=term ++close
    cnoreabbrev hterm term ++kill=term ++close
    cnoreabbrev tterm execute "tabnew<bar>term ++kill=term ++curwin ++close"


    let g:conda_environment = "base"
    let g:vimrc_github = "https://github.com/M4rqu1705/vimrc"

    " Prepare PATH variables for ... 
    let s:fd_path = expand('$VIMRUNTIME/../../../Programming/fd')
    let s:fzf_path = expand('$VIMRUNTIME/../../../Programming/fzf')
    let s:wget_path = expand('$VIMRUNTIME/../../../Programming/wget')
    let s:python_path = expand('$VIMRUNTIME/../../../Programming/WPy-3710/python-3.7.1')
    let s:git_path = expand('$VIMRUNTIME/../../../Programming/Git/bin') . ";" .
                \ expand(' $VIMRUNTIME/../../../Programming/Git/usr/bin') 

    let s:relevant_paths = []

    if $PATH !~? "fd" | call add(s:relevant_paths, s:fd_path) | endif
    if $PATH !~? "fzf" | call add(s:relevant_paths, s:fzf_path) | endif
    if $PATH !~? "git" | call add(s:relevant_paths, s:git_path) | endif
    if $PATH !~? "wget" | call add(s:relevant_paths, s:wget_path) | endif
    if $PATH !~? "python" && $PATH !~? "conda" && $PATH !~? "WPy-3710"
        call add(s:relevant_paths, s:python_path)
    endif


    if has('autocmd')
        augroup Terminal
            autocmd!
            autocmd SourcePre *vimrc if !exists('g:path_set') |
                        \ let $PATH = join(s:relevant_paths, ";") . ";" . $PATH |
                        \ let g:path_set = 1 |
                        \ endif
        augroup END
    else
        echoerr "[×] ERROR: NO AUTOCMD - Could not update PATH environment variable"
    endif

else
    echoerr "[×] ERROR: NO TERMINAL - Could not configure terminal settings"
endif

" Set the python3 home and dll directory, crucial to use python in Vim
if has('python_dynamic')
    set pythonthreehome=$VIMRUNTIME/../../../Programming/WPy-3710/python-3.7.1
    set pythonthreedll=$VIMRUNTIME/../../../Programming/WPy-3710/python-3.7.1/python37.dll
endif


" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" II. User defined mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1) Mappings {{{

" Make ',' leader for commands
let mapleader = ","

" Remap k to gk to intuitively jump lines upwards
nnoremap k gk

" Remap j to gj to intuitively jump lines downwards
nnoremap j gj


if exists('g:vimrc_dir')
    " Remap ev to edit vimrc file
    execute "nnoremap <silent> <leader>ev :tabedit " . g:vimrc_dir . "/.vimrc<cr>"

    " Remap lv to "refresh" vimrc
    execute "nnoremap <silent> <leader>lv :source " . g:vimrc_dir . "/.vimrc<cr>"
elseif has('gui_running')
    " Remap ev to edit vimrc file
    nnoremap <silent> <leader>ev :tabedit $VIMRUNTIME/../../../Data/settings/_vimrc<cr>

    " Remap lv to "refresh" vimrc
    nnoremap <silent> <leader>lv :source $VIMRUNTIME/../../../Data/settings/_vimrc<cr>
else
    " Remap ev to edit vimrc file
    nnoremap <silent> <leader>ev :tabedit $HOME/.vimrc<cr>

    " Remap lv to "refresh" vimrc
    nnoremap <silent> <leader>lv :source $HOME/.vimrc<cr>
endif

" Searches centralize result on screen
nnoremap n nzzzv
nnoremap N Nzzzv

" Move line up
nnoremap <m-k> "tdd2k"tp
" Move line down
nnoremap <m-j> "tdd"tp

" Move lines up
vnoremap <m-k> "td2k"tp'[V']
" Move lines down
vnoremap <m-j> "td"tp'[V']

" Control-backspace deletes a word
inoremap <c-bs> <esc>dbxi

" Control-delete deletes a word
inoremap <C-Del> <esc>dwi

" Control-a selects all in v-line mode
inoremap <c-a> <esc>ggVG
nnoremap <c-a> ggVG

" Control-s updates file contents 
nnoremap <silent> <c-s> :update<cr>
inoremap <silent> <c-s> <esc>:update<cr>a

" Map Y to act like D and C (To yank until EOL, rather than act as yy)
nnoremap Y y$

" Map gV to select previous visual selection
nnoremap gV `[v`] 

" Escape when writing jk in insert mode
inoremap <silent> jk <esc>

" Move cursor in insert mode
" Left
inoremap <c-h> <esc>i
" Right
inoremap <c-l> <esc>la
" Up
inoremap <c-k> <esc>ka
" Down
inoremap <c-j> <esc>ja

" 'Inside fold' text object 
onoremap iz :<c-u>normal! [zV]z<cr>

if exists("g:restrained_mode")
    inoremap <silent> <esc> <nop>
    inoremap <silent> <up> <nop>
    inoremap <silent> <down> <nop>
    inoremap <silent> <left> <nop>
    inoremap <silent> <right> <nop>
    nnoremap <silent> h <nop>
    nnoremap <silent> j <nop>
    nnoremap <silent> k <nop>
    nnoremap <silent> l <nop>
    vnoremap <silent> h <nop>
    vnoremap <silent> j <nop>
    vnoremap <silent> k <nop>
    vnoremap <silent> l <nop>
endif


" }}}
" 2) Ex command remap {{{
command! W w
command! Q q
command! WQ wq
command! Wq wq
command! QA qa
command! Qa qa
command! WQA wqa
command! WQa wqa
command! WqA wqa
command! Wqa wqa


command! Cdhere call CDCurrent()
command! Lcdhere call LCDCurrent()
command! QuickSetup call QuickSetup()
command! UploadVIMRC call UploadVIMRC()
command! DownloadVIMRC call DownloadVIMRC()
command! ClearAllRegisters call ClearAllRegisters()
command! ClearMessages messages clear
command! DeleteUnlistedBuffers call DeleteUnlistedBuffers()


" }}}
" 3) Custom functions {{{

" Install required dictionary files and vim plug automatically to the 
" corresponding destinations 
function! QuickSetup()

    if confirm("Do you want to download Vim Plug?", "&Yes\n&No") == 1

        " Where to download Vim Plug
        let l:vim_autoload = fnameescape(expand('$VIMRUNTIME/autoload'))
        " From where to download Vim Plug
        let l:vim_plug_link = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

        " Download Vim Plug to desired directory
        execute "!wget ". l:vim_plug_link . " -P " . l:vim_autoload

        echom "[!] DO NOT FORGET TO RUN 'PlugInstall'\n"
        echom "[✔] Successfully downloaded and installed Vim Plug!\n"

    else
        echoerr "[×] Did not install Vim Plug\n"

    endif

    if confirm("Do you want to create templates/skeleton files?", "&Yes\n&No") == 1

        " Where to create these skeleton files
        let l:vim_templates = fnameescape(expand("$VIMRUNTIME/templates"))

        " Create template directory if necessary 
        if !isdirectory(l:vim_templates)
            execute "!mkdir " . l:vim_templates
        endif

        " Python template
        let l:contents = "#!/usr/bin/env python\n" .
                    \ "# -*- coding: utf-8 -*-\n\n" .
                    \ "'''\n" .
                    \ "Docstring goes here\n" .
                    \ "'''\n\n" .
                    \ "__author__ = 'Marcos R. Pesante Colón'\n" .
                    \ "__email__ = 'm4rc05.dev@gmail.com'\n" .
                    \ "__date__ = ''\n" .
                    \ "__license__ = 'GNU GPL V.3'\n" .
                    \ "__version__ = '1.0'\n"

        execute "tabnew " . l:destination . "/skeleton.py | normal! ggVGc" . l:contents . "\<esc>:wq!\<cr>"

        " Add more templates ....

        echom "[✔] Successfully created skeleton files!\n"

    else
        echoerr "[×] Did not create templates/skeleton files\n"

    endif

    if confirm("Do you want to download spell files?", "&Yes\n&No") == 1

        if has('spell')
            " Where to download these spell files
            let l:destination = expand('$VIMRUNTIME/spell')

            " Spell files: English (ascii, latin1, utf8) and Spanish (latin1, utf8) 
            let g:links = [ "ftp.vim.org/vim/runtime/spell/en.ascii.spl", 
                        \ "ftp.vim.org/vim/runtime/spell/en.ascii.sug",
                        \ "ftp.vim.org/vim/runtime/spell/en.latin1.spl",
                        \ "ftp.vim.org/vim/runtime/spell/en.latin1.sug",
                        \ "ftp.vim.org/vim/runtime/spell/en.utf-8.spl",
                        \ "ftp.vim.org/vim/runtime/spell/en.utf-8.sug",
                        \ "ftp.vim.org/vim/runtime/spell/es.latin1.spl",
                        \ "ftp.vim.org/vim/runtime/spell/es.latin1.sug",
                        \ "ftp.vim.org/vim/runtime/spell/es.utf-8.spl",
                        \ "ftp.vim.org/vim/runtime/spell/es.utf-8.sug"
                        \ ]

            " Download every one of these spell files
            execute "!wget -P " . join(g:links, " " . l:destination . " ")

            echom "[✔] Successfully downloaded spell files!\n"

        else
            echoerr "[×] ERROR: NO SPELL - Did not download dictionaries"  

        endif
    else
        echoerr "[×] Did not download spell files\n"

    endif

endfunction


" Upload current local vimrc to github repository
function! UploadVIMRC()

    let l:vimrc_name = ""
    let l:current_directory = getcwd()

    " Change to VIMRC directory
    if exists('g:vimrc_dir')
        cd g:vimrc_dir
        let l:vimrc_name = ".vimrc"
    elseif has('gui_running')
        cd $VIMRUNTIME/../../../Data/settings
        let l:vimrc_name = "_vimrc"
    else
        cd $HOME/
        let l:vimrc_name = ".vimrc"
    endif

    " Download repository to which to copy and upload current vimrc 
    execute "!git clone " . g:vimrc_github 
    execute "!cp " .  l:vimrc_name . " vimrc/.vimrc "

    " Change to local repository's directory for git commands
    cd vimrc

    if confirm("Are you sure you want to upload the latest changes to '" . g:vimrc_github . "'?", "&Yes\n&No") == 1

        " Add contents to staging area, commit them, and upload them
        execute "!git add ."
        execute "!git commit"
        execute "!git push -fu origin master"

        echom "[✔] Successfully uploaded latest changes in VIMRC to " . g:vimrc_github . "\n"

    else
        echoerr "[×] Cancelled VIMRC upload!\n"

    endif

    " Go back to user's vimrc directory
    cd ..

    " Delete local repository
    execute "!rm -rf vimrc"

    " Go back to what was the current directory
    execute 'cd ' . fnameescape(l:current_directory)

endfunction


" Download current VIMRC in github to VIM 
function! DownloadVIMRC()

    let l:vimrc_name = ""
    let l:current_directory = getcwd()

    " Change to VIMRC directory
    if exists('g:vimrc_dir')
        cd g:vimrc_dir
        let l:vimrc_name = ".vimrc"
    elseif has('gui_running')
        cd $VIMRUNTIME/../../../Data/settings
        let l:vimrc_name = "_vimrc"
    else
        cd $HOME/
        let l:vimrc_name = ".vimrc"
    endif

    " Download repository from which to copy the vimrc
    execute "!git clone " . g:vimrc_github 

    if confirm("Would you like to replace your vimrc for the one downloaded from '" . g:vimrc_github . "'?", "&Yes\n&No") == 1
        " Copy contents of the downloaded vimrc to the current one 
        execute "!cp vimrc/.vimrc " . l:vimrc_name
        echom "[✔] Successfully downloaded latest changes in VIMRC from " . g:vimrc_github . "\n"

    else
        echoerr "[×] Cancelled VIMRC replacement!\n"

    endif

    " Delete local repository
    execute "!rm -rf vimrc"

    " Go back to what was the current directory
    execute 'cd ' . fnameescape(l:current_directory)

endfunction


function! Eatchar(pat)
    let l:c = nr2char(getchar(0))
    return (l:c =~ a:pat) ? '' : c
endfunction

" Define the behavior of specific tags
let s:tags_content = { 
            \   "meta":   " name\=\"\"\ content\=\"\"/>",
            \   "div":    ">\<cr>\<tab>\<cr>\<bs>",
            \   "html":   " lang\=\"en\-US\">\<cr>\<tab>\<cr>\<bs>",
            \   "img":    " src\=\"\"\ alt\=\"\"/>",
            \   "a":      " href\=\"#\">",
            \   "link":   " rel\=\"stylesheet\" type\=\"text/css\" href=\"#\"/>",
            \   "style":  " type\=\"text/css\"\>",
            \   "script": " type\=\"text/javascript\">",
            \   "input":  " name\=\"\" placeholder\=\"\"/>",
            \   "select": " name\=\"\">",
            \   "option": " value\=\"\">",
            \   "!--":    "  -->",
            \   "metas":  "\<bs> charset=\"UTF-8\"/>\<cr>\<cr><title></title>\<cr>\<cr><base href\=\"#\"/>\<cr>\<cr><link rel=\"stylesheet\" type=\"text/css\" href=\"#\"/>\<cr><link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"#\" />\<cr>\<cr><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"/>\<cr><meta name=\"description\" content=\"\"/>\<cr><meta name=\"keywords\" content=\"\"/>\<cr><meta name=\"copyright\" content=\"\" />\<cr><meta name=\"author\" content=\"Author name\" />\<cr><meta http-equiv=\"cache-control\" content=\"no-cache\"/>\<cr><meta property=\"og\:type\" content=\"\"/>\<cr><meta property=\"og\:title\" content=\"\"/>\<cr><meta property=\"og\:description\" content=\"\"/>\<cr><meta property=\"og\:image\" content=\"\"/>\<cr><meta property=\"og\:site_name\" content=\"\"/>"
            \}

let s:self_closing_tags = {
            \   "meta": "true",   "base": "true",
            \   "link": "true",   "img": "true",
            \   "br": "true",     "hr": "true",
            \   "input": "true",  "source": "true",
            \   "embed": "true",  "param": "true",
            \   "wbr": "true",    "area": "true",
            \   "col": "true",    "track": "true" ,
            \   "metas": "true",  "!--": "true" }


function! AutoCompleteTag(mode)
    " inoremap >> ><esc>T<"tyi>f>a</<c-r>t><esc>T>i<c-r>=Eatchar('\s')<cr>

    " Identify how to retrieve the current tag to the 't' register
    if a:mode ==# "n"
        execute "normal! T<\"tyi<"
    elseif a:mode ==# "v"
        " execute "normal! \"ty"
    else
        echo "No mode detected"
    endif

    " Select the contents based on the tags_content dictionary
    let l:tag_content = ">"
    if has_key(s:tags_content, @t)
        let l:tag_content = s:tags_content[@t]
    endif

    " Fill out the tags based on its content and type
    if has_key(s:self_closing_tags, @t)
        execute "normal! f>xa" . l:tag_content
    else
        execute "normal! f>xa" . l:tag_content . "</\<c-r>t>\<esc>F>"
    endif

    " If the tag has a newline character, assume it is a block element
    "   move the cursor to the space provided
    if join(split(l:tag_content, ''), '') =~? "kb"
        execute "normal! \<esc>k"
        return 'cc'
    endif

    return 'a'

endfunction

if has('autocmd')
    augroup CustomFunctions
        autocmd!
        autocmd FileType html,css inoremap <silent> >> ><esc>:call feedkeys(AutoCompleteTag('n'), 'n')<cr>
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not run inoremap <silent> >> ><esc>:call feedkeys(AutoCompleteTag('n'), 'n')<cr>"
endif

" Function used to remove unlisted buffers quickly 
function! DeleteUnlistedBuffers()
    execute "bwipeout! " . join(filter(range(1, bufnr('$')), 'buflisted(v:val) == 0'), " ")
endfunction

" Function used to change the present working directory to the current file's
function! CDCurrent()
    execute "cd %:p:h"
endfunction

" Function used to locally change the present working directory to the current file's
function! LCDCurrent()
    execute "lcd %:p:h"
endfunction

" Function used to clear all registers quickly
function! ClearAllRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"*', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
    execute "registers"
endfunction

" Function used to run the code in several ways as long as it is a supported 
" filetype 
function! RunCode()
    if has("terminal")
        " Full path to current program
        let l:full_path = shellescape(expand('%:p'))

        " Python --- Python --- Python --- Python --- Python --- Python ------
        if &filetype == 'python'

            write

            let l:current_buffer = bufwinnr("%")

            " Close all open terminals
            let l:terminal_buffers = term_list()
            if len(l:terminal_buffers) > 0
                execute "bwipeout! " . join(l:terminal_buffers, " ") 
            endif

            " Create new terminal
            if GetFontSize() > 12
                execute "vert term ++kill=term ++close"
            else
                execute "term ++kill=term ++close"
            endif

            let l:output = [
                        \ "conda activate " . g:conda_environment,
                        \ "python " . l:full_path
                        \ ]

            call term_sendkeys(get(term_list(), 0), join(l:output, "\<cr>") . "\<cr>")
            echom join(l:output, "\<cr>")

            " execute l:current_buffer ."wincmd w"
            " Python --- Python --- Python --- Python --- Python --- Python ------
        elseif &filetype == 'arduino'
            " Arduino --- Arduino --- Arduino --- Arduino --- Arduino ------------
            write
            " Minimize vim to focus on Arduino IDE
            execute "simalt ~n"
            " Arduino --- Arduino --- Arduino --- Arduino --- Arduino ------------
        elseif &filetype == 'javascript'
            echo("JS")
            execute "!node " . l:full_path 
        else
            echoerr "[×] I don't know how to run the file"
        endif

    else
        echoerr "[×] ERROR: NO TERMINAL - Could not run code without integrated terminal"
    endif

endfunction

nnoremap <silent> <c-enter> :call RunCode()<cr>
inoremap <silent> <c-enter> <esc>:call RunCode()<cr>


function! SetFontSize(size)
    if has('gui_running')

        let l:minfontsize = 10
        let l:maxfontsize = 40
        let l:fontname = substitute(&guifont,  '\(\S*\):h\(\d\d\)\(\S*\)', '\1', '')
        let l:information = substitute(&guifont, '\(\S*\):h\(\d\d\)\(\S*\)', '\3', '')

        let l:newsize = a:size
        if(l:newsize < l:minfontsize)
            let l:newsize = l:minfontsize
        elseif(l:maxfontsize < l:newsize)
            let l:newsize = l:maxfontsize
        endif

        let l:newfont = l:fontname . ":h" . l:newsize . l:information
        let &guifont = l:newfont

    else
        echoerr "You need to run the GTK2 version of Vim to use this function."
    endif
endfunction

function! AdjustFontSize(amount)
    let l:cursize = substitute(&guifont, '\(\S*\):h\(\d\d\)\(\S*\)', '\2', '')
    call SetFontSize(l:cursize + a:amount)
endfunction

function! GetFontSize()
    return substitute(&guifont, '\(\S*\):h\(\d\d\)\(\S*\)', '\2', '')
endfunction

nnoremap <silent> <m-.> :call AdjustFontSize(1)<cr>:redraw<cr>:echo "Font size: " . GetFontSize()<cr>
nnoremap <silent> <m-,> :call AdjustFontSize(-1)<cr>:redraw<cr>:echo "Font size: " . GetFontSize()<cr>

function! CreateList()
    let l:separators = ['.', ')', '-']
    let l:regex = '^\(\s*\)\(\d\{1,\}\)\([' . join(l:separators, '') . ']\).*$'

    let l:previous_line = getline(line('.')-1)
    if l:previous_line =~? l:regex
        let l:whitespace = substitute(l:previous_line, l:regex, '\1', '')
        let l:number = substitute(l:previous_line, l:regex, '\2', '')
        let l:separator = substitute(l:previous_line, l:regex, '\3', '')
        execute "normal! cc" . (l:number + 1) . l:separator . " "
    endif
endfunc




" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" III. Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1) Setup {{{

call plug#begin('$VIMRUNTIME/plugged')

Plug 'kyuhi/vim-emoji-complete'

Plug 'itchyny/lightline.vim'
Plug 'webdevel/tabulous'


Plug 'w0rp/ale'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Plug 'skywind3000/asyncrun.vim'
"
Plug 'vim-scripts/auto-pairs-gentle'
Plug 'scrooloose/nerdcommenter'
Plug 'simeji/winresizer'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'

" Plug 'sonph/onehalf'
Plug 'jacoborus/tender.vim'
Plug 'tomasr/molokai'

Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'

Plug 'mhinz/vim-startify'

call plug#end()


" }}}
" 2) ALE {{{
let g:ale_enabled = 1
let g:ale_fix_on_save = 0
let g:ale_lint_delay = 500
let g:ale_lint_on_enter = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_list_vertical = 1
let g:ale_set_highlights = 1
let g:ale_warn_about_trailing_whitespace = 1
let g:ale_virtualtext_cursor = 1

let g:ale_sign_error = '×'

let g:ale_linters = {
            \ 'python': ['pyflakes'],
            \ 'javascript': ['eslint']
            \ }

" nmap <silent> <leader>gd :ALEGoToTypeDefinitionInVSplit<cr>
" nmap <silent> <leader>gdt :ALEGoToTypeDefinitionInTab<cr>
" nmap <silent> <leader>gds :ALEGoToTypeDefinitionInSplit<cr>
" nmap <silent> <leader>fr :ALEFindReferences<cr>
nmap <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>


" }}}
" 3) AutoPairs {{{
let g:AutoPairsFlyMode = 0
let g:AutoPairsUseInsertedCount = 1
let g:AutoPairsMapCh = 0

if has('autocmd')
    augroup ALE
        autocmd!
        autocmd VimEnter unmap <M-p>
        autocmd VimEnter unmap <M-e>
        autocmd VimEnter unmap <M-n>
        autocmd VimEnter unmap <M-b>
        autocmd VimEnter unmap <c-h>
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not unmap unwanted auto-pairs shortcuts"
endif


" }}}
" 4) EasyMotion {{{
nmap <leader><leader>s <Plug>(easymotion-overwin-f)
nmap <leader><leader>l <Plug>(easymotion-overwin-line)
nmap <leader><leader>w <Plug>(easymotion-overwin-w)


" }}}
" 5) Emmet {{{
let g:user_emmet_install_global = 0
" Only enable Emmet in normal mode functions.
let g:user_emmet_mode='n'
" Set Emmet leader key
let g:user_emmet_leader_key= mapleader.'e'

if has('autocmd')
    augroup EMMET
        autocmd!
        " Create Emmet mappings to current buffer
        autocmd FileType html,css EmmetInstall
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not run 'Emmet Install'"
endif


" }}}
" 6) FZF {{{
nnoremap <c-p> :Files<cr>
inoremap <c-p> :Files<cr>
let $FZF_DEFAULT_COMMAND = 'fd -HL -c="always" '
let $FZF_CTRL_T_COMMAND = $FZF_DEFAULT_COMMAND
let $FZF_DEFAULT_OPTS = '--preview="head -10 {}" --inline-info '
if has('autocmd')
    augroup FZF
        autocmd!
        autocmd FileType fzf tnoremap <esc> <c-q>
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not map fzf commands"
endif

let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

let g:fzf_layout = { 'down': '~10' }

" Commands
" <cr> - Current window
" <c-k> - Selection up
" <c-j> - Selection down
" <c-v> - Vertical Split
" <c-x> - Horizontal Split
" <c-t> - New tab

" }}}
" 7) Lightline {{{
let g:lightline = {
            \ 'colorscheme': 'wombat'
            \ }
if has('autocmd')

    augroup Lightline
        autocmd!
        autocmd BufEnter * execute "call lightline#enable()" 
    augroup END
endif

" Status line tutorial from https://shapeshed.com/vim-statuslines/
" Colors: #DiffText# (Red), #WildMenu# (Yellow), #DiffAdd# (Blue),
" #SpellRare# (Purple), #Visual# (white)
" set statusline=
" set statusline+=%#MoreMsg#
" set statusline+=\ %t\ 
" set statusline+=%#MoreMsg#
" set statusline+=%m
" set statusline+=%#Question#
" set statusline+=%r
" set statusline+=%#PmenuSel#
" set statusline+=%=\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})
" set statusline+=%#MoreMsg#
" set statusline+=%y
" set statusline+=%#DiffAdd#
" set statusline+=\ %l:%v\ 
" set statusline+=%#SpellRare#
" set statusline+=\ %P\ 


" }}}
" 8) Matchit {{{
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif


" }}}
" 9) NETRW {{{
" https://blog.stevenocchipinti.com/2016/12/28/using-netrw-instead-of-nerdtree-for-vim/
" http://vimcasts.org/episodes/the-file-explorer/
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_winsize = 50
let g:netrw_altv = 1

let g:netrw_menu = 0
let g:netrw_preview = 1

let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

nnoremap <silent> <leader>nn :Explore<cr>
nnoremap <silent> <leader>nt :Texplore<cr>
nnoremap <silent> <leader>no :Sexplore<cr>
nnoremap <silent> <leader>nv :Vexplore!<cr>

if has('autocmd')
    augroup vim_netrw
        autocmd!

        " Display information on file after every upwards motion
        autocmd filetype netrw nmap <buffer> k kqf

        " Display information on file after every downwards motion
        autocmd filetype netrw nmap <buffer> j jqf

        " Create file with lowercase a
        autocmd filetype netrw nmap <buffer> a %

        " Go up a directory with lowercase u
        autocmd filetype netrw nmap <buffer> u -

        " Refresh directory listing with f5
        autocmd filetype netrw nmap <buffer> <f5> <c-l>

    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not map netrw commands"
endif


" Other commands
" Shortcut               Command
"    c         change to current browsing directory
"    d         create new directory
"    D         Delete file
"    R         Rename file
"    o         Open file in horizontal split
"    p         Open file preview
"    t         Open file in new tab
"    v         Open file in vertical split


" }}}
" 10) NerdCommenter {{{
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 0
let g:NERDCommentEmptyLines = 0
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCreateDefaultMappings = 0

nnoremap <silent> <leader>cc :call NERDComment('n', 'invert')<cr>
vnoremap <silent> <leader>cc :call NERDComment('x', 'invert')<cr>
nnoremap <silent> <leader>ca :call NERDComment('n', 'comment')<cr>
vnoremap <silent> <leader>ca :call NERDComment('x', 'comment')<cr>
nnoremap <silent> <leader>cd :call NERDComment('n', 'uncomment')<cr>
vnoremap <silent> <leader>cd :call NERDComment('x', 'uncomment')<cr>
nnoremap <silent> <leader>cy :call NERDComment('n', 'yank')<cr>
vnoremap <silent> <leader>cy :call NERDComment('x', 'yank')<cr>
" }}}
" 11) Startify {{{
let g:startify_session_dir = expand('$VIMRUNTIME/sessions') 
let g:startify_lists = [
            \ {'type': 'sessions', 'header':['     Sessions']},
            \ {'type': 'files', 'header':['     Files']},
            \ {'type': 'dir', 'header':['     Files in ' . getcwd()]},
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]
let g:startify_files_number = 30
let g:startify_change_to_dir = 1
let g:startify_padding_left = 5
let g:startify_custom_indices = ['cc', 'dd', 'mm', 'nn', 'pp', 'rr', 'ww', 'xx', 'yy', 'zz']

function! PLUGINS_ResetStartifyCustomHeader()
    let s:startify_left_margin = repeat(' ', (&columns - 63)/2)

    let g:startify_custom_header = [
                \ s:startify_left_margin . ' ___      ___ ___  _____ ______           ________    _____     ',
                \ s:startify_left_margin . '|\  \    /  /|\  \|\   _ \  _   \        |\   __  \  / __  \    ',
                \ s:startify_left_margin . '\ \  \  /  / \ \  \ \  \\\__\ \  \       \ \  \|\  \|\/_|\  \   ',
                \ s:startify_left_margin . ' \ \  \/  / / \ \  \ \  \\|__| \  \       \ \   __  \|/ \ \  \  ',
                \ s:startify_left_margin . '  \ \    / /   \ \  \ \  \    \ \  \       \ \  \|\  \ __\ \  \ ',
                \ s:startify_left_margin . '   \  __/ /     \ \__\ \__\    \ \__\       \ \_______|\__\ \__\',
                \ s:startify_left_margin . '    \|__|/       \|__|\|__|     \|__|        \|_______\|__|\|__|',
                \ s:startify_left_margin . '                                                                ',
                \ s:startify_left_margin . '                                                                ',
                \ ]
    Startify
endfunction


if has('autocmd')
    augroup Startify
        autocmd!
        autocmd VimEnter * if &filetype == "startify" | call PLUGINS_ResetStartifyCustomHeader() | endif
        autocmd VimResized * if &filetype == "startify" | call PLUGINS_ResetStartifyCustomHeader() | endif
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Cannot automatically reset Startify Custom Header"
endif


" }}}
" 12) Winresizer {{{
let g:winresizer_enable = 1
let g:winresizer_finish_with_escape = 1
let g:winresizer_vert_resize = 5
let g:winresizer_horiz_resize = 2

nnoremap <leader>w :WinResizerStartFocus<cr>

if has('autocmd')
    augroup Winresizer
        autocmd!
        autocmd VimEnter unmap <C-E>
        autocmd VimEnter unmap <C-a>
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not unmap unwanted winresizer shortcuts"
endif


" }}}


if !empty(glob('/c/Users/m4rc0/Documents'))
    cd /c/Users/m4rc0/Documents
elseif !empty(glob('C:/Users/m4rc0/Documents'))
    cd C:/Users/m4rc0/Documents
endif


" vim:foldmethod=marker:foldlevel=0
