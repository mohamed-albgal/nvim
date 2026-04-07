local M = {}
local uv = vim.uv
local json = vim.json
local state_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "custom-pins")
local fname = vim.fs.joinpath(state_dir, "pins.json")
local legacy_fname = vim.fs.joinpath(vim.fn.stdpath("data"), "pinned_buffers.json")

local pinned_buffers = {}
-- current_project_root tracks which project's pins are loaded in memory.
local current_project_root = nil

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.WARN, { title = "custom.pins" })
end

local function flash(message, highlight)
  vim.api.nvim_echo({ { message, highlight or "ModeMsg" } }, false, {})
end

local function refresh_statusline()
  local ok, lualine = pcall(require, "lualine")
  if ok then
    lualine.refresh({ scope = "window", place = { "statusline" } })
  end
end


-- =============================================================================
-- Core Project-Aware Helper Functions (NEW)
-- =============================================================================

--- Gets the root directory for the current project.
-- Uses the current working directory as the project identifier.
-- @return string: The absolute path of the current working directory.
local function get_project_root()
  return uv.cwd()
end

local function read_file(path)
  local fd = uv.fs_open(path, "r", 438)
  if not fd then
    return nil
  end

  local stat = uv.fs_fstat(fd)
  if not stat or stat.size == 0 then
    uv.fs_close(fd)
    return ""
  end

  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  return data
end

local function ensure_state_dir()
  local ok, err = uv.fs_mkdir(state_dir, 448)
  if ok or (err and err:match("EEXIST")) then
    return true
  end

  notify("Failed to create pin state directory: " .. err, vim.log.levels.ERROR)
  return false
end

local function decode_pin_data(raw, path)
  if not raw or raw == "" then
    return {}
  end

  local ok, decoded = pcall(json.decode, raw)
  if ok and type(decoded) == "table" then
    return decoded
  end

  notify("Failed to decode pin database: " .. path, vim.log.levels.ERROR)
  return {}
end

--- Loads the entire pin database from disk.
-- The database is a table where keys are project paths and values are lists of file paths.
-- @return table: The decoded table of all pins for all projects.
local function load_all_pins_from_disk()
  local raw = read_file(fname)
  if raw ~= nil then
    return decode_pin_data(raw, fname)
  end

  local legacy_raw = read_file(legacy_fname)
  if legacy_raw ~= nil then
    return decode_pin_data(legacy_raw, legacy_fname)
  end

  return {}
end

local function write_file_atomic(path, content)
  if not ensure_state_dir() then
    return false
  end

  local tmp_path = path .. ".tmp"
  local fd, open_err = uv.fs_open(tmp_path, "w", 420)
  if not fd then
    notify("Failed to open temp pin file: " .. open_err, vim.log.levels.ERROR)
    return false
  end

  local ok, write_err = uv.fs_write(fd, content, 0)
  uv.fs_close(fd)

  if not ok then
    uv.fs_unlink(tmp_path)
    notify("Failed to write temp pin file: " .. write_err, vim.log.levels.ERROR)
    return false
  end

  local renamed, rename_err = uv.fs_rename(tmp_path, path)
  if not renamed then
    uv.fs_unlink(tmp_path)
    notify("Failed to replace pin file: " .. rename_err, vim.log.levels.ERROR)
    return false
  end

  return true
end

local function get_current_project_paths()
  local paths = {}

  for _, buf in ipairs(pinned_buffers) do
    local path = vim.api.nvim_buf_get_name(buf)
    if path ~= "" then
      paths[#paths + 1] = path
    end
  end

  return paths
end

local function rebuild_pinned_buffers(project_paths)
  local buffers = {}

  for _, path in ipairs(project_paths) do
    local bufnr = vim.fn.bufnr(path, true)
    if vim.api.nvim_buf_is_valid(bufnr) then
      buffers[#buffers + 1] = bufnr
    end
  end

  pinned_buffers = buffers
end

--- Loads the pins for the current project into the `pinned_buffers` variable.
local function load_pins_for_current_project()
  local project_root = get_project_root()
  local all_pins = load_all_pins_from_disk()
  rebuild_pinned_buffers(all_pins[project_root] or {})
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

  if uv.fs_stat(legacy_fname) then
    uv.fs_unlink(legacy_fname)
  end
end

--- Pins a buffer, adding it to the in-memory list for the current project.
-- @param buf (number): The buffer number to pin.
local function pin_buffer(buf)
  -- Avoid duplicate pins.
  for _, b in ipairs(pinned_buffers) do
    if b == buf then
      return false
    end
  end

  table.insert(pinned_buffers, buf)
  return true
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
  local current_project_paths = get_current_project_paths()

  if #current_project_paths > 0 then
    all_pins[project_root] = current_project_paths
  else
    all_pins[project_root] = nil
  end

  if not next(all_pins) then
    remove_pins_file()
  else
    if write_file_atomic(fname, json.encode(all_pins)) and uv.fs_stat(legacy_fname) then
      uv.fs_unlink(legacy_fname)
    end
  end

  refresh_statusline()
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
  if pin_buffer(buf) then
    flash("[pin]")
    refresh_statusline()
  else
    flash("[pin exists]", "Comment")
  end
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

  local function populate_entries(entries)
    for i = #entries, 1, -1 do
      entries[i] = nil
    end

    for i, buf in ipairs(pinned_buffers) do
      if vim.api.nvim_buf_is_valid(buf) then
        local fullpath = vim.api.nvim_buf_get_name(buf)
        local relpath = (fullpath and fullpath ~= "") and vim.fn.fnamemodify(fullpath, ":.") or "[No Name]"
        table.insert(entries, string.format("%d: %s", i, relpath))
      end
    end

    return entries
  end

  local entries = populate_entries({})

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
          end

          M.savePins()
          populate_entries(entries)
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
  require('custom.utils').ensureRspecTermVisible()
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

local function cycle_pin(direction)
  ensure_correct_project_context()
  if #pinned_buffers == 0 then return end

  local current_buf_nr = vim.api.nvim_get_current_buf()
  local current_index

  for i, buf_nr in ipairs(pinned_buffers) do
    if buf_nr == current_buf_nr then
      current_index = i
      break
    end
  end

  local target_index
  if current_index then
    target_index = ((current_index - 1 + direction) % #pinned_buffers) + 1
  else
    target_index = direction > 0 and 1 or #pinned_buffers
  end

  local target_buf_nr = pinned_buffers[target_index]

  if vim.api.nvim_buf_is_valid(target_buf_nr) then
    vim.api.nvim_set_current_buf(target_buf_nr)
  else
    table.remove(pinned_buffers, target_index)
  end
end

--- Cycles to the next pinned buffer.
M.nextPin = function()
  cycle_pin(1)
end

--- Cycles to the previous pinned buffer.
M.prevPin = function()
  cycle_pin(-1)
end

--- Checks if there are any pins for the current project.
-- @return boolean: True if pins exist, false otherwise.
M.hasPins = function()
  ensure_correct_project_context()
  return #pinned_buffers > 0
end

M.isPinned = function(bufnr)
  ensure_correct_project_context()
  local target = bufnr or vim.api.nvim_get_current_buf()

  for _, pinned in ipairs(pinned_buffers) do
    if pinned == target then
      return true
    end
  end

  return false
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
