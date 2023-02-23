#
# Global antidote configuration
#

#
# Load various lib files
#

# Set the name of the static .zsh plugins file antidote will generate.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins.zsh

# Ensure you have a .zsh_plugins.txt file where you can add plugins.
[[ -f ${ZDOTDIR:-~}/dotfiles/.zsh_plugins.txt ]] || touch ${ZDOTDIR:-~}/dotfiles/.zsh_plugins.txt

# Lazy-load antidote.
fpath+=(${ZDOTDIR:-~}/.antidote)
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when .zsh_plugins.txt is updated.
if [[ ! $zsh_plugins -nt ${ZDOTDIR:-~}/dotfiles/.zsh_plugins.zsh ]]; then
  (antidote bundle <${ZDOTDIR:-~}/dotfiles/.zsh_plugins.txt >|$zsh_plugins)
fi

# Source your static plugins file.
source $zsh_plugins

#
# antidote Bundles
#
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

if ! type jump > /dev/null; then
    antidote bundle agkozak/zsh-z
else
    eval "$(jump shell --bind=z)"
fi

#
# antidote theme
#


