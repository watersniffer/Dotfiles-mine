" VS Code Dark Modern, as a Neovim colorscheme.
"
" VS Code ships this theme, but there is no matching nvim plugin that renders
" Dark Modern specifically -- akinsho/vscode.nvim is the older Dark+ -- so the
" token colours are reproduced here to match themes/vscode-dark-modern.
"
" The mapping is VS Code's own: comments green, strings salmon, keywords blue,
" types teal, functions yellow, variables light blue, errors red. The chrome
" around it is Dark Modern's: #181818 side/status/title against a #1F1F1F
" editor, and the #0078D4 focus blue.

highlight clear

" base
highlight Normal       guifg=#cccccc guibg=#1f1f1f
highlight NormalNC     guifg=#cccccc guibg=#1f1f1f
highlight NormalSB     guifg=#cccccc guibg=#181818
highlight EndOfBuffer  guifg=#cccccc guibg=#1f1f1f
highlight Cursor       guifg=#cccccc guibg=#1f1f1f
highlight CursorNC     guifg=#cccccc guibg=#1f1f1f
highlight CursorIM     guifg=#cccccc guibg=#569cd6
highlight CursorLine   guibg=#2a2d2e cterm=bold
highlight CursorColumn guibg=#2a2d2e
highlight LineNr       guifg=#6e7681
highlight CursorLineNr guifg=#cccccc
highlight SignColumn   guifg=#6e7681
highlight FoldColumn   guifg=#6e7681
highlight Folded       guifg=#6e7681 guibg=#2a2d2e
highlight NonText      guifg=#6e7681

" VS Code's token colours
highlight Comment      guifg=#6a9955 gui=italic
highlight Constant     guifg=#569cd6
highlight String       guifg=#ce9178
highlight Character    guifg=#ce9178
highlight Number       guifg=#b5cea8
highlight Float        guifg=#b5cea8
highlight Boolean      guifg=#569cd6
highlight Identifier   guifg=#9cdcfe
highlight Function     guifg=#dcdcaa
highlight Statement    guifg=#569cd6
highlight Conditional  guifg=#569cd6
highlight Repeat       guifg=#569cd6
highlight Label        guifg=#9cdcfe
highlight Operator     guifg=#cccccc
highlight Keyword      guifg=#569cd6
highlight Exception    guifg=#569cd6
highlight PreProc      guifg=#569cd6
highlight Include      guifg=#569cd6
highlight Define       guifg=#569cd6
highlight Macro        guifg=#569cd6
highlight PreCondit    guifg=#569cd6
highlight Type         guifg=#4ec9b0
highlight StorageClass guifg=#4ec9b0
highlight Structure    guifg=#4ec9b0
highlight Typedef      guifg=#4ec9b0
highlight Special      guifg=#dcdcaa

" status
highlight Error       guifg=#f44747
highlight ErrorMsg    guifg=#f44747
highlight WarningMsg  guifg=#dcdcaa
highlight MoreMsg     guifg=#cccccc
highlight Question    guifg=#cccccc
highlight Todo        guifg=#1f1f1f guibg=#dcdcaa
highlight ModeMsg     guifg=#569cd6 gui=bold
highlight Debug       guifg=#ce9178

" search and selection, using VS Code's own selection blue
highlight Search      guifg=#ffffff guibg=#264f78
highlight IncSearch   guifg=#ffffff guibg=#264f78
highlight CurSearch   guifg=#cccccc guibg=#04395e
highlight Substitute  guifg=#cccccc guibg=#b5cea8
highlight MatchParen  guifg=#dcdcaa gui=bold
highlight Visual      guifg=#cccccc guibg=#264f78

" diff, from VS Code's git decoration colours
highlight DiffAdd     guifg=#81b88b guibg=#1f1f1f
highlight DiffChange  guifg=#e2c08d guibg=#1f1f1f
highlight DiffDelete  guifg=#c74e39 guibg=#1f1f1f
highlight DiffText    guifg=#1f1f1f guibg=#264f78
highlight Added       guifg=#81b88b
highlight Changed     guifg=#e2c08d
highlight Removed     guifg=#c74e39

