local M = {}

M.bufFormat = function(whole)
  local pos = vim.fn.getpos('.')
  local f = "vap="
  if whole then
    f = " ggVG="
  end
  vim.cmd("normal!" .. f)
  vim.fn.setpos('.', pos)
end

M.toggleVirtualLines = function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end

M.toggleVirtualUnderlines = function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

M.map = function(arg)
  vim.keymap.set(arg.mode or 'n', arg.key, arg.cmd, { noremap = true, silent = true, desc = arg.desc })
end

return M

