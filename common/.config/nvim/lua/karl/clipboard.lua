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
  elseif vim.fn.has('mac') == 1 then
    -- macOS specific clipboard setup
    vim.g.clipboard = {
      name = 'macOS-clipboard',
      copy = {
        ['+'] = 'pbcopy',
        ['*'] = 'pbcopy',
      },
      paste = {
        ['+'] = 'pbpaste',
        ['*'] = 'pbpaste',
      },
      cache_enabled = 0,
    }
  else
    return
  end
end

return M
