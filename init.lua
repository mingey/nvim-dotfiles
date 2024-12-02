local vim = vim
vim.opt.compatible = false


vim.fn.setenv('TMPDIR', './tmp')
vim.opt.syntax = 'off'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('mapping')

-- OPTIONS
-- file navigation & handling
vim.opt.autochdir = true

-- gui
vim.opt.number = true
vim.opt.signcolumn = 'auto:2-9'
vim.opt.cursorbind = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.laststatus = 2
vim.opt.cmdheight = 4
vim.opt.guicursor = { 'n-v-c:block', 'i-ci-ve:ver25', 'r-cr:hor20', 'o:hor50', 'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor', 'sm:block-blinkwait175-blinkoff150-blinkon175' }

-- wrapping and indentation
vim.cmd [[filetype plugin indent on]]
vim.opt.textwidth = 90
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { 'min:20', 'shift:5' }
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false

-- folding
vim.opt.foldcolumn = 'auto:9'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 1

-- movement
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.mouse = 'a'
vim.opt.mousehide = true
vim.opt.cursorbind = false

-- layout: buffers, windows, and tabs
vim.opt.hidden = true					-- required for LSP
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- editing
vim.opt.formatoptions = 'tcqwnjc'
vim.opt.paste = false

-- search & substitute
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- completion
vim.opt.wildmenu = true
vim.opt.wildmode = 'full:lastused'
vim.opt.wildoptions = { 'fuzzy', 'pum', 'tagfile' }
vim.opt.spell = false
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- save and undo
vim.opt.history = 1000
vim.opt.undolevels = 2000
vim.opt.undofile = true

-- input
vim.opt.timeoutlen = 900
vim.opt.ttimeoutlen = 50

-- PLUGINS
vim.opt.rtp.append = '~/scoop/apps/fzf/current'

-- languages
vim.g.perl_host_prog='C:\\Users\\brobe\\scoop\\apps\\perl\\current\\perl\\bin\\perl.exe'
vim.g.node_host_prog='C:\\Users\\brobe\\node_modules\\neovim\\bin\\cli.exe'
vim.g.python3_host_prog='C:\\Users\\brobe\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'

-- require("luasnip.loaders.from_vscode").lazy_load()
-- require("luasnip.loaders.from_snipmate").lazy_load()

-- User command to print 'more' output from command line to a buffer
-- https://www.reddit.com/r/neovim/comments/zhweuc/whats_a_fast_way_to_load_the_output_of_a_command/
vim.api.nvim_create_user_command('Redir', function(ctx)
  local lines = vim.split(vim.api.nvim_exec(ctx.args, true), '\n', { plain = true })
  vim.cmd('new')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })
-- and then use a command like :Redir lua=vim.tbl_keys(package.loaded)

