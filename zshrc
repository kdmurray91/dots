################################################################################
#                                  ZSH config                                  #
################################################################################

export LANG=en_AU.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
export VIRTUALENVWRAPPER_PYTHON="${VIRTUALENVWRAPPER_PYTHON:-python3}"

if [ -n "$(which lesspipe 2>/dev/null)" ]
then
    eval $(lesspipe)
fi

function sourceifexists() {
    file="$1"
    test -f "$file" && source "$file"
}

setopt autocd extendedglob notify
setopt histignorespace
setopt autopushd
unsetopt beep
stty -ixon

# Source here to ensure all plugins have paths etc. set right
sourceifexists "$HOME/.zshlocal.pre"
sourceifexists "$HOME/.zshlocal"

################################################################################
#                                Plugin config                                 #
################################################################################
# Unfortunately some of these seem to need to be above the zgen stanza below

# Virtualenvwrapper
#export WORKON_HOME="$HOME/.virtualenvs/"

# tmux
ZSH_TMUX_AUTOSTART=${ZSH_TMUX_AUTOSTART:-true}
ZSH_TMUX_AUTOQUIT=${ZSH_TMUX_AUTOQUIT:-false}
ZSH_TMUX_AUTOCONNECT=${ZSH_TMUX_AUTOCONNECT:-false}
ZSH_TMUX_FIXTERM=${ZSH_TMUX_FIXTERM:-true}


################################################################################
#                                     Zgen                                     #
################################################################################
# Double underscore not to clash w/ zgen's internals
__ZGEN_DIR="$HOME/.cache/zgenom"
__ZGEN="$__ZGEN_DIR/zgenom.zsh"
if [ ! -f $__ZGEN ];
then
    git clone https://github.com/jandamm/zgenom.git $__ZGEN_DIR
fi
source $__ZGEN
unset __ZGEN_DIR
unset __ZGEN


################################################################################
#                           Zgen plugin install/load                           #
################################################################################

# Colour context red if we're on a remote server
BULLETTRAIN_CONTEXT_SHOW=true
if [ -n "$SSH_CLIENT" ]
then
    BULLETTRAIN_CONTEXT_BG=red
    BULLETTRAIN_CONTEXT_FG=black
    BULLETTRAIN_IS_SSH_CLIENT=true
else
    BULLETTRAIN_CONTEXT_BG=green
    BULLETTRAIN_CONTEXT_FG=white
    BULLETTRAIN_IS_SSH_CLIENT=false
fi
BULLETTRAIN_SEGMENT_SEPARATOR=""
BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    custom
    context
    dir
    git
    virtualenv
    cmd_exec_time
  )

# Uncomment the below while debugging, forces reset
# zgen reset
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)

if ! zgen saved; then
    # OMZsh and some plugins
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/debian
    zgen oh-my-zsh plugins/git
    #zgen oh-my-zsh plugins/ssh-agent
    #zgen oh-my-zsh plugins/gpg-agent
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/taskwarrior
    zgen oh-my-zsh plugins/tmux
    #zgen oh-my-zsh plugins/virtualenvwrapper

    # Hist search
    zgen load zsh-users/zsh-history-substring-search

    # ZSH command syntax hl
    zgen load zsh-users/zsh-syntax-highlighting

    # Extra shell completions
    zgen load zsh-users/zsh-completions

    # easily add remotes to git repositories.
    zgen load caarlos0/git-add-remote

    # Warns you when you have an alias for the command you just typed, and tells
    # you what it is.
    #zgen load djui/alias-tips
    zgen oh-my-zsh plugins/alias-finder

    # Improvements to vi-mode
    zgen load sharat87/zsh-vim-mode
    zgen load b4b4r07/zsh-vimode-visual

    # Gitignore generator
    zgen load voronkovich/gitignore.plugin.zsh

    # Theme
    zgen load kdm9/bullet-train.zsh bullet-train

    zgen load kdm9/zsh-autoactivate-conda

    zgen load kloetzl/biozsh

    zgen save
fi

################################################################################
#                           Misc final configuration                           #
################################################################################

# These need to be at the end

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

################################################################################
#                         KDM specific aliases & funcs                         #
################################################################################

sourceifexists "$HOME/.dots/aliases.sh"
sourceifexists "$HOME/.dots/functions.sh"


# Ensure tmux termcap is defined
#TERM=tmux tput cols >/dev/null 2>&1 || tic ${HOME}/.dots/tmux.term

################################################################################
#                              load zshlocal.post                              #
################################################################################

# Source here to ensure post script is final
sourceifexists "$HOME/.zshlocal.post"
