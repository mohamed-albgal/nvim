vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('bootstrap_lazy')
require('lazy').setup({ { import = 'custom.plugins' } })
require('custom.setup.core_setup')
require('custom.setup.tree_sitter_setup')
require('custom.keys')
require("custom.commands")
require("custom.setup.vscode_theme_setup")
