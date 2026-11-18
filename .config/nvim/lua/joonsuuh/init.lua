-- Load order matters: settings set the leader key before any keymap, and
-- `pack` registers the build hooks before the first plugin install.
require("joonsuuh.settings")
require("joonsuuh.keymaps")
require("joonsuuh.pack")

require("joonsuuh.plugins.ui")
require("joonsuuh.plugins.mini")
require("joonsuuh.plugins.treesitter")
require("joonsuuh.plugins.completion")
require("joonsuuh.plugins.telescope")
require("joonsuuh.plugins.lsp")
require("joonsuuh.plugins.conform")
require("joonsuuh.plugins.render_markdown")
require("joonsuuh.plugins.jupytext")
