# Claude Code Expert Skill

This skill provides comprehensive guidance on using Claude Code, Anthropic's agentic coding tool.

## When to Use This Skill

Use this skill when users need help with:
- Understanding Claude Code features and capabilities
- Setting up and configuring Claude Code
- Working with slash commands, hooks, and plugins
- Using MCP servers and Agent Skills
- Troubleshooting Claude Code issues
- Understanding best practices for Claude Code usage
- Deploying Claude Code in enterprise environments
- Using Claude Code with IDEs (VS Code, JetBrains)

## Core Concepts

### What is Claude Code?

Claude Code is Anthropic's agentic coding tool that lives in your terminal and helps you turn ideas into code faster. Key features include:

- **Agentic Capabilities**: Claude autonomously plans, executes, and validates tasks
- **Terminal Integration**: Works directly in your command line
- **IDE Support**: Extensions for VS Code and JetBrains IDEs
- **Extensibility**: Plugins, skills, slash commands, and MCP servers
- **Enterprise Ready**: SSO, sandboxing, monitoring, and compliance features

### Architecture Components

1. **Subagents**: Specialized AI agents for specific tasks
   - `planner`: Research and create implementation plans
   - `code-reviewer`: Review code quality and security
   - `tester`: Run tests and validate implementations
   - `debugger`: Investigate and diagnose issues
   - `docs-manager`: Manage technical documentation
   - `ui-ux-designer`: Design and implement UI/UX
   - `database-admin`: Database optimization and management
   - And many more specialized agents

2. **Agent Skills**: Modular capabilities that extend functionality
   - Package instructions, metadata, and resources
   - Automatically discovered and used by Claude
   - Shareable across projects and teams

3. **Slash Commands**: User-defined operations that expand to prompts
   - Located in `.claude/commands/`
   - Execute with `/command-name`
   - Can accept arguments

4. **Hooks**: Shell commands that execute in response to events
   - Pre/post tool execution hooks
   - User prompt submit hooks
   - Customizable validation and automation

5. **MCP Servers**: Model Context Protocol integrations
   - Connect external tools and services
   - Provide resources, tools, and prompts
   - Remote and local server support

## Installation & Setup

### Prerequisites
- macOS, Linux, or Windows (WSL2)
- Node.js 18+ or Python 3.10+
- API key from Anthropic Console

### Installation
```bash
# Install via npm (recommended)
npm install -g @anthropic-ai/claude-code

# Or via pip
pip install claude-code
```

### Authentication
```bash
# Login with API key
claude login

# Or set environment variable
export ANTHROPIC_API_KEY=your_api_key
```

### First Run
```bash
# Start interactive session
claude

# Run with specific task
claude "implement user authentication"

# Use in specific directory
cd /path/to/project
claude
```

## Common Workflows

### 1. Feature Implementation
```bash
# Use the cook command for feature work
/cook implement user authentication with JWT

# Or start with planning
/plan implement payment integration with Stripe
```

### 2. Bug Fixing
```bash
# Quick fixes
/fix:fast the login button is not working

# Complex debugging
/debug the API returns 500 errors intermittently

# Fix type errors
/fix:types
```

### 3. Code Review & Testing
```bash
# Review recent changes
claude "review my latest commit"

# Run tests
/test

# Fix test failures
/fix:test the user service tests are failing
```

### 4. Documentation
```bash
# Create initial documentation
/docs:init

# Update existing docs
/docs:update

# Summarize changes
/docs:summarize
```

### 5. Git Operations
```bash
# Commit changes
/git:cm

# Commit and push
/git:cp

# Create pull request
/git:pr feature-branch main
```

## Slash Commands Reference

### Development Commands
- `/cook [task]`: Implement features
- `/plan [task]`: Research and create implementation plans
- `/debug [issue]`: Debug technical issues
- `/test`: Run test suite
- `/refactor`: Improve code quality

### Fix Commands
- `/fix:fast [issue]`: Quick fixes
- `/fix:hard [issue]`: Complex issues with planning
- `/fix:types`: Fix TypeScript errors
- `/fix:test [issue]`: Fix test failures
- `/fix:ui [issue]`: Fix UI issues
- `/fix:ci [url]`: Fix CI/CD issues
- `/fix:logs [issue]`: Analyze logs and fix

### Documentation Commands
- `/docs:init`: Create initial documentation
- `/docs:update`: Update existing documentation
- `/docs:summarize`: Summarize codebase

### Git Commands
- `/git:cm`: Stage and commit
- `/git:cp`: Stage, commit, and push
- `/git:pr [branch] [base]`: Create pull request

