-- mini.nvim modules. They replace which-key, todo-comments, indent-blankline,
-- nvim-autopairs, and nvim-web-devicons.
local pack = require("joonsuuh.pack")

pack.add({ pack.gh("nvim-mini/mini.nvim") })

-- || icons ||
-- Telescope asks nvim-web-devicons for icons. mini.icons answers in its place.
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- || editing ||
-- Text objects: va), yinq, ci', and more.
require("mini.ai").setup({ n_lines = 500 })
-- Surround: saiw) adds, sd' deletes, sr)' replaces.
require("mini.surround").setup()
-- Close brackets and quotes in Insert mode.
require("mini.pairs").setup()

-- || indent scope ||
local indentscope = require("mini.indentscope")
indentscope.setup({
  draw = { animation = indentscope.gen_animation.none() },
  symbol = "│",
})

-- || highlight TODO, NOTE, and hex colors ||
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    warn = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

-- || status line ||
local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })
-- Cursor location as LINE:COLUMN.
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

-- || key hints ||
-- Shows the next keys after a trigger key, such as <Leader> or g.
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "i", keys = "<C-x>" },
    { mode = "n", keys = "<C-w>" },
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },
  clues = {
    { mode = "n", keys = "<Leader>c", desc = "+[C]ode" },
    { mode = "n", keys = "<Leader>h", desc = "+Git [H]unk" },
    { mode = "x", keys = "<Leader>h", desc = "+Git [H]unk" },
    { mode = "n", keys = "<Leader>s", desc = "+[S]earch" },
    { mode = "n", keys = "<Leader>t", desc = "+[T]oggle" },
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = { delay = 0 },
})
