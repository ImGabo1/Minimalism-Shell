<div align="center">

# Minimalism Shell

**Un entorno de escritorio modular y minimalista sobre Hyprland.**

[![Hyprland](https://img.shields.io/badge/Hyprland-0.56-blue?style=flat-square)](https://hyprland.org)
[![CachyOS](https://img.shields.io/badge/CachyOS-Arch-black?style=flat-square)](https://cachyos.org)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/status-Baseline%201.0-orange?style=flat-square)]()

*Identidad visual en escala de grises · TypeScript/AGS en camino*

**Idiomas: [🇬🇧 English](README.md) · 🇪🇸 Español**

</div>

---

## ✨ Características

- **Compositor:** Hyprland (config en Lua, API `hl.*`).
- **Barra:** Waybar con paleta de grises canónica (`palette.css`).
- **Launcher:** Rofi (drun) en grises.
- **Terminal:** Kitty con tema desaturado y copiar/pegar cómodo (seleccionar = copiar, clic central = pegar).
- **Notificaciones:** SwayNC recoloreado a grises (rojo solo en alertas).
- **Capturas:** `hyprshot` + `satty` vía un único comando `screenshot` (Super+P / Print).
- **Fondos:** `waypaper` (Super+Shift+W), restaurado automáticamente al iniciar sesión.
- **Visor de imágenes:** `imv` (ligero, nativo Wayland).
- **Login:** SDDM con tema Pixie en grises y fondo propio.
- **Bloqueo:** `hyprlock` (reloj + blur) con `hypridle` (atenúa → bloquea → apaga pantalla → suspende).
- **Multi-monitor** con regla *fallback* automática.
- **GPU auto-detectada:** NVIDIA / AMD / Intel — el backend de vídeo se aplica solo si la GPU existe (portátil entre equipos).

> **Fase actual — Baseline 1.0:** entorno estático estabilizado y empaquetado como
> dotfiles. Los módulos dinámicos en TypeScript (Topbar, Launcher, Centro de Control)
> con AGS/Astal + GTK4 vienen en una fase siguiente.

## 🖼️ Screenshots

Capturas de muestra en la máquina de referencia (panel interno, 1920×1200@165):

<p align="center">
  <img src="screenshots/Desktop.png" alt="Escritorio" width="840">
</p>

<p align="center">
  <img src="screenshots/waybar.png" alt="Waybar" width="840">
</p>

<p align="center">
  <img src="screenshots/rofi.png" alt="Launcher rofi" width="280">
  <img src="screenshots/SwayNC.png" alt="Notificaciones SwayNC" width="420">
</p>

<p align="center">
  <img src="screenshots/Fastfetch.png" alt="Fastfetch" width="620">
</p>

<p align="center">
  <img src="screenshots/sddm-login.png" alt="Login SDDM" width="410">
  <img src="screenshots/Sddm.png" alt="Tema SDDM" width="410">
</p>

## 💾 Consumo de RAM

El shell entero (compositor + barra), en reposo y sin apps abiertas: **~170 MB**.
Muy ligero: sobre una base de 8 GB deja ~7.8 GB libres. Cada app que abras suma su propia RAM.

## ⌨️ Keybindings

| Atajo | Acción |
|---|---|
| `Super + T` / `Super + Q` | Terminal (kitty) / cerrar ventana |
| `Super + A` / `Super + E` | Launcher (rofi) / explorador (thunar) |
| `Super + W` / `Super + F` | Alternar flotante / alternar pantalla completa |
| `Super + L` / `Super + M` | Bloquear (hyprlock) / cerrar sesión |
| `Super + P` / `Print` | Captura de región / pantalla completa (vía satty) |
| `Super + 1…0` | Ir al workspace 1–10 |
| `Super + Shift + 1…0` | Mover ventana al workspace 1–10 |
| `Super + S` | Alternar scratchpad (workspace especial) |
| `Super + Shift + W` | Gestor de fondos (waypaper) |
| `Super + ←↑↓→` / `Alt + Tab` | Cambiar foco / siguiente ventana |
| `Ctrl + Shift + F1…F4` | Volumen − / + / silenciar / silenciar micrófono |
| `Ctrl + Shift + F5…F8` | Música: anterior / play-pause / siguiente |
| `Super + B / G / C / Y / H` | Brave / Firefox / VSCodium / Spotify / Heroic *(apps opcionales — instala las tuyas)* |

Referencia completa (workspaces relativos, movimientos silenciosos, ratón, clics de waybar…):
[docs/KEYBINDINGS.es.md](docs/KEYBINDINGS.es.md) · [english](docs/KEYBINDINGS.md)

## 📦 Instalación

**Requisitos:** CachyOS/Arch (o cualquier derivo de Arch) con **Hyprland** instalado.

```bash
git clone https://github.com/ImGabo1/Minimalism-Shell.git ~/minimalism-shell
cd ~/minimalism-shell
./install.sh          # menú interactivo
```

Ejecutado en una terminal muestra el menú (instalar todo, solo dotfiles, solo
paquetes, solo SDDM, ver GPU o previsualizar la lista de paquetes). Las flags
siguen funcionando para scripts (`./install.sh` sin TTY instala todo):

```bash
./install.sh --menu     # fuerza el menú interactivo
./install.sh --dotfiles # solo symlinks de ~/.config (+ backup previo)
./install.sh --packages # solo paquetes
./install.sh --sddm     # solo despliega el tema SDDM
./install.sh --gpu      # solo muestra la GPU detectada
./install.sh --list     # previsualiza los paquetes que se instalarían
```

- Las configs existentes se **respaldan** en `~/.config/backup-dotfiles-<fecha>` antes de enlazar.
- Los directorios reales de `~/.config` se reemplazan por symlinks al repo (así
  no quedan links anidados y el repo pasa a ser la única fuente de verdad).
- `install.sh` **detecta tu GPU** e instala el backend de vídeo correspondiente.
- **Brave/Chromium en NVIDIA**: sin `brave-flags.conf` el vídeo se queda en una imagen fija (fallos de EGLImage al presentar frames VAAPI). El repo lo incluye ya resuelto.
- Los paquetes **AUR** (`graphite-gtk-theme`, `tela-black-icon-theme`, `bibata-cursor-theme-bin`, `iwgtk`, `overskride`) se instalan con tu helper (`paru`/`yay`); `install.sh` lo hace solo si lo tienes.
- `install.sh` **particiona solo**: lo que existe en tus repos va con `pacman`, lo que no (p. ej. `wlogout`/`waypaper` en Arch vanilla) va a AUR. Nunca aborta por un paquete que falte.
- También **enlaza los scripts auxiliares** (`screenshot`, `brightness-util`) en `~/.local/bin` y crea los **overrides de Libadwaita** (apps GTK4) apuntando al tema Graphite-Dark instalado.
- Activa los servicios que usa la barra cuando es posible: `bluetooth`, `power-profiles-daemon` (se omiten con aviso si, p. ej., usas `tlp`).
- El tema SDDM surte efecto en el **próximo login**.
- **Fondos:** `waypaper` trae una ruta de ejemplo y se instala como **copia
  editable** (no symlink), ya que su interfaz reescribe el archivo — configura
  tu propia carpeta en `waypaper/config.ini` (`folder = ...`) o simplemente elige
  un fondo desde su interfaz (Super+Shift+W). El fondo del bloqueo cae a una
  captura del escritorio hasta que ajustes `hypr/hyprlock.conf` a tu wallpaper.

### 📋 Instalación manual (lista completa de paquetes)

Todo validado en **CachyOS/Arch**. Si prefieres instalarlo tú mismo:

**Repositorios oficiales:**
```bash
sudo pacman -S hyprland hypridle hyprlock waybar rofi kitty wlogout swaync \
  hyprshot satty thunar tumbler ffmpegthumbnailer hyprpicker hyprsunset \
  wl-clipboard jq imv fastfetch swayosd udiskie waypaper polkit-kde-agent \
  mpv pciutils brightnessctl playerctl pavucontrol awww mpvpaper qt5ct \
  wireplumber pipewire pipewire-pulse upower power-profiles-daemon \
  networkmanager iwd bluez ttf-jetbrains-mono-nerd
```

**Driver de vídeo (elige el de tu GPU):**
```bash
sudo pacman -S libva-nvidia-driver   # NVIDIA
sudo pacman -S intel-media-driver    # Intel
# AMD → libva-mesa-driver (está en AUR, ver abajo)
```

**AUR** (necesitas `paru` o `yay`) — look, botones de red/bt, `wlogout` y `waypaper`:
```bash
paru -S graphite-gtk-theme tela-black-icon-theme bibata-cursor-theme-bin
paru -S iwgtk overskride
paru -S wlogout waypaper       # solo en Arch vanilla (en CachyOS están en repo)
paru -S libva-mesa-driver      # solo si tu GPU es AMD
```

**Servicios:**
```bash
sudo systemctl enable --now bluetooth power-profiles-daemon
```

> En **CachyOS**, `wlogout`/`waypaper` también están en los repos (`pacman -S`).
> El botón de Wi-Fi abre **iwgtk** (frontend de iwd): la configuración de
> referencia corre **iwd + NetworkManager**; si no ejecutas iwd, ese botón no
> mostrará adaptador (re-bíndalo en `waybar/config.jsonc` si prefieres otra herramienta).
> ¿Sigues en **pulseaudio**? Entonces omite `pipewire-pulse` (entran en conflicto);
> `install.sh` ya lo detecta.

### ¿Sirve en cualquier distro?

Los **configs** (`~/.config/...`) funcionan en cualquier distro con Hyprland + Wayland.
El `install.sh` está pensado para **Arch/CachyOS** (`pacman`): en Debian/Fedora detecta el
gestor, no rompe, e imprime la lista de paquetes para instalarlos a mano. GPU y detección
funcionan en todas.

## 🗂️ Estructura

```
Minimalism-Shell/
├── install.sh          # instalador (menú interactivo + flags)
├── hypr/               # Hyprland (hyprland.lua, hypridle, hyprlock)
├── waybar/             # barra (config.jsonc, palette.css, style.css)
├── rofi/               # launcher (config.rasi, theme.rasi)
├── kitty/              # terminal (kitty.conf, colors.conf)
├── wlogout/            # pantalla de salida (style.css, layout, icons)
├── swaync/             # notificaciones (colors.css, config.json, mpris.css)
├── hyprshot/           # configuración de capturas
├── waypaper/           # gestor de fondos (config.ini)
├── fastfetch/          # fastfetch (config.jsonc + logo ASCII)
├── gtk-3.0/ gtk-4.0/   # theming GTK (Graphite-Dark + overrides Libadwaita)
├── brave-flags.conf    # fix vídeo congelado de Brave en NVIDIA+Wayland
├── sddm/pixie/         # tema de login (grises + fondo)
├── scripts/            # screenshot.sh, brightness-util
├── screenshots/        # galería usada en este README
└── docs/               # KEYBINDINGS.es.md (+ .md)
```

## 🎨 Paleta

Identidad en **escala de grises**, derivada de Catppuccin Mocha con los acentos de
color eliminados y los grises afinados. La fuente de verdad es
[`waybar/palette.css`](waybar/palette.css); los demás componentes se unifican a ella.

## 🙏 Créditos

- **Haishi** — inspiración principal (SwayNC y estética).
- **[HyDE](https://github.com/hyprdot/HyDE)** — enfoque de dotfiles y estructura.
- **Celestia** — inspiración de diseño.
- **Pixie SDDM** — tema de login base.
- **[Catppuccin](https://catppuccin.com)** — paleta de la que deriva la escala de grises.
