-- return {
-- 	{
-- 		'neovim/nvim-lspconfig',
-- 		config = function()
-- 			local lspconfig = require('lspconfig')
-- 		end,
-- 	},
-- 	{
-- 		'williamboman/mason.nvim',
-- 			opts = {
-- 				ensure_installed = {},
-- 				automatic_installation = true,
-- 				ui = {
-- 					border = "M",
-- 					icons = {
-- 						package_installed = "✓",
-- 						package_pending = "➜",
-- 						package_uninstalled = "✗"
-- 					},
-- 				},
-- 			},
-- 	{
-- 		'williamboman/mason-lspconfig.nvim',
-- 	},
-- 		require'lspconfig'.ast_grep.setup {},
-- 			require'lspconfig'.vimls.setup {},
-- 			require'lspconfig'.lua_ls.setup {
-- 				settings = {
-- 					diagnostics = {
-- 						globals = {'vim'},
-- 					},
-- 				},
-- 			},
-- 			require'lspconfig'.basedpyright.setup{},
-- 			require'lspconfig'.jedi_language_server.setup{},
-- 			require'lspconfig'.jsonls.setup{},
-- 			require'lspconfig'.spectral.setup{},
-- 			require'lspconfig'.yamlls.setup {},
-- 			require'lspconfig'.clangd.setup {},
-- 			require'lspconfig'.diagnosticls.setup {},
-- 			require'lspconfig'.vale_ls.setup {},
-- 			require'lspconfig'.bashls.setup {},
-- 			require'lspconfig'.powershell_es.setup {
-- 				bundle_path = 'C:/Users/brobe/AppData/Local/nvim-data/mason/packages/powershell-editor-services',
-- 				filetypes = {
-- 					"ps1",
-- 				},
-- 				shell = "pwsh",
-- 				single_file_support = true,
-- 			},
-- 			-- require'lspconfig'.grammarly.setup {},
-- 			-- require'lspconfig'.harper_ls.setup {},
-- 		},
-- 		{ 'jay-babu/mason-null-ls.nvim' },
-- 		{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },
-- 	}

return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{
				"hrsh7th/cmp-nvim-lsp",
			},
		},
		---@class PluginLspOpts
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					-- prefix = "●",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					prefix = "icons",
				},
				severity_sort = true,
			},
			-- add any global capabilities here
			capabilities = {},
			-- Automatically format on save
			autoformat = true,
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				jsonls = {
					settings = {
						json = {},
					},
				},
				lua_ls = {
					-- mason = false, -- set to false if you don't want this server to be installed with mason
					settings = {
						Lua = {
							format = {
								enable = true,
							},
							hint = {
								enable = true,
								setType = true,
								paramName = "All",
								paramType = true,
								arrayIndex = "Enable",
							},
							hover = {
								enable = true,
							},
							semantic = {
								enable = true,
								variable = true,
							},
							codeLens = {
								enable = true,
							},
							diagnostics = {
								globals = { "vim" },
								enable = true,
								severity = Information,
								groupSeverity = Information,
							},
							workspace = {
								checkThirdParty = true,
							},
							completion = {
								enable = true,
								showWord = "Enable",
								showParams = true,
								displayContext = 2,
								keywordSnippet = "Both",
								callSnippet = "Replace",
							},
						},
					},
				},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
		---@param opts PluginLspOpts
		config = function(_, opts)
			local Util = require("util")
			-- setup autoformat
			require("plugins.lsp.format").autoformat = opts.autoformat
			-- setup formatting and keymaps
			Util.on_attach(function(client, buffer)
				require("plugins.lsp.format").on_attach(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			-- diagnostics
			for name, icon in pairs(require("config").icons.diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
					or function(diagnostic)
						local icons = require("config").icons.diagnostics
						for d, icon in pairs(icons) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities(),
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available thourgh mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({ ensure_installed = ensure_installed })
				mlsp.setup_handlers({ setup })
			end

			if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
				local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
				Util.lsp_disable("tsserver", is_deno)
				Util.lsp_disable("denols", function(root_dir)
					return not is_deno(root_dir)
				end)
			end
		end,
	},

	-- formatters
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					nls.builtins.formatting.fish_indent,
					nls.builtins.diagnostics.fish,
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.shfmt,
					-- nls.builtins.diagnostics.flake8,
				},
			}
		end,
	},

	-- cmdline tools and lsp servers
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				-- "flake8",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}
