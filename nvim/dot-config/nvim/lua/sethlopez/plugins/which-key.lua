-- https://github.com/folke/which-key.nvim
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "classic",
        spec = {
            { "<leader>f", group = "[F]ind", icon = "󰍉" },
            { "<leader>s", group = "[S]earch", icon = "󰍉" },
        },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer local keymaps (which-key)",
        },
    },
}
