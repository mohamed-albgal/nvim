-- for terminal to open properly
local api = vim.api
-- api.nvim_command("autocmd TermOpen * startinsert")             -- starts in insert mode
api.nvim_command("autocmd TermOpen * setlocal nonumber")       -- no numbers
api.nvim_command("autocmd TermEnter * setlocal signcolumn=no") -- no sign column
-- Define the keymapping to copy file name and cursor's line number to register "+"
-- ideally don't do this, define some floatterm specific for rspec that opens up larger and takes the needed info to run the test that i can summon on command!

require('nightfox').setup({
  options = {
    transparent = true,
    inverse = {
      match_paren = true,
      search = false,
      search_count = true,
      visual = true,
    },
  },
})
vim.cmd.colorscheme 'nightfox'

