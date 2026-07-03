# Herdr

Herdr 是一个专为 AI 编程 Agent 设计的终端工作区管理器，类似于 tmux，但原生集成了 Claude Code、Codex、Gemini 等 AI 工具的状态感知。

官网：<https://herdr.dev>

---

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

这会将 `herdr/config.toml` 软链接到 `~/.config/herdr/config.toml`。

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
| `<prefix> Alt+G` | 在临时 pane 中打开 `lazygit` |
| `<prefix> Alt+M` | 在临时 pane 中打开 `btop`（系统监控） |

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
| `[theme]` | 主题，支持 catppuccin / tokyo-night / dracula / nord / gruvbox 等 |
| `[terminal]` | 默认 shell、新 pane 工作目录策略 |
| `[keys]` | 所有快捷键绑定，`[[keys.command]]` 挂载自定义命令 |
| `[ui]` | 侧边栏宽度、鼠标、边框、通知、声音 |
| `[session]` | server 重启后是否恢复 agent 会话 |
| `[remote]` | SSH 远程会话配置 |
| `[experimental]` | CJK IME 光标修复、嵌套运行等实验性功能 |
| `[advanced]` | 每个 pane 的 scrollback 缓存上限 |

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

```
~/.config/herdr/herdr.log
~/.config/herdr/herdr-client.log
~/.config/herdr/herdr-server.log
```
