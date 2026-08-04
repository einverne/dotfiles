-- lua/plugins/outline.lua
-- 代码大纲侧边栏，基于 LSP document symbols，用 F3 切换（F2 是文件树）。
return {
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<F3>", "<cmd>Outline<cr>", desc = "切换代码大纲" },
    },
    opts = {
      outline_window = { width = 25 },
    },
  },
}