" chrome: the #181818 shell
highlight StatusLine     guifg=#cccccc guibg=#181818
highlight StatusLineNC   guifg=#6e7681 guibg=#181818
highlight VertSplit      guifg=#2b2b2b
highlight WinSeparator   guifg=#2b2b2b
highlight Winbar         guifg=#cccccc guibg=#181818
highlight WinbarNC       guifg=#6e7681 guibg=#181818
highlight Title          guifg=#cccccc guibg=#1f1f1f
highlight SpecialKey     guifg=#dcdcaa
highlight Conceal        guifg=#6e7681

" popups and widgets
highlight Pmenu        guifg=#cccccc guibg=#202020
highlight PmenuSel     guifg=#ffffff guibg=#04395e
highlight PmenuSbar    guibg=#202020
highlight PmenuThumb   guifg=#797979 guibg=#202020
highlight PmenuExtra   guifg=#6e7681 guibg=#202020
highlight PmenuKind    guifg=#569cd6 guibg=#202020
highlight PmenuMatch   guifg=#dcdcaa guibg=#202020 gui=bold
highlight WildMenu     guifg=#cccccc guibg=#202020
highlight MsgArea      guifg=#cccccc guibg=#202020
highlight MsgSeparator guifg=#2b2b2b

" diagnostics
highlight DiagnosticError           guifg=#f44747
highlight DiagnosticWarn            guifg=#dcdcaa
highlight DiagnosticInfo            guifg=#569cd6
highlight DiagnosticHint            guifg=#6e7681
highlight DiagnosticOk              guifg=#6e7681
highlight DiagnosticSignError       guifg=#f44747
highlight DiagnosticSignWarn        guifg=#dcdcaa
highlight DiagnosticSignInfo        guifg=#569cd6
highlight DiagnosticSignHint        guifg=#6e7681
highlight DiagnosticVirtualTextError guifg=#f44747
highlight DiagnosticVirtualTextWarn  guifg=#dcdcaa
highlight DiagnosticVirtualTextInfo  guifg=#569cd6
highlight DiagnosticUnderlineError  guisp=#f44747 gui=undercurl
highlight DiagnosticUnderlineWarn   guisp=#dcdcaa gui=undercurl
highlight DiagnosticUnderlineInfo   guisp=#569cd6 gui=undercurl
highlight DiagnosticFloatingError   guibg=#5a1d1d
highlight DiagnosticFloatingWarn    guibg=#5a5326
highlight DiagnosticFloatingInfo    guibg=#202020 guifg=#cccccc
highlight DiagnosticFloatingHint    guibg=#202020

