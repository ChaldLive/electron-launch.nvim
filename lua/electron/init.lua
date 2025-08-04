-- lua/electron/init.lua
local M = {}

function M.setup()
	--  require("electron.commands").setup()
	print("elelctron-launch.nvim loaded suc successfully")
	require("electron.commands")
end

return M
