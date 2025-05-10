-- https://github.com/stevearc/conform.nvim
return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>F",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = true,
        notify_no_formatters = true,
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            go = { "gofmt" },
            lua = { "stylua" },
            sh = { "shfmt" },
        },
        formatters = {
            shfmt = {
                prepend_args = { "-i", "2" },
            },
        },
    },
}
