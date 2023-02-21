-- Dependencies:
-- * ripgrep
-- * telescope-fzf-native.nvim
-- * fd
-- * nvim-treesitter

local telescope = require('telescope')

-- Requires telescope-fzf-native.nvim
telescope.load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>R', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
