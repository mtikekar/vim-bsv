let b:verilog_indent_modules = 1
" syntax clear bsv_ignore
colorscheme bsv
highlight! link FoldColumn Normal
" [[ will add begin ... end and take you to the right indentation
inoremap [[ begin<return><return>end<up>u<esc>==a<backspace>
