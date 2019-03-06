set nocompatible                " vi compatible is LAME


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


source $VIMRUNTIME/mswin.vim
behave mswin

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


" ================================== Buffers ==================================
set hidden
set viminfo='999,<50,s10,h,%,/0,:99,@99
filetype plugin indent on

" ================================== Windows ==================================
set splitbelow
set splitright

" ================================ Dictionaries ================================
set dictionary=$VIMRUNTIME\spell
set spell spelllang=en,es
set thesaurus+=$VIMRUNTIME\spell\en_thesaurus.txt
" For making everything UTF-8
set encoding=utf-8
let &termencoding = &encoding
set fileencoding=utf-8
set fileencodings=utf-8

" ================================= Interface ================================= 
set number                      " Add line numbers
set numberwidth=5               " Set line number width
set noshowmode                    " show the current mode
set showcmd                     " Show currently-typed command
set title
syntax on                       " turn syntax highlighting on by default
set visualbell                  " turn on the "visual bell" - which is much quieter than the "audio blink"
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
set sidescrolloff=2
set scrolloff=2
set binary
set ttyfast


" ==================================== GUI ====================================

if has("gui_running")
    set guioptions=cRLhb            " Remove menubar and other disturbing items in gVIM
    set guifont=Lucida_Console:h19qANTIALIASED
    set t_Co=256
    set cursorline
    autocmd VimEnter * execute "simalt ~x"
endif


" ================================= Whitespace =================================
set autoindent                          " set auto-indenting on for programming
set wrap
set wrapmargin=2
set textwidth=80 
set linebreak
set showbreak=\.\.\.\ 
set nolist
set formatoptions=nB1lcwt
set virtualedit=insert
set tabstop=4 softtabstop=4             " show existing tab with 4 spaces width
set shiftwidth=4                        " when indenting with '>', use 4 spaces width
set expandtab                           " On pressing tab, insert 4 spaces
set noshiftround

" ================================= Searching =================================
set incsearch ignorecase smartcase
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set ruler                       " show the cursor position all the time

" ========================= History and file handling =========================
set history=999             " Increase history (default = 20)
set undolevels=999          " More undo (default=100)

" =========================== Backup and Swap Files ===========================
set nobackup
set nowritebackup
set noswapfile

" =================================== Keys ====================================
set backspace=indent,eol,start  " allow backspacing over everything.
set timeoutlen=2000              " how long it wait for mapped commands

" ========================== Use TAB to autocomplete ==========================
set omnifunc=syntaxcomplete#Complete
set complete=.,w,b,i,d,u,t
set completeopt=longest,menuone,preview

" https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
" https://medium.com/usevim/vim-101-completion-compendium-97b4ebc3a45a
" https://news.ycombinator.com/item?id=13960147

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


" ================================ Code folding ===============================
set foldmethod=manual       " manual fold

" ================================== Sessions =================================
set sessionoptions="blank,buffers,curdir,folds,globals,resize,sesdir,tabpages,terminal"

let g:sessions_dir = "$VIMRUNTIME\\sessions"
execute 'cnoreabbrev mks mksession ' . g:sessions_dir . '\'

" =========================== User defined mappings ===========================

" Make ',' leader for commands
let mapleader = ","

" Remap k to gk to intuitively jump lines upwards
nnoremap k gk

" Remap j to gj to intuitively jump lines downwards
nnoremap j gj

" Remap ev to edit vimrc file
nnoremap <silent> <leader>ev :tabedit $VIMRUNTIME\..\..\..\Data\settings\_vimrc<cr>

" Remap sv to "refresh" vimrc
nnoremap <silent> <leader>sv :source $VIMRUNTIME\..\..\..\Data\settings\_vimrc<cr>

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

" Control-a selects all in v-line mode
inoremap <c-a> <esc>ggVG
nnoremap <c-a> ggVG

" Control-s updates file contents 
nnoremap <silent> <c-s> :update<cr>
inoremap <silent> <c-s> <esc>:update<cr>a


