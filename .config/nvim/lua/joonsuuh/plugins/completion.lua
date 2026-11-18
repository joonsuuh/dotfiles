-- Completion with blink.cmp. Snippets use the built-in vim.snippet engine and
-- the friendly-snippets collection.
local pack = require("joonsuuh.pack")
local gh = pack.gh

pack.add({
  gh("rafamadriz/friendly-snippets"),
  gh("folke/lazydev.nvim"),
  -- A release tag lets blink download its prebuilt fuzzy matcher.
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
})

-- lua_ls types for the Neovim API, in Lua files only.
require("lazydev").setup({
  library = {
    -- Load the luv types when a file uses `vim.uv`.
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

require("blink.cmp").setup({
  keymap = { preset = "super-tab" },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
    providers = {
      lsp = { score_offset = 150 },
      snippets = { max_items = 3, score_offset = -150, min_keyword_length = 2 },
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },
  snippets = { preset = "default" },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
})
