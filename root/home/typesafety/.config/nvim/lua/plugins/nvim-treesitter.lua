require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'bash',
        'c',
        'haskell',
        'json',
        'lua',
        'markdown',
        'python',
        'toml',
        'vim',
        'yaml',
    },

    highlight = {
        enable = true,

        additional_vim_regex_highlighting = false,
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            -- Set to `false` to disable one of the mappings.
            init_selection = 'gnn', 
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
        },
    },

    indent = {
        enable = true,
    },
})
