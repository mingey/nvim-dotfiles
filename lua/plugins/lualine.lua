return {
  'nvim-lualine/lualine.nvim',
	event = 'VimEnter',
		opts = {
    options = {
      icons_enabled = true,
      theme = 'catppuccin',
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      always_show_tabline = true,
     globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = {'searchcount', 'mode', 'selectioncount'},
      lualine_b = {
  			{
  				'branch'
  			},
  			{
  				'diff'
  			},
  			{
  				'diagnostics'
  			},
  			{
          'lsp_progress',
          lsp_progress = function()
            return require('lsp-progress').progress()
          end,
          'lint_progress',
          lint_progress = function()
            local linters = require("lint").get_running()
            if #linters == 0 then
              return "󰦕"
            end
            return "󱉶 " .. table.concat(linters, ", ")
          end,
        },
      },
      lualine_c = {
  		{
  			'filename',
  			file_status = true,
  			newfile_status = true,
  			path = 0,
  			shorting_target = 55,
  			symbols = {
  				modified = '',
  				readonly = '',
  				unnamed = '❓',
  				newfile = '',
  			},
  		},
  		{
  			'tabs',
  			tab_max_length = 10,
  			use_mode_colors = false,
  			show_modified_status = false,
  		},
  	},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'filesize', 'progress'},
      lualine_z = {'location'},
    },
    inactive_sections = {
      lualine_a = {'filename'},
      lualine_b = {'tabs'},
      lualine_c = {'datetime'},
      lualine_x = {'location'},
      lualine_y = {'filetype'},
      lualine_z = {'progress'},
    },
    tabline = {
        lualine_a = {'buffers'},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'tabs'}
      },
    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
  			{
  				'filename',
  				file_status = false,
  				path = 2,
  			},
  	  },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
    inactive_winbar = {},
    extensions = {
  	'fzf',
  	'man',
  	'mason',
  	'neo-tree',
  	'nerdtree',
  	'quickfix',
  	'symbols-outline',
  	'trouble',
  	},
  },
}
