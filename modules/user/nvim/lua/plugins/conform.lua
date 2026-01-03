return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black", "isort" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				markdown = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				go = { "gofumpt", "golines", "goimports-reviser" },
				typst = { "typstyle" },
				java = { "clang-format" },
				bash = { "shfmt" },
				xml = { "xmllint" },
				nix = { "nixfmt" },
			},
			formatters = {
				prettier = {
					append_args = { "--tab-width", "4" },
				},
				["clang-format"] = {
					prepend_args = { "--style={IndentWidth: 4}" },
				},
				nixfmt = {
					append_args = { "--indent=4" },
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
