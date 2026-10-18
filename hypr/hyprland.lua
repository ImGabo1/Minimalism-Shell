--===============================
-- Hyprland config (Lua) v0.56.2
-- Migrado desde hyprlang 2026-09-15
-- Backup: ~/.config/hypr/backup-2026-09-15/
--===============================

--===============================
-- PROGRAMAS
--===============================
local mainMod    = "SUPER"
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"
local browser     = "brave"
local games       = "heroic"
local browser2    = "firefox"

--===============================
-- MONITORES
--===============================
hl.monitor({
    output   = "desc:China Star Optoelectronics Technology Co. Ltd MNG007QA1-1",
    mode     = "1920x1200@165",
    position = "0x0",
    scale    = 1,
})

-- Fallback multimonitor: cualquier monitor conectado se activa solo con su
-- resolución/tasa preferidas. El de arriba (por desc) mantiene sus 165Hz.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

--===============================
-- AUTOSTART
--===============================
hl.on("hyprland.start", function()
    hl.dsp.focus({ workspace = "1" })
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("udiskie")
    hl.exec_cmd("waypaper --restore")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
end)

--===============================
-- ENVIRONNEMENT VARIABLES
--===============================
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

-- NVIDIA + Wayland (GPU híbrida: Intel iGPU + RTX 4060 dGPU)
-- Detalle de cada una en docs/VARIABLES-ENTORNO.md
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto") -- Electron (Discord/Spotify/Code) usa Wayland nativo
hl.env("MOZ_ENABLE_WAYLAND", "1")              -- Firefox usa Wayland nativo
hl.env("LIBVA_DRIVER_NAME", "nvidia")          -- decodificación de vídeo por NVDEC (GPU)
hl.env("NVD_BACKEND", "direct")                -- requisito para que la anterior funcione
-- En laptops híbridos estas dos pueden dar pantalla negra si la iGPU Intel alimenta
-- el panel. Actívalas solo si ves artefactos/crashes al abrir apps con OpenGL:
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

--===============================
-- LOOK AND FEEL
--===============================
hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 0,
        border_size = 2,
        col = {
            active_border = {
                colors = { "rgba(ffffffff)", "rgba(8c8c9fff)" },
                angle  = 45,
            },
            inactive_border = "rgba(313244ff)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 8,
        blur = {
            enabled = true,
            size    = 3,
            passes  = 2,
        },
    },

    input = {
        kb_layout  = "us",
        kb_variant = "intl",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity   = 0,
        accel_profile = "flat",

        touchpad = {
            natural_scroll = false,
        },
    },
})

--===============================
-- KEYBINDINGS
--===============================

-- Aplicaciones
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("vscodium"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("spotify"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
-- Capturas unificadas: ambas pasan por satty (wrapper screenshot.sh)
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("screenshot region"))
hl.bind("print",                        hl.dsp.exec_cmd("screenshot output"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(games))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(browser2))

-- Navegación de workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i }),
        { description = "[$ws|Navigation] navigate to workspace " .. i })
end

-- Workspaces relativos
hl.bind(mainMod .. " + CONTROL + Right",     hl.dsp.focus({ workspace = "r+1" }), { description = "[$ws|Navigation|Relative workspace] change active workspace forwards" })
hl.bind(mainMod .. " + CONTROL + Left",      hl.dsp.focus({ workspace = "r-1" }), { description = "[$ws|Navigation|Relative workspace] change active workspace backwards" })
hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "r+1" }), { description = "[$ws|Navigation|Relative workspace] change active workspace forwards" })
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "r-1" }), { description = "[$ws|Navigation|Relative workspace] change active workspace backwards" })
hl.bind(mainMod .. " + CONTROL + Down",       hl.dsp.focus({ workspace = "empty" }), { description = "[$ws|Navigation] navigate to the nearest empty workspace" })

-- Mover ventana a workspace
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i }),
        { description = "[$ws|Move window to workspace] move to workspace " .. i })
end

-- Mover ventana a workspace relativo
hl.bind(mainMod .. " + CONTROL + ALT + Right", hl.dsp.window.move({ workspace = "r+1" }), { description = "[$ws] move window to next relative workspace" })
hl.bind(mainMod .. " + CONTROL + ALT + Left",  hl.dsp.window.move({ workspace = "r-1" }), { description = "[$ws] move window to previous relative workspace" })

-- Desplazarse por workspaces existentes
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "[$ws|Navigation] next workspace" })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { description = "[$ws|Navigation] previous workspace" })

