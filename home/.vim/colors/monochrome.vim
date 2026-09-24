" monochrome.vim — pure grayscale, matches the static Monochrome desktop palette
let g:colors_name = 'monochrome'
set background=dark
hi clear
if exists('syntax_reset') | call syntax_reset() | endif

hi Normal       guifg=#f0f0f0 guibg=#161616
hi NonText      guifg=#3c3c3c guibg=#161616
hi Comment      guifg=#8a8a8a gui=italic
hi Constant     guifg=#d0d0d0
hi String       guifg=#c8c8c8
hi Character    guifg=#c8c8c8
hi Number       guifg=#d0d0d0
hi Boolean      guifg=#d0d0d0
hi Float        guifg=#d0d0d0
hi Identifier   guifg=#e8e8e8
hi Function     guifg=#ffffff
hi Statement    guifg=#f0f0f0 gui=bold
hi Conditional  guifg=#f0f0f0 gui=bold
hi Repeat       guifg=#f0f0f0 gui=bold
hi Label        guifg=#e0e0e0
hi Operator     guifg=#e0e0e0
hi Keyword      guifg=#ffffff gui=bold
hi Exception    guifg=#ffffff
hi PreProc      guifg=#b8b8b8
hi Include      guifg=#e0e0e0
hi Define       guifg=#e0e0e0
hi Macro        guifg=#b8b8b8
hi Type         guifg=#c0c0c0 gui=bold
hi StorageClass guifg=#c0c0c0
hi Structure    guifg=#c0c0c0
hi Typedef      guifg=#c0c0c0
hi Special      guifg=#e0e0e0
hi SpecialComment guifg=#8a8a8a
hi Delimiter    guifg=#b0b0b0
hi Underlined   guifg=#f0f0f0 gui=underline
hi Error        guifg=#ffffff guibg=#3c3c3c gui=bold
hi Todo         guifg=#161616 guibg=#e0e0e0 gui=bold
hi CursorLine   guibg=#1e1e1e
hi CursorColumn guibg=#1e1e1e
hi ColorColumn  guibg=#1e1e1e
hi LineNr       guifg=#4a4a4a guibg=#161616
hi CursorLineNr guifg=#e0e0e0 guibg=#1e1e1e gui=bold
hi SignColumn   guifg=#666666 guibg=#161616
hi VertSplit    guifg=#333333 guibg=#161616
hi StatusLine   guifg=#161616 guibg=#e0e0e0 gui=bold
hi StatusLineNC guifg=#b3b3b3 guibg=#333333
hi TabLine      guifg=#b3b3b3 guibg=#242424
hi TabLineFill  guifg=#8a8a8a guibg=#161616
hi Pmenu        guifg=#f0f0f0 guibg=#242424
hi PmenuSel     guifg=#161616 guibg=#e0e0e0 gui=bold
hi PmenuSbar    guibg=#333333
hi PmenuThumb   guibg=#666666
hi Visual       guibg=#333333
hi Search       guifg=#161616 guibg=#e0e0e0
hi IncSearch    guifg=#161616 guibg=#ffffff gui=bold
hi Directory    guifg=#ffffff
hi Title        guifg=#ffffff gui=bold
hi Question     guifg=#e0e0e0
hi MoreMsg      guifg=#e0e0e0
hi ModeMsg      guifg=#f0f0f0 gui=bold
hi WarningMsg   guifg=#e0e0e0 gui=bold
hi ErrorMsg     guifg=#ffffff guibg=#333333 gui=bold
hi WildMenu     guifg=#161616 guibg=#e0e0e0
hi Folded       guifg=#8a8a8a guibg=#1e1e1e
hi FoldColumn   guifg=#666666 guibg=#161616
hi DiffAdd      guibg=#1e1e1e gui=bold
hi DiffChange   guibg=#242424
hi DiffDelete   guifg=#8a8a8a guibg=#1e1e1e
hi DiffText     guibg=#333333 gui=bold
hi MatchParen   guifg=#ffffff guibg=#4a4a4a gui=bold
hi NormalFloat  guifg=#f0f0f0 guibg=#1e1e1e
hi FloatBorder  guifg=#333333 guibg=#161616
hi QuickFixLine guibg=#242424
