# Initialize Conda only when an installation is available.
for conda_bin in /opt/anaconda3/bin/conda "$HOME/miniconda3/bin/conda" "$HOME/anaconda3/bin/conda"; do
  if [[ -x "$conda_bin" ]]; then
    __conda_setup="$("$conda_bin" shell.zsh hook 2>/dev/null)"
    [[ $? -eq 0 ]] && eval "$__conda_setup"
    unset __conda_setup
    break
  fi
done
unset conda_bin

# Support both the nvm installer and Homebrew's nvm formula.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
elif command -v brew >/dev/null 2>&1 && [[ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ]]; then
  source "$(brew --prefix nvm)/nvm.sh"
fi
export NVM_NODEJS_ORG_MIRROR="${NVM_NODEJS_ORG_MIRROR:-https://npmmirror.com/mirrors/node}"

[[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1 &&
  source "$(kiro --locate-shell-integration-path zsh)"

# Normalize Enter if a terminal leaves CSI-u/modifyOtherKeys enabled.
if [[ -o interactive && -t 0 ]]; then
  printf '\e[<u\e[>4;0m' 2>/dev/null
  bindkey '^[[13u' accept-line
fi

path=("$HOME/.local/bin" $path)

if [[ -o interactive && -t 0 && "$TERM" != "dumb" ]]; then
  command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

  if command -v brew >/dev/null 2>&1; then
    brew_prefix="$(brew --prefix)"
    [[ -r "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
      source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -r "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
      source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

    if [[ -d "$brew_prefix/share/zsh-completions" ]]; then
      [[ ${fpath[(Ie)$brew_prefix/share/zsh-completions]} -eq 0 ]] &&
        fpath=("$brew_prefix/share/zsh-completions" $fpath)
      autoload -Uz compinit
      compinit -u
    fi
    unset brew_prefix
  fi

  if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)

    fzf-cd-widget() {
      local dir
      if command -v fd >/dev/null 2>&1; then
        dir="$(fd --type d --hidden --follow --exclude .git . 2>/dev/null |
          fzf --height=80% --reverse --preview 'ls -la {} | sed -n "1,80p"' --preview-window=right:50%:wrap)"
      else
        dir="$(find . -type d -not -path '*/.git/*' 2>/dev/null |
          fzf --height=80% --reverse --preview 'ls -la {} | sed -n "1,80p"' --preview-window=right:50%:wrap)"
      fi

      if [[ -n "$dir" ]]; then
        cd -- "$dir" || return
        zle reset-prompt
      fi
    }

    zle -N fzf-cd-widget
    bindkey '^G' fzf-cd-widget
  fi

  zmodload zsh/complist
fi

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Machine-specific aliases, tokens, and overrides belong here.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
