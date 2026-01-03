return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			---@diagnostic disable-next-line: missing-fields
			config.setup({
				auto_install = true,
				ensure_installed = {
					"lua",
					"python",
					"c",
					"cpp",
					"markdown",
					"json",
					"yaml",
					"toml",
					"rust",
					"bash",
					"css",
					"java",
					"go",
					"typst",
				},
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							vim.notify("Treesitter: file too big")
							return true
						end
					end,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		layz = true,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",
							["al"] = "@loop.inner",
							["il"] = "@loop.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]i"] = "@conditional.outer",
							["]l"] = "@loop.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
							["]I"] = "@conditional.outer",
							["]L"] = "@loop.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[i"] = "@conditional.outer",
							["[l"] = "@loop.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
							["[I"] = "@conditional.outer",
							["[L"] = "@loop.outer",
						},
					},
				},
			})

			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = false,
			})

			-- Setup colors based on theme
			local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
			vim.api.nvim_set_hl(0, "TreesitterContext", { bg = normal.bg })
			local linenr = vim.api.nvim_get_hl(0, { name = "LineNr" })
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = linenr.fg, bg = linenr.bg })
		end,
	},
}
