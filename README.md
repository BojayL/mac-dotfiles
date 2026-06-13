# mac-dotfiles

Portable zsh, Starship, Homebrew, and iTerm2 configuration for macOS.

## Fresh Mac

Run:

```zsh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/BojayL/mac-dotfiles/main/scripts/bootstrap.sh)"
```

The bootstrap script installs Homebrew when needed, clones this repository to
`~/.dotfiles`, installs the packages in `Brewfile`, links the shell files, and
points iTerm2 at the versioned preferences directory.

Restart iTerm2 after installation. Existing dotfiles are preserved with a
timestamped `.bak-*` suffix.

## Included

- `zsh/.zprofile`: portable Homebrew, MacPorts, Python, and mirror setup
- `zsh/.zshrc`: Conda/NVM detection, Starship, completions, fzf, and zoxide
- `config/starship.toml`: prompt theme
- `iterm2/com.googlecode.iterm2.plist`: sanitized iTerm2 preferences and profile
- `Brewfile`: terminal tools, iTerm2, and Nerd Fonts

Shell history, iTerm2 sockets, Keychain credentials, tokens, and machine state
are intentionally excluded. Put machine-only settings and secrets in
`~/.zprofile.local` or `~/.zshrc.local`.

## Update From This Mac

After changing iTerm2 settings, quit iTerm2 and run:

```zsh
~/.dotfiles/scripts/export-iterm2.sh
```

Then review and commit the change. Shell and Starship files are symlinked, so
their edits already appear in the repository.

## Install Without Homebrew Changes

```zsh
git clone https://github.com/BojayL/mac-dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/install.sh
```
