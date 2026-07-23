# Neovim 配置

从原 Vim (vim-plug) 迁移而来的现代 Lua 配置，使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理插件。

## 安装

配置纳入 dotfiles 仓库，通过软链接生效：

```bash
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
```

首次启动 `nvim` 时，lazy.nvim 会自动安装全部插件，Mason 会按需下载语言服务器。

**前置依赖**（建议安装以获得完整体验）：

```bash
brew install ripgrep fd    # Telescope 内容搜索 / 文件查找
# 终端字体需为 Nerd Font，图标才能正常显示
```

## 目录结构

```
init.lua                 # 入口：设 leader → options → keymaps → autocmds → lazy
lua/config/options.lua   # 编辑器基础选项
lua/config/keymaps.lua   # 通用按键映射
lua/config/autocmds.lua  # 自动命令 (缩进/去空白/记忆光标位置)
lua/config/lazy.lua      # lazy.nvim 引导
lua/plugins/*.lua        # 各插件的独立配置
```

## 插件一览（含 Vim 时代的对应关系）

| 现在 | 替代了 | 作用 |
| --- | --- | --- |
| lazy.nvim | vim-plug | 插件管理 |
| nvim-lspconfig + mason + nvim-cmp | YouCompleteMe / jedi-vim | 补全、跳转、诊断 |
| nvim-treesitter | 正则语法高亮 | 精准高亮与缩进 |
| telescope.nvim | fzf.vim | 模糊查找文件/内容/buffer |
| nvim-tree.lua | NERDTree | 文件树 (F2) |
| lualine.nvim | vim-airline | 状态栏 |
| gitsigns.nvim | — | Git 行内标记与 hunk 操作 |
| flash.nvim | vim-easymotion | 快速跳转 (f / gl) |
| nvim-surround | vim-surround | 成对符号操作 |
| Comment.nvim | nerdcommenter | 注释 (gcc / gc) |
| nvim-autopairs | delimitMate | 自动补全括号 |
| indent-blankline | vim-indent-guides | 缩进参考线 |
| mini.trailspace | vim-better-whitespace | 行尾空白 |
| which-key.nvim | — | 按键提示 |
| render-markdown | vim-markdown | Markdown 渲染 |
| sonokai | molokai | Monokai 风格主题 |

## 常用快捷键（leader = `,`）

| 按键 | 功能 |
| --- | --- |
| `,f` / `,,` | 查找文件 / Git 文件 |
| `,a` | 全局内容搜索 (ripgrep) |
| `,<CR>` | 切换 buffer |
| `,m` | 最近文件 |
| `F2` | 切换文件树 |
| `f` / `gl` | Flash 跳转 |
| `gcc` / `gc` | 注释行 / 选区 |
| `gd` / `gr` / `K` | 跳定义 / 找引用 / 看文档 |
| `,rn` / `,ca` / `,fm` | 重命名 / 代码动作 / 格式化 |
| `,w` / `,ss` | 保存 / 清行尾空白 |
| `Space` | 切换搜索高亮 |
| `,L` | 打开 Lazy 插件面板 |

## 维护

- `:Lazy`      管理插件（安装/更新/清理）
- `:Mason`     管理语言服务器
- `:checkhealth` 排查环境问题
