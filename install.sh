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

COMPONENTS=(hypr waybar rofi kitty wlogout swaync hyprshot gtk-3.0 gtk-4.0 fastfetch brave-flags.conf)

# Componentes que NO se enlazan: se copian como plantilla editable.
# waypaper reescribe config.ini en cada cambio de fondo desde su GUI, así que
# enlazarlo al repo haría que tus rutas personales acabaran en el repo.
COPY_COMPONENTS=(waypaper)

# Paquetes que queremos. Cada uno se instala por pacman si EXISTE en los repos
# sincronizados; si no (p. ej. wlogout/waypaper en Arch vanilla), va a AUR.
REPO_PKGS=(
  # compositor + shell
  hyprland hypridle hyprlock waybar rofi kitty wlogout swaync
  # apps del look
  hyprshot satty thunar tumbler ffmpegthumbnailer
  hyprpicker hyprsunset wl-clipboard jq imv fastfetch
  swayosd udiskie waypaper polkit-kde-agent mpv pciutils
  # binarios que las configs invocan
  brightnessctl playerctl pavucontrol awww mpvpaper qt5ct
  # servicios/audio que waybar y los binds asumen
  wireplumber pipewire pipewire-pulse upower power-profiles-daemon
  networkmanager iwd bluez
  # fuentes
  ttf-jetbrains-mono-nerd
)

# Siempre AUR (look + UI de red/bt): tema GTK, iconos, cursor e iwgtk/overskride
AUR_PKGS=(
  graphite-gtk-theme
  tela-black-icon-theme
  bibata-cursor-theme-bin
  iwgtk
  overskride
)

# Servicios que la UI del shell asume activos (nunca abortan si fallan)
ENABLE_SERVICES=(bluetooth power-profiles-daemon)

