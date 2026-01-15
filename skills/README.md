# Antigravity / Claude Code Agent Skills

这个目录包含了一系列可以在 Antigravity 和 Claude Code 中使用的 Agent Skills。这些技能遵循开放的 Agent Skills 标准，可以扩展 AI 助手的能力。

## 可用技能

### 1. git-commit-formatter
Git 提交信息格式化器，自动生成符合 Conventional Commits 规范的提交信息。

**触发词**: 生成提交、创建 commit、写提交信息

**使用场景**:
```bash
# 在暂存代码后
git add .
# 然后在 AI 助手中说
"帮我生成一个提交信息"
```

### 2. code-reviewer
代码审查助手，进行系统化的代码质量、安全性和性能检查。

**触发词**: 审查代码、review、检查代码

**使用场景**:
```bash
"审查这个文件的代码质量"
"Review src/api/user.ts"
```

### 3. deploy-staging
部署助手，将代码部署到测试环境并执行完整的验证流程。

**触发词**: 部署、发布到测试、staging 环境

**使用场景**:
```bash
"部署到 staging 环境"
"发布到测试环境"
```

### 4. react-component-generator
React 组件生成器，自动创建符合项目规范的组件文件结构。

**触发词**: 创建组件、新建 React 组件、生成组件

**使用场景**:
```bash
"创建一个 Button 组件"
"生成一个 UserCard 组件"
```

## 安装方法

### 项目级安装

将技能复制到项目的 `.agent/skills/` 目录：

```bash
# 克隆仓库
git clone https://github.com/einverne/dotfiles.git

# 复制所有技能到项目
cd your-project
cp -r ~/dotfiles/skills/* .agent/skills/

# 或者只复制特定技能
cp -r ~/dotfiles/skills/git-commit-formatter .agent/skills/
```

### 全局安装

将技能安装到全局目录，在所有项目中都可使用：

```bash
# Antigravity 全局目录
cp -r ~/dotfiles/skills/* ~/.gemini/antigravity/skills/

# Claude Code 全局目录
cp -r ~/dotfiles/skills/* ~/.claude/skills/
```

## 技能结构

每个技能都是一个目录，包含一个 `SKILL.md` 文件：

```
skill-name/
└── SKILL.md    # 技能定义文件
```

`SKILL.md` 文件包含：
- YAML 前置元数据（name 和 description）
- 详细的执行指令
- 使用示例
- 错误处理说明

## 自定义技能

你可以根据自己的需求修改这些技能，或创建新的技能。

基本结构：

```markdown
---
name: your-skill-name
description: 简短描述，AI 用它判断是否需要激活此技能
---

# 技能标题

## 任务说明
描述这个技能要做什么

## 执行步骤
1. 第一步
2. 第二步
3. 第三步

## 质量标准
必须遵守的规范

## 示例输出
期望的输出格式
```

## 相关资源

- [Agent Skills 官方文档](https://antigravity.google/docs/skills)
- [Agent Skills 开放标准](https://agentskills.io/home)
- [完整教程](https://gtk.einverne.info/posts/2026-01-15-antigravity-agent-skills.html)

## 贡献

欢迎提交 Pull Request 来改进这些技能或添加新技能。

## 许可证

MIT License
