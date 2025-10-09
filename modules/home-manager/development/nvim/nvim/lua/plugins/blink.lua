return {
  {
    "saghen/blink.cmp",
    build = 'nix run .#build-plugin',
    lazy = false,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saghen/blink.compat",
      "folke/lazydev.nvim",
      "giuxtaposition/blink-cmp-copilot",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- keymap = { preset = "super-tab" },
      snippets = { preset = "luasnip" },

      fuzzy = { implementation = "prefer_rust" },
      
      -- 🔧 Источники автодополнения
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 100,
            async = true,
          },
        },
      },

      -- 🎨 Внешний вид
      appearance = {
        nerd_font_variant = "mono",
        kind_icons = vim.tbl_extend("force", {}, require("lazyvim.config").icons.kinds),
      },

      completion = {
        accept = {
          create_undo_point = true,
          auto_brackets = {
            enabled = true,
            default_brackets = { "(", ")" },
            kind_resolution = {
              enabled = true,
              blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        menu = {
          auto_show = true,
        },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
