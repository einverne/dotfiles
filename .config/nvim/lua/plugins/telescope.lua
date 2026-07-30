-- lua/plugins/telescope.lua
-- Telescope：模糊查找文件 / 内容 / buffer，替代原来的 fzf.vim。
-- 保留原 fzf 的按键手感 (<leader>f 找文件、<leader><leader> 找 git 文件等)。
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- 原生 fzf 排序，速度更快 (需要 make)
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      -- 全局内容搜索，替代 ack.vim (需要 ripgrep)。
      -- 原来挂在 <leader>a 上，但被 nvim-treesitter-textobjects 的参数交换映射
      -- (BufReadPost 时用 vim.keymap.set 设置) 覆盖，实际按不出来，所以挪到 <leader><leader>。
      { "<leader><leader>", "<cmd>Telescope live_grep<cr>", desc = "全局内容搜索" },
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "查找文件" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "查找 Buffer" },
      { "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "当前文件内查找行" },
      { "<leader>m", "<cmd>Telescope oldfiles<cr>", desc = "最近打开的文件" },
      { "<leader>C", "<cmd>Telescope colorscheme<cr>", desc = "切换配色" },
      { "<leader>ag", "<cmd>Telescope grep_string<cr>", desc = "搜索光标下的词" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "查找帮助" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
