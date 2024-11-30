-- plugins/telescope.lua:
return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = {
		{ 'nvim-lua/plenary.nvim' },
		{	'polirritmico/telescope-lazy-plugins.nvim' },
		{ 'andrewberty/telescope-themes' },
	},
	opts = {
		defaults = {
			sorting_strategy = 'ascending',
			scroll_strategy = 'limit',
			wrap_results = true,
			dynamic_preview_title = true,
			layout_strategy = 'vertical',
			preview = {
				filesize_limit = 50,
				timeout = 2000,
				treesitter = true,
			},
			cache_picker = {
				num_pickers = -1,
				limit_entries = 5000,
			},
		},
		pickers = {
			find_files = {
				mappings = {
					n = {
						["cd"] = function(prompt_bufnr)
							local selection = require("telescope.actions.state").get_selected_entry()
							local dir = vim.fn.fnamemodify(selection.path, ":p:h")
							require("telescope.actions").close(prompt_bufnr)
							-- Depending on what you want put `cd`, `lcd`, `tcd`
							vim.cmd(string.format("silent lcd %s", dir))
						end
					}
				}
			},
		},
		extensions = {
			lazy_plugins = {
				lazy_config = vim.fn.stdpath("config") .. "init.lua",
			},
			fzf = {
				fuzzy = true,          -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			['ui-select'] = {
				require('telescope.themes').get_dropdown
			},
			themes = {
				ignore = {},
			},
			file_browser = {
			},
		}
	},

	require('telescope').load_extension('themes'),
	require('telescope').load_extension('ui-select'),
	require('telescope').load_extension('zf-native'),
	require('telescope').load_extension('repo'),
	require('telescope').load_extension('bookmarks'),
	require('telescope').load_extension('file_browser'),
	require('telescope').load_extension('frecency'),
	require('telescope').load_extension('lazy_plugins'),
}

