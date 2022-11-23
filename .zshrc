fpath+=($HOME/.zsh/pure)

autoload -U promptinit; promptinit
prompt pure
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^ ' autosuggest-accept
bindkey -s '^f' "tmux-sessionizer\n"

tilde=~
path+=("/usr/local/go/bin" "${tilde}/go/bin" "${tilde}/.local/bin" "${tilde}/.local/neovim/bin" )

alias ls='exa --icons'