### Planning Commands
- `/plan:two [task]`: Create plan with 2 approaches
- `/plan:ci [url]`: Plan CI/CD fixes
- `/plan:cro [issue]`: Create CRO optimization plan

### Content Commands
- `/content:fast [request]`: Quick copy writing
- `/content:good [request]`: High-quality copy
- `/content:enhance [issue]`: Enhance existing content
- `/content:cro [issue]`: Conversion rate optimization

### Design Commands
- `/design:fast [task]`: Quick design
- `/design:good [task]`: High-quality design
- `/design:3d [task]`: 3D designs with Three.js
- `/design:screenshot [path]`: Design from screenshot
- `/design:video [path]`: Design from video

### Deployment Commands
- `/deploy`: Deploy using `dx up`
- `/deploy-check`: Check deployment readiness

### Other Commands
- `/brainstorm [question]`: Brainstorm features
- `/ask [question]`: Answer technical questions
- `/scout [prompt]`: Scout directories
- `/watzup`: Review recent changes
- `/bootstrap [requirements]`: Bootstrap new project
- `/journal`: Write journal entries

## Agent Skills

### Creating Skills

Skills are located in `.claude/skills/` and consist of:

1. **skill.md**: Main skill instructions
2. **skill.json**: Metadata and configuration

Example skill.json:
```json
{
  "name": "my-skill",
  "description": "Brief description of when to use this skill",
  "version": "1.0.0",
  "author": "Your Name"
}
```

Example skill.md structure:
```markdown
# Skill Name

Description of what this skill does.

## When to Use This Skill

Specific scenarios when Claude should activate this skill.

## Instructions

Step-by-step instructions for Claude to follow.

## Examples

Concrete examples of skill usage.
```

### Best Practices for Skills

1. **Clear Activation Criteria**: Define exactly when the skill should be used
2. **Concise Instructions**: Focus on essential information
3. **Actionable Guidance**: Provide clear steps Claude can follow
4. **Examples**: Include concrete examples of expected inputs/outputs
5. **Scope Limitation**: Keep skills focused on specific domains

### Using Skills via API

Skills can be used with the Claude API:

```typescript
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

const response = await client.messages.create({
  model: 'claude-sonnet-4-5-20250929',
  max_tokens: 4096,
  skills: [
    {
      type: 'custom',
      custom: {
        name: 'document-creator',
        description: 'Creates professional documents',
        instructions: 'Follow corporate style guide...'
      }
    }
  ],
  messages: [{ role: 'user', content: 'Create a project proposal' }]
});
```

## MCP Server Integration

### What is MCP?

Model Context Protocol (MCP) allows Claude Code to connect to external tools and services.

### Configuration

MCP servers are configured in `.claude/mcp.json`:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/files"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your_github_token"
      }
    }
  }
}
```

### Common MCP Servers

- **@modelcontextprotocol/server-filesystem**: File system access
- **@modelcontextprotocol/server-github**: GitHub integration
- **@modelcontextprotocol/server-postgres**: PostgreSQL database
- **@modelcontextprotocol/server-brave-search**: Web search
- **@modelcontextprotocol/server-puppeteer**: Browser automation

### Remote MCP Servers

Connect to MCP servers over HTTP/SSE:

```json
{
  "mcpServers": {
    "remote-service": {
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer token"
      }
    }
  }
}
```

## Hooks System

### Hook Types

1. **Pre-tool hooks**: Execute before tool calls
2. **Post-tool hooks**: Execute after tool calls
3. **User prompt submit hooks**: Execute when user submits prompts

### Configuration

Hooks are configured in `.claude/hooks.json`:

```json
{
  "hooks": {
    "pre-tool": {
      "bash": "echo 'Running bash command: $TOOL_ARGS'"
    },
    "post-tool": {
      "write": "./scripts/format-code.sh"
    },
    "user-prompt-submit": "./scripts/validate-request.sh"
  }
}
```

### Hook Environment Variables

Available in hook scripts:
- `$TOOL_NAME`: Name of the tool being called
- `$TOOL_ARGS`: JSON string of tool arguments
- `$TOOL_RESULT`: Tool execution result (post-tool only)
- `$USER_PROMPT`: User's prompt text (user-prompt-submit only)

### Use Cases

- Code formatting after file writes
- Security validation before bash execution
- Cost tracking and budgeting
- Custom logging and monitoring
- Integration with external systems

## Plugins System

### Plugin Structure

Plugins are packaged collections of extensions:

```
my-plugin/
├── plugin.json          # Plugin metadata
├── commands/            # Slash commands
├── skills/             # Agent skills
├── hooks/              # Hook scripts
├── mcp/                # MCP server configurations
└── README.md           # Documentation
```

### plugin.json Example

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": "Your Name",
  "homepage": "https://github.com/user/plugin",
  "commands": ["commands/*.md"],
  "skills": ["skills/*/"],
  "hooks": "hooks/hooks.json",
  "mcpServers": "mcp/mcp.json"
}
```

