local function get_current_month_directory()
  local current_year = os.date("%Y")
  local current_month = os.date("%m")
  local journal_directory = string.format("~/VSCodeJournal/%s/%s/", current_year, current_month)
  return vim.fn.expand(journal_directory)
end

local function get_or_create_journal_path()
  -- Get the current date
  local current_date = os.date("%A, %B %d %Y")
  local current_day = os.date("%d")

  -- Define the journal directory and file path
  local journal_directory = get_current_month_directory()
  local journal_filename = string.format("%s.md", current_day)

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

-- function to create and open a scratch file for the current month
local function open_monthly_scratch_file()
  local expanded_directory = get_current_month_directory()

  -- Ensure the target directory exists so the scratch file can be created
  vim.fn.mkdir(expanded_directory, "p")

  local scratch_filename = string.format("scratch_%s.md", os.date("%H%M%S"))
  local scratch_path = expanded_directory .. scratch_filename
  local header = string.format("-- scratch file %s --\n\n", os.date("%A, %B %d %Y"))

  local file = io.open(scratch_path, "w")
  file:write(header)
  file:close()

  vim.cmd("e " .. scratch_path)

  return scratch_path
end

local function open_journal_directory_in_oil()
  local directory = get_current_month_directory()
  vim.fn.mkdir(directory, "p")
  require("oil").open_float(directory)
end

return {
  openNext = open_next_journal_entry,
  openPrev = open_previous_journal_entry,
  openToday = open_or_create_journal,
  addTask = add_task_to_journal,
  journalPath = get_or_create_journal_path,
  openScratch = open_monthly_scratch_file,
  openJournalDir = open_journal_directory_in_oil,
}
