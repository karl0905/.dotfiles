local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

vim.cmd("packadd nvim-treesitter-textobjects")

treesitter_configs.setup({
  ensure_installed = {
    "c",
    "gdscript",
    "git_rebase",
    "gitcommit",
    "javascript",
    "lua",
    "query",
    "ruby",
    "typescript",
    "vim",
    "vimdoc",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "gitcommit", "gitrebase" },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
    },
  },
})

local textobjects_ok, select = pcall(require, "nvim-treesitter.textobjects.select")
if not textobjects_ok then
  return
end

local select_modes = { "x", "o" }

vim.keymap.set(select_modes, "af", function()
  select.select_textobject("@function.outer", "textobjects")
end)

vim.keymap.set(select_modes, "if", function()
  select.select_textobject("@function.inner", "textobjects")
end)

vim.keymap.set(select_modes, "ac", function()
  select.select_textobject("@class.outer", "textobjects")
end)

vim.keymap.set(select_modes, "ic", function()
  select.select_textobject("@class.inner", "textobjects")
end)

vim.keymap.set(select_modes, "aa", function()
  select.select_textobject("@parameter.outer", "textobjects")
end)

vim.keymap.set(select_modes, "ia", function()
  select.select_textobject("@parameter.inner", "textobjects")
end)
