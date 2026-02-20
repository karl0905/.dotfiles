return {
  -- https://github.com/mfussenegger/nvim-lint
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- markdown = { "vale" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      css = { "stylelint" },
      html = { "htmlhint" },
      json = { "jsonlint" },
      yaml = { "yamllint" },
      -- markdown = { "markdownlint" },
      lua = { "luacheck" },
      python = { "ruff" },
      -- ruby = { "rubocop" },
      -- sh = { "shellcheck" },
      -- bash = { "shellcheck" },
    }

    if lint.linters.luacheck and lint.linters.luacheck.args then
      table.insert(lint.linters.luacheck.args, "--globals")
      table.insert(lint.linters.luacheck.args, "vim")
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({
      "BufEnter",
      "BufWritePost",
      "InsertLeave",
      "TextChanged",
      -- "TextChangedI",
    }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
        -- lint.try_lint("cspell")
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Lint current buffer" })
  end,
}
