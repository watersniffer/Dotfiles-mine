" E-ink: dark greyscale, for an e-ink panel or a glare-free desktop.
"
" Every colour here is a shade of grey, because an e-ink screen only renders
" luminance. The shades are stepped rather than flat so that syntax still reads:
" without that, a string and a comment would be indistinguishable.
"
" Matches themes/e-ink/palette.conf.

highlight clear

" base
highlight Normal      guifg=#f2f2f2 guibg=#0d0d0d
highlight NormalNC    guifg=#d0d0d0 guibg=#0d0d0d
highlight NormalSB    guifg=#d0d0d0 guibg=#0d0d0d
highlight EndOfBuffer guifg=#a0a0a0 guibg=#0d0d0d
highlight Cursor      guifg=#0d0d0d guibg=#f2f2f2
highlight CursorNC    guifg=#0d0d0d guibg=#d0d0d0
highlight CursorIM    guifg=#0d0d0d guibg=#e0e0e0
highlight CursorLine  guibg=#1a1a1a cterm=bold
highlight CursorColumn guibg=#1a1a1a
highlight LineNr      guifg=#767676
highlight CursorLineNr guifg=#a0a0a0
highlight SignColumn  guifg=#767676
highlight FoldColumn  guifg=#767676
highlight Folded      guifg=#a0a0a0 guibg=#1a1a1a
highlight NonText     guifg=#767676

" text roles
highlight Comment     guifg=#767676 gui=italic
highlight SpecialComment guifg=#8a8a8a
highlight Constant     guifg=#d0d0d0
highlight Identifier   guifg=#f2f2f2
highlight Function     guifg=#e0e0e0
highlight Statement    guifg=#f2f2f2 gui=bold
highlight Conditional  guifg=#f2f2f2
highlight Repeat       guifg=#f2f2f2
highlight Label        guifg=#f2f2f2
highlight Operator     guifg=#c8c8c8
highlight Keyword      guifg=#f2f2f2
highlight Exception    guifg=#f2f2f2
highlight PreProc      guifg=#dcdcdc
highlight Include      guifg=#dcdcdc
highlight Define       guifg=#dcdcdc
highlight Macro        guifg=#dcdcdc
highlight PreCondit    guifg=#dcdcdc

" literals, stepped lighter so string/number/char stay apart
highlight String      guifg=#d0d0d0
highlight Character   guifg=#dcdcdc
highlight Number      guifg=#e0e0e0
highlight Float       guifg=#e0e0e0
highlight Boolean     guifg=#e0e0e0

" types
highlight Type        guifg=#dcdcdc
highlight StorageClass guifg=#f2f2f2
highlight Structure   guifg=#f2f2f2
highlight Typedef     guifg=#dcdcdc
highlight Special     guifg=#e0e0e0

" status: no colour to carry meaning, so weight and caps do the work
highlight Error       guifg=#ffffff gui=bold
highlight ErrorMsg    guifg=#ffffff
highlight WarningMsg  guifg=#d0d0d0 gui=bold
highlight MoreMsg     guifg=#d0d0d0
highlight Question    guifg=#d0d0d0
highlight Todo        guifg=#ffffff gui=bold
highlight ModeMsg     guifg=#f2f2f2 gui=bold
highlight Search      guifg=#0d0d0d guibg=#d0d0d0
highlight IncSearch   guifg=#0d0d0d guibg=#d0d0d0
highlight CurSearch   guifg=#0d0d0d guibg=#dcdcdc
highlight Substitute  guifg=#0d0d0d guibg=#e0e0e0
highlight MatchParen  guifg=#f2f2f2 gui=bold
highlight DiffAdd     guifg=#f2f2f2 guibg=#262626
highlight DiffChange  guifg=#f2f2f2 guibg=#1a1a1a
highlight DiffDelete  guifg=#767676 guibg=#0d0d0d gui=strikethrough
highlight DiffText    guifg=#0d0d0d guibg=#d0d0d0

" popup menus and statusline
highlight Pmenu       guifg=#d0d0d0 guibg=#1a1a1a
highlight PmenuSel    guifg=#f2f2f2 guibg=#262626
highlight PmenuSbar   guibg=#1a1a1a
highlight PmenuThumb  guibg=#3d3d3d
highlight StatusLine   guifg=#d0d0d0 guibg=#000000
highlight StatusLineNC guifg=#a0a0a0 guibg=#000000
highlight VertSplit   guifg=#3d3d3d
highlight WinSeparator guifg=#3d3d3d
highlight WildMenu    guifg=#f2f2f2 guibg=#262626

" popups
highlight Visual      guibg=#262626
highlight SpellBad    guisp=#767676 gui=undercurl
highlight SpellCap    guisp=#a0a0a0 gui=undercurl
highlight SpellLocal  guisp=#8a8a8a gui=undercurl
highlight SpellRare   guisp=#767676 gui=undercurl

