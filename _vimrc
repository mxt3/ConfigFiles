"Add .vim and other unix like to runtimepath on windows so .vim files 
"from there are recognized
let &runtimepath.=",$HOME/.vim,$HOME/.vim/after"   

" -------------------------
" vundle setup and plugins
" -------------------------

set nocompatible              " be improved, required
filetype off                  " required
set encoding=utf-8

" set the runtime path to include vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where vundle should install plugins
"call vundle#begin('~/some/path/here')

" let vundle manage vundle, required
Plugin 'vundlevim/vundle.vim'

" the following are examples of different formats supported.
" keep plugin commands between vundle#begin/end.

" my plugins
"------------
Plugin 'tpope/vim-fugitive'
Plugin 'l9'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'altercation/vim-colors-solarized'
Plugin 'valloric/youcompleteme'
Plugin 'chriskempson/base16-vim'
"Plugin 'vim-syntastic/syntastic'
Plugin 'tpope/vim-repeat' " support dot-operator for vim-surround and others
Plugin 'tpope/vim-surround' " surround words with delimiters easiliy
Plugin 'tpope/vim-commentary' "pluging for easy commenting lines
"Plugin 'raimondi/delimitmate'
Plugin 'christoomey/vim-system-copy' "use cp{motion} to copy from vim to system clipboard instead of doublequote+y{motion}
"custom text object for selection
Plugin 'kana/vim-textobj-user'
"this plugin uses it for
Plugin 'kana/vim-textobj-indent'
"sneak motion: basically f-motion but with two letters
Plugin 'justinmk/vim-sneak'

"nice tagbar
Plugin 'majutsushi/tagbar'
"some sensible upgrades and settings for netrw
Plugin 'tpope/vim-vinegar'
" by buffer : replacement for bclose
Plugin 'moll/vim-bbye'

"fuzzy finders
Plugin 'ctrlpvim/ctrlp.vim'
"use a fast external lister to improve speed of ctrlp:
"(from
"https://bluz71.github.io/2017/10/26/turbocharge-the-ctrlp-vim-plugin.html)
let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
"turn of caching with this fast lister
let g:ctrlp_use_caching = 0
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir' ]

"fzf: needs binary on path and plugin asside from this one
Plugin 'junegunn/fzf.vim'

"async syntastic: ale
Plugin 'w0rp/ale'

Plugin 'rhysd/vim-grammarous'

Plugin 'ayu-theme/ayu-vim'
"Plugin 'rakr/vim-one'
Plugin 'reedes/vim-colors-pencil'

" all of your plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" to ignore plugin indent changes, instead use:
"filetype plugin on
"
" brief help
" :pluginlist       - lists configured plugins
" :plugininstall    - installs plugins; append `!` to update or just :pluginupdate " :pluginsearch foo - searches for foo; append `!` to refresh local cache
" :pluginclean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for faq
" put your non-plugin stuff after this line

" end vundle

" -------------------------
" Misc native vim settings
" -------------------------

"Start in Home directory (and not program files on windows)
"Much better is to set the working directotory through the shortcut
"becasue that way the working directory is the same as the in the
"terminal where you invoke vim
"cd ~

"Mapping of control s to save
"nmap <c-s> :w<CR>
"imap <c-s> <ESC>:w<CR>a

"Set line numbers on by default
set nu
" to set relative numbers: set rnu
" both rnu and nu can be one, showing the current absolute line number of the
" current line and relative numbering on other lines
set rnu

"Enable removing eol, autoindentation and charachters before start of Insert
"(necessairy also for delimitMata its exapnd_cr feature
set backspace=start,indent,eol

"For easier tag navigation, remap g C^] to g] i.e. replace command of show tag
"list always to go immeadiately to tag if there is only one tag, otherwise
"show list
nnoremap g$ g<C-]>

"allow hidden buffers, (usefull for tag jumping when not having saved yet)
" stil warns on pending changes when quiting
set hidden

"Set encryption method by default to blowfish2 (not supported by older
"verison). Use :X to save with encryption, see :help encryption
set cm=blowfish2

" -------------------------
" Search settings, see help
" -------------------------
set incsearch
set ignorecase smartcase
set hls
"Press enter to remove current highlihgting (and send enter again) 
nnoremap <CR> :noh<CR><CR>


" -----------------
" Vim completion behavior
" -----------------
"Only insert longest common text, do not add more
set completeopt=longest,menuone,preview

" -----------------
" Folding options
" -----------------

"Folding colmun at left side of window visible
set foldcolumn=3
"Set dir to save folds (default is in program files which has no access rights
"of course)
set viewdir=~\.vim\viewdir

" -----------------------------------------
"  Tab and indentation behaviour
" -----------------------------------------

"Set tab charactere (default=8)
set tabstop=4
"Set tab size in insert mode (uses mix of spaces and tabs to achieve this)
set softtabstop=4
"Set tab size in normal mode using > or < (uses mix of spaces and tabs to achieve this)
set shiftwidth=4
"Do not replace tabs by space (default behaviour)
set noexpandtab

" from http://vimcasts.org/episodes/tabs-and-spaces/
" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction


"Continue indentation automatically globally (does not interfere with filetype
"indentation)
set autoindent

if has("autocmd") "if vim is compiled wiht autocmd option
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
endif

"-----------------------------------------
"
"

"Wrap line after words
set wrap lbr

