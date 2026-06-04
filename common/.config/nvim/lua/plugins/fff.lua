vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })

local PREVIEW_MATCH_HL = "FFFPreviewMatch"
local PREVIEW_MATCH_GROUP = "fff_preview_match_highlight"

local function get_hl(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  return ok and hl or {}
end

local function apply_fff_preview_match_highlight()
  local statement = get_hl("Statement")
  local search = get_hl("Search")
  local inc = get_hl("IncSearch")

  vim.api.nvim_set_hl(0, PREVIEW_MATCH_HL, {
    fg = statement.fg or inc.fg,
    bg = search.bg or inc.bg,
    bold = true,
  })
end

apply_fff_preview_match_highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup(PREVIEW_MATCH_GROUP, { clear = true }),
  callback = apply_fff_preview_match_highlight,
  desc = "Refresh FFF preview grep match highlight",
})

vim.g.fff = {
  keymaps = {
    move_up = { "<Up>", "<C-k>" },
    move_down = { "<Down>", "<C-j>" },
    cycle_previous_query = "<C-p>",
    cycle_grep_modes = "<C-s>",
  },
  layout = {
    prompt_position = "buttom",
    preview_position = "top",
  },
  hl = {
    winhl = {
      preview = "Normal:NormalFloat,FloatBorder:FloatBorder,FloatTitle:Title,IncSearch:" .. PREVIEW_MATCH_HL,
    },
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

local function find_files()
  require("fff").find_files()
end

local function live_grep()
  require("fff").live_grep()
end

vim.keymap.set("n", "<leader>pf", find_files, { desc = "Find files" })
vim.keymap.set("n", "<C-p>", find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>ps", live_grep, { desc = "Live grep" })
