require("catppuccin").setup({
  flavour = "macchiato",
  transparent_background = false,
  integrations = {
    lualine = {
      all = function(colors)
        return {
          normal = {
            a = { bg = colors.mauve, fg = colors.base, gui = "bold" },
            b = { bg = colors.surface1, fg = colors.mauve },
            c = { bg = colors.surface0, fg = colors.text },
          },
          insert = {
            a = { bg = colors.green, fg = colors.base, gui = "bold" },
            b = { bg = colors.surface1, fg = colors.green },
            c = { bg = colors.surface0, fg = colors.text },
          },
          visual = {
            a = { bg = colors.pink, fg = colors.base, gui = "bold" },
            b = { bg = colors.surface1, fg = colors.pink },
            c = { bg = colors.surface0, fg = colors.text },
          },
          command = {
            a = { bg = colors.peach, fg = colors.base, gui = "bold" },
            b = { bg = colors.surface1, fg = colors.peach },
            c = { bg = colors.surface0, fg = colors.text },
          },
          replace = {
            a = { bg = colors.red, fg = colors.base, gui = "bold" },
            b = { bg = colors.surface1, fg = colors.red },
            c = { bg = colors.surface0, fg = colors.text },
          },
          terminal = {
            a = { bg = colors.sapphire, fg = colors.base, gui = "bold" },
            b = { bg = colors.surface1, fg = colors.sapphire },
            c = { bg = colors.surface0, fg = colors.text },
          },
          inactive = {
            a = { bg = colors.mantle, fg = colors.overlay0 },
            b = { bg = colors.mantle, fg = colors.overlay0 },
            c = { bg = colors.mantle, fg = colors.overlay0 },
          },
        }
      end,
    },
  },
  custom_highlights = function(colors)
    return {
      StatusLine = { bg = colors.surface0, fg = colors.text },
      StatusLineNC = { bg = colors.mantle, fg = colors.overlay0 },
    }
  end,
})

vim.cmd([[colorscheme catppuccin-macchiato]])

function HiLine()
  vim.cmd([[hi LineNr guibg=none guifg=#B7B7B7]])
end
