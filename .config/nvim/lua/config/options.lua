-- lua/config/options.lua
-- 基础编辑器选项，迁移自原 .vimrc。
local opt = vim.opt

-- 界面
opt.number = true            -- 显示行号 (set nu)
opt.cursorline = true        -- 高亮当前行
opt.ruler = true             -- 右下角显示光标位置
opt.showcmd = true           -- 显示正在输入的命令
opt.showmode = true          -- 左下角显示当前模式
opt.cmdheight = 1            -- 命令栏高度 (nvim 下 1 行足够)
opt.scrolloff = 4            -- 光标上下保留的行数
opt.signcolumn = "yes"       -- 常显符号列，避免 gitsigns/诊断跳动
opt.termguicolors = true     -- 开启真彩色 (现代主题必需)
opt.mouse = "a"              -- 启用鼠标

-- 搜索
opt.ignorecase = true        -- 搜索忽略大小写
opt.smartcase = true         -- 含大写时区分大小写
opt.hlsearch = true          -- 高亮搜索结果
opt.incsearch = true         -- 边输入边搜索

-- 缩进 (默认 4 空格，具体文件类型在 autocmds.lua 里覆盖)
opt.expandtab = true         -- Tab 转空格
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.smartindent = true

-- 换行与不可见字符
opt.wrap = true
opt.list = true
opt.listchars = { extends = ">", precedes = "<", tab = "▸ ", trail = "·", nbsp = "_" }

-- 窗口切分
opt.splitbelow = true
opt.splitright = true

-- 文件与备份
opt.autoread = true          -- 外部修改后自动重新读取
opt.hidden = true            -- 允许未保存就切换 buffer
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = false         -- 关闭持久化 undo (与原 .vimrc 的 noundofile 一致)

-- 编码
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = "ucs-bom,utf-8,gbk,gb2312,cp936,gb18030,big5,shift-jis,euc-jp,euc-kr,latin1"
opt.bomb = false

-- CJK 特殊字符按双字节宽度处理
if vim.fn.match(vim.v.lang or "", [[^\(zh\)\|\(ja\)\|\(ko\)]]) >= 0 then
  opt.ambiwidth = "double"
end

-- 体验优化
opt.updatetime = 300         -- 更快的 CursorHold / 诊断刷新
opt.timeoutlen = 400         -- which-key 提示更快弹出
opt.completeopt = { "menu", "menuone", "noselect" }
opt.clipboard = ""           -- 不接管系统剪贴板，保留原有 C-y/C-p 显式映射
