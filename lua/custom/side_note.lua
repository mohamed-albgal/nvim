-- lua/sidenote.lua

local M = {}

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

-- Helper function to determine the base filename for a side note from selected text
local function get_filename_base_from_selection(text)
  -- Priority 1: Check for a perfect wiki-link match first (e.g., "[[my_note.md]]")
  local wiki_match = text:match("^%[%[(.*)%]%]$")
  if wiki_match then
    -- Return the content inside the brackets, stripping a potential .md for the base name
    return wiki_match:gsub("%.md$", "")
  end

  -- Priority 2: If not a full wiki-link, check if the text itself ends with .md
  -- This handles selecting "frog.md" when it's inside "[[frog.md]]"
  if text:match("%.md$") then
    -- Also perform basic validation that it looks like a valid filename segment
    if text:match("^[^%s%/]+%.md$") then -- Matches "word.md" or "word_word.md", etc.
      return text:gsub("%.md$", "") -- Return the base name without .md
    end
  end

  -- If neither condition is met, it's considered new text that needs a new link
  return nil
end

function M.side_note()
  -- Get 1-indexed, inclusive visual selection positions
  local start_line_1_idx, start_col_1_idx = vim.fn.getpos("'<")[2], vim.fn.getpos("'<")[3]
  local end_line_1_idx, end_col_1_idx = vim.fn.getpos("'>")[2], vim.fn.getpos("'>")[3]

  -- Convert to 0-indexed, exclusive API compatible column numbers
  local start_col_0_idx = start_col_1_idx - 1
  local end_col_0_idx_exclusive = end_col_1_idx

  -- Get the visually selected text from the buffer
  local selected_lines = vim.api.nvim_buf_get_text(
    0,
    start_line_1_idx - 1,
    start_col_0_idx,
    end_line_1_idx - 1,
    end_col_0_idx_exclusive,
    {}
  )
  -- Concatenate lines in case of multi-line selection
  local selected_text_raw = table.concat(selected_lines, "")

  -- Trim leading/trailing whitespace and newlines for robust pattern matching
  local trimmed_selected_text = selected_text_raw:gsub("[\r\n]", ""):match("^%s*(.-)%s*$") or selected_text_raw

  local link_display_text    -- The text that will appear inside [[...]] (e.g., "my_note.md")
  local filename_for_file    -- The actual .md filename (e.g., "my_note.md")

  -- Try to identify the filename base if the selection looks like an existing link or its content
  local identified_filename_base = get_filename_base_from_selection(trimmed_selected_text)

  if identified_filename_base then
    -- This branch handles both perfect [[...]] selections AND "frog.md" selections
    -- It means we're dealing with an existing (or intended) side note file.
    link_display_text = identified_filename_base .. ".md" -- Always ensure the link display has .md
    filename_for_file = identified_filename_base .. ".md" -- The actual file name must also have .md

    local journal_dir = get_journal_dir()
    ensure_dir_exists(journal_dir)
    local note_filename = journal_dir .. filename_for_file

    vim.cmd("edit " .. note_filename)
  else
    -- This branch handles truly new, unwrapped text that needs to be created and linked.

    -- The text to display in the link (e.g., "sample.md")
    link_display_text = trimmed_selected_text .. ".md"
    -- The base name for the file (e.g., "sample") will be underscored
    filename_for_file = trimmed_selected_text:gsub("%s+", "_") .. ".md"

    local journal_dir = get_journal_dir()
    ensure_dir_exists(journal_dir)
    local note_filename = journal_dir .. filename_for_file

    local original_journal_file = vim.fn.expand("%:p")
    local original_line_num = start_line_1_idx

    vim.api.nvim_buf_set_text(
      0,
      start_line_1_idx - 1,
      start_col_0_idx,
      end_line_1_idx - 1,
      end_col_0_idx_exclusive,
      {"[[" .. link_display_text .. "]]"}
    )

    local file_exists = vim.fn.filereadable(note_filename) == 1
    vim.cmd("edit " .. note_filename)

    if not file_exists then
      local pre_word = "< " .. link_display_text .. " from "
      vim.api.nvim_buf_set_lines(0, 0, 0, false, {pre_word .. original_journal_file .. ":" .. original_line_num .. " >"})
    end
  end
end

return M
