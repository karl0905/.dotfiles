#!/bin/bash

# macos-install.sh - Setup script for Karl's dotfiles on macOS
# This script will:
# 1. Install Homebrew if not already installed
# 2. Install all dependencies from Brewfile
# 3. Stow the common and macOS packages into $HOME
# 4. Install additional components (NeoVim plugins, etc.)

# Set colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Resolve the real script path so this works both inside the repo and via a symlink.
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
done

REPO_ROOT="$(cd -P "$(dirname "$SOURCE")" && pwd)"
BREWFILE_PATH="$REPO_ROOT/macos/Brewfile"

# Log helper functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not already installed
install_homebrew() {
  if ! command_exists brew; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for both Intel and Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
      # Apple Silicon
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      # Intel
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >>~/.zprofile
      eval "$(/usr/local/bin/brew shellenv)"
    fi

    log_success "Homebrew installed successfully"
  else
    log_info "Homebrew is already installed"
  fi
}

# Install packages from Brewfile
install_brew_packages() {
  log_info "Installing packages from Brewfile..."

  if [ -f "$BREWFILE_PATH" ]; then
    # Make sure Homebrew bundle is installed
    brew tap Homebrew/bundle

    # Install from Brewfile
    brew bundle --file="$BREWFILE_PATH"
    log_success "Packages installed successfully"
  else
    log_error "Brewfile not found at $BREWFILE_PATH"
    exit 1
  fi
}

# Stow packages into the home directory
stow_packages() {
  log_info "Stowing dotfiles into $HOME..."

  if ! command_exists stow; then
    log_error "stow is not installed"
    exit 1
  fi

  stow --dir="$REPO_ROOT" --target="$HOME" --restow common macos
  log_success "Stowed common and macOS packages"
}

# Main installation function
main() {
  echo -e "${CYAN}=== Karl's dotfiles installation script for macOS ===${NC}"
  echo -e "${CYAN}=== Starting installation from: ${REPO_ROOT} ===${NC}\n"

  # Install Homebrew
  install_homebrew

  # Install packages from Brewfile
  install_brew_packages

  # Stow packages
  stow_packages

  # Set up NeoVim
  log_info "Setting up NeoVim configuration"
  # Install packer.nvim if not already installed
  if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    log_info "Installing packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  fi

  # Set up Tmux
  log_info "Setting up tmux configuration"
  # Install TPM (Tmux Plugin Manager) if not already installed
  if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    log_info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
  fi

  echo -e "\n${GREEN}=== Installation complete! ===${NC}"
  echo -e "${YELLOW}Notes:${NC}"
  echo -e "1. Remember to restart your terminal for changes to take effect"
  echo -e "2. For tmux, launch it and press ${YELLOW}prefix + I${NC} to install plugins"
  echo -e "3. For NeoVim, you might need to run ${YELLOW}:PackerSync${NC} manually inside NeoVim"
  echo -e "4. Some settings might require logout/login to take effect"
}

# Execute main function
main
