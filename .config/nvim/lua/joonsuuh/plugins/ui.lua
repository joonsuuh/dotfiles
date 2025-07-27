return {
  { -- the best theme
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "frappe",
      -- transparent_background = true,
      integrations = {
        mason = true,
        which_key = true,
      },
    },
  },

  { -- detect indentation really fast
    "NMAC427/guess-indent.nvim",
  },

  { -- lines for indents
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },

  { -- colored braces
    "HiPhish/rainbow-delimiters.nvim",
  },

  { -- NOTE: highlights TODO, NOTE, WARN, etc.
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
    },
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Jump to next git [c]hange" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Jump to [p]revious git change" })

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [s]tage hunk" })

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [r]eset hunk" })

        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "git [i]nline preview hunk" })

        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "git [b]lame line" })

        map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff this" })

        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, { desc = "git [D]iff against last commit" })

        map("n", "<leader>hQ", function()
          gitsigns.setqflist("all")
        end, { desc = "git " })
        map("n", "<leader>hq", gitsigns.setqflist, { desc = "git [q]uick fix list" })

        -- Toggles
        map(
          "n",
          "<leader>tb",
          gitsigns.toggle_current_line_blame,
          { desc = "git [t]oggle current line [b]lame" }
        )
        map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "git [t]oggle [w]ord diff" })

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "git select hunk" })
      end,
    },
  },

  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },

      -- Document existing key chains
      spec = {
        { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      },
    },
  },
}