-- Workspace especial (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }), { description = "[$ws|Navigation|Special workspace] move to scratchpad" })
hl.bind(mainMod .. " + ALT + S",    hl.dsp.window.move({ workspace = "special", follow = false }), { description = "[$ws|Navigation|Special workspace] move to scratchpad (silent)" })
hl.bind(mainMod .. " + S",          hl.dsp.workspace.toggle_special(), { description = "[$ws|Navigation|Special workspace] toggle scratchpad" })

-- Mover ventana a workspace en silencio
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + ALT + " .. key,
        hl.dsp.window.move({ workspace = i, follow = false }),
        { description = "[$ws|Navigation|Move window silently] move to workspace " .. i .. " (silent)" })
end

-- Mover/redimensionar con ratón
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Navegación de foco
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }), { description = "Focus window right" })
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }),  { description = "Focus window left" })
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }),    { description = "Focus window up" })
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }),  { description = "Focus window down" })
hl.bind("ALT + TAB", hl.dsp.focus({ direction = "down" }), { description = "Switch to next window" })

-- Volumen (locked + repeat)
hl.bind("CONTROL + SHIFT + F4", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),          { locked = true, repeating = true })
hl.bind("CONTROL + SHIFT + F1", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),               { locked = true, repeating = true })
hl.bind("CONTROL + SHIFT + F2", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),              { locked = true, repeating = true })
hl.bind("CONTROL + SHIFT + F3", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),            { locked = true, repeating = true })

-- Música (locked)
hl.bind("CONTROL + SHIFT + F8", hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("CONTROL + SHIFT + F6", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("CONTROL + SHIFT + F7", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("CONTROL + SHIFT + F5", hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Brillo
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +10% && swayosd-client --brightness raise"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%- && swayosd-client --brightness lower"))

-- Volumen (teclas multimedia, repetir)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && swayosd-client --output-volume raise"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && swayosd-client --output-volume lower"), { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))

-- Música (teclas multimedia)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))

--===============================
-- WINDOW RULES
--===============================

hl.window_rule({
    name  = "opacity-blur-empty",
    match = { class = "^()$", title = "^()$" },
    no_blur = true,
})

hl.window_rule({
    name  = "opacity-default",
    match = { class = "^(.*)$", title = "^(.*)$" },
    opacity = "0.90 0.90",
})

hl.window_rule({
    name  = "opacity-full-browsers",
    match = { class = "^(firefox)$|^(.*brave-browser*)$" },
    opacity = "1.00 1.00",
})

-- Picture in Picture (bilingüe EN/ES)
hl.window_rule({
    name  = "picture_in_picture",
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture|[Pp]antalla\\s+en\\s+pantalla|[Ii]magen\\s+en\\s+imagen)(.*)$" },
    tag               = "+picture-in-picture",
    float             = true,
    keep_aspect_ratio = true,
    move              = { "monitor_w * 0.73", "monitor_h * 0.72" },
    size              = { "monitor_w * 0.25", "monitor_h * 0.25" },
    pin               = true,
})

