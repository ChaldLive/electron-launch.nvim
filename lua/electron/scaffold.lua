-- lua/electron/scaffold.lua
local utils = require("electron.utils")

local M = {}

function M.create_project(name)
  local root = utils.project_path(name)
  vim.fn.mkdir(root, "p")
  vim.cmd("cd " .. root)

  vim.fn.system("npm init -y")
  vim.fn.system("npm install --save-dev electron")

  utils.add_start_script(root .. "/package.json")
  utils.write_main_js(root .. "/main.js")

  vim.cmd("edit " .. root .. "/main.js")
end

return M
