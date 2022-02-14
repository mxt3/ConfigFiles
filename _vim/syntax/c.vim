" From https://groups.google.com/g/vim_dev/c/0IDDI5WcYMk
" be able to fold #pragma regions
syn region	cPragma		start="^\s*#pragma\s\+region\>" end="^\s*#pragma\s\+endregion\>" transparent keepend extend fold
