return {

  {'ggandor/leap.nvim',
    config = function()
      leap = require('leap')
      require('leap').create_default_mappings()
      leap.opts.preview_filter = function (ch0, ch1, ch2)
        return not (
          ch1:match('%s') or
          ch0:match('%a') and ch1:match('%a') and ch2:match('%a')
        )
      end
    end,
  },
  {'nmac427/guess-indent.nvim'},
  {'ntpeters/vim-better-whitespace' },
  {'numToStr/Comment.nvim', opts = {} },
}
