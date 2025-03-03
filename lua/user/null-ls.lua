local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
}

local sql_formatter_config_file = os.getenv "HOME" .. "/.config/nvim/lua/user/sql-formatter-config.json"

function M.config()
  local null_ls = require "null-ls"

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup {
    sources = {
      -- -- sql -- --
      -- formatting.sqlfmt.with {
      --   filetypes = { "sql" },
      --   extra_args = {
      --     -- "--dialect=clickhouse",
      --     "--line-length=120",
      --   },
      -- },
      formatting.sql_formatter.with {
        args = vim.fn.empty(vim.fn.glob(sql_formatter_config_file)) == 0 and { "--config", sql_formatter_config_file }
          or nil,
      },

      -- -- golang -- --
      formatting.goimports,
      -- diagnostics.gopls, -- installed with golang

      -- -- lua -- --
      formatting.stylua,

      -- -- javascript -- --
      formatting.prettier,
      -- formatting.prettier.with {
      --   -- get configuration from project directory
      --   condition = function(utils)
      --     return utils.root_has_file ".prettierrc.js"
      --   end,
      --   extra_filetypes = {
      --     "typescript",
      --     "typescriptreact",
      --     "typescript.tsx",
      --     "javascript",
      --     "javascriptreact",
      --     "javascript.jsx",
      --   },
      -- },
      require "none-ls.diagnostics.eslint",
      -- diagnostics.eslint_d,

      -- -- css -- --
      diagnostics.stylelint,

      -- -- python -- --
      -- this is all handled by ruff now
      -- formatting.black.with {
      --   extra_args = { "--line-length=100" },
      -- },
      -- formatting.docformatter,
      formatting.isort,
      diagnostics.mypy,

      -- -- code completion -- --
      null_ls.builtins.completion.spell,
    },
  }

  -- fix ctrl + c issue when writing sql
  -- vim.cmd "let g:omni_sql_default_compl_type = 'syntax'"
  vim.cmd "let g:ftplugin_sql_omni_key = '<C-,>'"
end

return M
