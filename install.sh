#!/bin/bash
# Claude 配置工具一键安装脚本

set -e

CONFIG_DIR="$HOME/.config/claude"
KEYS_FILE="$CONFIG_DIR/api-keys.env"
CONFIG_FILE="$CONFIG_DIR/claude-config.sh"
ZSHRC="$HOME/.zshrc"

echo "🚀 开始安装 Claude 配置工具..."

# 创建配置目录
echo "📁 创建配置目录: $CONFIG_DIR"
mkdir -p "$CONFIG_DIR"

# 创建密钥文件
if [[ ! -f "$KEYS_FILE" ]]; then
    echo "🔑 创建密钥文件: $KEYS_FILE"
    cat > "$KEYS_FILE" << 'EOF'
# Claude API 密钥配置文件
# 文件位置: ~/.config/claude/api-keys.env
# 权限: chmod 600 (仅当前用户可读写)

# Moonshot API 配置
MOONSHOT_API_KEY="sk-ddd"

# 阿里云百炼配置  
BAILIAN_AUTH_TOKEN="sk-ddd"

# ModelScope 配置
MODELSCOPE_AUTH_TOKEN="ms-dddd"
EOF
    chmod 600 "$KEYS_FILE"
    echo "✅ 密钥文件已创建，请编辑 $KEYS_FILE 设置你的API密钥"
else
    echo "⚠️  密钥文件已存在: $KEYS_FILE"
fi

# 复制配置脚本
echo "⚙️  创建配置脚本: $CONFIG_FILE"
if [[ -f "claude-config.sh" ]]; then
    cp "claude-config.sh" "$CONFIG_FILE"
    chmod +x "$CONFIG_FILE"
    echo "✅ 配置脚本已复制到 $CONFIG_FILE"
else
    echo "❌ 错误：在当前目录未找到 claude-config.sh 文件"
    echo "请确保 claude-config.sh 文件存在于当前目录"
    exit 1
fi

# 检查 .zshrc 中是否已存在引用
if ! grep -q "source.*claude-config.sh" "$ZSHRC" 2>/dev/null; then
    echo "📝 添加配置到 $ZSHRC"
    echo "" >> "$ZSHRC"
    echo "# Claude 配置切换工具" >> "$ZSHRC"
    echo "source ~/.config/claude/claude-config.sh" >> "$ZSHRC"
    echo "✅ 已添加到 .zshrc"
    echo ""
    echo "💡 提示：安装完成后请运行 'source ~/.zshrc' 或重新打开终端"
    echo "    使用方法：claudeswitch help"
else
    echo "ℹ️  .zshrc 中已存在 claude-config.sh 引用"
fi

echo ""
echo "🎉 安装完成！"
echo ""

# 由于脚本在子进程中运行，直接 source 不会影响当前 shell
echo "🚨 要使 ClaudeSwitch 命令在当前终端可用，请执行："
echo ""
echo "   source ~/.zshrc    # 重新加载 shell 配置"
echo ""
echo "然后你就可以立即使用 claudeswitch 命令了！"
echo ""

# 清理可能存在的旧文件（现在有了新的持久化机制，不再需要）
rm -f ~/.config/claude/quick-load.sh 2>/dev/null || true

# 检测当前 shell 给出准确建议
current_shell=$(basename "$SHELL")
if [[ "$current_shell" == "zsh" ]]; then
    echo "🎯 检测到 Zsh，执行：source ~/.zshrc"
elif [[ "$current_shell" == "bash" ]]; then
    echo "🎯 检测到 Bash，执行：source ~/.bashrc"
else
    echo "🎯 当前 shell: $current_shell，执行：source ~/.${current_shell}rc"
fi

echo ""
echo "⏰ 或者你可以直接关闭此终端并重新打开新终端"
echo ""
echo "🌟 新功能：配置现在会自动持久化！"
echo "   切换 API 设置后会自动保存，新终端会自动恢复之前的配置"
echo ""
echo "📋 加载成功后，建议下一步："
echo "1️⃣ 编辑密钥：vim ~/.config/claude/api-keys.env"
echo "2️⃣ 测试：claudeswitch test"
echo "3️⃣ 初次切换：claudeswitch moon"
echo "4️⃣ 打开新终端，验证配置自动恢复"
echo ""
echo "💡 提示：密钥文件权限已设置为 600（仅当前用户可读写）"