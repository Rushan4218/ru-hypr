# ru-hypr

Personal, modular [Hyprland](https://hyprland.org/) configuration for Arch Linux, with coordinated themes, dynamic wallpaper colors, Waybar, Rofi, SwayNC, and utility scripts.

## Highlights

- Modular Hyprland configuration for easier maintenance
- Dynamic colors generated with **Wallust** from the current wallpaper
- Coordinated themes for Waybar, Rofi, SwayNC, Wlogout, Kitty, and Hyprlock
- Wallpaper picker with automatic color and background updates
- Animation presets
- Clipboard history and picker
- Screenshot utilities
- Wi-Fi, Bluetooth, and GPU status scripts
- Custom power menu and lock screen
- Workspace routing and multi-monitor configuration

## Repository layout

```text
ru-hypr/
├── hyprland.conf
├── config/
│   ├── autostart.conf
│   ├── input.conf
│   ├── keybinds.conf
│   ├── layout.conf
│   └── monitors.conf
├── animations/
├── scripts/
├── waybar/
├── rofi/
├── swaync/
├── wlogout/
├── kitty/
├── hyprlock/
├── hypridle/
├── wallust/
└── generated/
```

- `hyprland.conf` — main Hyprland configuration
- `config/` — input, layout, monitor, keybind, and autostart settings
- `animations/` — animation presets
- `scripts/` — helper scripts used by keybinds and status modules
- `waybar/` — status bar configuration and styling
- `rofi/` — application launcher and picker themes
- `swaync/` — notification center configuration and styling
- `wlogout/` — logout and power menu layout and styling
- `kitty/` — terminal configuration
- `hyprlock/` — lock screen configuration
- `hypridle/` — idle and screen-lock behavior
- `wallust/` — wallpaper-based color generation templates
- `generated/` — generated colors and background files

## Dependencies

Install the applications and utilities used by the configuration.

### Core applications

- [Hyprland](https://hyprland.org/)
- `hypridle`
- `hyprlock`
- `hyprpicker`
- `waybar`
- `rofi`
- `kitty`
- `swaync`
- `wlogout`

### Wallpaper and theming

- `awww`
- `wallust`
- `imagemagick`

### Utilities

- `git`
- `jq`
- `cliphist`
- `wl-clipboard`
- `brightnessctl`
- `wireplumber` — provides `wpctl`
- `pavucontrol`
- `networkmanager` — provides `nmtui`
- `bluez`
- `bluez-utils` — provides `bluetoothctl`

### Install packages on Arch Linux

```bash
sudo pacman -S \
  git hyprland hypridle hyprlock hyprpicker \
  waybar rofi kitty swaync wlogout \
  wallust jq cliphist wl-clipboard \
  brightnessctl wireplumber pavucontrol \
  imagemagick networkmanager bluez bluez-utils
```

Enable NetworkManager if you use it for networking:

```bash
sudo systemctl enable --now NetworkManager
```

Install `awww` separately if it is not available in your enabled repositories. It may need to be installed from the AUR using an AUR helper.

Some applications or services may be optional depending on which features you use.

## Setup

### 1. Clone the repository

Clone the repository into `~/.config/ru-hypr`:

```bash
git clone https://github.com/Rushan4218/ru-hypr.git ~/.config/ru-hypr
```

### 2. Back up your existing Hyprland configuration

If `~/.config/hypr` already exists, back it up before creating the symlink:

```bash
mv ~/.config/hypr ~/.config/hypr.backup
```

**Skip this command if `~/.config/hypr` does not exist.** If you already have a symlink at that path, check where it points before moving it.

### 3. Create the symlink

```bash
ln -s ~/ru-hypr ~/.config/hypr
```

This links Hyprland's standard configuration path to the repository. You can continue editing the files in `~/ru-hypr`, and the changes will be reflected through the symlink.

### 4. Start Hyprland

Log out and select **Hyprland** from your display manager.

To reload the configuration after making changes:

```bash
hyprctl reload
```

> **Note:** The symlink connects the configuration files; it does not install dependencies or automatically configure your hardware.

## Wallpaper and color workflow

The default wallpaper directory is:

```text
~/Pictures/Wallpapers
```

### Set a wallpaper directly

```bash
~/.config/ru-hypr/scripts/set-wallpaper /absolute/path/to/image
```

Use an absolute path to the image file.

### Open the wallpaper picker

```bash
~/.config/ru-hypr/scripts/wallpaper-picker
```

### Use a custom wallpaper directory

```bash
WALLPAPER_DIR=/path/to/walls ~/.config/ru-hypr/scripts/wallpaper-picker
```

When supported by the current setup, `set-wallpaper` updates:

- The desktop wallpaper through `awww`
- The generated Hyprlock background
- The Wallust color palette in `generated/colors.conf`
- Hyprland and Waybar so the new colors take effect

## Useful keybinds

| Keybind             | Action                             |
| ------------------- | ---------------------------------- |
| `SUPER + Q`         | Open Kitty                         |
| `SUPER + R`         | Open the Rofi application launcher |
| `SUPER + SHIFT + R` | Reload Hyprland                    |
| `SUPER + V`         | Open the clipboard picker          |
| `SUPER + W`         | Open the wallpaper picker          |
| `PRINT`             | Take a full-screen screenshot      |
| `SUPER + PRINT`     | Take a region screenshot           |

`SUPER` usually means the **Windows key**. Check `config/keybinds.conf` for the current keybinds and additional actions.

## Customization

### Monitor configuration

Monitor settings are defined in:

```text
config/monitors.conf
```

Update this file to match your monitor names, resolutions, refresh rates, and arrangement.

### Workspace routing

Some workspace behavior may assume monitor names such as `eDP-1` and `HDMI-A-1`.

If your outputs have different names, update:

```text
scripts/workspace-switch.sh
```

Check your actual monitor names with:

```bash
hyprctl monitors
```

### Input settings

Adjust keyboard, mouse, touchpad, and related options in:

```text
config/input.conf
```

### Keybinds

Edit:

```text
config/keybinds.conf
```

Reload Hyprland after changing the configuration.

### Animations

Check the files in `animations/` to customize animation presets and the active preset include.

### Themes and colors

The application themes are stored in their respective directories. Wallpaper-derived colors and other generated files may be overwritten when the wallpaper or Wallust palette is regenerated.

## Troubleshooting

### Hyprland does not load the configuration

Check that the symlink points to the repository:

```bash
ls -l ~/.config/hypr
```

It should point to `~/ru-hypr`.

Confirm that the main configuration exists:

```bash
ls ~/ru-hypr/hyprland.conf
```

### A script does not run

Make sure the script exists and is executable:

```bash
ls -l ~/.config/ru-hypr/scripts/
```

If needed, make a specific script executable:

```bash
chmod +x ~/.config/ru-hypr/scripts/script-name
```

Replace `script-name` with the actual filename.

### Wallpaper or generated colors do not update

Check that `awww`, `wallust`, and `imagemagick` are installed and that the wallpaper path is valid.

### A monitor or workspace behaves incorrectly

Check your monitor names:

```bash
hyprctl monitors
```

Then update `config/monitors.conf` and, if needed, `scripts/workspace-switch.sh`.

## Notes

- This configuration is designed for Arch Linux and Hyprland.
- Monitor names and hardware-specific settings may need adjustment.
- Install the dependencies required by the features you intend to use.
- Back up your existing configuration before replacing it with the symlink.
- Generated colors and wallpaper files may change when you regenerate the theme.

## License

See the repository for license information.
