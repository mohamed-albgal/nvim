vim.cmd('command! -nargs=1 RunRspec lua require("custom.run_rspec").runRspec(<f-args>)')
vim.cmd('command! -nargs=1 GoToPinned lua require("custom.pins").goToPinned(tonumber(<f-args>))')
vim.cmd('command! -nargs=1 DelPin lua require("custom.pins").removePin(tonumber(<f-args>))')



-- [[ Autocommands ]]
-- Save pins on VimLeavePre
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local pins = require("custom.pins")
    if pins.hasPins() then
      pins.savePins()
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
  end,
})

vim.api.nvim_create_autocmd("TermEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.signcolumn = "no"
  end,
})
