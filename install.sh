#!/bin/bash
# Claude 配置工具一键安装脚本

set -e

CONFIG_DIR="$HOME/.config/claude"
KEYS_FILE="$CONFIG_DIR/api-keys.env"
CONFIG_FILE="$CONFIG_DIR/claude-config.sh"
ZSHRC="$HOME/.zshrc"

echo "🚀 开始安装 Claude 配置工具..."

# 创建配置目录
mkdir -p "$CONFIG_DIR"

# 创建密钥文件
if [[ ! -f "$KEYS_FILE" ]]; then
    cat > "$KEYS_FILE" << 'EOF'
# Claude API 密钥配置文件

# Moonshot API 配置
MOONSHOT_API_KEY="sk-your-moonshot-key"

# 阿里云百炼配置  
BAILIAN_AUTH_TOKEN="sk-your-bailian-token"

# ModelScope 配置
MODELSCOPE_AUTH_TOKEN="ms-your-modelscope-token"
EOF
    chmod 600 "$KEYS_FILE"
    echo "✅ 密钥文件已创建: $KEYS_FILE"
else
    echo "⚠️  密钥文件已存在: $KEYS_FILE"
fi

# 复制配置脚本
if [[ -f "claude-config.sh" ]]; then
    cp "claude-config.sh" "$CONFIG_FILE"
    chmod +x "$CONFIG_FILE"
    echo "✅ 配置脚本已复制到 $CONFIG_FILE"
else
    echo "❌ 错误：在当前目录未找到 claude-config.sh 文件"
    exit 1
fi

# 检查并添加到 .zshrc
if ! grep -q "source.*claude-config.sh" "$ZSHRC" 2>/dev/null; then
    echo "" >> "$ZSHRC"
    echo "# Claude 配置切换工具" >> "$ZSHRC"
    echo "source ~/.config/claude/claude-config.sh" >> "$ZSHRC"
    echo "✅ 已添加到 .zshrc"
else
    echo "ℹ️  .zshrc 中已存在 claude-config.sh 引用"
fi

echo ""
echo "🎉 安装完成！"
echo ""
echo "📋 下一步："
echo "1️⃣  编辑密钥：vim ~/.config/claude/api-keys.env"
echo "2️⃣  重新加载：source ~/.zshrc"
echo "3️⃣  切换配置：claudeswitch moon (或 ali, ms)"
echo "4️⃣  查看状态：claudeswitch status"
echo ""
echo "💡 你的选择会自动在所有新终端中生效。密钥文件权限已设置为 600。"