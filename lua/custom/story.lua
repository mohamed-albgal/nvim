return {
  story = function()
    local details = vim.fn.input("Enter the story details: ")
    if details == "" then
      print("Details can't be empty")
      return
    end

    -- Extract the story number it always begins with PRD- (case insensitive)
    local num = details:match("PRD%-%d+")
    if num == nil then
      print("Invalid story number format. It should start with PRD-")
      return
    end

    local title = details:gsub("PRD%-%d+", "") -- Remove the story number

    local branch_name = title
      :gsub("[^%w%s]", "") -- Remove non-alphanumeric and non-space characters
      :gsub("%s+", "-")    -- Replace spaces with dashes
      :gsub("[-]+$", "")   -- Remove trailing dashes
      :gsub("^[-]+", "")   -- Remove leading dashes
      :gsub("[-]+", "-")   -- Collapse multiple dashes into one
      :lower()             -- Convert to lowercase

    local formatted_output = string.format("%s - %s\n[Story](https://myhealthteam.atlassian.net/browse/%s)\nwip/%s-%s", num, title, num, branch_name, num)

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
