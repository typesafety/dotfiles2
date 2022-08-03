-- Stuff to be run once when setting up a new environment.
--
-- nvim --headless -u NONE -c 'lua require("bootstrap").run_bootstrap()'

--
-- Paq stuff
-- https://github.com/savq/paq-nvim
--

-- List of packages for Paq to install.
local PAQ_PACKAGES = {
    -- Paq should install and manage itself
    'savq/paq-nvim';

    -- It's possible to not add any other packages here; the important thing is
    -- that Paq installs itself so that it can manage other packages/plugins
    -- normally.
}

-- Clone Paq so that it can be installed.
local function clone_paq()
    local clone_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
    -- Check if we've already cloned the repo.
    if vim.fn.empty(vim.fn.glob(clone_path)) > 0 then
        -- If not, run git clone.
        vim.fn.system {
            'git',
            'clone',
            '--depth=1',
            'https://github.com/savq/paq-nvim.git',
            clone_path
        }
    else
        print('Stuff already exists, is this already cloned?')
    end
end

-- Bootstrap Paq (install itself and packages).
-- Taken from https://github.com/savq/paq-nvim/blob/master/doc/paq-nvim.txt
local function bootstrap_paq()
    clone_paq()

    -- Load Paq
    vim.cmd('packadd paq-nvim')
    local paq = require('paq')

    -- Exit nvim after installing plugins
    vim.cmd('autocmd User PaqDoneInstall quit')

    -- Read and install packages
    paq(PAQ_PACKAGES)
    paq.install()
end

--
-- Entry point
--

local function run_bootstrap()
    bootstrap_paq()  -- Bootstrap the package manager
end

return { run_bootstrap = run_bootstrap }