-- Setup lazy.nvim
require("lazy").setup('plugins')
	opts = {
	root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
	defaults = {
		-- Set this to `true` to have all your plugins lazy-loaded by default.
		-- Only do this if you know what you are doing, as it can lead to unexpected behavior.
		lazy = true, -- should plugins be lazy-loaded?
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = nil, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
		-- default `cond` you can use to globally disable a lot of plugins
		-- when running inside vscode for example
		cond = nil, ---@type boolean|fun(self:LazyPlugin):boolean|nil
	},
	spec = nil,
	local_spec = true, -- load project specific .lazy.lua spec files. They will be added at the end of the spec.
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
	---@type number? limit the maximum amount of concurrent tasks
	concurrency = jit.os:find("Windows") and (vim.uv.available_parallelism() * 2) or nil,
	git = {
		-- defaults for the `Lazy log` command
		-- log = { "--since=3 days ago" }, -- show commits from the last 3 days
		log = { "-8" }, -- show the last 8 commits
		timeout = 120, -- kill processes that take more than 2 minutes
		url_format = "https://github.com/%s.git",
		-- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
		-- then set the below to false. This should work, but is NOT supported and will
		-- increase downloads a lot.
		filter = true,
	},
	pkg = {
		enabled = true,
		cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
		versions = true, -- Honor versions in pkg sources
		-- the first package source that is found for a plugin will be used.
		sources = {
			"lazy",
			"rockspec",
			"packspec",
		},
	},
	rocks = {
		root = vim.fn.stdpath("data") .. "/lazy-rocks",
		server = "https://nvim-neorocks.github.io/rocks-binaries/",
	},
	dev = {
		---@type string | fun(plugin: LazyPlugin): string directory where you store your local plugin projects
		path = "~/projects",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = {}, -- For example {"folke"}
		fallback = false, -- Fallback to git when local plugin doesn't exist
	},
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "oxocarbon" },
	},
	ui = {
		-- a number <1 is a percentage., >1 is a fixed size
		size = { width = 0.8, height = 0.8 },
		wrap = true, -- wrap the lines in the ui
		-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		border = "none",
		-- The backdrop opacity. 0 is fully opaque, 100 is fully transparent.
		backdrop = 60,
		title = nil, ---@type string only works when border is not "none"
		title_pos = "center", ---@type "center" | "left" | "right"
		-- Show pills on top of the Lazy window
		pills = true, ---@type boolean
		icons = {
			cmd = " ",
			config = "",
			event = " ",
			favorite = " ",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "󰒲 ",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			require = "󰢱 ",
			source = " ",
			start = " ",
			task = "✔ ",
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},
		-- leave nil, to automatically select a browser depending on your OS.
		-- If you want to use a specific browser, you can define it here
		browser = nil, ---@type string?
		throttle = 20, -- how frequently should the ui process render events
		custom_keys = {
			-- You can define custom key maps here. If present, the description will
			-- be shown in the help menu.
			-- To disable one of the defaults, set it to false.

			["<localleader>l"] = {
				function(plugin)
					require("lazy.util").float_term({ "lazygit", "log" }, {
						cwd = plugin.dir,
					})
				end,
				desc = "Open lazygit log",
			},

			["<localleader>t"] = {
				function(plugin)
					require("lazy.util").float_term(nil, {
						cwd = plugin.dir,
					})
				end,
				desc = "Open terminal in plugin dir",
			},
		},
	},
	diff = {
		-- diff command <d> can be one of:
		-- * browser: opens the github compare view. Note that this is always mapped to <K> as well,
		--   so you can have a different command for diff <d>
		-- * git: will run git diff and open a buffer with filetype git
		-- * terminal_git: will open a pseudo terminal with git diff
		-- * diffview.nvim: will open Diffview to show the diff
		cmd = "git",
	},
	checker = {
		-- automatically check for plugin updates
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true, -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
		check_pinned = false, -- check for pinned packages that can't be updated
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = true, -- get a notification when changes are found
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
			---@type string[]
			paths = {}, -- add any custom paths here that you want to includes in the rtp
			---@type string[] list any plugins you want to disable here
			disabled_plugins = {
				-- "gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				-- "tarPlugin",
				-- "tohtml",
				-- "tutor",
				-- "zipPlugin",
			},
		},
	},
	-- lazy can generate helptags from the headings in markdown readme files,
	-- so :help works even for plugins that don't have vim docs.
	-- when the readme opens with :help it will be correctly displayed as markdown
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		-- only generate markdown helptags for plugins that dont have docs
		skip_if_doc_exists = false,
	},
	-- state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
	-- Enable profiling of lazy.nvim. This will add some overhead,
	-- so only enable this when you are debugging lazy.nvim
	profiling = {
		-- Enables extra stats on the debug tab related to the loader cache.
		-- Additionally gathers stats about all package.loaders
		loader = false,
		-- Track each new require in the Lazy profiling tab
		require = false,
	},
}

