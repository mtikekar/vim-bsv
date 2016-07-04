if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" In normal mode, % to jump cursor between matching pairs using matchit plugin
let b:match_words = '(:),{:},[:],\<begin\>:\<end\>,'
let b:match_words .= substitute('action,actionvalue,case,seq,par,rules,rule,typeclass,instance,function,module,method,interface', '\v\w+', '\\<\0\\>:\\<end\0\\>', 'g')

let &l:dictionary = expand('<sfile>:p:h') . '/../bsv.words'
setlocal complete+=k

" Look for import/`include statements.
" C-x C-i can look for words in these files for completion.
" You also need to set path variable in vim (same as bsc's path option)
" There are several ways to do this:
" 1. Per project: set exrc secure, put a .vimrc in your project folder with set path=...
" 2. Per file: set modeline, put a comment at the beginning of your code // vim:path=...
" 3. Per project: same as above with: autocmd BufWinEnter *.bsv if &l:path != '' | let &path = &l:path | endif
" (note the colon at the end)
" 4. roll your own file format that can be read by both vim and your build script
" Do :help path, :help exrc, :help modeline for more info

setlocal complete+=i
setlocal complete+=d
" make sure import "BVI" doesn't match
let &l:include = '\v^\s*(import\s+"@!|`include)'
setlocal suffixesadd+=.bsv
let &l:define = '\v^\s*`define'
