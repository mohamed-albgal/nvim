local M = {}
local uv = vim.loop
local json = vim.fn.json_encode
local decode = vim.fn.json_decode
local fname = vim.fn.stdpath("data") .. "/pinned_buffers.json"

local pinned_buffers = {}
-- current_project_root tracks which project's pins are loaded in memory.
local current_project_root = nil


-- =============================================================================
-- Core Project-Aware Helper Functions (NEW)
-- =============================================================================

--- Gets the root directory for the current project.
-- Uses the current working directory as the project identifier.
-- @return string: The absolute path of the current working directory.
local function get_project_root()
  return vim.loop.cwd()
end

--- Loads the entire pin database from the JSON file.
-- The database is a table where keys are project paths and values are lists of file paths.
-- @return table: The decoded table of all pins for all projects.
local function load_all_pins_from_disk()
  local fd = uv.fs_open(fname, "r", 438)
  if not fd then return {} end

  local stat = uv.fs_fstat(fd)
  -- If file is empty or stat fails, close and return an empty table.
  if not stat or stat.size == 0 then
    uv.fs_close(fd)
    return {}
  end

  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)

  -- Use pcall for safety against malformed or empty JSON data.
  local ok, all_pins_data = pcall(decode, data)
  if ok and type(all_pins_data) == 'table' then
    return all_pins_data
  end

  return {}
end

--- Loads the pins for the current project into the `pinned_buffers` variable.
local function load_pins_for_current_project()
  local project_root = get_project_root()
  local all_pins = load_all_pins_from_disk()
  local project_paths = all_pins[project_root] or {}

  -- Clear any previously loaded pins.
  pinned_buffers = {}
  for _, path in ipairs(project_paths) do
    -- Create a buffer for the path if one doesn't exist yet.
    local bufnr = vim.fn.bufnr(path, true)
    -- We only load pins for which the buffer could be successfully created/found.
    if vim.api.nvim_buf_is_valid(bufnr) then
      table.insert(pinned_buffers, bufnr)
    end
  end
end

--- Ensures that the pins loaded in memory are for the current project directory.
-- If the project directory has changed, it reloads the pins.
-- This is the core function that makes the plugin context-aware.
local function ensure_correct_project_context()
  local project_root = get_project_root()
  if current_project_root ~= project_root then
    current_project_root = project_root
    load_pins_for_current_project()
  end
end


-- =============================================================================
-- Internal Helper Functions
-- =============================================================================

--- Removes the pins file from disk.
-- Used when the last project's pins are cleared.
local function remove_pins_file()
  if uv.fs_stat(fname) then
    uv.fs_unlink(fname)
  end
end

--- Pins a buffer, adding it to the in-memory list for the current project.
-- @param buf (number): The buffer number to pin.
local function pin_buffer(buf)
  -- Avoid duplicate pins.
  for _, b in ipairs(pinned_buffers) do
    if b == buf then
      return
    end
  end

  table.insert(pinned_buffers, buf)

  -- Optional: Trim the list to a maximum size.
  if #pinned_buffers > 4 then
    table.remove(pinned_buffers, 1) -- remove the oldest pin
  end
end


-- =============================================================================
-- Public API Functions (Exported in M)
-- =============================================================================

--- Saves the in-memory pins for the current project to the JSON file.
-- This function now intelligently updates only the entry for the current project.
M.savePins = function()
  ensure_correct_project_context()
  local project_root = get_project_root()
  local all_pins = load_all_pins_from_disk()

  local current_project_paths = {}
  for _, buf in ipairs(pinned_buffers) do
    local path = vim.api.nvim_buf_get_name(buf)
    if path and path ~= "" then
      table.insert(current_project_paths, path)
    end
  end

  if #current_project_paths > 0 then
    -- Update the pins for the current project.
    all_pins[project_root] = current_project_paths
  else
    -- If there are no pins for the current project, remove its entry from the table.
    all_pins[project_root] = nil
  end

  -- Check if the all_pins table is now empty.
  if not next(all_pins) then
    remove_pins_file()
  else
    local file_content = json(all_pins)
    local fd = assert(uv.fs_open(fname, "w", 438))
    uv.fs_write(fd, file_content, -1)
    uv.fs_close(fd)
  end
end