" ============================== Ex command remap ==============================
command! W w
command! Q q
command! WQ wq
command! Wq wq
command! WQa wqa
command! Wqa wqa
command! WQA wqa
command! Q q
command! Qa qa
command! QA qa

" ============================== Custom functions ==============================

function! Eatchar(pat)
    let l:c = nr2char(getchar(0))
    return (l:c =~ a:pat) ? '' : c
endfunc

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

endfunc

if has("autocmd")
    autocmd FileType html,css inoremap >> ><esc>:call feedkeys(AutoCompleteTag('n'), 'n')<cr>
endif


function! RunCode()
    let l:full_path = shellescape(expand('%:p'))

    if &ft == 'python'
        execute "vert term ++kill=term python " . l:full_path
        echom("normal! :vert term ++kill=term python " . l:full_path)

    elseif &ft == 'javascript'
        echo("JS")
        execute "!node " . l:full_path 
    else
        echo("I don't know how to run the file")
    endif

endfunc

nnoremap <silent> <c-enter> :call RunCode()<cr>


function! AdjustFontSize(amount)
    if has('gui_running')

        let l:minfontsize = 10
        let l:maxfontsize = 30
        let l:fontname = substitute(&guifont,  '\(\S*\):h\(\d\d\)\(\S*\)', '\1', '')
        let l:cursize = substitute(&guifont, '\(\S*\):h\(\d\d\)\(\S*\)', '\2', '')
        let l:information = substitute(&guifont, '\(\S*\):h\(\d\d\)\(\S*\)', '\3', '')

        let l:newsize = l:cursize + a:amount
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

nnoremap <silent> <leader>= :call AdjustFontSize(1)<cr>
nnoremap <silent> <leader>- :call AdjustFontSize(-1)<cr>

" ================================= Terminal ==================================
tnoremap <esc> <C-\><C-n>
cnoreabbrev term vert term ++kill=term
cnoreabbrev hterm term ++kill=term
cnoreabbrev tterm tabnew<bar>term ++curwin ++kill=term

" autocmd SourcePre * let $PATH = "" . $PATH
" let $PATH = $PATH . "C:/Users/m4rc0/Documents/gVim/WPy-3710;"
" let $PATH = $PATH . "C:/Users/m4rc0/Documents/gVim/Git;"
set pythonthreehome=$VIMRUNTIME\..\..\..\Programming\WPy-3710\python-3.7.1
set pythonthreedll=$VIMRUNTIME\..\..\..\Programming\WPy-3710\python-3.7.1\python37.dll


" ================================== Plugins ==================================

call plug#begin('$VIMRUNTIME/plugged')

Plug 'kyuhi/vim-emoji-complete'

Plug 'itchyny/lightline.vim'
Plug 'webdevel/tabulous'


Plug 'w0rp/ale'
" Plug 'skywind3000/asyncrun.vim'

Plug 'jiangmiao/auto-pairs'
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


" ================================ Vim Surround ================================
if has("autocmd")
    augroup vim_surround
        autocmd!

        " Map change surrounding to <leader>cs and eliminate the cs command
        autocmd VimEnter nmap <leader>cs cs 

        " Map delete surrounding to <leader>ds and eliminate the ds command
        autocmd VimEnter nmap <leader>ds ds

        " Map add surrounding to <leader>as and eliminate ysiw
        autocmd VimEnter nmap <leader>as ys

        " Map surround line to <leader>sl and eliminate yss
        autocmd VimEnter nmap <leader>sl yss

        " Map surround selection to <leader>s and eliminate S
        autocmd VimEnter imap <leader>s S
    augroup END

endif

" =================================== Emmet ===================================
let g:user_emmet_install_global = 0
if has("autocmd")
    autocmd FileType html,css EmmetInstall
endif
let g:user_emmet_mode='n'    "only enable normal mode functions.
let g:user_emmet_leader_key= mapleader.'e'


