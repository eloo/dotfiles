#
# Global zinit configuration
#

# zinit installation path
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# oh my zsh lib
zinit snippet OMZL::git.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::spectrum.zsh
zinit snippet OMZL::termsupport.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::grep.zsh
zinit snippet OMZL::misc.zsh

# oh my zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::pip
zinit snippet OMZP::aws
zinit snippet OMZP::extract
zinit snippet OMZP::docker-compose
zinit snippet OMZP::kubectl
zinit snippet OMZP::brew

# zsh-users
zinit ice blockf; zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# misc
zinit ice as"null" fpath"."; zinit light nobeans/zsh-sdkman
zinit light djui/alias-tips
zinit ice as"null" fpath"."; zinit light sawadashota/go-task-completions

# Initialize completions (replaces mattmc3/zephyr path:plugins/completion)
autoload -Uz compinit && compinit
zinit cdreplay -q

DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

if ! type jump > /dev/null; then
else
    eval "$(jump shell --bind=z)"
fi

eval "$(task --completion zsh)"

function zinit_update() {
    zinit update --all
}