### Installing Plugins

```bash
# Install from GitHub
claude plugin install gh:username/repo

# Install from local path
claude plugin install ./path/to/plugin

# Install from npm
claude plugin install npm:package-name

# List installed plugins
claude plugin list

# Uninstall plugin
claude plugin uninstall plugin-name
```

### Creating Plugin Marketplaces

Organizations can create private plugin marketplaces:

```json
{
  "marketplaces": [
    {
      "name": "company-internal",
      "url": "https://plugins.company.com/catalog.json",
      "auth": {
        "type": "bearer",
        "token": "${COMPANY_PLUGIN_TOKEN}"
      }
    }
  ]
}
```

## Configuration & Settings

### Settings Hierarchy

1. Global settings: `~/.claude/settings.json`
2. Project settings: `.claude/settings.json`
3. Environment variables
4. Command-line flags

### Key Settings

```json
{
  "model": "claude-sonnet-4-5-20250929",
  "maxTokens": 8192,
  "temperature": 1.0,
  "thinking": {
    "enabled": true,
    "budget": 10000
  },
  "sandboxing": {
    "enabled": true,
    "allowedPaths": ["/workspace"],
    "networkAccess": "restricted"
  },
  "outputStyle": "default",
  "memory": {
    "enabled": true,
    "location": "project"
  }
}
```

### Model Configuration

Model aliases available:
- `opusplan`: Claude Opus with extended thinking for planning
- `sonnet`: Latest Claude Sonnet
- `haiku`: Claude Haiku for fast responses

### Output Styles

Customize Claude's behavior for different use cases:

```bash
# List available output styles
ls ~/.claude/output-styles/

# Use specific output style
claude --output-style technical-writer

# Create custom output style
cat > ~/.claude/output-styles/my-style.md <<EOF
You are a [role]. Follow these guidelines:
- [Guideline 1]
- [Guideline 2]
EOF
```

## Enterprise Features

### Identity & Access Management

**SSO Integration**: SAML 2.0 and OAuth 2.0 support
**RBAC**: Role-based access control
**User Management**: Centralized user provisioning

### Security & Compliance

**Sandboxing**: Filesystem and network isolation
**Audit Logging**: Comprehensive activity logs
**Data Residency**: Region-specific deployment options
**Compliance**: SOC 2, HIPAA, GDPR compliant

### Deployment Options

**Amazon Bedrock**: Deploy via AWS Bedrock
**Google Vertex AI**: Deploy via GCP Vertex AI
**Self-hosted**: On-premises deployment with Docker/Kubernetes
**LLM Gateway**: Integration with LiteLLM and other gateways

### Monitoring & Analytics

**OpenTelemetry**: Built-in telemetry support
**Usage Analytics**: Track team productivity metrics
**Cost Management**: Monitor and control API costs
**Custom Dashboards**: Build org-specific dashboards

### Network Configuration

**Proxy Support**: HTTP/HTTPS proxy configuration
**Custom CA**: Trust custom certificate authorities
**mTLS**: Mutual TLS authentication
**IP Allowlisting**: Restrict access by IP

## IDE Integration

### Visual Studio Code

Install the official extension:
1. Open VS Code
2. Search for "Claude Code" in extensions
3. Install and authenticate

Features:
- Inline chat
- Code actions
- Diff view
- Terminal integration

### JetBrains IDEs

Supported IDEs:
- IntelliJ IDEA
- PyCharm
- WebStorm
- PhpStorm
- GoLand
- RubyMine

Installation:
1. Open Settings → Plugins
2. Search for "Claude Code"
3. Install and authenticate

## CI/CD Integration

### GitHub Actions

Example workflow:

```yaml
name: Claude Code CI
on: [push, pull_request]

jobs:
  claude-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: anthropic/claude-code-action@v1
        with:
          command: '/fix:types && /test'
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

### GitLab CI/CD

Example pipeline:

```yaml
claude-review:
  image: node:18
  script:
    - npm install -g @anthropic-ai/claude-code
    - claude login --api-key $ANTHROPIC_API_KEY
    - claude '/fix:types && /test'
  only:
    - merge_requests
