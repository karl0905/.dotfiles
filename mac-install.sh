#!/bin/bash

# mac-install.sh - Setup script for Karl's dotfiles on macOS
# This script will:
# 1. Install Homebrew if not already installed
# 2. Install all dependencies from Brewfile
# 3. Create necessary config directories
# 4. Symlink all dotfiles to their appropriate locations
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

  # Backup existing file/directory if it exists and is not a symlink
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
    log_warning "Backing up $dest to $backup"
    mv "$dest" "$backup"
  fi

  # Remove existing symlink
  if [ -L "$dest" ]; then
    rm "$dest"
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

  # Create directories
  mkdir -p ~/.config/nvim

  # Create directories for tmux
  mkdir -p ~/.config/tmux
  mkdir -p ~/.config/tmux/plugins

  # Create directories for borders
  mkdir -p ~/.config/borders

  # Create directories for karabiner
  mkdir -p ~/.config/karabiner

  # Aerospace removed as requested

  log_success "Directories created"
}

# Setup NeoVim
setup_neovim() {
  log_info "Setting up NeoVim..."

  # Symlink neovim config
  create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

  # Install packer.nvim if not already installed
  if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    log_info "Installing packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  fi

  # Install plugins
  log_info "Installing NeoVim plugins (this may take a while)..."
  # Use a more reliable approach to install plugins
  nvim --headless -c 'lua require("karl.packer")' -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || {
    log_warning "Automatic plugin installation failed. This is normal on first run."
    log_info "After installation completes, open NeoVim and run :PackerSync manually."
  }

  log_success "NeoVim setup complete"
}

# Setup tmux
setup_tmux() {
  log_info "Setting up tmux..."

  # Symlink tmux config
  create_symlink "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"

  # Install TPM (Tmux Plugin Manager) if not already installed
  if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    log_info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
  fi

  log_success "tmux setup complete"
  log_info "Remember to press prefix + I inside tmux to install plugins"
}

# Setup other configuration files
setup_other_configs() {
  log_info "Setting up other configuration files..."

  # WezTerm
  create_symlink "$DOTFILES_DIR/.wezterm.lua" "$HOME/.wezterm.lua"

  # Borders
  create_symlink "$DOTFILES_DIR/borders/bordersrc" "$HOME/.config/borders/bordersrc"

  # Karabiner
  create_symlink "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

  # ZSH
  create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

  log_success "Other configurations set up successfully"
}

# Main installation function
main() {
  echo -e "${CYAN}=== Karl's dotfiles installation script for macOS ===${NC}"
  echo -e "${CYAN}=== Starting installation from: ${DOTFILES_DIR} ===${NC}\n"

  # Install Homebrew
  install_homebrew

  # Install packages from Brewfile
  install_brew_packages

  # Create required directories
  create_directories

  # Setup NeoVim
  setup_neovim

  # Setup tmux
  setup_tmux

  # Setup other configuration files
  setup_other_configs

  echo -e "\n${GREEN}=== Installation complete! ===${NC}"
  echo -e "${YELLOW}Notes:${NC}"
  echo -e "1. Remember to restart your terminal for changes to take effect"
  echo -e "2. For tmux, launch it and press ${YELLOW}prefix + I${NC} to install plugins"
  echo -e "3. For NeoVim, you might need to run ${YELLOW}:PackerSync${NC} again inside NeoVim"
  echo -e "4. Some settings might require logout/login to take effect"
}

# Execute main function
main
