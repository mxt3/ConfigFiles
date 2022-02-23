"This is the custom filetype used by the plugin  
"	vhda/verilog_systemverilog.vim 
"
"	I choose to put the config here instead of in the .vimrc

" see :help verilog_systemverilog for configuation details

" Maps to follow instance to module source
nnoremap <leader>i :VerilogFollowInstance<CR>

" Do not forget to configure a .ctags.d/*.ctags file with the required tag
" options

"enable syntax folding
setlocal foldmethod=syntax
"need to set this option to enable folding for languae constructs
let b:verilog_syntax_fold_lst="block_nested,comment,task,function"
