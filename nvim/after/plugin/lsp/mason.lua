local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

local mason_tool_installer_status, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_status then
	return
end

-- Enable mason and configure icons
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Configure mason-lspconfig
mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = {
		"ts_ls",
		"html",
		"cssls",
		"tailwindcss",
		"lua_ls",
		"graphql",
		"emmet_ls",
		"pyright",
		"omnisharp",
	},
})

-- Configure mason-tool-installer
mason_tool_installer.setup({
	ensure_installed = {
		"prettier", -- prettier formatter
		"stylua", -- lua formatter
		"isort", -- python formatter
		"black", -- python formatter
		"pylint", -- python linter
		"eslint_d", -- js/ts linter
	},
})
