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
    quickfile = { enabled = false },
    bigfile = { enabled = false },
    words = { enabled = false },
    scope = { enabled = false },
    lazygit = { enabled = false },

    notifier = { enabled = true },
    input = { enabled = true },
    zen = { toggles = { dim = false}},
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    image = {},
  }
}
