vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })

vim.g.fff = {
  keymaps = {
    move_up = { "<Up>", "<C-k>" },
    move_down = { "<Down>", "<C-j>" },
    cycle_previous_query = "<C-p>",
    cycle_grep_modes = '<C-s>',
  },
}

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    local spec = event.data.spec
    local kind = event.data.kind

    if not spec or spec.name ~= "fff.nvim" or (kind ~= "install" and kind ~= "update") then
      return
    end

    if not event.data.active then
      vim.cmd.packadd("fff.nvim")
    end

    require("fff.download").download_or_build_binary()
  end,
})

vim.keymap.set("n", "<leader>pf", function()
  require("fff").find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<C-p>", function()
  require("fff").find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>ps", function()
  require("fff").live_grep()
end, { desc = "Live grep" })
