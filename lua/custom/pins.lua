M = {}
local pinned_buffers = {}
local uv = vim.loop
local json = vim.fn.json_encode
local decode = vim.fn.json_decode
local fname = vim.fn.stdpath("data") .. "/pinned_buffers.json"

M.savePins = function()
  local paths = {}
  for _, buf in ipairs(pinned_buffers) do
    local path = vim.api.nvim_buf_get_name(buf)
    if path and path ~= "" then table.insert(paths, path) end
  end
  local fd = assert(uv.fs_open(fname, "w", 438))
  uv.fs_write(fd, json(paths), -1)
  uv.fs_close(fd)
end

local function loadPinsFromDisk()
  local fd = uv.fs_open(fname, "r", 438)
  if not fd then return end
  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)

  local paths = decode(data)
  pinned_buffers = {}
  for _, path in ipairs(paths) do
    local bufnr = vim.fn.bufnr(path, true)
    if vim.api.nvim_buf_is_valid(bufnr) then
      table.insert(pinned_buffers, bufnr)
    end
  end
end

-- remove the pinned_buffers.json file if it exists
local function RemovePinsFile()
  if uv.fs_stat(fname) then
    uv.fs_unlink(fname)
  end
end


local function PinBuffer(buf)
  -- Avoid duplicates
  for _, b in ipairs(pinned_buffers) do
    if b == buf then
      return
    end
  end

  -- Append new buffer
  table.insert(pinned_buffers, buf)

  -- Trim list to max 4
  if #pinned_buffers > 4 then
    table.remove(pinned_buffers, 1) -- remove oldest
  end

end

M.goToPinned = function(index)
  if not index or type(index) ~= "number" then
    print("Invalid buffer index")
    return
  end

  local buf = pinned_buffers[index]
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_set_current_buf(buf)
  else
    print("No valid buffer at index " .. tostring(index))
  end
end

M.pinThis = function()
  local buf = vim.api.nvim_get_current_buf()
  PinBuffer(buf)
end

-- Function to clear the pinned buffer table
M.clearPins = function()
  pinned_buffers = {}
  RemovePinsFile()
end

M.showPins =  function()
  if #pinned_buffers == 0 then
    loadPinsFromDisk()
  end

  if #pinned_buffers == 0 then
    return
  end

  local entries = {}

  for i, buf in ipairs(pinned_buffers) do
    local fullpath = vim.api.nvim_buf_get_name(buf)
    local relpath

    if fullpath and fullpath ~= "" then
      relpath = vim.fn.fnamemodify(fullpath, ":.")
    else
      relpath = "[No Name]"
    end

    table.insert(entries, string.format("%d: %s", i, relpath))
  end

  require('fzf-lua').fzf_exec(entries, {
    prompt = "Pinned Buffers> ",
    winopts = {
      height = 0.1,
      width = 0.2,
      row = 0.3,
      col = 0.5,
    },
    actions = {
      default = function(selected)
        local index = tonumber(string.match(selected[1], "^(%d+):"))
        if index then GoToPinned(index) end
      end
    }
  })
end

M.splitPins = function()
  if #pinned_buffers == 0 then
    loadPinsFromDisk()
  end

  for i, buf in ipairs(pinned_buffers) do
    if vim.api.nvim_buf_is_valid(buf) then
      -- hide all other buffers before splitting
      if i == 1 then
        vim.cmd("buffer " .. buf)
        -- if there are splits, close them
        if #vim.api.nvim_list_wins() > 1 then
          vim.cmd("only")
        end
      else
        vim.cmd("vsplit | buffer " .. buf)
      end
    else
      print("Invalid buffer at index " .. tostring(i))
    end
  end
end

M.hasPins = function()
  return #pinned_buffers > 0
end

return M


