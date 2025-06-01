--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ { import = 'custom.plugins' }, }, {}) -- must be before core

require('custom.keys')
require('custom.setup.core_setup')
require('custom.setup.theme_setup')

require 'luasnip'.filetype_extend("ruby", { "rails" })
require('custom.setup.tree_sitter_setup')
require('custom.setup.cmp_setup')
require('custom.setup.lsp_setup')
