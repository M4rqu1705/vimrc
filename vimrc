" Setting some decent VIM settings for programming

set ai                          " set auto-indenting on for programming
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set ruler                       " show the cursor position all the time
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set backspace=indent,eol,start  " make that backspace key work the way it should
set nocompatible                " vi compatible is LAME
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set showmode                    " show the current mode
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
syntax on                       " turn syntax highlighting on by default

" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

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


	" augroup vim_surround
	autocmd!

	" ============ Commands for vim surround ============

	" Map change surrounding to <leader>cs and eliminate the cs command
	autocmd VimEnter * nmap <leader>cs cs

	" Map delete surrounding to <leader>ds and eliminate the ds command
	autocmd VimEnter * nmap <leader>ds ds

	" Map add surrounding to <leader>as and eliminate ysiw
	autocmd VimEnter * nmap <leader>as ysiw

	" Map surround line to <leader>sl and eliminate yss
	autocmd VimEnter * nmap <leader>sl yss

	" Map surround selection to <leader>s and eliminate S
	autocmd VimEnter * imap <leader>s S

	" augroup END

endif "has("autocmd")



" ============ Use TAB to autocomplete ============
function! Tab_Or_Complete()
	if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
		return "\<C-N>"
	else
		return "\<Tab>"
	endif
endfunction

inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>


" ============ Plugins ============
call plug#begin('$VIM/vim80/plugin')
" Declare list of plugins
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" List ends here. Plugins become visible to VIM
call plug#end()

set completefunc=emoji#complete

function ReplaceWithEmoji()
	%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
endfunction

" ============ User defined ============

" Add line numbers
set number
set numberwidth=5 

" Make '-' leader for commands
let mapleader = ","

" Remap k to gk to intuitively jump lines upwards
nnoremap k gk

" Remap j to gj to intuitively jump lines downwards
nnoremap j gj

" <leader>u toggles the case of the current word
nnoremap <leader>u Bviw~<esc>

" <leader>U toggles the case of the current WORD
nnoremap <leader>U BviW~<esc>

" Big jump left (to first non-blank character)
nnoremap <leader>h ^<space>

" Big jump right (to last non-blank character)
nnoremap <leader>l g_

" For making everything utf-8
set enc=utf-8

" Use both english and spanish dictionaries to check spelling
set spell spelllang=en,es
set dictionary="$VIM/vim80/spell"

set showmode 
set title

" Whitespace
set wrap
set textwidth=80
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Searching
set hlsearch
set incsearch
set ignorecase smartcase

" --- history / file handling ---
set history=999             " Increase history (default = 20)
set undolevels=999          " More undo (default=100)

" --- backup and swap files ---
" I save all the time, those are annoying and unnecessary...
set nobackup
set nowritebackup
set noswapfile

" --- keys ---
set backspace=indent,eol,start  " allow backspacing over everything.
set timeoutlen=500              " how long it wait for mapped commands

" --- command completion ---
set wildmenu                " Hitting TAB in command mode will
set wildchar=<TAB>          "   show possible completions.
set wildmode=list:longest
set wildignore+=*.DS_STORE,*.db,node_modules/**,*.jpg,*.png,*.gif

" --- folding---
set foldmethod=manual       " manual fold
