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

# Paquetes que queremos. Cada uno se instala por pacman si EXISTE en los repos
# sincronizados; si no (p. ej. wlogout/waypaper en Arch vanilla), va a AUR.
REPO_PKGS=(
  hyprland waybar rofi kitty wlogout swaync
  hyprshot satty thunar tumbler ffmpegthumbnailer
  hyprpicker wl-clipboard jq imv
  swayosd udiskie waypaper polkit-kde-agent mpv pciutils
  ttf-jetbrains-mono-nerd
)

# Siempre AUR (look): tema GTK, iconos y cursor
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
  --packages     Solo instala paquetes
  --sddm         Solo despliega el tema SDDM pixie
  --gpu          Solo muestra la GPU detectada (sin instalar nada)
  --help         Esta ayuda

Los paquetes AUR se instalan con paru/yay si lo tienes; si no, te los lista.
EOF
}

# Ejecuta con privilegios: root directo, o sudo si existe. Si no, error claro.
run_priv() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    err "Se necesita root para esto. Ejecuta como root o instala 'sudo'."
    return 1
  fi
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

# Detección de GPU. Usa lspci si existe; si no, lee vendor IDs de sysfs
# (0x10de NVIDIA, 0x1002 AMD, 0x8086 Intel) — funciona sin pciutils.
detect_gpu() {
  if command -v lspci >/dev/null 2>&1; then
    local out; out="$(lspci 2>/dev/null || true)"
    if echo "$out" | grep -qi nvidia; then echo "nvidia"
    elif echo "$out" | grep -qiE 'amd|radeon'; then echo "amd"
    elif echo "$out" | grep -qi intel; then echo "intel"
    else echo "unknown"
    fi
  else
    local v; v="$(cat /sys/bus/pci/devices/*/vendor 2>/dev/null | sort -u)"
    if echo "$v" | grep -qi '0x10de'; then echo "nvidia"
    elif echo "$v" | grep -qi '0x1002'; then echo "amd"
    elif echo "$v" | grep -qi '0x8086'; then echo "intel"
    else echo "unknown"
    fi
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

# Instala paquetes AUR si hay helper; si no (o si falla), solo avisa. Nunca aborta.
install_aur() {
  local pkgs=("$@")
  if [ ${#pkgs[@]} -eq 0 ]; then return 0; fi
  local helper=""
  if command -v paru >/dev/null 2>&1; then helper=paru
  elif command -v yay >/dev/null 2>&1; then helper=yay
  fi
  if [ -n "$helper" ]; then
    info "Instalando AUR con $helper: ${pkgs[*]}"
    if "$helper" -S --needed --noconfirm "${pkgs[@]}"; then
      ok "paquetes AUR instalados"
    else
      warn "Algunos AUR fallaron; instálalos a mano: ${pkgs[*]}"
    fi
  else
    warn "Sin paru/yay no se pueden instalar los AUR. Hazlo a mano:"
    printf '  %s\n' "${pkgs[*]}"
    info "Primero instala un helper:  paru (AUR)  |  yay (AUR)"
  fi
}

install_packages() {
  local gpu; gpu="$(detect_gpu)"
  info "GPU detectada: $gpu"

  if ! command -v pacman >/dev/null 2>&1; then
    warn "No se detectó pacman (Arch/CachyOS). Este dotfiles está pensado para Arch."
    warn "Los configs de ~/.config funcionan en cualquier distro con Hyprland;"
    warn "instala los paquetes a mano siguiendo la sección 'Instalación manual' del README."
    return 0
  fi

  local va; va="$(gpu_va_pkg "$gpu")"
  local want=("${REPO_PKGS[@]}")
  if [ -n "$va" ]; then want+=("$va"); fi

  # Partición: lo que existe en los repos va por pacman; lo que no, a AUR.
  local repo_list=()
  local aur_list=("${AUR_PKGS[@]}")
  local p
  for p in "${want[@]}"; do
    if pacman -Si "$p" >/dev/null 2>&1; then
      repo_list+=("$p")
    else
      aur_list+=("$p")
    fi
  done

  if [ ${#repo_list[@]} -gt 0 ]; then
    info "Instalando (repo): ${repo_list[*]}"
    run_priv pacman -S --needed --noconfirm "${repo_list[@]}"
    ok "paquetes de repo instalados"
  fi

  install_aur "${aur_list[@]}"
}

install_sddm() {
  local src="$REPO/sddm/pixie"
  local dst="/usr/share/sddm/themes/pixie"
  if [ ! -d "$src" ]; then
    err "no hay tema en $src"; return 1
  fi
  info "Desplegando tema SDDM pixie a $dst"
  run_priv mkdir -p "$dst"
  run_priv cp -r "$src/." "$dst/"
  run_priv mkdir -p /etc/sddm.conf.d
  printf '[Theme]\nCurrent=pixie\n' | run_priv tee /etc/sddm.conf.d/theme.conf >/dev/null
  ok "SDDM pixie desplegado (surtirá efecto en el próximo login)"
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
