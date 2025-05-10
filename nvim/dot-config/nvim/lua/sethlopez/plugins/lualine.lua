return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local colors = require("tokyonight.colors").setup({ style = "night" })

        require("lualine").setup({
            options = {
                component_separators = "",
                disabled_filetypes = {
                    statusline = {
                        "snacks_dashboard",
                    },
                },
                icons_enabled = vim.g.have_nerd_font,
                -- ignore_focus = { "help" },
                section_separators = "",
                refresh = {
                    statusline = 50,
                },
                theme = "tokyonight",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        "location",
                        fmt = function(str)
                            return str:gsub("%s+", "")
                        end,
                    },
                    "progress",
                    "selectioncount",
                    "searchcount",
                },
                lualine_c = {
                    {
                        "filename",
                        padding = 1,
                        path = 1,
                    },
                    "filetype",
                    "filesize",
                },
                lualine_x = {
                    "lsp_status",
                    "encoding",
                    {
                        "fileformat",
                        symbols = {
                            unix = "LF",
                            dos = "CRLF",
                            mac = "CR",
                        },
                    },
                },
                lualine_y = {
                    {
                        "diagnostics",
                        diagnostics_color = {
                            hint = { bg = colors.green, fg = colors.black },
                            info = { bg = colors.blue, fg = colors.black },
                            warn = { bg = colors.orange, fg = colors.black },
                            error = { bg = colors.red, fg = colors.black },
                        },
                        sections = { "hint", "info", "warn", "error" },
                        symbols = {
                            hint = "",
                            info = "",
                            warn = "",
                            error = "",
                        },
                    },
                },
                lualine_z = {
                    {
                        "branch",
                        icons_enabled = false,
                    },
                },
            },
            inactive_sections = {
                lualine_c = {
                    {
                        "location",
                        fmt = function(str)
                            return str:gsub("%s+", "")
                        end,
                    },
                    "progress",
                    "filename",
                },
                lualine_x = {},
            },
        })
    end,
}
