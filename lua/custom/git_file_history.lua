local M = {}

local function current_buf_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Current buffer has no file path.", vim.log.levels.WARN)
    return nil
  end

  return path
end

M.add_commits_for_current_file = function()
  local buf_path = current_buf_path()
  if not buf_path then
    return
  end

  require("fzf-lua").git_bcommits({
    prompt = "File Added❯❯ ",
    cmd = [[git log --all --follow --color --diff-filter=A --pretty=format:"%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" -- {file}]],
    preview = "git show --color {1} -- {file}",
    winopts = {
      fullscreen = false,
      height = 0.80,
      width = 0.80,
      row = 0.50,
      col = 0.50,
    },
    actions = {
      ["enter"] = require("fzf-lua.actions").git_buf_edit,
      ["ctrl-s"] = require("fzf-lua.actions").git_buf_split,
      ["ctrl-v"] = require("fzf-lua.actions").git_buf_vsplit,
      ["ctrl-t"] = require("fzf-lua.actions").git_buf_tabedit,
      ["ctrl-y"] = { fn = require("fzf-lua.actions").git_yank_commit, exec_silent = true },
    },
  })
end

return M
