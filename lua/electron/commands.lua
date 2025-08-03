-- lua/electron/commands.lua
local scaffold = require("electron.scaffold")

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("ElectronNew", function(opts)
    scaffold.create_project(opts.args)
  end, { nargs = 1 })
end

return M
