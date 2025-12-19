-- Import modular plugin configurations
local lsp_config = require("plugins.lsp")
local conform_config = require("plugins.conform")
local ufo_config = require("plugins.ufo")

-- Combine all plugin specs
local specs = {}

-- Add modular configs
for _, spec in ipairs(lsp_config) do
	table.insert(specs, spec)
end

for _, spec in ipairs(conform_config) do
	table.insert(specs, spec)
end

for _, spec in ipairs(ufo_config) do
	table.insert(specs, spec)
end

-- Add other plugins
table.insert(specs, { "nvim-lua/plenary.nvim", lazy = true })

-- Telescope
table.insert(specs, {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Help Tags",
		},
	},
})

-- Monokai Pro colorscheme
table.insert(specs, {
	"loctvl842/monokai-pro.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("monokai-pro").setup()
		vim.cmd([[colorscheme monokai-pro]])
	end,
})

-- Autopairs
table.insert(specs, {
	"windwp/nvim-autopairs",
	opts = {
		fast_wrap = {},
		disable_filetype = { "TelescopePrompt", "vim" },
	},
	config = function(_, opts)
		require("nvim-autopairs").setup(opts)

		-- setup cmp for autopairs
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
})

-- NvimTree file manager
table.insert(specs, {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("nvim-tree").setup()
	end,
})

-- Treesitter
table.insert(specs, {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
})

-- Leap
table.insert(specs, {
	"ggandor/leap.nvim",
	keys = {
		{ "s", "<Plug>(leap-forward)", mode = { "n", "x" }, desc = "Leap forward" },
		{ "S", "<Plug>(leap-backward)", mode = { "n", "x" }, desc = "Leap backward" },
	},
})

-- Gitsigns
table.insert(specs, {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup()
	end,
})

-- Lualine
table.insert(specs, {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup()
	end,
})

-- Tmux integration
table.insert(specs, {
	"aserowy/tmux.nvim",
	event = "VeryLazy",
	config = function()
		require("tmux").setup()
	end,
})

-- Which-key
table.insert(specs, {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 100
	end,
	config = function()
		require("which-key").setup()
	end,
})

return specs
