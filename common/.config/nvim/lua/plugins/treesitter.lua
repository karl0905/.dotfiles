vim.pack.add({
	"https://github.com/romus204/tree-sitter-manager.nvim",
})

require("tree-sitter-manager").setup({
	-- Default Options
	ensure_installed = {
    "ruby",
    "lua",
    "markdown"
  }, -- list of parsers to install at the start of a neovim session
	-- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
	auto_install = true, -- if enabled, install missing parsers when editing a new file
	-- highlight = true, -- treesitter highlighting is enabled by default
	-- languages = {}, -- override or add new parser sources
	-- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
	-- query_dir = vim.fn.stdpath("data") .. "/site/queries",
})
