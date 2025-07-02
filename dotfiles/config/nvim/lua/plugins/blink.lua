return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    lazy = false,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saghen/blink.compat",
      "folke/lazydev.nvim",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "super-tab" },
      snippets = { preset = "luasnip" },

      -- 🔧 Источники автодополнения
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev" },
        compat = { "codeium" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          codeium = {
            kind = "Codeium",
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
