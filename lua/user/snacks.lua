local M = {
  "folke/snacks.nvim",
  commit = "07f4b9adff7af45a7e0eb22d85a422e32ed4b1ca",
  config = true,
}

function M.config()
  require("snacks").setup {
    opts = {
      lazygit = { enabled = true },
      picker = {
        sources = {
          explorer = {
            replace_netrw = true,
          },
        },
        files = {
          hidden = true,
          ignored = true,
          show_empty = true,
        },
      },
    },
  }
end

return M
