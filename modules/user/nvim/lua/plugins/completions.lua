return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local ls = require("luasnip")

			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node

			-- Code blocks snippets by Linkarzu
			local function create_code_block_snippet(lang)
				return s({
					trig = lang,
					name = "Codeblock",
					desc = lang .. " codeblock",
				}, {
					t({ "```" .. lang, "" }),
					i(1),
					t({ "", "```" }),
				})
			end

			local languages = {
				"txt",
				"lua",
				"sql",
				"go",
				"regex",
				"bash",
				"markdown",
				"markdown_inline",
				"yaml",
				"json",
				"jsonc",
				"cpp",
				"csv",
				"java",
				"javascript",
				"python",
				"dockerfile",
				"html",
				"css",
				"templ",
				"php",
				"console",
				"rust",
			}

			local snippets = {}

			for _, lang in ipairs(languages) do
				table.insert(snippets, create_code_block_snippet(lang))
			end

			ls.add_snippets("markdown", snippets)

			ls.add_snippets("all", {
				s("{", {
					t("{"),
					t({ "", "\t" }),
					i(1),
					t({ "", "}" }),
				}),
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				-- Do not select any items
				preselect = cmp.PreselectMode.None,
				formatting = {
					fields = { "abbr", "kind" },
					format = lspkind.cmp_format({
						mode = "text",
						maxwidth = {
							menu = 50,
							abbr = 50,
						},
						ellipsis_char = "...",
						show_labelDetails = true,

						symbol_map = {
							Array = "",
							Boolean = "",
							Class = "",
							Color = "",
							Constant = "",
							Constructor = "",
							Enum = "",
							EnumMember = "",
							Event = "",
							Field = "",
							File = "",
							-- Folder = "",
							Function = "",
							Interface = "",
							Key = "",
							Keyword = "",
							Method = "",
							Module = "",
							Namespace = "",
							-- Null = "ﳠ",
							Number = "",
							Object = "",
							Operator = "",
							Package = "",
							Property = "",
							Reference = "",
							-- Snippet = "",
							String = "",
							Struct = "",
							Text = "",
							TypeParameter = "",
							Unit = "",
							Value = "",
							Variable = "",
						},

						before = function(entry, vim_item)
							return vim_item
						end,
					}),
				},

				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered({
						scrollbar = false,
					}),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-v>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
