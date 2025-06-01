-- Expose custom commands for journal and story
vim.cmd('command! Story lua require("custom.story").story()')
vim.cmd('command! OpenJournal lua require("custom.jou_funcs").openToday()')
vim.cmd('command! OpenPrevJournal lua require("custom.jou_funcs").openPrev()')
vim.cmd('command! OpenNextJournal lua require("custom.jou_funcs").openNext()')
vim.cmd('command! AddJournalTask lua require("custom.jou_funcs").addTask()')
vim.cmd('command! JournalSideNote lua require("custom.jou_funcs").sideNote()')
vim.cmd('command! JournalSideNoteContext lua require("custom.jou_funcs").sideNoteContext()')

-- Expose custom rspec commands
vim.cmd('command! -nargs=1 RunRspec lua require("custom.run_rspec").runRspec(<f-args>)')
vim.cmd('command! YankRspecFile lua require("custom.run_rspec").yankFile()')
vim.cmd('command! YankRspecTest lua require("custom.run_rspec").yankTest()')
vim.cmd('command! CleanFailures lua require("custom.run_rspec").cleanLines()')

-- Expose custom pins commands
vim.cmd('command! PinBuffer lua require("custom.pins").pinThis()')
vim.cmd('command! -nargs=1 GoToPinned lua require("custom.pins").goToPinned(tonumber(<f-args>))')
vim.cmd('command! ClearPinned lua require("custom.pins").clearPins()')
vim.cmd('command! ShowPins lua require("custom.pins").showPins()')
vim.cmd('command! SplitPins lua require("custom.pins").splitPins()')
vim.cmd('command! FirstPin lua require("custom.pins").firstPin()')
vim.cmd('command! NextPin lua require("custom.pins").nextPin()')
