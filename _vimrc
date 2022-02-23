
if has('win32') || has('win64')
	"Add .vim and other unix like to runtimepath on windows so .vim files
	"from there are recognized
	let &runtimepath.=",$HOME/.vim,$HOME/.vim/after"
endif

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
" keep plugin commands between vundle#begin/end.

" let vundle manage vundle, required
Plugin 'VundleVim/Vundle.vim'

"Basic text editing enchancements
Plugin 'tpope/vim-repeat' " support dot-operator for vim-surround and others
Plugin 'tpope/vim-surround' " surround words with delimiters easiliy
Plugin 'tpope/vim-commentary' "pluging for easy commenting lines
"custom text object for selection
Plugin 'kana/vim-textobj-user'
"this plugin uses it for
Plugin 'kana/vim-textobj-indent'
"sneak motion: basically f-motion but with two letters
Plugin 'justinmk/vim-sneak'

"Snippet Manager
Plugin 'SirVer/ultisnips'
"Snippet Library
Plugin 'honza/vim-snippets'

"nice tagbar
Plugin 'majutsushi/tagbar'
"some sensible upgrades and settings for netrw
Plugin 'tpope/vim-vinegar'

"Better Git experience
Plugin 'tpope/vim-fugitive'

" by buffer : replacement for bclose
Plugin 'moll/vim-bbye'
"Simple buffer managment. Command :BufExplorer
Plugin 'jlanzarotta/bufexplorer'

"Specific language support stuff
"Better syntax highlighting of cpp
Plugin 'octol/vim-cpp-enhanced-highlight'
if v:version >= 800
	"async syntastic: ale
	Plugin 'dense-analysis/ale'
"Better  (system)verilog syntax highighting, folding, error format support,
"omni completion from tags, tagbar support etc.
Plugin 'vhda/verilog_systemverilog.vim'
"see (system)verilog fplugin for options, as this is very file specific

endif
"Plugin 'vim-syntastic/syntastic'


"fuzzy finders
" Plugin 'ctrlpvim/ctrlp.vim'	"Not async
" Plugin 'Yggdroot/LeaderF'		"Intially slow
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

