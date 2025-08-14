return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = true,
      globalstatus = false, -- per-window statusline
      always_divide_middle = true,
      refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
    },

    sections = (function()
      -- Helpers
      local function is_single_window()
        return #vim.api.nvim_tabpage_list_wins(0) == 1
      end
      local function wide_enough()
        return vim.api.nvim_win_get_width(0) > 70
      end

      return {
        -- Put filename first so it keeps priority when space is tight
        lualine_a = {
          { 'branch', cond = function() return is_single_window() and wide_enough() end },
        },
        -- Only show branch when there’s a single window AND it’s not super narrow
        lualine_z = {
          { 'filename', path = 0, -- 0 = just the tail
            --  use dot icon and lock icon for modified and readonly files, respectively
            symbols = { modified = '●', readonly = ' ' },
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_b = {},
      }
    end)(),

    inactive_sections = {
      lualine_z = { { 'filename', path = 0 } },
      lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_a = {}
    },

    -- You can drop winbar entirely if you don't use it
    winbar = {}, inactive_winbar = {},
  },
}
