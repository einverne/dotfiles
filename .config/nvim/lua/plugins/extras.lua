-- lua/plugins/extras.lua
-- 从原 Vim 配置迁移的两个官方插件（本身即兼容 Neovim，无需 Lua 重写版）。
return {
  -- beancount：复式记账语法高亮 + 账户补全 + 金额对齐。
  {
    "nathangrigg/vim-beancount",
    ft = { "beancount", "bean" },
    init = function()
      -- 迁移自原 vundle_vimrc 的 beancount 设置
      vim.g.beancount_root = "~/Sync/beancount/main.bean"
      vim.g.beancount_account_completion = "chunks"
      vim.g.beancount_detailed_first = 1
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "beancount", "bean" },
        group = vim.api.nvim_create_augroup("beancount_maps", { clear = true }),
        callback = function(ev)
          -- 输入 . 时自动对齐金额 (原 AlignCommodity 映射)
          vim.keymap.set("i", ".", ".<c-o>:AlignCommodity<cr>", { buffer = ev.buf })
          -- Tab 触发账户 omni 补全 (原 <c-x><c-o> 映射)
          vim.keymap.set("i", "<Tab>", "<c-x><c-o>", { buffer = ev.buf })
        end,
      })
    end,
  },

  -- wakatime：自动统计编码时间。官方插件，同时支持 vim / nvim。
  -- 首次启动会提示输入 API Key，写入 ~/.wakatime.cfg。
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
}
