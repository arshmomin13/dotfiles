export GREP_COLOR='1;37;41'

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

# Starship
eval "$(starship init zsh)"

# ---- ALIASES ----
alias brewmaint='brew update && brew upgrade -y && brew autoremove && brew cleanup -s' # run all basic brew commands with an alias
alias cd='z' # replace cd w/ zoxide
alias ls='eza -a --icons=always --group-directories-first' # Eza (better ls)
alias tree='tree -C' # add coloration to tree command
alias grep='grep --color=auto'
alias poweradapter='system_profiler SPPowerDataType | grep -i "Wattage"' # see wattage of attached charger on macbook
# alias cat='bat --paging=never' # better cat
alias clang++="clang++ -std=c++20"

# ---- PLUGINS ----
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
