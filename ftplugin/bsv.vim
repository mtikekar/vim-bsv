if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1
set textwidth=100
set colorcolumn=77

" colorscheme bsv

" In normal mode, % to jump cursor between matching pairs
let s:match_pairs = '\<rule:endrule,module:endmodule,method:endmethod,interface:endinterface,function:endfunction,case:endcase,begin:end\>'
let s:match_pairs = substitute(s:match_pairs, ':', '\\>:\\<', 'g')
let b:match_words = substitute(s:match_pairs, ',', '\\>,\\<', 'g')
source $VIMRUNTIME/macros/matchit.vim
