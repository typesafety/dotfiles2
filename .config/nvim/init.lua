-- Set this first.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make the normal behavior of space a noop.
vim.keymap.set('n', '<space>', '<nop>')

-- Bootstrapping the package manager, if needed.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

--
-- Install plugins.
--

local plugins = {
    -- LSP
    {
        'neovim/nvim-lspconfig',
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = {
            {
                'nvim-lua/plenary.nvim',
            },
        },
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            {
                'hrsh7th/cmp-nvim-lsp',
            },
            {
                'hrsh7th/cmp-buffer',
            },
            {
                'hrsh7th/cmp-path',
            },
            {
                'saadparwaiz1/cmp_luasnip',
                dependencies = {
                    'L3MON4D3/LuaSnip',
                }
            },
        },
    },

    -- Colors
    {
        'folke/tokyonight.nvim',
    },

    -- Utils
    {
        'echasnovski/mini.comment',
        version = false,
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            {
                'nvim-lua/plenary.nvim',
            },
        },
    },

    -- Language-specific
    {
        'mrcjkb/haskell-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
    },

}

require('lazy').setup(plugins)

--
-- Load plugins.  Each plugin file should define settings for it.
--

require('plugins/haskell-tools_nvim')
require('plugins/nvim-lspconfig')
require('plugins/mini_comment')
require('plugins/null-ls_nvim')
require('plugins/nvim-cmp')
require('plugins/nvim-treesitter')
require('plugins/nvim-ts-context-commentstring')
require('plugins/tokyonight_nvim')

--
-- Set normal settings
--

-- Color scheme.
vim.opt.termguicolors = true
vim.api.nvim_cmd({
  cmd = 'colorscheme',
  args = {'tokyonight'},
}, {})

-- Don't do fancy conversion from spaces -> tab.
vim.opt.softtabstop = 0
-- Use spaces instead of tabs
vim.opt.expandtab = true
-- How many spaces should be inserted when pressing tab.
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.tabstop = 4

-- Turn on the mouse.
vim.opt.mouse = 'a'

-- Make splits open in the right place (to the right and to the bottom).
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Incremental highlighting for commands.
vim.opt.inccommand = 'split'

-- Don't want to automatically insert comment leaders after using `o` in
-- normal mode.  Doesn't work without the autocmd for some freak reason.
vim.cmd [[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions+=j formatoptions+=q]]

-- Highlight curent line
vim.opt.cursorline = true

-- Rulers
vim.opt.colorcolumn = {80; 120}

-- Show interesting whitespace characters.
-- (TODO: these don't work, font issue?)
vim.opt.list = true
vim.opt.listchars['trail'] = '·'
vim.opt.listchars['tab'] = '›'

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Do not use autowrite.
vim.opt.autowrite = false

-- Do not sync clipboard to the system clipboard.
vim.opt.clipboard = ''

-- grep options.
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"  -- Requires ripgrep

-- Use relative line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Hide the mode since we have a statusline.
vim.opt.showmode = true  -- Change to `false` once a statusline is installed.

-- Always show the sign column to avoid the screen skip left and right.
vim.opt.signcolumn = 'yes'

vim.opt.smartindent = true

-- Keep undo history after closing the buffer.
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 5000

-- Wrapping of long lines.
vim.opt.wrap = true

-- This is good supposedly.
vim.g.markdown_recommended_style = 0

--
-- Keymaps
--

-- Open Lazy menu
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>')

-- Reload the config.
vim.keymap.set('n', '<leader>re', '<cmd>source ~/.config/nvim/init.lua<cr>')

-- Switch between windows.
vim.keymap.set('n', '<A-l>', '<C-w>l')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-j>', '<C-w>j')

-- Switch between tabs.
vim.keymap.set('n', '<leader>1', '1gt')
vim.keymap.set('n', '<leader>2', '2gt')
vim.keymap.set('n', '<leader>3', '3gt')
vim.keymap.set('n', '<leader>4', '4gt')
vim.keymap.set('n', '<leader>5', '5gt')
vim.keymap.set('n', '<leader>6', '6gt')
vim.keymap.set('n', '<leader>7', '7gt')
vim.keymap.set('n', '<leader>8', '8gt')
vim.keymap.set('n', '<leader>9', '9gt')

-- Navigate tabs by history.
vim.keymap.set('n', '<leader>k', '<cmd>tabprevious<cr>')
vim.keymap.set('n', '<leader>j', '<cmd>tabnext<cr>')

-- Open tab to the left/right.
vim.keymap.set('n', '<leader>h', 'gT')
vim.keymap.set('n', '<leader>l', 'gt')

-- Other tab stuff.
vim.keymap.set('n', '<leader><tab>t', '<cmd>tabnew<cr>')
vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>')

-- Clear search highlighting with <esc>
vim.keymap.set('n', '<esc>', '<cmd>noh<cr><esc>')

-- Highlight the current word.
vim.keymap.set('n', 'gw', '*N')

-- Make `n` and `N` always go in the same direction, regardless of forwards o
-- backwards searching (`/` or `?`).
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

--
-- Autocommands
--

-- https://www.lazyvim.org/configuration/general#auto-commands
local function augroup(name)
    return vim.api.nvim_create_augroup('config_' .. name, { clear = true })
end

-- Go to last location when opening a buffer.
-- https://www.lazyvim.org/configuration/general#auto-commands
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup('last_location'),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Close some window tyeps with <q>
-- https://www.lazyvim.org/configuration/general#auto-commands
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})
