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
| telescope.nvim | fzf.vim | 模糊查找文件/全文检索内容/buffer |
| nvim-tree.lua | NERDTree | 文件树 (F2) |
| lualine.nvim | vim-airline | 状态栏 |
| gitsigns.nvim | — | Git 行内标记与 hunk 操作 |
| flash.nvim | vim-easymotion | 快速跳转 (f / F / S) |
| nvim-surround | vim-surround | 成对符号操作 |
| Comment.nvim | nerdcommenter | 注释 (gcc / gc) |
| nvim-autopairs | delimitMate | 自动补全括号 |
| indent-blankline | vim-indent-guides | 缩进参考线 |
| mini.trailspace | vim-better-whitespace | 行尾空白 |
| which-key.nvim | — | 按键提示 |
| render-markdown | vim-markdown | Markdown 渲染 |
| obsidian.nvim | — | Obsidian 仓库笔记（双链/反链/日记） |
| sonokai | molokai | Monokai 风格主题 |

## 常用快捷键（leader = `,`）

### 查找 / 导航

| 按键    | 功能 |
|-------| --- |
| `,f`  | 查找文件 |
| `,,`  | 全局内容搜索 (Telescope live_grep) |
| `,fb` | 切换 buffer |
| `,m`  | 最近打开的文件 |
| `,fl` | 当前文件内查找行 |
| `,fh` | 查找帮助 |
| `,ag` | 搜索光标下的词 (Telescope grep_string) |
| `,C`  | 切换配色 |
| `F2`  | 切换文件树 |
| `,n`  | 在文件树中定位当前文件 |

### 跳转 / 编辑

| 按键 | 功能 |
| --- | --- |
| `f` / `F` | Flash 跳转（双向 / 向后），覆盖了原生 `f`/`F`；`t`/`T` 仍是原生 till |
| `S` | Flash Treesitter 选择 |
| `gcc` / `gc` | 注释行 / 选区 (Comment.nvim) |
| `ys{motion}{c}` / `ds{c}` / `cs{c1}{c2}` | 加 / 删 / 改 成对符号 (nvim-surround) |
| `Tab`（普通/可视模式） | 跳到配对括号 |
| `<M-j>` / `<M-k>` | 当前行/选区上移一行 / 下移一行 |
| `,ss` | 清除当前 buffer 行尾空白 |
| `,w` / `,W` | 保存 / sudo 保存 |

### 语法文本对象 (nvim-treesitter-textobjects)

在 visual / operator-pending 模式下用 `a`（外部）/ `i`（内部）+ 下列字母组合成文本对象，例如 `daf` 删整个函数、`vic` 选中类内部、`cia` 改当前参数：

| 字母 | 对象 |
| --- | --- |
| `f` | 函数 `@function` |
| `c` | 类 `@class` |
| `a` | 参数 `@parameter` |
| `l` | 循环 `@loop` |
| `i` | 条件 `@conditional` |

| 按键 | 功能 |
| --- | --- |
| `]f` / `[f` | 下一个 / 上一个函数开头 |
| `]F` / `[F` | 下一个 / 上一个函数结尾 |
| `]c` / `[c` | 下一个 / 上一个类开头（不在 git 仓库、或 gitsigns 未附加时；否则见下方冲突说明） |
| `,a` / `,A` | 与下一个 / 上一个参数交换 |
| `;` / `,` | 重复 / 反向重复上一次的 treesitter 移动 |

### Git (gitsigns.nvim)

| 按键 | 功能 |
| --- | --- |
| `]c` / `[c` | 下一个 / 上一个改动块（仅 git 仓库内、buffer 已附加 gitsigns 时生效） |
| `,hp` / `,hs` / `,hr` | 预览 / 暂存 / 撤销 改动块 |
| `,hb` | 查看当前行 blame |

### LSP / 诊断

| 按键 | 功能 |
| --- | --- |
| `gd` / `gr` / `gi` / `K` | 跳转定义 / 查找引用 / 跳转实现 / 查看文档 |
| `,rn` / `,ca` / `,fm` | 重命名 / 代码动作 / 格式化 |
| `[d` / `]d` | 上一个 / 下一个诊断 |
| `,e` | 查看诊断详情 |

### 其它