" ============================ Preinstalled matchit ===========================
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif

" ================================= lightline =================================
let g:lightline = { 'colorscheme': 'wombat' }
autocmd BufEnter * execute "call lightline#enable()"

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

" ================================== NETRW =================================
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

if has("autocmd")
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
    augroup END

endif


" ================================ Molokai theme ==============================
" colorscheme molokai
" let g:molokai_original = 1

" ================================ Tender theme ===============================
" autocmd VimEnter * colorscheme tender

" =============================== One half theme ==============================
autocmd VimEnter * colorscheme onehalfdark


" ==================================== Ale ====================================
let g:ale_enabled = 1
let g:ale_completion_enabled = 0
let g:ale_echo_cursor = 1
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

" ================================= winresizer =================================

if has("autocmd")
    autocmd VimEnter unmap <C-E>
    autocmd VimEnter unmap <C-a>
endif

let g:winresizer_enable = 1
let g:winresizer_finish_with_escape = 1
let g:winresizer_vert_resize = 5
let g:winresizer_horiz_resize = 2

nnoremap <leader>w :WinResizerStartFocus<cr>


" ================================ Nerdcommenter ===============================
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 0
let g:NERDCommentEmptyLines = 0
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCreateDefaultMappings = 0

nnoremap <leader>cc :call NERDComment('n', 'invert')<cr>
vnoremap <leader>cc :call NERDComment('x', 'invert')<cr>
nnoremap <leader>ca :call NERDComment('n', 'comment')<cr>
vnoremap <leader>ca :call NERDComment('x', 'comment')<cr>
nnoremap <leader>cd :call NERDComment('n', 'uncomment')<cr>
vnoremap <leader>cd :call NERDComment('x', 'uncomment')<cr>
nnoremap <leader>cy :call NERDComment('n', 'yank')<cr>
vnoremap <leader>cy :call NERDComment('x', 'yank')<cr>


" ================================= auto-pairs =================================
let g:AutoPairsFlyMode = 0

if has("autocmd")
    autocmd VimEnter unmap <M-p>
    autocmd VimEnter unmap <M-e>
    autocmd VimEnter unmap <M-n>
    autocmd VimEnter unmap <M-b>
endif


" ================================= easymotion =================================
nmap <leader><leader>s <Plug>(easymotion-overwin-f)
nmap <leader><leader>l <Plug>(easymotion-overwin-line)
nmap <leader><leader>w <Plug>(easymotion-overwin-w)


" ================================== startify ==================================
let g:startify_session_dir = expand("$VIMRUNTIME\\sessions") 
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


let s:startify_left_addition = repeat(' ', (&columns - 63)/2)

let g:startify_custom_header = [
            \ s:startify_left_addition . ' ___      ___ ___  _____ ______           ________    _____     ',
            \ s:startify_left_addition . '|\  \    /  /|\  \|\   _ \  _   \        |\   __  \  / __  \    ',
            \ s:startify_left_addition . '\ \  \  /  / \ \  \ \  \\\__\ \  \       \ \  \|\  \|\/_|\  \   ',
            \ s:startify_left_addition . ' \ \  \/  / / \ \  \ \  \\|__| \  \       \ \   __  \|/ \ \  \  ',
            \ s:startify_left_addition . '  \ \    / /   \ \  \ \  \    \ \  \       \ \  \|\  \ __\ \  \ ',
            \ s:startify_left_addition . '   \  __/ /     \ \__\ \__\    \ \__\       \ \_______|\__\ \__\',
            \ s:startify_left_addition . '    \|__|/       \|__|\|__|     \|__|        \|_______\|__|\|__|',
            \ s:startify_left_addition . '                                                                ',
            \ s:startify_left_addition . '                                                                ',
            \ ]



cd C:\Users\m4rc0\Documents
 
" Diff commands
" do => diff obtain
" dp => diff put
" [c => previous diff
" ]c => following diff