```

## Advanced Features

### Extended Thinking

Enable deep reasoning for complex problems:

```bash
# Enable extended thinking globally
claude config set thinking.enabled true

# Set thinking budget
claude config set thinking.budget 15000

# Use in API
const response = await client.messages.create({
  model: 'claude-sonnet-4-5-20250929',
  thinking: {
    type: 'enabled',
    budget_tokens: 10000
  },
  messages: [...]
});
```

### Prompt Caching

Reduce costs by caching repeated context:

```typescript
const response = await client.messages.create({
  model: 'claude-sonnet-4-5-20250929',
  system: [
    {
      type: 'text',
      text: 'You are a coding assistant...',
      cache_control: { type: 'ephemeral' }
    }
  ],
  messages: [...]
});
```

### Checkpointing

Automatically track and rewind changes:

```bash
# Enable checkpointing
claude config set checkpointing.enabled true

# View checkpoints
claude checkpoint list

# Rewind to checkpoint
claude checkpoint restore <checkpoint-id>

# Create manual checkpoint
claude checkpoint create "before refactoring"
```

### Memory Management

Control how Claude remembers context:

```bash
# Enable memory
claude config set memory.enabled true

# Set memory location (global/project/none)
claude config set memory.location project

# View stored memories
claude memory list

# Clear memories
claude memory clear
```

## Troubleshooting

### Common Issues

**Authentication Failures**
```bash
# Re-login
claude logout
claude login

# Verify API key
echo $ANTHROPIC_API_KEY
```

**MCP Server Connection Issues**
```bash
# Test MCP server
npx @modelcontextprotocol/inspector

# Check MCP configuration
cat .claude/mcp.json
```

**Performance Issues**
- Reduce context window size
- Enable prompt caching
- Use appropriate model (Haiku for speed)
- Clear memory cache

**Permission Errors**
- Check file permissions
- Verify sandboxing settings
- Review hook configurations

### Debug Mode

Enable verbose logging:

```bash
# Enable debug logging
export CLAUDE_DEBUG=1
claude

# Or use debug flag
claude --debug "implement feature"
```

### Getting Help

- Documentation: https://docs.claude.com/claude-code
- GitHub Issues: https://github.com/anthropics/claude-code/issues
- Support: support.claude.com
- Community: discord.gg/anthropic

## Best Practices

### 1. Project Organization
- Keep `.claude/` directory in version control
- Document custom commands and skills
- Share plugin configurations with team
- Use project-specific settings

### 2. Security
- Never commit API keys
- Use environment variables for secrets
- Enable sandboxing in production
- Review hook scripts before execution
- Audit plugin sources

### 3. Performance Optimization
- Use prompt caching for repeated context
- Choose appropriate model for task
- Implement rate limiting in hooks
- Monitor token usage
- Use batch processing for bulk operations

### 4. Team Collaboration
- Standardize slash commands across projects
- Share useful skills via plugin marketplace
- Document custom configurations
- Set up CI/CD integration
- Use consistent memory settings

### 5. Cost Management
- Set budget limits in hooks
- Monitor usage via analytics API
- Use Haiku for simple tasks
- Implement caching strategies
- Track per-project costs

## API Reference

### Admin API

**Get Usage Report**
```bash
GET /v1/admin/claude-code/usage
```

**Get Cost Report**
```bash
GET /v1/admin/usage/cost
```

**List Users**
```bash
GET /v1/admin/users
```

### Messages API

**Create Message**
```bash
POST /v1/messages
```

**Stream Message**
```bash
POST /v1/messages (with stream=true)
```

**Count Tokens**
```bash
POST /v1/messages/count_tokens
```

### Files API

**Upload File**
```bash
POST /v1/files
```

**List Files**
```bash
GET /v1/files
```

**Delete File**
```bash
DELETE /v1/files/:file_id
```

### Models API

**List Models**
```bash
GET /v1/models
```

**Get Model**
```bash
GET /v1/models/:model_id
```

### Skills API

**Create Skill**
```bash
POST /v1/skills
```

**List Skills**
```bash
GET /v1/skills
```

**Update Skill**
```bash
PATCH /v1/skills/:skill_id
```

## Conclusion

Claude Code is a powerful agentic coding tool that can significantly accelerate development workflows. By leveraging its extensibility through skills, plugins, MCP servers, and hooks, you can create a highly customized development environment tailored to your team's needs.

Start simple with basic commands, then gradually adopt advanced features like custom skills, MCP integrations, and enterprise deployment options as your needs grow.
