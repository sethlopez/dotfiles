-- Enable saving undo history.
vim.opt.undofile = true

-- Decrease swap file update time.
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time.
vim.opt.timeoutlen = 300

-- Enable the mouse.
vim.opt.mouse = "a"

-- Disable showing the mode.
vim.opt.showmode = false

-- Enable new splits to open right or below.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enable hybrid line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable break indent.
vim.opt.breakindent = true

-- Enable smart-case searching.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable the signcolumn.
vim.opt.signcolumn = "yes"

-- Enable display of whitespace characters.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", nbsp = "␣", space = "·", extends = "…" }

-- Enable substitution previews.
vim.opt.inccommand = "split"

-- Enable highlighting the cursor line.
vim.opt.cursorline = true

-- Set the number of lines to display above/below the cursor line.
vim.opt.scrolloff = 10

-- Enable confirmation dialog when performing an operation that could fail due
-- to unsaved changes.
vim.opt.confirm = true

-- Highlight yanks.
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("sethlopez-highlight-yanks", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
