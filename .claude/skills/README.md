# Claude Skills for Dotfiles Management

This directory contains Claude Code skills that provide specialized expertise for common development tasks, especially related to managing and maintaining dotfiles.

## What are Skills?

Skills are specialized capabilities that Claude can invoke to provide expert assistance in specific domains. Each skill contains detailed knowledge and best practices for its area of expertise.

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

Each skill is a markdown file with:

1. **Frontmatter**: Metadata including name and description
```yaml
---
name: skill-name
description: Brief description of the skill
---
```

2. **Content**: Detailed knowledge, best practices, examples, and guidelines

## Creating Your Own Skills

To add a custom skill:

1. Create a new `.md` file in `.claude/skills/`
2. Add frontmatter with name and description
3. Write detailed instructions and knowledge
4. Save and it's automatically available

Example:
```markdown
---
name: my-skill
description: Description of what this skill does
---

You are an expert in [domain]. Your role is to...

## Key Concepts
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

## Related Resources

- [Claude Code Documentation](https://docs.claude.com/claude-code)
- [Agents Directory](../agents/README.md) - For autonomous task execution
- [Main Dotfiles README](../../README.md)

## Maintenance

Keep skills updated with:
- New tools and best practices
- Lessons learned from usage
- Platform-specific considerations
- Security updates and warnings

---

**Note**: Skills are loaded by Claude Code automatically. No installation or activation needed - just start using them!
