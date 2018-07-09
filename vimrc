set nocompatible                " vi compatible is LAME

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  "Set UTF-8 as the default encoding for commit messages
  autocmd BufReadPre COMMIT_EDITMSG,MERGE_MSG,git-rebase-todo setlocal fileencodings=utf-8

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


  " =============================================== Commands for vim surround ================================================
  augroup vim_surround
    autocmd!

    " Map change surrounding to <leader>cs and eliminate the cs command
    autocmd VimEnter * nmap <leader>cs cs " Map change surrounding to <leader>cs and eliminate the cs command

    " Map delete surrounding to <leader>ds and eliminate the ds command
    autocmd VimEnter * nmap <leader>ds ds

    " Map add surrounding to <leader>as and eliminate ysiw
    autocmd VimEnter * nmap <leader>as ysiw

    " Map surround line to <leader>sl and eliminate yss
    autocmd VimEnter * nmap <leader>sl yss

    " Map surround selection to <leader>s and eliminate S
    autocmd VimEnter * imap <leader>s S

    " Close vim if the only window left open is a NERDTree?
    " autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END

endif "has("autocmd")



" ================================================= Plugins ================================================= 
call plug#begin('$VIM/vim80/plugin')
  " Declare list of plugins
  Plug 'junegunn/vim-emoji'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'SirVer/ultisnips'
  Plug 'scrooloose/nerdtree'
  " List ends here. Plugins become visible to VIM
call plug#end()

set completefunc=emoji#complete

function ReplaceWithEmoji()
  %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
endfunction

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

" <leader>U toggles the case of the current WORD
nnoremap <leader>U BviW~<space><esc>

" Big jump left (to first non-blank character)
nnoremap <leader>h g^<space>

" Big jump right (to last non-blank character)
nnoremap <leader>l g_<cr>

" Remap ev to edit vimrc file
nnoremap <leader>ev :tabedit /c/Program\ Files/Git/etc/vimrc<cr>

" Remap sv to "refresh" vimrc
nnoremap <leader>sv :source /c/Program\ Files/Git/etc/vimrc<cr>

" ================================================== Buffers ==================================================
set hidden

" ================================================== Dictionaries ==================================================
set spell spelllang=en,es
set dictionary="$VIM/vim80/spell"
" For making everything utf-8
set enc=utf-8

" ================================================== Interface ================================================== 
set number                      " Add line numbers
set numberwidth=4               " Set line number width
set showmode                    " show the current mode
set title
syntax on                       " turn syntax highlighting on by default
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

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
set tabstop=2
set shiftwidth=2
set softtabstop=4
set expandtab
set noshiftround

" ================================================== Searching ==================================================
set hlsearch
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
set timeoutlen=500              " how long it wait for mapped commands

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

" ================================================== NERDtree ====================================================
nnoremap <leader>nt :NERDTreeToggle<cr>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'


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
