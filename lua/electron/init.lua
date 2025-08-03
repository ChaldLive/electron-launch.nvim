-- lua/electron/init.lua
local M = {}

function M.setup()
  require("electron.commands").setup()
end

return M
