-- lua/plugins/lualine.lua
-- 状态栏，替代原来的 vim-airline。显示模式、git 分支、文件路径、诊断等。
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "sonokai",
        globalstatus = true,          -- 全局单一状态栏
        section_separators = "",       -- 与原 airline 的极简分隔符一致
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        -- 显示相对文件路径 (延续原 airline_section_c 显示完整路径的习惯)
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {
        -- 顶部显示 buffer 列表，带序号 (原 airline tabline)
        lualine_a = { { "buffers", mode = 2 } },
        lualine_z = { "tabs" },
      },
    },
  },
}
