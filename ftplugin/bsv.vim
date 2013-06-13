if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1
set textwidth=76

colorscheme bsv

" typing begin will also add end. similarly for module, rule, case
iabbrev <buffer> begin begin<cr>end<up><end>
iabbrev <buffer> module module<cr>endmodule<up><end>
iabbrev <buffer> rule rule<cr>endrule<up><end>
iabbrev <buffer> case case<cr>endcase<up><end>
iabbrev <buffer> method method<cr>endmethod<up><end>
iabbrev <buffer> interface interface<cr>endinterface<up><end>

" In normal mode, % to jump cursor between matching pairs
let s:match_pairs = '(:),{:},[:],rule:endrule,module:endmodule,method:endmethod,interface:endinterface,function:endfunction,case:endcase,begin:end'
let s:match_sep = '\<'.substitute(s:match_pairs, ':', '\\>:\\<', 'g').'\>'
let b:match_words = substitute(s:match_sep, ',', '\\>,\\<', 'g')
"let b:delimitMate_matchpairs = s:match_pairs
source $VIMRUNTIME/macros/matchit.vim

setlocal expandtab      " use spaces, not tab
setlocal shiftwidth=4   " number of spaces to use for each indent
setlocal tabstop=4      " number of spaces that a <Tab> counts for
