-- Set this first.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Since space is now the leader key, make its command a noop.
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
    {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
    },
    {
        'williamboman/mason-lspconfig.nvim',
    },

    -- Colors
    {
        'folke/tokyonight.nvim',
    },

    -- Git
    {
        'sindrets/diffview.nvim',
        dependiencies = {
            'nvim-lua/plenary.nvim',
        },
    },
    {
        'lewis6991/gitsigns.nvim',
    },

    -- Other utils
    {
        'nanozuki/tabby.nvim',
    },
    {
        'ThePrimeagen/harpoon',
        dependencies = {
            {
                'nvim-lua/plenary.nvim',
            },
        },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            {
                'nvim-lua/plenary.nvim',
            },
        },
    },
    {
        'ms-jpq/chadtree',
        branch = chad,
        -- Requires python and virtualenv to be installed.
        build = 'python3 -m chadtree deps',
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            {
                'kyazdani42/nvim-web-devicons',
            },
        },
    },
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
        'kylechui/nvim-surround',
        version = '*',  -- Use for stability; omit to use `main` branch for the latest features
        event = 'VeryLazy',
        config = function()
            require('nvim-surround').setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    }
}

require('lazy').setup(plugins)

--
-- Load plugins.  Each plugin file should define settings for it.
--

-- mason.nvim & mason-lspconfig.nvim
-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
--
-- Note the order that the plugins must be loaded in (mason-lspconfig README):
-- 1. mason
-- 2. mason-lspconfig
-- 3. nvim-lspconfig

require('mason').setup()
require('mason-lspconfig').setup()

-- harpoon
-- https://github.com/ThePrimeagen/harpoon#readme

local harpoon = require('harpoon').setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 50,
    }
})
local harpoon_ui = require('harpoon.ui')
local harpoon_mark = require('harpoon.mark')

vim.keymap.set('n', '<C-h>', harpoon_ui.toggle_quick_menu)
vim.keymap.set('n', '<C-m>', harpoon_mark.add_file)

-- tabby.nvim
-- https://github.com/nanozuki/tabby.nvim

local tabby = require('tabby.tabline')
tabby.use_preset('active_wins_at_tail')


require('plugins/chadtree')
require('plugins/diffview_nvim')
require('plugins/gitsigns_nvim')
require('plugins/lualine_nvim')
require('plugins/mini_comment')
require('plugins/nvim-cmp')
require('plugins/nvim-lspconfig')
require('plugins/nvim-treesitter')
require('plugins/nvim-ts-context-commentstring')
require('plugins/telescope_nvim')
require('plugins/tokyonight_nvim')

--
-- Set normal settings
--

-- For options, see: https://neovim.io/doc/user/options.html

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

-- Don't want to automatically insert comment leaders after using `o` in normal
-- mode.  Doesn't work without the autocmd for some freak reason.
vim.cmd [[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions+=j formatoptions+=q]]

-- Highlight curent line
vim.opt.cursorline = true

-- Rulers
vim.opt.colorcolumn = {80; 100; 120}

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

-- Hide the mode since we have a statusline showing the mode instead.
vim.opt.showmode = false

-- Always show the sign column to avoid the screen skip left and right.
vim.opt.signcolumn = 'yes'

vim.opt.smartindent = true

-- Keep undo history after closing the buffer.
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Time of idling (in ms) until swap file is written and CursorHold event is
-- triggered.
vim.opt.updatetime = 500

-- Wrapping of long lines.
vim.opt.wrap = true

-- This is good supposedly.
vim.g.markdown_recommended_style = 0

-- Always show some lines around the cursor.
vim.opt.scrolloff = 1

-- When switching buffers, prioritise:
-- 1. An open window containing the target buffer.
-- 2. An open tab containing the target buffer.
vim.opt.switchbuf = {'useopen'; 'usetab'}

-- Display the current buffer in the terminal emulator window title.
-- vim.opt.title = true

--
-- Keymaps
--

-- Copy full path of file open in current buffer to the the clipboard
-- (unnamedplus).
vim.cmd([[nmap <leader>cp :let @+ = expand("%:p")<cr>]])

-- Make <Ctrl-e> and <Ctrl-Y> work the same in insert mode as in normal mode.
vim.keymap.set('i', '<C-e>', '<C-x><C-e>')
vim.keymap.set('i', '<C-y>', '<C-x><C-y>')

-- Open Lazy menu.
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>')

-- Clear the quickfix list.
vim.keymap.set('n', '<leader>zz', [[<cmd>call setqflist([])<cr>]])

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

-- When jumping to a tag, open it in a new tab.
-- Use together with `:set switchbuf=useopen,usetab`
vim.keymap.set('n', '<leader><C-]>', '<C-w><C-]><C-w>T')

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

-- Close some window types with <esc>.
-- https://www.lazyvim.org/configuration/general#auto-commands
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('close_with_esc'),
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
        vim.keymap.set('n', '<esc>', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})
