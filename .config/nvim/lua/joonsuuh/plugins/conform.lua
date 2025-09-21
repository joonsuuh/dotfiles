return { -- Autoformat
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    -- format_on_save = function(bufnr)
    --   -- Disable "format_on_save lsp_fallback" for languages that don't
    --   -- have a well standardized coding style. You can add additional
    --   -- languages here or re-enable it for the disabled ones.
    --   local disable_filetypes = { c = true, cpp = true, cuda = true, lua = true }
    --   if disable_filetypes[vim.bo[bufnr].filetype] then
    --     return nil
    --   else
    --     return {
    --       timeout_ms = 500,
    --       lsp_format = "fallback",
    --     }
    --   end
    -- end,
    formatters_by_ft = {
      lua = { "stylua" },
      cpp = { "clang_format" },
    },

    formatters = {
      stylua = {
        args = {
          "--indent-type",
          "Spaces",
        },
      },
      clang_format = {
        command = "clang-format",
        args = {
          "--style={BasedOnStyle: LLVM, IndentWidth: 4, BreakBeforeBraces: Allman, AllowShortFunctionsOnASingleLine: None, AllowShortIfStatementsOnASingleLine: false, AllowShortLoopsOnASingleLine: false, AccessModifierOffset: -4, PointerAlignment: Left, Cpp11BracedListStyle: false, SpaceBeforeCpp11BracedList: true, BinPackArguments: false, BreakConstructorInitializers: BeforeComma, ColumnLimit: 120}",
        },
      },
    },
  },
}
