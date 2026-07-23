-- lua/plugins/lsp.lua
-- LSP：代码补全、跳转、诊断、重命名，替代原来的 YouCompleteMe + jedi-vim。
-- Mason 负责自动下载语言服务器，nvim-lspconfig 提供默认配置。
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 诊断显示样式
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- 让 LSP 补全能力对齐 nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- 附加到 buffer 时绑定按键
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(ev)
          local function m(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          m("gd", vim.lsp.buf.definition, "跳转到定义")
          m("gD", vim.lsp.buf.declaration, "跳转到声明")
          m("gr", "<cmd>Telescope lsp_references<cr>", "查找引用")
          m("gi", vim.lsp.buf.implementation, "跳转到实现")
          m("K", vim.lsp.buf.hover, "查看文档")
          m("<leader>rn", vim.lsp.buf.rename, "重命名符号")
          m("<leader>ca", vim.lsp.buf.code_action, "代码动作")
          m("<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "格式化")
        end,
      })

      -- lua_ls 识别 vim 全局变量，避免 "undefined global vim" 警告
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      -- 自动安装并启用这些服务器 (按需增删)
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ts_ls", "bashls", "jsonls", "yamlls" },
        automatic_enable = true,
      })
    end,
  },
}
