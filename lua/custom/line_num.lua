M = {}
M.toggle = function()
  local rel_num = vim.wo.relativenumber
  local num = vim.wo.number
  if num then
    vim.wo.relativenumber = true
    vim.wo.number = false
  elseif rel_num then
      vim.wo.relativenumber = false
      vim.wo.number = false
  else
    vim.wo.number = true
  end
end

return M
