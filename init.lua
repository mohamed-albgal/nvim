--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('bootstrap_lazy')
require('lazy').setup({ { import = 'custom.plugins' } })
require('custom.setup.core_setup')
require('custom.setup.tree_sitter_setup')
require('custom.keys')
require("custom.commands")
