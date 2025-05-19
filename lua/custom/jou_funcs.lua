local function get_or_create_journal_path()
  -- Get the current date
  local current_date = os.date("%A, %B %d %Y")
  local current_year = os.date("%Y")
  local current_month = os.date("%m")
  local current_day = os.date("%d")

  -- Define the journal directory and file path
  local journal_directory = string.format("~/VSCodeJournal/%s/%s/", current_year, current_month)
  local journal_filename = string.format("%s.md", current_day)

  -- Expand the tilde (~) to the home directory
  journal_directory = vim.fn.expand(journal_directory)

  -- Combine the directory and filename to create the full journal path
  local journal_path = journal_directory .. journal_filename

  -- Check if the journal file already exists
  if vim.fn.filereadable(journal_path) == 0 then
    -- If the file doesn't exist, create it with default content
    vim.fn.mkdir(journal_directory, "p")  -- Create the directory if it doesn't exist
    -- vscode mermaid uses triple colon ':::' to separate tasks and notes, while neovim mermaid uses triple backtick '```' keep this in mind in case I need to port this to vscode
    local initial_content = string.format("# %s\n\n:::mermaid\nflowchart RL\nid1>Tasks]\n::: \n\n\n:::mermaid\nflowchart RL\nid1>Notes]\n:::  \n\n\n", current_date)
    local file = io.open(journal_path, "w")
    file:write(initial_content)
    file:close()
  end

  return journal_path
end

local function open_previous_journal_entry(just_return_path)
  local max_days_back = 90
  local current_buffer = vim.fn.expand('%:p')
  local journal_pattern = "VSCodeJournal/(%d+)/(%d+)/(%d+)%.md"

  -- Extract the current journal entry date from the buffer name
  local year, month, day = current_buffer:match(journal_pattern)
  if not year or not month or not day then
    print("No journal entry buffer is open")
    return
  end

  local current_date = { year = tonumber(year), month = tonumber(month), day = tonumber(day) }

  -- local function to get the previous journal file path with leading zeros for the day
  local function get_journal_path(date_table)
    local journal_directory = string.format("~/VSCodeJournal/%d/%02d/", date_table.year, date_table.month)
    return journal_directory .. string.format("%02d.md", date_table.day)
  end

  -- Check if the journal buffer is already open
  local function buffer_exists(path)
    return vim.fn.bufnr(path) ~= -1
  end

  while max_days_back > 0 do
    -- Move to the previous day
    current_date.day = current_date.day - 1
    if current_date.day < 1 then
      current_date.month = current_date.month - 1
      if current_date.month < 1 then
        current_date.month = 12
        current_date.year = current_date.year - 1
      end
      current_date.day = os.date("*t", os.time{year=current_date.year, month=current_date.month+1, day=0}).day
    end

    local journal_path = get_journal_path(current_date)
    if just_return_path then
      return journal_path
    end
    if buffer_exists(journal_path) then
      vim.cmd("buffer " .. vim.fn.bufnr(journal_path))
      return
    elseif vim.fn.filereadable(vim.fn.expand(journal_path)) == 1 then
      vim.cmd("e " .. vim.fn.expand(journal_path))
      return
    end

    max_days_back = max_days_back - 1
  end
end

-- resume this when i have time.........
local function get_previous_todos()
  -- if a journal entry has todos, they are marked with '- [ ]' in the journal file
  -- check the last journal, and extract the todos from it, and append them to today's journal todos
  -- todos are always located after the first line that starts with '::: ' (triple colon and a space) when the line that starts with :::mermaid is encountered, the todos are over
  local last_journal_path = open_previous_journal_entry(true)
  local todos = {}
  local in_todos = false
  for line in io.lines(last_journal_path) do
    if in_todos then
      if line:match(":::mermaid") then
        break
      end
      if line:match("- %[%s%]") then
        table.insert(todos, line)
      end
    end
    if line:match("::: $") then
      in_todos = true
    end
  end

  -- append the todos to today's journal (there may already be todos in today's journal, so prepend lines as needed and insert them after the first line that starts with '::: ')
  local journal_path = get_or_create_journal_path()
  local file_contents = {}
  for line in io.lines(journal_path) do
    table.insert(file_contents, line)
  end
end


local function open_next_journal_entry()
  local max_days_forward = 90
  local current_buffer = vim.fn.expand('%:p')
  local journal_pattern = "VSCodeJournal/(%d+)/(%d+)/(%d+)%.md"

  -- Extract the current journal entry date from the buffer name
  local year, month, day = current_buffer:match(journal_pattern)
  if not year or not month or not day then
    print("No journal entry buffer is open")
    return
  end

  local current_date = { year = tonumber(year), month = tonumber(month), day = tonumber(day) }

  -- local function to get the next journal file path with leading zeros for the day
  local function get_journal_path(date_table)
    local journal_directory = string.format("~/VSCodeJournal/%d/%02d/", date_table.year, date_table.month)
    return journal_directory .. string.format("%02d.md", date_table.day)
  end

  -- Check if the journal buffer is already open
  local function buffer_exists(path)
    return vim.fn.bufnr(path) ~= -1
  end

  while max_days_forward > 0 do
    -- Move to the next day
    current_date.day = current_date.day + 1
    local days_in_month = os.date("*t", os.time{year=current_date.year, month=current_date.month+1, day=0}).day
    if current_date.day > days_in_month then
      current_date.day = 1
      current_date.month = current_date.month + 1
      if current_date.month > 12 then
        current_date.month = 1
        current_date.year = current_date.year + 1
      end
    end

    local journal_path = get_journal_path(current_date)
    if buffer_exists(journal_path) then
      vim.cmd("buffer " .. vim.fn.bufnr(journal_path))
      return
    elseif vim.fn.filereadable(vim.fn.expand(journal_path)) == 1 then
      vim.cmd("e " .. vim.fn.expand(journal_path))
      return
    end

    max_days_forward = max_days_forward - 1
  end
