-- Format the buffer with <leader>f. A file type with no formatter here uses
-- its language server.
local pack = require("joonsuuh.pack")

pack.add({ pack.gh("stevearc/conform.nvim") })

require("conform").setup({
  notify_on_error = false,
  formatters_by_ft = {
    cpp = { "clang_format" },
    cuda = { "clang_format" },
    lua = { "stylua" },
    python = { "ruff_format" },
    sh = { "shfmt" },
  },
  formatters = {
    stylua = {
      -- A project .stylua.toml sets the other options.
      prepend_args = { "--indent-type", "Spaces" },
    },
    clang_format = {
      -- The project .clang-format sets the style. A file in a project with no
      -- .clang-format stays as it is.
      prepend_args = { "--fallback-style=none" },
    },
  },
})

vim.keymap.set("", "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })
