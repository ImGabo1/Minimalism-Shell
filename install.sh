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

COMPONENTS=(hypr waybar rofi kitty wlogout swaync hyprshot waypaper gtk-3.0 gtk-4.0)

# Paquetes en repos oficiales (Arch/CachyOS)
REPO_PKGS=(
  hyprland waybar rofi kitty wlogout swaync
  hyprshot satty thunar tumbler ffmpegthumbnailer
  hyprpicker wl-clipboard jq imv
  swayosd udiskie waypaper polkit-kde-agent mpv
  ttf-jetbrains-mono-nerd
)

# Paquetes AUR (se instalan con paru/yay si existe; si no, se listan)
AUR_PKGS=(
  graphite-gtk-theme
  tela-black-icon-theme
  bibata-cursor-theme-bin
)

usage() {
  cat <<EOF
Uso: ./install.sh [OPCIÓN]

  (sin opción)   Instala todo (backup + symlinks + paquetes + SDDM)
  --dotfiles     Solo backup + symlinks de ~/.config
  --packages     Solo instala paquetes (repo)
  --sddm         Solo despliega el tema SDDM pixie
  --gpu          Solo muestra la GPU detectada (sin instalar nada)
  --help         Esta ayuda

Los paquetes AUR (graphite-gtk-theme, tela-black-icon-theme, bibata-cursor-theme-bin)
se instalan solos si tienes paru/yay; si no, te los lista al final.
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

detect_gpu() {
  local out; out="$(lspci 2>/dev/null || true)"
  if   echo "$out" | grep -qi nvidia;        then echo "nvidia"
  elif echo "$out" | grep -qiE 'amd|radeon'; then echo "amd"
  elif echo "$out" | grep -qi intel;         then echo "intel"
  else echo "unknown"
  fi
}

gpu_va_pkg() {
  case "$1" in
    nvidia) echo "libva-nvidia-driver" ;;
    amd)    echo "libva-mesa-driver" ;;
    intel)  echo "intel-media-driver" ;;
    *)      echo "" ;;
  esac
}

install_aur() {
  local pkgs=("$@")
  [ ${#pkgs[@]} -eq 0 ] && return 0
  local helper=""
  command -v paru >/dev/null 2>&1 && helper=paru
  [ -z "$helper" ] && command -v yay >/dev/null 2>&1 && helper=yay
  if [ -n "$helper" ]; then
    info "Instalando AUR con $helper: ${pkgs[*]}"
    "$helper" -S --needed --noconfirm "${pkgs[@]}"
    ok "paquetes AUR instalados"
  else
    warn "Sin paru/yay — instala estos AUR a mano:"
    printf '  %s\n' "${pkgs[@]}"
  fi
}

install_packages() {
  local gpu; gpu="$(detect_gpu)"
  info "GPU detectada: $gpu"

  if command -v pacman >/dev/null 2>&1; then
    local va; va="$(gpu_va_pkg "$gpu")"
    local pkgs=("${REPO_PKGS[@]}")
    local aur=("${AUR_PKGS[@]}")
    # VA-API: nvidia/intel vienen de repo; amd (libva-mesa-driver) es AUR
    if [ -n "$va" ]; then
      if [ "$va" = "libva-mesa-driver" ]; then aur+=("$va"); else pkgs+=("$va"); fi
    fi
    info "Instalando (repo): ${pkgs[*]}"
    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    ok "paquetes de repo instalados"
    install_aur "${aur[@]}"
  elif command -v apt-get >/dev/null 2>&1; then
    warn "Debian/Ubuntu detectado. Este dotfiles está pensado para Arch/CachyOS."
    warn "Los configs de ~/.config funcionan; instala Hyprland + dependencias a mano (ver README)."
  elif command -v dnf >/dev/null 2>&1; then
    warn "Fedora detectado. Este dotfiles está pensado para Arch/CachyOS."
    warn "Los configs de ~/.config funcionan; instala Hyprland + dependencias a mano (ver README)."
  else
    err "gestor de paquetes no reconocido; instala las dependencias a mano"
    return 1
  fi
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
    --gpu) info "GPU detectada: $(detect_gpu)" ;;
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
