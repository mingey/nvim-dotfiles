require('nvim-treesitter.configs').setup {
	rainbow = {
		enabled = true,
		colors = require('ayu').rainbow_colors()
	},
  highlight = {
    enable = true,
  },
  additional_vim_regex_highlighting = false,
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
	textobjects = {
		select = {
			enable = true,
		},
	},
}
