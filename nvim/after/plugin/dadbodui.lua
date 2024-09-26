-- automaticcaly unfold query result
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'dbout' },
  callback = function()
    vim.opt.foldenable = false
  end,
})
