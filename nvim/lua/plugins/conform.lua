return {
  -- https://github.com/stevearc/conform.nvim
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 1000,
        })
      end,
      mode = { "n", "v" },
      desc = "Format file or range",
    },
  },
  opts = {
    formatters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      css = { "eslint_d" },
      html = { "eslint_d" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "markdownlint" },
      graphql = { "eslint_d" },
      lua = { "stylua" },
      python = { "isort", "ruff" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      typst = { "typstyle" },
    },
    formatters = {
      -- prettierd = { command = "prettierd" },
    },
    -- format_on_save = {
    --   lsp_format = "fallback",
    --   timeout_ms = 1000,
    -- },
  },
}
