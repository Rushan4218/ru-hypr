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
ARCH_PKGS=(git hyprland hyprland-guiutils xdg-desktop-portal-hyprland hypridle hyprlock hyprpicker waybar rofi kitty
  swaync swayosd wlogout jq cliphist wl-clipboard brightnessctl
  wireplumber pavucontrol imagemagick networkmanager bluez bluez-utils
  grim slurp satty mpv mpvpaper ffmpeg
  # needed to build wallust and awww
  rust pkgconf wayland wayland-protocols lz4)

FEDORA_PKGS=(git hyprland hyprland-guiutils xdg-desktop-portal-hyprland hypridle hyprlock hyprpicker waybar rofi kitty
  SwayNotificationCenter swayosd wlogout jq cliphist wl-clipboard
  brightnessctl wireplumber pavucontrol ImageMagick NetworkManager
  NetworkManager-tui bluez grim slurp satty mpv mpvpaper ffmpeg
  # needed to build wallust and awww
  rustc cargo pkgconf-pkg-config wayland-devel wayland-protocols-devel lz4-devel)

# Helpful guidance when a package cannot be installed automatically
hint() {
    case "$1" in
        mpvpaper) echo "https://github.com/GhostNaN/mpvpaper (AUR: mpvpaper, or build from source)" ;;
        wallust)  echo "https://codeberg.org/explosion-mental/wallust (or: cargo install wallust)" ;;
        awww)     echo "https://codeberg.org/LGFae/awww (or build with cargo)" ;;
        swayosd)  echo "https://github.com/ErikReider/SwayOSD (AUR: swayosd-git / Copr)" ;;
        *)        echo "check your distro's repositories or project page" ;;
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

# Fedora: Hyprland comes from a COPR repo
if [ "$FAMILY" = fedora ]; then
    say "Enabling Hyprland COPR (nett00n/hyprland)"
    sudo dnf install -y dnf-plugins-core >/dev/null 2>&1
    sudo dnf copr enable -y nett00n/hyprland \
        || FAILED+=("COPR repo nett00n/hyprland (run: sudo dnf copr enable nett00n/hyprland)")
fi

for p in "${PKGS[@]}"; do
    say "Installing $p"
    install_pkg "$p" || FAILED+=("$p")
done

# ---------- Build wallust and awww with Rust (Arch and Fedora) ----------
if [ "$FAMILY" != other ]; then
    say "Building wallust and awww"
    export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
    if command -v cargo >/dev/null; then
        command -v wallust >/dev/null || cargo install wallust || FAILED+=("wallust")
        if ! command -v awww >/dev/null; then
            src="$(mktemp -d)"
            if git clone --depth 1 https://codeberg.org/LGFae/awww.git "$src/awww" \
               && (cd "$src/awww" && cargo build --release); then
                mkdir -p "$HOME/.local/bin"
                install -m755 "$src/awww/target/release/awww" \
                              "$src/awww/target/release/awww-daemon" "$HOME/.local/bin/" \
                    || FAILED+=("awww")
            else
                FAILED+=("awww")
            fi
            rm -rf "$src"
        fi
    else
        FAILED+=("wallust" "awww")
        echo "cargo is missing, so wallust and awww could not be built." >&2
    fi
fi

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

# JetBrainsMono Nerd Font
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

# Material Symbols Rounded (variable font)
if command -v curl >/dev/null; then
    if ! fc-list 2>/dev/null | grep -qi "Material Symbols Rounded"; then
        curl -fL \
            "https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsRounded%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf" \
            -o "$FONT_DIR/MaterialSymbolsRounded.ttf" \
            || FAILED+=("Material Symbols Rounded font")
    fi
else
    FAILED+=("Material Symbols Rounded font (needs curl)")
fi

# Copy any additional bundled fonts
[ -d "$DEST/fonts" ] && cp -r "$DEST/fonts/." "$FONT_DIR/"

# Refresh font cache
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
