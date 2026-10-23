export GREP_COLOR='1;37;41'
export PATH="$HOME/.local/bin:$PATH"

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=12000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt hist_reduce_blanks

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- TOOLS ----
# Zoxide (better cd) - cached to avoid subprocess on every shell startup
_zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zoxide_init.zsh"
if [[ ! -f "$_zoxide_cache" || "$commands[zoxide]" -nt "$_zoxide_cache" ]]; then
    zoxide init zsh >| "$_zoxide_cache"
fi
source "$_zoxide_cache"

# Starship - cached to save a few milliseconds
_starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/starship_init.zsh"
if [[ ! -f "$_starship_cache" || "$commands[starship]" -nt "$_starship_cache" ]]; then
    starship init zsh --print-full-init >| "$_starship_cache"
fi
source "$_starship_cache"

# ---- ALIASES ----
alias brewmaint='brew update && brew upgrade -y && brew autoremove && brew cleanup -s' # run all basic brew commands with an alias
alias cd='z' # replace cd w/ zoxide
alias ls='eza -a --icons=always --group-directories-first' # Eza (better ls)
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias tree='tree -C' # add coloration to tree command
alias grep='rg'
alias poweradapter='system_profiler SPPowerDataType | grep -i "Wattage"' # see wattage of attached charger on macbook
alias clang++="clang++ -std=c++20"
alias bat='bat --style plain --pager never'

# ---- PLUGINS ----
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
