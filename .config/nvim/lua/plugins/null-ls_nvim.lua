local null_ls = require('null-ls')

null_ls.setup({
    sources = {
        --
        -- Builtins
        --

        null_ls.builtins.completion.luasnip,

        -- Requires `pylint` executable.
        null_ls.builtins.diagnostics.pylint.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }),

        null_ls.builtins.diagnostics.todo_comments.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }),
        null_ls.builtins.diagnostics.trail_space.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }),

        -- Requires `cabal-fmt` executable.
        null_ls.builtins.formatting.cabal_fmt.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }),
        -- Requires `fourmolu` executable.
        null_ls.builtins.formatting.fourmolu.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }),

        --
        -- Other
        --
    }
})
