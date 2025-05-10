-- https://github.com/echasnovski/mini.nvim
return {
    "echasnovski/mini.nvim",
    config = function()
        -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
        require("mini.ai").setup({ n_lines = 500 })

        -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md
        require("mini.pairs").setup({
            mappings = {
                -- insert space pairs inside curly braces: {  }
                [" "] = { action = "closeopen", pair = "  ", neigh_pattern = "{}" },
            },
        })

        -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-splitjoin.md
        require("mini.splitjoin").setup()

        -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
        require("mini.surround").setup()
    end,
}
