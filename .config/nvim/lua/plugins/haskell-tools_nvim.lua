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
local capabilities = vim.tbl_deep_extend('keep', ht_capabilities, cmp_capabilities, selection_range_capabilities)

local function on_attach(client_id, bufnr)
    local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr, })
    -- haskell-language-server relies heavily on codeLenses,
    -- so auto-refresh (see advanced configuration) is enabled by default
    vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run, opts)
    vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
    vim.keymap.set('n', '<leader>ea', ht.lsp.buf_eval_all, opts)

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

ht.setup {
    tools = {
        log = {
            level = vim.log.levels.DEBUG,
        },
        codeLens = {
            autoRefresh = false,
        },
        hoogle = {
            mode= 'auto',
        },
    },

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

        filetypes = { 'haskell', 'lhaskell', 'cabal' },

        default_settings = {
            haskell = {
                plugin = {
                    importLens = {
                        globalOn = false,
                    },
                },
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
