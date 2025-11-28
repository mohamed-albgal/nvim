vim.o.ignorecase = true
vim.o.smartcase  = true
vim.o.clipboard  = 'unnamedplus'
vim.keymap.set({ 'n', 'v' }, '<leader>', "<cmd>call VSCodeNotify('whichkey.show')<CR>")
vim.keymap.set('n', 'gD', "<cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>")
