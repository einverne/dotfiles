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
xcode-select --install     # make + C 编译器，telescope-fzf-native 要编译原生库
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
| LuaSnip + friendly-snippets | — | 代码片段展开（Vim 时代没装独立片段插件） |
| nvim-treesitter | 正则语法高亮 | 精准高亮与缩进 |
| telescope.nvim | fzf.vim | 模糊查找文件/全文检索内容/buffer |
| nvim-tree.lua | NERDTree | 文件树 (F2) |
| outline.nvim | tagbar | 代码大纲 (F3，基于 LSP document symbols) |
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
| `F3`  | 切换代码大纲 (outline.nvim) |

### 跳转 / 编辑

| 按键 | 功能 |
| --- | --- |
| `f` / `F` | Flash 跳转（双向 / 向后），覆盖了原生 `f`/`F`；`t`/`T` 仍是原生 till |
| `S` | Flash Treesitter 选择 |
| `gcc` / `gc` | 注释行 / 选区 (Comment.nvim) |
| `ys{motion}{c}` / `ds{c}` / `cs{c1}{c2}` | 加 / 删 / 改 成对符号 (nvim-surround) |
| `ysiwl` / `Sl`（可视模式） | 把光标下的词 / 选区包成 markdown 链接，URL 取自系统剪贴板（见下方「Markdown 链接」） |
| `csll` / `dsl` | 换掉链接的 URL（`cs` 要 target + replacement 两个字符）/ 拆掉链接只留显示文字 |
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

## 代码片段 (LuaSnip)

