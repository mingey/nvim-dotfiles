-- install and initialize mini.nvim
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

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({
	path = {
		package = path_package,
	},
})

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
	vim.o.termguicolors = true
	vim.cmd('colorscheme minischeme')
end)

now(function()
	require('mini.notify').setup()
	vim.notify = require('mini.notify').make_notify()
end)

now(function()
	require('mini.icons').setup()
end)

now(function()
	require('mini.tabline').setup()
end)

now(function()
	require('mini.statusline').setup()
end)

-- Safely execute later
later(function()
	require('mini.ai').setup({
		search_method = 'cover_or_nearest',
	})
end)

later(function()
	require('mini.comment').setup()
end)

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

later(function()
	require('mini.pick').setup()
end)

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

later(function()
	require('mini.surround').setup()
end)

now(function()
	-- Use other plugins with `add()`. It ensures plugin is available in current
	-- session (installs if absent)
	add({
		source = 'neovim/nvim-lspconfig',
		-- Supply dependencies near target plugin
		depends = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
	})

	add({
		source = 'rafamadriz/friendly-snippets',
	})

	add({
		source = 'vimwiki/vimwiki',
	})

end)

later(function()
	add ({
		source = 'nvim-treesitter/nvim-treesitter',
		-- Use 'master' while monitoring updates in 'main'
		checkout = 'master',
		monitor = 'main',
		-- Perform action after every checkout
		hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
	})

	-- Possible to immediately execute code which depends on the added plugin
	require('nvim-treesitter.configs').setup({
		ensure_installed = { 'c', 'lua', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },
		highlight = { enable = true },
	})
end)

require('mapping')

-- OPTIONS
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
vim.opt.sidescrolloff = 15

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

-- set colorscheme
vim.opt.background = 'dark'

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

-- languages
vim.g.perl_host_prog='C:\\Users\\brobe\\scoop\\apps\\perl\\current\\perl\\bin\\perl.exe'
vim.g.node_host_prog='C:\\Users\\brobe\\node_modules\\neovim\\bin\\cli.exe'
vim.g.python3_host_prog='C:\\Users\\brobe\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'

-- VimWiki
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
hi VimwikiItalic guifg=#F88379
]])

-- PLUGINS

require('mason').setup()
require('mason-lspconfig').setup()
require'lspconfig'.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					'vim',
					'MiniDeps',
				},
			},
		},
	},
})
require'lspconfig'.clangd.setup({
})

