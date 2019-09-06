set nocompatible                " vi compatible is LAME

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I. Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I. Configuration
" 1) Quick variable initialization {{{

" Store the VIMRUNTIME directory in a variable for later use
let s:vim_runtime_directory = ""
if getfperm(s:vim_runtime_directory)[4] == '-' && expand($USER) != "root"
    let s:vim_runtime_directory = expand('$VIMRUNTIME')
else
    let s:vim_runtime_directory = expand('$HOME/.vim')
endif

" Store the directory separator in a variable for later use
let s:directory_separator = (match(s:vim_runtime_directory, "\/") >= 0) ? '/' : '\'

" Generate path from $VIMRUNTIME depending on its directory and separators
function! FromRuntime(...)
    " Begin preparing output_directory local variable
    let l:output_directory = s:vim_runtime_directory

    " Iterate through each element in function parameter list 
    for level in a:000
        " Append separator to output_directory ... 
        let l:output_directory .= s:directory_separator
        if exists("*trim")
            " And append trimmed directory level
            let l:output_directory .= trim(level)
        else
            let l:output_directory .= level
        endif
    endfor

    return fnameescape(l:output_directory)
endfunction

" Store the VIMRC path to a variable
let g:vimrc_path = expand('$HOME/.vimrc')


" }}}
" 2) Buffers {{{
set hidden              " Do not erase a buffer when abandoned
set viminfo='999,<50,s10,h,%,/0,:99,@99
filetype plugin indent on


" }}}
" 3) Windows {{{
set splitbelow
set splitright


" }}}
" 4) Interface {{{
set number                      " Add line numbers
set relativenumber              " Add relative line numbers
set numberwidth=4               " Set line number width
set noshowmode                  " Do not show the current mode
set showcmd                     " Show currently-typed command
set title                       " Show tab titles
set noerrorbells                " Do not use error bells when doing something wrong
set novisualbell                " Do not use visual bell either when doing something wrong
set laststatus=2                " Make the last line where the status is two lines deep so you can see status always
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set clipboard=unnamed           " Set clipboard to unnamed to access the system clipboard under Windows
set scrolloff=2                 " Add space around the cursor when going off screen
set sidescrolloff=2             " Add space beside the cursor when going off screen
set binary                      " Used to edit binary files
set ruler                       " Show the cursor position all the time
set confirm                     " Confirm commands instead of throwing errors
set cmdheight=2                 " Make the ex command line 2 lines high
set t_Co=256                    " Make sure Vim is using 256 colors
set ttyfast                     " Smoother screen redraw
set lazyredraw                  " The screen will not be redrawn so frequently
set wildmenu                    " Show recommendations in the ex command line
syntax on                       " Turn syntax highlighting on by default
" set foldcolumn=1                " Add a little margin to the left

" Enable the use of mice if they are available
if has('mouse')
    set mouse=a
endif

" For making everything UTF-8
set encoding=utf-8
let &termencoding = &encoding
let &fileencoding = &encoding
let &fileencodings = &encoding

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
" 5) GUI {{{
if has("gui_running")
    set guioptions=chkM            " Remove menubar and other disturbing items in gVIM
    set guifont=DejaVu\ Sans\ Mono:h12qDEFAULT
    set t_Co=256
    set cursorline                  " Highlight line with cursor
    set cursorcolumn                " Highlight column with cursor
    " Maximize the screen on enter if has autocmd
    if has('autocmd')
        augroup GUI
            autocmd!
            " Download dlls from https://github.com/mattn/vimtweak
            autocmd VimEnter * 
                        \ if !empty("vimtweak32.dll") |
                        \ silent! call libcallnr("vimtweak32.dll", "EnableCaption", 0) |
                        \ silent! call libcallnr("vimtweak32.dll", "EnableMaximize", 1) |
                        \ endif
        augroup END
    else
        echoerr "[×] ERROR: NO AUTOCMD - Did not maximize window"
    endif
endif


" }}}
" 6) Themes {{{

if has('autocmd')
    augroup Themes
        autocmd!
        " autocmd VimEnter * colorscheme tender
        " autocmd VimEnter * colorscheme onehalfdark
        autocmd VimEnter * silent! colorscheme monokai
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not set colorscheme"
endif


