-- save pins on VimLeavePre to data directory
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local pins = require("custom.pins")
    if pins.hasPins() then
      pins.savePins()
    end
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


