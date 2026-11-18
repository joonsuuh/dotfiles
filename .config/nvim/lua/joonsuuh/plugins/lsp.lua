-- Language servers. nvim-lspconfig gives the default config of each server.
-- Mason installs the servers and the format tools in
-- ~/.local/share/nvim/mason/bin.
--
-- Install or update the tools:
--   :MasonInstall clang-format clangd lua-language-server ruff rumdl shellcheck shfmt stylua ty
local pack = require("joonsuuh.pack")
local gh = pack.gh

pack.add({
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("j-hui/fidget.nvim"),
})

require("mason").setup({ ui = { backdrop = 100 } })

-- LSP progress messages in the corner.
require("fidget").setup({})

-- || keymaps and highlights for each buffer with a server ||
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("joonsuuh-lsp-attach", { clear = true }),
  callback = function(event)
    local builtin = require("telescope.builtin")

    local function map(keys, func, desc, mode)
      vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
    map("grr", builtin.lsp_references, "[G]oto [R]eferences")
    map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
    map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
    -- Declaration, not definition. In C, this goes to the header.
    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("gO", builtin.lsp_document_symbols, "Open Document Symbols")
    map("gW", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
    map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Highlight the other uses of the word under the cursor after a short rest.
    if client:supports_method("textDocument/documentHighlight", event.buf) then
      local highlight_group = vim.api.nvim_create_augroup("joonsuuh-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("joonsuuh-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "joonsuuh-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    if client:supports_method("textDocument/inlayHint", event.buf) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})

-- || diagnostics ||
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  -- Each message on its own line under the code.
  virtual_text = false,
  virtual_lines = true,
})

-- || servers ||
-- Every server gets the completion capabilities of blink.cmp.
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

vim.lsp.config("clangd", {
  -- The nvim-lspconfig default also lists "c.doxygen", which nvim does not know.
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  cmd = {
    "clangd",
    "--background-index",
    -- Run the checks in the project .clang-tidy. A project with no .clang-tidy gets the compiler warnings only.
    "--clang-tidy",
    "--header-insertion=never",
  },
})

--- Returns the .venv of the main checkout when root_dir is a git worktree with
--- no .venv of its own. Worktrees then share the virtual environment of the
--- main checkout.
---@param root_dir string
---@return string?
local function main_checkout_venv(root_dir)
  if vim.uv.fs_stat(vim.fs.joinpath(root_dir, ".venv")) then
    return nil
  end
  local result = vim
    .system({ "git", "-C", root_dir, "rev-parse", "--path-format=absolute", "--git-common-dir" }, { text = true })
    :wait()
  if result.code ~= 0 then
    return nil
  end
  local venv = vim.fs.joinpath(vim.fs.dirname(vim.trim(result.stdout)), ".venv")
  return vim.uv.fs_stat(venv) and venv or nil
end

vim.lsp.config("ty", {
  -- The nvim-lspconfig default also lists requirements.txt, which often marks
  -- one service in a larger repo. ty then misses the packages at the repo root.
  root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", ".git" },
  -- The client keeps a reference to this table, so before_init changes it in place.
  settings = {
    ty = {
      configuration = {
        -- Rules that are off by default and point to real bugs. Type errors stay errors.
        rules = {
          ["division-by-zero"] = "warn",
          ["possibly-missing-attribute"] = "warn",
          ["possibly-missing-import"] = "warn",
          ["possibly-unresolved-reference"] = "warn",
          ["truthiness-test-of-none-union"] = "warn",
          ["unsound-assignment"] = "warn",
          ["unsound-return"] = "warn",
          ["unsound-yield"] = "warn",
        },
      },
    },
  },
  before_init = function(_, config)
    local venv = config.root_dir and main_checkout_venv(config.root_dir)
    if venv then
      config.settings.ty.configuration.environment = { python = venv }
    end
  end,
})

-- Python: ruff lints and formats, ty checks types and answers hover and
-- go-to-definition.
vim.lsp.enable({ "clangd", "lua_ls", "ruff", "rumdl", "ty" })
