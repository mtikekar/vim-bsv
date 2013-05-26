" Vim syntax file
" Language: Bluespec SystemVerilog
" Maintainer: Mehul Tikekar
" Latest Revision: May 22, 2013

if exists("b:current_syntax")
    finish
endif

" BSV is case-sensitive
syntax case match

if exists("g:bsv_ignore_semi")
    syntax match bsv_ignore ";"
    syntax match bsv_ignore "::\*;"
    highlight link bsv_ignore Ignore
endif

syntax match bsv_assign "<-"
syntax match bsv_assign "<="

" comments (must be before operators, or else / gets marked as an operator)
syntax keyword bsv_todo XXX FIXME TODO contained
syntax match   bsv_comment "//.*$" contains=bsv_todo
syntax region  bsv_comment start="/\*" end="\*/" contains=bsv_todo

" strings
syntax region bsv_string start=#"# skip=#\\"# end=#"#

setlocal iskeyword+='
syntax keyword bsv_number '0 '1 False True
syntax match   bsv_number #\v(\+|\-|\d*)'([bB][01_]+|[oO][0-7_]+|[dD][0-9_]+|[hH][0-9a-fA-F_]+)>#
syntax match   bsv_number '\v<\d[0-9_]*(.\d[0-9]*)=([eE][+-]=[0-9_]+)=>'

" types
syntax keyword bsv_datatypes Bit UInt Int int Integer Bool Real String Fmt Void Maybe Ordering Clock Reset Inout Action ActionValue Rules File
syntax keyword bsv_datatypes Tuple2 Tuple3 Tuple4 Tuple5 Tuple6 Tuple7 Tuple8

syntax keyword bsv_datatypes Vector List Valid Invalid Complex FixedPoint InvalidFile
syntax keyword bsv_interfaces Reg FIFO RegFile Get Put Server Client
syntax keyword bsv_typeclasses Bits Eq Literal RealLiteral Arith Ord Bounded Bitwise BitReduction BitExtend

setlocal iskeyword+=`
syntax keyword bsv_preproc `include `line `define `undef `resetall `ifdef `ifndef `elsif `else `endif

syntax keyword bsv_conditional if else case matches
syntax keyword bsv_repeat for while
syntax keyword bsv_keyword import export
syntax keyword bsv_keyword typedef enum struct deriving tagged union let
syntax keyword bsv_keyword module rule function instance interface method return

syntax keyword bsv_scope begin end endmodule endfunction endinterface endcase endinstance endrule endaction endmethod nextgroup=bsv_scope_identifier
syntax match   bsv_scope_identifier '\v:\S+' contained containedin=bsv_scope

" attributes
syntax keyword bsv_attribute contained synthesize noinline doc options split nosplit
syntax keyword bsv_attribute contained always_ready always_enabled
syntax keyword bsv_attribute contained ready enable result prefix port 
syntax keyword bsv_attribute contained fire_when_enabled no_implicit_conditions
syntax keyword bsv_attribute contained descending_urgency preempts
syntax keyword bsv_attribute contained internal_scheduling method_scheduling
syntax keyword bsv_attribute contained clock_prefix gate_prefix reset_prefix gate_input_clocks gate_all_clocks 
syntax keyword bsv_attribute contained default_clock_osc default_clock_gate default_gate_inhigh default_gate_unused default_reset 
syntax keyword bsv_attribute contained clock_family clock_ancestors
syntax region  bsv_attributes start="(\*" end="\*)" contains=bsv_attribute

setlocal iskeyword+=$
syntax keyword bsv_system_task $display $displayb $displayh $displayo $write $writeb $writeh $writeo
syntax keyword bsv_system_task $fopen $format $fclose $fgetc $ungetc $fflush
syntax keyword bsv_system_task $fdisplay $fdisplayb $fdisplayh $fdisplayo $fwrite $fwriteb $fwriteh $fwriteo
syntax keyword bsv_system_task $stop $finish $dumpon
syntax keyword bsv_system_task $dumpoff $dumpvars $dumpfile $dumpflush
syntax keyword bsv_system_task $time $stime $signed $unsigned $test$plusargs 

highlight link bsv_comment Comment

highlight link bsv_assign Keyword
highlight link bsv_keyword Keyword

highlight link bsv_string String
highlight link bsv_number Number
highlight link bsv_boolean Boolean
highlight link bsv_typeclasses Boolean

highlight link bsv_preproc PreProc
highlight link bsv_scope Ignore
highlight link bsv_scope_identifier Function

highlight link bsv_datatypes Type
highlight link bsv_interfaces Type

highlight link bsv_conditional Conditional
highlight link bsv_repeat Repeat

highlight link bsv_attributes SpecialComment 
highlight link bsv_attribute Keyword
highlight link bsv_system_task Function

let b:current_syntax = "bsv"
