-- Render markdown in the buffer: headings, lists, tables, and code blocks.
local pack = require("joonsuuh.pack")

pack.add({ pack.gh("MeanderingProgrammer/render-markdown.nvim") })

require("render-markdown").setup({
  -- LaTeX needs a parser and a converter that neither machine has.
  latex = { enabled = false },
})