片段引擎是 [LuaSnip](https://github.com/L3MON4D3/LuaSnip)，片段库是 [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)（VSCode 格式，按 filetype 懒加载），
两者都在 `plugins/cmp.lua` 里作为 nvim-cmp 的依赖引入，展开出来的候选走 `luasnip` 这个补全来源。

用法：**插入模式**敲片段前缀 → nvim-cmp 弹出候选（图标是 Snippet）→ 确认展开 → 在占位符之间跳。

| 按键 | 作用 |
| --- | --- |
| `<CR>` | 确认候选，展开片段 |
| `<Tab>` / `<S-Tab>` | 展开后：跳到下一个 / 上一个占位符 |
| `<C-Space>` | 手动唤出补全菜单（前缀太短没自动弹时用） |

> ⚠️ `<Tab>` 在**补全菜单可见时**是「选下一项」，只有菜单关掉、片段已展开后才是「跳占位符」。
> 所以确认候选请用 `<CR>`，习惯性按 `<Tab>` 只会在候选列表里往下走。
> （普通/可视模式的 `Tab` 是跳配对括号，和这里无关。）

### 常用 markdown 片段

| 前缀 | 展开成 |
| --- | --- |
| `l` / `link` | `[text](url)` |
| `img` | `![alt text](path)` |
| `u` / `url` | `<url>` |
| `h1` … `h6` | 各级标题 |
| `b` / `i` / `bi` | `**粗体**` / `*斜体*` / `***粗斜体***` |
| `code` / `codeblock` | 行内代码 / 围栏代码块（带语言占位符） |
| `task` / `task2` … `task5` | 1 ~ 5 条 `- [ ]` 待办 |
| `2x3table` / `3x3table` / `3x5table` … | N 行 M 列的表格骨架 |
| `quote` / `strikethrough` / `horizontal rule` | 引用 / `~~删除线~~` / `----------` |

完整清单见 `~/.local/share/nvim/lazy/friendly-snippets/snippets/markdown.json`。

### 加自己的片段

`cmp.lua` 里调的是不带参数的 `lazy_load()`，只会扫 runtimepath 上各插件自带的 `snippets/` 目录，
**不会**读本仓库里的片段。要放自己的片段，得给它传 `paths`：

```lua
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})
```

## Markdown 链接

插链接有三条路，按「文字是否已经存在」来选：

| 场景 | 做法 | 产出 |
| --- | --- | --- |
| 从零敲一个链接 | 插入模式 `link` → `<CR>` → `<Tab>` 填 URL | `[text](url)` |
| 文字已在 buffer 里，URL 在剪贴板 | 光标停在词上 `ysiwl`；或可视选中后 `Sl` | `[文字](剪贴板 URL)` |
| 改已有链接的 URL / 拆掉链接 | 光标在链接内 `csll` / `dsl` | 换 URL / 只留显示文字 |
| 链接到仓库里的另一篇笔记 | 插入模式敲 `[[` 触发笔记名补全；或可视模式 `,oL` | `[[笔记名]]` |

这套按键是本仓库在 `plugins/editor.lua` 里给 nvim-surround 自定义的 `l`（link）surround：

| 按键 | 作用 |
| --- | --- |
| `ysiwl` | 光标下的词 → `[词](剪贴板 URL)` |
| `Sl`（可视模式选中后） | 选区 → `[选区](剪贴板 URL)` |
| `csll` | 光标在链接内，把 URL 换成剪贴板里的新值，显示文字不动 |
| `dsl` | 拆掉链接，只留下显示文字 |

几个实现上的坑：

- `csll` 是**两个** `l`：`cs{target}{replacement}` 要求 target 和 replacement 各一个字符，只按 `csl` 会卡在等待第二个字符的状态。`ds{target}` 只要一个，所以是 `dsl`。
- `add` 写成函数而不是静态字符串，才能在**每次调用时**现读剪贴板；写成表的话 URL 会在 lazy.nvim 求值 `opts` 那一刻被固化。
- 顺带把剪贴板里的空白字符全删掉，避免从浏览器复制时带上的换行插进链接里。
- `delete` / `change.target` 的捕获组有硬性约定（`:h nvim-surround.config.get_selections()`）：**第 1、3 组是左右分隔符的文本捕获，第 2、4 组必须是空的位置捕获 `()`**。
  写成 `(.-)` 这类文本捕获会被当成分隔符删掉。这里左分隔符是 `[`、右分隔符是 `](url)`，和 `add` 的产出正好对称。
- 只写 `add` 的话就只能加不能删改，`dsl` / `csll` 依赖 `find` / `delete` / `change`。
  模式里的 `%b[]` 是 Lua 的平衡匹配，`[see [x] here](url)` 这种嵌套方括号也能圈出完整链接。
- `l` 不在 nvim-surround 的默认 surround 表里（默认是 `(` `{` `"` `t` 这些），所以全局注册不会撞键。

第三条路产出的是 `[[双链]]` 而不是 `[](...)`，因为 `plugins/obsidian.lua` 里设了 `link.style = "wiki"`，
对齐 vault 的 `app.json`（`useMarkdownLinks=false`）—— 这是刻意的，改成 markdown 链接会和 Obsidian App 那边不一致。

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

`<CR>`、`]o`/`[o` 是插件进入 markdown buffer 时自动注册的 buffer-local 映射，不在本仓库配置里，关闭方式是设 `vim.g.obsidian_default_keymap = false`。
`gf` 则是本仓库在 `plugins/obsidian.lua` 里额外补的 buffer-local 映射：插件本身只给 `includeexpr` 配合原生 `gf` 用，但原生 `gf` 依赖 `'isfname'` 先在光标处圈出一段"像文件名"的字符，
默认 `isfname` 不含 `[`、`]` 和空格，光标停在方括号或标题里的空格上时原生 `gf`会直接失效（`includeexpr` 都不会被调用）；这里改成光标在链接范围内就用 `:Obsidian follow_link`，其余情况落回原生 `gf`。

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

### 重新编译 telescope-fzf-native

telescope 的模糊排序默认是纯 Lua 的 `fzy` 算法，候选一多就会卡。
`plugins/telescope.lua` 里把 [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) 作为依赖引入，
用 `build = "make"` 编出一个 C 实现的原生排序器顶替掉默认的 sorter——注意它替换的只是**排序**，
真正列文件 / 搜内容的仍然是 `fd` 和 `rg`。

判断有没有生效，看编译产物在不在：

```bash
ls ~/.local/share/nvim/lazy/telescope-fzf-native.nvim/build/libfzf.so
```

文件不存在（换新机器、`make` 当时失败、误删 build 目录）就在 nvim 里重编：

```vim
:Lazy build telescope-fzf-native.nvim
```

> ⚠️ 编译失败是**静默**的：`telescope.lua` 里用 `pcall(telescope.load_extension, "fzf")` 包住加载，
> 缺编译器的机器上 nvim 不会报错，只会悄悄退回 Lua 排序，表现为"最近搜起来有点慢"。
> 这是有意的健壮性取舍，代价就是得靠上面那条 `ls` 主动自查。

> macOS 上产物也叫 `.so` 而不是 `.dylib`，这是对的：Lua 的 `package.cpath` 按约定加载 `.so`。