" }}}
" 7) Searching {{{
set incsearch           " Show temporary search results as being typed
set ignorecase
set smartcase           " Ignore case when pattern contains lower-case letters
set showmatch           " Automatically show matching brackets.
set magic               " Easier use of regex for searching
" set gdefault            " Always use g flag on substitutions


" }}}
" 8) Dictionaries {{{
if has('spell')
    let s:spell_directory = FromRuntime("spell")
    if !isdirectory(s:spell_directory) && exists("*mkdir")
        call mkdir(s:spell_directory, "p")
    endif

    let &dictionary = s:spell_directory
    let &thesaurus .= FromRuntime("spell", "en_thesaurus.txt")
    set spell
    set spelllang=en,es
else
    echoerr "[×] ERROR: NO SPELL - Could not configure spell check"
endif

" ]s - Next spell error
" [s - Previous spell error
" zg - Add word to dictionary
" zw - Remove word from dictionary


" }}}
" 9) History and file handling {{{
set history=999             " Increase history (default = 20)
set undolevels=999          " More undo (default=100)
if has('persistent_undo')
    let s:undo_directory = FromRuntime("temp", "undo")
    if !isdirectory(s:undo_directory) && exists("*mkdir")
        call mkdir(s:undo_directory, "p")
    endif

    let &undodir=s:undo_directory
    set undofile
else
    echoerr "[×] ERROR: NO PERSISTENT UNDO - Could not set up persistent undo"
endif


" }}}
" 10) Whitespace {{{
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

set tabstop=4
set softtabstop=4                       " Show existing tab with 4 spaces width
set shiftwidth=4                        " When indenting with '>', use 4 spaces width
set expandtab                           " On pressing tab, insert 4 spaces
set noshiftround
set nostartofline                       " Make sure cursor remains where it is


" }}}
" 11) Keys {{{
set backspace=indent,eol,start      " Allow backspacing over everything.
set timeoutlen=2000                 " How long it wait for mapped commands


" }}}
" 12) Autocomplete {{{
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
" 13) Code folding {{{
if has('folding')
    set foldenable              " Enable code folding and show all folds
    set foldmethod=manual
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
" 14) Diff {{{
if has('autocmd')
    augroup Diff
        autocmd!
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

    augroup END
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
" 15) Backup and Swap Files {{{
set nobackup
set nowritebackup
set noswapfile


" }}}
" 16) Sessions {{{
if has('mksession')
    if has('autocmd')
        let s:session_options = [
                    \ "blank",
                    \ "buffers",
                    \ "curdir",
                    \ "folds",
                    \ "globals",
                    \ "resize",
                    \ "tabpages",
                    \ "terminal",
                    \ "winpos",
                    \ "winsize"
                    \ ]

        let s:session_options = join(s:session_options, ",")
        let s:session_options = fnameescape(s:session_options)

        augroup Sessions
            autocmd!
            autocmd VimEnter * let &sessionoptions = s:session_options
        augroup END
    else
        echoerr "[×] ERROR: NO AUTOCMD - Did not configure vim sessions"
    endif

    let s:sessions_directory = FromRuntime("temp", "sessions", "")
    execute 'cnoreabbrev mks mksession! ' . s:sessions_directory
else
    echoerr "[×] ERROR: NO SESSIONS - Could not configure vim sessions"
endif


" }}}
" 17) Templates {{{
if has("autocmd")
    let s:templates_directory = FromRuntime("templates")
    if !isdirectory(s:templates_directory) && exists("*mkdir")
        call mkdir(s:templates_directory, "p")
    endif

    augroup Templates
        let s:python_templates = FromRuntime("templates", "skeleton.py")
        autocmd!

        " Python files
        execute "autocmd BufNewFile *.py 0r " . s:python_templates

    augroup END
endif


" }}}
" 18) Terminal {{{
function! DevelopmentEnvironment()
    if has("terminal")
        call SetFontSize(12)
        " Maximize window
        execute "simalt ~x"

        redraw

        tabnew

        Startify
        let l:current_window = bufwinnr('%')

        execute "term ++kill=term ++close ++rows=" . str2nr(&lines) / 4
        execute l:current_window . "wincmd w"

        execute "Vexplore " . &columns / 6
        execute l:current_window + 1 . "wincmd w"


        normal gg
    endif
endfunction


