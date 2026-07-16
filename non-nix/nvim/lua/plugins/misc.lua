return {
	{
		"folke/zen-mode.nvim",
		opts = {},
		cmd = "ZenMode",
		keys = {
			{ "<leader>zm", "<cmd>ZenMode<cr>", desc = "Toggle zen mode" },
		},
	},
	{
		"folke/twilight.nvim",
		opts = {},
	},
	{
		"nvim-mini/mini.bufremove",
		version = false,
	},
	{
		"3rd/image.nvim",
		build = false,
		opts = {
			processor = "magick_cli",
		},
	},
	{
		"benlubas/molten-nvim",
		config = function()
			vim.g.molten_auto_open_output = false
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_wrap_output = true
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = true
		end
	}
}
