local M = {
  "williamboman/mason-lspconfig.nvim",
  commit = "e7b64c11035aa924f87385b72145e0ccf68a7e0a",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-lua/plenary.nvim",
  },
}

M.servers = {
  "lua_ls",
  "cssls",
  "html",
  "tsserver",
  "astro",
  -- "pyright",
  -- "jedi_language_server",
  "bashls",
  "jsonls",
  "yamlls",
  "marksman",
  "tailwindcss",
  "gopls",
}

M.formatters = {
  "docformatter",
  "black",
}

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }
  require("mason-lspconfig").setup {
    automatic_installation = true,
    ensure_installed = M.servers,
    M.formatters,
  }
end

return M
