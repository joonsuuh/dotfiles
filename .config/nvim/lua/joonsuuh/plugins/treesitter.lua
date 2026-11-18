-- Treesitter parsers, highlights, and indent. The `main` branch of
-- nvim-treesitter builds each parser with the tree-sitter CLI (0.26.1 or later).
local pack = require("joonsuuh.pack")

pack.add({ { src = pack.gh("nvim-treesitter/nvim-treesitter"), version = "main" } })

local languages = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "cuda",
  "diff",
  "html",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}

-- Install the missing parsers. The install runs in the background.
require("nvim-treesitter").install(languages)

-- Start Treesitter highlights and indent for these file types.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("joonsuuh-treesitter", { clear = true }),
  pattern = languages,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
