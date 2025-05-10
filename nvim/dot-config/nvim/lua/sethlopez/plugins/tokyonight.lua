-- https://github.com/folke/tokyonight.nvim
return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            dim_inactive = true,
        })
        vim.cmd.colorscheme("tokyonight-night")
    end,
}
