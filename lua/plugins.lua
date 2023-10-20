vim.g.mapleader = " "
require("lazy").setup({
	{url = "https://github.com/neovim/nvim-lspconfig"},
	{url = 'https://github.com/hrsh7th/nvim-cmp'}, -- Autocompletion plugin
	{url = 'https://github.com/hrsh7th/cmp-nvim-lsp'}, -- LSP source for nvim-cmp
	{
		url = 'https://github.com/L3MON4D3/LuaSnip',
		dependencies = { "https://github.com/rafamadriz/friendly-snippets" },
	}, -- LuaSnip plugin (used by cmp)
	{url = 'https://github.com/saadparwaiz1/cmp_luasnip'}, -- LuaSnip for nvim-cmp
	{url = "https://github.com/navarasu/onedark.nvim"},
	{url = "https://github.com/nvim-telescope/telescope.nvim",
      		dependencies = { url = "https://github.com/nvim-lua/plenary.nvim"}},
	{url = "https://github.com/akinsho/bufferline.nvim",
		requires = { url = "nvim-tree/nvim-web-devicons"}},
	{ url = 'https://github.com/nvim-lualine/lualine.nvim',
		requires = { 'https://github.com/kyazdani42/nvim-web-devicons',
			opt = true }},
	{url = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	{url = "https://github.com/windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end},
	{url = "https://github.com/windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end},
	{url = 'https://github.com/nvim-tree/nvim-tree.lua'},
	{url = 'https://github.com/lewis6991/gitsigns.nvim'},
	{url = 'https://github.com/j-hui/fidget.nvim', tag = "legacy"}, -- Show LSP info bottom right
	{url = 'https://github.com/ojroques/nvim-osc52'},
	{url = 'https://github.com/famiu/bufdelete.nvim'},
	{url = 'https://github.com/akinsho/toggleterm.nvim'},
	{url = 'https://github.com/numToStr/Comment.nvim'},
	{url = 'https://github.com/roxma/vim-tmux-clipboard'},
	
})
