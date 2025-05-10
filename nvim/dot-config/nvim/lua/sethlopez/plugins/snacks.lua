-- https://github.com/folke/snacks.nvim
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    {
                        desc = "Restore Session",
                        icon = " ",
                        key = "s",
                        section = "session",
                    },
                    {
                        action = ":ene | startinsert",
                        desc = "New File",
                        icon = " ",
                        key = "n",
                    },
                    {
                        action = function()
                            require("snacks").picker.smart({ layout = { preset = "sethlopez-default" } })
                        end,
                        desc = "Find File",
                        icon = " ",
                        key = "f",
                    },
                    {
                        action = function()
                            require("snacks").picker.files({
                                layout = { preset = "sethlopez-default" },
                                cwd = vim.fn.stdpath("config"),
                            })
                        end,
                        desc = "Config Files",
                        icon = " ",
                        key = "c",
                    },
                    {
                        action = ":Lazy",
                        desc = "Lazy",
                        enabled = package.loaded.lazy ~= nil,
                        icon = "󰒲 ",
                        key = "l",
                    },
                    {
                        action = ":checkhealth",
                        desc = "Health",
                        icon = "󰛯 ",
                        key = "h",
                    },
                    {
                        action = ":qa",
                        desc = "Quit",
                        icon = " ",
                        key = "q",
                    },
                },
            },
            sections = {
                {
                    padding = 1,
                    section = "header",
                },
                {
                    padding = 1,
                    section = "startup",
                },
                {
                    icon = "󰥻",
                    -- indent = 2,
                    padding = 1,
                    section = "keys",
                    title = "Shortcuts",
                },
                {
                    icon = "󰝰",
                    -- indent = 2,
                    padding = 1,
                    section = "projects",
                    title = "Projects",
                },
                {
                    icon = "",
                    -- indent = 2,
                    section = "recent_files",
                    title = "Recent Files",
                },
            },
        },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        notifier = { enabled = true },
        picker = {
            enabled = true,
            prompt = "󰍉 ",
            show_empty = true,
            layout = {
                cycle = false,
            },
            layouts = {
                ["sethlopez-default"] = {
                    layout = {
                        backdrop = 60,
                        border = "solid",
                        box = "horizontal",
                        height = 0.8,
                        min_width = 120,
                        width = 0.8,
                        {
                            border = "solid",
                            box = "vertical",
                            title = "{title} {live} {flags}",
                            { win = "input", height = 1, border = { "", "", "", "", "", " ", "", "" } },
                            { win = "list", border = "none" },
                        },
                        { win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
                    },
                },
                ["sethlopez-dropdown"] = {
                    layout = {
                        backdrop = 60,
                        border = "solid",
                        box = "vertical",
                        height = 0.4,
                        min_height = 40,
                        min_width = 60,
                        width = 0.3,
                        { win = "preview", title = "{preview}", height = 0.4, border = "rounded" },
                        {
                            box = "vertical",
                            border = "none",
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                            { win = "input", height = 1, border = { "", "", "", "", "", " ", "", "" } },
                            { win = "list", border = "none" },
                        },
                    },
                },
            },
            win = {
                input = {
                    keys = {
                        ["H"] = { "preview_scroll_left", mode = { "n" } },
                        ["J"] = { "preview_scroll_down", mode = { "n" } },
                        ["K"] = { "preview_scroll_up", mode = { "n" } },
                        ["L"] = { "preview_scroll_right", mode = { "n" } },
                    },
                },
            },
        },
    },
    terminal = { enabled = true },
    keys = {
        {
            "<leader><space>",
            function()
                Snacks.picker.smart({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "Smart Find File",
        },
        {
            "<leader>,",
            function()
                Snacks.picker.buffers({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "Buffers",
        },
        {
            "<leader>/",
            function()
                Snacks.picker.grep({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "Grep",
        },
        {
            "<leader>:",
            function()
                Snacks.picker.command_history({
                    layout = {
                        preset = "sethlopez-dropdown",
                        preview = false,
                    },
                })
            end,
            desc = "Command History",
        },
        {
            "<leader>e",
            function()
                Snacks.picker.explorer()
            end,
            desc = "[E]xplorer",
        },
        -- Terminal
        {
            "<leader>t",
            function()
                Snacks.terminal.toggle("zsh")
            end,
            desc = "Open Floating [T]erminal",
        },
        -- Find
        {
            "<leader>fc",
            function()
                Snacks.picker.files({
                    layout = {
                        preset = "sethlopez-default",
                    },
                    cwd = vim.fn.stdpath("config"),
                })
            end,
            desc = "[F]ind [C]onfig File",
        },
        {
            "<leader>ff",
            function()
                Snacks.picker.files({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[F]ind [F]ile",
        },
        {
            "<leader>fp",
            function()
                Snacks.picker.projects({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[F]ind [P]roject",
        },
        {
            "<leader>fr",
            function()
                Snacks.picker.recent({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[F]ind [R]ecent File",
        },
        -- Search
        {
            '<leader>s"',
            function()
                Snacks.picker.registers({ layout = { preset = "sethlopez-default" } })
            end,
            desc = '[S]earch ["] Registers',
        },
        {
            "<leader>sb",
            function()
                Snacks.picker.lines()
            end,
            desc = "[S]earch [B]uffer",
        },
        {
            "<leader>sc",
            function()
                Snacks.picker.commands({
                    layout = {
                        preset = "sethlopez-dropdown",
                        preview = false,
                    },
                })
            end,
            desc = "[S]earch [C]ommands",
        },
        {
            "<leader>sd",
            function()
                Snacks.picker.diagnostics({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch All [D]iagnostics",
        },
        {
            "<leader>sD",
            function()
                Snacks.picker.diagnostics_buffer({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch Buffer [D]iagnostics",
        },
        {
            "<leader>sh",
            function()
                Snacks.picker.help({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch [H]elp",
        },
        {
            "<leader>sH",
            function()
                Snacks.picker.highlights({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch [H]ighlights",
        },
        {
            "<leader>sg",
            function()
                Snacks.picker.icons({
                    layout = {
                        preset = "sethlopez-dropdown",
                        preview = false,
                    },
                })
            end,
            desc = "[S]earch [G]lyphs",
        },
        {
            "<leader>sj",
            function()
                Snacks.picker.jumps({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch [J]umps",
        },
        {
            "<leader>sk",
            function()
                Snacks.picker.keymaps({
                    layout = {
                        preset = "sethlopez-dropdown",
                        preview = false,
                    },
                })
            end,
            desc = "[S]earch [K]eymaps",
        },
        {
            "<leader>sl",
            function()
                Snacks.picker.loclist({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch [L]ocation List",
        },
        {
            "<leader>sm",
            function()
                Snacks.picker.marks({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch [M]arks",
        },
        {
            "<leader>sM",
            function()
                Snacks.picker.man({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch [M]an Pages",
        },
        {
            "<leader>sq",
            function()
                Snacks.picker.qflist({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch [Q]iuckfix List",
        },
        {
            "<leader>sr",
            function()
                Snacks.picker.resume()
            end,
            desc = "[S]earch [R]esume",
        },
        {
            "<leader>su",
            function()
                Snacks.picker.undo({ layout = { preset = "sethlopez-default" } })
            end,
            desc = "[S]earch [U]ndo History",
        },
        -- LSP
        -- {
        --     "gd",
        --     function()
        --         Snacks.picker.lsp_definitions({ layout = { preset = "sethlopez-default" } })
        --     end,
        --     desc = "[G]oto [D]efinition",
        -- },
        -- {
        --     "gD",
        --     function()
        --         Snacks.picker.lsp_declarations({ layout = { preset = "sethlopez-default" } })
        --     end,
        --     desc = "[G]oto [D]eclaration",
        -- },
        -- {
        --     "gr",
        --     function()
        --         Snacks.picker.lsp_references({ layout = { preset = "sethlopez-default" } })
        --     end,
        --     nowait = true,
        --     desc = "[G]oto [R]eference",
        -- },
        -- {
        --     "gI",
        --     function()
        --         Snacks.picker.lsp_implementations({ layout = { preset = "sethlopez-default" } })
        --     end,
        --     desc = "[G]oto [I]mplementation",
        -- },
        -- {
        --     "gy",
        --     function()
        --         Snacks.picker.lsp_type_definitions({ layout = { preset = "sethlopez-default" } })
        --     end,
        --     desc = "[G]oto T[y]pe Definition",
        -- },
        -- {
        --     "<leader>ss",
        --     function()
        --         Snacks.picker.lsp_symbols({ layout = { preset = "sethlopez-default" } })
        --     end,
        --     desc = "[S]earch [S]ymbols",
        -- },
        -- {
        --     "<leader>sS",
        --     function()
        --         Snacks.picker.lsp_workspace_symbols({ layout = { preset = "sethlopez-default" } })
        --     end,
        --     desc = "[S]earch Workspace [S]ymbols",
        -- },
    },
}