if has("terminal")
    " Use escape or 'jk' key combination instead of <C-\><C-n>
    tnoremap <esc> <C-\><C-n>
    tnoremap jk <C-\><C-n>

    " Prepare command mode mappings which make the use of 'term' less lengthy
    cnoreabbrev term terminal ++kill=term ++curwin ++close
    cnoreabbrev vterm vert terminal ++kill=term ++close
    cnoreabbrev hterm terminal ++kill=term ++close
    cnoreabbrev tterm execute "tabnew<bar>terminal ++kill=term ++curwin ++close"

    let s:programming_directory = FromRuntime("programming")
    if !isdirectory(s:programming_directory) && exists("*mkdir")
        call mkdir(s:programming_directory, "p")
    endif

    let g:conda_environment = "base"
    let g:vimrc_github = "https://github.com/M4rqu1705/vimrc"

    " Prepare PATH variables for ...
    let s:fd_directory = FromRuntime("programming", "fd")
    let s:fzf_directory = FromRuntime("programming", "fzf")
    let s:miktex_directory = FromRuntime("programming", "miktex", "texmfs", "install", "miktex", "bin", "x64")
    let s:ripgrep_directory = FromRuntime("programming", "ripgrep")
    let s:wget_directory = FromRuntime("programming", "wget", "bin")
    let s:mingw_directory = FromRuntime("programming", "mingw", "bin")
    let s:python_directory = FromRuntime("programming", "WPy-3710", "python-3.7.1")
    let s:git_directories = [
                \ FromRuntime("programming", "Git", "bin"),
                \ FromRuntime("programming", "Git", "usr", "bin")
                \ ]

    " Only retain variables if the directories exist
    if !isdirectory(s:fd_directory) | unlet s:fd_directory | endif
    if !isdirectory(s:fzf_directory) | unlet s:fzf_directory | endif
    if !isdirectory(s:miktex_directory) | unlet s:miktex_directory | endif
    if !isdirectory(s:ripgrep_directory) | unlet s:ripgrep_directory | endif
    if !isdirectory(s:wget_directory) | unlet s:wget_directory | endif
    if !isdirectory(s:mingw_directory) | unlet s:mingw_directory | endif
    if !isdirectory(s:python_directory) | unlet s:python_directory | endif
    for directory in s:git_directories
        if !isdirectory(directory)
            unlet s:git_directories
        endif
    endfor

    " Prepare list of programs which will be added to PATH
    let s:relevant_paths = []

    if $PATH !~? "fd" && exists("s:fd_directory")
        call add(s:relevant_paths, s:fd_directory)
    endif
    if $PATH !~? "fzf" && exists("s:fzf_directory")
        call add(s:relevant_paths, s:fzf_directory)
    endif
    if $PATH !~? "miktex" && exists("s:miktex_directory")
        call add(s:relevant_paths, s:miktex_directory)
    endif
    if $PATH !~? "ripgrep" && exists("s:ripgrep_directory")
        call add(s:relevant_paths, s:ripgrep_directory)
    endif
    if $PATH !~? "wget" && exists("s:wget_directory")
        call add(s:relevant_paths, s:wget_directory)
    endif
    if $PATH !~? "mingw" && exists("s:mingw_directory")
        call add(s:relevant_paths, s:mingw_directory)
    endif
    if $PATH !~? "python" && $PATH !~? "conda" && exists("s:python_directory")
        call add(s:relevant_paths, s:python_directory)
    endif
    if $PATH !~? "git" && exists("s:git_directories")
        call add(s:relevant_paths, join(s:git_directories, ";"))
    endif

    if has('autocmd')
        augroup Terminal
            autocmd!
            autocmd SourcePre *vimrc if !exists('g:path_was_set') |
                        \ let $PATH = join(s:relevant_paths, ";") . ";" . $PATH |
                        \ let g:path_was_set = 1 |
                        \ endif

            " Automatically resize terminal when in and out of focus if there
            " are more than one buffer in window
            autocmd BufEnter * if &buftype == 'terminal' && winnr() > 1 |
                        \       if winheight(0) > winwidth(0)  * (&lines * 1.0/&columns) |
                        \            execute "vert resize " . (&columns * 1/2) |
                        \       else |
                        \            execute "resize " . (&lines * 1/2) |
                        \       endif |
                        \ endif
            autocmd BufLeave * if &buftype == 'terminal' && winnr() > 1 |
                        \       if winheight(0) > winwidth(0) * (&lines * 1.0/&columns) |
                        \            execute "vert resize " . (&columns * 1/4) |
                        \       else |
                        \            execute "resize " . (&lines * 1/4) |
                        \       endif |
                        \ endif
        augroup END
    else
        echoerr "[×] ERROR: NO AUTOCMD - Could not update PATH environment variable"
    endif

