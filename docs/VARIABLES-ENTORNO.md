# Variables de entorno — Minimalism Shell

Las variables de entorno (env vars) son pares `clave=valor` que el sistema y las
apps leen para adaptar su comportamiento. Se definen en `hyprland.lua` con
`hl.env("CLAVE", "valor")` y las heredan **todas las apps que lanza Hyprland**
(el shell, terminales, navegadores…).

> Nota sobre GPU híbrida (tu laptop): la **iGPU Intel** alimenta el panel
> interno; la **RTX 4060** se usa para render/descarga. Por eso hay que tener
> cuidado con forzar todo hacia NVIDIA.
>
> **Portabilidad:** las variables de vídeo (`LIBVA_DRIVER_NAME`, `NVD_BACKEND`) ya
> no se fuerzan a NVIDIA. `hyprland.lua` **detecta la GPU al arrancar** (vía `lspci`)
> y aplica el backend solo si existe: NVIDIA → `nvidia`+`direct`, AMD → `radeonsi`,
> Intel → `iHD`. Así el mismo dotfiles sirve en máquinas de cualquier marca.

## Variables activas

| Variable | Valor | ¿Qué hace? | ¿Por qué? |
|---|---|---|---|
| `XCURSOR_THEME` | `Bibata-Modern-Classic` | Tema del cursor. | Coherencia visual. |
| `XCURSOR_SIZE` | `24` | Tamaño del cursor en px. | Legibilidad en 165Hz/alta densidad. |
| `QT_AUTO_SCREEN_SCALE_FACTOR` | `1` | Escalado automático de apps Qt según DPI. | Evita UI pequeña/grande en monitores distintos. |
| `QT_QPA_PLATFORM` | `wayland;xcb` | Apps Qt usan Wayland, con fallback a X11 (xcb). | Wayland nativo + compatibilidad. |
| `QT_WAYLAND_DISABLE_WINDOWDECORATION` | `1` | Quita los bordes/títulos nativos de ventanas Qt. | Hyprland dibuja sus propios bordes (no doble decoración). |
| `QT_QPA_PLATFORMTHEME` | `qt5ct` | Tema/aspecto de apps Qt vía qt5ct. | Unificar apariencia Qt con el resto. |
| `ELECTRON_OZONE_PLATFORM_HINT` | `auto` | Apps Electron usan Wayland nativo si está disponible (si no, XWayland). | Nitidez y menos lag de entrada en Discord/Spotify/VSCode. |
| `MOZ_ENABLE_WAYLAND` | `1` | Firefox corre nativo en Wayland (no XWayland). | Mejor rendimiento y integración (p. ej. capturas, foco). |
| `LIBVA_DRIVER_NAME` | `nvidia`* | La decodificación de vídeo (VA-API) la hace la GPU. | Vídeo 4K/60 sin cargar la CPU; clave para mpvpaper. *Según GPU: `nvidia`/`radeonsi`/`iHD`. |
| `NVD_BACKEND` | `direct`* | Requisito del driver VA-API de NVIDIA para descodificar de verdad. | *Solo se aplica si hay GPU NVIDIA. Sin esta, la anterior no tiene efecto real. |

### Nota: vídeo en Brave/Chromium (NVIDIA + Wayland)

Con `LIBVA_DRIVER_NAME=nvidia`, Brave/Chromium decodifican en la GPU pero al
presentar los frames vía EGLImage fallan en NVIDIA+Wayland
(`eglCreateImage` → `0x3009`): **el vídeo se queda en una imagen fija** con el
audio corriendo. Por eso el repo incluye `brave-flags.conf`
(`~/.config/brave-flags.conf`) con `--disable-features=AcceleratedVideoDecodeLinuxGL`:
Brave pasa a decodificar por software y el vídeo se reproduce con normalidad.
mpv/Firefox no se ven afectados y siguen usando la GPU (verificado: mpv
`Using hardware decoding (vaapi)`).

## Variables comentadas (peligrosas en híbrido — actívalas con criterio)

| Variable | Valor | ¿Qué hace? | Riesgo en laptop híbrido |
|---|---|---|---|
| `GBM_BACKEND` | `nvidia-drm` | Fuerza el buffer gráfico (GBM) a pasar por NVIDIA. | Si la iGPU Intel alimenta el panel, puede causar **pantalla negra**. Solo actívala si ves artefactos/crashes con OpenGL. |
| `__GLX_VENDOR_LIBRARY_NAME` | `nvidia` | Fuerza GLX (OpenGL vía XWayland) a usar la NVIDIA. | Similar: útil para offload, pero puede conflicto en híbrido. |

### ¿Cuándo activarlas?
Solo si notas apps XWayland con OpenGL lentas o con artefactos. En un setup
híbrido bien configurado **no hacen falta** (Hyprland + drivers recientes con
*explicit sync* ya enrutan bien la render).

## Requisito de kernel (ya cumplido)

- `nvidia_drm.modeset=1` → verificado: `cat /sys/module/nvidia_drm/parameters/modeset` = **Y**.
  Sin esto, Wayland/NVIDIA no arranca bien. En CachyOS viene activado por defecto.
