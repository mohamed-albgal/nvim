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
    local dashes = string.rep("-", 22)
    local underlines = string.rep("_", 22)
    local initial_content = string.format(
      "# %s\n\n%s\n%s\n::: \n\n\n:::  \n%s\n%s\n",
      current_date,
      dashes,
      underlines,
      dashes,
      underlines
    )
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

local function get_previous_todos(opts)
  -- Gather unfinished todos (lines starting with "- [ ]") from the previous five
  -- journal entries and append them to today's todo list. Todos are expected to
  -- live between the first line that equals "::: " and the next ":::mermaid".
  local sentinel_file = vim.fn.stdpath("data") .. "/journal_rollover"
  local today_key = os.date("%Y-%m-%d")
  local last_rollover = nil
  if vim.fn.filereadable(sentinel_file) == 1 then
    local contents = vim.fn.readfile(sentinel_file)
    last_rollover = contents[1]
  end

  if last_rollover == today_key then
    if not (opts and opts.silent) then
      print("Todos already rolled over for today.")
    end
    return
  end

  local function journal_path_for(date_tbl)
    local dir = string.format("~/VSCodeJournal/%d/%02d/", date_tbl.year, date_tbl.month)
    return dir .. string.format("%02d.md", date_tbl.day)
  end

  local function extract_todos_from_file(path)
    local expanded = vim.fn.expand(path)
    if vim.fn.filereadable(expanded) == 0 then return {} end

    local contents = {}
    for line in io.lines(expanded) do
      table.insert(contents, line)
    end

    if #contents == 0 then return {} end

    local todos, rewritten = {}, {}
    local in_todo_block = false
    local todo_section_consumed = false

    for _, line in ipairs(contents) do
      if not in_todo_block then
        table.insert(rewritten, line)
        if not todo_section_consumed and line:match("^::: %s*$") then
          in_todo_block = true
        end
      else
        if line:match("^:::mermaid") then
          table.insert(rewritten, line)
          in_todo_block = false
          todo_section_consumed = true
        elseif line:match("^%- %[%s*%]") then
          table.insert(todos, line)
        else
          table.insert(rewritten, line)
        end
      end
    end

    if #todos > 0 then
      local file = io.open(expanded, "w")
      for _, line in ipairs(rewritten) do
        file:write(line .. "\n")
      end
      file:close()
    end

    return todos
  end

  local collected = {}
  for offset = 5, 1, -1 do
    local target_date = os.date("*t", os.time() - (offset * 24 * 60 * 60))
    local candidate_path = journal_path_for(target_date)
    local todos = extract_todos_from_file(candidate_path)
    for _, todo in ipairs(todos) do
      local label = string.format(" -- ⬅️ %02d/%02d", target_date.month, target_date.day)
      if not todo:find("↺") then
        todo = todo .. label
      end
      table.insert(collected, todo)
    end
  end

  if #collected == 0 then
    print("No unfinished todos found in the last five days.")
    return
  end

  local today_path = get_or_create_journal_path()
  local expanded_today = vim.fn.expand(today_path)
  local today_contents = {}
  for line in io.lines(expanded_today) do
    table.insert(today_contents, line)
  end

  local insert_at = nil
  for idx, line in ipairs(today_contents) do
    if line:match("^::: %s*$") then
      insert_at = idx
      break
    end
  end

  if not insert_at then
    insert_at = #today_contents
  end

  for i = #collected, 1, -1 do
    table.insert(today_contents, insert_at + 1, collected[i])
  end

  local today_file = io.open(expanded_today, "w")
  for _, line in ipairs(today_contents) do
    today_file:write(line .. "\n")
  end
  today_file:close()

  local sentinel = io.open(vim.fn.expand(sentinel_file), "w")
  if sentinel then
    sentinel:write(today_key)
    sentinel:close()
  end

  print(string.format("Rolled over %d todo(s) into today's journal.", #collected))
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
  get_previous_todos({ silent = true })

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

local function open_most_recent_scratch_file()
  local journal_root = vim.fn.expand("~/VSCodeJournal/")
  local scratch_files = vim.fn.glob(journal_root .. "**/scratch_*.md", false, true)

  if not scratch_files or vim.tbl_isempty(scratch_files) then
    return open_monthly_scratch_file()
  end

  local uv = vim.loop
  local latest_file, latest_mtime = nil, -1

  for _, path in ipairs(scratch_files) do
    local stat = uv.fs_stat(path)
    if stat and stat.mtime and stat.mtime.sec and stat.mtime.sec > latest_mtime then
      latest_mtime = stat.mtime.sec
      latest_file = path
    end
  end

  if latest_file then
    vim.cmd("e " .. latest_file)
  else
    open_monthly_scratch_file()
  end
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
  rolloverTodos = get_previous_todos,
  journalPath = get_or_create_journal_path,
  openScratch = open_monthly_scratch_file,
  openLatestScratch = open_most_recent_scratch_file,
  openJournalDir = open_journal_directory_in_oil,
}
