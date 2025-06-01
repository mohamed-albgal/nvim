vim.cmd('command! -nargs=1 RunRspec lua require("custom.run_rspec").runRspec(<f-args>)')
vim.cmd('command! -nargs=1 GoToPinned lua require("custom.pins").goToPinned(tonumber(<f-args>))')
