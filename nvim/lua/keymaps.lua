vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move left" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move up" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move right" })

-- clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- window splits
vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })

-- diagnostic error
vim.keymap.set("n", "<leader>q", vim.diagnostic.open_float, { desc = "Current error" })

--setup yank highlighting
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})
