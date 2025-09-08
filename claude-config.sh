#!/bin/zsh
# Claude API 配置切换工具 (持久化版)
# 文件位置: ~/.config/claude/claude-config.sh

# 定义配置文件路径
_CLAUDE_CONFIG_DIR="$HOME/.config/claude"
_CLAUDE_API_KEYS_FILE="$_CLAUDE_CONFIG_DIR/api-keys.env"
_CLAUDE_CHOICE_FILE="$_CLAUDE_CONFIG_DIR/api_choice"

# 加载API密钥配置
_load_api_keys() {
    if [[ -f "$_CLAUDE_API_KEYS_FILE" ]]; then
        source "$_CLAUDE_API_KEYS_FILE"
    else
        echo "❌ 未找到密钥文件 $_CLAUDE_API_KEYS_FILE"
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

# 根据选择应用配置
claudeapply() {
    _load_api_keys || return 1
    
    local choice
    if [[ -f "$_CLAUDE_CHOICE_FILE" ]]; then
        choice=$(cat "$_CLAUDE_CHOICE_FILE")
    else
        choice="clear"
    fi

    case $choice in
        moon|moonshot)
            if [[ -z "$MOONSHOT_API_KEY" ]]; then return 1; fi
            _clear_claude_env
            export ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic"
            export ANTHROPIC_AUTH_TOKEN="$MOONSHOT_API_KEY"
            export ANTHROPIC_MODEL="moonshotai/Kimi-K2-Instruct-0905"
            ;;
        ali|bailian)
            if [[ -z "$BAILIAN_AUTH_TOKEN" ]]; then return 1; fi
            _clear_claude_env
            export ANTHROPIC_BASE_URL="https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
            export ANTHROPIC_AUTH_TOKEN="$BAILIAN_AUTH_TOKEN"
            ;;
        ms|modelscope)
            if [[ -z "$MODELSCOPE_AUTH_TOKEN" ]]; then return 1; fi
            _clear_claude_env
            export ANTHROPIC_BASE_URL="https://api-inference.modelscope.cn"
            export ANTHROPIC_AUTH_TOKEN="$MODELSCOPE_AUTH_TOKEN"
            export ANTHROPIC_MODEL="moonshotai/Kimi-K2-Instruct-0905"
            ;;
        big|bigmodel)
            if [[ -z "$BIGMODEL_API_KEY" ]]; then return 1; fi
            _clear_claude_env
            export ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic"
            export ANTHROPIC_AUTH_TOKEN="$BIGMODEL_API_KEY"
            export ANTHROPIC_MODEL="glm-4.5"
            export ANTHROPIC_SMALL_FAST_MODEL="glm-4.5-air"
            ;;
        clear)
            _clear_claude_env
            ;;
        *)
            # 兼容旧的或未知配置，清理环境
            _clear_claude_env
            ;;
    esac
}

# 主切换函数
claudeswitch() {
    local choice="$1"
    
    case $choice in
        moon|moonshot)
            echo "moon" > "$_CLAUDE_CHOICE_FILE"
            claudeapply
            echo "✅ 已切换到 Moonshot API"
            ;;
        ali|bailian)
            echo "ali" > "$_CLAUDE_CHOICE_FILE"
            claudeapply
            echo "✅ 已切换到阿里云百炼"
            ;;
        ms|modelscope)
            echo "ms" > "$_CLAUDE_CHOICE_FILE"
            claudeapply
            echo "✅ 已切换到 ModelScope"
            ;;
        big|bigmodel)
            echo "big" > "$_CLAUDE_CHOICE_FILE"
            claudeapply
            echo "✅ 已切换到智谱 BigModel"
            ;;
        status)
            local current_choice
            if [[ -f "$_CLAUDE_CHOICE_FILE" ]]; then
                current_choice=$(cat "$_CLAUDE_CHOICE_FILE")
            else
                current_choice="未设置"
            fi
            echo "💾 当前持久化选择: $current_choice"
            echo "📊 当前 Shell 环境配置："
            echo "   BASE_URL: ${ANTHROPIC_BASE_URL:-未设置}"
            echo "   API_KEY: ${ANTHROPIC_API_KEY:+'*已设置*'}"
            echo "   AUTH_TOKEN: ${ANTHROPIC_AUTH_TOKEN:+'*已设置*'}"
            echo "   MODEL: ${ANTHROPIC_MODEL:-未设置}"
            ;;
        clear)
            echo "clear" > "$_CLAUDE_CHOICE_FILE"
            claudeapply
            echo "🧹 已清理所有 Claude 环境变量，并设置默认状态为 'clear'"
            ;;
        help|--help|-h)
            echo "🚀 Claude 配置切换工具 (持久化版)"
            echo ""
            echo "命令："
            echo "   moon/moonshot     - 切换到 Moonshot API"
            echo "   ali/bailian       - 切换到阿里云百炼"
            echo "   ms/modelscope     - 切换到 ModelScope"
            echo "   big/bigmodel      - 切换到智谱 BigModel"
            echo "   status            - 显示当前配置"
            echo "   clear             - 清理环境变量并设为默认"
            echo "   help              - 显示此帮助"
            echo ""
            echo "💡 设置会自动在新的 Shell 中生效。"
            ;;
        "")
            echo "❌ 请指定配置名称，使用 'claudeswitch help' 查看选项"
            ;;
        *)
            echo "❌ 未知配置: $1，使用 'claudeswitch help' 查看选项"
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
        'big:切换到智谱 BigModel'
        'bigmodel:切换到智谱 BigModel'
        'status:显示当前配置'
        'clear:清理环境变量并设为默认'
        'help:显示帮助'
    )
    _describe 'claude options' options
}

# 注册补全函数
compdef _claude_complete claudeswitch

# 每次 source 时自动应用配置
claudeapply
