require('chadtree')

vim.keymap.set('n', '<C-n>', '<cmd>CHADopen<cr>')
vim.keymap.set('n', '<leader><C-n>', '<cmd>CHADopen --always-focus<cr>')
vim.keymap.set('n', '<leader>HH', '<cmd>CHADhelp keybind<cr>')
