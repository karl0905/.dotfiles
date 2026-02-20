return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer",
    "hrsh7th/cmp-nvim-lsp",
    "antosha417/nvim-lsp-file-operations",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local servers = {
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "lua_ls",
      "graphql",
      "emmet_ls",
      "ruby_lsp",
      "sorbet",
      "eslint",
      "marksman",
      "jsonls",
      "jedi_language_server",
      "sqls",
      "tinymist",
    }

    mason.setup({
      ui = {
        icons = {
          package_installed = "+",
          package_pending = ">",
          package_uninstalled = "x",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = servers,
      automatic_installation = true,
      automatic_enable = false,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettierd",
        "black",
        "isort",
        "shfmt",
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
      },
    })

    require("lsp-file-operations").setup()

    local capabilities = cmp_nvim_lsp.default_capabilities()

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

    local default_config = {
      capabilities = capabilities,
    }

    for _, server_name in ipairs(servers) do
      local custom_settings = server_settings[server_name] or {}
      local config = vim.tbl_deep_extend("force", default_config, custom_settings)

      if server_settings[server_name] then
        vim.lsp.config(server_name, config)
      end

      vim.lsp.enable(server_name)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local opts = { buffer = event.buf, remap = false }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vd", function()
          vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
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
    })
  end,
}
