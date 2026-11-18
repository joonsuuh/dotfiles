-- Open .ipynb files as text. Needs the jupytext command:
--   uv tool install jupytext
local pack = require("joonsuuh.pack")

pack.add({ { src = pack.gh("goerz/jupytext.nvim"), version = vim.version.range("0.2.0") } })

require("jupytext").setup({})
