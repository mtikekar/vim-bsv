" we need the conceal feature (vim ≥ 7.3)
if exists('g:no_bsv_conceal') || !has('conceal') || &enc != 'utf-8' || !has('gui_running')
    finish
endif

syntax match bsvNiceOperator "!=" conceal cchar=≠
syntax match bsvNiceOperator "==" conceal cchar=≡
syntax match bsvNiceOperator "<-" conceal cchar=←
syntax match bsvNiceOperator "&\@<!&&&\@!" conceal cchar=∧
syntax match bsvNiceOperator "||" conceal cchar=∨
syntax match bsvNiceOperator "<<" conceal cchar=≪
syntax match bsvNiceOperator ">>" conceal cchar=≫
syntax match bsvNiceOperator ">=" conceal cchar=≥
syntax match bsvNiceOperator "<=" conceal cchar=⇐
" Register write is more common than check for less-equal.
" Checks should ideally be for x >= a and x < b so that the range is b-a.
" In the worst case, replace x <= a by a >= x or !(x > a).

hi! link Conceal Operator
setlocal conceallevel=1
