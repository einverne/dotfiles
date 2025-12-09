# Claude Skills for Dotfiles Management

This directory contains Claude Code skills that provide specialized expertise for common development tasks, especially related to managing and maintaining dotfiles.

## What are Skills?

Skills are specialized capabilities that Claude can invoke to provide expert assistance in specific domains. Each skill is a folder containing a `SKILL.md` file with detailed knowledge and best practices for its area of expertise.

At startup, Claude pre-loads the name and description of every installed skill, allowing it to know when each skill should be used without loading all content into context initially.

## Available Skills

### 🔧 Development & Configuration

#### 1. **dotfiles-manager**
Expert in managing dotfiles, configuration files, and setting up development environments across different systems.

**Use for:**
- Organizing and structuring dotfiles
- Setting up symlinks with GNU Stow or dotbot
- Managing secrets and platform-specific configs
- Creating bootstrap scripts
- Migrating configs between machines

**Example:** "Help me reorganize my vim configuration" or "How do I make my zshrc portable across macOS and Linux?"

#### 2. **shell-scripting**
Expert in Bash and Zsh scripting, automation, command-line tools, and shell best practices.

**Use for:**
- Writing robust shell scripts
- Shell script debugging
- Using modern CLI tools (ripgrep, fd, fzf)
- Bash/Zsh best practices
- Command-line automation

**Example:** "Write a script to backup my configs" or "How do I properly handle errors in bash?"

### 🔍 Development Tools

#### 3. **git-workflow**
Expert in Git operations, branch management, commit best practices, and resolving merge conflicts.

**Use for:**
- Git workflow strategies
- Writing good commit messages
- Resolving merge conflicts
- Branch management
- Git history manipulation
- Pull request workflows

**Example:** "Help me rebase my feature branch" or "How do I write better commit messages?"

#### 4. **debug-helper**
Expert in debugging strategies, troubleshooting techniques, and systematic problem-solving.

**Use for:**
- Systematic debugging approaches
- Using debuggers (pdb, gdb, etc.)
- Troubleshooting system issues
- Log analysis
- Network debugging
- Performance issues

**Example:** "My script fails intermittently, how do I debug it?" or "Help me trace this issue"

### ⚡ Optimization & Quality

#### 5. **performance-optimizer**
Expert in analyzing and optimizing code performance, identifying bottlenecks, and implementing efficient solutions.

**Use for:**
- Profiling code
- Finding bottlenecks
- Algorithm optimization
- Memory optimization
- Database query optimization
- Shell script performance

**Example:** "My script is slow, help me optimize it" or "How do I profile this Python code?"

#### 6. **test-expert**
Expert in writing comprehensive tests, test-driven development, and testing best practices.

**Use for:**
- Writing unit tests
- Integration testing
- Test-driven development (TDD)
- Mocking and fixtures
- Testing shell scripts
- Coverage analysis

**Example:** "Help me write tests for this function" or "How do I test this bash script?"

## How to Use Skills

### In Claude Code CLI

Skills are automatically available when using Claude Code. You can reference them in your conversations:

```
You: "I need help optimizing my shell script"
Claude: [May invoke performance-optimizer skill]

You: "Help me set up dotfile syncing"
Claude: [May invoke dotfiles-manager skill]
```

### Invoking Specific Skills

You can explicitly ask Claude to use a specific skill:

```
"Use the git-workflow skill to help me with rebasing"
"Apply the debug-helper skill to troubleshoot this issue"
"Use the test-expert skill to write tests for my function"
```

## Skill Structure

Each skill is organized as a directory containing a `SKILL.md` file:

```
.claude/skills/
├── skill-name/
│   └── SKILL.md
├── another-skill/
│   └── SKILL.md
└── README.md
```

### SKILL.md Format

1. **YAML Frontmatter** (required):
```yaml
---
name: skill-name
description: What the skill does and when Claude should use it (max 1024 chars)
---
```

**Frontmatter Requirements:**
- `name`: Lowercase letters, numbers, and hyphens only (max 64 chars)
- `description`: Should explain both WHAT the skill does and WHEN to use it
- Optional: `allowed-tools` - Restrict which tools Claude can use (e.g., `[Read, Grep, Glob]` for read-only)

2. **Markdown Content**: Detailed instructions, knowledge, best practices, and examples

## Creating Your Own Skills

To add a custom skill:

1. Create a new directory in `.claude/skills/`: `mkdir -p ~/.claude/skills/my-skill`
2. Create `SKILL.md` file in that directory
3. Add required frontmatter with name and description
4. Write detailed instructions and knowledge
5. The skill is automatically available on next Claude Code session

**Example:**
```markdown
---
name: my-custom-skill
description: Expert in [domain]. Use when the user needs help with [specific tasks].
---

You are an expert in [domain]. Your role is to...

## Core Responsibilities
...

## Best Practices
...

## Examples
...
```

## Skills vs Agents

- **Skills**: Domain knowledge and expertise (passive, invoked by Claude)
- **Agents**: Autonomous task execution (active, can be launched as subagents)

Skills provide knowledge; agents take action.

## Tips for Using Skills

1. **Be Specific**: Mention the domain to help Claude choose the right skill
2. **Provide Context**: Give relevant details about your environment and goals
3. **Ask Follow-ups**: Skills can help with related tasks in their domain
4. **Combine Skills**: Complex tasks may benefit from multiple skills

## Contributing

Feel free to:
- Add new skills for your specific needs
- Enhance existing skills with more examples
- Share useful patterns you discover
- Customize skills to match your workflow

## Installation

This repository uses dotbot to automatically symlink skills to `~/.claude/skills/` during bootstrap:

```bash
cd ~/dotfiles
make bootstrap
```

The bootstrap process will:
1. Create `~/.claude/` directory
2. Symlink `~/.claude/skills` → `~/dotfiles/.claude/skills`
3. Make all skills available to Claude Code

You can also manually create the symlink:
```bash
ln -sf ~/dotfiles/.claude/skills ~/.claude/skills
```

## Related Resources

- [Claude Code Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills)
- [Official Skills Repository](https://github.com/anthropics/skills)
- [How to Create Custom Skills](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills)
- [Agents Directory](../agents/README.md) - For autonomous task execution
- [Main Dotfiles README](../../README.md)

## Maintenance

Keep skills updated with:
- New tools and best practices
- Lessons learned from usage
- Platform-specific considerations
- Security updates and warnings

## Progressive Disclosure

Skills use progressive disclosure - Claude loads only the name and description at startup. The full skill content is loaded only when needed, keeping the context window efficient while providing specialized expertise on demand.

---

**Note**: Skills are loaded by Claude Code automatically from `~/.claude/skills/`. No manual installation or activation needed - just start using them!
