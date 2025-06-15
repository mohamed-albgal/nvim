return {
  {
    "folke/tokyonight.nvim",
    lazy = false,     -- load immediately
    priority = 1000,
    opts = {
      cache = true,
      plugins = {
        all  = package.loaded.lazy == nil,
        auto = true,
      },
      style = "night",
      light_style = "day",
      -- transparent = true,
      terminal_colors = true,
      styles = {
        comments   = { italic = true },
        keywords   = { italic = true },
        functions  = {},
        variables  = {},
        sidebars   = "transparent",
        floats     = "transparent",
      },
      sidebars = { "qf", "help", "terminal" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = true,
      on_colors = function(colors) end,
      on_highlights = function(highlights, colors) end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      -- Set Tokyonight‐Storm as your active colorscheme:
      vim.cmd [[colorscheme tokyonight]]
    end,
  },
}
