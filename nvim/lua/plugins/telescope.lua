return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    {
      "<C-p>",
      function()
        require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
      end,
      desc = "Find all files",
    },
    { "<leader>pr", "<cmd>Telescope resume<cr>", desc = "Resume picker" },
    {
      "<leader>ps",
      function()
        require("telescope.builtin").live_grep({
          additional_args = function()
            return { "--fixed-strings" }
          end,
        })
      end,
      desc = "Live grep",
    },
    { "<leader>pb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  },
  opts = function()
    local actions = require("telescope.actions")

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

    return {
      defaults = {
        mappings = {
          i = {
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-f>"] = select_dir_for_grep,
          },
          n = {
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-f>"] = select_dir_for_grep,
          },
        },
      },
      pickers = {
        live_grep = {
          mappings = {
            i = {
              ["<C-f>"] = select_dir_for_grep,
            },
            n = {
              ["<C-f>"] = select_dir_for_grep,
            },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("file_browser")
  end,
}
