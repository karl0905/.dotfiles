#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
done

REPO_ROOT="$(cd -P "$(dirname "$SOURCE")" && pwd)"

PACMAN_PACKAGES=(
  git
  stow
  zsh
  zsh-completions
  neovim
  tmux
  fzf
  zoxide
  eza
  fd
  ripgrep
  wezterm
  direnv
  ttf-hack-nerd
)

AUR_PACKAGES=(
  zsh-theme-powerlevel10k-git
)

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

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_pacman_packages() {
  log_info "Installing Arch packages with pacman..."
  sudo pacman -S --needed "${PACMAN_PACKAGES[@]}"
  log_success "Arch packages installed"
}

install_aur_packages() {
  if [ "${#AUR_PACKAGES[@]}" -eq 0 ]; then
    return
  fi

  if ! command_exists yay; then
    log_warning "Skipping AUR packages because yay is not installed: ${AUR_PACKAGES[*]}"
    return
  fi

  log_info "Installing AUR packages with yay..."
  yay -S --needed "${AUR_PACKAGES[@]}"
  log_success "AUR packages installed"
}

stow_packages() {
  if ! command_exists stow; then
    log_error "stow is not installed"
    exit 1
  fi

  log_info "Stowing common and linux packages into $HOME..."
  stow --dir="$REPO_ROOT" --target="$HOME" --restow common linux
  log_success "Stowed common and linux packages"
}

bootstrap_neovim() {
  local packer_dir="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

  if [ -d "$packer_dir" ]; then
    return
  fi

  log_info "Installing packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_dir"
  log_success "packer.nvim installed"
}

bootstrap_tmux() {
  local tpm_dir="$HOME/.config/tmux/plugins/tpm"

  if [ -d "$tpm_dir" ]; then
    return
  fi

  log_info "Installing Tmux Plugin Manager..."
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"
  log_success "Tmux Plugin Manager installed"
}

main() {
  echo -e "${CYAN}=== Karl's dotfiles installation script for Linux ===${NC}"
  echo -e "${CYAN}=== Starting installation from: ${REPO_ROOT} ===${NC}\n"

  if ! command_exists pacman; then
    log_error "This installer currently supports Arch-based systems with pacman"
    exit 1
  fi

  install_pacman_packages
  install_aur_packages
  stow_packages
  bootstrap_neovim
  bootstrap_tmux

  echo -e "\n${GREEN}=== Installation complete! ===${NC}"
  echo -e "${YELLOW}Notes:${NC}"
  echo -e "1. Restart your shell so zsh, powerlevel10k, and completions reload"
  echo -e "2. For tmux, launch it and press ${YELLOW}prefix + I${NC} to install plugins"
  echo -e "3. For NeoVim, run ${YELLOW}:PackerSync${NC} once inside NeoVim if plugins are missing"
}

main "$@"
