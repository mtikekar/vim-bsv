" Language:     Bluespec System Verilog (BSV)
"
" Credits:
"   Hadar Agam <hagam at bluespec dot com >
"   Originally created by
"       Chih-Tsun Huang <cthuang@larc.ee.nthu.edu.tw>
" 	http://larc.ee.nthu.edu.tw/~cthuang/vim/indent/verilog.vim
"
" Buffer Variables:
"     b:verilog_indent_verbose : verbose to each indenting

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetBSVIndent(v:lnum)
setlocal indentkeys=!^F,o,O,0),0},=begin,=end
setlocal indentkeys+==`else,=`endif

let s:maxoff = 50
" Find backwards the closest open parenthesis/bracket/brace.
function! s:SearchParensPair()
    let line = line('.')
    let col = col('.')
    
    " Skip strings and comments and don't look too far
    let skip = "line('.') < " . (line - s:maxoff) . " ? dummy :" .
                \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? ' .
                \ '"string\\|comment"'

    " Search for parentheses
    call cursor(line, col)
    let parlnum = searchpair('(', '', ')', 'bW', skip)
    let parcol = col('.')

    " Search for brackets
    call cursor(line, col)
    let par2lnum = searchpair('\[', '', '\]', 'bW', skip)
    let par2col = col('.')

    " Search for braces
    call cursor(line, col)
    let par3lnum = searchpair('{', '', '}', 'bW', skip)
    let par3col = col('.')

    " Get the closest match
    if par2lnum > parlnum || (par2lnum == parlnum && par2col > parcol)
        let parlnum = par2lnum
        let parcol = par2col
    endif
    if par3lnum > parlnum || (par3lnum == parlnum && par3col > parcol)
        let parlnum = par3lnum
        let parcol = par3col
    endif 

    " Put the cursor on the match
    if parlnum > 0
        call cursor(parlnum, parcol)
    endif
    return parlnum
endfunction

set cpo-=C

