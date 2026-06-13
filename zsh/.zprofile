# Homebrew is installed in different locations on Apple Silicon and Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Keep existing MacPorts and framework Python installs available when present.
[[ -d /opt/local/bin ]] && path=(/opt/local/bin /opt/local/sbin $path)
[[ -d /Library/Frameworks/Python.framework/Versions/3.13/bin ]] &&
  path=(/Library/Frameworks/Python.framework/Versions/3.13/bin $path)

export HOMEBREW_PIP_INDEX_URL="${HOMEBREW_PIP_INDEX_URL:-https://pypi.mirrors.ustc.edu.cn/simple}"
export HOMEBREW_API_DOMAIN="${HOMEBREW_API_DOMAIN:-https://mirrors.ustc.edu.cn/homebrew-bottles/api}"
export HOMEBREW_BOTTLE_DOMAIN="${HOMEBREW_BOTTLE_DOMAIN:-https://mirrors.ustc.edu.cn/homebrew-bottles}"

# Machine-specific overrides belong in ~/.zprofile.local and stay out of git.
[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
