
if vim.fn.exists("g:vscode") ~= 0 then
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.clipboard = 'unnamedplus'
  vim.keymap.set({ 'n', 'v' }, '<leader>', "<cmd>call VSCodeNotify('whichkey.show')<CR>")
  vim.keymap.set('n', 'gD', "<cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>")
  require('lazy').setup({
    { 'ggandor/lightspeed.nvim' },
  })
end
