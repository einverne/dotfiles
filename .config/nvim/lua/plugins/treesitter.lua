-- lua/plugins/treesitter.lua
-- Treesitter（main 分支新架构）：插件只负责解析器的安装与管理，
-- 高亮/缩进等特性改由 Neovim 内置能力在 FileType 时手动开启。
-- 说明：main 分支已移除旧的 `nvim-treesitter.configs` 与 `opts` 配置方式，
-- 也不再内置 incremental_selection（如需可另接 textobjects 插件）。

-- 需要预装的解析器（等价旧版 ensure_installed），install 幂等、异步。
local ensure_installed = {
  "lua", "vim", "vimdoc", "python", "javascript", "typescript", "tsx",
  "html", "css", "json", "yaml", "toml", "bash", "markdown",
  "markdown_inline", "gitcommit", "diff", "dockerfile",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- main 分支的特性要在 FileType 前就绪，官方推荐不做懒加载。
    -- install 是异步的，lazy=false 对启动速度几乎无影响。
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- 安装/更新解析器（已装则跳过，异步执行不阻塞启动）。
      require("nvim-treesitter").install(ensure_installed)

      -- 对任意已安装解析器的 buffer 启用 treesitter 特性。
      -- 用 get_lang 把 filetype 正确映射到 parser 名（如 typescriptreact -> tsx）。
      local function enable(buf)
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if not lang or lang == "" then
          return
        end
        -- parser 未安装时 start 会报错，用 pcall 兜底静默跳过。
        if pcall(vim.treesitter.start, buf, lang) then
          -- 缩进（nvim-treesitter 提供，实验性），等价旧版 indent.enable。
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          enable(args.buf)
        end,
      })

      -- lazy=false 时本文件在启动早期加载，为已打开的 buffer 补上启用逻辑。
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          enable(buf)
        end
      end
    end,
  },

  -- Treesitter 文本对象（main 分支）：基于语法树的选择/移动/交换。
  -- 替代旧核心里已移除的 incremental_selection 与 textobjects 配置块。
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true, -- 向前跳到最近的文本对象，类似 targets.vim
        },
        move = {
          set_jumps = true, -- 移动记入 jumplist，可用 <C-o>/<C-i> 回跳
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- 选择：在可视/操作待决模式下用 a*/i* 选中语法节点。
      -- 例：daf 删整个函数，vic 选类内部，cia 改当前参数。
      local objects = {
        f = "@function", -- 函数
        c = "@class",    -- 类
        a = "@parameter", -- 参数/实参
        l = "@loop",     -- 循环
        i = "@conditional", -- 条件（if/else）
      }
      for key, capture in pairs(objects) do
        vim.keymap.set({ "x", "o" }, "a" .. key, function()
          select.select_textobject(capture .. ".outer", "textobjects")
        end, { desc = "选中 " .. capture .. " 外部" })
        vim.keymap.set({ "x", "o" }, "i" .. key, function()
          select.select_textobject(capture .. ".inner", "textobjects")
        end, { desc = "选中 " .. capture .. " 内部" })
      end

      -- 移动：]f/[f 在函数间跳转，]c/[c 在类间跳转。大写跳到末尾。
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "下一个函数开头" })
      vim.keymap.set({ "n", "x", "o" }, "]F", function()
        move.goto_next_end("@function.outer", "textobjects")
      end, { desc = "下一个函数结尾" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "上一个函数开头" })
      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        move.goto_previous_end("@function.outer", "textobjects")
      end, { desc = "上一个函数结尾" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "下一个类开头" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "上一个类开头" })

      -- 交换：<leader>a 与下一个参数交换，<leader>A 与上一个参数交换。
      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "与下一个参数交换" })
      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "与上一个参数交换" })

      -- 可重复移动：; 重复上次跳转，, 反向重复（不覆盖 flash 占用的 f/F）。
      local rep = require("nvim-treesitter-textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", rep.repeat_last_move_next, { desc = "重复上次 TS 移动" })
      vim.keymap.set({ "n", "x", "o" }, ",", rep.repeat_last_move_previous, { desc = "反向重复上次 TS 移动" })
    end,
  },
}