-- set colorscheme
vim.opt.termguicolors = true
vim.opt.background = 'dark'
-- commands for specific colorschemes
-- ONEDARK
-- vim.g.onedark_terminal_italics = 1
-- AYU
-- vim.g.ayucolor = 'mirage'
-- vim.g.ayucolor = 'dark'
-- vim.g.ayu_italic_comment = 1
-- vim.g.ayu_sign_contrast = 1
-- vim.g.ayu_extended_palette = 1
-- SONOKAI
-- vim.g.sonokai_style = 'andromeda'
-- vim.g.sonokai_enable_italic = '1'
-- vim.g.sonokai_dim_inactive_windows = '1'
-- vim.g.sonokai_show_eob = '0'
-- CATPPUCCIN
-- require('catppuccin').setup({
--     flavour = 'mocha',      -- latte, frappe, macciato, mocha
--     background = {
--       light = 'latte',
--       dark = 'mocha',
--     },
--     dim_inactive = {
--       enabled = true,
--       shade = 'dark',
--       percentage = 0.15,
--     },
--     default_integrations = true,
--     integrations = {
--       cmp = true,
--       gitsigns = true,
--       nvimtree = false,
--       neotree = true,
--       treesitter = true,
--       notify = false,
--       mini = {
--         enabled = true,
--         indentscope_color = '',
--       },
--       native_lsp = {
--         enabled = true,
--         virtual_text = {
--           errors = { 'italic' },
--           hints = { 'italic' },
--           warnings = { 'italic' },
--           information = { 'italic' },
--           ok = { 'italic' },
--         },
--         underlines = {
--           errors = { 'underline' },
--           hints = { 'underline' },
--           warnings = { 'underline' },
--           information = { 'underline' },
--           ok = { 'underline' },
--         },
--         inlay_hints = {
--           background = true,
--         },
--       },
--       lsp_trouble = false,
--       gitgutter = false,
--       vimwiki = false,
--       which_key = false,
--     },
-- })
--
-- vim.cmd [[colorscheme catppuccin]]

-- CMP
local cmp = require'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = 'luasnip' }, -- For luasnip users.
		{ name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
		{ name = 'nvim-lsp' },
		{ name = 'path' },
		{ name = 'cmdline' },
		{ name = 'help-tags' },
		{ name = 'luasnip' },
		{ name = 'plugins' },
	})
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' },
	}, {
		{ name = 'buffer' },
	})
})
require("cmp_git").setup() ]]--

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' },
		{ name = 'cmdline' },
		{ name = 'helptags' },
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})


require'lspconfig'.vimls.setup {}
require'lspconfig'.lua_ls.setup {}
require'lspconfig'.basedpyright.setup{}
require'lspconfig'.jedi_language_server.setup{}
require'lspconfig'.jsonnet_ls.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.spectral.setup{}
require'lspconfig'.yamlls.setup {}
require'lspconfig'.clangd.setup {}
require'lspconfig'.lemminx.setup {}
require'lspconfig'.diagnosticls.setup {}
require'lspconfig'.taplo.setup {}
require'lspconfig'.vale_ls.setup {}
require'lspconfig'.bashls.setup {}
require'lspconfig'.powershell_es.setup {
  bundle_path = 'C:/Users/brobe/AppData/Local/nvim-data/mason/packages/powershell-editor-services',
  filetypes = {
    "ps1",
  },
  shell = "pwsh",
  single_file_support = true
}

-- Linters
require('lint').linters_by_ft = {
  yaml = {
    'yamllint',
    opts = {
      cmd = { 'yamllint -f parsable' },
    },
  },
  lua = { 'luac', 'luacheck' },
  markdown = { 'markdownlint' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})

-- neomake
vim.fn['neomake#configure#automake']('rw', 1000)

-- Neovide
if vim.g.neovide then
  vim.opt.linespace = 0.2
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.8
  vim.g.neovide_padding_top = 0.5
  vim.g.neovide_padding_bottom = 0.5
  vim.g.neovide_padding_right = 0.5
  vim.g.neovide_padding_left = 0.5
  vim.g.neovide_transparency = 0.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  vim.g.neovide_floating_corner_radius = 0.5
  vim.g.neovide_position_animation_length = 0.05
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_scroll_animation_far_lines = 999
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_underline_stroke_scale = 1.0
  vim.g.neovide_theme = 'dark'
  vim.g.experimental_layer_grouping = false
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_no_idle = true
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_detach_on_quit = 'prompt'
  vim.g.neovide_fullscreen = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_profiler = false
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 1.5
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_unfocused_outline_width = 0.025
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
  vim.g.neovide_cursor_vfx_opacity = 200.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 2.0
  vim.g.neovide_cursor_vfx_particle_density = 7.0
  vim.g.neovide_cursor_vfx_particle_speed = 10.0
end

if vim.g.neovide then
	-- keybindings to change scale factor on the fly
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1/1.25)
	end)
end

