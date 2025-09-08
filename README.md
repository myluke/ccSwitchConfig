# Claude 配置切换工具 (ccSwitchConfig)

一个简单的命令行工具，用于在不同的 Claude API 兼容服务（如 Moonshot, 阿里云百炼, ModelScope, 智谱 BigModel）之间快速切换和持久化配置。

**命令名称**: `claudeswitch`

**核心功能**: 你的选择会自动保存在一个文件中。每次打开新终端时，配置会自动恢复。

## 🌟 功能特性

- 🔄 **多服务支持**: 支持 Moonshot, 阿里云百炼, ModelScope, 智谱 BigModel。
- 💾 **配置持久化**: 你的选择会被保存，新终端会自动加载上次的配置。
- ⚡ **快速切换**: 使用单个命令即可切换。
- 🔍 **状态查看**: 清晰地查看当前保存的选项和环境变量。
- 🧹 **一键清理**: 快速清理所有相关的环境变量。
- 🛡️ **安全**: API 密钥存储在受限权限的文件中。
- ⌨️ **自动补全**: 为 Zsh 用户提供命令自动补全。

## 📋 安装

1.  **克隆仓库**
    ```bash
    git clone https://github.com/your-username/ccSwitchConfig.git
    cd ccSwitchConfig
    ```

2.  **运行安装脚本**
    ```bash
    ./install.sh
    ```
    脚本会自动将 `claude-config.sh` 复制到 `~/.config/claude/` 并设置好 `~/.zshrc`。

3.  **配置 API 密钥**
    编辑新创建的密钥文件并填入你的 API 密钥：
    ```bash
    vim ~/.config/claude/api-keys.env
    ```

4.  **重新加载 Shell**
    ```bash
    source ~/.zshrc
    ```
    现在 `claudeswitch` 命令应该可用了。

## 🚀 使用指南

### 切换配置

切换命令会立即生效，并为你之后打开的所有新终端设置默认配置。

- **切换到 Moonshot**:
  ```bash
  claudeswitch moon
  ```

- **切换到阿里云百炼**:
  ```bash
  claudeswitch ali
  ```

- **切换到 ModelScope**:
  ```bash
  claudeswitch ms
  ```

- **切换到智谱 BigModel**:
  ```bash
  claudeswitch big
  ```

### 查看状态

使用 `status` 命令可以查看当前持久化的选择以及当前 shell 中生效的环境变量。

```bash
claudeswitch status
```

### 清理配置

`clear` 命令会清除所有相关的环境变量，并将持久化设置也重置为 `clear` 状态。

```bash
claudeswitch clear
```

### 获取帮助

```bash
claudeswitch help
```

## 🤔 工作原理

-   当你运行 `claudeswitch <choice>` 时，你的选择（例如 `moon`）会被写入到 `~/.config/claude/api_choice` 文件中。
-   `claude-config.sh` 脚本在 `~/.zshrc` 中被 `source`。
-   每次你打开一个新的终端，`claude-config.sh` 都会被加载，它会读取 `api_choice` 文件并自动为你配置相应的环境变量。

## 🔧 API 配置详情

### Moonshot
- **环境变量**: `MOONSHOT_API_KEY`
- **API 端点**: `https://api.moonshot.cn/anthropic`
- **模型**: `moonshotai/Kimi-K2-Instruct-0905`

### 阿里云百炼
- **环境变量**: `BAILIAN_AUTH_TOKEN`
- **API 端点**: `https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy`

### ModelScope
- **环境变量**: `MODELSCOPE_AUTH_TOKEN`
- **API 端点**: `https://api-inference.modelscope.cn`
- **模型**: `moonshotai/Kimi-K2-Instruct-0905`

### 智谱 BigModel
- **环境变量**: `BIGMODEL_API_KEY`
- **API 端点**: `https://open.bigmodel.cn/api/anthropic`
- **模型**: `glm-4.5`
- **小型快速模型**: `glm-4.5-air`

## 📁 文件结构

安装后，相关文件位于 `~/.config/claude/`：

```
~/.config/claude/
├── api-keys.env      # 存储你的 API 密钥
├── api_choice        # 存储你当前选择的配置
└── claude-config.sh  # 主要的逻辑脚本
```

## 📄 许可证

本项目采用 MIT 许可证。
