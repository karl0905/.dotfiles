-- Simple LSP configuration with formatting support

-- Setup Mason package manager
require('mason').setup()

-- Setup LSP with sensible defaults
local lsp = require('lsp-zero').preset("recommended")

-- Setup mason-lspconfig to automatically handle servers
require('mason-lspconfig').setup({
  automatic_installation = true,
  handlers = {
    lsp.default_setup,
    ["lua_ls"] = function()
      require('lspconfig').lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              -- Recognize the `vim` global
              globals = { 'vim' }
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false
            },
            completion = {
              callSnippet = "Replace"
            }
          }
        }
      })
    end,
  },

})

-- Standard LSP keybindings
lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

  print("LSP started: " .. client.name)
end)

-- Simple diagnostic icons
lsp.set_preferences({
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

-- Initialize LSP
lsp.setup()

-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Setup none-ls/null-ls for formatters like Prettier
local has_null_ls, null_ls = pcall(require, "null-ls")
if has_null_ls then
  null_ls.setup({
    sources = {
      -- Add the formatters you have installed with Mason
      null_ls.builtins.formatting.prettierd.with({
        filetypes = { "javascript", "typescript", "css", "scss", "html", "json", "yaml", "markdown", "graphql" },
      }),
      -- Add more formatters as needed
    }
  })

  -- Setup Mason integration with null-ls if available
  pcall(function()
    require("mason-null-ls").setup({
      automatic_installation = true,
    })
  end)
else
  -- Fallback if null-ls is not installed
  vim.notify("For formatting with Prettier, please install null-ls: use 'jose-elias-alvarez/null-ls.nvim'",
    vim.log.levels.INFO)
end

-- Commands to check LSP status
vim.api.nvim_create_user_command('LspAttachInfo', function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = buf })

  if #clients == 0 then
    print("No LSP clients attached to this buffer.")
  else
    print("LSP clients attached to this buffer:")
    for _, client in ipairs(clients) do
      print("- " .. client.name)
    end
  end
end, {})

-- Format command that works with both LSP and null-ls
vim.api.nvim_create_user_command('Format', function()
  vim.lsp.buf.format({ async = true })
end, {})
