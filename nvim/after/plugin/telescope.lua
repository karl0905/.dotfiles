local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- git files search på Ctrl + p, dette søger efter alle git filer
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep)
vim.keymap.set('n', '<leader>pb', builtin.buffers)
