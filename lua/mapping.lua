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
vim.keymap.set('n', '<F2>', ':edit $MYVIMRC<cr>')
vim.keymap.set('i', '<F2>', ':edit $MYVIMRC<cr>')
vim.keymap.set('c', '<F2>', ':edit $MYVIMRC<cr>')
vim.keymap.set('v', '<F2>', ':edit $MYVIMRC<cr>')
-- save and source current buffer
vim.keymap.set('n', '<Leader>xs', ':w <Bar> so %<cr>')
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