--- Unpin the current buffer.
M.unpinThis = function()
  ensure_correct_project_context()
  local buf = vim.api.nvim_get_current_buf()
  for i, b in ipairs(pinned_buffers) do
    if b == buf then
      require('custom.pins').removePin(i)
      break
    end
  end
end

--- Pins the current buffer.
M.pinThis = function()
  ensure_correct_project_context()
  local buf = vim.api.nvim_get_current_buf()
  pin_buffer(buf)
  -- Note: This function doesn't save automatically. Call savePins on an autocommand.
end

--- Clears all pins for the CURRENT project.
M.clearPins = function()
  ensure_correct_project_context()
  pinned_buffers = {}
  -- Save the state to remove the project's entry from the JSON file.
  M.savePins()
end

--- Shows the list of pinned buffers for the current project using fzf-lua.
M.showPins = function()
  ensure_correct_project_context()

  -- if #pinned_buffers == 0 then
  --   print("No pinned buffers for this project.")
  --   return
  -- end
  --
  local entries = {}
  for i, buf in ipairs(pinned_buffers) do
    -- make sure the buffer is valid before trying to get its name
    if not vim.api.nvim_buf_is_valid(buf) then  goto continue end
    local fullpath = vim.api.nvim_buf_get_name(buf)
    local relpath = (fullpath and fullpath ~= "") and vim.fn.fnamemodify(fullpath, ":.") or "[No Name]"
    table.insert(entries, string.format("%d: %s", i, relpath))
    ::continue::
  end

  require('fzf-lua').fzf_exec(entries, {
    prompt = "Pinned Buffers> ",
    winopts = { height = 0.15, width = 0.45, row = 0.3, col = 0.5 },
    actions = {
      default = function(selected)
        local index = tonumber(string.match(selected[1], "^(%d+):"))
        if index then M.goToPinned(index) end
      end,
      -- Action to remove selected pins.
      ["tab"] = {
        fn = function(selected)
          local indices_to_remove = {}
          for _, sel in ipairs(selected) do
            local index = tonumber(string.match(sel, "^(%d+):"))
            if index then table.insert(indices_to_remove, index) end
          end

          -- Sort indices in descending order to avoid messing up indices
          -- of subsequent items to be removed.
          table.sort(indices_to_remove, function(a, b) return a > b end)

          for _, index in ipairs(indices_to_remove) do
            table.remove(pinned_buffers, index)
            table.remove(entries, index)
          end

          M.savePins()
        end,
        -- This tells fzf-lua to re-run the provider function (get_pin_entries)
        -- to refresh the list that is displayed.
        reload = true,
        desc = "Remove Pin",
      },
    }
  })
end

M.runAndPin = function(whole)
  ensure_correct_project_context()
  -- make sure  file ends with _spec.rb
  local cmd = require("custom.run_rspec").rspec_command(whole)
  if not cmd then
    print("Not a test file.")
    return
  end
  require('custom.utils').rspecTermToggle()
  vim.cmd("FloatermSend! --name=rspec " .. cmd)
end

--- Jumps to the pinned buffer at the given index.
-- @param index (number): The 1-based index of the pin to jump to.
M.goToPinned = function(index)
  ensure_correct_project_context()
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

--- Cycles to the next pinned buffer.
M.nextPin = function()
  ensure_correct_project_context()

  if #pinned_buffers == 0 then return end

  local current_buf_nr = vim.api.nvim_get_current_buf()
  local current_found_at_idx = 0
  for i, buf_nr in ipairs(pinned_buffers) do
    if buf_nr == current_buf_nr then
      current_found_at_idx = i
      break
    end
  end

  local next_index = (current_found_at_idx > 0) and (current_found_at_idx % #pinned_buffers) + 1 or 1
  local next_buf_nr = pinned_buffers[next_index]

  if vim.api.nvim_buf_is_valid(next_buf_nr) then
    vim.api.nvim_set_current_buf(next_buf_nr)
  else
    table.remove(pinned_buffers, next_index)
  end
end

--- Checks if there are any pins for the current project.
-- @return boolean: True if pins exist, false otherwise.
M.hasPins = function()
  ensure_correct_project_context()
  return #pinned_buffers > 0
end

M.removePin = function(index)
  ensure_correct_project_context()

  if not index or type(index) ~= "number" or index < 1 or index > #pinned_buffers then
    return
  end

  table.remove(pinned_buffers, index)
  M.savePins() -- Save the updated state after removing a pin.
end

return M


