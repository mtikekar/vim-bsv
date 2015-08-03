if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" In normal mode, % to jump cursor between matching pairs
let b:match_words = '(:),{:},[:],\<begin\>:\<end\>,'
let b:match_words .= substitute('action,actionvalue,case,seq,par,rules,rule,typeclass,instance,function,module,method,interface', '\v\w+', '\\<\0\\>:\\<end\0\\>', 'g')
source $VIMRUNTIME/macros/matchit.vim

let &l:dictionary = expand('<sfile>:p:h') . "/../bsv.words"
setlocal complete+=k
