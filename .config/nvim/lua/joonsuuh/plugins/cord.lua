return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  opts = {
    editor = {
      -- client = 'neovim',
      tooltip = 'searching for undefined behavior',
      -- icon = nil,
    },
    buttons = {
      {
        label = 'view repository',
        url = function(opts)
          return opts.repo_url
        end,
      },
    },
  }
}
