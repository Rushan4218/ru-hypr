# ru-hypr

A personal, modular [Hyprland](https://hyprland.org/) configuration targeting **Arch Linux** and **Fedora**, featuring coordinated dynamic theming via Wallust, Waybar status bar, Rofi application launcher, SwayNC notification center, SwayOSD on-screen display, Wlogout power menu, and automated workflow scripts.

---

## Highlights

- **One-Script Installation** — Automated setup script (`install.sh`) supporting **Arch Linux** and **Fedora**
- **Modular Hyprland Configuration** — Clean separation of concerns (monitors, keybinds, inputs, layout, autostart)
- **Dynamic Theming with Wallust** — Coordinated color palettes derived automatically from your active wallpaper
- **Full UI Integration** — Matched themes for Waybar, Rofi, SwayNC, SwayOSD, Wlogout, Kitty, and Hyprlock
- **Wallpaper & Animation Pickers** — Easy graphical selectors for wallpapers (`SUPER + W`) and animation presets (`SUPER + SHIFT + W`)
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
2. **Installs Packages**: Uses `pacman` (with `paru`/`yay` fallback) on Arch or `dnf` on Fedora to install all required dependencies.
3. **Clones or Updates Config**: Ensures the configuration is cloned to `~/.config/ru-hypr` (or updates existing checkout).
4. **Links Configuration**: Safely backs up any existing `~/.config/hypr/hyprland.conf` and symlinks `~/.config/ru-hypr/hyprland.conf` into place.
5. **Installs Fonts**: Automatically downloads and installs **JetBrainsMono Nerd Font** into `~/.local/share/fonts` and refreshes the font cache.
6. **Makes Scripts Executable**: Grants execution permissions to all helper scripts in `scripts/`.
7. **Reports Missing Packages**: Informs you if any distro-specific packages (such as `awww` or `wallust`) require manual or AUR/Cargo installation.

---

### Method 2: Manual Installation

If you prefer installing dependencies and setting up symlinks manually, follow these steps:

#### 1. Install Dependencies

##### On Arch Linux:
```bash
sudo pacman -S --needed \
  git hyprland hypridle hyprlock hyprpicker \
  waybar rofi kitty swaync wlogout \
  wallust awww jq cliphist wl-clipboard \
  brightnessctl wireplumber pavucontrol \
  imagemagick networkmanager bluez bluez-utils \
  grim slurp satty
```

> **Note**: If `awww` or `wallust` are not in the main Arch repositories on your system, install them from the AUR using an AUR helper (e.g. `yay -S awww wallust` or `paru -S awww wallust`). For SwayOSD, install `swayosd-git` from the AUR if desired.

##### On Fedora:
```bash
sudo dnf install -y \
  git hyprland hypridle hyprlock hyprpicker \
  waybar rofi kitty SwayNotificationCenter wlogout \
  wallust awww jq cliphist wl-clipboard \
  brightnessctl wireplumber pavucontrol \
  ImageMagick NetworkManager NetworkManager-tui bluez \
  grim slurp satty
```

> **Note**: On Fedora, `wallust`, `awww`, and `swayosd` may need to be installed via Copr or Cargo (`cargo install wallust` / build `awww` from source / `swayosd` via Copr).

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
Ensure **JetBrainsMono Nerd Font** is installed on your system:
```bash
mkdir -p ~/.local/share/fonts
curl -fsSL -o /tmp/jb.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
unzip -qo /tmp/jb.zip -d ~/.local/share/fonts/JetBrainsMonoNF
rm /tmp/jb.zip
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
| **Compositor & Session** | `hyprland`, `hypridle`, `hyprlock`, `hyprpicker`, `swayosd` |
| **Status, App Launcher & UI** | `waybar`, `rofi`, `kitty`, `swaync` (Fedora: `SwayNotificationCenter`), `wlogout` |
| **Theming & Wallpaper** | `wallust`, `awww`, `imagemagick` (Fedora: `ImageMagick`) |
| **Media, Audio & Brightness** | `wireplumber` (`wpctl`), `pavucontrol`, `brightnessctl` |
| **Screenshots & Clipboard** | `grim`, `slurp`, `satty`, `cliphist`, `wl-clipboard` |
| **System & Networking** | `networkmanager` (`NetworkManager-tui`), `bluez`, `bluez-utils`, `jq`, `git` |
| **Typography** | `JetBrainsMono Nerd Font` |

---

## Wallpaper and Theming Workflow

The default wallpaper directory is:
```text
~/Pictures/Wallpapers
```

### Set a Wallpaper Directly
```bash
~/.config/ru-hypr/scripts/set-wallpaper /absolute/path/to/image.jpg
```

### Open the Graphical Wallpaper Picker
Press `SUPER + W` or run:
```bash
~/.config/ru-hypr/scripts/wallpaper-picker
```

### Custom Wallpaper Directory
You can override the wallpaper directory by passing `WALLPAPER_DIR`:
```bash
WALLPAPER_DIR=/path/to/wallpapers ~/.config/ru-hypr/scripts/wallpaper-picker
```

### What Happens Automatically
When a wallpaper is selected, `set-wallpaper` triggers:
1. Smooth desktop background transition via `awww`
2. Color palette generation with **Wallust** based on wallpaper hues
3. Dynamic CSS / config injection for Waybar, SwayNC, SwayOSD, Wlogout, Rofi, and Kitty
4. Generation of a blurred lockscreen background for **Hyprlock**
5. Live reload of Hyprland, Waybar, and SwayNC so color changes appear immediately without restarting your session

---

## Keybindings

> `SUPER` is mapped to the **Windows / Command key**.

### Applications & Menus
| Keybind | Action |
| :--- | :--- |
| `SUPER + Q` | Launch Kitty terminal |
| `SUPER + R` | Open Rofi application launcher |
| `SUPER + E` | Open Thunar file manager |
| `SUPER + Escape` | Open Wlogout power menu |
| `SUPER + SHIFT + R` | Reload Hyprland configuration |

### Window Management
| Keybind | Action |
| :--- | :--- |
| `SUPER + C` | Close focused window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + P` | Toggle floating mode |
| `SUPER + H / J / K / L` | Move focus Left / Down / Up / Right (Vim-style) |
| `SUPER + Left Mouse Drag` | Move floating window |
| `SUPER + Right Mouse Drag` | Resize floating window |

### Workspaces
| Keybind | Action |
| :--- | :--- |
| `SUPER + 1` .. `0` | Switch to workspace 1–10 (mapped per active monitor) |
| `SUPER + SHIFT + 1` .. `0` | Move active window to workspace 1–10 |
| `SUPER + Scroll Down / Up` | Switch to next / previous workspace |

### Media & Brightness (SwayOSD)
| Keybind | Action |
| :--- | :--- |
| `XF86AudioRaiseVolume` | Increase volume (with OSD popup) |
| `XF86AudioLowerVolume` | Decrease volume (with OSD popup) |
| `XF86AudioMute` | Toggle audio mute |
| `XF86AudioMicMute` | Toggle microphone mute |
| `XF86MonBrightnessUp` | Increase display brightness (with OSD popup) |
| `XF86MonBrightnessDown` | Decrease display brightness (with OSD popup) |

### Utilities & Tools
| Keybind | Action |
| :--- | :--- |
| `SUPER + W` | Open wallpaper picker |
| `SUPER + SHIFT + W` | Open animation preset picker (End-4 Horizontal / Vertical / macOS) |
| `SUPER + V` | Open clipboard manager picker (`cliphist` + Rofi) |
| `SUPER + SHIFT + C` | Pick color from screen to clipboard (`hyprpicker`) |
| `PRINT` | Take fullscreen screenshot |
| `SUPER + PRINT` | Interactive region screenshot with annotation editor (`slurp` + `satty`) |

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

---

## License

Personal Hyprland setup. Feel free to use, modify, and adapt to your own workflow.
