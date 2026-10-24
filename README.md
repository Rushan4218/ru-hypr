# ru-hypr

Personal, modular Hyprland configuration designed to live in `~/.config/ru-hypr`.

## Highlights

- Split Hyprland config (`config/*.conf`) for easier maintenance
- Dynamic colors with `wallust` based on the current wallpaper
- Waybar, Rofi, SwayNC, Wlogout, Kitty, and Hyprlock themed together
- Utility scripts for wallpaper/animation picking, screenshots, and workspace routing

## Repository layout

- `hyprland.conf` — main entry point loaded by Hyprland
- `config/` — monitor/input/layout/keybind/autostart/rules
- `animations/` — animation presets and active preset include
- `scripts/` — helpers used by keybinds and status modules
- `waybar/`, `rofi/`, `swaync/`, `wlogout/`, `kitty/`, `hyprlock/`, `hypridle/` — app configs
- `wallust/` — template + palette generation config
- `generated/` — generated files (colors/lock background)

## Dependencies

Install the tools used by this setup:

- `hyprland`, `hypridle`, `hyprlock`, `hyprpicker`
- `waybar`, `rofi`, `kitty`, `swaync`, `wlogout`
- `awww`, `wallust`
- `jq`, `cliphist`, `wl-clipboard`
- `brightnessctl`, `wpctl` (PipeWire), `pavucontrol`
- `imagemagick` (`magick`), `nmtui` (NetworkManager), `bluetoothctl`

## Setup

1. Clone this repo to:
   - `~/.config/ru-hypr`
2. Point your Hyprland config to this repo entry point:
   - Add `source = ~/.config/ru-hypr/hyprland.conf` in `~/.config/hypr/hyprland.conf`
3. Reload Hyprland:
   - `hyprctl reload`

## Wallpaper and color workflow

- Set a wallpaper directly:
  - `~/.config/ru-hypr/scripts/set-wallpaper /absolute/path/to/image`
- Open wallpaper picker (default folder: `~/Pictures/Wallpapers`):
  - `~/.config/ru-hypr/scripts/wallpaper-picker`
- Optional custom wallpaper folder:
  - `WALLPAPER_DIR=/path/to/walls ~/.config/ru-hypr/scripts/wallpaper-picker`

`set-wallpaper` updates:
- Wayland wallpaper (`awww`)
- Generated Hyprlock background include
- Wallust palette (`generated/colors.conf`)
- Hyprland + Waybar reload

## Useful keybinds

- `SUPER + Q` → open Kitty
- `SUPER + R` → open Rofi app launcher
- `SUPER + SHIFT + R` → reload Hyprland
- `SUPER + V` → clipboard picker
- `SUPER + W` → wallpaper picker
- `PRINT` / `SUPER + PRINT` → full/region screenshot

## Notes

- This setup assumes monitor names like `eDP-1` and `HDMI-A-1` for workspace routing.
- Tweak monitor mapping in `scripts/workspace-switch.sh` if your outputs differ.
