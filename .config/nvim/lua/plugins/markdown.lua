-- lua/plugins/markdown.lua
-- Markdown 增强，替代 plasticboy/vim-markdown。
-- 语法高亮已由 Treesitter 接管，这里加上编辑器内的美观渲染。
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      heading = { enabled = true },
      code = { enabled = true },
    },
  },
}
