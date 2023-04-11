-- Dependencies:
-- * ripgrep
-- * telescope-fzf-native.nvim
-- * fd
-- * nvim-treesitter

local telescope = require('telescope')

-- Requires telescope-fzf-native.nvim
telescope.load_extension('fzf')

telescope.setup({
    defaults = {},
    pickers = {
        live_grep = {
            theme = 'ivy',
        },
    },
    extensions = {},
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>tl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>tg', builtin.grep_string, {})
vim.keymap.set('n', '<leader>tt', builtin.resume, {})
vim.keymap.set('n', '<leader>th', builtin.help_tags, {})
