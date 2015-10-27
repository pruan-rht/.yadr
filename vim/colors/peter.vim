"
" Fruity Color Scheme
" ===================
"
" Author:   Armin Ronacher <armin.ronacher@active-4.com>
" Version:  0.2
"
set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="peter"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}

    call <SID>X("Normal", "cccccc", "000000", "")

    " highlight groups
    call <SID>X("Cursor", "708090", "f0e68c", "")
    "CursorIM
    "Directory
    "DiffAdd
    "DiffChange
    "DiffDelete
    "DiffText
    "ErrorMsg
    call <SID>X("VertSplit", "c2bfa5", "7f7f7f", "reverse")
    call <SID>X("Folded", "ffd700", "4d4d4d", "")
    call <SID>X("FoldColumn", "d2b48c", "4d4d4d", "")
    call <SID>X("IncSearch", "708090", "f0e68c", "")
    "LineNr
    call <SID>X("ModeMsg", "daa520", "", "")
    call <SID>X("MoreMsg", "2e8b57", "", "")
    call <SID>X("NonText", "addbe7", "000000", "bold")
    call <SID>X("Question", "00ff7f", "", "")
    call <SID>X("Search", "f5deb3", "cd853f", "")
    call <SID>X("SpecialKey", "9acd32", "", "")
    call <SID>X("StatusLine", "c2bfa5", "000000", "reverse")
    call <SID>X("StatusLineNC", "c2bfa5", "7f7f7f", "reverse")
    call <SID>X("Title", "cd5c5c", "", "")
    call <SID>X("Visual", "6b8e23", "f0e68c", "reverse")
    "VisualNOS
    call <SID>X("WarningMsg", "fa8072", "", "")
    "WildMenu
    "Menu
    "Scrollbar
    "Tooltip

    " syntax highlighting groups
    call <SID>X("Comment", "87ceeb", "", "")
    call <SID>X("Constant", "ffa0a0", "", "")
    call <SID>X("Identifier", "98fb98", "", "none")
    call <SID>X("Statement", "f0e68c", "", "bold")
    call <SID>X("PreProc", "cd5c5c", "", "")
    call <SID>X("Type", "bdb76b", "", "bold")
    call <SID>X("Special", "ffdead", "", "")
    "Underlined
    call <SID>X("Ignore", "666666", "", "")
    "Error
    call <SID>X("Todo", "ff4500", "eeee00", "")

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
else
    " color terminal definitions
    hi SpecialKey    ctermfg=darkgreen
    hi NonText       cterm=bold ctermfg=darkblue
    hi Directory     ctermfg=darkcyan
    hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
    hi IncSearch     cterm=NONE ctermfg=yellow ctermbg=green
    hi Search        cterm=NONE ctermfg=grey ctermbg=blue
    hi MoreMsg       ctermfg=darkgreen
    hi ModeMsg       cterm=NONE ctermfg=brown
    hi LineNr        ctermfg=3
    hi Question      ctermfg=green
    hi StatusLine    cterm=bold,reverse
    hi StatusLineNC  cterm=reverse
    hi VertSplit     cterm=reverse
    hi Title         ctermfg=5
    hi Visual        cterm=reverse
    hi VisualNOS     cterm=bold,underline
    hi WarningMsg    ctermfg=1
    hi WildMenu      ctermfg=0 ctermbg=3
    hi Folded        ctermfg=darkgrey ctermbg=NONE
    hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
    hi DiffAdd       ctermbg=4
    hi DiffChange    ctermbg=5
    hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
    hi DiffText      cterm=bold ctermbg=1
    "hi Comment       ctermfg=darkcyan
    hi Constant      ctermfg=brown
    hi Special       ctermfg=5
    hi Identifier    ctermfg=6
    hi Statement     ctermfg=3
    hi PreProc       ctermfg=5
    hi Type          ctermfg=2
    hi Underlined    cterm=underline ctermfg=5
    hi Ignore        ctermfg=darkgrey
    hi Error         cterm=bold ctermfg=7 ctermbg=1
endif

" vim: set fdl=0 fdm=marker:

hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "peter"

" Default Colors
hi Normal       guifg=#ffffff   guibg=#000000
hi NonText      guifg=#444444   guibg=#000000
hi Cursor       guibg=#FFFF00
hi lCursor      guibg=#FFFF00

" Search
"hi Search       guifg=#000000   guibg=#00ffff
"hi IncSearch    guifg=#000000   guibg=#ffae00

