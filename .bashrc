#
# ~/.bashrc
#

# Exit early if not interactive
[[ $- != *i* ]] && return

# --------------------------------------------------------------------
# Aliases
# --------------------------------------------------------------------
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'
alias grep='grep --color=auto'

# Git shortcuts
alias gs='git status'
alias gd='git diff'
alias gc='git commit'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'

# Editor
alias vim='nvim'

# --------------------------------------------------------------------
# Prompt
# --------------------------------------------------------------------
PS1='[\u@\h \W]\$ '

# --------------------------------------------------------------------
# PATH setup (avoid duplicates)
# --------------------------------------------------------------------
add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;; # already in PATH
    *) PATH="$1:$PATH" ;;
  esac
}
add_to_path "$HOME/go/bin"
add_to_path "$HOME/boot.dev/worldbanc/private/bin/"

# --------------------------------------------------------------------
# NVM (Node Version Manager)
# --------------------------------------------------------------------
if [ -f /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi

# --------------------------------------------------------------------
# Secrets (API keys, tokens, etc.)
# --------------------------------------------------------------------
[ -f ~/.config/secrets.env ] && source ~/.config/secrets.env

# --------------------------------------------------------------------
# AI helper function (OpenRouter CLI shortcut)
# --------------------------------------------------------------------
ai() {
  curl -s https://openrouter.ai/api/v1/chat/completions \
    -H "Authorization: Bearer $OPENROUTER_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
      \"model\": \"openai/gpt-4o-mini\",
      \"messages\": [{\"role\": \"user\", \"content\": \"$*\"}]
    }" | jq -r '.choices[0].message.content'
}
# --------------------------------------------------------------------
# Starship Prompt
# --------------------------------------------------------------------
eval "$(starship init bash)"

# Load custom aliases and functions
[ -f ~/.config/shell/aliases.sh ] && source ~/.config/shell/aliases.sh
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh


# Turso
export PATH="$PATH:/home/me/.turso"

# Android Studio & SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

alias emulist='$ANDROID_HOME/emulator/emulator -list-avds'
alias emustart='nohup $ANDROID_HOME/emulator/emulator -avd Pixel_9 -no-snapshot >/dev/null 2>&1 &'
alias emusoft='nohup $ANDROID_HOME/emulator/emulator -avd Pixel_9 -no-snapshot -gpu software >/dev/null 2>&1 &'
alias emudev='adb devices'
