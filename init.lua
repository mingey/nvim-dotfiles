-- mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		'git', 'clone', '--filter=blob:none',
		'https://github.com/echasnovski/mini.nvim', mini_path
	}
	vim.fn.system(clone_cmd)
	vim.cmd('packadd mini.nvim | helptags ALL')
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- mini.deps
require('mini.deps').setup({
	job = {
		n_threads = nil,
		timeout = 120000,
	},
	path = {
		package = path_package,
		snapshot = vim.fn.stdpath('config') .. '/mini-deps-snap',
		log = vim.fn.stdpath('config') .. '/mini-deps.log',
	},
	silent = false,
})

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- COLORSCHEMES

	vim.o.termguicolors = true

-- Catppuccin

now(function()
	add({
		source = 'catppuccin/nvim',
		name = 'catppuccin'
	})
end)

require('catppuccin').setup({
	flavour = 'mocha',
	transparent_background = true,
	dim_inactive = {
		enabled = false,
		shade = 'dark',
		percentage = 0.25,
	},
	integrations = {
		vimwiki = true,
	}
})

-- Everblush

now(function()
	add({
		source = 'Everblush/nvim',
		name = 'everblush',
	})
end)

-- Monokai

now(function()
	add({
		source = 'tanvirtin/monokai.nvim',
	})
end)

require('monokai').setup{}
require('monokai').setup { palette = require('monokai').pro }
require('monokai').setup { palette = require('monokai').soda }
require('monokai').setup { palette = require('monokai').ristretto }

-- declare colorscheme

now(function()
	vim.cmd.colorscheme 'monokai'
end)

-- MINI.NVIM PLUGINS (and dependencies)

-- mini.sessions

now(function()
	require('mini.sessions').setup({
		autoread = false,
		autowrite = false,
	})
end)

-- ascii.nvim (for art in mini.starter buffer) and nui.nvim

now(function()
	add({
		source = 'MaximilianLloyd/ascii.nvim',
		depends = {
			'MunifTanjim/nui.nvim',
		},
	})
end)

-- mini.starter

now(function()
	require('mini.starter').setup()
end)

local starter = require('mini.starter')
starter.setup({
	autoopen = true,
	evaluate_single = false,
	items = {
		starter.sections.sessions(10, true),
		starter.sections.recent_files(10, false, false),
		starter.sections.builtin_actions(),
	},
	header = table.concat(require('ascii').art.text.neovim.colossal, '\n'),
	footer = nil,
	content_hooks = nil,
	query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
	silent = false,
})

-- mini.notify

local win_config = function() -- displays notifications in bottom right corner
	local has_statusline = vim.o.laststatus > 0
	local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
	return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
end

now(function()
	require('mini.notify').setup({
		window = {
			config = win_config
		}
	})
	vim.notify = require('mini.notify').make_notify()
end)

-- mini.icons

now(function()
	require('mini.icons').setup()
end)

-- mini.visits

now(function()
	require('mini.visits').setup()
end)

-- mini.git

now(function()
	require('mini.git').setup()
end)

-- mini.diff

now(function()
	require('mini.diff').setup()
end)

-- mini.tabline

now(function()
	require('mini.tabline').setup()
end)

-- mini.test

now(function()
	require('mini.test').setup()
end)

-- mini.statusline

now(function()
	require('mini.statusline').setup({})
end)

vim.cmd([[
hi MiniStatuslineModeNormal guifg=#8ccf7e guibg=#141b1e
hi MiniStatuslineFilename guifg=#ffffbf guibg=#141b1e
]])

-- mini.ai

later(function()
	require('mini.ai').setup({
		search_method = 'cover_or_nearest',
	})
end)

-- mini.bufremove

later(function()
	require('mini.bufremove').setup()
end)

-- mini.clue

