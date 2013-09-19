" Restore default colors
set background=light

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "bsv"

" vim elements

hi Cursor guibg=IndianRed

hi Normal  guibg=grey78   guifg=black
hi NonText guibg=grey74   guifg=grey50

if version >= 700
    " Just a tad off of bg
    hi CursorLine   guibg=grey85
    hi CursorColumn guibg=grey85
endif

hi Visual     guibg=palegreen3 guifg=fg   gui=none
hi Search     guibg=LightBlue
hi IncSearch  guibg=yellow2    guifg=fg   gui=none
hi WarningMsg guibg=white      guifg=red3 gui=bold

" Outline mode highlighting
hi Outline_2_match guifg=blue3 guibg=grey83

" syntax elements
hi Comment guifg=#666666 gui=none ctermfg=Gray

hi Constant guifg=DarkGreen gui=none ctermfg=DarkGreen
hi String guifg=DarkGreen gui=italic ctermfg=DarkGreen
hi link String Number
hi link String Boolean

hi Identifier guifg=blue3 gui=none ctermfg=Blue
hi Function guifg=DodgerBlue4 gui=none ctermfg=DarkBlue

hi Statement guifg=Blue gui=none
hi Operator guifg=Black

hi PreProc guifg=DeepPink4 gui=none

hi link Define PreProc
hi link Include PreProc
hi link PreCondit PreProc

hi Type guifg=#6D16BD gui=none

hi Special guifg=DodgerBlue4  gui=none

hi Ignore guifg=#AAAAAA ctermfg=Gray

hi! link SpecialKey Identifier
hi! link Directory Identifier
hi! link MatchParen Search
