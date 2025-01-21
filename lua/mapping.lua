vim.g.mapleader = '\\'

-- spacebar enters command mode
vim.keymap.set('n', '<Space>', ':')

-- right arrow replaces spacebar in normal mode
vim.keymap.set('n', '<Right>', '<Space>')

-- CapsLock = Esc...also set systemwide in PowerToys
vim.keymap.set('n', '<Caps_Lock>', '<Esc>')
vim.keymap.set('i', '<Caps_Lock>', '<Esc>')
vim.keymap.set('c', '<Caps_Lock>', '<Esc>')
vim.keymap.set('v', '<Caps_Lock>', '<Esc>')

-- F2 opens init.lua for editing
vim.keymap.set('n', '<F2>', ':split $MYVIMRC<cr>')
vim.keymap.set('i', '<F2>', ':split $MYVIMRC<cr>')
vim.keymap.set('c', '<F2>', ':split $MYVIMRC<cr>')
vim.keymap.set('v', '<F2>', ':split $MYVIMRC<cr>')

-- F3 toggles LazyDo
vim.keymap.set('n', '<F3>', ':LazyDoToggle<cr>')
vim.keymap.set('i', '<F3>', ':LazyDoToggle<cr>')
vim.keymap.set('c', '<F3>', ':LazyDoToggle<cr>')
vim.keymap.set('v', '<F3>', ':LazyDoToggle<cr>')

-- save and source current buffer
vim.keymap.set('n', '<Leader>xs', ':w <Bar> so %<cr>', { desc = 'Save and source buffer'})

-- moving screenwise through wrapped text with arrow keys and Home/End
vim.keymap.set('n', '<down>', 'gj')
vim.keymap.set('n', '<up>', 'gk')
vim.keymap.set('v', '<down>', 'gj')
vim.keymap.set('v', '<up>', 'gk')
vim.keymap.set('i', '<down>', '<c-o>gj')
vim.keymap.set('i', '<up>', '<c-o>gk')
vim.keymap.set('i', '<home>', '<c-o>g<home>')
vim.keymap.set('i', '<end>', '<c-o>g<end>')

-- shuffle the lines of a file
vim.keymap.set('n', '<Leader>r', ':%!shuf<cr>')

-- use tabs to navigate through mini.completion list
local imap_expr = function(lhs, rhs)
	vim.keymap.set('i', lhs, rhs, { expr = true })
end
imap_expr('<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

-- Use <CR> in mini.completion in a more intuitive way
local keycode = vim.keycode or function(x)
	return vim.api.nvim_replace_termcodes(x, true, true, true)
end
local keys = {
	['cr'] = keycode('<CR>'),
	['ctrl-y'] = keycode('<C-y>'),
	['ctrl-y_cr'] = keycode('<C-y><CR>'),
}

_G.cr_action = function()
	if vim.fn.pumvisible() ~= 0 then
		-- if popup is visible, confirm selected line or add new line otherwise
		local item_selected = vim.fn.complete_info()['selected'] ~= -1
		return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
	else
		-- If popup is not visible, use plain `<CR>`. You might want to customize according to
		-- other plugins. For example, to use 'mini.pairs', replace next line with `return 
		-- require('mini.pairs').cr()`
		return keys['cr']
	end
end

vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })

-- Telescope shortcuts
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tt', ':Telescope<CR>', { desc = 'Telescope main menu' })
vim.keymap.set('n', '<leader>tc', builtin.colorscheme, { desc = 'Telescope colorschemes' })
vim.keymap.set('n', '<leader>td', builtin.diagnostics, { desc = 'Telescope diagnostics' })
vim.keymap.set('n', '<leader>tf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = 'Telescope help_tags' })
vim.keymap.set('n', '<leader>tk', builtin.keymaps, { desc = 'Telescope keymaps' })

-- FzfLua shortcuts
vim.keymap.set('n', '<leader>ff', ':FzfLua<CR>', { desc = 'FzfLua main menu' })
vim.keymap.set('n', '<leader>fa', ':FzfLua awesome_colorschemes<CR>', { desc = 'FzfLua awesome colorschemes' })
vim.keymap.set('n', '<leader>fc', ':FzfLua colorschemes<CR>', { desc = 'FzfLua colorschemes' })
vim.keymap.set('n', '<leader>fd', ':FzfLua diagnostics_document<CR>', { desc = 'FzfLua diagnostics (document)' })
vim.keymap.set('n', '<leader>fi', ':FzfLua files<CR>', { desc = 'FzfLua files' })
vim.keymap.set('n', '<leader>fh', ':FzfLua helptags<CR>', { desc = 'FzfLua helptag' })
vim.keymap.set('n', '<leader>fk', ':FzfLua keymaps<CR>', { desc = 'FzfLua keymaps' })

-- open mini.files window in current buffer's directory
local function open_mini_files(arg)
	if not MiniFiles.close() then
		MiniFiles.open(arg)
	end
end

vim.keymap.set('n', '-', function()
	open_mini_files(vim.api.nvim_buf_get_name(0))
end, { desc = "Open MiniFiles in current file's directory" })

-- open mini.files window in cwd
vim.keymap.set('n', '_', function()
	open_mini_files(vim.uv.cwd())
end, { desc = 'Open MiniFiles in CWD' })

-- open mini.files selection in split
local map_split = function(buf_id, lhs, direction)
	local rhs = function()
		-- Make new window and set it as target
		local cur_target = MiniFiles.get_explorer_state().target_window
		local new_target = vim.api.nvim_win_call(cur_target, function()
			vim.cmd(direction .. ' split')
			return vim.api.nvim_get_current_win()
		end)

		MiniFiles.set_target_window(new_target)

		-- This intentionally doesn't act on file under cursor in favor of
		-- explicit "go in" action (`l` / `L`). To immediately open file,
		-- add appropriate `MiniFiles.go_in()` call instead of this comment.
	end

	-- Adding `desc` will result into `show_help` entries
	local desc = 'Split ' .. direction
	vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

vim.api.nvim_create_autocmd('User', {
	pattern = 'MiniFilesBufferCreate',
	callback = function(args)
		local buf_id = args.data.buf_id
		-- Tweak keys to your liking
		map_split(buf_id, '<C-s>', 'belowright horizontal')
		map_split(buf_id, '<C-v>', 'belowright vertical')
	end,
})

-- mini.files: `g~` to set directory under cursor as cwd; `gy` to yank the full path of 
-- file under cursor
local set_cwd = function()
	local path = (MiniFiles.get_fs_entry() or {}).path
	if path == nil then return vim.notify('Cursor is not on valid entry') end
	vim.fn.chdir(vim.fs.dirname(path))
end

local yank_path = function()
	local path = (MiniFiles.get_fs_entry() or {}).path
	if path == nil then return vim.notify('Cursor is not on valid entry') end
	vim.fn.setreg(vim.v.register, path)
end

vim.api.nvim_create_autocmd('User', {
	pattern = 'MiniFilesBufferCreate',
	callback = function(args)
		local b = args.data.buf_id
		vim.keymap.set('n', 'g~', set_cwd, { buffer = b, desc = 'Set cwd' })
		vim.keymap.set('n', 'gy', yank_path, { buffer = b, desc = 'Yank path' })
	end,
})


