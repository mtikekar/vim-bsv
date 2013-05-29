colorscheme bsv

" typing begin will also add end. similarly for module, rule, case
iabbrev <buffer> begin beginend<up><end>
iabbrev <buffer> module moduleendmodule<up><end>
iabbrev <buffer> rule ruleendrule<up><end>
iabbrev <buffer> case caseendcase<up><end>

source $VIMRUNTIME/macros/matchit.vim

let s:match_pairs = '\<rule:endrule,module:endmodule,method:endmethod,interface:endinterface,function:endfunction,case:endcase,begin:end\>'
let s:match_pairs = substitute(s:match_pairs, ':', '\\>:\\<', 'g')
let b:match_words = substitute(s:match_pairs, ',', '\\>,\\<', 'g')
