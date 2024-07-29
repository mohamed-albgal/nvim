return {
  story = function()
    local num = vim.fn.input("Enter number: ")
    local title = vim.fn.input("Enter the story title: ")
    -- early return if num or title is empty
    if num == "" or title == "" then
      -- print("num, title, or branch name is empty")
      print("Story number or title can't be empty")
      return
    end

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
