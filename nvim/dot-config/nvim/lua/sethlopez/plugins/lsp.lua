-- This configuration is largely taken from kickstart.nvim.
-- https://github.com/nvim-lua/kickstart.nvim
return {
    -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    dependencies = {
        -- https://github.com/mason-org/mason.nvim
        { "williamboman/mason.nvim", opts = {} },
        -- https://github.com/williamboman/mason-lspconfig.nvim
        "williamboman/mason-lspconfig.nvim",
        -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        -- https://github.com/j-hui/fidget.nvim
        { "j-hui/fidget.nvim", opts = {} },
        -- https://github.com/Saghen/blink.cmp
        "saghen/blink.cmp",
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("sethlopez-lsp-attach", { clear = true }),
            callback = function(event)
                -- Set up keymappings.
                local map = function(mode, keys, func, desc)
                    local opts = { desc = desc, buffer = event.buf }
                    vim.keymap.set(mode, keys, func, opts)
                end

                map("n", "<leader>lr", vim.lsp.buf.rename, "[L]SP [R]ename")
                map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "[L]SP [A]ction")
                map("n", "<leader>lgd", function()
                    require("snacks").picker.lsp_definitions({ layout = { preset = "sethlopez-default" } })
                end, "[L]SP [G]oto [D]efinition")
                map("n", "<leader>lgD", function()
                    require("snacks").picker.lsp_declarations({ layout = { preset = "sethlopez-default" } })
                end, "[L]SP [G]oto [D]eclaration")
                map("n", "<leader>lgr", function()
                    require("snacks").picker.lsp_references({ layout = { preset = "sethlopez-default" } })
                end, "[L]SP [G]oto [R]eference")
                map("n", "<leader>lgi", function()
                    require("snacks").picker.lsp_implementations({ layout = { preset = "sethlopez-default" } })
                end, "[L]SP [G]oto [I]mplementation")
                map("n", "<leader>lgy", function()
                    require("snacks").picker.lsp_type_definitions({ layout = { preset = "sethlopez-default" } })
                end, "[L]SP [G]oto T[y]pe Definition")
                map("n", "<leader>ss", function()
                    require("snacks").picker.lsp_symbols({ layout = { preset = "sethlopez-default" } })
                end, "[S]earch [S]ymbols")
                map("n", "<leader>sS", function()
                    require("snacks").picker.lsp_workspace_symbols({ layout = { preset = "sethlopez-default" } })
                end, "[S]earch Workspace [S]ymbols")

                require("which-key").add({
                    { "<leader>l", group = "[L]SP" },
                    { "<leader>lg", group = "[L]SP [G]oto" },
                    { "<leader>lt", group = "[L]SP [T]oggle" },
                })

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                -- Set up highlighting on cursor dwell.
                local isHighlightSupported = client
                    and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
                if isHighlightSupported then
                    local highlight_augroup = vim.api.nvim_create_augroup("sethlopez-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("sethlopez-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "sethlopez-lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end

                -- Set up inlay hints.
                local isInlayHintsSupported = client
                    and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                if isInlayHintsSupported then
                    map("n", "<leader>lth", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[L]SP [T]oggle Inlay [H]ints")
                end
            end,
        })

        -- Set up diagnostics UI.
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = "E ",
                    [vim.diagnostic.severity.WARN] = "W ",
                    [vim.diagnostic.severity.INFO] = "I ",
                    [vim.diagnostic.severity.HINT] = "H ",
                },
            } or {},
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        })

        -- Set up mason to install language servers.
        local servers = {
            harper_ls = {
                filetypes = { "markdown" },
            },
            just = {},
            lua_ls = {},
            marksman = {},
            rust_analyzer = {},
            zls = {},
        }
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "shfmt",
            "stylua",
        })

        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        -- Get
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        require("mason-lspconfig").setup({
            ensure_installed = {},
            automatic_installation = false,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for ts_ls)
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}
