vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" })

vim.keymap.set("n", "{Left-Mapping}", "<Cmd>TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "{Down-Mapping}", "<Cmd>TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "{Up-Mapping}", "<Cmd>TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "{Right-Mapping}", "<Cmd>TmuxNavigateRight<CR>", { silent = true })
vim.keymap.set("n", "{Previous-Mapping}", "<Cmd>TmuxNavigatePrevious<CR>", { silent = true })
