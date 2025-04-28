-- Add this to your nvim/after/plugin/neotest.lua file

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

-- Key mappings for neotest
vim.keymap.set("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run current file" })
vim.keymap.set("n", "<leader>ta", function() neotest.run.run({suite = true}) end, { desc = "Run test suite" })
vim.keymap.set("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Run last test" })
vim.keymap.set("n", "<leader>to", function() neotest.output.open({enter = true}) end, { desc = "Open test output" })
vim.keymap.set("n", "<leader>tp", function() neotest.output_panel.toggle() end, { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle summary panel" })
vim.keymap.set("n", "[t", function() neotest.jump.prev({ status = "failed" }) end, { desc = "Jump to previous failed test" })
vim.keymap.set("n", "]t", function() neotest.jump.next({ status = "failed" }) end, { desc = "Jump to next failed test" })
