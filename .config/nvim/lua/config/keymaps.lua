-- lua/config/keymaps.lua
-- 通用按键映射，迁移自原 .vim/startup/map_vimrc。
-- 插件相关的映射放在各自的 lua/plugins/*.lua 里。
local map = vim.keymap.set

-- 把长行的 j/k 当作屏幕行移动 (long lines as break lines)
map({ "n", "v" }, "j", "gj", { desc = "下移一屏幕行" })
map({ "n", "v" }, "k", "gk", { desc = "上移一屏幕行" })

-- 快速保存
map("n", "<leader>w", "<cmd>w!<cr>", { desc = "保存文件" })

-- 用 Tab 作为 % 跳转配对括号
map({ "n", "v" }, "<tab>", "%", { desc = "跳到配对括号" })

-- 窗口之间移动 (与 tmux-navigator 类似的手感)
map("n", "<C-j>", "<C-w>j", { desc = "移到下方窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "移到上方窗口" })
map("n", "<C-h>", "<C-w>h", { desc = "移到左侧窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "移到右侧窗口" })

-- 标签页管理
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "新建标签页" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "只保留当前标签页" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "关闭标签页" })

-- 禁用方向键，强制养成 hjkl 习惯
for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  map({ "n", "i" }, key, "<Nop>")
end

-- 与系统剪贴板交互 (显式，避免误操作)
map({ "n", "v" }, "<C-y>", '"+y', { desc = "复制到系统剪贴板" })
map({ "n", "v" }, "<C-p>", '"+gP', { desc = "从系统剪贴板粘贴" })

-- 快速上下移动当前行 / 选区
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "下移一行" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "上移一行" })
map("i", "<A-j>", "<Esc><cmd>m .+1<cr>==gi", { desc = "下移一行" })
map("i", "<A-k>", "<Esc><cmd>m .-2<cr>==gi", { desc = "上移一行" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "下移选区" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "上移选区" })

-- 空格切换搜索高亮
map("n", "<Space>", "<cmd>set hlsearch! hlsearch?<cr>", { desc = "切换搜索高亮" })

-- 以 root 权限保存
map("n", "<leader>W", "<cmd>w !sudo tee % > /dev/null<cr>", { desc = "sudo 保存" })

-- 去除行尾空白 (原 StripWhitespace)
map("n", "<leader>ss", function()
  local save = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(save)
end, { desc = "清除行尾空白" })

-- 诊断跳转 (LSP)
map("n", "[d", vim.diagnostic.goto_prev, { desc = "上一个诊断" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "下一个诊断" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "查看诊断详情" })

-- FormatXML：用 python3 格式化 XML (迁移自原 = 映射)
vim.api.nvim_create_user_command("FormatXML", function()
  vim.cmd([[%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"]])
end, {})
