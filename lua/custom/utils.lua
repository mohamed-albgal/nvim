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

M.pasteBufferPath = function()
  local buf_path = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg('+', buf_path)
  print("Copied to clipboard: " .. buf_path)
end

M.map = function(arg)
  vim.keymap.set(arg.mode or 'n', arg.key, arg.cmd, { noremap = true, silent = true, desc = arg.desc })
end

M.toggleLineNums = function()
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

M.ff = function(f, ...)
  local args = {...}
  return function()
    f(unpack(args))
  end
end

M.rspecTermToggle = function()
	local floatTermBufnr = vim.fn["floaterm#terminal#get_bufnr"]("rspec")

	if floatTermBufnr ~= -1 then
		vim.cmd(":FloatermToggle rspec")
	else
		vim.cmd(":FloatermNew --width=0.99 --position=bottom --borderchars=─ --name=rspec --title=⚡")
		vim.cmd(":FloatermToggle rspec")
	end
end

M.ensureRspecTermVisible = function()
  local floatTermBufnr = vim.fn["floaterm#terminal#get_bufnr"]("rspec")
  if floatTermBufnr == -1 then
    vim.cmd(":FloatermNew --width=0.99 --position=bottom --borderchars=─ --name=rspec --title=⚡")
    return
  end

  if vim.fn.bufwinid(floatTermBufnr) == -1 then
    vim.cmd(":FloatermShow rspec")
  end
end

M.escape_highlights = function()
  vim.cmd('nohlsearch')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'n', true)
end

return M
