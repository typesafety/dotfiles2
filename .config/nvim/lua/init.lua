-- Attempt at a Lua init file (to be sourced when nvim is launched).

--
-- Load packages/plugins.
-- Uses Paq: https://github.com/savq/paq-nvim
-- See bootstrap.lua for the automated setup.
--

-- List of packages to install and manage.
require 'paq' {
    -- Paq should manage itself
    'savq/paq-nvim';

    'tpope/vim-commentary';  -- `gc` to comment/uncomment; useful as fuck.
    'tpope/vim-surround';

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
}

--
-- Add more stuff
--