"if executable('fd')
"	"use a fast external lister to improve speed of ctrlp:
"	"(from
"	"https://bluz71.github.io/2017/10/26/turbocharge-the-ctrlp-vim-plugin.html)
"	let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
"	"turn of caching with this fast lister
"	let g:ctrlp_use_caching = 0
"endif
"let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir' ]

" Themes
" Plugin 'ayu-theme/ayu-vim'
" Plugin 'rakr/vim-one'
Plugin 'reedes/vim-colors-pencil'
" Plugin 'dawikur/base16-vim-airline-themes'
" Plugin 'morhetz/gruvbox'
" Plugin 'sonph/onehalf', {'rtp': 'vim'}
" Plugin 'nanotech/jellybeans.vim'
"Plugin 'altercation/vim-colors-solarized'
" Plugin 'fnune/base16-vim'

" UI enhancements
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" A start screen for VIM
Plugin 'mhinz/vim-startify'

" aliases in the command line
Plugin 'Konfekt/vim-alias'

call vundle#end()            " required
filetype plugin indent on    " required, This enable flile type plugins in the ftplugin/ folder.

" Native vim package manager
" (useful for built-in packages)
if v:version >= 800 && has('eval')
	packadd! matchit
else
	runtime macros/matchit.vim
end

" -------------------------
" Misc native vim settings
" -------------------------

"Set line numbers on by default
set nu
" to set relative numbers: set rnu
" both rnu and nu can be one, showing the current absolute line number of the
" current line and relative numbering on other lines
set rnu

"Enable removing eol, autoindentation and charachters before start of Insert
"(necessairy also for delimitMata its exapnd_cr feature
set backspace=start,indent,eol


"allow hidden buffers, (usefull for tag jumping when not having saved yet)
" stil warns on pending changes when quiting
set hidden

"Set encryption method by default to blowfish2 (not supported by older
"verison). Use :X to save with encryption, see :help encryption
set cm=blowfish2

if has('win32') || has('win64')
	"scroll (split)window under cursor, even if it has no focus
	set scrollfocus
endif
"Always have 3 lines below/above cursor
set scrolloff=3

"Enable mouse in the terminal. Putty and xterm-(compatible) terminals support
"this
set mouse=a

" -------------------------
" Search settings, see help
" -------------------------
set incsearch
set ignorecase smartcase
set hls


" -----------------
" Vim completion behavior
" -----------------
"Do not instert text when pressing the completetion key (noinsert), so we can
"type further to narrow down the completetion menu
"NOTE: the option 'longest' is not compatible with youcompleteme
set completeopt=menuone,preview,noinsert
" Make pressing space accepting suggestion: Control - Y(es) = accept
inoremap <expr> <Space> pumvisible() ? "\<C-y>" : "\<Space>"
" Tab and shift tap scroll due to youcompleteme

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

"Continue indentation automatically globally (does not interfere with filetype
"indentation)
set autoindent

"Continue indentation on linewrap
set breakindent
"Indicate this with following character
set showbreak=└

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


if has("autocmd") "if vim is compiled with autocmd option
  " Enable file type detection.
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

"prevent enabling for every file
"Add if needed, done to ensure perf. at startup
"Default value: { '*': 1 } --> every file
"let g:ycm_filetype_whitelist = {'cpp': 1, 'python': 1, 'c': 1,
"								\'cs': 1, 'javascript': 1, 'go': 1,
"								\'rust': 1, 'java': 1,}
""prevent autocompletion for identifier based (which I find infers with the use
""of the tab key. The autocompletion after '->' or '.' remains. You can always
""call autocomplete by Ctrl+space
"let g:ycm_min_num_of_chars_for_completion = 99

""default extra_conf for cpp completion
"let g:ycm_global_ycm_extra_conf = '~\.vim\global.ycm_extra_conf.py'

""Hide the preview automatically
"let g:ycm_autoclose_preview_window_after_completion=1


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


"--------------------------------
" vim-cpp-enhanced-highlight settings
"--------------------------------
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_concepts_highlight = 1

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

" Use xdg open-file method when hitting x in netrew or gx on a
" path/url in a file. On linux only.
if has('unix') || has('macunix')
	let g:netrw_browsex_viewer= "xdg-open"
endif

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

" Make netrw buffer close if you want
" Hint: easy access to netrw by pressing '-' in any buffer
autocmd FileType netrw setl bufhidden=wipe

"--------------------------------
" Vim Alias Plugin Aliases
"--------------------------------

" See ~/.vim/after/plugin/alias.vim


"--------------------------------
" Aesthetics
"--------------------------------

"Enable 24-bit terminal colors
"Works on Windows 10 creators update and later
"if vim terminal app is compiled with vtp option
if ($COLORTERM == 'truecolor') || ($COLORTERM == '24bit') || has('vcon')
	set termguicolors
	"Theme for terminal != gui -> defined in .gvimrc
	" colorscheme base16-gruvbox-dark-hard
	colorscheme desert256
	if !has("gui_running")
		let g:airline_theme='base16_default'
	endif
else
	"fall back on 256 color theme
	colorscheme desert256
endif

"enable syntax highligting in terminal
syntax on

"Fix netrw leaving buffers open after closing it (with e.g Ctrl-^)
" autocmd FileType netrw setl bufhidden=delete
let g:netrw_fastbrowse=0

"--------------------------------
" Functions for misc utility
"--------------------------------
"TODO: move to somewhere else??

" redirect the output of a Vim or external command into a scratch buffer
" From : https://vi.stackexchange.com/questions/8378/dump-the-output-of-internal-vim-command-into-buffer
" Works well with ex commands. E.g. :Redir g/String/p
" akin to built-in redir (saves to register)
function! Redir(cmd)
  if a:cmd =~ '^!'
    execute "let output = system('" . substitute(a:cmd, '^!', '', '') . "')"
  else
    redir => output
    execute a:cmd
    redir END
  endif
  new " Present new buffers is split window
  setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
  call setline(1, split(output, "\n"))
  put! = a:cmd
  put = '----'
endfunction
command! -nargs=1 Redir silent call Redir(<f-args>)

" Plugin settings {{{1
" =========================
"
" fzf and fzf.vim 
" ----------------
" See https://raw.githubusercontent.com/junegunn/fzf/master/README-VIM.md 
" and https://raw.githubusercontent.com/junegunn/fzf.vim/master/README.md

" Default behavior
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }
if has('win32') || has('win64')
	let g:fzf_history_dir = '$LOCALAPPDATA/fzf_history'
else
	let g:fzf_history_dir = '~/.local/share/fzf_history'
endif

" Popup for file browser with preview
let fzf_preview_cmd=''
if executable('bat')
	let fzf_preview_cmd='bat --color=always --style=numbers --line-range :500'
elseif has('win32') || has('win64')
	let fzf_preview_cmd='type'
else
	let fzf_preview_cmd='cat'
endif
command! -bang FilesPreview call fzf#run(fzf#wrap({
			\ 'window': { 'width': 0.9, 'height': 0.7 },
			\ 'options': '--preview "' . fzf_preview_cmd . ' {}"' }, <bang>0 ))

