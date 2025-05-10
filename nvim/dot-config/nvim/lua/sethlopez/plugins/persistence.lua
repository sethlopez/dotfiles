-- https://github.com/folke/persistence.nvim
return {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
        branch = false,
    },
}