function! GetBSVIndent(linenum)
    " At the start of the file use zero indent.
    if a:linenum == 1
        return 0
    endif
   
    " If we can find an open parenthesis/bracket/brace, line up with it.
    call cursor(a:linenum, 1)
    let parlnum = s:SearchParensPair()
    if parlnum > 0
        let parcol = col('.')
        let closing_paren = match(getline(a:linenum), '^\s*[])}]') != -1
        if match(getline(parlnum), '[([{]\s*$', parcol - 1) != -1
            if closing_paren
                return indent(parlnum)
            else
                return indent(parlnum) + &shiftwidth
            endif
        else
            if closing_paren
                return parcol - 1
            else
                return parcol
            endif
        endif
    endif

    let offset = &shiftwidth
    let indent_modules = offset

    " Find a non-blank line above the current line.
    let lnum = prevnonblank(a:linenum - 1)
    
    let lnum2 = prevnonblank(lnum - 1)
    let curr_line  = getline(a:linenum)
    let last_line  = getline(lnum)
    let last_line2 = getline(lnum2)
    let ind  = indent(lnum)
    let ind2 = indent(lnum - 1)
    let offset_comment1 = 0
    " Define the condition of an open statement
    "   Exclude the match of //, /* or */
    let vlog_openstat = '\(\<or\>\|\([*/]\)\@<![*(,{><+-/%^&|!=?:]\([*/]\)\@!\)'
    " Define the condition when the statement ends with a one-line comment
    let vlog_comment = '\(//.*\|/\*.*\*/\s*\)'
    if exists('b:verilog_indent_verbose')
        let vverb_str = 'INDENT VERBOSE:'
        let vverb = 1
    else
        let vverb = 0
    endif

    " Indent accoding to last line
    " End of multiple-line comment
    if last_line =~ '\*/\s*$' && last_line !~ '/\*.\{-}\*/'
        let ind = ind - offset_comment1
        if vverb
            echo vverb_str "De-indent after a multiple-line comment."
        endif

    elseif last_line =~ '^\s*\<rule\>'
        if last_line !~ '\<end\>\s*' . vlog_comment . '*$' ||
                    \ last_line =~ '\(//\|/\*\).*\(;\|\<end\>\)\s*' . vlog_comment . '*$'
            let ind = ind + offset
            if vverb
                echo vverb_str "Indent after rule block statement."
            endif
        endif


        " Indent after if/else/for/case/always/initial/specify/fork blocks
    elseif last_line =~ '`\@<!\<\(if\|else\)\>' ||
                \ last_line =~ '^\s*\<\(for\|case\%[[zx]]\|do\|foreach\|randcase\)\>' ||
                \ last_line =~ '^\s*\<\(always\|always_comb\|always_ff\|always_latch\)\>' ||
                \ last_line =~ '^\s*\<\(initial\|specify\|fork\|final\)\>'
        if last_line !~ '\(;\|\<end\>\)\s*' . vlog_comment . '*$' ||
                    \ last_line =~ '\(//\|/\*\).*\(;\|\<end\>\)\s*' . vlog_comment . '*$'
            if last_line !~ '^\s*' . vlog_comment
                let ind = ind + offset
                if vverb | echo vverb_str "Indent after a block statement." | endif
            endif
        endif
        " Indent after task/class/package/sequence/clocking .. blocks
    elseif last_line =~ '^\s*\<\(task\|class\|package\)\>' ||
                \ last_line =~ '^\s*\<\(sequence\|clocking\|rule\|instance\|typeclass\)\>' ||
                \ last_line =~ '^\s*\(\w\+\s*:\)\=\s*\<covergroup\>' ||
                \ last_line =~ '^\s*\<\(property\|program\)\>'
        if last_line !~ '\<end\>\s*' . vlog_comment . '*$' ||
                    \ last_line =~ '\(//\|/\*\).*\(;\|\<end\>\)\s*' . vlog_comment . '*$'
            let ind = ind + offset
            if vverb
                echo vverb_str "Indent after task/class block statement."
            endif
        endif

        " Indent after module blocks
    elseif last_line =~ '^\s*\(\<extern\>\s*\)\=\<module\>'
        let ind = ind + indent_modules
        if vverb && indent_modules
            echo vverb_str "Indent after module statement."
        endif
        if last_line =~ '[(,]\s*' . vlog_comment . '*$' &&
                    \ last_line !~ '\(//\|/\*\).*[(,]\s*' . vlog_comment . '*$'
            let ind = ind + offset
            if vverb
                echo vverb_str "Indent after a multiple-line module statement."
            endif
        endif

        " Indent after a 'begin' statement
    elseif last_line =~ '\(\<\(begin\|action\|actionvalue\)\>\)\(\s*:\s*\w\+\)*' . vlog_comment . '*$' &&
                \ last_line !~ '\(//\|/\*\).*\(\<begin\>\)' &&
                \ ( last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
                \ last_line2 =~ '^\s*[^=!]\+\s*:\s*' . vlog_comment . '*$' )
        let ind = ind + offset
        if vverb | echo vverb_str "Indent after begin statement." | endif

        " Indent after a '{' or a '('
    elseif last_line =~ '[{(]' . vlog_comment . '*$' &&
                \ last_line !~ '\(//\|/\*\).*[{(]' &&
                \ ( last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
                \ last_line2 =~ '^\s*[^=!]\+\s*:\s*' . vlog_comment . '*$' )
        let ind = ind + offset
        if vverb | echo vverb_str "Indent after begin statement." | endif

        " De-indent for the end of one-line block
    elseif ( last_line !~ '\<begin\>' ||
                \ last_line =~ '\(//\|/\*\).*\<begin\>' ) &&
                \ last_line2 =~ '\<\(`\@<!if\|`\@<!else\|for\|always\|initial\|do\|foreach\|final\)\>.*' .
                \ vlog_comment . '*$' &&
                \ last_line2 !~
                \
        '\(//\|/\*\).*\<\(`\@<!if\|`\@<!else\|for\|always\|initial\|do\|foreach\|final\)\>' &&
                    \ last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
                    \ ( last_line2 !~ '\<begin\>' ||
                    \ last_line2 =~ '\(//\|/\*\).*\<begin\>' )
        let ind = ind - offset
        if vverb
            echo vverb_str "De-indent after the end of one-line statement."
        endif

        " Multiple-line statement (including case statement)
        " Open statement
        "   Ident the first open line
    elseif  last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
                \ last_line !~ '\(//\|/\*\).*' . vlog_openstat . '\s*$' &&
                \ last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$'
        let ind = ind + offset
        if vverb | echo vverb_str "Indent after an open statement." | endif

        " Close statement
        "   De-indent for an optional close parenthesis and a semicolon, and only
        "   if there exists precedent non-whitespace char
    elseif last_line =~ ')*\s*;\s*' . vlog_comment . '*$' &&
                \ last_line !~ '^\s*)*\s*;\s*' . vlog_comment . '*$' &&
                \ last_line !~ '\(//\|/\*\).*\S)*\s*;\s*' . vlog_comment . '*$' &&
                \ ( last_line2 =~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
                \ last_line2 !~ ';\s*//.*$') &&
                \ last_line2 !~ '^\s*' . vlog_comment . '$'
        let ind = ind - offset
        if vverb | echo vverb_str "De-indent after a close statement." | endif

        " `ifdef and `else
    elseif last_line =~ '^\s*`\<\(ifdef\|else\)\>'
        let ind = ind + offset
        if vverb
            echo vverb_str "Indent after a `ifdef or `else statement."
        endif

    endif

    " Re-indent current line

    " De-indent on the end of the block
    " join/end/endcase/endfunction/endtask/endspecify
    if curr_line =~ '^\s*\<\(join\|join_any\|join_none\|\|end\|endcase\|while\)\>' ||
                \ curr_line =~ '^\s*\<\(endaction\|endactionvalue\|endtask\|endspecify\|endclass\)\>' ||
                \ curr_line =~ '^\s*\<\(endpackage\|endsequence\|endclocking\|endrule\|endinstance\|endtypeclass\)\>' ||
                \ curr_line =~ '^\s*\<\(endgroup\|endproperty\|endprogram\)\>' ||
                \ curr_line =~ '^\s*}'
        let ind = ind - offset
        if vverb | echo vverb_str "De-indent the end of a block." | endif
    elseif curr_line =~ '^\s*\<endmodule\>'
        let ind = ind - indent_modules
        if vverb && indent_modules
            echo vverb_str "De-indent the end of a module."
        endif

        " De-indent on a stand-alone 'begin'
    elseif curr_line =~ '^\s*\<begin\>'
        if last_line !~ '^\s*\<\(action\|actionvalue\|task\|specify\|module\|class\|package\)\>' ||
                    \ last_line !~ '^\s*\<\(sequence\|clocking\|rule\|covergroup\)\>' ||
                    \ last_line !~ '^\s*\<\(property\|program\)\>' &&
                    \ last_line !~ '^\s*\()*\s*;\|)\+\)\s*' . vlog_comment . '*$' &&
                    \ ( last_line =~
                    \ '\<\(`\@<!if\|`\@<!else\|for\|case\%[[zx]]\|always\|initial\|do\|foreach\|randcase\|final\)\>' ||
                    \ last_line =~ ')\s*' . vlog_comment . '*$' ||
                    \ last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' )
            let ind = ind - offset
            if vverb
                echo vverb_str "De-indent a stand alone begin statement."
            endif
        endif

        " De-indent after the end of multiple-line statement
    elseif curr_line =~ '^\s*)' &&
                \ ( last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
                \ last_line !~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
                \ last_line2 =~ vlog_openstat . '\s*' . vlog_comment . '*$' )
        let ind = ind - offset
        if vverb
            echo vverb_str "De-indent the end of a multiple statement."
        endif

        " De-indent `else and `endif
    elseif curr_line =~ '^\s*`\<\(else\|endif\)\>'
        let ind = ind - offset
        if vverb | echo vverb_str "De-indent `else and `endif statement." | endif

    endif

    " Return the indention
    return ind
endfunction
