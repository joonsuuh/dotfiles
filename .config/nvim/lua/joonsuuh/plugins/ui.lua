-- Colors, indent detection, delimiters, and git signs.
local pack = require("joonsuuh.pack")
local gh = pack.gh

pack.add({
  { src = gh("catppuccin/nvim"), name = "catppuccin" },
  gh("NMAC427/guess-indent.nvim"),
  gh("HiPhish/rainbow-delimiters.nvim"),
  gh("lewis6991/gitsigns.nvim"),
})

-- || colors ||
require("catppuccin").setup({
  flavour = "frappe",
  integrations = {
    mason = true,
    mini = { enabled = true },
  },
})
vim.cmd.colorscheme("catppuccin")

local colors = require("catppuccin.palettes").get_palette("frappe")
local telescope_hl = colors.lavender
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.base })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.base, fg = telescope_hl })
vim.api.nvim_set_hl(0, "FloatTitle", { bg = telescope_hl, fg = colors.crust })

-- || indent detection ||
require("guess-indent").setup({})

-- || git signs ||
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Jump to next git [c]hange" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Jump to [p]revious git change" })

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "git [s]tage hunk" })
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "git [r]eset hunk" })
    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
    map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "git [i]nline preview hunk" })
    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "git [b]lame line" })
    map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff this" })
    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end, { desc = "git [D]iff against last commit" })
    map("n", "<leader>hQ", function()
      gitsigns.setqflist("all")
    end, { desc = "git [Q]uickfix list, all files" })
    map("n", "<leader>hq", gitsigns.setqflist, { desc = "git [q]uickfix list" })

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "git [t]oggle current line [b]lame" })
    map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "git [t]oggle [w]ord diff" })

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "git select hunk" })
  end,
})
