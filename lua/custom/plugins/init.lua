-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

vim.api.nvim_set_keymap('n', '<leader>r.', ":w!<cr>:terminal rspec %:<C-r>=line('.')<cr><cr>", { noremap=true, silent = false})
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
      vim.cmd.colorscheme 'carbonfox'
    end,
  },

  { "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

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
