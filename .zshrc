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

# You can add your personal aliases here
# Example: alias ls='ls -G'

alias ls="eza --icons=always"
alias python="python3"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
