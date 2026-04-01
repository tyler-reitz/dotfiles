#!/usr/bin/env bash

set -euo pipefail

CURRENT_WALLPAPER="$HOME/.config/theme/current-wallpaper"
DEFAULT_WALLPAPER="/home/me/Downloads/Wallpapers/1772327806148247.jpg"
WALLPAPER="$DEFAULT_WALLPAPER"
RENDER_DIR="$HOME/.cache/theme"
RENDERED_WALLPAPER="$RENDER_DIR/wallpaper-rendered.png"
WAL_DIR="$HOME/.cache/wal"
MODE="${1-apply}"

if [ -L "$CURRENT_WALLPAPER" ] || [ -f "$CURRENT_WALLPAPER" ]; then
  WALLPAPER="$(readlink -f "$CURRENT_WALLPAPER")"
fi

mkdir -p "$RENDER_DIR"

if [ "$MODE" = "regenerate" ]; then
  # Dim the left side a bit so window-heavy areas are easier on the eyes.
  magick "$WALLPAPER" \
    \( -clone 0 -fill "rgba(0,0,0,0.22)" -draw "rectangle 0,0 35%,100%" \) \
    -compose over -composite \
    "$RENDERED_WALLPAPER"

  wal -q -i "$RENDERED_WALLPAPER"
fi

export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS-}"
export LS_COLORS="${LS_COLORS-}"

# shellcheck disable=SC1090
if [ ! -f "$WAL_DIR/colors.sh" ]; then
  wal -q -i "$RENDERED_WALLPAPER"
fi

source "$WAL_DIR/colors.sh"

printf '%s\n' \
  '[color]' \
  "background = ${background}" \
  "background-alt = ${color8}" \
  "foreground = ${foreground}" \
  "primary = ${color4}" \
  "secondary = ${color6}" \
  "alert = ${color1}" \
  "disabled = ${color8}" \
  > "$WAL_DIR/colors-polybar.ini"

printf '%s\n' \
  '[colors.primary]' \
  "background = \"${background}\"" \
  "foreground = \"${foreground}\"" \
  '' \
  '[colors.cursor]' \
  "text = \"${background}\"" \
  "cursor = \"${foreground}\"" \
  '' \
  '[colors.selection]' \
  "text = \"${background}\"" \
  "background = \"${color4}\"" \
  '' \
  '[colors.normal]' \
  "black = \"${color0}\"" \
  "red = \"${color1}\"" \
  "green = \"${color2}\"" \
  "yellow = \"${color3}\"" \
  "blue = \"${color4}\"" \
  "magenta = \"${color5}\"" \
  "cyan = \"${color6}\"" \
  "white = \"${color7}\"" \
  '' \
  '[colors.bright]' \
  "black = \"${color8}\"" \
  "red = \"${color9}\"" \
  "green = \"${color10}\"" \
  "yellow = \"${color11}\"" \
  "blue = \"${color12}\"" \
  "magenta = \"${color13}\"" \
  "cyan = \"${color14}\"" \
  "white = \"${color15}\"" \
  > "$WAL_DIR/colors-alacritty.toml"

if command -v xrdb >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  xrdb -merge "$WAL_DIR/colors.Xresources" || true
fi

if command -v feh >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  feh --bg-fill "$RENDERED_WALLPAPER" || true
fi

if command -v polybar-msg >/dev/null 2>&1; then
  polybar-msg cmd restart >/dev/null 2>&1 || true
fi
