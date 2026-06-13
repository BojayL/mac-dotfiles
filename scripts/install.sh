#!/bin/zsh
set -euo pipefail

repo_dir="${0:A:h:h}"
timestamp="$(date +%Y%m%d-%H%M%S)"

link_file() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "${target_path:h}"
  if [[ -L "$target_path" && "${target_path:A}" == "${source_path:A}" ]]; then
    return
  fi
  if [[ -e "$target_path" || -L "$target_path" ]]; then
    mv "$target_path" "${target_path}.bak-${timestamp}"
    echo "Backed up $target_path"
  fi
  ln -s "$source_path" "$target_path"
  echo "Linked $target_path"
}

link_file "$repo_dir/zsh/.zprofile" "$HOME/.zprofile"
link_file "$repo_dir/zsh/.zshrc" "$HOME/.zshrc"
link_file "$repo_dir/config/starship.toml" "$HOME/.config/starship.toml"

if [[ "${DOTFILES_SKIP_ITERM2:-0}" != "1" ]]; then
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$repo_dir/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi

mkdir -p "$HOME/.nvm"

echo
echo "Installed dotfiles. Restart iTerm2, then open a new shell."
