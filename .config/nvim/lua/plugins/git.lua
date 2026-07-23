-- lua/plugins/git.lua
-- gitsigns：在行号旁显示 git 增删改标记，并提供 hunk 级操作。
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function m(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        m("n", "]c", function() gs.nav_hunk("next") end, "下一个改动块")
        m("n", "[c", function() gs.nav_hunk("prev") end, "上一个改动块")
        m("n", "<leader>hp", gs.preview_hunk, "预览改动")
        m("n", "<leader>hs", gs.stage_hunk, "暂存改动块")
        m("n", "<leader>hr", gs.reset_hunk, "撤销改动块")
        m("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "查看行 blame")
      end,
    },
  },
}
