"c++11 clang compiler
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic"
"mark syntax errors with :signs
let g:syntastic_enable_signs=1
"automatically jump to the error when saving the file
let g:syntastic_auto_jump=0
"show the error list automatically
let g:syntastic_auto_loc_list=0
"don't care about warnings
"let g:syntastic_quiet_messages = {'level': 'warnings'}
"replace error arrow into X
let g:syntastic_error_symbol = "✗"
"replace warning symbol with box
let g:syntastic_warning_symbol = "⚠"
"automatically load errors into the location list
let g:syntastic_always_populate_loc_list = 1
