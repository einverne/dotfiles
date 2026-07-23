-- lua/plugins/treesitter.lua
-- Treesitter：精准的语法高亮、缩进和代码结构感知，替代 vim 时代的正则高亮。
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      -- 常用语言，按需增删
      ensure_installed = {
        "lua", "vim", "vimdoc", "python", "javascript", "typescript", "tsx",
        "html", "css", "json", "yaml", "toml", "bash", "markdown",
        "markdown_inline", "gitcommit", "diff", "dockerfile",
      },
      auto_install = true,     -- 打开未安装语言时自动装 parser
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          node_decremental = "<BS>",
        },
      },
    },
  },
}
