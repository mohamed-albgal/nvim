local M = {}

M.zap = function(selected)
  for _, entry in ipairs(selected) do
    -- parse "path/to/file:LINE:…"
    local rel, lnum = entry:match("([^:]+):(%d+):")
    if not (rel and lnum) then goto continue end

    local full = vim.fn.fnamemodify(rel, ':p')
    local bufnr = vim.fn.bufnr(full, true)
    vim.fn.bufload(bufnr)

    -- drop that single line [ln-1, ln)
    local ln = tonumber(lnum)
    if (not ln) or (ln < 1) then
      vim.notify("Invalid line number: " .. ln, vim.log.levels.ERROR)
      goto continue
    end
    vim.api.nvim_buf_set_lines(bufnr, ln-1, ln, false, {})

    -- write via the buffer’s own name so Neovim marks it saved
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd('silent! write')
    end)

    ::continue::
  end
end

M.grep_zap = function()
  require('fzf-lua').grep({
    prompt = 'Zap❯❯ ',
    git_icons   = false,
    file_icons  = false,
    color_icons = false,
    actions = {
      ['default'] = require('fzf-lua.actions').file_edit,
      ['tab'] = {
        fn = require('custom.zap').zap,
        reload = true,
      },
    },
  })
end

M.zap_debuggers = function()
  require('fzf-lua').grep {
    -- 1) only modified files, no icons injected by fzf-lua
    raw_cmd = [[
            git status -su |
            rg '^\s*M' |
            cut -d ' ' -f3 |
            xargs rg --hidden --column --line-number --no-heading --color=always --with-filename -e 'debugger' -e 'save_and_open_page'
          ]],
    git_icons   = false,  -- hide the “M” prefix :contentReference[oaicite:0]{index=0}
    file_icons  = false,  -- hide the devicons :contentReference[oaicite:1]{index=1}
    color_icons = false,  -- no icon colouring :contentReference[oaicite:2]{index=2}

    -- 2) allow fzf to select multiple lines and bind Tab to “select-all+accept”
    fzf_opts = {
      ["--multi"] = "",
    },

    actions = {
      -- Enter still opens a file
      ['default'] = require('fzf-lua.actions').file_edit,

      -- Tab (internally seen as <C-i>) fires once over *all* matches
      ['tab'] = {
        fn = require('custom.zap').zap,
        reload = true,  -- reload the buffer after the action
      },
    },
  }
end

return M
