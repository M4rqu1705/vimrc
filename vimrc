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

if has("unix")
    " Remap ev to edit vimrc file
    nnoremap <leader>ev :tabedit /usr/share/vim/vimrc<cr>
    " Remap sv to "refresh" vimrc
    nnoremap <leader>sv :source /usr/share/vim/vimrc<cr>

elseif has("win32unix")
    " Remap ev to edit vimrc file
    nnoremap <leader>ev :tabedit /c/Users/m4rc0/AppData/Local/Programs/cmder/vendor/git-for-windows/etc/vimrc<cr>
    " Remap sv to "refresh" vimrc
    nnoremap <leader>sv :source /c/Users/m4rc0/AppData/Local/Programs/cmder/vendor/git-for-windows/etc/vimrc<cr>

endif

" Remap Ctrl+W for use in Cmder
nnoremap <c-w> <c-s-w>

" ================================================= Plugins ================================================= 
call plug#begin('$VIM/vim81/plugin')
" Declare list of plugins
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-repeat'
Plug 'junegunn/vim-emoji'
Plug 'scrooloose/nerdtree'
Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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
        autocmd VimEnter * nmap <leader>cs cs 

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

" ================================================== Emmet ====================================================
let g:user_emmet_install_global = 0
if has("autocmd")
    autocmd FileType html,css EmmetInstall
endif
let g:user_emmet_mode='n'    "only enable normal mode functions.
let g:user_emmet_leader_key= ',e'

" ================================================== Airline ====================================================
let g:airline_theme='dark'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif


" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '►'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◄'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '↨'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '||'
let g:airline_symbols.whitespace = 'Ξ'
                          

let g:airline_section_a = '%{airline#util#wrap(airline#parts#mode(),0)} %{airline#util#wrap(airline#parts#spell(),0)}'
let g:airline_section_b = '%t %m'
let g:airline_section_c = ''
let g:airline_section_y = "%Y %{\"[\".(&fenc==\"\"?&enc:&fenc).\"\]\"}" 
let g:airline_section_z='%P %l/%L:%v' 
let g:airline_section_warning = ''
" let g:airline_section_warning="(%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})"

set ttimeoutlen=50

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

" ================================================== NERDTree ====================================================
if has("autocmd")
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

endif
nnoremap <leader>pnt :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'

" ================================================== Molokai theme ====================================================
colorscheme molokai
let g:molokai_original = 1


" ================================================== Abbreviations ==================================================

func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

" Define the behavior of specific tags
let s:tags_content = {
    \ "meta": " name\=\"\"\ content\=\"\"/>",
    \ "div": ">\<cr>\<tab>\<cr>\<bs>",
    \ "html": " lang\=\"en\-US\">\<cr>\<tab>\<cr>\<bs>",
    \ "img": " src\=\"\"\ alt\=\"\"/>",
    \ "a": " href\=\"#\">",
    \ "link": " rel\=\"stylesheet\" type\=\"text/css\" href=\"#\"/>",
    \ "style": " type\=\"text/css\"\>",
    \ "script": " type\=\"text/javascript\">",
    \ "input": " name\=\"\" placeholder\=\"\"/>",
    \ "select": " name\=\"\">",
    \ "option": " value\=\"\">",
    \ "metas": "\<bs> charset=\"UTF-8\"/>\<cr>\<cr><title></title>\<cr>\<cr><base href\=\"#\"/>\<cr>\<cr><link rel=\"stylesheet\" type=\"text/css\" href=\"#\"/>\<cr><link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"#\" />\<cr>\<cr><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"/>\<cr><meta name=\"description\" content=\"\"/>\<cr><meta name=\"keywords\" content=\"\"/>\<cr><meta name=\"copyright\" content=\"\" />\<cr><meta name=\"author\" content=\"Author name\" />\<cr><meta http-equiv=\"cache-control\" content=\"no-cache\"/>\<cr><meta property=\"og\:type\" content=\"\"/>\<cr><meta property=\"og\:title\" content=\"\"/>\<cr><meta property=\"og\:description\" content=\"\"/>\<cr><meta property=\"og\:image\" content=\"\"/>\<cr><meta property=\"og\:site_name\" content=\"\"/>"
    \ }

let s:self_closing_tags = {
    \ "meta": "true",   "base": "true",
    \ "link": "true",   "img": "true",
    \ "br": "true",     "hr": "true",
    \ "input": "true",  "source": "true",
    \ "embed": "true",  "param": "true",
    \ "wbr": "true",    "area": "true",
    \ "col": "true",    "track": "true" ,
    \ "metas": "true"}


func AutoCompleteTag(mode)
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
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows

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


" ================================================== Conceal ==================================================


if has("autocmd")
    autocmd VimEnter * set conceallevel=1
    autocmd VimEnter * set concealcursor=ni
endif

call matchadd('Conceal','delta',1,-1,{'conceal': '∆'})
call matchadd('Conceal','pi',1,-1,{'conceal': 'π'})
call matchadd('Conceal','!=',1,-1,{'conceal': '≠'})
call matchadd('Conceal','>=',1,-1,{'conceal': '≥'})
call matchadd('Conceal','<=',1,-1,{'conceal': '≤'})
call matchadd('Conceal','->',1,-1,{'conceal': '→'})
call matchadd('Conceal','<-',1,-1,{'conceal': '←'})

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
