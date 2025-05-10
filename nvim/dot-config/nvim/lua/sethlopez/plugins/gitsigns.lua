return {
    "lewis6991/gitsigns.nvim",
    opts = {},
    keys = {
        {
            "<leader>B",
            function()
                require("gitsigns").toggle_current_line_blame()
            end,
            desc = "[T]oggle Current Line [B]lame",
            buffer = true,
        },
    },
}