"Toggle with \w between moving between rapped lines and moving between normal
"lines
noremap <silent> <Leader>w :call ToggleWrapMovement()<CR>
let wrapMotion = 0
function ToggleWrapMovement()
    if g:wrapMotion
	let g:wrapMotion = 1
	echo "Moving between wrapped lines OFF"
	unmap j
	unmap k
    else
	let g:wrapMotion = 1
	echo "Moving between wrapped lines ON"
	map j gj
	map k gk
    endif
endfunction

" Fuzzy file finding
set path+=** "makes :find autocomplete for files also in subdirectories of working dir
set wildmenu "give options when using autocomplete (cycle with tab)
set wildmode=longest:full,full
" through open buffers: use :b command (default)
"
" Easy command to make ctags run recursively from working dir
command! MakeTags !ctags -R .

" when gaining focus, reload file to check for changes when no pending changes
" in buffer
set autoread

"Enable hidden buffers
set hidden

" Easier navigation to other window splits
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Nice symbols for showing withespace characters when
" using :set list
set listchars=eol:¬,tab:»\ 


"--------------------------------
" DelimitMate settings
" -------------------------------

"TODO: if there is lot of filetype specific content, put it in
".vim/after/ftplugin/[language].vim

"set expand_cr functionality for c-syntax files
" if has("autocmd")
" 	autocmd FileType cpp,c,javascript,cs let b:delimitMate_expand_cr = 1
" endif

"-------------------------------------
" YouCompleMe Keymappings & settings
" ------------------------------------

" First try definiton (only works in same translation unit), then definition.
map <F2> :YcmCompleter GoTo<CR>
" Go to the header that includes declaration
map <F3> :YcmCompleter GoToInclude<CR>
" Same as Goto but do not recompile (fast but inaccurate)
map <F4> :YcmCompleter GoToImprecise<CR>

"prevent enabling for every file
"Add if needed, done to ensure perf. at startup
"Default value: { '*': 1 } --> every file
let g:ycm_filetype_whitelist = {'cpp': 1, 'python': 1, 'c': 1,
								\'cs': 1, 'javascript': 1, 'go': 1,
								\'rust': 1, 'java': 1,}
"prevent autocompletion for identifier based (which I find infers with the use
"of the tab key. The autocompletion after '->' or '.' remains. You can always
"call autocomplete by Ctrl+space
let g:ycm_min_num_of_chars_for_completion = 99

"default extra_conf for cpp completion
let g:ycm_global_ycm_extra_conf = '~\.vim\global.ycm_extra_conf.py'

"Hide the preview automatically
"let g:ycm_autoclose_preview_window_after_completion=1

"--------------------------------
" A.L.E. Config
"--------------------------------
"Using it only for linting and fixing at the moment

" Define fixers for using :ALEFix, todo for each filetype
let g:ale_fixers = {
			\ 'python': ['autopep8', 'remove_trailing_lines'],
			\ }

"set ale flake8 warnings into errors, as this are all styel guide things
let g:ale_type_map = {'flake8': {'ES': 'WS', 'E': 'W'}}
"let g:ale_type_map.new_entry = bla

"enabled linters: this is merged with a default dic for
"unset filetypes
"let g:ale_linters = { 'python': [ 'pylint'] }

"--------------------------------
" Airline config
"--------------------------------
set laststatus=2
if has('gui_running')
	let g:airline_powerline_fonts = 1
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
" disabling showtabs make airline always show buffers, also when multiple tabs
" exist. Then there is a tab indication on the right
let g:airline#extensions#tabline#show_tabs= 0

"--------------------------------
" Syntastic config
"--------------------------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


"--------------------------------
" Tagbar config
"--------------------------------

"Bind leader key to toggle
nnoremap <silent> <Leader>t :TagbarToggle<CR>

"--------------------------------
" Netrw settings
"--------------------------------
" Note: plugin vinegar also controls some settings
" and adds the '-' key outside netrw to open 
" parent dir of file immeadiately.
" other useful things are '.' and 'y.' while in netrw

"hide files matching g:netrw_list_hide. Toggle hiding with
" gh inside netrw
let g:netrw_hide = 1
let g:netrw_liststyle = 0


"Function to set-up a project explorer like sidesplit
function ProjectExplNetrw()
   
	let l:no_restore = 0
	"copy vars to reset them
	if exists("g:netrw_liststyle")
		let l:list_style = g:netrw_liststyle
	else
		let l:no_restore = 0
	end
	if exists("g:netrw_hide")
		let l:hide_file = g:netrw_hide
	else
		let l:no_restore = 0;
	endif

	let g:netrw_liststyle = 3
	let g:netrw_hide = 1

	"split window with netrw
	Vexplore
	vertical resize 42 
   
	if l:no_restore == 0
		"restore netrw vars
		let g:netrw_liststyle = l:list_style
		let g:netrw_hide = l:hide_file
	endif
endfunction

"--------------------------------
" Leader Key maps
"--------------------------------

"map key to vim function setting up a buffer with project
"explorer like view starting of the current directory
"
noremap <silent> <Leader>p :call ProjectExplNetrw()<CR>

"map BBye to close buffer
noremap <silent> <Leader>q :Bdelete<CR>

"map YCM GoTo
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

"map ALE Fix
nnoremap <leader>f :ALEFix<CR>


"--------------------------------
" Aesthetics
"--------------------------------

"Enable 24-bit terminal colors
"Works on Windows 10 creators update and later
"if vim terminal app is compiled with vtp option
set termguicolors

"Theme for terminal != gui -> defined in .gvimrc
"Ayu Theme settings
" let ayucolor="dark"
" colorscheme ayu
"colorscheme ayu
"set background=dark
colorscheme base16-gruvbox-dark-hard

"enable syntax highligting in terminal
syntax on

