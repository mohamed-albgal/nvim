M = {}
M.toggle = function()
  if vim.wo.number then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
  end
end

M.toggleRelative = function()
  if vim.wo.relativenumber then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end

return M
