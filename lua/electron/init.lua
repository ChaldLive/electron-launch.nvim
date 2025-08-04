-- lua/electron/init.lua
local M = {}

function M.setup()
	print("electron-launcher.nvim loaded successfully")

	-- Load commands (if you have any defined)
	require("electron.commands")

	-- Detect project root
	local utils = require("electron.utils")
	local root = utils.find_project_root()

	if root then
		print("✅ Electron project root found at: " .. root)
	else
		print("❌ No Electron project root found.")
	end
end

return M
