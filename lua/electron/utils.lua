-- lua/electron/utils.lua
local M = {}

function M.project_path(name)
  return vim.fn.expand("~/Projects/" .. name)
end

function M.write_main_js(path)
  local lines = {
    "const { app, BrowserWindow } = require('electron');",
    "",
    "app.whenReady().then(() => {",
    "  const win = new BrowserWindow({ width: 800, height: 600 });",
    "  win.loadURL('https://example.com');",
    "});",
  }
  vim.fn.writefile(lines, path)
end

function M.add_start_script(pkg_path)
  local pkg = vim.fn.readfile(pkg_path)
  for i, line in ipairs(pkg) do
    if line:match('"scripts"%s*:%s*{') then
      table.insert(pkg, i + 1, '    "start": "electron .",')
      break
    end
  end
  vim.fn.writefile(pkg, pkg_path)
end

return M
