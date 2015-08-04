if exists("b:current_syntax")
    finish
endif

" BSV is case-sensitive
syntax case match

syntax match bsvAssign "<-"
syntax match bsvAssign "<="
syntax match bsvAssign "="

syntax match bsvDelimiter "?"
syntax match bsvDelimiter ":"

syntax match bsvSemicolon ";"
syntax match bsvSemicolon "::\*;"

" comments (must be before operators, or else / gets marked as an operator)
syntax match   bsvComment '\v\/\/.*$' contains=bsvTodo
syntax region  bsvComment start='\v\/\*' end='\v\*\/' contains=bsvTodo
syntax keyword bsvTodo todo contained

" strings
syntax region bsvString start=#"# skip=#\\"# end=#"#

setlocal iskeyword+='
syntax keyword bsvNumber '0 '1
syntax match   bsvNumber #\v(\+|\-|\d*)'([bB][01_]+|[oO][0-7_]+|[dD][0-9_]+|[hH][0-9a-fA-F_]+)>#
syntax match   bsvNumber '\v<\d[0-9_]*(.\d[0-9]*)=([eE][+-]=[0-9_]+)=>'
syntax keyword bsvBoolean True False

" types
syntax match bsvDatatype '\vTuple[2-8]'
syntax keyword bsvDatatype Bit UInt Int int Integer Bool Real String Fmt void Maybe Ordering Clock Reset Inout Action ActionValue Rules File BuffIndex
syntax keyword bsvDatatype Vector List Valid Invalid Complex FixedPoint InvalidFile Stmt
syntax keyword bsvInterface Reg FIFO FIFOF RegFile Get Put Server Client Empty

" type functions
syntax keyword bsvTypeclass Bits Eq Literal RealLiteral Arith Ord Bounded Bitwise BitReduction BitExtend FShow
syntax keyword bsvTypeclass Add Mul Div Log Max Min
syntax keyword bsvTypefunction TAdd TSub TMul TDiv TLog TExp TMax TMin
syntax keyword bsvTypefunction valueof valueOf SizeOf

" inbuilt functions
syntax match bsvFunction '\vtpl_[1-8]'
syntax match bsvFunction '\vtuple[2-8]'
syntax keyword bsvFunction pack unpack fromInteger when

setlocal iskeyword+=`
syntax keyword bsvPreproc `include `line `define `undef `resetall `ifdef `ifndef `elsif `else `endif

syntax keyword bsvConditional if else case matches
syntax keyword bsvRepeat for while

syntax keyword bsvKeyword import export
syntax keyword bsvKeyword typedef enum struct deriving tagged union
syntax keyword bsvKeyword numeric type provisos dependencies determines
syntax keyword bsvKeyword return let matches match default
syntax keyword bsvKeyword schedule parameter enable ready clocked_by reset_by

syntax keyword bsvScopeOpen begin action actionvalue case seq par rules rule typeclass instance function method package
syntax keyword bsvScopeClose end endaction endactionvalue endcase endseq endpar endrules endrule endtypeclass endinstance endfunction endmodule endmethod endinterface endpackage nextgroup=bsvScopeIdentifier
syntax match   bsvScopeIdentifier '\v:\S+' contained containedin=bsvScopeClose
syntax keyword bsvScopeOpen interface nextgroup=bsvNewInterface
syntax keyword bsvScopeOpen module nextgroup=bsvNewModule

"syntax match bsvInterfaceDecl '\v^interface\s+[A-Z][a-zA-Z0-9_]+' contains=bsvInterfaceName,bsvScopeOpen
syntax match bsvNewInterface '\v\s+[A-Z][a-zA-Z0-9_]+' contained containedin=bsvScopeOpen

"syntax match bsvModuleDecl '\v^module\s+[a-z][a-zA-Z0-9_]+' contains=bsvModuleName,bsvScopeOpen
syntax match bsvNewModule '\v\s+[a-z][a-zA-Z0-9_]+' contained containedin=bsvScopeOpen

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
syntax region  bsvAttributes start='\v\(\*' end='\v\*\)' contains=bsvAttribute

setlocal iskeyword+=$
syntax match bsvSystemTask '\v\$f?(display|write)[hbo]?'
syntax match bsvSystemTask '\v\$dump(on|off|vars|file|flush)'
syntax keyword bsvSystemTask $fopen $fclose $fgetc $ungetc $fflush
syntax keyword bsvSystemTask $stop $finish $time $stime
syntax keyword bsvSystemTask $format $signed $unsigned $test$plusargs

highlight link bsvSemicolon Normal
highlight link bsvAssign Operator
highlight link bsvDelimiter Operator

highlight link bsvComment Comment
highlight link bsvTodo Todo

highlight link bsvString String
highlight link bsvNumber Number
highlight link bsvBoolean Boolean

highlight link bsvDatatype Type
highlight link bsvInterface Type
highlight link bsvTypeclass Type
highlight link bsvTypefunction Type

highlight link bsvFunction Function
highlight link bsvPreproc PreProc
highlight link bsvConditional Conditional
highlight link bsvRepeat Repeat

highlight link bsvKeyword Keyword
highlight link bsvScopeOpen Keyword
highlight link bsvScopeClose Keyword
highlight link bsvScopeIdentifier Identifier

highlight link bsvNewInterface Identifier
highlight link bsvNewModule Function

highlight link bsvAttribute SpecialComment
highlight link bsvAttributes SpecialComment

highlight link bsvSystemTask Function

" we need the conceal feature (vim ≥ 7.3)
if !has('conceal') || &enc != 'utf-8' || &diff
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
" In the worst case, replace x <= a by a >= x or !(x > a).

highlight link bsvNiceOperator Operator
highlight! link Conceal Operator
setlocal conceallevel=1
