# Color definitions (converting tput colors to zsh format)
bold='%B'
reset='%b%f'
blue='%F{153}'
steel_blue='%F{67}'
green='%F{71}'
orange='%F{166}'
red='%F{167}'
white='%F{15}'
yellow='%F{228}'

# Set user style based on root status
if [[ "${USER}" == "root" ]]; then
    userStyle="${red}"
else
    userStyle="${orange}"
fi

# Set host style based on SSH status
if [[ "${SSH_TTY}" ]]; then
    hostStyle="${bold}${red}"
else
    hostStyle="${yellow}"
fi

# Git status function
function prompt_git() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local git_status=''
    local gitSummary
    gitSummary=$(git status --porcelain)

    [[ "$gitSummary" == *$'\nM'* || "$gitSummary" == $'M'* ]] && git_status+='+'
    [[ "$gitSummary" == *$'\n M'* || "$gitSummary" == $' M'* ]] && git_status+='!'
    [[ "$gitSummary" == *'??'* ]] && git_status+='?'
    git rev-parse --verify refs/stash &>/dev/null && git_status+='$'

    local branchName
    branchName="$(git symbolic-ref --quiet --short HEAD 2>/dev/null \
        || git rev-parse --short HEAD 2>/dev/null \
        || echo '(unknown)')"

    [[ -n "$git_status" ]] && git_status=" [${git_status}]"
    echo "${white} on ${blue}${branchName}${git_status}"
}

# Virtual environment function
export VIRTUAL_ENV_DISABLE_PROMPT=1
function prompt_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        echo "\n${steel_blue}(${venv_name})\n"
    fi
}

# Enable required zsh options
setopt PROMPT_SUBST

# Set the prompt
PROMPT='$(prompt_venv)' # virtual environment
PROMPT+='${bold}'$'\n' # newline
PROMPT+='${userStyle}%n' # username
PROMPT+='${white} at '
PROMPT+='${hostStyle}%m' # host
PROMPT+='${white} in '
PROMPT+='${green}%1~' # working directory
PROMPT+='$(prompt_git)' # Git repository details
PROMPT+=$'\n'
PROMPT+='${white}$ ${reset}' # `$` (and reset color)

# Set the continuation prompt (PS2)
PROMPT2='${yellow}→ ${reset}'

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt hist_reduce_blanks

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- TOOLS ----
# Zoxide (better cd) — cached to avoid subprocess on every shell startup
_zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zoxide_init.zsh"
if [[ ! -f "$_zoxide_cache" || "$commands[zoxide]" -nt "$_zoxide_cache" ]]; then
    zoxide init zsh >| "$_zoxide_cache"
fi
source "$_zoxide_cache"

# thefuck — lazy-loaded to avoid slow Python startup on every shell startup
# Initialises on first use; re-run command after the first invocation.
function fuck() {
    eval "$(thefuck --alias)"
    unfunction fuck
}

# ---- ALIASES ----
alias brewmaint='brew update && brew upgrade && brew autoremove && brew cleanup -s' # run all basic brew commands with an alias
alias cd='z' # replace cd w/ zoxide
alias ls='eza -a --icons=always --group-directories-first' # Eza (better ls)
alias tree='tree -C' # add coloration to tree command
alias poweradapter='system_profiler SPPowerDataType | grep -i "Wattage"' # see wattage of attached charger on macbook
# alias cat='bat --paging=never' # better cat

# ---- PLUGINS ----
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh