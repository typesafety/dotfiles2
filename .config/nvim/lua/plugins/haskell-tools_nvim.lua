local ht = require('haskell-tools')
local deps = require('haskell-tools.deps')
local buffer = vim.api.nvim_get_current_buf()
local def_opts = { noremap = true, silent = true, }

-- Add capabilities
local ht_capabilities = {}
local cmp_capabilities = deps.if_available('cmp_nvim_lsp', function(cmp_nvim_lsp)
    return cmp_nvim_lsp.default_capabilities()
end, {})
local selection_range_capabilities = deps.if_available('lsp-selection-range', function(lsp_selection_range)
    return lsp_selection_range.update_capabilities {}
end, {})
local capabilities = vim.tbl_deep_extend(
    'keep',
    ht_capabilities,
    cmp_capabilities, selection_range_capabilities
)

--
-- General LSP config setup (TODO: move somewhere else so it can be reused).
--

-- Diagnostics configuration.
vim.diagnostic.config({
    virtual_text = false,  -- Inline text.
})

-- Open a diagnostics floating window for the currently hovered over symbol.
vim.keymap.set('n', 'L', function()
    -- Make the preview/float window closable with <esc> after entering.
    --
    -- When entering the window, add a new keybind that:
    --
    -- 1. Immediately unbinds itself, so that it's not
    -- 2. Closes the window with the newly opened window's ID.
    local float_bufnr, win_id = vim.diagnostic.open_float()
    vim.keymap.set('n', '<esc>', function()
        vim.keymap.del('n', '<esc>', { buffer = float_bufnr })
        vim.api.nvim_win_close(win_id, false)
    end, { buffer = float_bufnr })
end, def_opts)

-- Go to next/prev diagnostics.
vim.keymap.set('n', '<C-k>', vim.diagnostic.goto_prev, def_opts)
vim.keymap.set('n', '<C-j>', vim.diagnostic.goto_next, def_opts)

vim.keymap.set('n', '<space>ll', vim.diagnostic.setloclist, def_opts)

local function on_attach(client_id, bufnr)
    local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr, })
    -- haskell-language-server relies heavily on codeLenses,
    -- so auto-refresh (see advanced configuration) is enabled by default

    --
    -- haskell-tools mappings.
    --
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
    vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
    vim.keymap.set('n', '<leader>eva', ht.lsp.buf_eval_all, opts)

    --
    -- General LSP config setup.
    --

    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- nvim LSP mappings
    -- See `:help vim.lsp.*` for documentation on any of the below functions,
    -- or https://neovim.io/doc/user/lsp.html.

    -- Show available code actions.
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

    -- Go to definition.
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)

    -- Activate document highlights when cursor is idle over a name.
    -- Clear highlights once the cursor is moved.
    vim.api.nvim_create_autocmd({'CursorHold'}, {
        pattern = '<buffer>',
        callback = function(event)
            vim.lsp.buf.document_highlight()
        end,
    })
    vim.api.nvim_create_autocmd({'CursorMoved'}, {
        pattern = '<buffer>',
        callback = function(event)
            vim.lsp.buf.clear_references()
        end
    })

    -- List all symbols in the current buffer in the quickfix window.
    vim.keymap.set('n', '<leader>sy', vim.lsp.buf.document_symbol, bufopts)

    -- Format the buffer, or a selection if in visual mode.
    vim.keymap.set('n', '<leader>fo', function() vim.lsp.buf.format({ async = true }) end, bufopts)

    -- Display hover information about the symbol under the cursor.
    -- Information shows up in a floating window.
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

    -- List call sites of the symbol under cursor in the quickfix window.
    vim.keymap.set('n', '<leader>cs', vim.lsp.buf.incoming_calls, bufopts)

    -- List refernces to the symbol under the cursor
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, bufopts)

end

--
-- haskell-tools settings (wraps HSL settings, see the `hls` subtable).
--

ht.setup {
    tools = {
        log = {
            level = vim.log.levels.DEBUG,
        },
        codeLens = {
            autoRefresh = true,
        },
        hoogle = {
            mode= 'auto',
        },
    },

    -- HLS settings.
    hls = {
        on_attach = function(client_id, bufnr)
            local success, err = pcall(on_attach, client_id, bufnr)
            if not success then
                ht.log.error('Encountered an exception while running `on_attach`')
                ht.log.error(err)
                ht.log.error(debug.traceback())
            end
        end,

        capabilities = capabilities,

        settings = function(project_root)
            return ht.lsp.load_hls_settings(project_root)
        end,

        filetypes = { 'haskell', 'lhaskell' },
        -- Can't use cabal for some reason, get error:
        -- "No plugin enabled for STextDocumentDocumentHighlight, available:
        -- ghcide-hover-and-symbols", even if the plugin is enabled.

        default_settings = {
            haskell = {
                cabalFormattingProvider = 'cabalfmt',
                formattingProvider = 'fourmolu',
                plugin = {
                    importLens = {
                        globalOn = false,
                    },
                }
            }
        }
    },
}

-- Suggested keymaps that do not depend on haskell-language-server:
local bufnr = vim.api.nvim_get_current_buf()
-- set buffer = bufnr in ftplugin/haskell.lua
local opts = { noremap = true, silent = true, buffer = bufnr }

-- Toggle a GHCi repl for the current package
vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set('n', '<leader>rf', function()
    ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, def_opts)
vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
