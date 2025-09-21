-- || lazy plugin manager ||
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "joonsuuh.plugins" },
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
  ui = {
    backdrop = 100,
    -- border = "rounded",
  },
})

vim.cmd.colorscheme("catppuccin")

-- Highlight overrides
local colors = require("catppuccin.palettes").get_palette("frappe")
local telescope_hl = colors.lavender
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.base })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.base, fg = telescope_hl })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.base })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.base })
vim.api.nvim_set_hl(0, "FloatTitle", { bg = telescope_hl, fg = colors.crust })

-- vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.base })
-- vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.base })

-- || vim modeline ||
-- vim: ts=2 sts=2 sw=2 et
