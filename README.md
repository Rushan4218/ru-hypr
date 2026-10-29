# ru-hypr

A personal, modular [Hyprland](https://hyprland.org/) configuration targeting **Arch Linux** and **Fedora**, featuring coordinated dynamic theming via Wallust, Waybar status bar, Rofi application launcher, SwayNC notification center, SwayOSD on-screen display, Wlogout power menu, and automated workflow scripts.

---

## Highlights

- **One-Script Installation** — Automated setup script (`install.sh`) supporting **Arch Linux** and **Fedora**
- **Modular Hyprland Configuration** — Clean separation of concerns (monitors, keybinds, inputs, layout, autostart)
- **Live & Static Wallpaper Engine** — Full support for static images (`.png`, `.jpg`, `.webp`, `.avif`, etc.) via `awww` and animated/video wallpapers (`.mp4`, `.webm`, `.mkv`, `.mov`, `.gif`, etc.) via `mpvpaper` and `ffmpeg`
- **Dynamic Theming with Wallust** — Coordinated color palettes derived automatically from static wallpapers or auto-extracted still frames from live wallpapers
- **Full UI Integration** — Matched themes for Waybar, Rofi, SwayNC, SwayOSD, Wlogout, Kitty, and Hyprlock
- **Wallpaper & Animation Pickers** — Graphical selectors for wallpapers (`SUPER + W`) with video thumbnails and animation presets (`SUPER + SHIFT + W`)
- **On-Screen Display (OSD)** — Smooth volume and brightness indicators using **SwayOSD**
- **Battery Monitoring** — Background daemon notifying on low and critical battery levels
- **Screenshots & Annotations** — Quick fullscreen and interactive region capture with **grim**, **slurp**, and **satty**
- **Clipboard Management** — Integrated history and searchable picker via **cliphist** and Rofi
- **Color Picker** — Instant hex color grabber via **hyprpicker** with clipboard integration
- **Multi-Monitor Workspace Routing** — Smart workspace mapping across internal laptop displays and external monitors

---

## Repository Layout

```text
ru-hypr/
├── hyprland.conf            # Main Hyprland configuration entrypoint
├── install.sh               # One-script installer for Arch & Fedora
├── config/                  # Modular Hyprland configs
│   ├── autostart.conf       # Background services and daemons
│   ├── input.conf           # Keyboard, touchpad, and mouse settings
│   ├── keybinds.conf        # Keybindings and shortcut triggers
│   ├── layout.conf          # Window decoration and layout options
│   ├── monitors.conf        # Display outputs, scales, and resolutions
│   └── rule.conf            # Window and layer rules
├── animations/              # Animation curve presets & active symlink
├── scripts/                 # Utility scripts (wallpaper, battery, workspaces, etc.)
├── waybar/                  # Waybar layout and styling
├── rofi/                    # Rofi launcher and menu themes
├── swaync/                  # SwayNotificationCenter configuration & styling
├── swayosd/                 # SwayOSD configuration & styling
├── wlogout/                 # Power/logout menu layout and style
├── kitty/                   # Kitty terminal configuration
├── hyprlock/                # Hyprlock screen locker configuration
├── hypridle/                # Hypridle timeout and lock behavior
├── wallust/                 # Wallust templates for dynamic palette generation
└── generated/               # Auto-generated palettes and cached backgrounds
```

---

## Installation

### Method 1: One-Script Installation (Recommended)

You can run the installer directly using `curl`:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Rushan4218/ru-hypr/main/install.sh)
```

Alternatively, clone the repository first and execute the script:

```bash
git clone https://github.com/Rushan4218/ru-hypr.git ~/.config/ru-hypr
cd ~/.config/ru-hypr
chmod +x install.sh
./install.sh
```

#### What `install.sh` does:
1. **Detects Distro**: Recognizes whether you are running **Arch Linux** or **Fedora**.
2. **Installs Packages**: Uses `pacman` (with `paru`/`yay` fallback) on Arch or `dnf` on Fedora to install all required compositor, UI, multimedia (`mpv`, `mpvpaper`, `ffmpeg`), and system utilities.
3. **Builds Wallust & awww**: Automatically compiles and installs `wallust` and `awww` using Cargo if not already installed.
4. **Clones or Updates Config**: Ensures the configuration is cloned to `~/.config/ru-hypr` (or updates existing checkout).
5. **Links Configuration**: Safely backs up any existing `~/.config/hypr/hyprland.conf` and symlinks `~/.config/ru-hypr/hyprland.conf` into place.
6. **Installs Fonts**: Automatically downloads and installs **JetBrainsMono Nerd Font** and **Material Symbols Rounded** into `~/.local/share/fonts` and refreshes the font cache.
7. **Makes Scripts Executable**: Grants execution permissions to all helper scripts in `scripts/`.
8. **Reports Missing Packages**: Informs you with actionable hints if any distro-specific packages require manual intervention.

---

### Method 2: Manual Installation

If you prefer installing dependencies and setting up symlinks manually, follow these steps:

#### 1. Install Dependencies

##### On Arch Linux:
```bash
sudo pacman -S --needed \
  git hyprland hyprland-guiutils xdg-desktop-portal-hyprland \
  hypridle hyprlock hyprpicker waybar rofi kitty swaync swayosd wlogout \
  jq cliphist wl-clipboard brightnessctl wireplumber pavucontrol \
  imagemagick networkmanager bluez bluez-utils \
  grim slurp satty mpv ffmpeg
