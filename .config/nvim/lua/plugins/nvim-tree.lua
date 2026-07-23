-- lua/plugins/nvim-tree.lua
-- 文件树，替代原来的 NERDTree。保留 F2 切换的习惯。
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- 图标 (需 Nerd Font)
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<F2>", "<cmd>NvimTreeToggle<cr>", desc = "切换文件树" },
      { "<leader>n", "<cmd>NvimTreeFindFile<cr>", desc = "在文件树中定位当前文件" },
    },
    opts = {
      hijack_cursor = true,
      view = { width = 32 },
      renderer = {
        highlight_git = true,           -- 原 NERDTreeHighlightCursorline 的进阶版
        group_empty = true,             -- 只有一个子目录时折叠展示 (原 CascadeOpenSingleChildDir)
      },
      filters = {
        dotfiles = false,               -- 显示隐藏文件 (原 NERDTreeShowHidden)
      },
      git = { enable = true },
      actions = { open_file = { quit_on_open = false } },
    },
  },
}
