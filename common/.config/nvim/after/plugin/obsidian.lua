local ok, obsidian = pcall(require, "obsidian")
if not ok then
	return
end

local workspaces = {}
for _, workspace in ipairs({
	{ name = "personal", path = "~/repos/notes/personal" },
	{ name = "landfolk", path = "~/repos/notes/landfolk" },
}) do
	local expanded = vim.fn.expand(workspace.path)
	if vim.fn.isdirectory(expanded) == 1 then
		table.insert(workspaces, workspace)
	end
end

if #workspaces == 0 then
	return
end

obsidian.setup({
	workspaces = workspaces,
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
	note_id_func = function(title)
		local suffix = ""
		if title ~= nil then
			suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
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
	sort_by = "modified",
	sort_reversed = true,
	mappings = {},
	follow_url_func = function(url)
		if vim.ui.open then
			vim.ui.open(url)
			return
		end

		if vim.fn.has("mac") == 1 then
			vim.fn.jobstart({ "open", url })
			return
		end

		vim.fn.jobstart({ "xdg-open", url })
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
