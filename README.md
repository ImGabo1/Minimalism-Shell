<div align="center">

# Minimalism Shell

**Un entorno de escritorio modular y minimalista sobre Hyprland.**

[![Hyprland](https://img.shields.io/badge/Hyprland-0.56-blue?style=flat-square)](https://hyprland.org)
[![CachyOS](https://img.shields.io/badge/CachyOS-Arch-black?style=flat-square)](https://cachyos.org)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/status-Baseline%201.0-orange?style=flat-square)]()

*Identidad visual en escala de grises · TypeScript/AGS en camino*

</div>

---

## ✨ Características

- **Compositor:** Hyprland (config en Lua, API `hl.*`).
- **Barra:** Waybar con paleta de grises canónica (`palette.css`).
- **Launcher:** Rofi (drun) en grises.
- **Terminal:** Kitty con tema desaturado y copiar/pegar cómodo (seleccionar = copiar, clic central = pegar).
- **Notificaciones:** SwayNC recoloreado a grises (rojo solo en alertas).
- **Capturas:** `hyprshot` + `satty` vía un único comando `screenshot`.
- **Visor de imágenes:** `imv` (ligero, nativo Wayland).
- **Login:** SDDM con tema Pixie en grises y fondo propio.
- **Multi-monitor** con regla *fallback* automática.
- **GPU auto-detectada:** NVIDIA / AMD / Intel — el backend de vídeo se aplica solo si la GPU existe (portátil entre equipos).

> **Fase actual — Baseline 1.0:** entorno estático estabilizado y empaquetado como
> dotfiles. Los módulos dinámicos en TypeScript (Topbar, Launcher, Centro de Control)
> con AGS/Astal + GTK4 vienen en una fase siguiente.

## 🖼️ Screenshots

> Añade aquí tus capturas en `docs/screenshots/`.

| Login (SDDM) | Escritorio |
|---|---|
| _(pendiente)_ | _(pendiente)_ |

## 💾 Consumo de RAM

El shell entero (compositor + barra), en reposo y sin apps abiertas: **~170 MB**.
Muy ligero: sobre una base de 8 GB deja ~7.8 GB libres. Cada app que abras suma su propia RAM.

## 📦 Instalación

**Requisitos:** CachyOS/Arch (o cualquier derivo de Arch) con **Hyprland** instalado.

```bash
git clone https://github.com/ImGabo1/Minimalism-Shell.git ~/minimalism-shell
cd ~/minimalism-shell
./install.sh
```

Opciones individuales:

```bash
./install.sh --dotfiles   # solo symlinks de ~/.config (+ backup previo)
./install.sh --packages   # solo paquetes del repo
./install.sh --sddm       # solo despliega el tema SDDM
./install.sh --gpu        # solo muestra la GPU detectada
```

- Las configs existentes se **respaldan** en `~/.config/backup-dotfiles-<fecha>` antes de enlazar.
- `install.sh` **detecta tu GPU** e instala el backend de vídeo correspondiente.
- Los paquetes **AUR** (`satty`, `waybar-git`, …) instálalos con tu helper (`paru`/`yay`).
- El tema SDDM surte efecto en el **próximo login**.

### ¿Sirve en cualquier distro?

Los **configs** (`~/.config/...`) funcionan en cualquier distro con Hyprland + Wayland.
El `install.sh` está pensado para **Arch/CachyOS** (`pacman`): en Debian/Fedora detecta el
gestor, no rompe, e imprime la lista de paquetes para instalarlos a mano. GPU y detección
funcionan en todas.

## 🗂️ Estructura

```
Minimalism-Shell/
├── install.sh          # instalador (backup + symlinks + paquetes + SDDM + GPU)
├── hypr/               # Hyprland (hyprland.lua, hypridle, hyprlock)
├── waybar/             # barra (config.jsonc, palette.css, style.css)
├── rofi/               # launcher (config.rasi, theme.rasi)
├── kitty/              # terminal (kitty.conf, colors.conf)
├── wlogout/            # pantalla de salida (style.css, layout, icons)
├── swaync/             # notificaciones (colors.css, config.json, mpris.css)
├── hyprshot/           # configuración de capturas
├── sddm/pixie/         # tema de login (grises + fondo)
├── scripts/            # screenshot.sh (hyprshot + satty)
└── docs/               # VARIABLES-ENTORNO.md
```

## 🎨 Paleta

Identidad en **escala de grises**, derivada de Catppuccin Mocha pero con los acentos de
color eliminados y los grises afinados. La fuente de verdad es
[`waybar/palette.css`](waybar/palette.css); los demás componentes se unifican a ella.

## 🙏 Créditos

- **Haishi** — inspiración principal (SwayNC y estética).
- **[HyDE](https://github.com/hyprdot/HyDE)** — enfoque de dotfiles y estructura.
- **Celestia** — inspiración de diseño.
- **Pixie SDDM** — tema de login base.
- **[Catppuccin](https://catppuccin.com)** — paleta de la que deriva la escala de grises.
