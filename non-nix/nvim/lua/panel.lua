local modes = {
	["n"] = "NORMAL",
	["no"] = "NORMAL",
	["v"] = "VISUAL",
	["V"] = "VISUAL LINE",
	[""] = "VISUAL BLOCK",
	["s"] = "SELECT",
	["S"] = "SELECT LINE",
	[""] = "SELECT BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "VISUAL REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colors()
	local current_mode = vim.api.nvim_get_mode().mode
	local mode_color = "%#Cursor#"
	if current_mode == "n" then
		mode_color = "%#Cursor#"
	elseif current_mode == "i" or current_mode == "ic" then
		mode_color = "%#DiffAdd#"
	elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
		mode_color = "%#StatuslineVisualAccent#"
	elseif current_mode == "R" then
		mode_color = "%#StatuslineReplaceAccent#"
	elseif current_mode == "c" then
		mode_color = "%#StatuslineCmdLineAccent#"
	elseif current_mode == "t" then
		mode_color = "%#StatuslineTerminalAccent#"
	end
	return mode_color
end

local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
	if fpath == "" or fpath == "." then
		return " "
	end

	return string.format(" %%<%s/", fpath)
end

local function filename()
	local fname = vim.fn.expand("%:t")
	if fname == "" then
		return ""
	end

	return fname .. " "
end

local function lsp()
	local count = {}
	local levels = {
		errors = "Error",
		warnings = "Warn",
		info = "Info",
		hints = "Hint",
	}

	for k, level in pairs(levels) do
		count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
	end

	local errors = ""
	local warnings = ""
	local hints = ""
	local info = ""

	if count["errors"] ~= 0 then
		errors = " %#LspDiagnosticsSignError# " .. count["errors"]
	end
	if count["warnings"] ~= 0 then
		warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
	end
	if count["hints"] ~= 0 then
		hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
	end
	if count["info"] ~= 0 then
		info = " %#LspDiagnosticsSignInformation# " .. count["info"]
	end

	return errors .. warnings .. hints .. info .. "%#Normal#"
end

local function filetype()
	return string.format(" %s ", vim.bo.filetype):upper()
end

local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	return " %P %l:%c "
end

Statusline = {}

_G.Statusline = Statusline

Statusline.active = function()
	return table.concat({
		"%#DiffAdd#", -- Use a neutral separator highlight group
		mode(),
		"%#StatusLineNC#", -- Use a neutral separator highlight group
		"%#Normal#",
		filepath(),
		filename(),
		lsp(),
		"%=",
		"%#StatusLineExtra#",
		filetype(),
		lineinfo(),
	})
end

function Statusline.inactive()
	return " %F"
end

function Statusline.short()
	return "%#StatusLineNC#   NvimTree"
end

-- vim.api.nvim_exec(
-- 	[[
--   augroup Statusline
--   au!
--   " Only apply to normal buffers (ignores Telescope, NvimTree, terminals, etc.)
--   au WinEnter,BufEnter * if &buftype == '' && &filetype != 'NvimTree' | setlocal statusline=%!v:lua.Statusline.active() | endif
--
--   " Optional: Special statusline for NvimTree
--   au WinEnter,BufEnter * if &filetype == 'NvimTree' | setlocal statusline=%!v:lua.Statusline.short() | endif
--
--   au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
--   augroup END
-- ]],
-- 	false
-- )

vim.go.statusline =
	"%{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.Statusline.active() : v:lua.Statusline.inactive()%}"
