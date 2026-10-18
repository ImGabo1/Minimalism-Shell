<div align="center">

# Minimalism Shell

**A minimal, modular desktop environment built on Hyprland.**

[![Hyprland](https://img.shields.io/badge/Hyprland-0.56-blue?style=flat-square)](https://hyprland.org)
[![CachyOS](https://img.shields.io/badge/CachyOS-Arch-black?style=flat-square)](https://cachyos.org)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/status-Baseline%201.0-orange?style=flat-square)]()

*Greyscale visual identity · TypeScript/AGS coming soon*

**Languages: [🇪🇸 Español](README.md) · 🇬🇧 English**

</div>

---

## ✨ Features

- **Compositor:** Hyprland (Lua config, `hl.*` API).
- **Bar:** Waybar with the canonical greyscale palette (`palette.css`).
- **Launcher:** Rofi (drun) in greys.
- **Terminal:** Kitty with a desaturated theme and easy copy/paste (select = copy, middle-click = paste).
- **Notifications:** SwayNC recoloured to greys (red only for alerts).
- **Screenshots:** `hyprshot` + `satty` through a single `screenshot` command.
- **Image viewer:** `imv` (lightweight, Wayland-native).
- **Login:** SDDM with a greyscale Pixie theme and its own background.
- **Multi-monitor** with an automatic *fallback* rule.
- **Auto-detected GPU:** NVIDIA / AMD / Intel — the video backend is only applied when that GPU is present (portable across machines).

> **Current phase — Baseline 1.0:** the static environment stabilised and packaged as
> dotfiles. The dynamic TypeScript modules (Topbar, Launcher, Control Center) with
> AGS/Astal + GTK4 come in a later phase.

## 🖼️ Screenshots

> Add your captures in `docs/screenshots/`.

| Login (SDDM) | Desktop |
|---|---|
| _(pending)_ | _(pending)_ |

## 💾 RAM usage

The whole shell (compositor + bar), idle with no apps open: **~170 MB**.
Very light: on an 8 GB base it leaves ~7.8 GB free. Each app you open adds its own RAM.

## 📦 Installation

**Requirements:** CachyOS/Arch (or any Arch derivative) with **Hyprland** installed.

```bash
git clone https://github.com/ImGabo1/Minimalism-Shell.git ~/minimalism-shell
cd ~/minimalism-shell
./install.sh
```

Individual options:

```bash
./install.sh --dotfiles   # only symlinks for ~/.config (+ prior backup)
./install.sh --packages   # only the repo packages
./install.sh --sddm       # only deploy the SDDM theme
./install.sh --gpu        # only show the detected GPU
```

- Existing configs are **backed up** to `~/.config/backup-dotfiles-<date>` before linking.
- `install.sh` **detects your GPU** and installs the matching video backend.
- **AUR** packages (`graphite-gtk-theme`, `tela-black-icon-theme`, `bibata-cursor-theme-bin`) are installed with your helper (`paru`/`yay`); `install.sh` does it automatically if you have one.
- The SDDM theme takes effect on your **next login**.

### 📋 Manual installation (full package list)

Everything validated on **CachyOS/Arch**. If you prefer to install it yourself:

**Official repositories:**
```bash
sudo pacman -S hyprland waybar rofi kitty wlogout swaync hyprshot satty \
  thunar tumbler ffmpegthumbnailer hyprpicker wl-clipboard jq imv \
  swayosd udiskie waypaper polkit-kde-agent mpv ttf-jetbrains-mono-nerd
```

**Video driver (pick yours):**
```bash
sudo pacman -S libva-nvidia-driver   # NVIDIA
sudo pacman -S intel-media-driver    # Intel
# AMD → libva-mesa-driver (in the AUR, see below)
```

**AUR** (requires `paru` or `yay`) — the look's theme, icons and cursor:
```bash
paru -S graphite-gtk-theme tela-black-icon-theme bibata-cursor-theme-bin
paru -S libva-mesa-driver   # only if your GPU is AMD
```

> `waybar` and `satty` come from the official repos; `waybar-git`/`satty-git` are optional AUR alternatives.

### Does it work on any distro?

The **configs** (`~/.config/...`) work on any distro with Hyprland + Wayland.
`install.sh` targets **Arch/CachyOS** (`pacman`): on Debian/Fedora it detects the
package manager, doesn't break, and prints the package list so you can install them
manually. GPU detection works everywhere.

## 🗂️ Structure

```
Minimalism-Shell/
├── install.sh          # installer (backup + symlinks + packages + SDDM + GPU)
├── hypr/               # Hyprland (hyprland.lua, hypridle, hyprlock)
├── waybar/             # bar (config.jsonc, palette.css, style.css)
├── rofi/               # launcher (config.rasi, theme.rasi)
├── kitty/              # terminal (kitty.conf, colors.conf)
├── wlogout/            # logout screen (style.css, layout, icons)
├── swaync/             # notifications (colors.css, config.json, mpris.css)
├── hyprshot/           # screenshot config
├── waypaper/           # wallpaper manager (config.ini)
├── gtk-3.0/ gtk-4.0/   # GTK theming (selects the Graphite-Dark theme)
├── sddm/pixie/         # login theme (greys + background)
├── scripts/            # screenshot.sh (hyprshot + satty)
└── docs/               # VARIABLES-ENTORNO.md
```

## 🎨 Palette

A **greyscale** identity, derived from Catppuccin Mocha with the colour accents
removed and the greys fine-tuned. The source of truth is
[`waybar/palette.css`](waybar/palette.css); every other component aligns to it.

## 🙏 Credits

- **Haishi** — main inspiration (SwayNC and aesthetics).
- **[HyDE](https://github.com/hyprdot/HyDE)** — dotfiles approach and structure.
- **Celestia** — design inspiration.
- **Pixie SDDM** — base login theme.
- **[Catppuccin](https://catppuccin.com)** — palette the greyscale derives from.
