#!/bin/zsh
# Claude API 配置切换工具 (完整版)
# 文件位置: ~/.config/claude/claude-config.sh

# 加载API密钥配置
_load_api_keys() {
    local keys_file="$HOME/.config/claude/api-keys.env"
    
    if [[ -f "$keys_file" ]]; then
        source "$keys_file"
    else
        echo "⚠️  警告: 未找到密钥文件 $keys_file"
        echo "请创建该文件并添加相应的API密钥"
        return 1
    fi
}

# 清理环境变量
_clear_claude_env() {
    unset ANTHROPIC_BASE_URL
    unset ANTHROPIC_API_KEY
    unset ANTHROPIC_AUTH_TOKEN
    unset ANTHROPIC_MODEL
}

# 保存当前配置到文件
_save_current_config() {
    local config_file="$HOME/.config/claude/current-config.env"
    cat > "$config_file" << EOF
# ClaudeSwitch 自动保存的配置
# 生成时间: $(date)
ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-}"
ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}"
ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN:-}"
ANTHROPIC_MODEL="${ANTHROPIC_MODEL:-}"
EOF
    chmod 600 "$config_file"
}

# 加载保存的配置
_load_saved_config() {
    local config_file="$HOME/.config/claude/current-config.env"
    if [[ -f "$config_file" ]]; then
        source "$config_file"
        if [[ -n "$ANTHROPIC_BASE_URL" ]]; then
            # 静默模式加载，只显示简要信息
            #echo "🔄 已恢复配置: $(basename "$ANTHROPIC_BASE_URL")"
            return 0
        fi
    fi
    return 1
}

# 验证密钥是否存在
_check_key() {
    local key_name="$1"
    local key_value="$2"
    
    if [[ -z "$key_value" ]]; then
        echo "❌ 错误: $key_name 未在密钥文件中设置"
        return 1
    fi
    return 0
}

