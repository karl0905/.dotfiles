local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

-- Custom function to narrow down the search results for live_grep by selecting a dir
local select_dir_for_grep = function()
	local action_state = require("telescope.actions.state")
	local fb = require("telescope").extensions.file_browser
	local live_grep = require("telescope.builtin").live_grep
	local current_line = action_state.get_current_line()

	fb.file_browser({
		files = false,
		depth = false,
		attach_mappings = function()
			require("telescope.actions").select_default:replace(function()
				local entry_path = action_state.get_selected_entry().Path
				local dir = entry_path:is_dir() and entry_path or entry_path:parent()
				local relative = dir:make_relative(vim.fn.getcwd())
				local absolute = dir:absolute()

				live_grep({
					results_title = relative .. "/",
					cwd = absolute,
					default_text = current_line,
				})
			end)

			return true
		end,
	})
end

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				-- Navigate history with Ctrl+P/N
				["<C-p>"] = actions.cycle_history_prev,
				["<C-n>"] = actions.cycle_history_next,
				-- Navigate results with Ctrl+J/K
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
        -- Select directory for live_grep
        ["<C-f>"] = select_dir_for_grep,
			},
			n = {
				-- Navigate history with Ctrl+P/N
				["<C-p>"] = actions.cycle_history_prev,
				["<C-n>"] = actions.cycle_history_next,
				-- Navigate results with Ctrl+J/K
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
        -- Select directory for live_grep
        ["<C-f>"] = select_dir_for_grep,
			},
		},
	},
  pickers = {
    live_grep = {
      mappings = {
        i = {
          -- Select directory for live_grep
          ["<C-f>"] = select_dir_for_grep,
        },
        n = {
          -- Select directory for live_grep
          ["<C-f>"] = select_dir_for_grep,
        },
      }
    }
  }
})

-- Load extensions
require("telescope").load_extension("file_browser")

-- Keymaps
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
-- git files search på Ctrl + p, dette søger efter alle git filer
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
-- Continue telescope (resume last picker)
vim.keymap.set("n", "<leader>pr", builtin.resume, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.live_grep({
		additional_args = function()
			return { "--fixed-strings" }
		end,
	})
end)
vim.keymap.set("n", "<leader>pb", builtin.buffers)
