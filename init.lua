-------------------------------------------------------------------
-- Ensure that the lazy.nvim plugin manager is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Install Plugins and import keymaps
-- Both located in ~/.config/nvim/lua
require('plugins')
require('keymaps')
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Use the gruvbox scheme
vim.cmd('colorscheme gruvbox')
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Show Buffers as tabs on top
require("bufferline").setup{}
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Enable the LSP and use it with nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }

local rust_analyzer_settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
	}
}

for _, lsp in ipairs(servers) do
	if lsp == "rust_analyzer" then
		lspconfig[lsp].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = rust_analyzer_settings,
		}
	else
		lspconfig[lsp].setup {
			capabilities = capabilities,
		}
	end
end
-------------------------------------------------------------------
-------------------------------------------------------------------
-- LuaSnip provides default VSCode code snippets and
-- own ones located in ~/.config/nvim/snippets
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
-------------------------------------------------------------------

-------------------------------------------------------------------
-- nvim-cmp: completion engine plugin for neovim
-- used by LSP and LuaSnip
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["TAB"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ["S-TAB"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
-------------------------------------------------------------------

-------------------------------------------------------------------
-- A super powerful autopair plugin
-- Automatically closes brackets and so on...
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})
-------------------------------------------------------------------

-------------------------------------------------------------------
-- A blazing fast and easy to configure Neovim statusline
-- written in Lua
require('lualine').setup{
	options = {
		icons_enabled = false,
		theme = 'onedark',
		component_separators = '|',
		section_separators = '',
	}
}
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Show the status of the LSP bottom right
require"fidget".setup{
	window = {
		blend = 0,
  },
}
-------------------------------------------------------------------

-------------------------------------------------------------------
-- File Explorer
require("nvim-tree").setup()
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Plugin that highlights code in color
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "javascript", "typescript", 
    	"lua", "vim", "json", "html", "rust", "tsx" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
})
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Plugin that shows new Git lines in color
-- on the left
require('gitsigns').setup()
-------------------------------------------------------------------

-------------------------------------------------------------------
--  A horizontal terminal can be toggled by
--  pressing Ctrl+e
require("toggleterm").setup{
  open_mapping = [[<c-e>]],
  direction = 'horizontal',
  start_in_insert = true,
}
-------------------------------------------------------------------

require('leap').create_default_mappings()
vim.keymap.set('n', 's', function ()
  require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
end)
-------------------------------------------------------------------
-- Use nvim-osc52 as the default clipboard provider
-- If you use a terminal that supports the OSC52 escape
-- sequence (e.g. Alacritty on Linux or iTerm2 on macOS)
-- everything that you delete and yank will be copied
-- to the system clipboard
require('osc52').setup {
  max_length = 0,      -- Maximum length of selection (0 for no limit)
  silent     = true,  -- Disable message on successful copy
  trim       = false,  -- Trim surrounding whitespaces before copy
}

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}
vim.opt.clipboard = "unnamedplus"
------------------------------------------------------------------

require('Comment').setup()

------------------------------------------------------------------
-- Set Terminal automatically to insert mode
-- and hide line numbers in terminal mode
vim.cmd('autocmd BufEnter,BufNew term://* startinsert')
vim.cmd('autocmd BufEnter,BufNew term://* set laststatus=0')
vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber nobuflisted')
------------------------------------------------------------------

vim.cmd('set shell=/usr/bin/zsh')
vim.cmd('set list')
vim.cmd('set listchars=tab:*\\ ,eol:¬,trail:~')
vim.wo.number = true
vim.wo.relativenumber = true
