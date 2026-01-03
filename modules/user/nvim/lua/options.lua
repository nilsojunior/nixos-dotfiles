local opt = vim.opt

local wo = vim.wo

local autocmd = vim.api.nvim_create_autocmd

local usercmd = vim.api.nvim_create_user_command

local cmd = vim.cmd

-- Relative lines
opt.relativenumber = true
opt.nu = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Colors
opt.termguicolors = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 50

-- Incremental search
opt.incsearch = true

-- Disable search highlight
opt.hlsearch = false

-- Remove case-sensitive search
opt.ignorecase = true

-- Enable case-sensitive search when using uppercase letters
opt.smartcase = true

-- Statusline relative path
opt.statusline = "%!expand('%:~:.')"

-- Disable bottom right stuff
opt.ruler = false

-- Disable keys showing on bottom right
opt.showcmd = false

-- Global statusline (1 statusline for all windows)
opt.laststatus = 3

-- Make the statusline and cli overlap
opt.cmdheight = 0

-- Highlight current line number
opt.cursorline = true
opt.cursorlineopt = "number"

-- Disable line wrapping
wo.wrap = false

-- Hide mode display on bottom left
opt.showmode = false

-- Enable mouse for all modules
opt.mouse = "a"

-- Always open split on the right
opt.splitright = true

-- Always open split below
opt.splitbelow = true

opt.guicursor = ""

-- Hover border
opt.winborder = "rounded"

-- Remove the ~ at the end of buffers
opt.fillchars = { eob = " " }

opt.swapfile = false
opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Obsidian stuff
opt.conceallevel = 2

-- Terminal Settings
autocmd("TermOpen", {
	callback = function()
		wo.number = false
		wo.relativenumber = false
		wo.scrolloff = 0
	end,
})

-- Disable statusline for toggleterm
cmd([[
    augroup ToggleTermStatusline
        autocmd!
        autocmd TermOpen * setlocal statusline=Terminal
    augroup END
]])

local function open_path(path)
	local uv = vim.loop

	local stat = uv.fs_stat(path)

	if stat.type == "directory" then
		cmd("cd " .. vim.fn.fnameescape(path))
		require("snacks").picker.files()
	elseif stat.type == "file" then
		local dir = vim.fn.fnamemodify(path, ":h")
		cmd("cd " .. vim.fn.fnameescape(dir))
		cmd("edit " .. vim.fn.fnameescape(path))
	end
end

usercmd("OpenWorkspace", function(opts)
	open_path(opts.args)
end, { nargs = 1, complete = "file" })

-- Highlight on yank
autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Remove whitespaces on save
autocmd({ "BufWritePre" }, {
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Syntax highlight for jflex
autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.flex", "*.jflex" },
	callback = function()
		vim.bo.filetype = "jflex"
	end,
})

-- Syntax highlight for jcup
autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.cup" },
	callback = function()
		vim.bo.filetype = "cup"
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.apol" },
	callback = function()
		vim.bo.filetype = "apol"
	end,
})

-- Compile dictionaries
usercmd("Compiledicts", function()
	cmd("silent mkspell! ~/.config/nvim/spell/en.utf-8.add")
	cmd("silent mkspell! ~/.config/nvim/spell/pt.utf-8.add")
end, {})

autocmd("Filetype", {
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us,pt"
	end,
})

usercmd("Compiletypst", function()
	local file_path = vim.fn.expand("%")
	local file_name = vim.fn.expand("%:t:r")
	local pdf_path = os.getenv("HOME") .. "/Documents/PDFs/" .. file_name .. ".pdf"
	vim.fn.system("typst compile " .. file_path .. " " .. pdf_path)
end, {})
