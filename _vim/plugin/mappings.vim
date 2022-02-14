"Custom mappings
"
"Keybinds placed in a seperate file to keep it clear, and
"to easiliy allow to disable all custom keybinds at once in 
"case of conflicts.
"

" General behavior {{{1
" =========================

"Press enter to remove current highlighting (and send enter again) 
nnoremap <CR> :noh<CR><CR>

"Center after search hit
nnoremap n nzz
nnoremap N Nzz

" Navigation bindings {{{1
" =========================

"map to switch to alternate(=last) buffer
nnoremap <leader>s :b#<CR>

"Toggle with \w between moving between rapped lines and moving between normal lines
"A custom function
noremap <silent> <Leader>w :call ToggleWrapMovement()<CR>

" Easier navigation to other windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Tree-style Project drawer window
noremap <silent> <Leader>p :call ProjectExplNetrw()<CR>


" Plugin Bindings {{{1
" =========================
"

" ALE Linting + LSP client
" -----------------------

"gD jumpt to first occurence in file. Like *, but start at line 1.
"Remapping at almost no cost: *ggn works as well
nmap gD <Plug>(ale_go_to_definition)
"Note, there is also the built-in gd: which searches in a scoped way for 
"first occurence. See :help gd. Useful if ALE is not available.

" buffer managment (Bbye)
" -----------------------

"map Bbye to close buffers without closing the window
noremap <silent> <Leader>q :Bdelete<CR>
"Default vim behavior: close all windows with this buffer
noremap <silent> <leader>Q :bdelete<CR>

" fzf and fzf.vim 
" ----------------
nnoremap <leader>f	:Files<CR>
" Custom function for popup file search window with preview
nnoremap <leader>F	:FilesPreview<CR>
nnoremap <leader>b	:Buffer<CR>
nnoremap <leader>h	:Helptags<CR>
" Lines in all open buffers:
nnoremap <leader>l	:Lines<CR>
nnoremap <leader>t	:Tags<CR>
" For ultisnips snippets
nnoremap <leader>S	:Snippets<CR>
cnoremap <c-r>		History:<CR>

" Intersting commands, but no keymap for now:
" :Filetypes	- easily set filetype of buffer
" :Mark			- search to marks currently set
" :Maps			- keybinds 

" Tagbar
" ----------------
"Bind leader key to toggle
nnoremap <silent> <Leader>t :TagbarToggle<CR>


" YouCompleteMe
" ----------------

" " First try definiton (only works in same translation unit), then definition.
" map <F2> :YcmCompleter GoTo<CR>
" " Go to the header that includes declaration
" map <F3> :YcmCompleter GoToInclude<CR>
" " Same as Goto but do not recompile (fast but inaccurate)
" map <F4> :YcmCompleter GoToImprecise<CR>

 

