-- Helpers for vim.pack, the plugin manager in Neovim 0.12.
--
-- Install: start nvim. vim.pack installs each missing plugin at the commit in
-- nvim-pack-lock.json.
-- Update: run `:lua vim.pack.update()`, review the changes, then `:write` to
-- accept or `:quit` to cancel. Commit nvim-pack-lock.json after an update.

local M = {}

--- Returns the GitHub URL of a plugin repository.
---@param repo string Owner and name, such as "nvim-mini/mini.nvim".
---@return string
function M.gh(repo)
  return "https://github.com/" .. repo
end

--- Adds plugins to the session. Installs the missing ones without a prompt.
---@param specs (string|vim.pack.Spec)[]
function M.add(specs)
  vim.pack.add(specs, { confirm = false })
end

-- Build steps that run after vim.pack installs or updates a plugin.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("joonsuuh-pack", { clear = true }),
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end
    if name == "telescope-fzf-native.nvim" then
      vim.system({ "make" }, { cwd = event.data.path }):wait()
    elseif name == "nvim-treesitter" and kind == "update" then
      if not event.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

return M
