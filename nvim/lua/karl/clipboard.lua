local M = {}

M.setup = function()
  if vim.fn.has('wsl') == 1 then
    -- WSL-specific clipboard setup
    vim.g.clipboard = {
      name = 'WslClipboard',
      copy = {
        ['+'] = 'clip.exe',
        ['*'] = 'clip.exe',
      },
      paste = {
        ['+'] = 'powershell.exe -c Get-Clipboard',
        ['*'] = 'powershell.exe -c Get-Clipboard',
      },
      cache_enabled = 0,
    }
  else
    -- macOS/Linux clipboard setup using OSC52
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy,
        ['*'] = require('vim.ui.clipboard.osc52').copy,
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste,
        ['*'] = require('vim.ui.clipboard.osc52').paste,
      },
    }
  end
end

return M
