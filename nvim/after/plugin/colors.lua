vim.cmd [[colorscheme tokyonight-night]]
vim.cmd [[ 
  highlight Normal guibg=none 
  highlight NonText guibg=none 
  highlight Normal guibg=none 
  highlight NonText ctermbg=none 
]]

function HiLine()
  vim.cmd([[hi LineNr guibg=none guifg=#B7B7B7]])
end
