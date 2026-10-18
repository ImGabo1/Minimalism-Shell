#!/usr/bin/env bash
# screenshot.sh — captura unificada hyprshot + satty (Minimalism Shell)
# Ambos modos (región y pantalla completa) pasan por satty para anotar/guardar.
# Uso: screenshot.sh [region|output|window]
# Guarda en ~/Pictures/Screenshots (sobrescribir con SCREENSHOT_DIR).
set -euo pipefail

MODE="${1:-region}"
SAVE_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"
FMT="screenshot-<%Y-%m-%d-%H%M%S>.png"

mkdir -p "$SAVE_DIR"

satty_args=(
  -f -
  -o "$SAVE_DIR/$FMT"
  --actions-on-enter save-to-file
  --early-exit
)

case "$MODE" in
  region) hyprshot -m region --raw -s | satty "${satty_args[@]}" ;;
  output) hyprshot -m output --raw -s | satty "${satty_args[@]}" ;;
  window) hyprshot -m window --raw -s | satty "${satty_args[@]}" ;;
  *)
    echo "Uso: $(basename "$0") [region|output|window]" >&2
    exit 1
    ;;
esac
