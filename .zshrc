fpath+=($HOME/.zsh/pure)

autoload -U promptinit; promptinit
prompt pure
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^ ' autosuggest-accept
bindkey -s '^f' "tmux-sessionizer\n"

path+=("/usr/local/go/bin")

