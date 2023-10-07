
-- i created this to easily use vscode and neovim together with the same journal
-- Helper function to get the current date in the specified format
-- Helper function to create or open a journal file

local function get_current_date(format)
  return os.date(format)
end

local function create_or_open_journal()
  -- Get the current date
  local current_date = get_current_date("%A, %B %d %Y")
  local current_year = get_current_date("%Y")
  local current_month = get_current_date("%m")
  local current_day = get_current_date("%d")

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
    local initial_content = string.format("# %s\n\n:::mermaid\nflowchart RL\nid1>Tasks]\n:::\n\n:::  mermaid\nflowchart RL\nid1>Notes]\n:::\n", current_date)
    local file = io.open(journal_path, "w")
    file:write(initial_content)
    file:close()
  end

  return journal_path
end

-- Function to open or create today's journal
local function open_or_create_journal()
  local journal_path = create_or_open_journal()

  -- Open the journal file in a new buffer
  vim.cmd("e " .. journal_path)
end

-- Function to add a task to today's journal
local function add_task_to_journal()
  local journal_path = create_or_open_journal()

  -- Prompt for input from the command line
  local my_input = vim.fn.input("Enter your task: ")
  if my_input == "" then
    return
  end

  -- Read the contents of the journal file
  local file_contents = {}
  for line in io.lines(journal_path) do
    table.insert(file_contents, line)
  end

  -- Find the line with ":::" and insert the task after it
  local found = false
  for i, line in ipairs(file_contents) do
    if line:match("^:::$") then
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
