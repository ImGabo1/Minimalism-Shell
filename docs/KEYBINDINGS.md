# Keybindings

Full reference of the default keybindings in [`hypr/hyprland.lua`](../hypr/hyprland.lua)
plus the Waybar mouse/click actions. The **Super** key is the main modifier (`mainMod`).

Legend: **[locked]** = works on the lock screen · **[repeat]** = repeats while held.

## Applications

| Shortcut | Action |
|---|---|
| `Super + T` | Terminal — kitty |
| `Super + Q` | Close focused window |
| `Super + A` | App launcher — rofi (drun) |
| `Super + E` | File manager — thunar |
| `Super + W` | Toggle floating on focused window |
| `Super + F` | Toggle fullscreen |
| `Super + L` | Lock screen — hyprlock |
| `Super + M` | Log out (`hyprshutdown` if installed, otherwise Hyprland exit) |
| `Super + P` | Screenshot of a region → satty (annotate/save) |
| `Print` | Screenshot of the full output → satty |
| `Super + B` | Brave *(optional app)* |
| `Super + G` | Firefox *(optional app)* |
| `Super + C` | VSCodium *(optional app)* |
| `Super + Y` | Spotify *(optional app)* |
| `Super + H` | Heroic *(optional app)* |
| `Super + Shift + W` | Wallpaper manager — waypaper |

## Workspaces

| Shortcut | Action |
|---|---|
| `Super + 1…9`, `Super + 0` | Focus workspace 1–10 (`0` = workspace 10) |
| `Super + Shift + 1…9/0` | Move focused window to workspace 1–10 |
| `Super + Alt + 1…9/0` | Move window to workspace 1–10 **without following it** |
| `Super + Ctrl + → / ←` | Relative workspace: next / previous |
| `Super + Ctrl + scroll ↑ / ↓` | Relative workspace: previous / next |
| `Super + Ctrl + ↓` | Nearest **empty** workspace |
| `Super + scroll ↓ / ↑` | Next / previous **existing** workspace |
| `Super + Ctrl + Alt + → / ←` | Move window to next / previous relative workspace |
| `Super + S` | Toggle the scratchpad (special workspace) |
| `Super + Shift + S` | Move window into the scratchpad |
| `Super + Alt + S` | Move window into the scratchpad **without following it** |

## Window focus & layout

| Shortcut | Action |
|---|---|
| `Super + ← / → / ↑ / ↓` | Focus window in that direction |
| `Alt + Tab` | Focus the next window |
| `Super + left drag` | Move window |
| `Super + right drag` | Resize window |

Windows are tiled (dwindle layout) with 2 px borders and 2 px inner gaps;
floating rules (dialogs, PiP, calculators, etc.) are defined in `hyprland.lua`.

## Media & brightness

All of these work from the lock screen where marked **[locked]**.

| Shortcut | Action |
|---|---|
| `Ctrl + Shift + F1` **[locked] [repeat]** | Volume down 5% |
| `Ctrl + Shift + F4` **[locked] [repeat]** | Volume up 5% |
| `Ctrl + Shift + F2` **[locked]** | Toggle mute (speakers/headphones) |
| `Ctrl + Shift + F3` **[locked]** | Toggle microphone mute |
| `Ctrl + Shift + F5` **[locked]** | Previous track |
| `Ctrl + Shift + F6` **[locked]** | Play / pause |
| `Ctrl + Shift + F7` **[locked]** | Stop |
| `Ctrl + Shift + F8` **[locked]** | Next track |
| `XF86AudioRaiseVolume` **[repeat]** | Volume up 5% (+ on-screen indicator) |
| `XF86AudioLowerVolume` **[repeat]** | Volume down 5% (+ on-screen indicator) |
| `XF86AudioMute` | Toggle mute (+ on-screen indicator) |
| `XF86AudioPlay` / `Next` / `Prev` / `Stop` | Media transport |
| `XF86MonBrightnessUp` / `Down` | Backlight +10% / −10% (+ on-screen indicator) |

## Waybar (mouse)

| Where | Action |
|---|---|
| Menu icon (center) | Open rofi |
| `+` (next to workspaces) | Jump to the next workspace |
| Volume icon | Mute / unmute output · **right-click** → pavucontrol |
| Microphone icon | Mute / unmute input · **right-click** → pavucontrol |
| Brightness icon | Toggle `hyprsunset` (night light) · **scroll** → brightness ±10% |
| Bluetooth icon | Open **overskride** |
| Network icon | Open **iwgtk** (iwd) |
| Battery / power-profiles | Informational (tooltip) |
| Power icon | Open wlogout (logout / reboot / shutdown / suspend / lock) |
| Bell icon | Toggle the SwayNC notification panel |
| Clock | Tooltip with the full date |

## Notes

- **Optional apps:** `Super + B/G/C/Y/H` launch Brave, Firefox, VSCodium, Spotify
  and Heroic — install whichever you use (or edit the variables at the top of
  `hypr/hyprland.lua` to point at your own programs).
- Everything lives in [`hypr/hyprland.lua`](../hypr/hyprland.lua); after editing it
  run `hyprctl reload`.
- `waypaper` restores your last wallpaper at login (`hl.exec_cmd("waypaper --restore")`).
  Set your own folder in `waypaper/config.ini` (`folder = ...`).
- Screenshots are saved to `~/Pictures/Screenshots` (override with `$SCREENSHOT_DIR`).
