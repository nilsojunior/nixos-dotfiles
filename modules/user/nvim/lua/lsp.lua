vim.lsp.enable({
	"lua_ls",
	"pyright",
	"clangd",
	"stylelint_lsp",
	"rust_analyzer",
	"bashls",
	"jsonls",
	"html",
	"tailwindcss",
	"ts_ls",
	"jdtls",
	"gopls",
	"tinymist",
	"cssls",
	"nil",
	"nixd",
})

vim.lsp.config("nil", {
	cmd = { "nil" },
	filetypes = { "nix" },
})

vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
		},
		-- options = {
		-- 	nixos = {
		-- 		expr = '(builtins.getFlake (builtins.toString "/home/nilso/dotfiles-nixos")).nixosConfigurations.nixing.options',
		-- 	},
		-- 	home_manager = {
		-- 		expr = '(builtins.getFlake (builtins.toString "/home/nilso/dotfiles-nixos")).nixosConfigurations.nixing.options.home-manager.users.type.getSubOptions []',
		-- 	},
		-- },
	},
})

vim.lsp.config("html", {
	filetypes = {
		"html",
		"css",
		"javascript",
		"javascriptreact",
		"jsx",
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local function keymap(mode, map, func, desc, nowait)
			vim.keymap.set(mode, map, func, {
				buffer = ev.buf,
				silent = true,
				desc = "LSP: " .. desc,
				nowait = nowait,
			})
		end

		keymap("n", "K", vim.lsp.buf.hover, "Docs")

		keymap("n", "<leader>vd", vim.diagnostic.open_float, "Diagnostic")

		keymap("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Prev diagnostic")

		keymap("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")

		keymap("n", "<leader>rm", vim.lsp.buf.rename, "Rename")

		keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")

		keymap({ "i", "n" }, "<C-s>", function()
			vim.lsp.buf.signature_help()
		end, "Signature docs")

		-- Snacks
		local snacks = require("snacks")

		keymap("n", "gd", snacks.picker.lsp_definitions, "Goto Definition")

		keymap("n", "gD", snacks.picker.lsp_declarations, "Goto Declaration")

		keymap("n", "gr", snacks.picker.lsp_references, "References", true)

		keymap("n", "<leader>ds", snacks.picker.diagnostics, "Diagnostics")

		keymap("n", "<leader>db", snacks.picker.diagnostics_buffer, "Buffer diagnostics")
	end,
})

vim.diagnostic.config({
	signs = {
		-- Remove default letters for diagnostics (W, E)
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.INFO] = "",
		},

		-- Highlight line numbers where diagnostics exists
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		},
	},
	virtual_text = true,
	-- virtual_lines = true,
	underline = true, -- Specify Underline diagnostics
	update_in_insert = false, -- Keep diagnostics active in insert mode
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		header = "",
		prefix = "",
		source = true,
	},
})
