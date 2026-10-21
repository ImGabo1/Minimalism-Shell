# Keybindings

Referencia completa de los atajos por defecto en [`hypr/hyprland.lua`](../hypr/hyprland.lua)
más las acciones de ratón/clic de Waybar. La tecla **Super** es el modificador
principal (`mainMod`).

Leyenda: **[locked]** = funciona en la pantalla de bloqueo · **[repeat]** = se
repite al mantener pulsado.

## Aplicaciones

| Atajo | Acción |
|---|---|
| `Super + T` | Terminal — kitty |
| `Super + Q` | Cerrar la ventana enfocada |
| `Super + A` | Launcher de apps — rofi (drun) |
| `Super + E` | Explorador de archivos — thunar |
| `Super + W` | Alternar flotante en la ventana enfocada |
| `Super + F` | Alternar pantalla completa |
| `Super + L` | Bloquear pantalla — hyprlock |
| `Super + M` | Cerrar sesión (`hyprshutdown` si está instalado; si no, salir de Hyprland) |
| `Super + P` | Captura de región → satty (anotar/guardar) |
| `Print` | Captura de la pantalla completa → satty |
| `Super + B` | Brave *(app opcional)* |
| `Super + G` | Firefox *(app opcional)* |
| `Super + C` | VSCodium *(app opcional)* |
| `Super + Y` | Spotify *(app opcional)* |
| `Super + H` | Heroic *(app opcional)* |
| `Super + Shift + W` | Gestor de fondos — waypaper |

## Workspaces

| Atajo | Acción |
|---|---|
| `Super + 1…9`, `Super + 0` | Ir al workspace 1–10 (`0` = workspace 10) |
| `Super + Shift + 1…9/0` | Mover la ventana al workspace 1–10 |
| `Super + Alt + 1…9/0` | Mover la ventana al workspace 1–10 **sin seguirla** |
| `Super + Ctrl + → / ←` | Workspace relativo: siguiente / anterior |
| `Super + Ctrl + scroll ↑ / ↓` | Workspace relativo: anterior / siguiente |
| `Super + Ctrl + ↓` | Workspace **vacío** más cercano |
| `Super + scroll ↓ / ↑` | Workspace existente siguiente / anterior |
| `Super + Ctrl + Alt + → / ←` | Mover ventana al workspace relativo siguiente / anterior |
| `Super + S` | Alternar el scratchpad (workspace especial) |
| `Super + Shift + S` | Mover la ventana al scratchpad |
| `Super + Alt + S` | Mover la ventana al scratchpad **sin seguirla** |

## Foco y distribución de ventanas

| Atajo | Acción |
|---|---|
| `Super + ← / → / ↑ / ↓` | Cambiar el foco hacia esa dirección |
| `Alt + Tab` | Focar la siguiente ventana |
| `Super + clic izquierdo` (arrastrar) | Mover ventana |
| `Super + clic derecho` (arrastrar) | Redimensionar ventana |

Las ventanas se colocan en mosaico (layout dwindle) con bordes de 2 px y gaps
interiores de 2 px; las reglas de flotante (diálogos, PiP, calculadoras…) están
definidas en `hyprland.lua`.

## Música y brillo

Todo esto funciona desde la pantalla de bloqueo donde indica **[locked]**.

| Atajo | Acción |
|---|---|
| `Ctrl + Shift + F1` **[locked] [repeat]** | Bajar volumen 5% |
| `Ctrl + Shift + F4` **[locked] [repeat]** | Subir volumen 5% |
| `Ctrl + Shift + F2` **[locked]** | Silenciar / desactivar silencio (altavoces) |
| `Ctrl + Shift + F3` **[locked]** | Silenciar / desactivar silencio del micrófono |
| `Ctrl + Shift + F5` **[locked]** | Pista anterior |
| `Ctrl + Shift + F6` **[locked]** | Reproducir / pausar |
| `Ctrl + Shift + F7` **[locked]** | Detener |
| `Ctrl + Shift + F8` **[locked]** | Pista siguiente |
| `XF86AudioRaiseVolume` **[repeat]** | Subir volumen 5% (+ indicador en pantalla) |
| `XF86AudioLowerVolume` **[repeat]** | Bajar volumen 5% (+ indicador en pantalla) |
| `XF86AudioMute` | Alternar silencio (+ indicador en pantalla) |
| `XF86AudioPlay` / `Next` / `Prev` / `Stop` | Controles de reproducción |
| `XF86MonBrightnessUp` / `Down` | Retroiluminación +10% / −10% (+ indicador) |

## Waybar (ratón)

| Dónde | Acción |
|---|---|
| Icono de menú (centro) | Abrir rofi |
| `+` (junto a los workspaces) | Saltar al workspace siguiente |
| Icono de volumen | Silenciar / desactivar silencio · **clic derecho** → pavucontrol |
| Icono de micrófono | Silenciar / desactivar silencio · **clic derecho** → pavucontrol |
| Icono de brillo | Alternar `hyprsunset` (luz nocturna) · **scroll** → brillo ±10% |
| Icono de Bluetooth | Abrir **overskride** |
| Icono de red | Abrir **iwgtk** (iwd) |
| Batería / perfiles de energía | Informativo (tooltip) |
| Icono de energía | Abrir wlogout (salir / reiniciar / apagar / suspender / bloquear) |
| Icono de campana | Mostrar / ocultar el panel de notificaciones SwayNC |
| Reloj | Tooltip con la fecha completa |

## Notas

- **Apps opcionales:** `Super + B/G/C/Y/H` abren Brave, Firefox, VSCodium, Spotify
  y Heroic — instala las que uses (o edita las variables al inicio de
  `hypr/hyprland.lua` para apuntar a tus propios programas).
- Todo vive en [`hypr/hyprland.lua`](../hypr/hyprland.lua); tras editarlo ejecuta
  `hyprctl reload`.
- `waypaper` restaura tu último fondo al iniciar sesión
  (`hl.exec_cmd("waypaper --restore")`). Configura tu propia carpeta en
  `waypaper/config.ini` (`folder = ...`).
- Las capturas se guardan en `~/Pictures/Screenshots` (sobrescribe con `$SCREENSHOT_DIR`).