else
    echoerr "[×] ERROR: NO TERMINAL - Could not configure terminal settings"
endif

" Set the python3 home and dll directory, crucial to use Python in Vim
if has('python_dynamic')
    let &pythonthreehome = FromRuntime("programming", "WPy-3710", "python-3.7.1")
    let &pythonthreedll = FromRuntime("programming", "WPy-3710", "python-3.7.1", "python37.dll")
endif


" }}}
" 19) Programming {{{
if has('autocmd')
    augroup Programming
        autocmd!

        autocmd BufWinEnter *.py try | execute "normal! gg=G" | execute "%s/\r//g" | catch | echo "" | endtry
        autocmd Filetype *.py let g:jedi#auto_initialization=1

        autocmd BufWinEnter *.html try | execute "normal! gg=G" | execute "%s/\r//g" | catch | echo "" | endtry

    augroup END
endif


function! CodeQuestSetup()
    let g:conda_environment = 'CodeQuest'
    let g:jedi#auto_initialization=1

    if has('autocmd')
        augroup CodeQuest
            autocmd!

            autocmd BufWinEnter *.py try | execute "%s/\r//g" | catch | echo "" | endtry

        augroup END
    endif

endfunction

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


if exists('g:vimrc_path')
    " Remap ev to edit vimrc file
    execute "nnoremap <silent> <leader>ev :tabedit " . g:vimrc_path . "<cr>"

    " Remap lv to "refresh" vimrc
    execute "nnoremap <silent> <leader>lv :source " . g:vimrc_path . "<cr>"
else
    echoerr "[×] ERROR: You need to create `g:vimrc_path` and restart VIM"
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
command! TrimAll call TrimAll()
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

    " First make sure requirements are met
    if !executable("wget")
        echoerr "You do not have wget. Install it for Windows through:\n"
                    \ . "http://gnuwin32.sourceforge.net/packages/wget.htm\n"
                    \ . "and put executable inside `$VIMRUNTIME/programming`\n"
                    \ . "or Google search for an alternative\n"
        return ""
    endif

    if !executable("git")
        echoerr "You do not have git. Install it for Windows through:\n"
                    \ . "https://git-scm.com/download\n"
                    \ . "and put executable inside `$VIMRUNTIME/programming`\n"
        return ""
    endif


    " Vim Plug
    if confirm("Do you want to download Vim Plug?", "&Yes\n&No") == 1

        " Where to download Vim Plug
        let l:vim_autoload = FromRuntime("autoload")
        " From where to download Vim Plug
        let l:vim_plug_link = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

        " Download Vim Plug to desired directory
        execute "!wget ". l:vim_plug_link . " -P " . l:vim_autoload

        echom "[!] DO NOT FORGET TO RUN 'PlugInstall'\n"
        echohl DiffAdd
        echom "[✔] Successfully downloaded and installed Vim Plug!\n"
        echohl Normal

    else
        echoerr "[×] Did not install Vim Plug\n"

    endif

    if confirm("Do you want to create templates/skeleton files?", "&Yes\n&No") == 1

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
                    \ "__version__ = '1.0'\n" .
                    \ "\n" .
                    \ "\n" .
                    \ "def main():\n" .
                    \ "# Your code goes here"
                    \ "\n" .
                    \ "\n" .
                    \ "\n" .
                    \ "# Your code goes here"
                    \ "\n" .
                    \ "\n" .
                    \ "if __name__ == '__main__':\n" .
                    \ "\tmain()"

        execute "tabnew " . FromRuntime("templates", "skeleton.py") . " | normal! ggVGc" . l:contents . "\<esc>:wq!\<cr>"

        " Add more templates ....

        echohl DiffAdd
        echom "[✔] Successfully created skeleton files!\n"
        echohl Normal

    else
        echoerr "[×] Did not create templates/skeleton files\n"

    endif

    if confirm("Do you want to download spell files?", "&Yes\n&No") == 1

        if has('spell')
            " Where to download these spell files

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
            execute "!wget -P " . join(g:links, " " . s:spell_directory . " ")

            echohl DiffAdd
            echom "[✔] Successfully downloaded spell files!\n"
            echohl Normal

        else
            echoerr "[×] ERROR: NO SPELL - Did not download dictionaries"

        endif
    else
        echoerr "[×] Did not download spell files\n"

    endif

    if !executable("fd")
        echom "You do not have fd. Please, try to Install it for \n"
                    \ . "Windows from: https://github.com/sharkdp/fd/releases\n"
                    \ . "and put executable inside `$VIMRUNTIME/programming`\n"
        return ""
    endif

    if !executable("fzf")
        echom "You do not have fzf. Please, try to Install it for \n"
                    \ . "Windows from: https://github.com/junegunn/fzf-bin/releases\n"
                    \ . "and put executable inside `$VIMRUNTIME/programming`\n"
        return ""
    endif

    if !executable("ripgrep")
        echom "You do not have ripgrep. Please, try to Install it for \n"
                    \ . "Windows from: https://github.com/BurntSushi/ripgrep/releases\n"
                    \ . "and put executable inside `$VIMRUNTIME/programming`\n"
        return ""
    endif

    if !executable("ripgrep")
        echom "You do not have ripgrep. Please, try to Install it for \n"
                    \ . "Windows from: https://github.com/BurntSushi/ripgrep/releases\n"
                    \ . "and put executable inside `$VIMRUNTIME/programming`\n"
        return ""
    endif

    if !executable("python") && !executable("python3")
        echom "You do not have python. Please, try to Install it for \n"
                    \ . "Windows from: https://winpython.github.io/\n"
                    \. "or https://www.python.org/downloads/ and then put"
                    \ . "extracted files inside `$VIMRUNTIME/programming`\n"
        return ""
    endif

    if !executable("gcc") && !executable("g++")
        echom "You do not have mingw. Please, try to Install it for \n"
                    \ . "Windows from: http://www.mingw.org/download/installer\n"
                    \. "or https://portableapps.com/node/18601 and then put"
                    \ . "extracted files inside `$VIMRUNTIME/programming`\n"
        return ""
    endif


