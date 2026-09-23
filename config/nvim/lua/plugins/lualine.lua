return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- 1. Gruvbox Dark palette (desktop accent: orange #fe8019)
		local colors = {
			base = "#282828",
			mantle = "#1d2021",
			crust = "#1d2021",
			surface0 = "#32302f",
			overlay0 = "#665c54",
			text = "#ebdbb2",
			subtext0 = "#a89984",
			accent = "#fe8019",
			green = "#b8bb26",
			orange = "#d65d0e",
			yellow = "#fabd2f",
			red = "#fb4934",
			blue = "#83a598",
		}

		-- 2. Map Gruvbox colours to the 'p' variable
		local p = {
			bg = colors.base,
			bg_dark = colors.mantle,
			bg_float = colors.surface0, -- Lighter background
			fg = colors.text,
			fg_dim = colors.overlay0, -- Dimmed text (grey)
			func = colors.accent, -- orange: primary/normal-mode accent
			string = colors.green,
			class = colors.orange,
			error = colors.red,
			number = colors.yellow,
			diag_err = colors.red,
			diag_warn = colors.yellow,
			diag_info = colors.blue,
		}

		-- 3. Define your Custom Theme using the mapped colors
		local custom_theme = {
			normal = {
				a = { bg = p.func, fg = p.bg, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			insert = {
				a = { bg = p.string, fg = p.bg_dark, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			visual = {
				a = { bg = p.class, fg = p.bg_dark, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			replace = {
				a = { bg = p.error, fg = p.bg, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			command = {
				a = { bg = p.number, fg = p.bg, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			inactive = {
				a = { bg = p.bg_dark, fg = p.fg_dim, gui = "bold" },
				b = { bg = p.bg_dark, fg = p.fg_dim },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
		}

		-- 4. Setup Lualine
		require("lualine").setup({
			options = {
				theme = custom_theme, -- Using your custom theme
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
			},
			sections = {
				lualine_a = {
					{ "mode", separator = { left = "" }, right_padding = 2 },
				},
				lualine_b = {
					"branch",
					{ "diff", colored = true },
				},
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " " },
						diagnostics_color = {
							error = { fg = p.diag_err },
							warn = { fg = p.diag_warn },
							info = { fg = p.diag_info },
						},
					},
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
		})
	end,
}
