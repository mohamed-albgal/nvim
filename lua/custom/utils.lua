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
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local path_with_line = buf_path .. ":" .. line_number
  vim.fn.setreg('+', path_with_line)
  print("Copied to clipboard: " .. path_with_line)
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

M.resizeCurrentFloat = function(width_ratio, height_ratio)
  local win = vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(win)
  if config.relative == "" then
    return false
  end

  local total_width = vim.o.columns
  local total_height = vim.o.lines - vim.o.cmdheight

  local width = math.floor(total_width * (width_ratio or 0.9))
  local height = math.floor(total_height * (height_ratio or 0.9))
  width = math.max(1, math.min(width, total_width))
  height = math.max(1, math.min(height, total_height))

  local row = math.floor((total_height - height) / 2)
  local col = math.floor((total_width - width) / 2) - 1

  vim.api.nvim_win_set_config(win, vim.tbl_extend("force", config, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
  }))

  return true
end

return M