endfunction


" Upload current local vimrc to github repository
function! UploadVIMRC()
    if !executable("git")
        echoerr "You do not have git. Install it for Windows through:\n"
                    \ . "https://git-scm.com/download\n"
                    \ . "and put executable inside `$VIMRUNTIME/programming`\n"
        return ""
    endif


    let l:current_directory = getcwd()

    " Change to VIMRC directory
    execute "cd " . fnamemodify(g:vimrc_path, ":h")

    " Download repository to which to copy and upload current vimrc
    execute "!git clone " . g:vimrc_github
    " Copy current vimrc to downloaded repository
    execute "!cp " . fnamemodify(g:vimrc_path,':t') . " vimrc/.vimrc "

    " Change to local repository's directory for git commands
    cd vimrc

    if confirm("Are you sure you want to upload the latest changes to '" . g:vimrc_github . "'?", "&Yes\n&No") == 1

        " Add contents to staging area, commit them, and upload them
        execute "!git add ."
        execute "!git commit"
        execute "!git push -fu origin master"

        echohl DiffAdd
        echom "[✔] Successfully uploaded latest changes in VIMRC to " . g:vimrc_github . "\n"
        echohl Normal

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

    let l:current_directory = getcwd()

    " Change to VIMRC directory
    cd fnamemodify(g:vimrc_path, ":h")

    " Download repository from which to copy the vimrc
    execute "!git clone " . g:vimrc_github

    if confirm("Would you like to replace your vimrc for the one downloaded from '" . g:vimrc_github . "'?", "&Yes\n&No") == 1
        " Copy contents of the downloaded vimrc to the current one
        execute "!cp vimrc/.vimrc " . fnamemodify(g:vimrc_path,':t')
        echohl DiffAdd
        echom "[✔] Successfully downloaded latest changes in VIMRC from " . g:vimrc_github . "\n"
        echohl Normal

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
            \   "div":    ">\<cr>\<tab>\<cr>",
            \   "html":   " lang\=\"en-US\">\<cr>\<tab>\<cr>",
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
        autocmd FileType html,css,javascript,php inoremap <silent> >> ><esc>:call feedkeys(AutoCompleteTag('n'), 'n')<cr>
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

