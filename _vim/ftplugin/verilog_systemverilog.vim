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

"Because the filetype is non-standard, Ultisnips does not load verilog or
"systemverilog specific snippets. Tell Ultisnips manually to load these
" '=~ ' is regexp operator. Be careful, single quotes on rhs!
if expand("%:t") =~ '\.sv$'
	call UltiSnips#AddFiletypes('systemverilog')
else
	call UltiSnips#AddFiletypes('verilog')
endif


"Overrule tagbar config to include instances
let g:tagbar_type_verilog_systemverilog={'ctagstype': 'SystemVerilog', 'sro': '.',
			\'kinds': ['b:blocks:1:1', 'c:constants:1:0', 'e:events:1:0', 'f:functions:1:1', 'i:instances:1:0', 'm:modules:0:1', 'n:nets:1:0', 'p:ports:1:0', 'r:registers:1:0', 't:tasks:1:1', 'A:assertions:1:1', 'C:classes:0:1', 'V:covergroups:0:1', 'I:interfaces:0:1', 'M:modport:0:1', 'K:packages:0:1', 'P:programs:0:1', 'R:properties:0:1', 'T:typedefs:0:1'], 
			\'kind2scope': {'P': 'program', 'b': 'block', 'C': 'class', 't': 'task', 'V': 'covergroup', 'f': 'function', 'I': 'interface', 'R': 'property', 'K': 'package', 'm': 'module', '?': 'unknown'}}

