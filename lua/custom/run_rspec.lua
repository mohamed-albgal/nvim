M = {}
M.runRspec = function(wholeFile)
    -- Get the current file and line number
    local current_file = vim.fn.expand('%')
    local current_line = vim.fn.line('.')

  -- if current_file has _spec.rb then proceed, otherwise find the corresponding _spec.rb file in /Users/mohamedalbgal/dev/health-teams/spec/
    if not string.match(current_file, '_spec.rb') then
      local spec_file = string.gsub(current_file, 'app', 'spec')
      spec_file = string.gsub(spec_file, '.rb', '_spec.rb')
      if vim.fn.filereadable(spec_file) == 1 then
        current_file = spec_file
      else
        print('No spec file found for ' .. current_file)
        return
      end
    end
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

M.yankFile = function()
    local file_path = vim.fn.expand('%')
    local cmd = 'rspec ' .. file_path
    vim.fn.setreg('+', cmd)
end

M.yankTest = function()
    local file_path = vim.fn.expand('%')
    if not string.match(file_path, '_spec.rb') then
        local spec_file = string.gsub(file_path, 'app', 'spec')
        spec_file = string.gsub(spec_file, '.rb', '_spec.rb')
        if vim.fn.filereadable(spec_file) == 1 then
            file_path = spec_file
        else
            print('No spec file found for ' .. file_path)
            return
        end
    end
    local line_number = vim.fn.line('.')
    local cmd = 'rspec ' .. file_path .. ':' .. line_number
    vim.fn.setreg('+', cmd)
end

return M
