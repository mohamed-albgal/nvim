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

  { 'folke/which-key.nvim', opts = {} },

  {'tpope/vim-sleuth'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-rhubarb'},
  {'ggandor/lightspeed.nvim'},

  { "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
    end,
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

  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

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
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
    },
  },
}