usage() {
  cat <<EOF
Uso: ./install.sh [OPCIÓN]

  (sin opción, terminal)  Menú interactivo  ← por defecto
  (sin opción, sin TTY)   Instala todo (para scripts: curl | bash)
  --menu         Fuerza el menú interactivo
  --dotfiles     Solo backup + symlinks de ~/.config
  --packages     Solo instala paquetes
  --sddm         Solo despliega el tema SDDM pixie
  --gpu          Solo muestra la GPU detectada (sin instalar nada)
  --list         Muestra los paquetes que se instalarían (sin instalar)
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
  local items=() c
  for c in "${COMPONENTS[@]}" "${COPY_COMPONENTS[@]}"; do
    if [ -e "$CONF/$c" ] && [ ! -L "$CONF/$c" ]; then
      items+=("$c")
    fi
  done
  if [ ${#items[@]} -eq 0 ]; then
    info "Configs ya enlazadas o ausentes: nada que respaldar"
    return 0
  fi
  info "Respaldo de configs actuales en $BACKUP"
  mkdir -p "$BACKUP"
  for c in "${items[@]}"; do
    cp -a "$CONF/$c" "$BACKUP/"   # -a: preserva symlinks sin seguirlos
    ok "respaldado $c"
  done
}

link_dotfiles() {
  info "Creando symlinks $CONF/<comp> -> repo"
  mkdir -p "$CONF"
  local c
  for c in "${COMPONENTS[@]}"; do
    if [ -e "$REPO/$c" ]; then
      # Si existe un dir real (configs previas), quítalo: backup_dotfiles lo
      # respaldó justo antes. Así evitamos el bug de symlinks anidados
      # (ln -sfn sobre un dir crea <dir>/<comp> en vez de reemplazarlo).
      if [ -e "$CONF/$c" ] && [ ! -L "$CONF/$c" ]; then
        rm -rf "$CONF/$c"
      fi
      ln -sfn "$REPO/$c" "$CONF/$c"
      ok "link $c"
    else
      warn "no hay $c en el repo, se omite"
    fi
  done

  # Plantillas editables (copia, no enlace): ver COPY_COMPONENTS arriba.
  for c in "${COPY_COMPONENTS[@]}"; do
    if [ -e "$REPO/$c" ]; then
      if [ ! -e "$CONF/$c" ]; then
        mkdir -p "$(dirname "$CONF/$c")"
        cp -r "$REPO/$c" "$CONF/$c"
        ok "copia $c (plantilla editable; ajústala a tu gusto)"
      else
        warn "$c ya existe en $CONF: se respeta tu copia (el repo trae una de ejemplo)"
      fi
    fi
  done

  # Libadwaita (GTK4) ignora settings.ini: el override estándar son estos
  # symlinks al tema instalado (se crean dentro del repo enlazado; el
  # .gitignore los excluye porque son locales).
  local theme="/usr/share/themes/Graphite-Dark/gtk-4.0"
  if [ -d "$CONF/gtk-4.0" ]; then
    if [ -d "$theme" ]; then
      ln -sfn "$theme/gtk.css"      "$CONF/gtk-4.0/gtk.css"
      ln -sfn "$theme/gtk-dark.css" "$CONF/gtk-4.0/gtk-dark.css"
      ln -sfn "$theme/assets"       "$CONF/gtk-4.0/assets"
      ok "override Libadwaita (Graphite-Dark)"
    else
      warn "graphite-gtk-theme no instalado: los apps GTK4 quedan con Adwaita"
    fi
  fi

  # Scripts que las configs invocan por nombre
  mkdir -p "$HOME/.local/bin"
  if [ -f "$REPO/scripts/screenshot.sh" ]; then
    ln -sfn "$REPO/scripts/screenshot.sh" "$HOME/.local/bin/screenshot"
    chmod +x "$REPO/scripts/screenshot.sh"
    ok "link screenshot -> ~/.local/bin/screenshot"
  fi
  if [ -f "$REPO/scripts/brightness-util" ]; then
    ln -sfn "$REPO/scripts/brightness-util" "$HOME/.local/bin/brightness-util"
    chmod +x "$REPO/scripts/brightness-util"
    ok "link brightness-util -> ~/.local/bin/brightness-util"
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

# Partición de paquetes: llena REPO_LIST (pacman) y AUR_LIST.
# Reglas: driver de vídeo según GPU; si pulseaudio ya está instalado se omite
# pipewire-pulse (entran en conflicto); lo que pacman no conoce, a AUR.
partition_pkgs() {
  local gpu va p
  gpu="$(detect_gpu)"
  va="$(gpu_va_pkg "$gpu")"
  local want=("${REPO_PKGS[@]}")
  if [ -n "$va" ]; then want+=("$va"); fi

  REPO_LIST=()
  AUR_LIST=("${AUR_PKGS[@]}")

  if ! command -v pacman >/dev/null 2>&1; then
    REPO_LIST=("${want[@]}")
    return 0
  fi

  for p in "${want[@]}"; do
    if [ "$p" = "pipewire-pulse" ] && pacman -Q pulseaudio >/dev/null 2>&1; then
      warn "pulseaudio instalado: se omite pipewire-pulse (conflicto)"
      continue
    fi
    if pacman -Si "$p" >/dev/null 2>&1; then
      REPO_LIST+=("$p")
    else
      AUR_LIST+=("$p")
    fi
  done
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

# Servicios requeridos por la barra/UI (bluetooth, perfiles de energía).
# Nunca aborta: si hay conflicto (p. ej. tlp) solo avisa.
enable_services() {
  command -v systemctl >/dev/null 2>&1 || return 0
  local svc
  for svc in "${ENABLE_SERVICES[@]}"; do
    if run_priv systemctl enable --now "$svc" >/dev/null 2>&1; then
      ok "servicio activo: $svc"
    else
      warn "no se pudo activar $svc (¿conflicto, p. ej. tlp?). Actívalo a mano si lo necesitas"
    fi
  done
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

  partition_pkgs

  if [ ${#REPO_LIST[@]} -gt 0 ]; then
    info "Instalando (repo): ${REPO_LIST[*]}"
    run_priv pacman -S --needed --noconfirm "${REPO_LIST[@]}"
    ok "paquetes de repo instalados"
  fi

  install_aur "${AUR_LIST[@]}"
  enable_services
}

list_packages() {
  local gpu; gpu="$(detect_gpu)"
  info "GPU detectada: $gpu (driver de vídeo: $(gpu_va_pkg "$gpu") o ninguno)"
  partition_pkgs
  echo
  info "Repo (pacman):"
  printf '  %s\n' "${REPO_LIST[*]}"
  info "AUR (paru/yay):"
  printf '  %s\n' "${AUR_LIST[*]}"
  echo
  info "Servicios que se activarían: ${ENABLE_SERVICES[*]}"
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

show_menu() {
  echo
  echo "Minimalism Shell — instalador"
  echo "  1) Instalar todo (backup + symlinks + paquetes + SDDM)"
  echo "  2) Solo dotfiles (backup + symlinks de ~/.config)"
  echo "  3) Solo paquetes"
  echo "  4) Solo tema SDDM"
  echo "  5) Solo mostrar GPU detectada"
  echo "  6) Ver paquetes que se instalarían"
  echo "  0) Salir"
  while true; do
    printf '> '
    read -r opt || { echo; ok "¡Hasta luego!"; exit 0; }
    case "$opt" in
      1) backup_dotfiles; link_dotfiles; install_packages; install_sddm
         ok "Listo. Reinicia sesión (o el equipo) para ver SDDM." ;;
      2) backup_dotfiles; link_dotfiles ;;
      3) install_packages ;;
      4) install_sddm ;;
      5) info "GPU detectada: $(detect_gpu)" ;;
      6) list_packages ;;
      0|q|Q) ok "¡Hasta luego!"; exit 0 ;;
      *) warn "opción no válida: $opt" ;;
    esac
    echo
  done
}

main() {
  case "${1:-}" in
    --help) usage; exit 0 ;;
    --menu) show_menu ;;
    --dotfiles) backup_dotfiles; link_dotfiles ;;
    --packages) install_packages ;;
    --sddm) install_sddm ;;
    --gpu) info "GPU detectada: $(detect_gpu)" ;;
    --list) list_packages ;;
    "")
      if [ -t 0 ]; then
        show_menu
      else
        # Sin TTY (curl | bash): instalación completa sin menú.
        backup_dotfiles
        link_dotfiles
        install_packages
        install_sddm
        ok "Listo. Reinicia sesión (o el equipo) para ver SDDM."
      fi
      ;;
    *) err "opción desconocida: $1"; usage; exit 1 ;;
  esac
}

main "$@"
