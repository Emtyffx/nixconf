return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
		config = function()
			vim.g.rustaceanvim = {
				server = {
					default_settings = {
						["rust-analyzer"] = {
							checkOnSave = false,
							diagnostics = {
								enable = true,
								experimental = {
									enable = true,
								},
							},
							cargo = {
								buildScripts = {
									enable = true,
								},
								features = "all",
							},
							procMacro = {
								enable = true,
							},
							inlayHints = {
								bindingModeHints = {
									enable = false,
								},
								chainingHints = {
									enable = true,
								},
								closingBraceHints = {
									enable = true,
								},
								parameterHints = {
									enable = true,
								},
								typeHints = {
									enable = true,
								},
							},
							-- completion = {
							-- 	autoimport = { enable = true },
							-- },
						},
					},
				},
			}
		end,
	},
}
