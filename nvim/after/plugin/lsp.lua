require('mason').setup()

-- Add cmp_nvim_lsp capabilities to lspconfig defaults
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

-- Configure lua_ls separately
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

-- Mason-lspconfig for LSP servers only
require('mason-lspconfig').setup({
  ensure_installed = {
    "eslint",
    "marksman",
    "ts_ls",
    "tailwindcss",
    "ruby_lsp",
    "omnisharp",
    "sqls",
    "jedi_language_server",
    "pyright",
    "jsonls",
    "lua_ls",
  },
  automatic_installation = true,
  automatic_enable = true,
})

-- Mason-null-ls for formatters and linters
require("mason-null-ls").setup({
  ensure_installed = {
    "prettierd",
    "eslint_d",
  },
  automatic_installation = true,
})

-- Fix for Copilot Tab completion
local cmp = require("cmp")
cmp.setup({
  mapping = {
    -- Remove Tab from cmp to reserve it for Copilot
    ["<Tab>"] = nil,
    ["<S-Tab>"] = nil,
    -- Add Ctrl+Space to trigger completion
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- arrows
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- LSP keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  end
})

-- Basic diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.HINT] = 'H',
      [vim.diagnostic.severity.INFO] = 'I',
    }
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Setup null-ls/none-ls for formatters safely
local has_null_ls, null_ls = pcall(require, "null-ls")
if has_null_ls then
  local sources = {}

  -- First check if the prettierd formatter is available
  pcall(function()
    table.insert(
      sources,
      null_ls.builtins.formatting.prettierd.with({
        filetypes = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "css",
          "scss",
          "html",
          "json",
          "yaml",
          "markdown",
          "graphql",
        },
        -- Only use prettier when no ESLint config is found
        condition = function(utils)
          return not utils.root_has_file({
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.json",
            ".eslintrc.yaml",
            ".eslintrc.yml",
          })
        end,
      })
    )
  end)

  -- Setup null-ls with safe sources
  if #sources > 0 then
    null_ls.setup({
      sources = sources,
    })
  end

  -- Minimal mason-null-ls setup to avoid errors
  pcall(function()
    require("mason-null-ls").setup({
      ensure_installed = {
        "prettierd",
        "eslint_d",
      },
      automatic_installation = true,
    })
  end)
end
