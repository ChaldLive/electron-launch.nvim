-- lua/electron/utils.lua
local M = {}
--Resolve index.js and make it main.js because that is what we generate anyway
function M.set_main_entry(pkg_path, entry)
	local pkg = vim.fn.readfile(pkg_path)
	for i, line in ipairs(pkg) do
		if line:match('"main"%s*:') then
			pkg[i] = '  "main": "' .. entry .. '",'
			break
		end
	end
	vim.fn.writefile(pkg, pkg_path)
	print('[Electron] package.json "main" entry set to ' .. entry)
end

-- Resolve project path based on name
function M.project_path(name)
	-- If name is an absolute path, use it directly
	if name:match("^/") or name:match("^~") then
		return vim.fn.expand(name)
	end

	-- Otherwise, create inside current working directory
	local cwd = vim.fn.getcwd()
	return cwd .. "/" .. name
end

-- Write main.js inside the given project folder
function M.write_main_js(project_path)
	local lines = {
		"const { app, BrowserWindow } = require('electron');",
		"",
		"app.whenReady().then(() => {",
		"  const win = new BrowserWindow({ width: 800, height: 600 });",
		"  win.loadURL('https://example.com');",
		"});",
	}
	local file_path = project_path .. "/main.js"
	vim.fn.writefile(lines, file_path)
	print("[Electron] main.js created at " .. file_path)
end

-- Add "start" script to package.json inside the project folder
function M.add_start_script(project_path)
	local pkg_path = project_path .. "/package.json"
	if vim.fn.filereadable(pkg_path) == 0 then
		print("[Electron] package.json not found at " .. pkg_path)
		return
	end

	local pkg = vim.fn.readfile(pkg_path)
	local has_start = false

	for _, line in ipairs(pkg) do
		if line:match('"start"%s*:') then
			has_start = true
			break
		end
	end

	if not has_start then
		for i, line in ipairs(pkg) do
			if line:match('"scripts"%s*:%s*{') then
				table.insert(pkg, i + 1, '    "start": "electron .",')
				print('[Electron] "start" script added to package.json')
				break
			end
		end
		vim.fn.writefile(pkg, pkg_path)
	else
		print('[Electron] "start" script already exists in package.json')
	end
end

function M.write_gitignore(project_path)
	local lines = {
		"# Electron project .gitignore",
		"",
		"# OS-specific",
		".DS_Store",
		"Thumbs.db",
		"",
		"# Node.js",
		"node_modules/",
		"npm-debug.log*",
		"yarn-debug.log*",
		"yarn-error.log*",
		"package-lock.json",
		"",
		"# Electron build output",
		"dist/",
		"build/",
		"*.asar",
		"",
		"# IDEs and editors",
		".vscode/",
		".idea/",
		"*.sublime-workspace",
		"*.sublime-project",
		"",
		"# Environment files",
		".env",
		".env.local",
		".env.production",
		".env.development",
		"",
		"# TypeScript / Babel / Webpack",
		"*.tsbuildinfo",
		"*.cache",
		"*.webpack-cache",
		"*.eslintcache",
		"",
		"# Misc",
		"*.log",
		"*.tgz",
		"*.swp",
		"",
		"# Electron-specific",
		"electron-api.json",
		"electron.d.ts",
		"ts-gen/",
		"spec/.hash",
		"spec/fixtures/native-addon/echo/build/",
	}

	local file_path = project_path .. "/.gitignore"
	vim.fn.writefile(lines, file_path)
	print("[Electron] .gitignore created at " .. file_path)
end

-- 🔍 Find the nearest directory with package.json
function M.find_project_root(start_path)
	local uv = vim.loop
	local function is_root(path)
		local package_json = path .. "/package.json"
		local stat = uv.fs_stat(package_json)
		return stat and stat.type == "file"
	end

	local function dirname(path)
		return path:match("^(.*)/[^/]*$")
	end

	local path = start_path or vim.fn.expand("%:p:h")
	while path and path ~= "" do
		if is_root(path) then
			return path
		end
		local parent = dirname(path)
		if parent == path then
			break
		end
		path = parent
	end
	return nil
end

return M
