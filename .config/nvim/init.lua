-- ~/.config/nvim/init.lua
-- Neovim 配置入口。加载顺序：先设置 leader 和基础选项，再引导 lazy.nvim 加载插件。
-- 由 vim 迁移而来，保留了原 .vimrc 的核心设置与按键习惯（leader=",").

-- leader 必须在插件加载之前设置，否则插件里的 <leader> 映射会用错前缀
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
