local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
}

local sql_formatter_config_file = os.getenv "HOME" .. "/.config/nvim/lua/user/sql-formatter-config.json"

function M.config()
  local null_ls = require "null-ls"
  local methods = require "null-ls.methods"
  local helpers = require "null-ls.helpers"

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  local docformatter = helpers.make_builtin {
    name = "docformatter",
    meta = {
      url = "https://pypi.org/project/docformatter/",
      description = "A docstring formatter for Python.",
      notes = { "Install docformatter with `pip install docformatter`" },
    },
    method = methods.internal.FORMATTING,
    filetypes = { "python" },
    generator_opts = {
      command = "docformatter",
      args = { "--in-place", "-" },
      -- args = {},
      to_stdin = true,
      check_exit_code = { 0, 1 },
      on_output = function(output)
        return output
      end,
    },
    factory = helpers.formatter_factory,
  }

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
      docformatter,
      formatting.isort,
      formatting.black.with {
        extra_args = { "--line-length=100" },
      },
      diagnostics.pylint,

      -- -- code completion -- --
      null_ls.builtins.completion.spell,
    },
  }

  -- fix ctrl + c issue when writing sql
  -- vim.cmd "let g:omni_sql_default_compl_type = 'syntax'"
  vim.cmd "let g:ftplugin_sql_omni_key = '<C-,>'"
end

return M