" Window Elements
hi StatusLine   guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC guibg=#c2bfa5 guifg=grey50 gui=none
hi VertSplit    guifg=#a0b0c0   guibg=#a0b0c0
hi Folded       guifg=#111111   guibg=#8090a0
hi IncSearch    guifg=#708090   guibg=#f0e68c
hi Pmenu        guifg=#ffffff   guibg=#cb2f27
hi SignColumn   guibg=#111111
hi CursorLine   guibg=#eeee00 
"#181818
hi LineNr       guifg=#aaaaaa   guibg=#222222

" Specials
hi Todo         guifg=#eeee00   guibg=#ff4500   gui=bold
hi Title        guifg=#ffffff                   gui=bold
hi Special      guifg=#fd8900

" Syntax Elements
"hi String       guifg=#BDB76B
hi String       guifg=#FFEFD5
hi Constant     guifg=#FF0007
hi Number       guifg=#FFC0CB                  gui=bold
hi Statement    guifg=#ffa500                   gui=bold
hi Function     guifg=#ffff00                   gui=bold
hi PreProc      guifg=#ff0007                   gui=bold
hi Comment      guifg=#00d2ff   guibg=#000000   gui=bold
hi Type         guifg=#9acd32                   gui=bold
hi Error        guifg=#ffffff   guibg=#ab0000
hi Identifier   guifg=#9ACD32                   gui=bold
hi Label        guifg=#9acd32

" PHP Highlighting for php.vim
hi phpFunction guifg=#CD5C5C               gui=bold

" Python Highlighting for python.vim
hi pythonCoding guifg=#ff0086
hi pythonRun    guifg=#ff0086
hi pythonBuiltinObj     guifg=#2b6ba2           gui=bold
hi pythonBuiltinFunc    guifg=#2b6ba2           gui=bold
hi pythonException      guifg=#9acd32           gui=bold
hi pythonExClass        guifg=#66cd66           gui=bold
hi pythonSpaceError     guibg=#270000
hi pythonDocString    guifg=#2f5f49
"hi pythonDocString    guifg=#2f5f49
hi pythonDocTest2   guifg=#3b916a
hi pythonFunction   guifg=#ffff00               gui=bold
hi pythonClass      guifg=#CD5C5C
"hi String       guifg=#FFEFD5
hi Constant     guifg=#FF0007
hi Number       guifg=#FFC0CB               gui=bold
hi pythonString     guifg=#FFEFD5
"hi pythonString     guifg=#CD5C5C
hi pythonKeyword    guifg=#FFA500               
"gui=bold

" JavaScript Highlighting
hi javaScript                   guifg=#ffffff
hi javaScriptRegexpString       guifg=#aa6600
hi javaScriptDocComment         guifg=#aaaaaa
hi javaScriptCssStyles          guifg=#dd7700
hi javaScriptDomElemFuncs       guifg=#66cd66
hi javaScriptHtmlElemFuncs      guifg=#dd7700
hi javaScriptLabel              guifg=#00bdec   gui=italic
hi javaScriptPrototype          guifg=#00bdec
hi javaScriptConditional        guifg=#ff0007   gui=bold
hi javaScriptRepeat             guifg=#ff0007   gui=bold
hi javaScriptFunction           guifg=#ff0086   gui=bold

" CSS Highlighting
hi cssIdentifier            guifg=#66cd66       gui=bold
hi cssBraces                guifg=#00bdec       gui=bold

" Ruby Highlighting
hi rubyFunction     guifg=#0066bb               gui=bold
hi rubyClass        guifg=#ff0086               gui=bold
hi rubyModule       guifg=#ff0086               gui=bold,underline
hi rubyKeyword      guifg=#008800               gui=bold
hi rubySymbol       guifg=#aa6600
hi rubyIndentifier              guifg=#008aff
hi rubyGlobalVariable           guifg=#dd7700
hi rubyConstant                 guifg=#5894d2   gui=bold
hi rubyBlockParameter           guifg=#66cd66
hi rubyPredefinedIdentifier     guifg=#555555   gui=bold
hi rubyString           guifg=#0086d2
hi rubyStringDelimiter  guifg=#dd7700
hi rubySpaceError       guibg=#270000
hi rubyDocumentation    guifg=#aaaaaa
hi rubyData             guifg=#555555

