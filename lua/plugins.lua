-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use) 
  -- add you plugins here like:
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- LuaSnip for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- LuaSnip plugin (used by cmp)
  use {'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons'} -- Tab bar
  use 'morhetz/gruvbox' -- Theme
  use {"windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup {} end}
  use 'j-hui/fidget.nvim' -- Show LSP info bottom right
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}}}
  use {'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true }}
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'nvim-tree/nvim-tree.lua'
  end)
