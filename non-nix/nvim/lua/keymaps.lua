vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- window navigation
vim.keymap.set("n", "gh", "<C-w><C-h>", { desc = "Move left" })
vim.keymap.set("n", "gj", "<C-w><C-j>", { desc = "Move down" })
vim.keymap.set("n", "gk", "<C-w><C-k>", { desc = "Move up" })
vim.keymap.set("n", "gl", "<C-w><C-l>", { desc = "Move right" })

-- clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- window splits
vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })

-- diagnostic error
vim.keymap.set("n", "<leader>q", vim.diagnostic.open_float, { desc = "Current error" })

-- remap for pasting from clipboard
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

--format
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-c>", "<Esc>")

vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")

vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")

--setup yank highlighting
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})


vim.keymap.set(
	"n",
	"<leader>ie",
	"oif err != nil {<CR>}<Esc>Oreturn err<Esc>",
	{ desc = "IfErr(return err)" })

vim.keymap.set(
	"n",
	"<leader>ia",
	"oassert.NoError(err, \"\")<Esc>F\";a",
	{ desc = "IfErr(assert)" }
)

vim.keymap.set(
	"n",
	"<leader>if",
	"oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj",
	{ desc = "IfErr(log fatal)" }
)

vim.keymap.set(
	"n",
	"<leader>il",
	"oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i",
	{ desc = "IFErr(logger Error)" }
)