" XML Highlighting
hi xmlTag           guifg=#00bdec
hi xmlTagName       guifg=#00bdec
hi xmlEndTag        guifg=#00bdec
hi xmlNamespace     guifg=#00bdec                   gui=underline
hi xmlAttribPunct   guifg=#cccaa9                   gui=bold
hi xmlEqual         guifg=#cccaa9                   gui=bold
hi xmlCdata         guifg=#bf0945                   gui=bold
hi xmlCdataCdata	guifg=#ac1446   guibg=#23010c   gui=none
hi xmlCdataStart	guifg=#bf0945                   gui=bold
hi xmlCdataEnd		guifg=#bf0945                   gui=bold

" HTML Highlighting
hi htmlTag          guifg=#ff7f50               gui=bold
hi htmlEndTag       guifg=#ff7f50               gui=bold
hi htmlSpecialTagName   guifg=#9ACD32           gui=bold
hi htmlTagName      guifg=#66cd66              
hi htmlTagN         guifg=#66cd66                 
hi htmlEvent        guifg=#ffffff

" Django Highlighting
hi djangoTagBlock   guifg=#ff0007   guibg=#200000   gui=bold
hi djangoVarBlock   guifg=#ff0007   guibg=#200000
hi djangoArgument   guifg=#0086d2   guibg=#200000
hi djangoStatement  guifg=#fb660a   guibg=#200000   gui=bold
hi djangoComment    guifg=#008800   guibg=#002300   gui=italic
hi djangoFilter     guifg=#ff0086   guibg=#200000   gui=italic
" highlight groups
hi Cursor   guibg=yellow guifg=slategrey
"hi Cursor   guibg=khaki guifg=slategrey
"hi CursorIM    
"hi Directory   
"hi DiffAdd             
"hi DiffChange  
"hi DiffDelete  
"hi DiffText    
"hi ErrorMsg    
hi VertSplit    guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded   guibg=grey30 guifg=gold 
hi FoldColumn   guibg=grey30 guifg=tan
hi IncSearch    guifg=slategrey guibg=khaki
"hi LineNr              
hi ModeMsg  guifg=goldenrod
hi MoreMsg  guifg=SeaGreen
hi NonText  guifg=LightBlue guibg=grey30
hi Question guifg=springgreen
hi Search   guibg=peru guifg=wheat
hi SpecialKey   guifg=yellowgreen
hi StatusLine   guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC guibg=#c2bfa5 guifg=grey50 gui=none
hi Title    guifg=indianred
hi Visual   gui=none guifg=khaki guibg=olivedrab
"hi VisualNOS   
hi WarningMsg   guifg=salmon
"hi WildMenu    
"hi Menu                
"hi Scrollbar   
"hi Tooltip             

" syntax highlighting groups
"hi Comment   guifg=SkyBlue
hi Constant  guifg=#ffa0a0
"hi Identifier    guifg=palegreen
"hi Statement     guifg=khaki
hi PreProc   guifg=indianred
hi Type      guifg=darkkhaki
hi Special   guifg=navajowhite
"hi Underlined  
hi Ignore    guifg=grey40
"hi Error           
hi Todo      guifg=orangered guibg=yellow2

" color terminal definitions
hi SpecialKey    ctermfg=darkgreen
hi NonText       cterm=bold ctermfg=darkblue
hi Directory     ctermfg=darkcyan
hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
hi IncSearch     cterm=NONE ctermfg=yellow ctermbg=green
hi Search        cterm=NONE ctermfg=grey ctermbg=blue
hi MoreMsg       ctermfg=darkgreen
hi ModeMsg       cterm=NONE ctermfg=brown
hi LineNr        ctermfg=3
hi Question      ctermfg=green
hi StatusLine    cterm=bold,reverse
hi StatusLineNC  cterm=reverse
hi VertSplit     cterm=reverse
hi Title         ctermfg=5
hi Visual        cterm=reverse
hi VisualNOS     cterm=bold,underline
hi WarningMsg    ctermfg=1
hi WildMenu      ctermfg=0 ctermbg=3
hi Folded        ctermfg=darkgrey ctermbg=NONE
hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
hi DiffAdd       ctermbg=4
hi DiffChange    ctermbg=5
hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
hi DiffText      cterm=bold ctermbg=1
"hi Comment       ctermfg=darkcyan
hi Constant      ctermfg=brown
hi Special       ctermfg=5
hi Identifier    ctermfg=6
hi Statement     ctermfg=3
hi PreProc       ctermfg=5
hi Type          ctermfg=2
hi Underlined    cterm=underline ctermfg=5
hi Ignore        ctermfg=darkgrey
hi Error         cterm=bold ctermfg=7 ctermbg=1
