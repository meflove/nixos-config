if true then return {} end

return {
  {                    --* the completion engine *--
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
  },

  --* the sources *--
  { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
  { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
  { "iguanacucumber/mag-buffer",   name = "cmp-buffer" },
  { "iguanacucumber/mag-cmdline",  name = "cmp-cmdline" },
  require("cmp").setup({
    sources = {
      { name = "async_path" },
    },
  }),
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
}
