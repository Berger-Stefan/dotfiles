local map = vim.keymap.set

local function build_and_run_current_day()
	-- Save current buffer
	vim.cmd("w")

	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return
	end

	-- Directory name like "day_5"
	local day_dir = vim.fn.fnamemodify(file, ":p:h:t")

	-- Find project root as the parent of the nearest "build" directory
	local build_match = vim.fs.find("build", { path = file, upward = true, type = "directory" })[1]
	if not build_match then
		vim.notify("No build directory found upwards from current file", vim.log.levels.ERROR)
		return
	end
	local project_root = vim.fs.dirname(build_match)

	-- Assume the executable lives at build/<day_dir>/<day_dir>
	-- Adjust this mapping if your target name differs from the directory name.
	local target_name = day_dir
	local cmd = string.format("cd %s && cmake --build build && ./build/%s/%s", project_root, day_dir, target_name)

	vim.cmd("!" .. cmd)
end

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection up" })

map("n", "<C-d>", "<C-d>zz", { desc = "scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "scroll up centered" })
map("n", "n", "nzzzv", { desc = "next search centered" })
map("n", "N", "Nzzzv", { desc = "previous search centered" })

-- build & run CMake target
map("n", "<leader>dr", build_and_run_current_day, { desc = "Build and run current day" })

-- nvimtree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
-- map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window"})

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- lsp keybindings (on_attach)
map("n", "gd", function()
	vim.lsp.buf.definition()
end, { desc = "Go to definition" })
map("n", "K", function()
	vim.lsp.buf.hover()
end, { desc = "Hover documentation" })
map("n", "gr", function()
	vim.lsp.buf.references()
end, { desc = "Show references" })
map("n", "<leader>rn", function()
	vim.lsp.buf.rename()
end, { desc = "Rename symbol" })
map("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "Code action" })
map("n", "[d", function()
	vim.diagnostic.goto_prev()
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
	vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })
map("n", "<leader>d", function()
	vim.diagnostic.open_float()
end, { desc = "Open diagnostic float" })
map("n", "<leader>f", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- remap save command
map("n", "<leader>w", ":w<CR>")

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "telescope find all files" }
)

-- remap brackets to german layout
map("n", "ü", "[", { noremap = true })
map("n", "ä", "]", { noremap = true })