" LSP
highlight DiagnosticError   guifg=#ffffff gui=bold
highlight DiagnosticWarn    guifg=#d0d0d0 gui=bold
highlight DiagnosticInfo    guifg=#a0a0a0
highlight DiagnosticHint    guifg=#8a8a8a
highlight DiagnosticOk      guifg=#8a8a8a
highlight DiagnosticSignError guifg=#ffffff
highlight DiagnosticSignWarn  guifg=#d0d0d0
highlight DiagnosticSignInfo  guifg=#a0a0a0
highlight DiagnosticSignHint  guifg=#8a8a8a
highlight DiagnosticVirtualTextError guifg=#a0a0a0
highlight DiagnosticVirtualTextWarn  guifg=#8a8a8a
highlight DiagnosticUnderlineError guisp=#767676 gui=undercurl
highlight DiagnosticUnderlineWarn  guisp=#565656 gui=undercurl

" treesitter
highlight @comment           guifg=#767676 gui=italic
highlight @comment.documentation guifg=#8a8a8a gui=italic
highlight @constant          guifg=#d0d0d0
highlight @constant.builtin  guifg=#dcdcdc
highlight @constant.macro    guifg=#dcdcdc
highlight @function          guifg=#e0e0e0
highlight @function.builtin  guifg=#f2f2f2
highlight @function.macro    guifg=#e0e0e0
highlight @keyword           guifg=#f2f2f0
highlight @keyword.function  guifg=#f2f2f2
highlight @keyword.operator  guifg=#c8c8c8
highlight @keyword.return    guifg=#f2f2f2
highlight @module            guifg=#f2f2f2
highlight @string            guifg=#d0d0d0
highlight @string.documentation guifg=#a0a0a0
highlight @string.escape     guifg=#dcdcdc
highlight @string.regexp     guifg=#c8c8c8
highlight @string.special    guifg=#dcdcdc
highlight @tag               guifg=#f2f2f2
highlight @type              guifg=#dcdcdc
highlight @type.builtin      guifg=#f2f2f2
highlight @type.definition   guifg=#e0e0e0
highlight @variable          guifg=#f2f2f2
highlight @variable.builtin  guifg=#dcdcdc
highlight @variable.parameter guifg=#f2f2f2
highlight @variable.member   guifg=#e0e0e0
highlight @markup.heading    guifg=#f2f2f2 gui=bold
highlight @markup.strong     gui=bold
highlight @markup.italic     gui=italic
highlight @markup.strikethrough gui=strikethrough
highlight @markup.link       guifg=#d0d0d0 gui=underline
highlight @markup.raw        guifg=#a0a0a0
highlight @markup.list       guifg=#d0d0d0
highlight @markup.quote      guifg=#a0a0a0 gui=italic
highlight @diff.plus         guifg=#f2f2f2
highlight @diff.minus        guifg=#767676
highlight @diff.delta        guifg=#a0a0a0

" treesitter, the modern capture names, same greys
highlight TSComment         guifg=#767676 gui=italic
highlight TSCommentTodo     guifg=#ffffff gui=bold
highlight TSConstant        guifg=#d0d0d0
highlight TSKeyword         guifg=#f2f2f0
highlight TSFunction         guifg=#e0e0e0
highlight TSFunctionBuiltin  guifg=#f2f2f2
highlight TSOperator         guifg=#c8c8c8
highlight TSString          guifg=#d0d0d0
highlight TSStringEscape    guifg=#dcdcdc
highlight TSStringSpecial   guifg=#dcdcdc
highlight TSNumber          guifg=#e0e0e0
highlight TSType            guifg=#dcdcdc
highlight TSVariable        guifg=#f2f2f2
highlight TSTag             guifg=#f2f2f2

" windows
highlight Winbar          guifg=#a0a0a0 guibg=#000000
highlight WinbarNC        guifg=#767676 guibg=#000000
highlight Title           guifg=#f2f2f2 guibg=#1a1a1a gui=bold
highlight SpecialKey      guifg=#f2f2f2
highlight Conceal        guifg=#a0a0a0

" lualine, so the statusline follows the theme rather than overriding it
highlight NormalSB   guifg=#d0d0d0 guibg=#000000
highlight lualine_c_normal   guifg=#d0d0d0 guibg=#000000
highlight lualine_c_inactive guifg=#767676 guibg=#000000
highlight lualine_c_visible  guifg=#a0a0a0 guibg=#000000
highlight lualine_c_modified guifg=#f2f2f2 guibg=#000000 gui=bold
highlight lualine_c_insert   guifg=#0d0d0d guibg=#d0d0d0

" gui options. Normal is left as the explicit dark set at the top rather than
" NONE: an e-ink theme is opaque on purpose, and guibg=NONE would hand the
" background to whatever terminal is hosting nvim.
set termguicolors
set background=dark

let g:terminal_color_0 = '#0d0d0d'
let g:terminal_color_1 = '#dcdcdc'
let g:terminal_color_2 = '#d0d0d0'
let g:terminal_color_3 = '#a0a0a0'
let g:terminal_color_4 = '#e0e0e0'
let g:terminal_color_5 = '#c8c8c8'
let g:terminal_color_6 = '#f2f2f2'
let g:terminal_color_7 = '#d0d0d0'
let g:terminal_color_8 = '#767676'
let g:terminal_color_9 = '#dcdcdc'
let g:terminal_color_10 = '#d0d0d0'
let g:terminal_color_11 = '#a0a0a0'
let g:terminal_color_12 = '#e0e0e0'
let g:terminal_color_13 = '#c8c8c8'
let g:terminal_color_14 = '#f2f2f2'
let g:terminal_color_15 = '#f2f2f2'
