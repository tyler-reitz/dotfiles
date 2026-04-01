#!/usr/bin/env bash

set -euo pipefail

if [ "${1-}" = "" ]; then
  echo "usage: set-wallpaper.sh /path/to/image"
  exit 1
fi

SOURCE="$(readlink -f "$1")"
CURRENT_WALLPAPER="$HOME/.config/theme/current-wallpaper"

if [ ! -f "$SOURCE" ]; then
  echo "wallpaper not found: $SOURCE" >&2
  exit 1
fi

mkdir -p "$(dirname "$CURRENT_WALLPAPER")"
ln -sfn "$SOURCE" "$CURRENT_WALLPAPER"

"$HOME/.config/theme/apply-theme.sh" regenerate
