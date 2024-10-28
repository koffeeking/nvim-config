local M = {
  "sbdchd/neoformat",
}

function M.config()
  vim.g.neoformat_run_all_formatters = 1
  vim.g.neoformat_python_black = { exe = "black", args = { "-l", "100" }, replace = 1 }
  vim.g.neoformat_enabled_python = { "black", "isort", "docformatter" }
end

return M
