local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
  return
end

local treesitter_filetypes = { "c", "gdscript", "javascript", "lua", "query", "ruby", "typescript", "vim", "vimdoc" }

treesitter.setup()

local function start_treesitter(bufnr)
  if not vim.api.nvim_buf_is_loaded(bufnr) or vim.bo[bufnr].buftype ~= "" then
    return
  end

  if not vim.list_contains(treesitter_filetypes, vim.bo[bufnr].filetype) then
    return
  end

  pcall(vim.treesitter.start, bufnr)
end

local treesitter_group = vim.api.nvim_create_augroup("karl-treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = treesitter_group,
  pattern = treesitter_filetypes,
  callback = function(event)
    start_treesitter(event.buf)
  end,
})

for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  start_treesitter(bufnr)
end

local textobjects_ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
if not textobjects_ok then
  return
end

textobjects.setup({
  select = {
    lookahead = true,
  },
})

local select = require("nvim-treesitter-textobjects.select")
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
