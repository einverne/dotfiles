-- lua/plugins/editor.lua
-- 编辑体验增强插件合集。

return {
  -- flash：快速跳转，替代 vim-easymotion。f/F 改成多字符搜索跳转 (jump)，t/T 保留原生 till。
  -- 关掉 char 模式：它默认把 f F t T 做成单字符移动，会盖掉下面的多字符 jump() 映射。
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = { enabled = false },
      },
    },
    keys = {
      -- f 双向、F 向后；t/T 不映射，回归原生 till 动作
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash 跳转 (双向)" },
      { "F", mode = { "n", "x", "o" }, function() require("flash").jump({ search = { forward = false, wrap = false } }) end, desc = "Flash 跳转 (向后)" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter 选择" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash 远程操作" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search 搜索选择" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "命令行搜索切换 Flash 高亮" },
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
