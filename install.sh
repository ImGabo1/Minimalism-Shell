#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$HOME/.config"
STAMP="$(date +%Y-%m-%d-%H%M%S)"
BACKUP="$CONF/backup-dotfiles-$STAMP"

G='\033[0;32m'; B='\033[0;34m'; Y='\033[0;33m'; R='\033[0;31m'; N='\033[0m'
ok()   { echo -e "${G}==>${N} $*"; }
info() { echo -e "${B}==>${N} $*"; }
warn() { echo -e "${Y}==>${N} $*"; }
err()  { echo -e "${R}ERROR:${N} $*" >&2; }

COMPONENTS=(hypr waybar rofi kitty wlogout swaync hyprshot)

REPO_PKGS=(
  hyprland waybar rofi-wayland kitty wlogout swaync
  hyprshot satty thunar tumbler ffmpegthumbnailer
  hyprpicker wl-clipboard jq
)

usage() {
  cat <<EOF
Uso: ./install.sh [OPCIÓN]

  (sin opción)   Instala todo (backup + symlinks + paquetes + SDDM)
  --dotfiles     Solo backup + symlinks de ~/.config
  --packages     Solo instala paquetes (repo)
  --sddm         Solo despliega el tema SDDM pixie
  --help         Esta ayuda

Los paquetes AUR (satty, waybar-git, etc.) instálalos con tu helper (paru/yay).
EOF
}

backup_dotfiles() {
  info "Respaldo de configs actuales en $BACKUP"
  mkdir -p "$BACKUP"
  for c in "${COMPONENTS[@]}"; do
    if [ -e "$CONF/$c" ] && [ ! -L "$CONF/$c" ]; then
      cp -r "$CONF/$c" "$BACKUP/"
      ok "respaldado $c"
    fi
  done
}

link_dotfiles() {
  info "Creando symlinks $CONF/<comp> -> repo"
  mkdir -p "$CONF"
  for c in "${COMPONENTS[@]}"; do
    if [ -d "$REPO/$c" ]; then
      ln -sfn "$REPO/$c" "$CONF/$c"
      ok "link $c"
    else
      warn "no hay dir $c en el repo, se omite"
    fi
  done

  if [ -f "$REPO/scripts/screenshot.sh" ]; then
    mkdir -p "$HOME/.local/bin"
    ln -sfn "$REPO/scripts/screenshot.sh" "$HOME/.local/bin/screenshot"
    chmod +x "$REPO/scripts/screenshot.sh"
    ok "link screenshot -> ~/.local/bin/screenshot"
  fi
}

install_packages() {
  info "Instalando paquetes del repo"
  if ! command -v pacman >/dev/null 2>&1; then
    err "pacman no encontrado; instala los paquetes a mano"; return 1
  fi
  sudo pacman -S --needed --noconfirm "${REPO_PKGS[@]}"
  ok "paquetes instalados"
  warn "Recuerda los AUR: satty, waybar-git (si usas la versión -git)"
}

install_sddm() {
  local src="$REPO/sddm/pixie"
  local dst="/usr/share/sddm/themes/pixie"
  if [ ! -d "$src" ]; then
    err "no hay tema en $src"; return 1
  fi
  info "Desplegando tema SDDM pixie a $dst"
  sudo mkdir -p "$dst"
  sudo cp -r "$src/." "$dst/"
  sudo mkdir -p /etc/sddm.conf.d
  printf '[Theme]\nCurrent=pixie\n' | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
  ok "SDDM pixie desplegado (surtira efecto en el proximo login)"
}

main() {
  case "${1:-}" in
    --help) usage; exit 0 ;;
    --dotfiles) backup_dotfiles; link_dotfiles ;;
    --packages) install_packages ;;
    --sddm) install_sddm ;;
    "")
      backup_dotfiles
      link_dotfiles
      install_packages
      install_sddm
      ok "Listo. Reinicia sesión (o el equipo) para ver SDDM."
      ;;
    *) err "opción desconocida: $1"; usage; exit 1 ;;
  esac
}

main "$@"
