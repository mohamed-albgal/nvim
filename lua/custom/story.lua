return {
    story = function()
      local details = vim.fn.input("Enter the story details: ")
      if details == "" then
        print("Details can't be empty")
        return
      end

      -- Extract the ticket number and title
      local all_numbers = {}
      for number in string.gmatch(details, "%d+") do
        table.insert(all_numbers, number)
      end

      -- Find the longest numeric string
      table.sort(all_numbers, function(a, b) return #a > #b end)
      local num = all_numbers[1] or ""

      -- Escape the longest numeric string for use in gsub
      local num_pattern = num:gsub("([^%w])", "%%%1")

      -- Remove the longest numeric string to get the title
      local title = details:gsub(num_pattern, "", 1):gsub("^%s+", ""):gsub("%s+$", "")



      local branch_name = string.gsub(title, "%d", "")
      -- change all non-alphanumeric characters to empty string
      branch_name = string.gsub(branch_name, "%W", "")
      branch_name = string.gsub(branch_name, "|", "")
      -- change all spaces to dashes
      branch_name = string.gsub(title, "%s+", "-")
      -- remove any trailing dashes
      branch_name = string.gsub(branch_name, "-$", "")
      -- remove any leading dashes
      branch_name = string.gsub(branch_name, "^-", "")
      -- make it lowercase
      branch_name = string.lower(branch_name)
      -- ignore any text in brackets or parentheses
      branch_name = string.gsub(branch_name, "%b()", "")
      branch_name = string.gsub(branch_name, "%b[]", "")
      -- remove any dash that is followed by another dash
      branch_name = string.gsub(branch_name, "-+", "-")

    local formatted_output = string.format("%s - %s\n[Story](https://www.pivotaltracker.com/story/show/%s)\nwip/%s-%s", num, title, num, branch_name, num)

    local journal_path = require("custom.jou_funcs").journalPath()
    local journal_file = io.open(journal_path, "a")
    if journal_file == nil then
      print("Error opening journal file")
      return
    end
    journal_file:write("\n" .. formatted_output .. "\n")
    journal_file:close()
    print(" |-----------------------Success")
    -- open the journal file as a vertical split
    vim.cmd("vsplit " .. journal_path)
  end
}
