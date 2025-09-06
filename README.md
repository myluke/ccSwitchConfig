# Claude 配置切换工具 (ClaudeSwitch)

一个强大的命令行工具，用于快速切换不同的 Claude API 配置（Moonshot、阿里云百炼、ModelScope）。

**命令名称**：`claudeswitch` （避免与官方 Claude CLI 冲突）

**🆕 新功能**：配置自动持久化！切换的配置会自动保存，新终端窗口自动恢复上次的 API 设置

## 🌟 功能特性

- 🔄 **多 API 支持**：支持 Moonshot、阿里云百炼、ModelScope 三大平台
- 💾 **配置持久化**：切换的配置自动保存，新终端自动恢复，无需重复设置
- ⚡ **快速切换**：一键切换不同的 API 配置
- 🔍 **状态查看**：实时查看当前 API 配置状态
- 🛡️ **安全配置**：密钥文件权限保护，仅当前用户可读写
- 🎯 **自动补全**：支持 Zsh 命令补全
- 📝 **配置管理**：便捷的配置文件编辑和管理

## 📋 安装指南

### 前提要求

- macOS/Linux 系统
- Zsh shell
- Bash（用于运行安装脚本）

### 一键安装

1. **克隆或下载项目**
   ```bash
   git clone <repository-url>
   cd claude-config-switcher
   ```

2. **运行安装脚本**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **激活 ClaudeSwitch**
   ```bash
   source ~/.zshrc
   # 或者关闭终端重新打开
   ```

### 手动安装（备选方案）

如果自动安装失败，可以手动安装：

1. **创建配置目录**
   ```bash
   mkdir -p ~/.config/claude
   ```

2. **复制配置文件**
   ```bash
   cp claude-config.sh ~/.config/claude/
   chmod +x ~/.config/claude/claude-config.sh
   ```

3. **创建密钥文件**
   ```bash
   cp api-keys.env.template ~/.config/claude/api-keys.env
   chmod 600 ~/.config/claude/api-keys.env
   ```

4. **添加到 shell 配置**
   在 `~/.zshrc` 文件中添加：
   ```bash
   source ~/.config/claude/claude-config.sh
   ```

5. **重新加载配置**
   ```bash
   source ~/.zshrc
   ```

## ⚙️ 配置说明

### 1. 编辑 API 密钥

安装完成后，首先需要编辑密钥文件：

```bash
# 使用 vim 编辑
vim ~/.config/claude/api-keys.env

# 或使用 nano 编辑
nano ~/.config/claude/api-keys.env
```

根据你使用的平台，填写相应的 API 密钥：

```bash
# Moonshot API 配置
MOONSHOT_API_KEY="sk-你的moonshot密钥"

# 阿里云百炼配置  
BAILIAN_AUTH_TOKEN="sk-你的阿里云密钥"

# ModelScope 配置
MODELSCOPE_AUTH_TOKEN="ms-你的modelscope密钥"
```

### 2. 测试配置

配置完成后，测试密钥是否正确加载：

```bash
claudeswitch test
```

### 3. 配置持久化（重要功能！）

**ClaudeSwitch 现在支持配置持久化！**

一旦你切换到某个 API 配置，系统会自动保存当前设置。即使你关闭终端、重新打开新窗口，配置也会被自动恢复。

**工作原理：**
- 每次切换 API 时，配置会自动保存到 `~/.config/claude/current-config.env`
- 新终端打开时，工具会自动加载上次使用的配置
- 配置文件权限为 600，确保安全

**禁用自动加载：**
```bash
export CLAUDESWITCH_NO_AUTOLOAD=1
```

## 🚀 使用指南

### 基本命令

```bash
# 查看帮助
claudeswitch help

# 查看当前状态
claudeswitch status

# 切换到 Moonshot API
claudeswitch moon

# 切换到阿里云百炼
claudeswitch ali

# 切换到 ModelScope
claudeswitch ms

# 清理所有环境变量
claudeswitch clear

# 编辑配置文件
claudeswitch edit
```

### API 配置命令

#### Moonshot API
```bash
claudeswitch moon
# 或
claudeswitch moonshot
```

#### 阿里云百炼
```bash
claudeswitch ali
# 或
claudeswitch bailian
```

#### ModelScope
```bash
claudeswitch ms
# 或
claudeswitch modelscope
```

### 快捷命令

支持命令缩写形式：
- `claudeswitch st` - 显示状态（等同于 `claudeswitch status`）
- `claudeswitch ls` - 显示帮助（等同于 `claudeswitch help`）

## 📊 使用示例

### 示例 1：基础使用流程（配置自动保存）
```bash
# 1. 查看当前状态
claudeswitch status

# 2. 切换到 Moonshot（配置会自动保存）
claudeswitch moon

# 3. 验证切换成功
claudeswitch status

# 4. 现在你可以关闭终端，重新打开，配置还在！
# 新终端会自动恢复 Moonshot 配置
```

