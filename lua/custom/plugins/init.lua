vim.cmd('command! Story lua require("custom.story").story()')
vim.cmd('command! OpenJournal lua require("custom.jou_funcs").openToday()')
vim.cmd('command! OpenPrevJournal lua require("custom.jou_funcs").openPrev()')
vim.cmd('command! OpenNextJournal lua require("custom.jou_funcs").openNext()')
vim.cmd('command! AddJournalTask lua require("custom.jou_funcs").addTask()')
vim.cmd('command! -nargs=1 RunRspec lua require("custom.run_rspec").runRspec(<f-args>)')
vim.cmd('command! YankRspecFile lua require("custom.run_rspec").yankFile()')
vim.cmd('command! YankRspecTest lua require("custom.run_rspec").yankTest()')

return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', },
    build = ':TSUpdate',
  },

  { 'numToStr/Comment.nvim', opts = {} },

  { 'folke/which-key.nvim',
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 50
    end,
    opts = {
      triggers = {
        { "<leader>", mode = { "n", "v" } },
      },
      icons = { mappings = false },
      delay = 500,
    },
  },

  {"vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" }
    }
  },
  { "3rd/image.nvim",
    dependencies = { "vhyrro/luarocks.nvim" },
    config = function()
      require('image').setup()
    end
  },
  { "anuvyklack/windows.nvim",
   dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim"
   },
   config = function()
      vim.o.winwidth = 19
      vim.o.winminwidth = 19
      vim.o.equalalways = false
      require('windows').setup({
        animation = { duration = 250 }
      })
   end
  },

  {'nmac427/guess-indent.nvim'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-rhubarb'},
  {'ggandor/leap.nvim',
    config = function()
      require('leap').create_default_mappings()
    end,
  },
  { "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  { "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { 'rhysd/git-messenger.vim' },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 160,
        options = {
          number = false,
        }
      },
      on_open = function()
        vim.fn.system('kitty @ set-tab-bar visible no')
      end,
      on_close = function()
        vim.fn.system('kitty @ set-tab-bar visible yes')
      end,
    }
  },

  {
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
  },
}
