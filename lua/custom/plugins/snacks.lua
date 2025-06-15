return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    explorer = { enabled = true },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    bigfile = { enabled = false },
    words = { enabled = false },
    scope = { enabled = false },

    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    image = {},
  }
}
