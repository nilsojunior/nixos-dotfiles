local opts = { noremap = true, silent = true }

local keymap = vim.keymap.set

local cmd = vim.cmd

-- Set leader key to Space
vim.g.mapleader = " "

-- Make CTRL+C behave like ESC, useful in vertical editing
keymap("i", "<C-c>", "<ESC>")

-- Disable Space in normal and visual mode
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Quit and save keymaps
keymap("n", "<leader>q", ":quitall<CR>", opts)
keymap("n", "<leader>w", ":write<CR>", opts)
keymap("n", "<leader>W", ":wall<CR>", opts)

-- Control S to save
keymap({ "n", "i" }, "<C-s>", "<CMD>w<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down with auto indentation
keymap("v", "<S-J>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<S-K>", ":m '<-2<CR>gv=gv", opts)

-- Yank to clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap({ "n", "v" }, "<leader>Y", [["+Y]], { desc = "Yank to system clipboard" })

-- Pasting will not yank
keymap("v", "p", '"_dp', opts)

-- X will not yank
keymap("n", "x", '"_x', opts)

-- Delete without yank
keymap("v", "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Replace the word where cursor is
keymap("n", "<leader>rn", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename word under cursor" })

-- Keep cursor on center (from Prime)
keymap("n", "J", "mzJ`z", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

local function add_to_portuguese_dict()
	cmd("set spelllang=pt")
	cmd("normal zg")
	cmd("silent mkspell! ~/.config/nvim/spell/pt.utf-8.add")
	cmd("set spelllang=en_us,pt")
end

local function remove_from_portuguese_dict()
	cmd("set spelllang=pt")
	cmd("normal zw")
	cmd("silent mkspell! ~/.config/nvim/spell/pt.utf-8.add")
	cmd("set spelllang=en_us,pt")
end

keymap("n", "<leader>zg", add_to_portuguese_dict, { desc = "Add word to Portuguese dictionary" })
keymap("n", "<leader>zw", remove_from_portuguese_dict, { desc = "Remove word from Portuguese dictionary" })

keymap("n", "<leader>pd", function()
	vim.fn.jobstart({ "previewpdf", vim.fn.expand("%") })
end, { desc = "Preview PDF" })

-- Goto previous buffer
keymap("n", "gp", "<c-^>", { desc = "Alternate file" })

-- Open a new tmux window in the current buffer directory
local function tmux_neww()
	local current_buf = vim.fn.expand("%:p:h")
	vim.fn.system({ "tmux", "neww", "-c", current_buf })
end
keymap("n", "<leader>tn", tmux_neww, { desc = "Tmux new window in current buffer" })

keymap("n", "<leader>xe", function()
	cmd("write")
	cmd("silent !chmod +x %")
end, { desc = "Set executable" })

keymap("n", "<leader>xs", function()
	cmd("setfiletype sh")
	cmd("write")
	cmd("silent !chmod +x %")
end, { desc = "Set shell script" })

keymap("n", "<leader>cp", function()
	vim.notify("Compiling on save", "info")

	local source = vim.fn.expand("%")
	local file_name = vim.fn.expand("%:t:r")
	local output = os.getenv("HOME") .. "/Documents/PDFs/" .. file_name .. ".pdf"
	local command =
		string.format("pandoc --pdf-engine=weasyprint --standalone --embed-resources %s -o %s", source, output)

	vim.api.nvim_create_autocmd("BufWrite", {
		callback = function()
			vim.fn.jobstart(command)
		end,
	})
	cmd("silent write")
	vim.fn.jobstart("zathura " .. output)
end, { desc = "Compile PDF on save" })
