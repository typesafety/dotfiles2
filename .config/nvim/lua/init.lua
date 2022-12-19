-- Attempt at a Lua init file (to be sourced when nvim is launched).

--
-- Load packages/plugins.
-- Uses Paq: https://github.com/savq/paq-nvim
-- See bootstrap.lua for the automated setup.
--

-- List of packages to install and manage.
--
-- To install, run :PaqInstall.
require 'paq' {
    -- Paq should manage itself
    'savq/paq-nvim';

    -- Mason Package manager 
    'williamboman/mason.nvim';
    'williamboman/mason-lspconfig.nvim';

    'neovim/nvim-lspconfig';

    'tpope/vim-commentary';  -- `gc` to comment/uncomment; useful as fuck.
    'tpope/vim-surround';

    -- Neat tool for aligning stuff by patterns.
    'junegunn/vim-easy-align';

    -- Fuzzy file finder.  Bind :FZF to a keybinding, like Alt + P.
    --
    -- See the following for good reading on how to use the plugin:
    -- https://github.com/junegunn/fzf/blob/master/README-VIM.md
    --
    -- Also see https://github.com/junegunn/fzf.vim for some more inspiration
    -- on what to do with the plugin.
    --
    -- Run `:call fzf#install()` to install the latest binary.
    {'junegunn/fzf', run=vim.fn['fzf#install()']};
    'junegunn/fzf.vim';

    -- File tree explorer.
    -- See the following for a primer on commands to bind:
    -- https://github.com/preservim/nerdtree#frequently-asked-questions
    'preservim/nerdtree';

    --
    -- Color schemes
    --
    'hachy/eva01.vim';
    'folke/tokyonight.nvim';
    'sainnhe/everforest';
    'hoppercomplex/calvera-dark.nvim';

    --
    -- Haskell
    --
    'neovimhaskell/haskell-vim';

    --
    -- Rust
    --
    'simrat39/rust-tools.nvim';
}


--
-- Colors
--
vim.cmd [[ set background=dark ]]

vim.cmd [[
let g:everforest_background = 'hard'
]]

vim.cmd [[ colorscheme tokyonight-night ]]
-- require('calvera').set()

--
-- Haskell
--

vim.cmd [[
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

let g:haskell_indent_if = 4
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_guard = 4
let g:haskell_indent_in = 0
let g:haskell_indent_case_alternative = 1

let g:haskell_classic_highlighting = 1
]]


--
-- Add more stuff
--

-- Set up Mason
require("mason").setup()



--
-- General LSP config.
--

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '💩'})
sign({name = 'DiagnosticSignWarn', text = '👿'})
sign({name = 'DiagnosticSignHint', text = '🤓'})
sign({name = 'DiagnosticSignInfo', text = '🧙'})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    severity_sort = true,
    -- float = {
    --     source = 'always',
    --     header = '',
    --     prefix = '',
    -- },
})

--vim.cmd([[
--set signcolumn=yes
--autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
--]])

--
-- Rust
--

local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
