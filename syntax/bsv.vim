" Vim syntax file
" Language: Bluespec SystemVerilog
" Maintainer: Mehul Tikekar
" Latest Revision: May 22, 2013

if exists("b:current_syntax")
    finish
endif

" BSV is case-sensitive
syntax case match

if exists("g:bsv_ignore_semicolon")
    syntax match bsvIgnore ";"
    syntax match bsvIgnore "::\*;"
    highlight link bsvIgnore Ignore
endif

syntax match bsvAssign "<-"
syntax match bsvAssign "<="

" comments (must be before operators, or else / gets marked as an operator)
syntax keyword bsvTodo XXX FIXME TODO contained
syntax match   bsvComment "//.*$" contains=bsvTodo
syntax region  bsvComment start="/\*" end="\*/" contains=bsvTodo
"syntax match   bsvComment "//?.*$" contains=bsvTodo transparent
"syntax match   bsvComment "//[^?].*$" contains=bsvTodo
"syntax region  bsvComment start="/\*?" end="\*/" contains=bsvTodo transparent
"syntax region  bsvComment start="/\*[^?]" end="\*/" contains=bsvTodo

" strings
syntax region bsvString start=#"# skip=#\\"# end=#"#

setlocal iskeyword+='
syntax keyword bsvNumber '0 '1 False True
syntax match   bsvNumber #\v(\+|\-|\d*)'([bB][01_]+|[oO][0-7_]+|[dD][0-9_]+|[hH][0-9a-fA-F_]+)>#
syntax match   bsvNumber '\v<\d[0-9_]*(.\d[0-9]*)=([eE][+-]=[0-9_]+)=>'

" types
syntax keyword bsvDatatypes Bit UInt Int int Integer Bool Real String Fmt Void Maybe Ordering Clock Reset Inout Action ActionValue Rules File
syntax keyword bsvDatatypes Tuple2 Tuple3 Tuple4 Tuple5 Tuple6 Tuple7 Tuple8

syntax keyword bsvDatatypes Vector List Valid Invalid Complex FixedPoint InvalidFile
syntax keyword bsvInterfaces Reg FIFO RegFile Get Put Server Client Empty
syntax keyword bsvTypeclasses Bits Eq Literal RealLiteral Arith Ord Bounded Bitwise BitReduction BitExtend

setlocal iskeyword+=`
syntax keyword bsvPreproc `include `line `define `undef `resetall `ifdef `ifndef `elsif `else `endif

syntax keyword bsvConditional if else case matches
syntax keyword bsvRepeat for while
syntax keyword bsvKeyword import export
syntax keyword bsvKeyword typedef enum struct deriving tagged union let matches
syntax keyword bsvKeyword module rule function instance interface method rules return
syntax keyword bsvKeyword numeric type provisos

syntax keyword bsvScope begin end endmodule endfunction endinterface endcase endinstance endrule endaction endmethod endrules nextgroup=bsvScopeIdentifier
syntax match   bsvScopeIdentifier '\v:\S+' contained containedin=bsvScope

" attributes
syntax keyword bsvAttribute contained synthesize noinline doc options split nosplit
syntax keyword bsvAttribute contained always_ready always_enabled
syntax keyword bsvAttribute contained ready enable result prefix port 
syntax keyword bsvAttribute contained fire_when_enabled no_implicit_conditions
syntax keyword bsvAttribute contained descending_urgency preempts
syntax keyword bsvAttribute contained internal_scheduling method_scheduling
syntax keyword bsvAttribute contained clock_prefix gate_prefix reset_prefix gate_input_clocks gate_all_clocks 
syntax keyword bsvAttribute contained default_clock_osc default_clock_gate default_gate_inhigh default_gate_unused default_reset 
syntax keyword bsvAttribute contained clock_family clock_ancestors
syntax region  bsvAttributes start="(\*" end="\*)" contains=bsvAttribute

setlocal iskeyword+=$
syntax keyword bsvSystemTask $display $displayb $displayh $displayo $write $writeb $writeh $writeo
syntax keyword bsvSystemTask $fopen $format $fclose $fgetc $ungetc $fflush
syntax keyword bsvSystemTask $fdisplay $fdisplayb $fdisplayh $fdisplayo $fwrite $fwriteb $fwriteh $fwriteo
syntax keyword bsvSystemTask $stop $finish $dumpon
syntax keyword bsvSystemTask $dumpoff $dumpvars $dumpfile $dumpflush
syntax keyword bsvSystemTask $time $stime $signed $unsigned $test$plusargs 

highlight link bsvComment Comment

highlight link bsvAssign Keyword
highlight link bsvKeyword Keyword

highlight link bsvString String
highlight link bsvNumber Number
highlight link bsvBoolean Boolean
highlight link bsvTypeclasses Boolean

highlight link bsvPreproc PreProc
highlight link bsvScope Ignore
highlight link bsvScopeIdentifier Function

highlight link bsvDatatypes Type
highlight link bsvInterfaces Type

highlight link bsvConditional Conditional
highlight link bsvRepeat Repeat

highlight link bsvAttributes SpecialComment 
highlight link bsvAttribute Keyword
highlight link bsvSystemTask Function

let b:current_syntax = "bsv"