### 示例 2：多平台切换
```bash
# 切换到阿里云进行中文对话
claudeswitch ali

# 切换到 Moonshot 进行英文对话
claudeswitch moon

# 切换到 ModelScope 测试新模型
claudeswitch ms
```

### 示例 3：故障排查
```bash
# 检查密钥是否正确加载
claudeswitch test

# 查看帮助信息
claudeswitch help

# 如果配置混乱，清理环境变量
claudeswitch clear
```

## 🔧 高级功能

### 自动补全

工具支持 Zsh 自动补全功能：

```bash
# 输入 claudeswitch 后按 Tab 键查看可用命令
claudeswitch <Tab>
```

可用的自动补全选项：
- `moon` / `moonshot` - 切换 Moonshot API
- `ali` / `bailian` - 切换阿里云百炼
- `ms` / `modelscope` - 切换 ModelScope
- `status` / `st` - 显示状态
- `clear` / `reset` - 清理环境变量
- `edit` / `config` - 编辑配置
- `test` - 测试密钥
- `list` / `ls` / `help` - 显示帮助

### 环境变量

工具会设置以下环境变量：
- `ANTHROPIC_BASE_URL` - API 基础地址
- `ANTHROPIC_API_KEY` - API 密钥（某些平台）
- `ANTHROPIC_AUTH_TOKEN` - 认证令牌（某些平台）
- `ANTHROPIC_MODEL` - 模型名称（某些平台）

## 🛠️ 常见问题

### Q1: 安装后命令不可用？
**解决方案：**
1. 确认已执行 `source ~/.zshrc`
2. 检查 `~/.zshrc` 中是否包含 `source ~/.config/claude/claude-config.sh`
3. 重新打开终端窗口

### Q2: 切换 API 后无效？
**解决方案：**
1. 检查密钥是否正确：`claudeswitch test`
2. 确认 API 密钥是否有效
3. 检查网络连接
4. 清理环境变量后重试：`claudeswitch clear`

### Q3: 自动补全不工作？
**解决方案：**
1. 确认使用 Zsh shell
2. 重新加载配置：`source ~/.zshrc`
3. 检查 compdef 是否可用

### Q4: 权限错误？
**解决方案：**
1. 检查密钥文件权限：`ls -la ~/.config/claude/api-keys.env`
2. 确保权限为 600：`chmod 600 ~/.config/claude/api-keys.env`

### Q5: 配置在新终端中不生效？
**解决方案：**
- 确保你使用的是支持配置文件加载的 Cladoneswitch 版本（v2.0+）
- 检查是否禁用了自动加载：`echo $CLAUDESWITCH_NO_AUTOLOAD`
- 手动加载保存的配置：`source ~/.config/claude/current-config.env`
- 如果问题持续，尝试：`claudeswitch moon`（或其他平台）重新设置

### Q6: 如何禁用自动持久化？
**解决方案：**
```bash
export CLAUDESWITCH_NO_AUTOLOAD=1
```
设置此环境变量即可禁用自动加载保存的配置。

## 🔒 安全说明

- **密钥文件保护**：密钥文件默认设置为 600 权限（仅当前用户可读写）
- **不存储敏感信息**：工具只存储必要的 API 密钥，不保存其他敏感数据
- **本地运行**：所有配置都在本地进行，不会上传到任何服务器

## 📁 文件结构

```
claude-config-switcher/
├── install.sh              # 安装脚本
├── claude-config.sh        # 主配置工具
├── api-keys.env.template   # 密钥文件模板
└── README.md              # 本文档
```

安装后的文件位置：
```
~/.config/claude/
├── claude-config.sh        # 主工具脚本
├── api-keys.env           # API 密钥配置文件
└── current-config.env     # 自动保存的当前配置（新增）
```

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request 来改进这个工具！

### 开发建议
- 保持代码简洁易懂
- 添加适当的错误处理
- 更新文档说明
- 测试不同平台的兼容性

## 📄 许可证

本项目采用 MIT 许可证 - 详情请查看 LICENSE 文件。

## 🙏 致谢

感谢以下平台的 API 支持：
- [Moonshot AI](https://www.moonshot.cn/)
- [阿里云百炼](https://bailian.aliyun.com/)
- [ModelScope](https://www.modelscope.cn/)

---

## 💡 小贴士

1. **定期更新密钥**：为了安全，建议定期更新 API 密钥
2. **备份配置**：可以备份 `~/.config/claude/` 目录以防配置丢失
3. **多环境使用**：可以在不同机器上使用相同的配置文件
4. **快速切换**：使用 `claudeswitch moon` / `claudeswitch ali` / `claudeswitch ms` 快速在不同平台间切换

如有问题，请查看帮助信息：`claudeswitch help`