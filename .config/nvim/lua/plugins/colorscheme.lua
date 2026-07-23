-- lua/plugins/colorscheme.lua
-- sonokai：Monokai 风格、对 Treesitter/LSP 支持完善的现代主题，
-- 延续原配置 molokai/monokai 的观感。
return {
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000, -- 主题要最先加载
    config = function()
      vim.g.sonokai_style = "default"
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 1
      vim.cmd.colorscheme("sonokai")
    end,
  },
}
