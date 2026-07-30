# Herdr

[Herdr](https://herdr.dev) 是一个专为 AI 编程 Agent 设计的终端工作区管理器，类似于 tmux，但原生集成了 Claude Code、Codex、Gemini 等 AI 工具的状态感知。

## 安装

### macOS (Homebrew)

```bash
brew install herdr
```

### 写入 dotfiles 并建立符号链接

```bash
# 在 dotfiles 根目录执行
./install
```

这会将 `.config/herdr/config.toml` 软链接到 `~/.config/herdr/config.toml`。

---

## 快速上手

```bash
herdr                        # 启动或附加到持久会话
herdr --session myproject    # 进入或创建具名会话
herdr status                 # 查看当前 server/client 状态
herdr update                 # 更新到最新版本
herdr server reload-config   # 热重载配置（无需重启）
herdr server stop            # 停止 server
```

---

## 键位参考

> 前缀键默认为 `Ctrl+b`（与 tmux 一致）。
>
> 表格中 `<prefix>` 表示先按前缀键，再按后续键。

### 基础操作

| 快捷键 | 功能 |
|--------|------|
| `<prefix> ?` | 显示帮助 / 快捷键列表 |
| `<prefix> s` | 打开设置面板 |
| `<prefix> q` | 从当前会话 detach |
| `<prefix> Shift+R` | 热重载 config.toml |
| `<prefix> o` | 跳转到通知目标 |

### 工作区（Workspace）

| 快捷键 | 功能 |
|--------|------|
| `<prefix> w` | 工作区选择器 |
| `<prefix> g` | 进入 Navigate 模式（见下方） |
| `<prefix> Shift+N` | 新建工作区 |
| `<prefix> Shift+W` | 重命名当前工作区 |
| `<prefix> Shift+D` | 关闭当前工作区 |

### Tab 管理

| 快捷键 | 功能 |
|--------|------|
| `<prefix> c` | 新建 Tab |
| `<prefix> Shift+T` | 重命名当前 Tab |
| `<prefix> p` | 切换到上一个 Tab |
| `<prefix> n` | 切换到下一个 Tab |
| `<prefix> 1–9` | 直接跳转到指定 Tab |

### Pane 导航（Navigate 模式）

按 `<prefix> g` 进入 Navigate 模式，然后使用：

| 键 | 功能 |
|----|------|
| `↑` / `↓` | 在工作区列表中上下移动 |
| `h` | 聚焦左侧 pane |
| `j` | 聚焦下方 pane |
| `k` | 聚焦上方 pane |
| `l` | 聚焦右侧 pane |
| `Enter` / `Esc` | 退出 Navigate 模式 |

### Git Worktree

| 快捷键 | 功能 |
|--------|------|
| `<prefix> Shift+G` | 新建 git worktree |

### 自定义命令绑定（本配置已添加）

| 快捷键 | 功能 |
|--------|------|
| `<prefix> Alt+G` | 在 popup 中打开 `lazygit`（92% × 90%） |
| `<prefix> Alt+M` | 在 popup 中打开 `btop`（系统监控，92% × 90%） |

`[[keys.command]]` 的 `type` 有三种：

| `type` | 行为 | 支持 `width`/`height` |
|--------|------|----------------------|
| `pane` | 在当前 tab 里新开临时 pane，命令退出即关闭，会挤压现有布局 | 否 |
| `popup` | 会话级模态终端，浮在上层，不改变 tab 布局 | 是 |
| `shell` | 完全后台 detached 运行，无 UI | 否 |

`width` / `height` 接受终端单元格数或百分比字符串（`"80%"`）。给非 `popup` 类型设置尺寸会触发配置 diagnostic。

---

## Agent 集成

Herdr 内置识别以下 AI agent：

`claude` · `codex` · `gemini` · `cursor` · `devin` · `cline` · `opencode` · `copilot` · `kimi` · `kiro` · `droid` · `amp` · `grok` · `hermes` · `kilo`

Agent 在后台工作区有状态变化时会通过系统通知推送（已启用 `delivery = "system"`）。

```bash
herdr agent list             # 列出当前所有 agent
herdr integration list       # 查看内置集成状态
```

---

## Session 管理

```bash
herdr session list           # 列出所有具名 session
herdr session attach <name>  # 附加到指定 session
herdr --session work         # 启动或附加 "work" session
herdr --remote user@host     # 通过 SSH 附加远程 Herdr server
```

---

## 实用命令速查

```bash
# 工作区操作
herdr workspace list
herdr workspace new --name ai-project

# Worktree 操作（与 git worktree 联动）
herdr worktree list
herdr worktree new --branch feature/foo

# Tab 操作
herdr tab list
herdr tab new

# Pane 操作
herdr pane list
herdr pane kill <id>

# 通知管理
herdr notification list
herdr notification clear

# 切换更新频道
herdr channel set stable     # 稳定版
herdr channel set preview    # 预览版
```

---

## 配置文件说明

| 区块 | 说明 |
|------|------|
| `[theme]` | 主题名与明暗自动切换，合法值见下方「内置主题」 |
| `[terminal]` | 默认 shell、新 pane 工作目录策略 |
| `[keys]` | 所有快捷键绑定，`[[keys.command]]` 挂载自定义命令 |
| `[ui]` | 侧边栏宽度、鼠标、边框、通知、声音 |
| `[session]` | server 重启后是否恢复 agent 会话 |
| `[remote]` | SSH 远程会话配置 |
| `[experimental]` | CJK IME 光标修复、嵌套运行等实验性功能 |
| `[advanced]` | 每个 pane 的 scrollback 缓存上限 |

### 内置主题

`name` / `dark_name` / `light_name` 三个字段只接受以下 18 个值（herdr 0.7.4）：

| 深色 | 对应浅色 |
|------|----------|
| `catppuccin` | `catppuccin-latte` |
| `tokyo-night` | `tokyo-night-day` |
| `gruvbox` | `gruvbox-light` |
| `one-dark` | `one-light` |
| `solarized` | `solarized-light` |
| `kanagawa` | `kanagawa-lotus` |
| `rose-pine` | `rose-pine-dawn` |
| `dracula` | 无浅色变体 |
| `nord` | 无浅色变体 |
| `vesper` | 无浅色变体 |
| `terminal` | 直接沿用外层终端自身配色 |

命名规则并不统一：深色版多数是裸名（`gruvbox`、`kanagawa`），但 `one-dark` 带后缀；浅色版则各用上游自己的传统叫法（`catppuccin-latte`、`kanagawa-lotus`、`rose-pine-dawn`）。写成 `gruvbox-dark`、`gruvbox_light` 这类都是无效值，而且 **`herdr config check` 对未知主题名仍然返回 `config: ok`，不会报错**，所以拼错只能靠界面没变色发现。

`auto_switch = true` 时实际生效的是 `dark_name` / `light_name`（跟随宿主终端的明暗外观切换），`name` 仅作回退值。因此换主题需要三个字段一起改，只改 `name` 在自动模式下没有效果。本配置当前使用：

```toml
[theme]
name = "gruvbox"
auto_switch = true
dark_name = "gruvbox"
light_name = "gruvbox-light"
```

改完后热重载生效（因为 `~/.config/herdr/config.toml` 是指向本仓库的软链接，编辑仓库内文件即可，无需重跑 `./install`）：

```bash
herdr config check           # 先校验语法
herdr server reload-config   # 或在 TUI 中按 <prefix> Shift+R
```

此外 `[theme.custom]` 可以在基础主题之上覆盖单个色值，接受 hex（`#rrggbb`）、颜色名、`rgb(r,g,b)`，或 `panel_bg = "reset"`：

```toml
[theme.custom]
accent = "#f5c2e7"
```

### CJK 输入法说明

本配置已启用两项 CJK 优化（对中文输入法用户有效）：

```toml
[experimental]
# 前缀模式激活时临时切换为 ASCII 键盘布局，避免中文 IME 拦截前缀键
switch_ascii_input_source_in_prefix = true

# 让外层终端显示光标位置，使输入法候选框跟随 TUI 光标
reveal_hidden_cursor_for_cjk_ime = true
cjk_ime_agents = ["claude", "codex", "gemini", "kiro"]
```

---

## 日志位置

日志按 session 分目录存放（herdr 0.7.x）：

```
~/.config/herdr/sessions/<session>/herdr-server.log
~/.config/herdr/sessions/<session>/herdr-client.log
~/.config/herdr/sessions/<session>/session.json
~/.config/herdr/sessions/<session>/session-history.json
```

`~/.config/herdr/` 根目录下同名的 `herdr-server.log` / `herdr-client.log` 是旧版路径，新版已不再写入，排查问题时不要看错。查看当前目录对应的 session：

```bash
tail -f ~/.config/herdr/sessions/dotfiles/herdr-server.log
```

### 自定义命令闪退排查

popup / pane 类型的自定义命令在命令退出时就会关闭，所以命令不存在时表现为「一闪而过」。日志里的退出码能直接定位原因：

```
pane.exit status="ExitStatus { code: 127, signal: None }"
```

| 退出码 | 含义 |
|--------|------|
| `127` | 命令未找到 —— 对应的工具没安装，或不在 herdr server 的 PATH 中 |
| `126` | 找到了但无法执行 —— 权限不足或架构不匹配 |

注意 popup 在日志中也记为 `pane.spawn` / `pane.exit`（内部复用 pane terminal 实现）。

本配置依赖的外部命令：`lazygit`、`btop`，均已在 `Brewfile-essentials` 与 `config/macos_base.conf.yml` 中声明。
