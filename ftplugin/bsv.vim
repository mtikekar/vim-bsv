let b:verilog_indent_modules = 1
" syntax clear bsv_ignore
colorscheme bsv
highlight! link FoldColumn Normal
" [[ will add begin ... end and take you to the right indentation
inoremap [[ begin<return><return>end<up>u<esc>==a<backspace>
" for use with matchit.vim. Do :source $VIMRUNTIME/macros/matchit.vim in vimrc
let s:match_pairs = '\<rule:endrule,module:endmodule,method:endmethod,interface:endinterface,function:endfunction,begin:end\>'
let s:match_pairs = substitute(s:match_pairs, ':', '\\>:\\<', 'g')
let b:match_words = substitute(s:match_pairs, ',', '\\>,\\<', 'g')
