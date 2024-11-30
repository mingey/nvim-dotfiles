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

