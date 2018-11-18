
"Enable syntastic for matlab files using the builtin support mlint

"Enable mlint
let g:syntastic_matlab_checker = ["mlint"]
"Set executable depending on system
let s:mlint_path = ''
let s:matlab_path = $MATLAB_PATH

if has('win32') || has('win64')
	if !empty(glob( s:matlab_path, 'win64/'))
		let s:mlint_path =  s:matlab_path . '/win64/'
	elseif !empty(glob( s:matlab_path, 'win32/'))
		let s:mlint_path = s:matlab_path . '/win32/'
	endif
	let g:syntastic_matlab_mlint_exec = s:mlint_path . "mlint.exe"

elseif has('unix')
	if !empty(glob( s:matlab_path, 'glnxa64/'))
		let s:mlint_path =  s:matlab_path . '/glnxa64/'
	elseif !empty(glob( s:matlab_path, 'glnxa32/'))
		let s:mlint_path = s:matlab_path . '/glnxa32/'
	endif
	let g:syntastic_matlab_mlint_exec = s:mlint_path . "mlint"

endif

"Set tab to 4 long softabs
set expandtab
set tabstop =4
set shiftwidth =4
set softtabstop =4
