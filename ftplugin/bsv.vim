let b:verilog_indent_modules = 1
" syntax clear bsv_ignore
colorscheme bsv
" [[ will add begin ... end and take you to the right indentation
inoremap <buffer> [[ begin<return><return>end<up>u<esc>==a<backspace>

source $VIMRUNTIME/macros/matchit.vim

let s:match_pairs = '\<rule:endrule,module:endmodule,method:endmethod,interface:endinterface,function:endfunction,case:endcase,begin:end\>'
let s:match_pairs = substitute(s:match_pairs, ':', '\\>:\\<', 'g')
let b:match_words = substitute(s:match_pairs, ',', '\\>,\\<', 'g')