later(function()
	local miniclue = require('mini.clue')
	require('mini.clue').setup({
		triggers = {
			-- Leader triggers
			{ mode = 'n', keys = '<Leader>' },
			{ mode = 'x', keys = '<Leader>' },
			{ mode = 'n', keys = '<Leader>m' },
			{ mode = 'x', keys = '<Leader>m' },

			-- Built-in Completion
			{ mode = 'i', keys = '<C-x>' },

			-- 'g' key
			{ mode = 'n', keys = 'g' },
			{ mode = 'x', keys = 'g' },

			-- Marks
			{ mode = 'n', keys = "'" },
			{ mode = 'n', keys = "`" },
			{ mode = 'x', keys = "'" },
			{ mode = 'x', keys = "`" },

			-- Registers
			{ mode = 'n', keys = '"' },
			{ mode = 'x', keys = '"' },
			{ mode = 'i', keys = '<C-r>' },
			{ mode = 'c', keys = '<C-r>' },

			-- Window commands
			{ mode = 'n', keys = '<C-w>' },

			-- 'z' key
			{ mode = 'n', keys = 'z' },
			{ mode = 'x', keys = 'z' },
		},

		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows({
				submode_move = true,
				submode_navigate = true,
				submode_resize = true,
			}),
			miniclue.gen_clues.z(),
			{ mode = 'n', keys = '<Leader>mh', postkeys = '<Leader>m' },
			{ mode = 'n', keys = '<Leader>mj', postkeys = '<Leader>m' },
			{ mode = 'n', keys = '<Leader>mk', postkeys = '<Leader>m' },
			{ mode = 'n', keys = '<Leader>ml', postkeys = '<Leader>m' },
			{ mode = 'x', keys = '<Leader>mh', postkeys = '<Leader>m' },
			{ mode = 'x', keys = '<Leader>mj', postkeys = '<Leader>m' },
			{ mode = 'x', keys = '<Leader>mk', postkeys = '<Leader>m' },
			{ mode = 'x', keys = '<Leader>ml', postkeys = '<Leader>m' },
		},

		window = {
			delay = 0,
			config = {
				width = 'auto',
				border = 'double',
			},
		},
	})
end)

-- mini.extra

later(function()
	require('mini.extra').setup()
end)

-- mini.files

later(function()
	require('mini.files').setup({
		windows = {
			preview = true,
		},
		options = {
			use_as_default_explorer = false,
		},
	})
end)

-- mini.comment

later(function()
	require('mini.comment').setup()
end)

-- mini.completion

later(function()
	require('mini.completion').setup({
		delay = {
			completion = 100,
			info = 0,
			signature = 0,
		},
		window = {
			info = {
				height = 25,
				width = 80,
				border = 'rounded',
			},
			signature = {
				height = 25,
				width = 80,
				border = 'single'
			},
		},
		lsp_completion = {
			source_func = 'completefunc',
			auto_setup = true,
			-- process_items = <function: MiniCompletion.default_process_items>,
		},
		fallback_action = '<C-x><C-v>',
		mappings = {
			force_twostep = '<C-Space>',
			force_fallback = '<A-Space>',
		},
		set_vim_settings = true,
	})
end)

-- mini.move

later(function()
	require('mini.move').setup({
		mappings = {
			left			= '<Leader>mh',
			right			= '<Leader>ml',
			down			= '<Leader>mj',
			up				= '<Leader>mk',
			line_left	= '<Leader>mh',
			line_right= '<Leader>ml',
			line_down	= '<Leader>mj',
			line_up		= '<Leader>mk',
		},
	})
end)

-- mini.pairs

later(function()
	require('mini.pairs').setup()
end)

-- mini.pick

later(function()
	require('mini.pick').setup()
end)

-- mini.snippets

later(function()
	local gen_loader = require('mini.snippets').gen_loader
	require('mini.snippets').setup({
		snippets = {
			-- custom snippets first:
			gen_loader.from_file('~/AppData/Local/nvim/lua/snippets/global.json'),
			-- files from "snippets/" subdirectories in rtp
			gen_loader.from_lang(),
		},
	})
end)

-- mini.surround

later(function()
	require('mini.surround').setup()
end)

-- OTHER PLUGINS

now(function()

-- nvim-lspconfig, Mason, Mason-lspconfig

	add({
		source = 'neovim/nvim-lspconfig',
		-- Supply dependencies near target plugin
		depends = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
	})

	require('mason').setup()
	require('mason-lspconfig').setup()
	require'lspconfig'.lua_ls.setup({
		settings = {
			Lua = {
				diagnostics = {
					globals = {
						'vim',
						'MiniDeps',
						'MiniStarter',
					},
				},
			},
		},
	})
	require'lspconfig'.clangd.setup({
	})

	require'lspconfig'.lua_ls.setup {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT'
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME
						-- Depending on the usage, you might want to add additional paths here.
						-- "${3rd}/luv/library"
						-- "${3rd}/busted/library",
					}
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
					-- library = vim.api.nvim_get_runtime_file("", true)
				}
			})
		end,
		settings = {
			Lua = {}
		}
	}

