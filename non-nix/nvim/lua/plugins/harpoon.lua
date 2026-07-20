return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, {
				desc = "[A]dd to harpoon",
			})

			for i = 1, 9 do
				local captured = i
				vim.keymap.set("n", "<leader>" .. captured, function()
					harpoon:list():select(captured)
				end, {
					desc = "Move to [" .. captured .. "]",
				})
			end
		end,
	},
}
