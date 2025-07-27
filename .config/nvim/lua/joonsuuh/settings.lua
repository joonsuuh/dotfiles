-- || vim global vars ||
-- set <Space> to <Leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- use the best font: ComicShannsMono
-- https://www.nerdfonts.com/font-downloads
vim.g.have_nerd_font = true -- set to false if not downloaded
vim.g.vimtex_view_method = 'skim'

-- || vim options ||
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.expandtab = true -- tabs == spaces

vim.opt.mouse = 'a' -- mouse on
vim.opt.showmode = false -- hide mode

-- os clipboard == nvim
-- schedule at end for fast startup
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- wrapped text aligns at indent
vim.opt.breakindent = true;

-- save undo history
vim.opt.undofile = true;

vim.opt.ignorecase = true;
vim.opt.smartcase = true;

-- for gitsigns space
vim.opt.signcolumn = 'yes';

-- decrease time for plugin update i.e. linter, swapfile update...
vim.opt.updatetime = 250 -- ms

-- qte for command
vim.opt.timeoutlen = 300

-- open new splits right and down
vim.opt.splitright = true
vim.opt.splitbelow = true

-- label whitespace
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- preview substitution
vim.opt.inccommand = 'split'

-- highlight cursor line
vim.opt.cursorline = true

-- keep cursor at center
vim.opt.scrolloff = 10

-- prompt save before command that would fail
vim.opt.confirm = true

-- || vim api ||
-- highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set highlight after Netrw is loaded
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    -- Clear existing highlight
    vim.api.nvim_set_hl(0, "netrwMarkFile", {})

    -- Set your custom highlight
    vim.api.nvim_set_hl(0, "netrwMarkFile", {
      fg = "#e78284",   -- gold/yellow
      -- bg = "#303446",   -- dark gray
    })
  end
})

-- just colors
-- vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white' })
-- vim.api.nvim_set_hl(0, '@comment', { fg = 'white' })
-- vim.api.nvim_set_hl(0, '@lsp.type.comment', { fg = 'white' })
-- vim.api.nvim_set_hl(0, 'Comment', { fg = 'white' })