```

> **Note**: `mpvpaper` is available in the AUR (`yay -S mpvpaper` or `paru -S mpvpaper`). `wallust` and `awww` can be installed via AUR or with Cargo (`cargo install wallust` and compiling `awww` from source). `swayosd` is available in Arch's `extra` repository.

##### On Fedora:
```bash
# Enable Hyprland COPR repository
sudo dnf copr enable -y nett00n/hyprland

sudo dnf install -y \
  git hyprland hyprland-guiutils xdg-desktop-portal-hyprland \
  hypridle hyprlock hyprpicker waybar rofi kitty \
  SwayNotificationCenter swayosd wlogout jq cliphist wl-clipboard \
  brightnessctl wireplumber pavucontrol ImageMagick \
  NetworkManager NetworkManager-tui bluez grim slurp satty \
  mpv mpvpaper ffmpeg
```

> **Note**: `wallust` and `awww` can be installed using Rust/Cargo (`cargo install wallust`, and building `awww` from https://codeberg.org/LGFae/awww).

Enable system services if you use them:
```bash
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
```

#### 2. Clone the Repository
```bash
git clone https://github.com/Rushan4218/ru-hypr.git ~/.config/ru-hypr
```

#### 3. Link `hyprland.conf`
Ensure `~/.config/hypr` exists and back up any existing configuration:
```bash
mkdir -p ~/.config/hypr
if [ -e ~/.config/hypr/hyprland.conf ] && [ ! -L ~/.config/hypr/hyprland.conf ]; then
  mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup
fi
ln -sfn ~/.config/ru-hypr/hyprland.conf ~/.config/hypr/hyprland.conf
```

#### 4. Install Fonts
Ensure **JetBrainsMono Nerd Font** and **Material Symbols Rounded** are installed:
```bash
mkdir -p ~/.local/share/fonts

# JetBrainsMono Nerd Font
curl -fsSL -o /tmp/jb.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
unzip -qo /tmp/jb.zip -d ~/.local/share/fonts/JetBrainsMonoNF
rm /tmp/jb.zip

# Material Symbols Rounded
curl -fL "https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsRounded%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf" \
  -o ~/.local/share/fonts/MaterialSymbolsRounded.ttf

