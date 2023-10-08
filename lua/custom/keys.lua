
-- local vscode_journal = require("custom.vscode-journal")
-- -- Define a variable to control whether to equalize on window navigation
-- local vscode_journal = require('vscode-journal') didnt work? see ugly stuff at bottom
local equalize_enabled = false
-- Define a function to make windows equal width and increase buffer width
function equalize_windows_and_increase_width()
    -- Get the number of windows (splits)
    local num_windows = vim.fn.winnr("$")

    -- Calculate the dynamic width
    local width = 80 / (num_windows - 1)

    -- Make windows equal width
    vim.cmd("wincmd =")

    -- Increase buffer width by the calculated width
    vim.cmd("vertical resize +" .. width)
end


vim.api.nvim_set_keymap('n', '<leader>wn', ':tabdo windo set number!<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wt', '<cmd>lua if equalize_enabled then equalize_enabled = false vim.cmd("wincmd = | echom \'equalize_enabled is true\'") else equalize_enabled=true equalize_windows_and_increase_width() vim.cmd("echom \'equalize_enabled is false\'") end<cr>', { noremap = true, silent = true, desc = "vscode's buffer width switch toggle" })
vim.api.nvim_set_keymap('n', '<leader>w', '<C-w>', { noremap=true, silent = false, desc="Window navigation" })
vim.api.nvim_set_keymap('n', '<leader>a', ':wincmd h<cr>:lua if equalize_enabled then equalize_windows_and_increase_width() end<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>z', ':Z<cr>', { noremap = true, silent = true, desc= "Zen mode" })
-- Map <leader>l to navigate right (equivalent to <C-w>l) and trigger equalize if enabled
vim.api.nvim_set_keymap('n', '<leader>l', ':wincmd l<cr>:lua if equalize_enabled then equalize_windows_and_increase_width() end<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/', 'g*', { noremap = true, silent = true, desc = "Search for word under cursor" })
vim.api.nvim_set_keymap('n', '<leader>d', ':bd!<CR>', { noremap=true, silent = true, desc="Close buffer" })
vim.api.nvim_set_keymap('n', '<leader>w/', ':vertical sb<CR>', { noremap=true, silent = false, desc="Open vertical split" })
vim.api.nvim_set_keymap('n', '<leader>w-', ':split<CR>', { noremap=true, silent = false, desc="Open horizontal split" })

vim.api.nvim_set_keymap('n', '<leader>tt', ":FloatermToggle<CR>", { noremap=true, silent = true, desc = "Toggle terminal" })
vim.api.nvim_set_keymap('n', '<leader>tn', ":FloatermNew<CR>", { noremap=true, silent = true, desc = "New terminal" })
vim.api.nvim_set_keymap('n', '<leader>tp', ":FloatermPrev<CR>", { noremap=true, silent = true, desc = "Previous terminal" })

vim.keymap.set({'n','v','i'}, '<C-h>', ":BufferLineCyclePrev<cr>", { noremap=true, silent = true, desc = "Previous buffer"})
vim.keymap.set({'n','v','i'}, '<C-l>', ":BufferLineCycleNext<cr>", { noremap=true, silent = true, desc = "Next buffer"})
vim.keymap.set({'n','v','i'}, '<C-l>', ":BufferLineCycleNext<cr>", { noremap=true, silent = true, desc = "Next buffer"})
vim.keymap.set('n', '<leader>bD', ":BufferLineCloseOthers<cr>", { noremap=true, silent = true, desc = "Close other buffers"})

vim.api.nvim_set_keymap('n', '<leader>gg', ":LazyGit<cr>", { silent = true, desc = 'LazyGit window' })
vim.api.nvim_set_keymap('n', '<C-w>h', ':lua if equalize_enabled then equalize_windows_and_increase_width() else vim.cmd("wincmd h") end<cr>', { noremap = true, silent = true, desc = "Navigate left like vscode full-width" })

-- rspec mappings
vim.api.nvim_set_keymap('n', '<leader>r.', ":w!<CR>:rightbelow vsplit | terminal rspec %:<C-r>=line('.')<CR><CR>:setlocal nonumber<CR>", { noremap=true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>rw', ":w!<CR>:rightbelow vsplit | terminal rspec %:p<CR>:setlocal nonumber<CR>", { noremap=true, silent = false, desc="Run rspec on whole file" })
vim.api.nvim_set_keymap('n', '<Leader>ry', ":let @+ = 'rspec ' . expand('%') . ':' . line('.')<CR>", { noremap = true, silent = true, desc = "[y]ank rspec line signature" })
vim.api.nvim_set_keymap('n', '<Leader>rf', ":let @+ = 'rspec ' . expand('%')<CR>", { noremap = true, silent = true , desc = "copy rspec [f]ile signature" })

vim.api.nvim_set_keymap('t', 'kj', "<C-\\><C-n><cr>", { noremap=true, silent = true, desc = "Exit terminal" })
--
-- revisit this, i tried to create a M.{} in another file and require it here but it didn't work, so for now im waving the white flag
function get_current_date(format)
  return os.date(format)
end

function create_or_open_journal()
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
    local initial_content = string.format("# %s\n\n:::mermaid\nflowchart RL\nid1>Tasks]\n::: \n\n\n:::mermaid\nflowchart RL\nid1>Notes]\n:::  \n\n\n", current_date)
    local file = io.open(journal_path, "w")
    file:write(initial_content)
    file:close()
  end

  return journal_path
end

-- Function to open or create today's journal
function open_or_create_journal()
  local journal_path = create_or_open_journal()

  -- Open the journal file in a new buffer
  vim.cmd("e " .. journal_path)
end

-- Function to add a task to today's journal
function add_task_to_journal ()
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
    if line:match("^::: $") then
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
-- Map the journal function to <leader>j
vim.api.nvim_set_keymap('n', '<leader>jt', ":lua open_or_create_journal()<CR>", { noremap = true, silent = true, desc = "Open today's journal" })
vim.api.nvim_set_keymap('n', '<leader>ja', ":lua add_task_to_journal()<CR>", { noremap = true, silent = true, desc = "Add task to journal" })
