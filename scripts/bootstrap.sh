#!/bin/zsh
set -euo pipefail

repo_url="${DOTFILES_REPO_URL:-https://github.com/BojayL/mac-dotfiles.git}"
repo_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap script currently supports macOS only." >&2
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Finish installing Command Line Tools, then run this script again."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ ! -d "$repo_dir/.git" ]]; then
  git clone "$repo_url" "$repo_dir"
else
  git -C "$repo_dir" pull --ff-only
fi

brew bundle --file "$repo_dir/Brewfile"
"$repo_dir/scripts/install.sh"
