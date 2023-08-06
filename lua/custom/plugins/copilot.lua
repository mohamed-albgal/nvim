return {
  "zbirenbaum/copilot.lua",
  config = function()
    require('copilot').setup({
      panel = {
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = false,
          refresh = "gr",
          open = "<M-CR>"
       },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      filetypes = {
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 16.x
      server_opts_overrides = {},
    })

  end,
}
