vim.g.mapleader = " "
vim.keymap.set('n', '<leader>pv', '<Cmd>NERDTreeToggle<CR>', { noremap = true, silent = true }) -- Open NERDTree
vim.keymap.set("n", "<leader>nf", vim.cmd.NERDTreeFind)                                         -- Open NERDTree with current file selected
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y"]])

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
  require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
  require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set('t', '<C-Space>', [[<C-\><C-n>]], { noremap = true })

-- Split windows
vim.keymap.set('n', '<leader>h', '<Cmd>vsplit<CR><C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>v', '<Cmd>split<CR><C-w>j', { noremap = true, silent = true })

-- Resize windows
vim.keymap.set("n", "<Left>", ":vertical resize +4<CR>")
vim.keymap.set("n", "<Right>", ":vertical resize -4<CR>")
vim.keymap.set("n", "<Up>", ":horizontal resize +4<CR>")
vim.keymap.set("n", "<Down>", ":horizontal resize -4<CR>")
-- NERDTree

-- Vim tmux navigator
-- vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', { silent = true })
-- vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', { silent = true })
-- vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', { silent = true })
-- vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', { silent = true })
-- vim.keymap.set('n', '<C-p>', '<Cmd>TmuxNavigatePrevious<CR>', { silent = true })vim.keymap.set('n', '{Left-Mapping}', '<Cmd>TmuxNavigateLeft<CR>', { silent = true })
vim.keymap.set('n', '{Left-Mapping}', '<Cmd>TmuxNavigateLeft<CR>', { silent = true })
vim.keymap.set('n', '{Down-Mapping}', '<Cmd>TmuxNavigateDown<CR>', { silent = true })
vim.keymap.set('n', '{Up-Mapping}', '<Cmd>TmuxNavigateUp<CR>', { silent = true })
vim.keymap.set('n', '{Right-Mapping}', '<Cmd>TmuxNavigateRight<CR>', { silent = true })
vim.keymap.set('n', '{Previous-Mapping}', '<Cmd>TmuxNavigatePrevious<CR>', { silent = true })

-- vi-mongo keybinds
vim.api.nvim_set_keymap('n', '<leader>vm', ':ViMongo<CR>', { noremap = true, silent = true })

-- vim dadbod keybinds
-- toggle dadbod UI
vim.keymap.set("n", "<leader>db", "<Cmd>DBUIToggle<CR>");
-- run current buffer
vim.keymap.set("n", "<leader>dr", "<Cmd>DB<CR>");

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- Yank whole file to clipboard
vim.keymap.set("n", "<leader>yf", "<Cmd>:%y+<CR>");

-- Open floating linter window
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