" Function used to trim all trailing whitespaces in current file
function! TrimAll()
    try
        execute '%s/\s\+$//'
    catch
        echo "Done!"
    endtry
    try
        execute '%s/\r//'
    catch
        echo "Done!"
    endtry
endfunction

" Function used to clear all registers quickly
function! ClearAllRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"*', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
    execute "registers"
endfunction

" Function which will soon be used to open dynamic terminal window and run code
function! RunCodeDynamically(output)
    " Save file
    write

    " Prepare info and variables for later
    let l:current_buffer = bufwinnr('%')
    let l:terminal_buffer = -1

    " Check if terminal in window already
    if len(term_list()) > 0                     " If there exists terminals
        for termNum in term_list()              " Cycle through them
            if index(tabpagebuflist(), termNum) >= 0    " If term number inside tabpage buffer list
                execute bufwinnr(termNum) . "wincmd w"
                let l:terminal_buffer = termNum
                break
            else
            endif
        endfor
    endif

    " Open a new terminal window if no terminal in tabpage
    if l:terminal_buffer < 0
        if len( term_list() ) > 0
            execute "bwipeout! " . join(term_list(), " ")
        endif

        if GetFontSize() > 12
            execute "vert terminal ++kill=term ++close"
        else
            execute "terminal ++kill=term ++close"
        endif

        let l:terminal_buffer = get(term_list(), 0)
    else
        " If no need to open a new terminal, reset a currently open one
        call term_sendkeys(l:terminal_buffer, "\<c-c>\<cr>clear\<cr>")
    endif

    " Send commands to the established terminal
    call term_sendkeys(l:terminal_buffer, join(a:output, "\<cr>") . "\<cr>")

    " execute l:current_buffer ."wincmd w"
endfunction


" Function used to run the code in several ways as long as it is a supported filetypes
function! RunCode()
    if has("terminal")
        " Full path to current program
        let l:full_path = shellescape(expand('%:p'))


        if &filetype == 'python'
            " Python --- Python --- Python --- Python --- Python --- Python ------

            let l:commands = [
                        \ "conda activate " . g:conda_environment,
                        \ "python " . l:full_path
                        \ ]
            " Send these commands to another function to actually be run
            call RunCodeDynamically(l:commands)

            " Python --- Python --- Python --- Python --- Python --- Python ------

        elseif &filetype == 'arduino'
            " Arduino --- Arduino --- Arduino --- Arduino --- Arduino ------------
            write

            let l:runCodeScript = fnameescape(expand('$VIMRUNTIME/macros/runCode/compileAndDownloadToArduino.py'))
            execute "py3file " . l:runCodeScript

            " Arduino --- Arduino --- Arduino --- Arduino --- Arduino ------------

        elseif &filetype == 'tex' || &filetype == 'plaintex'
            " LaTEX --- LaTEX --- LaTEX --- LaTEX --- LaTEX --- LaTEX ------------
            let l:commands = [
                        \ "texify --pdf --run-viewer " . l:full_path
                        \ ]
            " Send these commands to another function to actually be run
            call RunCodeDynamically(l:commands)

            " LaTEX --- LaTEX --- LaTEX --- LaTEX --- LaTEX --- LaTEX ------------

        elseif &filetype == 'html' || &filetype == 'css' || &filetype == 'php' || &filetype == 'markdown'
            " HTML --- CSS --- PHP --- Markdown --- HTML --- CSS --- PHP ---------
            write

            let l:runCodeScript = fnameescape(expand('$VIMRUNTIME/macros/runCode/changeAndRefreshScreen.py'))
            execute "py3file " . l:runCodeScript

            " HTML --- CSS --- PHP --- Markdown --- HTML --- CSS --- PHP ---------

        elseif &filetype == 'javascript'
            echo("JS")
            execute "!node " . l:full_path

        elseif &filetype == 'cpp' || &filetype == 'c'
            " C --- C++ --- C --- C++ --- C --- C++ --- C --- C++ --- C --------
            let l:commands = [
                        \ "g++ " . l:full_path,
                        \ "a.exe"
                        \ ]
            " Send these commands to another function to actually be run
            call RunCodeDynamically(l:commands)

            " C --- C++ --- C --- C++ --- C --- C++ --- C --- C++ --- C --------
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
        let l:fontname = substitute(&guifont, '\v(.+):h(\d+)(.+)', '\1', '')
        let l:information = substitute(&guifont, '\v(.+):h(\d+)(.+)', '\3', '')

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

