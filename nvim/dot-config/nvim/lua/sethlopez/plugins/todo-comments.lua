-- https://github.com/folke/todo-comments.nvim
return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
        {
            "[t",
            function()
                require("todo-comments").jump_prev()
            end,
            desc = "[[] Previous [T]odo Comment",
        },
        {
            "]t",
            function()
                require("todo-comments").jump_next()
            end,
            desc = "[]] Next [T]odo Comment",
        },
        {
            "<leader>st",
            function()
                Snacks.picker.todo_comments()
            end,
            desc = "[S]earch [T]odo",
        },
    },
}
