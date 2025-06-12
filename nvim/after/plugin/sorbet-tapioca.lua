-- Sorbet + Tapioca integration for Neovim
-- Simple plugin file that follows the same structure as other after/plugin files

-- Early return if not a Ruby project
if vim.fn.glob("Gemfile") == "" then
	return
end

-- Configuration
local config = {
	panel_width = 50,
	panel_position = "right",
}

-- State tracking
local tapioca_buf = nil
local tapioca_win = nil
local is_running = false

-- Function to check if we're in a Sorbet project
local function is_sorbet_project()
	return vim.fn.glob("sorbet/config") ~= "" or vim.fn.glob("*.rbi") ~= ""
end

-- Function to append text to the panel
local function append_to_panel(text)
	if not tapioca_buf or not vim.api.nvim_buf_is_valid(tapioca_buf) then
		return
	end

	local lines = vim.split(text, "\n")
	local current_lines = vim.api.nvim_buf_get_lines(tapioca_buf, 0, -1, false)

	for _, line in ipairs(lines) do
		table.insert(current_lines, line)
	end

	vim.api.nvim_buf_set_lines(tapioca_buf, 0, -1, false, current_lines)

	-- Scroll to bottom
	if tapioca_win and vim.api.nvim_win_is_valid(tapioca_win) then
		vim.api.nvim_win_set_cursor(tapioca_win, { #current_lines, 0 })
	end
end

-- Function to create or get the tapioca panel
local function create_tapioca_panel()
	-- If panel already exists and is visible, focus it
	if tapioca_win and vim.api.nvim_win_is_valid(tapioca_win) then
		vim.api.nvim_set_current_win(tapioca_win)
		return tapioca_buf, tapioca_win
	end

	-- Create buffer if it doesn't exist
	if not tapioca_buf or not vim.api.nvim_buf_is_valid(tapioca_buf) then
		tapioca_buf = vim.api.nvim_create_buf(false, true)

		-- Set buffer options
		vim.api.nvim_buf_set_option(tapioca_buf, "buftype", "nofile")
		vim.api.nvim_buf_set_option(tapioca_buf, "swapfile", false)
		vim.api.nvim_buf_set_option(tapioca_buf, "filetype", "tapioca")
		vim.api.nvim_buf_set_name(tapioca_buf, "Tapioca Commands")

		-- Set buffer-local keymaps
		local opts = { buffer = tapioca_buf, silent = true }
		vim.keymap.set("n", "q", function()
			close_panel()
		end, opts)
		vim.keymap.set("n", "<Esc>", function()
			close_panel()
		end, opts)
		vim.keymap.set("n", "r", function()
			restart_sorbet()
		end, opts)
		vim.keymap.set("n", "1", function()
			run_tapioca_dsl()
		end, opts)
		vim.keymap.set("n", "2", function()
			run_tapioca_build()
		end, opts)
		vim.keymap.set("n", "3", function()
			run_tapioca_sync()
		end, opts)
		vim.keymap.set("n", "c", function()
			clear_panel()
		end, opts)

		-- Add initial help text
		local help_lines = {
			"╭─ Tapioca Commands Panel ─╮",
			"│                          │",
			"│ Keybinds:                │",
			"│  1 - Run tapioca dsl     │",
			"│  2 - Run tapioca build   │",
			"│  3 - Run tapioca sync    │",
			"│  r - Restart Sorbet LSP  │",
			"│  c - Clear panel         │",
			"│  q - Close panel         │",
			"│                          │",
			"╰──────────────────────────╯",
			"",
			"Ready! Press a number to run a command.",
			"",
		}

		vim.api.nvim_buf_set_lines(tapioca_buf, 0, -1, false, help_lines)
	end

	-- Calculate window size and position
	local width = config.panel_width
	local height = vim.o.lines - 6
	local row = 1
	local col = config.panel_position == "right" and (vim.o.columns - width - 1) or 0

	-- Create window
	tapioca_win = vim.api.nvim_open_win(tapioca_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Tapioca Panel ",
		title_pos = "center",
	})

	-- Set window options
	vim.api.nvim_win_set_option(tapioca_win, "number", false)
	vim.api.nvim_win_set_option(tapioca_win, "relativenumber", false)
	vim.api.nvim_win_set_option(tapioca_win, "wrap", true)
	vim.api.nvim_win_set_option(tapioca_win, "cursorline", false)

	return tapioca_buf, tapioca_win
end

-- Function to close the panel
function close_panel()
	if tapioca_win and vim.api.nvim_win_is_valid(tapioca_win) then
		vim.api.nvim_win_close(tapioca_win, false)
		tapioca_win = nil
	end
end

-- Function to clear the panel
function clear_panel()
	if tapioca_buf and vim.api.nvim_buf_is_valid(tapioca_buf) then
		vim.api.nvim_buf_set_lines(tapioca_buf, 0, -1, false, {})
	end
end

-- Function to run a command in the panel
local function run_command_in_panel(command, description)
	if is_running then
		append_to_panel("⚠ Another command is already running. Please wait...")
		return
	end

	if not is_sorbet_project() then
		append_to_panel("❌ Not a Sorbet project")
		return
	end

	is_running = true

	local timestamp = os.date("%H:%M:%S")
	append_to_panel(string.format("▶ [%s] %s", timestamp, description))
	append_to_panel(
		"─────────────────────────────────────"
	)

	vim.fn.jobstart(command, {
		cwd = vim.fn.getcwd(),
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						append_to_panel(line)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						append_to_panel("🔴 " .. line)
					end
				end
			end
		end,
		on_exit = function(_, exit_code)
			is_running = false
			local timestamp = os.date("%H:%M:%S")

			if exit_code == 0 then
				append_to_panel(string.format("✅ [%s] Command completed successfully!", timestamp))
				-- Restart Sorbet LSP after successful tapioca run
				if description:find("tapioca") then
					vim.defer_fn(function()
						restart_sorbet()
					end, 1000)
				end
			else
				append_to_panel(string.format("❌ [%s] Command failed (exit code: %d)", timestamp, exit_code))
			end
			append_to_panel("")
		end,
		stdout_buffered = false,
		stderr_buffered = false,
	})
end

-- Function to toggle the tapioca panel
function toggle_panel()
	-- If panel is open, close it
	if tapioca_win and vim.api.nvim_win_is_valid(tapioca_win) then
		close_panel()
		return
	end

	-- Create and show panel
	create_tapioca_panel()
end

-- Function to run tapioca dsl
function run_tapioca_dsl()
	create_tapioca_panel()
	run_command_in_panel({ "bash", "-c", "bundle exec tapioca dsl" }, "Running tapioca dsl (DSL rebuild)")
end

-- Function to run full tapioca build
function run_tapioca_build()
	create_tapioca_panel()
	run_command_in_panel(
		{ "bash", "-c", "bundle exec tapioca dsl && bundle exec tapioca gems" },
		"Running tapioca build (DSL + gems)"
	)
end

-- Function to run tapioca sync
function run_tapioca_sync()
	create_tapioca_panel()
	run_command_in_panel({ "bash", "-c", "bundle exec tapioca sync" }, "Running tapioca sync (update gem RBIs)")
end

-- Function to restart Sorbet LSP
function restart_sorbet()
	local clients = vim.lsp.get_clients({ name = "sorbet" })
	if #clients > 0 then
		append_to_panel("🔄 Stopping Sorbet LSP...")

		-- Stop all sorbet clients
		for _, client in ipairs(clients) do
			client.stop()
		end

		-- Wait for clients to fully stop, then restart
		vim.defer_fn(function()
			-- Check if we're in a sorbet project and restart
			if is_sorbet_project() then
				append_to_panel("🔄 Starting Sorbet LSP...")

				-- Get current buffer to restart LSP for
				local bufnr = vim.api.nvim_get_current_buf()
				local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

				if filetype == "ruby" then
					-- Use lspconfig to start sorbet
					require("lspconfig").sorbet.launch()

					vim.defer_fn(function()
						local new_clients = vim.lsp.get_clients({ name = "sorbet" })
						if #new_clients > 0 then
							append_to_panel("✅ Sorbet LSP restarted successfully")
						else
							append_to_panel("❌ Failed to restart Sorbet LSP")
						end
						append_to_panel("")
					end, 2000)
				else
					append_to_panel("⚠ Open a Ruby file to restart Sorbet LSP")
					append_to_panel("")
				end
			else
				append_to_panel("⚠ Not a Sorbet project")
				append_to_panel("")
			end
		end, 2000)
	else
		append_to_panel("⚠ Sorbet LSP is not running")

		-- Try to start it if we're in a sorbet project
		if is_sorbet_project() then
			append_to_panel("🔄 Attempting to start Sorbet LSP...")
			local bufnr = vim.api.nvim_get_current_buf()
			local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

			if filetype == "ruby" then
				require("lspconfig").sorbet.launch()

				vim.defer_fn(function()
					local clients = vim.lsp.get_clients({ name = "sorbet" })
					if #clients > 0 then
						append_to_panel("✅ Sorbet LSP started")
					else
						append_to_panel("❌ Failed to start Sorbet LSP")
					end
					append_to_panel("")
				end, 2000)
			else
				append_to_panel("⚠ Open a Ruby file to start Sorbet LSP")
				append_to_panel("")
			end
		end
	end
end

-- Commands
vim.api.nvim_create_user_command("TapiocaPanel", toggle_panel, { desc = "Toggle Tapioca commands panel" })
vim.api.nvim_create_user_command("TapiocaDsl", run_tapioca_dsl, { desc = "Run tapioca dsl in panel" })
vim.api.nvim_create_user_command("TapiocaBuild", run_tapioca_build, { desc = "Run tapioca build in panel" })
vim.api.nvim_create_user_command("TapiocaSync", run_tapioca_sync, { desc = "Run tapioca sync in panel" })

-- Keymaps
vim.keymap.set("n", "<leader>sp", toggle_panel, { desc = "Toggle Sorbet/Tapioca panel" })
vim.keymap.set("n", "<leader>sd", run_tapioca_dsl, { desc = "Run tapioca dsl in panel" })
vim.keymap.set("n", "<leader>sb", run_tapioca_build, { desc = "Run tapioca build in panel" })
vim.keymap.set("n", "<leader>ss", run_tapioca_sync, { desc = "Run tapioca sync in panel" })
