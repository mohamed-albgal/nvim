local pinned_buffers = {}

local function PinBuffer(buf)
  -- Avoid duplicates
  for _, b in ipairs(pinned_buffers) do
    if b == buf then
      print("Buffer already pinned")
      return
    end
  end

  -- Append new buffer
  table.insert(pinned_buffers, buf)

  -- Trim list to max 4
  if #pinned_buffers > 4 then
    table.remove(pinned_buffers, 1) -- remove oldest
  end

  print("Added buffer " .. buf .. " to pinned buffers")
end

local function GoToPinnedBuffer(index)
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

local fzf = require'fzf-lua'

local function AddCurrentBufferToPinneds()
  local buf = vim.api.nvim_get_current_buf()
  PinBuffer(buf)
end

-- Function to clear the pinned buffer table
local function ClearPinnedBuffers()
  pinned_buffers = {}
  print("Pinned buffers cleared")
end

local function ShowPinnedBuffers()
  if #pinned_buffers == 0 then
    print("No pinned buffers")
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
        if index then GoToPinnedBuffer(index) end
      end
    }
  })
end

local function SplitPins()
  if #pinned_buffers == 0 then
    return
  end

  for i, buf in ipairs(pinned_buffers) do
    if vim.api.nvim_buf_is_valid(buf) then
      -- hide all other buffers before splitting
      if i == 1 then
        vim.cmd("buffer " .. buf)
        vim.cmd("only")
      else
        vim.cmd("vsplit | buffer " .. buf)
      end
    else
      print("Invalid buffer at index " .. tostring(i))
    end
  end
end

return {
  pinThis = AddCurrentBufferToPinneds,
  GoToPinned = GoToPinnedBuffer,
  ShowPins = ShowPinnedBuffers,
  ClearPins = ClearPinnedBuffers,
  SplitPins = SplitPins
}