end

-- function to add a task to today's journal
local function add_task_to_journal ()
  local journal_path = get_or_create_journal_path()

  -- Prompt for input from the command line
  local my_input = vim.fn.input("Enter your task: ")
  if my_input == "" then
    return
  else
    -- append the name of the current file and the line number to the task (with a colon separator)
    my_input = my_input .. " --> " .. vim.fn.expand("%") .. ":" .. vim.fn.line(".")
  end

  -- Read the contents of the journal file
  local file_contents = {}
  for line in io.lines(journal_path) do
    table.insert(file_contents, line)
  end

  -- Find the line with ":::" and insert the task after it
  local found = false
  for i, line in ipairs(file_contents) do
    if line:match("::: $") then
      table.insert(file_contents, i + 1, "- [ ] " .. my_input)
      found = true
      break
    end
  end

  -- Write the modified contents back to the file
  local file = io.open(journal_path, "w")
  for _, line in ipairs(file_contents) do
    file:write(line .. "\n")
  end
  file:close()

  if found then
    print(" ---------------------------------------------------------------------------------------- ADDED.")
  else
    print(" --- unable to add.")
  end
end

-- function to open or create today's journal
local function open_or_create_journal()
  local journal_path = get_or_create_journal_path()

  -- Open the journal file in a new buffer
  vim.cmd("e " .. journal_path)
end

local function wrap_wiki_link()
  local start_pos = vim.fn.getpos("'<")
  local end_pos   = vim.fn.getpos("'>")
  local ls, cs = start_pos[2]-1, start_pos[3]-1
  local le, ce = end_pos[2]-1, end_pos[3]

  -- Safely get selection text
  local ok, lines = pcall(vim.api.nvim_buf_get_text, 0, ls, cs, le, ce, {})
  if not ok or #lines == 0 then
    print("No selection to wrap")
    return
  end

  -- Concatenate selection text
  local text = table.concat(lines, "\n")

  -- Early exit if selection already inside a wiki link
  if ls == le then
    local line = vim.api.nvim_buf_get_lines(0, ls, ls+1, false)[1]
    local start_col = cs + 1
    local end_col = ce
    if start_col > 2 and end_col < #line - 1 then
      local before = line:sub(start_col - 2, start_col - 1)
      local after  = line:sub(end_col + 1, end_col + 2)
      if before == "[[" and after == "]]" then
        print("Selection is already within a wiki link")
        return
      end
    end
  end

  local link = "[[" .. text .. "]]"

  -- Replace selection with wiki link
  vim.api.nvim_buf_set_text(0, ls, cs, le, ce, {link})
end

-- Create a side note file based on the visual selection, and wrap selection as wiki link
local function side_note()
  -- Extract the selected text for file naming
  local start_pos = vim.fn.getpos("'<")
  local end_pos   = vim.fn.getpos("'>")
  local ls, cs = start_pos[2], start_pos[3]
  local le, ce = end_pos[2], end_pos[3]

  local ok, lines = pcall(vim.api.nvim_buf_get_text, 0, ls-1, cs-1, le-1, ce, {})
  if not ok or #lines == 0 then
    print("No selection found for side note")
    return
  end

  -- Build file name from selection
  local file_name = table.concat(lines, "\n"):gsub("%s+", "")
  if file_name == "" then
    print("Invalid file name from selection")
    return
  end

  -- Wrap the original visual selection as a wiki link
  wrap_wiki_link()

  -- Prepare journal path
  local year, month = os.date("%Y"), os.date("%m")
  local dir = string.format("%s/VSCodeJournal/%s/%s", os.getenv("HOME"), year, month)
  local path = dir .. "/" .. file_name

  -- Switch to existing buffer if open
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == path then
      vim.api.nvim_set_current_buf(buf)
      print("Opened existing note: " .. path)
      return
    end
  end

  -- Create directory and file if needed
  vim.fn.mkdir(dir, "p")
  local created = false
  if vim.fn.filereadable(path) == 0 then
    local f = io.open(path, "w")
    if f then
      f:write(string.format("<from %s:%d\n\n", vim.fn.expand("%:p"), vim.fn.line(".")))
      f:close()
      created = true
    end
  end

  -- Open the new note
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  if created then vim.cmd("normal! G") end
end
local function side_note_context()
  -- Read the first few lines of the current buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, 5, false)
  local from_line = nil

  for _, line in ipairs(lines) do
    if line:match("^<from .+:%d+$") then
      from_line = line
      break
    end
  end

  if not from_line then
    print("No <from ...> line found at top of file.")
    return
  end

  -- Parse <from /full/path/to/file:123>
  local path, line_str = from_line:match("^<from%s+(.+):(%d+)$")
  if not path or not line_str then
    print("Malformed <from ...> line.")
    return
  end

  local line_number = tonumber(line_str)

  -- Check if the file is already open
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == path then
      vim.api.nvim_set_current_buf(buf)
      vim.api.nvim_win_set_cursor(0, { line_number, 0 })
      print("Switched to buffer: " .. path)
      return
    end
  end

  -- Otherwise, open the file
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  vim.api.nvim_win_set_cursor(0, { line_number, 0 })
end

return {
  openNext = open_next_journal_entry,
  openPrev = open_previous_journal_entry,
  openToday = open_or_create_journal,
  addTask = add_task_to_journal,
  journalPath = get_or_create_journal_path,
  getPrevTodos = get_previous_todos,
  sideNote = side_note,
  sideNoteContext = side_note_context
}
