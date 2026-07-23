-- lua/plugins/editor.lua
-- 编辑体验增强插件合集。

return {
  -- flash：快速跳转，替代 vim-easymotion。保留原 f / gl 的跳转习惯。
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash 跳转" },
      { "F", mode = { "n", "x", "o" }, function() require("flash").jump({ search = { mode = "search" } }) end, desc = "Flash 词跳转" },
      { "gl", mode = { "n", "x", "o" }, function() require("flash").jump({ search = { forward = true, wrap = false } }) end, desc = "Flash 行跳转" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter 选择" },
    },
  },

  -- 成对符号操作 (cs"' / ds( / ysiw)，替代 tpope/vim-surround。
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

  -- 注释：gcc 注释当前行，gc 注释选区，替代 nerdcommenter。
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = { padding = true }, -- 注释符后带空格 (原 NERDSpaceDelims)
  },

  -- 自动补全括号 / 引号，替代 delimitMate。
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- 缩进参考线，替代 vim-indent-guides。
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = { indent = { char = "│" }, scope = { enabled = true } },
  },

  -- 高亮 / 一键清除行尾空白，替代 vim-better-whitespace。
  {
    "echasnovski/mini.trailspace",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.trailspace").setup()
      vim.keymap.set("n", "<leader>st", function()
        require("mini.trailspace").trim()
      end, { desc = "清除全部行尾空白" })
    end,
  },

  -- 按键提示：按下 leader 后弹出可用映射，降低记忆负担。
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "modern" },
  },

  -- 高亮 TODO/FIXME/HACK 等注释关键字，并可用 Telescope 检索。
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- 自动读取 .editorconfig (nvim 已内置，此处仅确保行为，无需额外插件)。
}