-- friendly-snippets

	add({
		source = 'rafamadriz/friendly-snippets',
	})

-- VimWiki

	add({
		source = 'vimwiki/vimwiki',
	})

	vim.g.vimwiki_global_ext = 0
	vim.cmd([[
		let g:vimwiki_key_mappings =
		\{
		\	'all_maps': 1,
		\	'global': 1,
		\	'headers': 1,
		\	'text_objs': 1,
		\	'table_format': 1,
		\	'table_mappings': 1,
		\	'lists': 1,
		\	'links': 1,
		\	'html': 1,
		\	'mouse': 1,
		\}
	hi VimwikiItalic guifg=#F88379 gui=italic
	]])

-- helpview

	add({
		source = 'OXY2DEV/helpview.nvim',
	})

-- coop.nvim

	add({
		source = 'gregorias/coop.nvim',
	})

-- pathlib.nvim

	add({
		source = 'pysan3/pathlib.nvim',
})

-- Telescope & plenary.nvim

	add({
		source = 'nvim-telescope/telescope.nvim',
		depends = {
			'nvim-lua/plenary.nvim',
		},
	})

-- LazyDo

	add({
		source = 'Dan7h3x/LazyDo',
		checkout = 'main',
	})

	require'LazyDo'.setup({
		title = " ToDo ",
	})

-- Oatmeal

	add({
		source = 'dustinblackman/oatmeal.nvim',
	})

	require("oatmeal").setup({
		backend = 'ollama',
		model = 'llama3.2:latest',
	})

-- fzf-lua & nvim-web-devicons

	add({
		source = 'ibhagwan/fzf-lua',
		depends = {
			'nvim-tree/nvim-web-devicons',
		},
	})

-- lush

	add({
		source = 'rktjmp/lush.nvim',
	})

-- mpv.nvim

	add({
		source = 'tamton-aquib/mpv.nvim',
	})

	require'mpv'.setup()

end)

later(function()

-- Treesitter

	add ({
		source = 'nvim-treesitter/nvim-treesitter',
		-- Use 'master' while monitoring updates in 'main'
		checkout = 'master',
		-- monitor = 'main',
		-- Perform action after every checkout
		hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
	})

	require('nvim-treesitter.configs').setup({
		ensure_installed = { 'c', 'lua', 'markdown', 'markdown_inline', 'vim', 'vimdoc', 'xml' },
		highlight = { enable = true },
	})
end)

-- KEYMAPS

require('mapping')

-- VIM OPTIONS

-- file navigation & handling
vim.opt.autochdir = false

-- gui
vim.opt.number = true
vim.opt.signcolumn = 'auto:2-9'
vim.opt.cursorbind = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.laststatus = 2
vim.opt.cmdheight = 4
vim.opt.guicursor = { 'n-v-c:block', 'i-ci-ve:ver25', 'r-cr:hor20', 'o:hor50', 'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor', 'sm:block-blinkwait175-blinkoff150-blinkon175' }
vim.opt.list = true
vim.opt_global.listchars = 'tab:> ,trail:-,nbsp:+,extends:&,precedes:&'
vim.opt.pumblend = 10

-- wrapping and indentation
vim.cmd [[filetype plugin indent on]]
vim.opt.textwidth = 90
vim.opt.wrap = false
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
vim.opt.foldlevel = 5

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
vim.opt.sidescrolloff = 10

-- editing
vim.opt.formatoptions = 'tcqwnjc'
vim.opt.paste = false

-- search & substitute
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.infercase = true
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

-- set colorscheme
vim.opt.background = 'dark'

-- NEOVIDE OPTIONS
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

-- LANGUAGES
vim.g.perl_host_prog='C:\\Users\\brobe\\scoop\\apps\\perl\\current\\perl\\bin\\perl.exe'
vim.g.node_host_prog='C:\\Users\\brobe\\node_modules\\neovim\\bin\\cli.exe'
vim.g.python3_host_prog='C:\\Users\\brobe\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
