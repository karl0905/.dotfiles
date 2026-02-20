require("obsidian").setup({
	workspaces = {
		{
			name = "personal",
			path = "~/repos/notes/personal",
		},
		{
			name = "landfolk",
			path = "~/repos/notes/landfolk",
		},
	},
	daily_notes = {
		folder = "daily",
		date_format = "%Y-%d-%m-%a",
		default_tags = { "daily-notes" },
		template = "templates/daily.md",
	},
	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},
	ui = {
		enable = false,
	},
	new_notes_location = "current_dir",
	-- Zettelkasten-style IDs: timestamp + title
	note_id_func = function(title)
		local suffix = ""
		if title ~= nil then
			suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			-- Random suffix if no title
			for _ = 1, 4 do
				suffix = suffix .. string.char(math.random(65, 90))
			end
		end
		return tostring(os.time()) .. "-" .. suffix
	end,

	preferred_link_style = "wiki",

	templates = {
		folder = "templates",
		date_format = "%Y-%m-%d-%a",
		time_format = "%H:%M",
	},
	-- Show recently modified notes first (great for Zettelkasten workflow)
	sort_by = "modified",
	sort_reversed = true,
	mappings = {},

	---@param url string
	follow_url_func = function(url)
		-- Open the URL in the default web browser.
		vim.fn.jobstart({ "open", url }) -- Mac OS
		-- vim.fn.jobstart({"xdg-open", url})  -- linux
		-- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
		-- vim.ui.open(url) -- need Neovim 0.10.0+
	end,
})

-- Obsidian note management (prefix: <leader>n)
vim.keymap.set("n", "<leader>nn", "<cmd>ObsidianNew<CR>", { desc = "New note" })
vim.keymap.set("n", "<leader>nt", "<cmd>ObsidianNewFromTemplate<CR>", { desc = "New note from template" })

-- Searching
vim.keymap.set("n", "<leader>npf", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Search/switch notes" })
vim.keymap.set("n", "<leader>nps", "<cmd>ObsidianSearch<CR>", { desc = "Search in notes" })
vim.keymap.set("n", "<leader>nst", "<cmd>ObsidianTags<CR>", { desc = "Search tags" })

-- Daily notes
vim.keymap.set("n", "<leader>nd", "<cmd>ObsidianToday<CR>", { desc = "Today's daily note" })
vim.keymap.set("n", "<leader>ny", "<cmd>ObsidianYesterday<CR>", { desc = "Yesterday's note" })

-- Navigation and links
vim.keymap.set("n", "<leader>nj", "<cmd>ObsidianFollowLink<CR>", { desc = "Jump to link under cursor" })
vim.keymap.set("n", "<leader>nb", "<cmd>ObsidianBacklinks<CR>", { desc = "Show backlinks" })
vim.keymap.set("n", "<leader>nl", "<cmd>ObsidianLinks<CR>", { desc = "Show all links" })

-- Workspace and external
vim.keymap.set("n", "<leader>nw", "<cmd>ObsidianWorkspace<CR>", { desc = "Switch workspace" })
vim.keymap.set("n", "<leader>no", "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian app" })

-- Checkbox toggle (works anywhere)
vim.keymap.set("n", "<leader>nc", function()
	return require("obsidian").util.toggle_checkbox()
end, { desc = "Toggle checkbox" })
