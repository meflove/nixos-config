return {
  -- lazyvim's mini.files extra has a few extra functions in its config function,
  --  to avoid clobbering those, I recommend only using opts:
  {
    'echasnovski/mini.files',
    lazy = false,
    opts = {
      options = {
        use_as_default_explorer = true
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
  }
}
