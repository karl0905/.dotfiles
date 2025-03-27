local lsp = require("lsp-zero")
lsp.preset("recommended")

-- Setup Mason
require('mason').setup()

-- Setup mason-lspconfig
require('mason-lspconfig').setup({
  ensure_installed = {
    -- 'rust_analyzer',
    -- 'ts_ls',
    -- 'cssls',
    -- 'html',
    -- 'intelephense',
    -- 'lua_ls',
    -- 'tailwindcss',
    -- 'sqls',
    -- 'jedi_language_server',
    -- 'pylsp'
  },
})

-- Setup mason-null-ls
require('mason-null-ls').setup({
  ensure_installed = {
    'prettierd',
    'eslint_d',
  },
  automatic_installation = true,
})

-- Setup null-ls
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
  },
})

-- Setup vim-dadbod for SQL completion
require('lspconfig').sqls.setup {
  on_attach = function(client, bufnr)
    -- Enable SQL completion
    vim.cmd [[
        autocmd FileType sql setlocal omnifunc=v:lua.vim.dadbod.complete
    ]]
  end,
}

-- OmniSharp setup
require('lspconfig').omnisharp.setup {
  cmd = {
    "dotnet",
    vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.dll",
    "--languageserver",
    "--hostPID",
    tostring(vim.fn.getpid())
  },
  root_dir = require('lspconfig').util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "Directory.Build.props"),
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true
    }
  }
}

-- Setup cmp
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})
