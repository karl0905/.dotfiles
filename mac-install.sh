#!/bin/bash

# mac-install.sh - Setup script for Karl's dotfiles on macOS
# This script will:
# 1. Install Homebrew if not already installed
# 2. Install all dependencies from Brewfile
# 3. Create necessary config directories
# 4. Symlink files that should exist outside of .config
# 5. Install additional components (NeoVim plugins, etc.)

# Set colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Dotfiles directory (the directory where this script is located)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Create a symbolic link with backup of existing file
create_symlink() {
  local src="$1"
  local dest="$2"

  # Create directory if it doesn't exist
  mkdir -p "$(dirname "$dest")"

  # If destination exists (file, directory, or symlink)
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    log_warning "Removing existing $dest"
    rm -rf "$dest"
  fi

  # Create symlink
  ln -sf "$src" "$dest"
  log_success "Symlinked $src to $dest"
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

  if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    # Make sure Homebrew bundle is installed
    brew tap Homebrew/bundle

    # Install from Brewfile
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    log_success "Packages installed successfully"
  else
    log_error "Brewfile not found at $DOTFILES_DIR/Brewfile"
  fi
}

# Create required directories
create_directories() {
  log_info "Creating required directories..."

  # Create directories (these should already exist if cloned to .config)
  mkdir -p ~/.config/nvim
  mkdir -p ~/.config/tmux
  mkdir -p ~/.config/tmux/plugins
  mkdir -p ~/.config/borders
  mkdir -p ~/.config/karabiner

  log_success "Directories created"
}

# Main installation function
main() {
  echo -e "${CYAN}=== Karl's dotfiles installation script for macOS ===${NC}"
  echo -e "${CYAN}=== Starting installation from: ${DOTFILES_DIR} ===${NC}\n"

  # Install Homebrew
  install_homebrew

  # Install packages from Brewfile
  install_brew_packages

  # Create required directories (if they don't exist)
  create_directories

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

  # Only symlink files that go outside of .config
  log_info "Creating symbolic links for files outside of .config..."
  create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  create_symlink "$DOTFILES_DIR/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
  create_symlink "$DOTFILES_DIR/.wezterm.lua" "$HOME/.wezterm.lua"

  # These may be redundant if borders and karabiner are already in .config
  # but keeping them for clarity
  create_symlink "$DOTFILES_DIR/borders/bordersrc" "$HOME/.config/borders/bordersrc"
  create_symlink "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

  echo -e "\n${GREEN}=== Installation complete! ===${NC}"
  echo -e "${YELLOW}Notes:${NC}"
  echo -e "1. Remember to restart your terminal for changes to take effect"
  echo -e "2. For tmux, launch it and press ${YELLOW}prefix + I${NC} to install plugins"
  echo -e "3. For NeoVim, you might need to run ${YELLOW}:PackerSync${NC} manually inside NeoVim"
  echo -e "4. Some settings might require logout/login to take effect"
}

# Execute main function
main