| 按键 | 功能 |
| --- | --- |
| `Space` | 切换搜索高亮 |
| `,L` | 打开 Lazy 插件面板 |

### 已知按键冲突

Neovim 里同一个按键被多处注册时：**buffer-local 映射优先于全局映射**；都是全局映射时**后设置的覆盖先设置的**。这份配置里目前有一处：

- **`]c` / `[c`**：gitsigns（buffer-local，"下一个/上一个改动块"）与 treesitter-textobjects（全局，"下一个/上一个类开头"）共用同一个键。在 git 仓库内、gitsigns 附加后走改动块导航；其余情况走类导航。

> 历史遗留：`,a` 曾经同时被 telescope（全局内容搜索）和 treesitter-textobjects（参数交换）注册，
> 后者总是覆盖前者，导致全局搜索按键失效。现已把全局搜索挪到 `,,`，`,a` 现在专属于参数交换，不再冲突。

## Obsidian 笔记（`,o` 前缀）

仓库配置对齐 `~/Sync/wiki/.obsidian/`，和 Obsidian App 共用同一套目录约定：
新笔记进 `Zettelkasten/`、日记进 `notes/journals/`、模板在 `Template/`、附件在 `Attachments/`。

| 按键 | 功能 |
| --- | --- |
| `,oo` / `,os` | 快速切换笔记 / 全文搜索 |
| `,ok` / `,ob` / `,ol` / `,oc` | 标签 / 反链 / 链接 / 大纲 |
| `,on` / `<C-n>`（后者仅 markdown buffer） | 新建笔记 |
| `,oz` / `,oF` | 时间戳笔记 / 插入模板 |
| `,ot` / `,oy` / `,oT` / `,od` | 今天 / 昨天 / 明天 / 日记列表 |
| `,ox` / `,or` / `,op` | 切换勾选 / 重命名(同步反链) / 粘贴图片 |
| `,oL` / `,oN` / `,oe` | 选区：链接已有笔记 / 新建并链接 / 抽成新笔记 |
| `,ow` | 切换仓库 (wiki / private / research / japanese) |
| `gf` / `<CR>` | 跟随光标所在的 `[[双链]]` 跳转到对应笔记（不存在则新建）；`<CR>` 不在链接上时是切换 checkbox |
| `]o` / `[o` | 光标跳到当前笔记内下一个 / 上一个链接（只移动光标，不打开） |

`gf`、`<CR>`、`]o`/`[o` 都是插件进入 markdown buffer 时自动注册的 buffer-local 映射，不在本仓库配置里，关闭方式是设 `vim.g.obsidian_default_keymap = false`。

### 新建笔记的模板

| 命令 | 模板 | `title:` 填成 |
| --- | --- | --- |
| `,on` / `<C-n>` 新建（`,oN` / `,oe` / 补全里建笔记同此） | `Template/Jekyll Template.md` | 输入的标题 |
| `,oz` 时间戳笔记 | `Template/Jekyll Template.md` | 时间戳，如 `202607301429` |
| `,ot` 日记 | 不套模板 | — |

模板里的 YAML 会**原样保留**（因为关掉了 `frontmatter`），只有 `{{title}}` 这类占位符会被替换。
`{{title}}` 走 `display_name()`：有标题用标题，否则回退到笔记 ID，所以 `,oz` 填进去的是时间戳。
这个占位符 Obsidian 核心 Templates 插件也认，App 那边套同一份模板同样生效。

日记刻意不套模板：`Template/Daily Template.md` 用的是 Templater 的 `<% tp.* %>` 语法，
obsidian.nvim 只认 `{{date}}` / `{{title}}`，套上去只会把原始标记插进笔记里。

> 模板 `Template/Jekyll Template.md` 的 `title:` 已改成 `"{{title}}"`（在 vault 里，不在本仓库）。

两个刻意关掉的默认行为：`ui`（渲染让给 render-markdown.nvim，否则抢 conceal）、
`frontmatter`（既避免保存时往既有 Jekyll 风格笔记里塞 `id:` 污染 Syncthing 同步，
也保证上面的模板头不被重写）。

## 维护

- `:Lazy`      管理插件（安装/更新/清理）
- `:Mason`     管理语言服务器
- `:checkhealth` 排查环境问题
- `:checkhealth obsidian` 排查笔记仓库配置