function! GetFontSize()
    return substitute(&guifont, '\v(.+):h(\d+)(.+)', '\2', '')
endfunction

nnoremap <silent> <m-.> :call SetFontSize(GetFontSize() + 1)<cr>:redraw<cr>:echo "Font size: " . GetFontSize()<cr>
nnoremap <silent> <m-,> :call SetFontSize(GetFontSize() - 1)<cr>:redraw<cr>:echo "Font size: " . GetFontSize()<cr>


" Work in progres ...
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
endfunction


" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" III. Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1) Setup {{{

call plug#begin(FromRuntime('plugged'))
" Interface
Plug 'itchyny/lightline.vim'
Plug 'webdevel/tabulous'

" General programming tools
" Plug 'w0rp/ale'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Plug 'skywind3000/asyncrun.vim'
Plug 'vim-scripts/auto-pairs-gentle'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'

" Themes
" Plug 'sonph/onehalf'
Plug 'jacoborus/tender.vim'
Plug 'crusoexia/vim-monokai'

" Speciic programming tools
" HTML
Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'

" CSS
Plug 'ap/vim-css-color'

" PHP
Plug 'StanAngeloff/php.vim'

" Python
Plug 'davidhalter/jedi-vim'

" LaTEX
Plug 'gi1242/vim-tex-syntax'

call plug#end()


" }}}
" 2) ALE {{{
" let g:ale_enabled = 1
" let g:ale_fix_on_save = 0
" let g:ale_lint_delay = 0
" let g:ale_lint_on_enter = 1
" let g:ale_lint_on_insert_leave = 1
" let g:ale_lint_on_save = 1
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_list_vertical = 1
" let g:ale_set_highlights = 1
" let g:ale_warn_about_trailing_whitespace = 1
" let g:ale_virtualtext_cursor = 1

" let g:ale_sign_error = '×'

" let g:ale_linters_explicit = 1
let g:ale_linters = {
            \ 'python': ['pyflakes'],
            \ 'javascript': ['eslint'],
            \ }

let g:ale_python_pyflakes_executable = 'python'
let g:ale_open_list=1


" nmap <silent> <leader>gd :ALEGoToTypeDefinitionInVSplit<cr>
" nmap <silent> <leader>gdt :ALEGoToTypeDefinitionInTab<cr>
" nmap <silent> <leader>gds :ALEGoToTypeDefinitionInSplit<cr>
" nmap <silent> <leader>fr :ALEFindReferences<cr>
" nmap <silent> <leader>aj :ALENext<cr>
" nmap <silent> <leader>ak :ALEPrevious<cr>


" }}}
" 3) AutoPairs {{{
let g:AutoPairsFlyMode = 0
let g:AutoPairsUseInsertedCount = 1
let g:AutoPairsMapCh = 0

if has('autocmd')
    augroup AutoPairs
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
let g:user_emmet_mode='a'
" Set Emmet leader key
let g:user_emmet_leader_key= mapleader . 'e'
" Use Emmet as autocompletion engine in HTMl and CSS files
if &filetype == 'html' || &filetype == 'css'
    let g:user_emmet_complete_tag = 1
endif

if has('autocmd')
    augroup EMMET
        autocmd!
        " Create Emmet mappings to current buffer
        autocmd FileType html,css EmmetInstall
    augroup END
else
    echoerr "[×] ERROR: NO AUTOCMD - Could not run 'Emmet Install'"
endif
" Change some Emmet settings
let g:user_emmet_settings = {
            \ 'html' : {
            \ 'quote_char': "'",
            \ },
            \ }


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
" 7) Jedi {{{

let g:jedi#auto_initialization = 1
let g:jedi#use_splits_not_buffers = "left"
let g:jedi#show_call_signatures = 1
let g:jedi#show_call_signatures_delay = 500
let g:jedi#completions_enabled = 1

" }}}
" 8) Lightline {{{
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
" 9) Matchit {{{
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif


" }}}
" 10) NETRW {{{
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
" 11) NerdCommenter {{{
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

try
    cd C:\Users\m4rc0\Documents
catch
    echo "Cannot find C:\\Users\\m4rc0\\Documents"
endtry


" vim:foldmethod=marker:foldlevel=0
