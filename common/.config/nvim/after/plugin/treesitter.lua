local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

treesitter_configs.setup({
  ensure_installed = { "javascript", "typescript", "c", "lua", "vim", "vimdoc", "query", "ruby" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
  },
})
