" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentkeys=!^F,o,O,},),=end
setlocal indentexpr=bsv#Indent()
" for preserving alignment with spaces
setlocal preserveindent
setlocal copyindent

let s:openExpr = '\v(<begin>|<action>|<actionvalue>|<case>|<seq>|<par>|<rules>|\{)'
let s:closeExpr = '\v(<end>|<endaction>|<endactionvalue>|<endcase>|<endseq>|<endpar>|<endrules>|\})'

function! s:TokenLine(line)
    " Convert line to a string of ( and ) and delete all unmatched parentheses
    let line = substitute(a:line, s:openExpr, '(', 'g')
    let line = substitute(line, s:closeExpr, ')', 'g')
    let line = substitute(line, '\v[^\(\)]', '', 'g')
    let line1 = substitute(line, '\v\(\)', '', 'g')
    while strlen(line) != strlen(line1)
        let line = line1
        let line1 = substitute(line, '\v\(\)', '', 'g')
    endwhile
    return line
endfunction

function! s:NumPrevClosed(line)
    " how many exprs from previous lines closed in current line
    let line = s:TokenLine(a:line)
    return strlen(substitute(line, '\v\(', '', 'g'))
endfunction

function! s:NumNewOpened(line)
    " how many new exprs opened in current line
    let line = s:TokenLine(a:line)
    return strlen(substitute(line, '\v\)', '', 'g'))
endfunction

function! s:IsComment(lnum, line)
    " synID is supposedly slow, avoid using as far as possible
    return synIDattr(synID(a:lnum, match(a:line, '\v\S') + 1, 0), "name") ==# "bsvComment"
endfunction

function! s:PrevNonComment(lnum)
    let lnum = prevnonblank(a:lnum)
    let line = getline(lnum)
    while lnum != 0 && s:IsComment(lnum, line)
        let lnum = prevnonblank(lnum - 1)
        let line = getline(lnum)
    endwhile
    return [lnum, line]
endfunction

function! s:InModule(lnum)
    " is line in module scope
    let lnum = a:lnum
    let line = getline(lnum)
    while lnum != 0
        if line =~# '\v^\s*module>((\s\=\s)@!.)*$' && !s:IsComment(lnum, line)
            return 1
        elseif line =~# '\v^\s*endmodule>' && !s:IsComment(lnum, line)
            return 0
        endif
        " can use PrevNonComment, but this way we call InComment less often
        let lnum = prevnonblank(lnum - 1)
        let line = getline(lnum)
    endwhile
    return 0
endfunction

function! bsv#Indent()
    let [prevlnum, prevline] = s:PrevNonComment(v:lnum - 1)
    if prevlnum == 0
        return 0
    endif

    let line = getline(v:lnum)
    if s:IsComment(v:lnum, line)
        " leave comments untouched
        return indent(v:lnum)
    endif

    let ind = s:NumNewOpened(prevline)
    let singlelinecond = 0
    if !ind
        " indent if/for/else followed by single statements
        if prevline =~#'\v^\s*(if|else|for|while)>' && prevline !~# '\v\;\s*$'
            let ind += 1
            let singlelinecond = 1
        endif
    endif
    if !ind | let ind += (prevline =~# '\v^\s*(rule|typeclass|instance)>') | endif
    if !ind | let ind += (prevline =~# '\v^\s*(function|module)>((\s\=\s)@!.)*$') | endif
    if !ind | let ind += (prevline =~# '\v^\s*method>((\s\=\s)@!.)*$') && s:InModule(prevlnum) | endif
    " interface used as an expression: a = interface Put ... endinterface
    if !ind | let ind += (prevline =~# '\v\=\s*interface>') | endif
    if !ind
        " indent all interfaces and in modules and top-level
        " indent subinterfaces in modules but not in top-level
        if prevline =~# '\v^\s*interface>((\s\=\s)@!.)*$'
            if indent(prevlnum) == 0 || s:InModule(prevlnum)
                let ind += 1
            endif
        endif
    endif

    let ded = s:NumPrevClosed(line)

    if !ded
        let ded += (line =~# '\v^\s*(endrule|endtypeclass|endinstance|endfunction|endmodule|endinterface|endmethod)>')
    endif
    " to dedent after if/for/else followed by single statements
    " handle nested cases
    if !singlelinecond
        let [plnum, pline] = s:PrevNonComment(prevlnum - 1)
        while plnum != 0 && pline =~#'\v^\s*(if|else|for|while)>' && pline !~# '\v\;\s*$' && !s:NumNewOpened(pline)
            let ded += 1
            let [plnum, pline] = s:PrevNonComment(plnum - 1)
        endwhile
    endif

    return indent(prevlnum) + (ind - ded) * &shiftwidth
endfunction
