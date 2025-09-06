# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Claude AI API configuration switching tool** written in Zsh/Bash that allows users to quickly switch between different Claude API providers (Moonshot, Alibaba Bailian, and ModelScope). The tool is designed to be installed on macOS/Linux systems with Zsh.

## File Structure

- `claude-config.sh` - Main tool script containing all switching logic
- `install.sh` - Installation script that sets up the tool in user's environment  
- `README.md` - Comprehensive documentation in Chinese

## Development Commands

### Testing the Script
```bash
# Syntax check the main script
bash -n claude-config.sh

# Test the installation process locally
./install.sh
```

### Common Development Tasks
```bash
# Source the script for testing (after installation)
source ~/.config/claude/claude-config.sh

# Test command functionality
claudeswitch test
claudeswitch status
claudeswitch help
```

## Architecture & Key Components

### Function Structure in `claude-config.sh`

1. **`_load_api_keys()`** - Loads API keys from `~/.config/claude/api-keys.env`
2. **`_clear_claude_env()`** - Unsets all Claude-related environment variables
3. **`_check_key()`** - Validates that required API keys exist
4. **`claudeswitch()`** - Main command dispatcher function that:
   - Handles command line arguments (moon/moonshot, ali/bailian, ms/modelscope, etc.)
   - Sets appropriate environment variables for each API provider
   - Manages state switching between providers

### Environment Variables Set by the Tool

- `ANTHROPIC_BASE_URL` - API endpoint URL
- `ANTHROPIC_API_KEY` - API key for providers that use key-based auth
- `ANTHROPIC_AUTH_TOKEN` - Auth token for providers that use token-based auth  
- `ANTHROPIC_MODEL` - Model specification (when applicable)

### API Provider Configurations

1. **Moonshot**: `ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"`
2. **Alibaba Bailian**: Uses `ANTHROPIC_AUTH_TOKEN` with bailian-specific URL
3. **ModelScope**: Uses `ANTHROPIC_AUTH_TOKEN` with modelscope-specific URL

## Important Considerations

- The tool modifies shell environment variables, so changes are session-specific
- Installation modifies user's `~/.zshrc` file to source the tool script
- API keys are stored in `~/.config/claude/api-keys.env` with 600 permissions
- All user-facing text and documentation is in Chinese
- The tool provides Zsh autocompletion via `compdef`