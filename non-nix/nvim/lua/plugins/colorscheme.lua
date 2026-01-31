return {
	-- {
	-- 	"AlexvZyl/nordic.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("nordic").setup({
	-- 			transparent = {
	-- 				bg = true,
	-- 			},
	-- 		})
	-- 		require("nordic").load()
	-- 	end,
	-- },
	-- {
	-- 	"morhetz/gruvbox",
	-- 	config = function()
	-- 		vim.cmd.colorscheme("gruvbox")
	-- 	end,
	-- },
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			transparent_mode = true,
		},
		config = function(_, opts)
			require("gruvbox").setup(opts)

			vim.cmd.colorscheme("gruvbox")
		end,
	},
}
