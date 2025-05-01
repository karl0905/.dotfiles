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
    -- Configure ESLint LSP if you want to use it - helpful for integrated IDE-like experience
    ["eslint"] = function()
      require('lspconfig').eslint.setup({
        settings = {
          format = true,
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = true

          -- Optional: auto-fix on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })
    end,
  },
})

-- Fix for Copilot Tab completion from paste.txt
local cmp = require('cmp')
local cmp_mappings = lsp.defaults.cmp_mappings()
-- Remove Tab from cmp completely to reserve it for Copilot
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
-- Add Ctrl+Space to trigger completion
cmp_mappings['<C-Space>'] = cmp.mapping.complete()
-- Set up cmp with our modified mappings
lsp.setup_nvim_cmp({
  mapping = cmp_mappings
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

-- Setup none-ls/null-ls for formatters
local has_null_ls, null_ls = pcall(require, "null-ls")
if has_null_ls then
  local sources = {}

  -- First check if the prettierd formatter is available
  pcall(function()
    table.insert(sources, null_ls.builtins.formatting.prettierd.with({
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "css", "scss", "html", "json", "yaml", "markdown", "graphql" },
      -- Only use prettier when no ESLint config is found
      condition = function(utils)
        return not utils.root_has_file({
          '.eslintrc',
          '.eslintrc.js',
          '.eslintrc.json',
          '.eslintrc.yaml',
          '.eslintrc.yml',
        })
      end,
    }))
  end)

  -- Try to safely add eslint_d diagnostics (but not formatting yet)
  pcall(function()
    -- Only add eslint_d diagnostics if the builtin exists
    local has_eslint_d_diag = false
    for name, _ in pairs(null_ls.builtins.diagnostics) do
      if name == "eslint_d" then
        has_eslint_d_diag = true
        break
      end
    end

    if has_eslint_d_diag then
      table.insert(sources, null_ls.builtins.diagnostics.eslint_d.with({
        condition = function(utils)
          return utils.root_has_file({
            '.eslintrc',
            '.eslintrc.js',
            '.eslintrc.json',
            '.eslintrc.yaml',
            '.eslintrc.yml',
          })
        end,
      }))
    end
  end)

  -- Setup null-ls with our safe sources
  null_ls.setup({
    sources = sources
  })

  -- Minimal mason-null-ls setup to avoid errors
  pcall(function()
    require("mason-null-ls").setup({
      automatic_setup = true,
    })
  end)
else
  -- Fallback if null-ls is not installed
  vim.notify("For formatting with Prettier, please install null-ls: use 'nvimtools/none-ls.nvim'",
    vim.log.levels.INFO)
end

-- Format command with intelligent source selection
vim.api.nvim_create_user_command('Format', function()
  -- Format using available providers
  vim.lsp.buf.format({
    async = true,
  })
end, {})

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

-- Command to check available null-ls builtins
vim.api.nvim_create_user_command('NullLsInfo', function()
  if not has_null_ls then
    print("null-ls is not available")
    return
  end

  print("Available null-ls formatters:")
  for name, _ in pairs(null_ls.builtins.formatting) do
    print("- " .. name)
  end

  print("\nAvailable null-ls diagnostics:")
  for name, _ in pairs(null_ls.builtins.diagnostics) do
    print("- " .. name)
  end
end, {})
