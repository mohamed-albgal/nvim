vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('bootstrap_lazy')
if vim.g.vscode then
  require('lazy').setup({ spec = { { import = 'custom.plugins.flash' } } })
  require('custom.setup.vscode_setup')
else
  require('lazy').setup({ spec = { { import = 'custom.plugins' } } })
  require('custom.setup.core_setup')
  require('custom.setup.tree_sitter_setup')
  require('custom.keys')
  require('custom.commands')
  require('custom.setup.vscode_theme_setup')
end