fc-cache -f
```

#### 5. Make Scripts Executable
```bash
chmod +x ~/.config/ru-hypr/scripts/*
```

---

## Dependencies Reference

| Category | Packages / Tools |
| :--- | :--- |
| **Compositor & Session** | `hyprland`, `hyprland-guiutils`, `xdg-desktop-portal-hyprland`, `hypridle`, `hyprlock`, `hyprpicker`, `swayosd` |
| **Status, Launcher & UI** | `waybar`, `rofi`, `kitty`, `swaync` (Fedora: `SwayNotificationCenter`), `wlogout` |
| **Static & Live Wallpaper** | `awww` (static transitions), `mpvpaper` & `mpv` (live video/GIF), `ffmpeg` (video frame extraction) |
| **Color Generation & Images** | `wallust` (palette generation), `imagemagick` (Fedora: `ImageMagick`) |
| **Media, Audio & Brightness** | `wireplumber` (`wpctl`), `pavucontrol`, `brightnessctl` |
| **Screenshots & Clipboard** | `grim`, `slurp`, `satty`, `cliphist`, `wl-clipboard` |
| **System & Networking** | `networkmanager` (`NetworkManager-tui`), `bluez`, `bluez-utils`, `jq`, `git` |
| **Typography** | `JetBrainsMono Nerd Font`, `Material Symbols Rounded` |

---

## Wallpaper and Theming Workflow

The default wallpaper directory is:
```text
~/Pictures/Wallpapers
```

### Supported Formats
- **Static Images**: `.jpg`, `.jpeg`, `.png`, `.webp`, `.avif`, `.bmp`, `.tif`, `.tiff`
- **Live / Video Wallpapers**: `.mp4`, `.webm`, `.mkv`, `.mov`, `.m4v`, `.avi`, `.gif`

### Set a Wallpaper Directly
```bash
~/.config/ru-hypr/scripts/set-wallpaper /absolute/path/to/wallpaper.mp4
# or for static image:
~/.config/ru-hypr/scripts/set-wallpaper /absolute/path/to/wallpaper.jpg
```

### Open the Graphical Wallpaper Picker
Press `SUPER + W` or run:
```bash
~/.config/ru-hypr/scripts/wallpaper-picker
```
The picker generates cached thumbnails in parallel using `ffmpeg` and ImageMagick, tagging video items with `[VIDEO]` and GIFs with `[GIF]` so you can easily browse your collection in Rofi.

### Custom Wallpaper Directory
You can override the wallpaper directory by passing `WALLPAPER_DIR`:
```bash
WALLPAPER_DIR=/path/to/wallpapers ~/.config/ru-hypr/scripts/wallpaper-picker
```

### How Live and Static Wallpapers Work:
When a wallpaper is selected (or restored on boot via `scripts/start-session`):
1. **Background Rendering**:
   - **Static Wallpapers**: Set using `awww` with a smooth cross-fade animation.
   - **Live Wallpapers**: Played continuously across all connected monitors using `mpvpaper` (`--loop-file=inf`, muted audio).
2. **Still Frame & Palette Generation**:
   - For video and GIF wallpapers, `ffmpeg` (or `magick`) extracts a reference frame into `~/.cache/ru-hypr/live-wallpaper-frames/`.
   - **Wallust** runs on this representative still frame to generate dynamic, harmonized color schemes.
3. **Desktop Theme Synchronization**:
   - Injects the generated color palette into Waybar, SwayNC, SwayOSD, Wlogout, Rofi, and Kitty.
   - Live-reloads Hyprland, Waybar, and SwayOSD so colors update instantaneously without ending your session.
4. **Lock Screen Integration**:
   - Generates a matching static lock screen background for **Hyprlock**, ensuring fast and secure locking even when running video wallpapers.

---

## Keybindings Reference

All keybindings are configured in [`config/keybinds.conf`](file:///home/ross/.config/ru-hypr/config/keybinds.conf).

> **Modifier Key**: `SUPER` refers to the **Windows / Super / Command** key.

### Application Shortcuts
| Keybind | Command / Script | Description |
| :--- | :--- | :--- |
| `SUPER + Q` | `kitty` | Launch Kitty terminal emulator |
| `SUPER + R` | `rofi -show drun` | Open Rofi application launcher |
| `SUPER + E` | `thunar` | Open Thunar file manager |
| `SUPER + Escape` | `wlogout` | Open Wlogout lock / reboot / shutdown menu |
| `SUPER + SHIFT + R` | `hyprctl reload` | Reload Hyprland configuration live |

### Window Management & Focus
| Keybind | Action | Description |
| :--- | :--- | :--- |
| `SUPER + C` | `killactive` | Close the currently focused window |
| `SUPER + F` | `fullscreen` | Toggle fullscreen mode for the active window |
| `SUPER + P` | `togglefloating` | Toggle floating / tiling mode for the active window |
| `SUPER + H` | `movefocus, l` | Move focus to the window on the **left** (Vim-style) |
| `SUPER + J` | `movefocus, d` | Move focus to the window **down** (Vim-style) |
| `SUPER + K` | `movefocus, u` | Move focus to the window **up** (Vim-style) |
| `SUPER + L` | `movefocus, r` | Move focus to the window on the **right** (Vim-style) |
| `SUPER + Left Click Drag` | `movewindow` | Move a floating window by dragging |
| `SUPER + Right Click Drag` | `resizewindow` | Resize a floating window by dragging |

### Workspaces & Monitor-Aware Switching
This configuration uses a monitor-aware switching script (`scripts/workspace-switch.sh`) so each monitor maintains its own set of workspaces without overlap:
- **Internal display (`eDP-1`)**: uses Workspaces **1 – 10**
- **External monitor (`HDMI-A-1`)**: uses Workspaces **11 – 20**

| Keybind | Action | Description |
| :--- | :--- | :--- |
| `SUPER + 1` .. `9`, `0` | Switch workspace | Switch to workspace 1–10 on `eDP-1` or 11–20 on `HDMI-A-1` |
| `SUPER + SHIFT + 1` .. `9`, `0` | Move window | Move focused window to workspace 1–10 (or 11–20 on external display) |
| `SUPER + Scroll Up` | `workspace, e-1` | Cycle to the previous active workspace |
| `SUPER + Scroll Down` | `workspace, e+1` | Cycle to the next active workspace |

### Audio & Display Brightness (SwayOSD)
Hardware media keys display a modern on-screen overlay via SwayOSD:
| Keybind | Command | Description |
| :--- | :--- | :--- |
| `XF86AudioRaiseVolume` | `swayosd-client --output-volume raise` | Raise volume (+OSD popup) |
| `XF86AudioLowerVolume` | `swayosd-client --output-volume lower` | Lower volume (+OSD popup) |
| `XF86AudioMute` | `swayosd-client --output-volume mute-toggle` | Toggle audio mute (+OSD popup) |
| `XF86AudioMicMute` | `swayosd-client --input-volume mute-toggle` | Toggle microphone mute (+OSD popup) |
| `XF86MonBrightnessUp` | `swayosd-client --brightness raise` | Increase screen brightness (+OSD popup) |
| `XF86MonBrightnessDown` | `swayosd-client --brightness lower` | Decrease screen brightness (+OSD popup) |

### Tools & Utilities
| Keybind | Tool / Script | Description |
| :--- | :--- | :--- |
| `SUPER + W` | `scripts/wallpaper-picker` | Open Rofi visual wallpaper picker & regenerates colors |
| `SUPER + SHIFT + W` | `scripts/animation-picker` | Open animation preset picker (End-4 Horizontal / Vertical / macOS) |
| `SUPER + V` | `scripts/clipboard` | Open clipboard history manager (`cliphist` + Rofi) |
| `SUPER + SHIFT + C` | `hyprpicker -a` | Eyedropper color picker (copies HEX code to clipboard) |
| `PRINT` | `scripts/screenshot-full` | Take a full-screen screenshot (`~/Pictures/Screenshots`) |
| `SUPER + PRINT` | `scripts/screenshot-region` | Interactive area capture with **Satty** annotation editor |

---

## Customization

### Displays and Monitors
Display layout and refresh rates are configured in:
```text
config/monitors.conf
```
Check your detected display outputs:
```bash
hyprctl monitors
```
Update `config/monitors.conf` and `scripts/workspace-switch.sh` if your outputs differ from `eDP-1` or `HDMI-A-1`.

### Animations
Change animation styles anytime via the picker (`SUPER + SHIFT + W`) or modify files in `animations/`:
- `end4-horizontal.conf`
- `end4-vertical.conf`
- `macos.conf`

The active preset is symlinked/sourced via `animations/active.conf`.

### Inputs
Mouse sensitivity, touchpad tap-to-click, natural scroll, and keyboard layouts can be customized in:
```text
config/input.conf
```

### SwayOSD
Customize SwayOSD appearance and behavior in `swayosd/config.toml` and `swayosd/style.css`.

### Dynamic Theme Templates
Templates defining how Wallust generates colors live in `wallust/wallust.toml` and the `wallust/` directory.

---

## Troubleshooting

### Hyprland doesn't pick up the configuration
Ensure `~/.config/hypr/hyprland.conf` exists and points to `~/.config/ru-hypr/hyprland.conf`:
```bash
ls -l ~/.config/hypr/hyprland.conf
```

### Scripts fail with permission denied
Run:
```bash
chmod +x ~/.config/ru-hypr/scripts/*
```

### Icons or glyphs look broken
Ensure a Nerd Font is installed and the font cache has been refreshed:
```bash
fc-list | grep -i "JetBrainsMono Nerd"
fc-cache -f
```

### Volume / Brightness OSD popups do not appear
Verify that `swayosd-server` is running:
```bash
pgrep -l swayosd-server
```
If not running, you can manually start it:
```bash
swayosd-server --config ~/.config/ru-hypr/swayosd/config.toml --style ~/.config/ru-hypr/swayosd/style.css &
```

### Colors do not update on wallpaper change
Ensure `wallust`, `awww`, and `imagemagick` are installed and reachable in your `$PATH`. Test manual execution:
```bash
~/.config/ru-hypr/scripts/set-wallpaper /path/to/your/image.jpg
```

### Live wallpaper is not playing or video fails to display
Ensure `mpvpaper`, `mpv`, and `ffmpeg` are installed:
```bash
which mpvpaper mpv ffmpeg
```
- **Arch Linux**: `sudo pacman -S mpv ffmpeg` and install `mpvpaper` via AUR (`yay -S mpvpaper` or `paru -S mpvpaper`).
- **Fedora**: `sudo dnf install mpv mpvpaper ffmpeg`.

---

## License

Personal Hyprland setup. Feel free to use, modify, and adapt to your own workflow.
