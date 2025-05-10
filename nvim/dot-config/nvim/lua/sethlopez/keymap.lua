-- Clear hlsearch with <Esc> in normal mode.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Yanking.
vim.keymap.set("n", "Y", '"+y', { desc = "[Y]ank to Clipboard" })
vim.keymap.set("n", "<Leader>y", ":%y<CR>", { desc = "[Y]ank Buffer to Register" })
vim.keymap.set("n", "<Leader>Y", ":%y+<CR>", { desc = "[Y]ank Buffer to Clipboard" })

-- Diagnostics navigation.
vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic [Q]uickfix List" })

-- Terminal.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
