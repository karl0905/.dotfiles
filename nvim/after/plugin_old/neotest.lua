-- Enhanced neotest.lua with Ruby/RSpec toggle functionality

local neotest = require("neotest")

-- Helper to debug test commands if needed
-- vim.api.nvim_create_user_command("NeotestDebugEnv", function()
--   print("PATH: " .. vim.env.PATH)
--   print("PWD: " .. vim.fn.getcwd())
--   print("Bundle executable: " .. tostring(vim.fn.executable('bundle')))
-- end, {})

neotest.setup({
	adapters = {
		require("neotest-rspec"),
	},
	-- Display test results
	summary = {
		enabled = true,
		expand_errors = true,
		follow = true,
	},
	output = {
		enabled = true,
		open_on_run = true,
	},
	-- Floating window settings for test output
	floating = {
		border = "rounded",
		max_width = 0.8,
		max_height = 0.8,
	},
})

-- Function to toggle between Ruby implementation and spec files
local function toggle_ruby_spec()
	local current_file = vim.fn.expand("%:p")
	local is_spec = current_file:match("_spec%.rb$")
	local new_file = ""

	if is_spec then
		-- Convert from spec to implementation file
		-- Handle both lib/ and app/ structures common in Ruby/Rails projects
		new_file = current_file:gsub("spec/(.+)_spec%.rb$", "app/%1.rb")
		if vim.fn.filereadable(new_file) == 0 then
			-- Try lib/ if app/ doesn't exist
			new_file = current_file:gsub("spec/(.+)_spec%.rb$", "lib/%1.rb")
		end

		-- Handle spec/models/, spec/controllers/, etc. (Rails convention)
		if vim.fn.filereadable(new_file) == 0 then
			new_file = current_file:gsub("spec/(%w+)/(.+)_spec%.rb$", "app/%1/%2.rb")
		end

		-- Ruby gems often use lib/ at the root
		if vim.fn.filereadable(new_file) == 0 then
			new_file = current_file:gsub("spec/(.+)_spec%.rb$", "%1.rb")
		end
	else
		-- Convert from implementation to spec file
		if current_file:match("^.+/app/(.+)%.rb$") then
			-- Rails app structure
			new_file = current_file:gsub("app/(.+)%.rb$", "spec/%1_spec.rb")
		elseif current_file:match("^.+/lib/(.+)%.rb$") then
			-- Lib structure (common in gems and some Rails apps)
			new_file = current_file:gsub("lib/(.+)%.rb$", "spec/%1_spec.rb")
		else
			-- Fallback for other structures
			new_file = current_file:gsub("%.rb$", "_spec.rb")

			-- If file path doesn't include "spec", add it
			if not new_file:match("/spec/") then
				local dir = vim.fn.fnamemodify(new_file, ":h")
				local file = vim.fn.fnamemodify(new_file, ":t")
				new_file = dir .. "/spec/" .. file
			end
		end
	end

	-- If no corresponding file was found using the transforms, try a more generic approach
	if vim.fn.filereadable(new_file) == 0 then
		if is_spec then
			-- Try to find any Ruby file with a matching name (without _spec)
			local base_name = vim.fn.expand("%:t:r"):gsub("_spec$", "")
			local cmd = "find . -type f -name '" .. base_name .. ".rb' -not -path '*/spec/*' | head -n 1"
			local found_file = vim.fn.system(cmd):gsub("%s+$", "")
			if found_file ~= "" then
				new_file = found_file
			end
		else
			-- Try to find any spec file with a matching name
			local base_name = vim.fn.expand("%:t:r")
			local cmd = "find . -type f -path '*/spec/*' -name '" .. base_name .. "_spec.rb' | head -n 1"
			local found_file = vim.fn.system(cmd):gsub("%s+$", "")
			if found_file ~= "" then
				new_file = found_file
			end
		end
	end

	-- Open the new file if it exists or can be created
	if vim.fn.filereadable(new_file) == 1 then
		vim.cmd("edit " .. new_file)
	else
		-- If file doesn't exist, ask if user wants to create it
		local create_file = vim.fn.input("File " .. new_file .. " does not exist. Create it? (y/n): ")
		if create_file:lower() == "y" then
			-- Ensure the directory exists
			local dir = vim.fn.fnamemodify(new_file, ":h")
			if vim.fn.isdirectory(dir) == 0 then
				vim.fn.mkdir(dir, "p")
			end

			vim.cmd("edit " .. new_file)

			-- If creating a spec file, add basic RSpec structure with your preferred format
			if new_file:match("_spec%.rb$") then
				local class_name = vim.fn
					.fnamemodify(new_file, ":t:r")
					:gsub("_spec$", "")
					:gsub("^%l", string.upper)
					:gsub("_(%l)", function(l)
						return string.upper(l)
					end)
				local template = [[
# typed: strict
# frozen_string_literal: true

RSpec.describe ]] .. class_name .. [[ do
  describe ".run" do
    subject(:command) { ]] .. class_name .. [[.run(inputs) }
    
    let(:inputs) { {} }
    
    it "is successful" do
      expect(command).to be_success, command.errors.full_messages.to_sentence
    end
    
    it "returns the expected result" do
      expect(command.result).to eq(nil)
    end
  end
end
]]
				vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
			end
		else
			vim.notify("Toggle cancelled", vim.log.levels.INFO)
		end
	end
end

-- Key mappings for neotest
vim.keymap.set("n", "<leader>tt", function()
	neotest.run.run()
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run current file" })
vim.keymap.set("n", "<leader>ta", function()
	neotest.run.run({ suite = true })
end, { desc = "Run test suite" })
vim.keymap.set("n", "<leader>tl", function()
	neotest.run.run_last()
end, { desc = "Run last test" })
vim.keymap.set("n", "<leader>to", function()
	neotest.output.open({ enter = true })
end, { desc = "Open test output" })
vim.keymap.set("n", "<leader>tp", function()
	neotest.output_panel.toggle()
end, { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>ts", function()
	neotest.summary.toggle()
end, { desc = "Toggle summary panel" })
vim.keymap.set("n", "[t", function()
	neotest.jump.prev({ status = "failed" })
end, { desc = "Jump to previous failed test" })
vim.keymap.set("n", "]t", function()
	neotest.jump.next({ status = "failed" })
end, { desc = "Jump to next failed test" })

-- Add our new toggle keybind
vim.keymap.set("n", "<leader>tr", toggle_ruby_spec, { desc = "Toggle between Ruby file and spec" })
