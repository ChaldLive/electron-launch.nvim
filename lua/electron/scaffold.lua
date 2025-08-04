-- lua/electron/scaffold.lua
local utils = require("electron.utils")

local M = {}

-- Run a shell command inside a specific directory
local function run_in_dir(cmd, dir)
  local full_cmd = "cd " .. dir .. " && " .. cmd
  return vim.fn.system(full_cmd)
end

-- Create a new Electron project at the given path
function M.create_project(path)
  vim.fn.mkdir(path, "p")

  -- Run npm init and install electron inside the project folder
  run_in_dir("npm init -y", path)
  run_in_dir("npm install --save-dev electron", path)

  -- Scaffold files
  utils.add_start_script(path)
  utils.write_main_js(path)
  utils.write_gitignore(path)

  -- Open main.js in editor
  vim.cmd("edit " .. path .. "/main.js")
end

-- Define :ElectronNew command
vim.api.nvim_create_user_command("ElectronNew", function(opts)
  local args = opts.args
  local name = args:gsub("%s+--git", ""):gsub('"', ""):gsub("'", "")
  local enable_git = args:match("--git") ~= nil

  if name == "" then
    print("[ElectronNew] Error: Project name is required")
    return
  end

  local path = utils.project_path(name)

  if vim.fn.isdirectory(path) == 1 then
    print("[ElectronNew] Error: Folder already exists at " .. path)
    return
  end

  print("[ElectronNew] Creating project: " .. name .. " at " .. path)
  M.create_project(path)

  if enable_git then
    local result = run_in_dir("git init", path)
    if vim.v.shell_error == 0 then
      print("[ElectronNew] Git repo initialized")
    else
      print("[ElectronNew] Git init failed: " .. result)
    end
  else
    print("[ElectronNew] (Tip: Add --git to initialize a repo)")
  end
end, { nargs = "+" })

return M
