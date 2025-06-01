  return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        disabled_filetypes = {
          statusline = {'.md'},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        -- lualine_b = {
        --   {
        --     'filename',
        --     path = 1,
        --     separators = { left = '', right = ''},
        --     color = {fg = '#ffffff', bg = '#000000', gui = 'bold'},
        --   }
        -- },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { { 'filename', path = 4,
          color = {fg = '#8b8b8b', bg = '#000000', gui = 'bold'},
          }
        },
      },
      sections = {
        lualine_a = {''},
        lualine_b = { { 'branch' }
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { { 'filename', path = 4,
          color = {fg = '#a7c7e7', bg = '#000000', gui = 'bold'},
          }
        },
      },
    },
  }
