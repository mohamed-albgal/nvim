-- for terminal to open properly
local api = vim.api
api.nvim_command("autocmd TermOpen * startinsert")             -- starts in insert mode
api.nvim_command("autocmd TermOpen * setlocal nonumber")       -- no numbers
api.nvim_command("autocmd TermEnter * setlocal signcolumn=no") -- no sign column
vim.keymap.set('t', '<esc>', "<C-\\><C-n>")                    -- esc to exit insert mode
--
-- Define the keymapping to copy file name and cursor's line number to register "+"
vim.api.nvim_set_keymap('n', '<Leader>ry', ":let @+ = 'rspec ' . expand('%') . ':' . line('.')<CR>", { noremap = true, silent = true, desc = "copy rspec line signature" })
vim.api.nvim_set_keymap('n', '<Leader>rf', ":let @+ = 'rspec ' . expand('%')<CR>", { noremap = true, silent = true , desc = "copy rspec file signature" })

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

