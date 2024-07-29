M = {}
M.runRspec = function(wholeFile)
    -- Get the current file and line number
    local current_file = vim.fn.expand('%')
    local current_line = vim.fn.line('.')

    -- Construct the "rspec" command

    local rspec_command = 'rspec ' .. current_file
  -- if wholeFile is false then append the : and current_line
    if wholeFile == 'false' then
      rspec_command = rspec_command .. ':' .. current_line
    end

    -- Delete existing rspec terminal buffers (buffers whose name is like  "term://.*rspec .*")
    local term_buffers = vim.fn.getbufinfo({ buftype = 'terminal' })
    for _, buf in ipairs(term_buffers) do
        local buffer_name = vim.fn.bufname(buf.bufnr)
        if buffer_name == '' then
            goto continue
        end
        if string.match(buffer_name, "term://.*rspec .*") then
            vim.cmd(':bdelete!' .. buf.bufnr)
        end
      ::continue::
    end

    -- Open a new terminal buffer in a horizontal split to the right
    vim.cmd(':rightbelow vsplit')
  -- set no line numbers
  -- vim.cmd(':setlocal nonumber')
    vim.cmd(':term ' .. rspec_command)
end

return M
