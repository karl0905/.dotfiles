# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Set Powerlevel10k path based on OS
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS-specific configurations
    export POWERLEVEL10K_PATH="/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme"
    export PATH="/Applications/Opera GX.app/Contents/MacOS:$PATH"
elif [[ "$(uname)" == "Linux" ]]; then
    # WSL-specific configurations
    export POWERLEVEL10K_PATH="/home/linuxbrew/.linuxbrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ -n "$POWERLEVEL10K_PATH" ]]; then
    source "$POWERLEVEL10K_PATH"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

################### EXPORTS ######################

export EDITOR="nvim"
export VISUAL="nvim"

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
# Load ASDF based on OS
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS ASDF initialization
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [[ "$(uname)" == "Linux" ]]; then
    # Linux ASDF initialization
    . /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh
fi

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"
# Fix for dotnet tools in both WSL and macOS
if [[ "$(uname)" == "Linux" ]]; then
    # We're in Linux (WSL)
    if [[ -d "/usr/share/dotnet" ]]; then
        # Set .NET environment variables for WSL
        export DOTNET_ROOT=/usr/share/dotnet
        export PATH="$HOME/.dotnet/tools:$PATH"
    fi
elif [[ "$(uname)" == "Darwin" ]]; then
    # We're in macOS
    # macOS-specific dotnet config if needed
    # Nothing needed here as it works already
    true
fi

#################### GIT #########################

# Get the current git branch name
get_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/ '
}
# Get the remote URL of the current git repository
get_git_remote_url() {
  git config --get remote.origin.url | sed -e 's|^git@\(.*\):\(.*\)$|https://\1/\2|' -e 's|\.git$||'
}
# Push current branch to remote and set upstream
git_push_set_upstream() {
  git push --set-upstream origin $(get_git_branch)
}
# Open GitHub pull request page for the current branch
git_pull_request() {
  open "$(get_git_remote_url)/compare/main...$(get_git_branch)?expand=1"
}

############### BINDS AND MODES ##################
bindkey -v

bindkey '^R' history-incremental-search-backward

#################### ALIAS #######################

alias ls="eza --icons=always"
alias python="python3"
alias gppr="git_push_set_upstream && git_pull_request"
alias gpsu="git_push_set_upstream"
alias gl="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias grep="rg"
