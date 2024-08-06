-- Settings for tokyonight.nvim
-- https://github.com/folke/tokyonight.nvim

require("tokyonight").setup({
    style = "moon",
    light_style = "day",
    transparent = true,
    terminal_colors = true,
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},

        sidebars = "moon",
        floats = "moon",
    },

    sidebars = {
        "qf",
        "help",
        "Lazy",
        "terminal",
    },
})
