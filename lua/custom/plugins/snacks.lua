return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    bigfile = { enabled = false },
    words = { enabled = false },
    scope = { enabled = false },
    lazygit = { enabled = false },

    input = { enabled = true },
    zen = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    image = {},
  }
}