-- idle_inhibit (reproductores y navegadores)
hl.window_rule({ name = "idle-celluloid",    match = { class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$" },         idle_inhibit = "fullscreen" })
hl.window_rule({ name = "idle-spotify",      match = { class = "^(.*[Ss]potify.*)$" },                              idle_inhibit = "fullscreen" })
hl.window_rule({ name = "idle-yandex-music", match = { class = "^(yandex-music)$" },                              idle_inhibit = "fullscreen" })
hl.window_rule({ name = "idle-browsers",     match = { class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$" }, idle_inhibit = "fullscreen" })

-- Ventanas flotantes
hl.window_rule({ name = "float-vlc",           match = { class = "^(vlc)$" },                                             float = true })
hl.window_rule({ name = "float-overskride",    match = { class = "^(io.github.kaii_lb.Overskride)$" },                     float = true })
hl.window_rule({ name = "float-iwgtk",         match = { class = "^(org.twosheds.iwgtk)$" },                               float = true })
hl.window_rule({ name = "float-steam",         match = { class = "^(steam_app_default)$" },                                float = true })
hl.window_rule({ name = "float-xarchiver",     match = { class = "^(xarchiver)$" },                                        float = true })
hl.window_rule({ name = "float-comscp",        match = { class = "^(com-scp-MainDashboard)$" },                            float = true })
hl.window_rule({ name = "float-pip-browsers",  match = { class = "^(firefox)$|^(.*brave-browser.*)$", title = "^(Picture-in-Picture)$|^(Pantalla en pantalla)$|^(Imagen en imagen)$" }, float = true })
hl.window_rule({ name = "float-library",       match = { class = "^(firefox)$|^(.*brave-browser.*)$", title = "^(Library)$" }, float = true })
hl.window_rule({ name = "float-polkit",        match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },        float = true })
hl.window_rule({ name = "float-qt5ct",         match = { class = "^(qt5ct)$" },                                            float = true })
hl.window_rule({ name = "float-qt6ct",         match = { class = "^(qt6ct)$" },                                            float = true })
hl.window_rule({ name = "float-ark",           match = { class = "^(org.kde.ark)$" },                                      float = true })
hl.window_rule({ name = "float-pavucontrol",   match = { class = "^(org.pulseaudio.pavucontrol)$" },                      float = true, size = { "monitor_w * 0.48", "monitor_h * 0.42" } })
hl.window_rule({ name = "float-yad",           match = { class = "^(yad)$" },                                              float = true })
hl.window_rule({ name = "float-calculator",    match = { class = "^(gnome-calculator)$" },                                 float = true, center = true, size = { "monitor_w * 0.19", "monitor_h * 0.47" } })
hl.window_rule({ name = "float-loupe",         match = { class = "^(org.gnome.Loupe)$" },                                   float = true, center = true, size = { "monitor_w * 0.63", "monitor_h * 0.74" } })
hl.window_rule({ name = "float-fileroller",    match = { class = "^(org.gnome.FileRoller)$" },                              float = true, center = true, size = { "monitor_w * 0.63", "monitor_h * 0.74" } })
hl.window_rule({ name = "float-qalculate",     match = { class = "^(qalculate-gtk)$" },                                    float = true, center = true, size = { "monitor_w * 0.45", "monitor_h * 0.55" } })

-- Modales
hl.window_rule({ name = "float-modal-open",            match = { title = "^(Open)$" },                          float = true })
hl.window_rule({ name = "float-modal-auth",            match = { title = "^(Authentication Required)$" },       float = true })
hl.window_rule({ name = "float-modal-add-folder",      match = { title = "^(Add Folder to Workspace)$" },       float = true })
hl.window_rule({ name = "float-modal-open-file",       match = { initial_title = "^(Open File)$" },             float = true })
hl.window_rule({ name = "float-modal-choose-files",    match = { title = "^(Choose Files)$" },                  float = true })
hl.window_rule({ name = "float-modal-save-as",         match = { title = "^(Save As)$" },                       float = true })
hl.window_rule({ name = "float-modal-confirm-replace", match = { title = "^(Confirm to replace files)$" },      float = true })
hl.window_rule({ name = "float-modal-file-op-progress",match = { title = "^(File Operation Progress)$" },       float = true })
hl.window_rule({ name = "float-modal-file-upload",     match = { title = "^(File Upload)(.*)$" },               float = true })
hl.window_rule({ name = "float-modal-choose-wallpaper",match = { title = "^(Choose wallpaper)(.*)$" },          float = true })
hl.window_rule({ name = "float-modal-library",         match = { title = "^(Library)(.*)$" },                   float = true })
hl.window_rule({ name = "float-dialog-class",          match = { class = "^(.*dialog.*)$" },                    float = true })
hl.window_rule({ name = "float-dialog-title",          match = { title = "^(.*dialog.*)$" },                    float = true })

-- Portales
hl.window_rule({ name = "float-portal-hyprland", match = { class = "^(org.freedesktop.impl.portal.desktop.hyprland)$" }, float = true, center = true })
hl.window_rule({ name = "float-portal-gtk",      match = { class = "^(org.freedesktop.impl.portal.desktop.gtk)$" },      float = true, center = true })
hl.window_rule({ name = "float-portal-xdg-gtk",  match = { class = "^([Xx]dg-desktop-portal-gtk)$" },                      float = true, center = true })

-- xwayland video bridge
hl.window_rule({
    name  = "xwayland-video-bridge-fixes",
    match = { class = "xwaylandvideobridge" },
    no_initial_focus = true,
    no_focus         = true,
    no_anim          = true,
    no_blur          = true,
    max_size         = { 1, 1 },
    opacity          = "0.0",
})

--===============================
-- LAYER RULES
--===============================
hl.layer_rule({ match = { namespace = "rofi" },                 blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "notifications" },         blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "waybar" },                blur = true, ignore_alpha = 0 })