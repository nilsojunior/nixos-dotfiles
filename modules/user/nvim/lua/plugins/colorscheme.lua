return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				no_italic = true,
				float = {
					transparent = true,
				},
			})
			-- vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"wincent/base16-nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("gruvbox-dark-hard")
			for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
				local hl = vim.api.nvim_get_hl(0, { name = group })
				if hl.italic then
					hl.italic = false
					vim.api.nvim_set_hl(0, group, hl)
				end
			end
		end,
	},
}
