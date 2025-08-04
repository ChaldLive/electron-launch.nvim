vim.api.nvim_create_user_command("ElectronNew", function(opts)
	local args = opts.args
	local name = args:gsub("%s+--git", ""):gsub('"', ""):gsub("'", "")
	local enable_git = args:match("--git") ~= nil

	if name == "" then
		print("[ElectronNew] Error: Project name is required")
		return
	end

	local path = require("electron.utils").project_path(name)

	if vim.fn.isdirectory(path) == 1 then
		print("[ElectronNew] Error: Folder already exists at " .. path)
		return
	end

	print("[ElectronNew] Creating project: " .. name .. " at " .. path)
	require("electron.scaffold").create_project(path)

	if enable_git then
		local result = vim.fn.system({ "git", "init", path })
		if vim.v.shell_error == 0 then
			print("[ElectronNew] Git repo initialized")
		else
			print("[ElectronNew] Git init failed: " .. result)
		end
	else
		print("[ElectronNew] (Tip: Add --git to initialize a repo)")
	end
end, { nargs = "+" })
