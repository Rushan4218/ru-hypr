#!/usr/bin/env bash
set -u

REPO="https://github.com/Rushan4218/ru-hypr.git"
DEST="$HOME/.config/ru-hypr"
HYPR_DIR="$HOME/.config/hypr"
FONT_DIR="$HOME/.local/share/fonts"
FAILED=()

say() { printf '\n==> %s\n' "$*"; }

# ---------- Detect distro ----------
. /etc/os-release
case " ${ID:-} ${ID_LIKE:-} " in
    *" arch "*)   FAMILY=arch ;;
    *" fedora "*) FAMILY=fedora ;;
    *)            FAMILY=other ;;
esac
say "Detected distro family: $FAMILY"

# ---------- Package lists ----------
ARCH_PKGS=(git hyprland hypridle hyprlock hyprpicker waybar rofi kitty
  swaync wlogout wallust awww jq cliphist wl-clipboard brightnessctl
  wireplumber pavucontrol imagemagick networkmanager bluez bluez-utils
  grim slurp satty)

FEDORA_PKGS=(git hyprland hypridle hyprlock hyprpicker waybar rofi kitty
  SwayNotificationCenter wlogout wallust awww jq cliphist wl-clipboard
  brightnessctl wireplumber pavucontrol ImageMagick NetworkManager
  NetworkManager-tui bluez grim slurp satty)

# Where to look when a package can't be installed automatically
hint() {
    case "$1" in
        awww)    echo "https://codeberg.org/LGFae/awww (AUR on Arch, or build with cargo)" ;;
        wallust) echo "https://codeberg.org/explosion-mental/wallust (or: cargo install wallust)" ;;
        *)       echo "search your distro's repos / the project page" ;;
    esac
}

install_pkg() {
    case "$FAMILY" in
        arch)
            sudo pacman -S --needed --noconfirm "$1" >/dev/null 2>&1 && return 0
            for helper in paru yay; do
                command -v "$helper" >/dev/null && \
                    "$helper" -S --needed --noconfirm "$1" && return 0
            done
            return 1 ;;
        fedora)
            sudo dnf install -y "$1" ;;
    esac
}

# ---------- Install packages ----------
case "$FAMILY" in
    arch)   PKGS=("${ARCH_PKGS[@]}") ;;
    fedora) PKGS=("${FEDORA_PKGS[@]}") ;;
    other)
        PKGS=()
        say "Your distro isn't supported by the auto-installer."
        say "Install the packages listed in the README yourself."
        command -v git >/dev/null || { echo "git is required."; exit 1; } ;;
esac

[ ${#PKGS[@]} -gt 0 ] && sudo -v

for p in "${PKGS[@]}"; do
    say "Installing $p"
    install_pkg "$p" || FAILED+=("$p")
done

# ---------- Clone or update the config ----------
say "Fetching configuration"
if [ -d "$DEST/.git" ]; then
    git -C "$DEST" pull --ff-only
elif [ -e "$DEST" ]; then
    echo "$DEST exists but is not a git repo. Move it and re-run." >&2
    exit 1
else
    mkdir -p "$HOME/.config"
    git clone --depth 1 "$REPO" "$DEST" || exit 1
fi
chmod +x "$DEST"/scripts/* 2>/dev/null

# ---------- Symlink hyprland.conf ----------
say "Linking hyprland.conf"
if [ -L "$HYPR_DIR" ]; then
    echo "$HYPR_DIR is a symlink to a folder. Remove it first, then re-run." >&2
    exit 1
fi
mkdir -p "$HYPR_DIR"
TARGET="$HYPR_DIR/hyprland.conf"
if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    if [ "$(readlink -f "$TARGET")" != "$(readlink -f "$DEST/hyprland.conf")" ]; then
        mv "$TARGET" "$TARGET.backup.$(date +%s)"
        echo "Existing hyprland.conf backed up next to it."
    fi
fi
ln -sfn "$DEST/hyprland.conf" "$TARGET"

# ---------- Fonts ----------
say "Installing fonts"
mkdir -p "$FONT_DIR"
if ! fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd"; then
    if command -v curl >/dev/null && command -v unzip >/dev/null; then
        tmp=$(mktemp -d)
        curl -fsSL -o "$tmp/jb.zip" \
          "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
          && unzip -qo "$tmp/jb.zip" -d "$FONT_DIR/JetBrainsMonoNF" \
          || FAILED+=("JetBrainsMono Nerd Font")
        rm -rf "$tmp"
    else
        FAILED+=("JetBrainsMono Nerd Font (needs curl and unzip)")
    fi
fi
[ -d "$DEST/fonts" ] && cp -r "$DEST/fonts/." "$FONT_DIR/"
fc-cache -f

# ---------- Summary ----------
say "Configuration installed."
if [ ${#FAILED[@]} -gt 0 ]; then
    echo
    echo "Your Hyprland setup is ready, but these packages could not be"
    echo "installed automatically. Please install them yourself:"
    echo
    for f in "${FAILED[@]}"; do
        echo "  - $f"
        echo "      $(hint "${f%% *}")"
    done
    echo
    echo "Features that need them will start working as soon as they are installed."
    echo "Run ~/.config/ru-hypr/scripts/check-deps any time to see what's still missing."
else
    echo "All dependencies installed."
fi
echo "Log out and choose Hyprland from your display manager."
