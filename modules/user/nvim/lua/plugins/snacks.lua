return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		picker = {
			prompt = " ",
			exclude = { "node_modules", "target" },
			sources = {
				files = { ignored = true, hidden = true },
				grep = {
					hidden = true,
				},
			},
		},
		image = {
			doc = {
				inline = false,
				float = true,
				max_height = 25,
			},
		},
		dashboard = {
			sections = {
				{ section = "header" },
				{
					secton = "keys",
					gap = 1,
					padding = 1,
					{ icon = " ", key = "f", desc = "Find Files", action = ":lua Snacks.dashboard.pick('smart')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Grep",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{
						icon = " ",
						key = "s",
						desc = "Fugitive",
						action = "<leader>gs",
					},
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				{ section = "startup" },
			},
		},
	},
	keys = {
		{
			"<leader>fs",
			function()
				require("snacks").picker.smart()
			end,
			desc = "Find files",
		},
		{
			"<leader>fw",
			function()
				require("snacks").picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>fc",
			function()
				require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find config files",
		},
		{
			"<leader>fr",
			function()
				require("snacks").picker.recent()
			end,
			desc = "Find recent files",
		},
		{
			"<leader>fi",
			function()
				require("snacks").picker.icons()
			end,
			desc = "Find icons",
		},
		{
			"<leader>fh",
			function()
				require("snacks").picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<C-p>",
			function()
				require("snacks").picker.git_files()
			end,
			desc = "Find Git files",
		},

		-- Lazygit
		{
			"<leader>lg",
			function()
				require("snacks").lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				require("snacks").lazygit.log()
			end,
			desc = "Lazygit logs",
		},
	},
}
