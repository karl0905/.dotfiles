vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y"]])

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("t", "<C-Space>", [[<C-\><C-n>]], { noremap = true })

-- Split windows
vim.keymap.set("n", "<leader>h", "<Cmd>vsplit<CR><C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>v", "<Cmd>split<CR><C-w>j", { noremap = true, silent = true })

-- Resize windows
vim.keymap.set("n", "<Left>", ":vertical resize +4<CR>")
vim.keymap.set("n", "<Right>", ":vertical resize -4<CR>")
vim.keymap.set("n", "<Up>", ":horizontal resize +4<CR>")
vim.keymap.set("n", "<Down>", ":horizontal resize -4<CR>")

-- Vim tmux navigator
vim.keymap.set("n", "{Left-Mapping}", "<Cmd>TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "{Down-Mapping}", "<Cmd>TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "{Up-Mapping}", "<Cmd>TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "{Right-Mapping}", "<Cmd>TmuxNavigateRight<CR>", { silent = true })
vim.keymap.set("n", "{Previous-Mapping}", "<Cmd>TmuxNavigatePrevious<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

-- Yank whole file to clipboard
vim.keymap.set("n", "<leader>yf", "<Cmd>:%y+<CR>")

-- Yank current file path and name to clipboard
vim.keymap.set("n", "<leader>yp", function()
  local filepath = vim.fn.expand("%:p:.")
  vim.fn.setreg("+", filepath)
  vim.notify("Copied to clipboard: " .. filepath)
end, { desc = "Copy current file path to clipboard" })

-- Yank current file path, name and line-number to clipboard
vim.keymap.set("n", "<leader>yP", function()
	local filepath = vim.fn.expand("%:p:.")
  local line_number = vim.fn.line(".")
  local full_path_with_line = filepath .. ":" .. line_number
  vim.fn.setreg("+", full_path_with_line)
	vim.notify("Copied to clipboard: " .. full_path_with_line)
end, { desc = "Copy current file path to clipboard" })

-- Open floating linter window
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")

-- Scratchpad files
vim.keymap.set("n", "<leader>ot", ":e ~/tmp/todo.md<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>or", ":e ~/tmp/scratchpad.rb<CR>", { noremap = true, silent = true })

-- Restart and keep sessions
vim.keymap.set("n", "<leader>r", function()
	local session = vim.fn.stdpath("state") .. "/restart_session.vim"
	vim.cmd("mksession! " .. vim.fn.fnameescape(session))
	vim.cmd("restart source " .. vim.fn.fnameescape(session))
end, { desc = "Restart Neovim" })
