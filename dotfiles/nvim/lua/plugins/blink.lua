return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      { "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = true } },
      { "dmitmel/cmp-digraphs" },
    },
    -- lock compat to tagged versions, if you've also locked blink.cmp to tagged versions
    -- use a release tag to download pre-built binaries
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = "super-tab" },

      sources = {
        completion = {
          -- remember to enable your providers here
          enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
        },
        compat = { "luasnip" },
        snippets = {
          expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
          end,
          active = function(filter)
            if filter and filter.direction then
              return require("luasnip").jumpable(filter.direction)
            end
            return require("luasnip").in_snippet()
          end,
          jump = function(direction)
            require("luasnip").jump(direction)
          end,
        },
        providers = {
          luasnip = {
            name = "luasnip",
            module = "blink.compat.source",

            score_offset = -3,

            opts = {
              use_show_condition = false,
              show_autosnippets = true,
            },
          },

          lsp = {
            -- dont show LuaLS require statements when lazydev has items
            fallback_for = { "lazydev" },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
          },
        },
      },

      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",

      windows = {
        autocomplete = {
          -- draw = "reversed",
          winblend = vim.o.pumblend,
        },
        documentation = {
          auto_show = true,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },

      -- experimental auto-brackets support
      accept = {
        auto_brackets = { enabled = true },
        expand_snippet = function(...)
          return require("luasnip").lsp_expand(...)
        end,
      },

      -- experimental signature help support
      trigger = { signature_help = { enabled = true } },
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { "sources.completion.enabled_providers" },

    -- LSP servers and clients communicate what features they support through "capabilities".
    --  By default, Neovim support a subset of the LSP specification.
    --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
    --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
    --
    -- This can vary by config, but in general for nvim-lspconfig:

    -- {
    --   'neovim/nvim-lspconfig',
    --   dependencies = { 'saghen/blink.cmp' },
    --   config = function(_, opts)
    --     local lspconfig = require('lspconfig')
    --     for server, config in pairs(opts.servers or {}) do
    --       config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
    --       lspconfig[server].setup(config)
    --     end
    --   end
    -- },
    -- add blink.compat
  },
}
