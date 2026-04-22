vim.pack.add({ "https://github.com/rgroli/other.nvim" })

require("other-nvim").setup({
  mappings = {
    -- builtin mappings
    -- "livewire",
    -- "angular",
    -- "laravel",
    -- "rails",
    -- "golang",
    -- "python",
    "react",
    -- "rust",
    "elixir",
    -- "clojure",
    -- Custom mapping for Rails and RSpec
    {
      pattern = "/app/(.*)/(.*).rb$",
      target = "/spec/%1/%2_spec.rb",
      context = "test",
    },
    {
      pattern = "/spec/(.*)/(.*)_spec.rb$",
      target = "/app/%1/%2.rb",
      context = "source",
    }
  },
  transformers = {
    -- defining a custom transformer
    -- lowercase = function (inputString)
    --   return inputString:lower()
    -- end
  },
  style = {
    -- How the plugin paints its window borders
    -- Allowed values are none, single, double, rounded, solid and shadow
    -- border = "solid",

    -- Column seperator for the window
    -- seperator = "|",

    -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
    -- width = 0.7,

    -- min height in rows.
    -- when more columns are needed this value is extended automatically
    -- minHeight = 2
  },
})

-- Set up keymaps for the plugin
vim.keymap.set("n", "<leader>tr", "<cmd>Other<cr>")
