return {
  'stevearc/oil.nvim',
  opts = function()
    return {
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",

        ["<C-j>"] = { "actions.preview_scroll_down", mode = "n" },
        ["<C-k>"] = { "actions.preview_scroll_up", mode = "n" },

        ["-"] = { "actions.parent", mode = "n" },
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },

        ["<Leader>e"] =  { "actions.close", mode = "n" },
        ["<Leader>;"] =  { "actions.close", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
      },
      float = {
        -- Padding around the floating window
        padding = 2,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.89,
        max_height = 0.89,
        border = "rounded",
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "right",
      }
    }
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