# 主配置函数
claudeswitch() {
    # 加载密钥文件
    _load_api_keys || return 1
    
    case $1 in
        moon|moonshot)
            if _check_key "MOONSHOT_API_KEY" "$MOONSHOT_API_KEY"; then
                _clear_claude_env
                export ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
                export ANTHROPIC_API_KEY="$MOONSHOT_API_KEY"
                _save_current_config
                echo "✅ 已切换到 Moonshot API"
                echo "   BASE_URL: $ANTHROPIC_BASE_URL"
                echo "💾 配置已保存，新终端将自动加载此配置"
            fi
            ;;
        ali|bailian)
            if _check_key "BAILIAN_AUTH_TOKEN" "$BAILIAN_AUTH_TOKEN"; then
                _clear_claude_env
                export ANTHROPIC_BASE_URL="https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
                export ANTHROPIC_AUTH_TOKEN="$BAILIAN_AUTH_TOKEN"
                _save_current_config
                echo "✅ 已切换到阿里云百炼"
                echo "   BASE_URL: $ANTHROPIC_BASE_URL"
                echo "💾 配置已保存，新终端将自动加载此配置"
            fi
            ;;
        ms|modelscope)
            if _check_key "MODELSCOPE_AUTH_TOKEN" "$MODELSCOPE_AUTH_TOKEN"; then
                _clear_claude_env
                export ANTHROPIC_BASE_URL="https://api-inference.modelscope.cn"
                export ANTHROPIC_AUTH_TOKEN="$MODELSCOPE_AUTH_TOKEN"
                export ANTHROPIC_MODEL="moonshotai/Kimi-K2-Instruct-0905"
                _save_current_config
                echo "✅ 已切换到 ModelScope"
                echo "   BASE_URL: $ANTHROPIC_BASE_URL"
                echo "   MODEL: $ANTHROPIC_MODEL"
                echo "💾 配置已保存，新终端将自动加载此配置"
            fi
            ;;
        status|st)
            echo "📊 当前 Claude 配置："
            echo "   BASE_URL: ${ANTHROPIC_BASE_URL:-❌ 未设置}"
            
            # 根据当前配置的 URL 决定显示哪些认证信息
            if [[ "$ANTHROPIC_BASE_URL" == *"modelscope.cn"* ]]; then
                # ModelScope 平台只使用 AUTH_TOKEN
                if [[ -n "$ANTHROPIC_AUTH_TOKEN" ]]; then
                    echo "   AUTH_TOKEN: ✅ 已设置 (${ANTHROPIC_AUTH_TOKEN:0:8}...)"
                else
                    echo "   AUTH_TOKEN: ❌ 未设置"
                fi
            elif [[ "$ANTHROPIC_BASE_URL" == *"moonshot.cn"* ]]; then
                # Moonshot 平台只使用 API_KEY
                if [[ -n "$ANTHROPIC_API_KEY" ]]; then
                    echo "   API_KEY: ✅ 已设置 (${ANTHROPIC_API_KEY:0:8}...)"
                else
                    echo "   API_KEY: ❌ 未设置"
                fi
            elif [[ "$ANTHROPIC_BASE_URL" == *"aliyuncs.com"* ]]; then
                # 阿里云百炼只使用 AUTH_TOKEN
                if [[ -n "$ANTHROPIC_AUTH_TOKEN" ]]; then
                    echo "   AUTH_TOKEN: ✅ 已设置 (${ANTHROPIC_AUTH_TOKEN:0:8}...)"
                else
                    echo "   AUTH_TOKEN: ❌ 未设置"
                fi
            else
                # 默认显示两种认证方式
                if [[ -n "$ANTHROPIC_API_KEY" ]]; then
                    echo "   API_KEY: ✅ 已设置 (${ANTHROPIC_API_KEY:0:8}...)"
                else
                    echo "   API_KEY: ❌ 未设置"
                fi
                if [[ -n "$ANTHROPIC_AUTH_TOKEN" ]]; then
                    echo "   AUTH_TOKEN: ✅ 已设置 (${ANTHROPIC_AUTH_TOKEN:0:8}...)"
                else
                    echo "   AUTH_TOKEN: ❌ 未设置"
                fi
            fi
            echo "   MODEL: ${ANTHROPIC_MODEL:-❌ 未设置}"
            ;;
        clear|reset)
            _clear_claude_env
            rm -f "$HOME/.config/claude/current-config.env"
            echo "🧹 已清理所有 Claude 环境变量和保存的配置"
            ;;
        edit|config)
            echo "📝 打开配置文件:"
            echo "   密钥文件: ~/.config/claude/api-keys.env"
            echo "   配置文件: ~/.config/claude/claude-config.sh"
            echo ""
            echo "使用你喜欢的编辑器编辑，例如:"
            echo "   vim ~/.config/claude/api-keys.env"
            echo "   nano ~/.config/claude/api-keys.env"
            ;;
        test)
            echo "🧪 测试配置加载..."
            _load_api_keys
            echo "   MOONSHOT_API_KEY: ${MOONSHOT_API_KEY:+✅ 已设置}${MOONSHOT_API_KEY:-❌ 未设置}"
            echo "   BAILIAN_AUTH_TOKEN: ${BAILIAN_AUTH_TOKEN:+✅ 已设置}${BAILIAN_AUTH_TOKEN:-❌ 未设置}"
            echo "   MODELSCOPE_AUTH_TOKEN: ${MODELSCOPE_AUTH_TOKEN:+✅ 已设置}${MODELSCOPE_AUTH_TOKEN:-❌ 未设置}"
            ;;
        list|ls|help|--help|-h)
            echo "🚀 Claude 配置切换工具"
            echo ""
            echo "📋 API 配置:"
            echo "   moon/moonshot     - 切换到 Moonshot API"
            echo "   ali/bailian       - 切换到阿里云百炼"
            echo "   ms/modelscope     - 切换到 ModelScope"
            echo ""
            echo "🛠️  管理命令:"
            echo "   status/st         - 显示当前配置"
            echo "   clear/reset       - 清理环境变量和保存的配置"
            echo "   edit/config       - 编辑配置文件"
            echo "   test              - 测试密钥加载"
            echo "   list/ls/help      - 显示此帮助"
            echo ""
            echo "🔧 高级功能:"
            echo "   配置自动保存，新终端自动恢复上次的 API 设置"
            echo "   设置 CLAUDESWITCH_NO_AUTOLOAD=1 可禁用自动加载"
            echo ""
            echo "💡 示例:"
            echo "   claudeswitch moon       # 切换到 Moonshot"
            echo "   claudeswitch status     # 查看当前状态"
            echo "   claudeswitch edit       # 编辑密钥"
            ;;
        "")
            echo "❌ 请指定配置名称"
            claudeswitch help
            ;;
        *)
            echo "❌ 未知配置: $1"
            echo "使用 'claudeswitch help' 查看可用选项"
            ;;
    esac
}

# Tab 自动补全支持
_claude_complete() {
    local -a options
    options=(
        'moon:切换到 Moonshot API'
        'moonshot:切换到 Moonshot API'
        'ali:切换到阿里云百炼'
        'bailian:切换到阿里云百炼'
        'ms:切换到 ModelScope'
        'modelscope:切换到 ModelScope'
        'status:显示当前配置'
        'st:显示当前配置'
        'clear:清理环境变量'
        'reset:清理环境变量'
        'edit:编辑配置文件'
        'config:编辑配置文件'
        'test:测试密钥加载'
        'list:显示帮助'
        'ls:显示帮助'
        'help:显示帮助'
    )
    _describe 'claude options' options
}

# 注册补全函数
compdef _claude_complete claudeswitch

# 自动加载保存的配置（静默模式，不打扰用户）
if [[ -z "$CLAUDESWITCH_NO_AUTOLOAD" ]]; then
    _load_saved_config 2>/dev/null
fi

# 显示加载信息
#echo "🚀 Claude 配置工具已加载 (使用 'claude help' 查看帮助)"