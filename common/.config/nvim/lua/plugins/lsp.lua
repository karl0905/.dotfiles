vim.pack.add({
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/whoissethdaniel/mason-tool-installer",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
})

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local mason_servers = {
  "ts_ls",
  "html",
  "cssls",
  "tailwindcss",
  "lua_ls",
  "graphql",
  "emmet_ls",
  -- "pyright",
  -- "omnisharp",
  "ruby_lsp",
  "sorbet",
  "eslint",
  "marksman",
  "jsonls",
  "jedi_language_server",
  "sqls",
  "tinymist",
}

local extra_servers = {
  "gdscript",
}

local mason_tools = {
  -- Formatters
  "prettierd",
  "black",
  "isort",
  "shfmt",

  -- Linters
  "jsonlint",
  "eslint_d",
  "luacheck",
  "pylint",
  "stylelint",
  "htmlhint",
  "yamllint",
  "markdownlint",
  "biome",
  "shellcheck",
}

local server_settings = {
  lua_ls = {
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
  },
  ruby_lsp = {
    init_options = {
      formatter = "syntax_tree",
    },
  },
  sorbet = {
    cmd = { "srb", "tc", "--lsp", "--disable-watchman" },
  },
}

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_lspconfig.setup({
  ensure_installed = mason_servers,
  automatic_installation = true,
  automatic_enable = false,
})

mason_tool_installer.setup({
  ensure_installed = mason_tools,
})

local default_config = {
  capabilities = cmp_nvim_lsp.default_capabilities(),
}

for _, server_name in ipairs(vim.list_extend(vim.deepcopy(mason_servers), extra_servers)) do
  local custom_settings = server_settings[server_name] or {}
  local config = vim.tbl_deep_extend("force", default_config, custom_settings)

  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local opts = { buf = event.buf, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, opts)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
})
