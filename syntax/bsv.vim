" Vim syntax file
" Language: Bluespec SystemVerilog
" Maintainer: Mehul Tikekar
" Latest Revision: May 22, 2013

if exists("b:current_syntax")
    finish
endif

" BSV is case-sensitive
syn case match

syn match bsv_ignore ";"
syn match bsv_ignore "::\*;"

syn match bsv_assign "<-"
syn match bsv_assign "<="

" SV identifiers
syn match bsv_identifier "\<[a-z_][A-za-z_]*\>"

" comments (must be before operators, or else / gets marked as an operator)
syn keyword bsv_todo XXX FIXME TODO contained
syn match   bsv_comment "//.*$" contains=bsv_todo
syn region  bsv_comment start="/\*" end="\*/" contains=bsv_todo

" strings
syn region bsv_string start=/"/ skip=/\\"/ end=/"/

" numeric literals (XXX stolen from verilog.vim)
syn match   bsv_number "\(\<\d\+\|\)'[bB]\s*[0-1_xXzZ?]\+\>"
syn match   bsv_number "\(\<\d\+\|\)'[oO]\s*[0-7_xXzZ?]\+\>"
syn match   bsv_number "\(\<\d\+\|\)'[dD]\s*[0-9_xXzZ?]\+\>"
syn match   bsv_number "\(\<\d\+\|\)'[hH]\s*[0-9a-fA-F_xXzZ?]\+\>"
syn match   bsv_number "\<[+-]\=[0-9_]\+\(\.[0-9_]*\|\)\(e[0-9_]*\|\)\>"
syn match   bsv_number "?" 
syn keyword bsv_boolean True False

" types
syn keyword bsv_datatypes Bit UInt Int int Integer Bool Real String Fmt Void Maybe Ordering Clock Reset Inout Action ActionValue Rules File
syn keyword bsv_datatypes Tuple2 Tuple3 Tuple4 Tuple5 Tuple6 Tuple7 Tuple8

syn keyword bsv_datatypes Vector List Valid Invalid Complex FixedPoint InvalidFile
syn keyword bsv_interfaces Reg FIFO RegFile Get Put Server Client
syn keyword bsv_typeclasses Bits Eq Literal RealLiteral Arith Ord Bounded Bitwise BitReduction BitExtend

set iskeyword+=`
syn keyword bsv_preproc `include `line `define `undef `resetall `ifdef `ifndef `elsif `else `endif

syn keyword bsv_conditional if else case matches
syn keyword bsv_repeat for while
syn keyword bsv_keyword import export
syn keyword bsv_keyword typedef enum struct deriving tagged union let
syn keyword bsv_keyword module rule function instance interface method return

syn keyword bsv_scope begin end endmodule endfunction endinterface endcase endinstance endrule endaction endmethod

" attributes
syn keyword bsv_attribute contained synthesize noinline doc options split nosplit
syn keyword bsv_attribute contained always_ready always_enabled
syn keyword bsv_attribute contained ready enable result prefix port 
syn keyword bsv_attribute contained fire_when_enabled no_implicit_conditions
syn keyword bsv_attribute contained descending_urgency preempts
syn keyword bsv_attribute contained internal_scheduling method_scheduling
syn keyword bsv_attribute contained clock_prefix gate_prefix reset_prefix gate_input_clocks gate_all_clocks 
syn keyword bsv_attribute contained default_clock_osc default_clock_gate default_gate_inhigh default_gate_unused default_reset 
syn keyword bsv_attribute contained clock_family clock_ancestors
syn region  bsv_attributes start="(\*" end="\*)" contains=bsv_attribute

set iskeyword+=$
syn keyword bsv_system_task $display $displayb $displayh $displayo $write $writeb $writeh $writeo
syn keyword bsv_system_task $fopen $format $fclose $fgetc $ungetc $fflush
syn keyword bsv_system_task $fdisplay $fdisplayb $fdisplayh $fdisplayo $fwrite $fwriteb $fwriteh $fwriteo
syn keyword bsv_system_task $stop $finish $dumpon
syn keyword bsv_system_task $dumpoff $dumpvars $dumpfile $dumpflush
syn keyword bsv_system_task $time $stime $signed $unsigned $test$plusargs 

hi link bsv_comment Comment

hi link bsv_assign Keyword
hi link bsv_keyword Keyword

hi link bsv_string String
hi link bsv_number Number
hi link bsv_boolean Boolean
hi link bsv_typeclasses Boolean

hi link bsv_preproc PreProc
hi link bsv_scope Ignore
hi link bsv_datatypes Type
hi link bsv_interfaces Type

hi link bsv_conditional Conditional
hi link bsv_repeat Repeat

hi link bsv_attributes SpecialComment 
hi link bsv_attribute Keyword
hi link bsv_system_task Function
hi link bsv_ignore Ignore

let b:current_syntax = "bsv"
