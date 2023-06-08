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

require('plugins')
require('keymaps')

vim.cmd('colorscheme gruvbox')
-- bufferline
require("bufferline").setup{}

-- nvim lsp start
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip (used by nvim-cmp)
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })

-- nvim-cmp setup (better completion than default nvim completion)
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

-- nvim lsp end
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

-- lualine start
require('lualine').setup()
-- end lualine

require"fidget".setup{}

require("nvim-tree").setup()

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

vim.cmd('set shell=/usr/bin/zsh')
vim.cmd('set list')
vim.cmd('set listchars=tab:*\\ ,eol:¬,trail:~')
vim.wo.number = true
vim.wo.relativenumber = true

-------------------------------------------------------------------
-- Use nvim-osc52 as the default clipboard provider
-- If you use a terminal that supports the OSC52 escape
-- sequence everything that you delete and yank
-- will be in the system clipboard
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

------------------------------------------------------------------
-- Set Terminal automatically to insert mode
-- and hide line numbers in terminal mode
vim.cmd('autocmd BufEnter,BufNew term://* startinsert')
vim.cmd('autocmd BufEnter,BufNew term://* set laststatus=0')
vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber')
------------------------------------------------------------------
