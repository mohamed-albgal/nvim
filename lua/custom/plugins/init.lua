-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information


return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', },
    build = ':TSUpdate',
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  -- maq lightspeed

  { 'folke/which-key.nvim',
    event= "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 2000
    end,
    opts = { },
  },


-- install without yarn or npm
  {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function() vim.fn["mkdp#util#install"]() end,
  },

  {'tpope/vim-sleuth'},
  {'tpope/vim-dispatch'},
  {'radenling/vim-dispatch-neovim'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-rhubarb'},
  {'ggandor/lightspeed.nvim'},
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

  -- floating window for git stuff
  { 'rhysd/git-messenger.vim' },
  -- zen mode
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 160,
        options = {
          number = false,
        }
      }
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  -- for tabline
  -- {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
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
        --   
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
      sections= {
        lualine_c = {{
          'filename',
          path=4,
          -- color = {fg = '#ffffff', bg = '#000000', gui = 'bold'},
        }},
      },
    },
  },
}
