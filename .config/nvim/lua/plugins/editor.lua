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
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {
      surrounds = {
        -- l = link：把词/选区包成 markdown 链接 [文字](URL)，URL 取自系统剪贴板。
        -- 典型流程是浏览器里 Cmd-C 复制地址，回到 nvim 光标停在词上按 ysiwl。
        -- l 不在默认 surround 表里（默认是 ( { " t 这些），不会撞键，所以直接全局注册。
        ["l"] = {
          -- 写成函数而不是静态表：每次调用时现读剪贴板，写成表会在配置加载那一刻被固化。
          -- %s 全删是为了去掉复制时常带上的换行，URL 里本来也不该有空白。
          add = function()
            local url = vim.fn.getreg("+"):gsub("%s", "")
            return { { "[" }, { "](" .. url .. ")" } }
          end,
          -- %b[] / %b() 是 Lua 的平衡匹配，链接文字里再嵌方括号也能圈出完整的链接
          find = "%b[]%b()",
          -- delete / change.target 的捕获组约定见 :h nvim-surround.config.get_selections()：
          -- 第 1、3 组是「左右分隔符」的文本捕获，第 2、4 组必须是空的位置捕获 ()。
          -- 网上流传的版本把第 3 组写成 (.-) 去捕获 URL，那会被当成分隔符连着开头的
          -- "[x" 一起删掉；第 2、4 组写成文本捕获则直接报 "must be empty"。
          -- 这里左分隔符是 "["、右分隔符是 "](url)"，和上面 add 的产出正好对称。
          delete = "^(%[)().-(%]%b())()$", -- dsl：拆掉链接，只留显示文字
          change = {
            target = "^(%[)().-(%]%b())()$", -- csll：文字不动，只把 URL 换成剪贴板里的新值
            replacement = function()
              local url = vim.fn.getreg("+"):gsub("%s", "")
              return { { "[" }, { "](" .. url .. ")" } }
            end,
          },
        },
      },
    },
  },

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
