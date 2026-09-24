return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- 1. Monochrome palette (desktop accent: white #ffffff)
		local colors = {
			base = "#161616",
			mantle = "#101010",
			crust = "#101010",
			surface0 = "#1e1e1e",
			overlay0 = "#606060",
			text = "#f0f0f0",
			subtext0 = "#a0a0a0",
			accent = "#ffffff",
			green = "#a9a9a9",
			orange = "#787878",
			yellow = "#e0e0e0",
			red = "#d0d0d0",
			blue = "#999999",
		}

		-- 2. Map Monochrome colours to the 'p' variable
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
