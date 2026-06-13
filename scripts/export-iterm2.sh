#!/bin/zsh
set -euo pipefail

repo_dir="${0:A:h:h}"
output="$repo_dir/iterm2/com.googlecode.iterm2.plist"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

defaults export com.googlecode.iterm2 "$tmp"

# Remove machine state, update metadata, window geometry, and recents.
while IFS= read -r key; do
  /usr/libexec/PlistBuddy -c "Delete :'$key'" "$tmp" >/dev/null 2>&1 || true
done < <(
  plutil -p "$tmp" |
    sed -n 's/^  "\([^"]*\)" =>.*/\1/p' |
    grep -E '^(NS|NoSync|SU|iTerm Version$)'
)

# The default profile already starts in the current user's home directory.
/usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':0:'Working Directory'" "$tmp" >/dev/null 2>&1 || true

plutil -convert xml1 "$tmp"
mv "$tmp" "$output"
plutil -lint "$output"
echo "Exported sanitized iTerm2 preferences to $output"
