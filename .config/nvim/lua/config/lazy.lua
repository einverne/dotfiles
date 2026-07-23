-- lua/config/lazy.lua
-- 引导 lazy.nvim 插件管理器，并加载 lua/plugins/ 下的所有插件定义。
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "lazy.nvim 克隆失败:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- 导入 lua/plugins/ 下的每个模块
    { import = "plugins" },
  },
  install = { colorscheme = { "sonokai", "habamax" } },
  checker = { enabled = true, notify = false }, -- 后台检查更新，不打扰
  change_detection = { notify = false },
  ui = { border = "rounded" },
})

-- 快捷打开插件面板
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "打开 Lazy 插件面板" })