" treesitter @-captures
highlight @comment            guifg=#6a9955 gui=italic
highlight @comment.documentation guifg=#6a9955 gui=italic
highlight @comment.error      guifg=#f44747
highlight @comment.warning    guifg=#dcdcaa
highlight @comment.todo       guifg=#1f1f1f guibg=#dcdcaa
highlight @constant           guifg=#569cd6
highlight @constant.builtin   guifg=#4fc1ff
highlight @constant.macro     guifg=#569cd6
highlight @function           guifg=#dcdcaa
highlight @function.builtin   guifg=#dcdcaa
highlight @function.macro     guifg=#dcdcaa
highlight @function.method    guifg=#dcdcaa
highlight @keyword            guifg=#569cd6
highlight @keyword.function   guifg=#569cd6
highlight @keyword.operator   guifg=#cccccc
highlight @keyword.return     guifg=#c586c0
highlight @keyword.modifier   guifg=#569cd6
highlight @module             guifg=#9cdcfe
highlight @string             guifg=#ce9178
highlight @string.documentation guifg=#6a9955 gui=italic
highlight @string.escape      guifg=#d7ba7d
highlight @string.regexp      guifg=#d16969
highlight @string.special     guifg=#d7ba7d
highlight @string.special.url guifg=#ce9178 gui=underline
highlight @tag                guifg=#569cd6
highlight @tag.builtin        guifg=#569cd6
highlight @tag.attribute      guifg=#9cdcfe
highlight @tag.delimiter      guifg=#cccccc
highlight @type               guifg=#4ec9b0
highlight @type.builtin       guifg=#4ec9b0
highlight @type.definition    guifg=#4ec9b0
highlight @type.qualifier     guifg=#dcdcaa
highlight @variable           guifg=#9cdcfe
highlight @variable.builtin   guifg=#4fc1ff
highlight @variable.parameter guifg=#9cdcfe
highlight @variable.member    guifg=#dcdcaa
highlight @field              guifg=#9cdcfe
highlight @constructor       guifg=#4ec9b0
highlight @label              guifg=#cccccc
highlight @markup.heading     guifg=#569cd6 gui=bold
highlight @markup.strong      gui=bold
highlight @markup.italic      gui=italic
highlight @markup.strikethrough gui=strikethrough
highlight @markup.link        guifg=#ce9178 gui=underline
highlight @markup.raw         guifg=#ce9178
highlight @markup.quote       guifg=#9cdcfe gui=italic
highlight @markup.list        guifg=#ce9178
highlight @diff.plus          guifg=#81b88b
highlight @diff.minus         guifg=#c74e39
highlight @diff.delta         guifg=#e2c08d
highlight @spell.error        guisp=#f44747 gui=undercurl
highlight @spell.warn         guisp=#dcdcaa gui=undercurl
highlight @spell.info         guisp=#569cd6 gui=undercurl
highlight @spell.hint         guisp=#6e7681 gui=undercurl

" treesitter, the modern capture names
highlight TSComment        guifg=#6a9955 gui=italic
highlight TSCommentTodo    guifg=#1f1f1f guibg=#dcdcaa
highlight TSConstant       guifg=#569cd6
highlight TSKeyword        guifg=#569cd6
highlight TSOperator       guifg=#cccccc
highlight TSFunction       guifg=#dcdcaa
highlight TSFunctionBuiltin guifg=#dcdcaa
highlight TSString         guifg=#ce9178
highlight TSStringEscape   guifg=#d7ba7d
highlight TSStringSpecial  guifg=#d7ba7d
highlight TSNumber         guifg=#b5cea8
highlight TSType           guifg=#4ec9b0
highlight TSVariable       guifg=#9cdcfe
highlight TSTag            guifg=#569cd6
highlight TSField          guifg=#9cdcfe

" lualine, so the statusline follows instead of overriding
highlight lualine_c_normal   guifg=#cccccc guibg=#181818
highlight lualine_c_inactive guifg=#6e7681 guibg=#181818
highlight lualine_c_visible  guifg=#cccccc guibg=#1f1f1f
highlight lualine_c_modified guifg=#1f1f1f guibg=#e2c08d
highlight lualine_c_insert   guifg=#1f1f1f guibg=#81b88b
highlight lualine_c_replace  guifg=#1f1f1f guibg=#f44747

set termguicolors
set background=dark

let g:terminal_color_0  = '#1f1f1f'
let g:terminal_color_1  = '#f44747'
let g:terminal_color_2  = '#6a9955'
let g:terminal_color_3  = '#dcdcaa'
let g:terminal_color_4  = '#569cd6'
let g:terminal_color_5  = '#c586c0'
let g:terminal_color_6  = '#4ec9b0'
let g:terminal_color_7  = '#cccccc'
let g:terminal_color_8  = '#6e7681'
let g:terminal_color_9  = '#f44747'
let g:terminal_color_10 = '#6a9955'
let g:terminal_color_11 = '#dcdcaa'
let g:terminal_color_12 = '#569cd6'
let g:terminal_color_13 = '#c586c0'
let g:terminal_color_14 = '#4ec9b0'
let g:terminal_color_15 = '#ffffff'
