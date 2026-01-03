return {
	"chomosuke/typst-preview.nvim",
	lazy = false,
	version = "1.*",
	config = function()
		require("typst-preview").setup()
	end,
	vim.keymap.set("n", "<leader>pt", ":TypstPreview<CR>", { desc = "Typst preview" }),
}
