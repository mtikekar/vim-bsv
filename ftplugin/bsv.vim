if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" In normal mode, % to jump cursor between matching pairs using matchit plugin
let b:match_words = '<begin>:<end>,'
let b:match_words .= '<(action|actionvalue|case|seq|par|rules|rule|typeclass|instance|function|module|method|interface)>:<end\1>'
let b:match_words = escape(b:match_words, '<>()|')

" tpope/vim-endwise settings
let b:endwise_words = 'begin,action,actionvalue,case,seq,par,rules,rule,typeclass,instance,module'
let b:endwise_addition = '\=submatch(0)=="begin"? "end": "end" . submatch(0)'
let b:endwise_syngroups = 'bsvScopeOpen'

let &l:dictionary = simplify(expand('<sfile>:p:h') . '/../bsv.words')
setlocal complete+=k

" Look for import/`include statements.
" C-x C-i can look for words in these files for completion.
" You also need to set vim's path variable. See this plugin's readme for options.

setlocal complete+=i
setlocal complete+=d
" make sure import "BVI" doesn't match
let &l:include = '\v^\s*(import\s+"@!|`include)'
setlocal suffixesadd+=.bsv
let &l:define = '\v^\s*`define'