" vim-startify
" ----------------
"  A start screen and session manager for Vim
"  Shows sessions and MRU files as start screen
"  Also Does session managment: wrap around :mksession
"  If sessions management is not sufficient, vim-obssession and vim-prosession
"  are also an option

" configure vim :mksession
" compared to default: remove 'options' and add skiprtp
" see 
if v:version >= 800 && has('mksession')
	set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal,skiprtp,resize
else
	set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,resize
endif

"I also use .vim on windows
let g:startify_session_dir = '~/.vim/session'

"header config
let g:startify_custom_header=startify#center(['VIM Start'])
"show 8 files per section
let g:startify_files_number=8
"show env variables to shorten paths: ugly on windows
" let g:startify_use_env=1
"change dir to the file openend
let g:startify_change_to_dir=1
"take a git dir to be the project root: slow on windows
" let g:startify_change_to_vcs_root=1


" auto save sessions
let g:startify_session_persistence=1
" auto load when starting vim in a directory containing a session.vim file
let g:startify_session_autoload=1
" sort session on start screen by modification time
let g:startify_session_sort=1
" show max 5 sessions on start
let g:startify_session_sort=5


if v:version >= 800
"--------------------------------
" A.L.E. Config
"--------------------------------
"Ansync LSP client.

"Use airline status info
let g:airline#extensions#ale#enabled=1


" Define fixers for using :ALEFix, todo for each filetype
let g:ale_fixers = {
			\ 'python': ['autopep8', 'remove_trailing_lines'],
			\ }

"set ale flake8 errors into warnings, as this are all styel guide things
let g:ale_type_map = {'flake8': {'ES': 'WS', 'E': 'W'}}
"let g:ale_type_map.new_entry = bla

"enabled linters: this is merged with a default dic for
"unset filetypes
let g:ale_linters = { 'python': [ 'pylint'], 'cpp' : [ 'clangd'], }

"Dry run make -n to extract compilation info for c/cpp
"Can run arbitrary code ...
" let g:ale_c_parse_makefile=1

"Make ALE also look for compile_commands.json in same folder as .c(pp)
"instead of only in a 'bin' of 'build' subfolder
let g:ale_c_build_dir_names=['bin', 'build', '.']

" ALE will provide omnicompletion 
" NOTE: there is also automatic completion by ALE
set omnifunc=ale#completion#OmniFunc

endif

"--------------------------------
" Ultisnips
"--------------------------------
"Snippet manager
"See bottom of https://github.com/SirVer/ultisnips/blob/master/README.md
"for excellent screencasts

"Deliberate snippet expansion: prevent unwanted replacement of tab character
"Note: many terminals capture ctrl+tab already for something
let g:UltiSnipsExpandTrigger="<c-tab>"
"Ultisnips by default already uses ctrl+tab command for listing all possible
"snippets, and this overrules. Choose another for the list 
let g:UltiSnipsListSnippets="<s-tab>"

"In visual mode, I find tab is enough to delete the selected test and dump 
"it into the visual placeholder
xn <tab> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

