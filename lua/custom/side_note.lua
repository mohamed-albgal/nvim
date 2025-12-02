
local M = {}
local jou_funcs = require("custom.jou_funcs")

-- Function to get the current journal directory path
local function get_journal_dir()
  local current_time = os.date("*t")
  local year = current_time.year
  local month = string.format("%02d", current_time.month)
  local day = string.format("%02d", current_time.day)
  return os.getenv("HOME") .. "/VSCodeJournal/" .. year .. "/" .. month .. "/"
end

-- Function to create a directory if it doesn't exist
local function ensure_dir_exists(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

local function sanitize_note_name(input)
  if not input or input == "" then
    return nil
  end
  local trimmed = input:match("^%s*(.-)%s*$")
  if trimmed == "" then
    return nil
  end
  trimmed = trimmed:gsub("%.md$", "") -- allow folks to type foo.md
  trimmed = trimmed:gsub("%s+", "_")
  -- remove stray path separators to keep notes in the month folder
  trimmed = trimmed:gsub("[/\\]", "")
  return trimmed ~= "" and trimmed or nil
end

function M.side_note()
  local user_input = vim.fn.input("Side note name: ")
  local base_name = sanitize_note_name(user_input)
  if not base_name then
    print("No side note name provided")
    return
  end

  local filename = base_name .. ".md"
  local journal_dir = get_journal_dir()
  ensure_dir_exists(journal_dir)
  local note_filename = journal_dir .. filename

  local original_file = vim.fn.expand("%:p")
  local original_line_num = vim.fn.line(".")
  local header = string.format("< %s:%d >", original_file, original_line_num)

  local file_exists = vim.fn.filereadable(note_filename) == 1
  if not file_exists then
    local file = io.open(note_filename, "w")
    file:write(header .. "\n\n")
    file:close()
  end

  local todays_journal_path = jou_funcs.journalPath()
  local expanded_todays_path = vim.fn.expand(todays_journal_path)
  local todays_file = io.open(expanded_todays_path, "a")
  todays_file:write(string.format("[%s]\n", filename))
  todays_file:close()

  vim.cmd("edit " .. note_filename)
end

return M
