# Tmux 远程剪贴板配置说明

## 功能说明

此配置允许在远程服务器的 tmux 会话中复制文本时,自动将内容同步到本地计算机的剪贴板。使用 OSC 52 转义序列实现。

## 工作原理

1. **OSC 52**: 使用 ANSI 转义序列将剪贴板内容从远程终端传输到本地终端
2. **tmux-yank**: 与 OSC 52 集成,实现无缝复制体验
3. **终端模拟器支持**: 需要终端模拟器支持 OSC 52 协议

## 支持的终端模拟器

### ✅ 完全支持
- **iTerm2** (macOS) - 默认支持,推荐
- **kitty** - 默认支持
- **Alacritty** - 需要启用配置
- **WezTerm** - 默认支持
- **tmux** (>= 3.3) - 需要 `set -g allow-passthrough on`

### ⚠️ 部分支持
- **Terminal.app** (macOS) - 有限支持
- **Windows Terminal** - 需要最新版本
- **Hyper** - 需要插件

### ❌ 不支持
- **PuTTY** (旧版本)
- **SecureCRT** (部分版本)

## 使用方法

### 在 Tmux 中复制

1. **进入复制模式**: `prefix + [`
2. **开始选择**: 按 `v` (vi 模式)
3. **复制到剪贴板**: 按 `y`
4. **退出复制模式**: 按 `Escape` 或 `q`

### 使用鼠标复制

- 使用鼠标选择文本
- 释放鼠标按钮时自动复制到剪贴板

### 命令行使用

```bash
# 复制文件内容到本地剪贴板
cat file.txt | ~/dotfiles/tmux/scripts/yank.sh

# 复制命令输出到本地剪贴板
echo "Hello World" | ~/dotfiles/tmux/scripts/yank.sh
```

## 配置检查

### 验证 Tmux 版本
```bash
tmux -V
# 建议 >= 3.3
```

### 测试 OSC 52 支持
```bash
# 运行此命令,如果本地剪贴板有 "test" 则成功
printf "\033]52;c;%s\007" "$(echo -n test | base64)"
```

### 重新加载配置
```bash
# 在 tmux 会话中
prefix + r

# 或使用命令
tmux source-file ~/.tmux.conf
```

## 终端模拟器配置

### iTerm2
默认已启用,无需额外配置。

### Alacritty
在 `~/.config/alacritty/alacritty.yml` 中添加:
```yaml
selection:
  save_to_clipboard: true
```

### kitty
在 `~/.config/kitty/kitty.conf` 中添加:
```
clipboard_control write-clipboard write-primary
```

### WezTerm
默认已启用,无需额外配置。

## 故障排除

### 问题: 复制不工作

1. **检查终端支持**
   ```bash
   # 测试 OSC 52
   printf "\033]52;c;%s\007" "$(echo -n test | base64)"
   # 粘贴,应该看到 "test"
   ```

2. **检查 Tmux 配置**
   ```bash
   tmux show-options -g | grep allow-passthrough
   # 应该显示: allow-passthrough on
   ```

3. **检查插件安装**
   ```bash
   ls ~/.tmux/plugins/tmux-yank
   # 如果不存在,在 tmux 中按 prefix + I 安装
   ```

### 问题: 长文本无法复制

OSC 52 有长度限制 (通常 100KB):
- 对于大文件,使用 scp 或其他文件传输工具
- 或者分段复制

### 问题: SSH 会话中不工作

确保 SSH 配置正确:
```bash
# ~/.ssh/config
Host *
    ForwardAgent yes
```

## 性能影响

- OSC 52 传输: 几乎无延迟 (< 10ms)
- 最大支持长度: ~100KB
- 建议用于: 代码片段、配置文件、日志片段

## 安全考虑

- OSC 52 数据通过 SSH 加密传输
- 数据不经过中间服务器
- 仅在受信任的终端模拟器中启用

## 参考链接

- [OSC 52 规范](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands)
- [tmux-yank 插件](https://github.com/tmux-plugins/tmux-yank)
- [Tmux 文档](https://github.com/tmux/tmux/wiki)
