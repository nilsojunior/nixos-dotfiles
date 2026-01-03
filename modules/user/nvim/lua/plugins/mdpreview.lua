return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_browser = "zen-browser"
	end,
	ft = { "markdown" },
	config = function()
		vim.cmd([[do FileType]])
		vim.cmd([[
         function OpenMarkdownPreview (url)
            let cmd = "zen-browser --new-window " . shellescape(a:url) . " &"
            silent call system(cmd)
         endfunction
      ]])
		vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
		vim.keymap.set("n", "<leader>pm", ":MarkdownPreview<CR>", { desc = "Markdown preview" })
	end,
}
