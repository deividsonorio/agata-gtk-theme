
#!/usr/bin/env bash
set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
THEMES_DIR="${REPO_DIR}/themes"

DEST="${HOME}/.local/share/themes"
CONFIG_DIR="${HOME}/.config"
GTK4_CONFIG="${CONFIG_DIR}/gtk-4.0"

EDITION=""
VARIANT=""
ACTION=""
LIBADWAITA=0

THEMES=()
LINK_THEME=""

# --------------------------------------------------
# General functions
# --------------------------------------------------

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

info() {
    printf '\n%s\n' "$*"
}

is_agata_theme() {
    case "$1" in
        */Agata-Nord-Dark/gtk-4.0|*/Agata-Nord-Light/gtk-4.0|\
        */Agata-Gruvbox-Dark/gtk-4.0|*/Agata-Gruvbox-Light/gtk-4.0)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}


theme_name() {
    local edition="$1"
    local variant="$2"

    case "$edition" in
        nord)
            printf 'Agata-Nord-%s' "$variant"
            ;;
        gruvbox)
            printf 'Agata-Gruvbox-%s' "$variant"
            ;;
        *)
            fail "invalid edition: $edition"
            ;;
    esac
}

# --------------------------------------------------
# Help
# --------------------------------------------------

usage() {
    cat <<'EOF'
Agata GTK Theme Installer

Usage:
  ./install.sh
      Open interactive installer

  ./install.sh install nord both
      Install Nord Dark and Light

  ./install.sh install gruvbox dark
      Install Gruvbox Dark

  ./install.sh install nord light --libadwaita
      Install Nord Light with GTK 4 integration

  ./install.sh remove nord both
      Remove Nord Dark and Light

  ./install.sh remove gruvbox dark
      Remove Gruvbox Dark

  ./install.sh remove all
      Remove all Agata themes

  ./install.sh remove-libadwaita
      Remove GTK 4 integration and restore backup

Options:
  --libadwaita     Enable GTK 4 integration
  --dest DIR       Change installation directory
  --help           Show this help

Available editions:
  nord
  gruvbox

Available variants:
  dark
  light
  both

Default installation directory:
  ~/.local/share/themes

No compilation or sudo is required.
EOF
}

# --------------------------------------------------
# Interactive menus
# --------------------------------------------------

ask_choice() {
    local prompt="$1"
    local -n result="$2"
    shift 2

    local options=("$@")
    local answer
    local i

    printf '\n%s\n\n' "$prompt"

    for i in "${!options[@]}"; do
        printf '  %s) %s\n' "$((i + 1))" "${options[$i]}"
    done

    printf '\n'
    read -r -p "Choose [1-${#options[@]}]: " answer

    [[ "$answer" =~ ^[0-9]+$ ]] || fail "invalid selection"

    ((answer >= 1 && answer <= ${#options[@]})) ||
        fail "invalid selection"

    result="${options[$((answer - 1))]}"
}

interactive_menu() {
    local selection

    printf '\n'
    printf '%s\n' "================================"
    printf '%s\n' "      Agata GTK Theme Installer"
    printf '%s\n' "================================"
    printf '\n'
    printf '%s\n' \
        "  1) Install or update themes" \
        "  2) Remove themes" \
        "  3) Remove libadwaita integration" \
        "  0) Exit"

    printf '\n'
    read -r -p "Choose [0-3]: " selection

    case "$selection" in
        1) ACTION="install" ;;
        2) ACTION="remove" ;;
        3) ACTION="remove-libadwaita" ;;
        0)
            printf '\nNo changes made.\n'
            exit 0
            ;;
        *)
            fail "invalid selection"
            ;;
    esac

    [[ "$ACTION" == "remove-libadwaita" ]] && return

    if [[ "$ACTION" == "install" ]]; then
        ask_choice "Which Agata edition do you want?" EDITION \
            "nord" "gruvbox"

        ask_choice "Which variant do you want to install?" VARIANT \
            "dark" "light" "both"

        printf '\n'
        read -r -p "Enable GTK 4 / libadwaita integration? [y/N]: " answer

        case "${answer,,}" in
            y|yes) LIBADWAITA=1 ;;
            *) LIBADWAITA=0 ;;
        esac
    else
        ask_choice "Which edition do you want to remove?" EDITION \
            "nord" "gruvbox" "all"

        if [[ "$EDITION" != "all" ]]; then
            ask_choice "Which variant do you want to remove?" VARIANT \
                "dark" "light" "both"
        fi
    fi
}

# --------------------------------------------------
# Build theme list
# --------------------------------------------------

build_theme_list() {
    local editions=()
    local variants=()

    THEMES=()

    if [[ "$EDITION" == "all" ]]; then
        editions=("nord" "gruvbox")
    else
        editions=("$EDITION")
    fi

    case "$VARIANT" in
        dark) variants=("Dark") ;;
        light) variants=("Light") ;;
        both) variants=("Dark" "Light") ;;
        *) fail "invalid variant: $VARIANT" ;;
    esac

    local edition
    local variant

    for edition in "${editions[@]}"; do
        for variant in "${variants[@]}"; do
            THEMES+=("$(theme_name "$edition" "$variant")")
        done
    done
}

# --------------------------------------------------
# GTK 4 / libadwaita integration
# --------------------------------------------------

unlink_libadwaita() {
    local current_target=""
    local backup=""

    if [[ -L "$GTK4_CONFIG" ]]; then
        current_target="$(readlink -f -- "$GTK4_CONFIG" 2>/dev/null || true)"

        if is_agata_theme "$current_target"; then
            rm -- "$GTK4_CONFIG"
            printf 'Removed Agata GTK 4 link.\n'
        else
            printf 'GTK 4 link does not point to Agata. Leaving it untouched.\n'
            return 0
        fi
    elif [[ -e "$GTK4_CONFIG" ]]; then
        printf 'GTK 4 configuration is not an Agata link. Leaving it untouched.\n'
        return 0
    else
        printf 'No GTK 4 configuration link found.\n'
    fi

    # Restore the newest available backup.
    shopt -s nullglob
    local backups=("${GTK4_CONFIG}".backup-*)
    shopt -u nullglob

    if ((${#backups[@]})); then
        backup="${backups[-1]}"

        if [[ ! -e "$GTK4_CONFIG" && ! -L "$GTK4_CONFIG" ]]; then
            mv -- "$backup" "$GTK4_CONFIG"
            printf 'Restored backup: %s\n' "$GTK4_CONFIG"
        fi
    fi
}

choose_libadwaita_theme() {
    if ((${#THEMES[@]} == 1)); then
        LINK_THEME="${THEMES[0]}"
        return
    fi

    printf '\nWhich installed variant should GTK 4 use?\n\n'

    local i
    for i in "${!THEMES[@]}"; do
        printf '  %s) %s\n' "$((i + 1))" "${THEMES[$i]}"
    done

    local answer
    read -r -p "Choose [1-${#THEMES[@]}]: " answer

    [[ "$answer" =~ ^[0-9]+$ ]] || fail "invalid selection"
    ((answer >= 1 && answer <= ${#THEMES[@]})) ||
        fail "invalid selection"

    LINK_THEME="${THEMES[$((answer - 1))]}"
}

link_libadwaita() {
    local source
    local old_target
    local backup

    choose_libadwaita_theme

    source="${DEST%/}/${LINK_THEME}/gtk-4.0"

    [[ -d "$source" ]] ||
        fail "GTK 4 theme directory not found: $source"

    mkdir -p -- "$CONFIG_DIR"

    if [[ -e "$GTK4_CONFIG" || -L "$GTK4_CONFIG" ]]; then
        if [[ -L "$GTK4_CONFIG" ]]; then
            old_target="$(readlink -f -- "$GTK4_CONFIG" 2>/dev/null || true)"

            if is_agata_theme "$old_target"; then
                rm -- "$GTK4_CONFIG"
            else
                backup="${GTK4_CONFIG}.backup-$(date +%Y%m%d-%H%M%S)"
                mv -- "$GTK4_CONFIG" "$backup"
                printf 'Existing GTK 4 link backed up.\n'
            fi
        else
            backup="${GTK4_CONFIG}.backup-$(date +%Y%m%d-%H%M%S)"
            mv -- "$GTK4_CONFIG" "$backup"
            printf 'Existing GTK 4 configuration backed up.\n'
        fi
    fi

    ln -s -- "$source" "$GTK4_CONFIG"

    printf '\nGTK 4 integration enabled.\n'
    printf 'Linked: %s -> %s\n' "$GTK4_CONFIG" "$source"
    printf '\n'
    printf '%s\n' \
        "Note: Some libadwaita applications may ignore third-party styling."
}


# --------------------------------------------------
# GNOME Shell 50+ compatibility
# --------------------------------------------------

detect_gnome_shell_version() {
    local version

    AGATA_GNOME_SHELL_MAJOR=""

    if ! command -v gnome-shell >/dev/null 2>&1; then
        printf 'GNOME Shell: not detected; GNOME 50+ patch will not be applied.\n'
        export AGATA_GNOME_SHELL_MAJOR=""
        return 0
    fi

    version="$(gnome-shell --version 2>/dev/null || true)"
    AGATA_GNOME_SHELL_MAJOR="$(printf '%s\n' "$version" | sed -nE 's/.*GNOME Shell[[:space:]]+([0-9]+).*/\1/p')"

    if [[ -n "$AGATA_GNOME_SHELL_MAJOR" ]]; then
        printf 'GNOME Shell detected: %s\n' "$AGATA_GNOME_SHELL_MAJOR"
    else
        printf 'GNOME Shell version could not be detected; GNOME 50+ patch will not be applied.\n'
    fi

    export AGATA_GNOME_SHELL_MAJOR
}

apply_gnome_shell_50_patch() {
    local theme_dir="$1"
    local theme_name
    local shell_css="${theme_dir}/gnome-shell/gnome-shell.css"
    local patch_file

    theme_name="$(basename "$theme_dir")"
    patch_file="${REPO_DIR}/patches/gnome-shell-50/${theme_name}.css"

    if [[ -n "$AGATA_GNOME_SHELL_MAJOR" &&
          "$AGATA_GNOME_SHELL_MAJOR" -ge 50 &&
          -f "$shell_css" &&
          -f "$patch_file" ]]; then
        {
            printf '\n\n'
            cat "$patch_file"
        } >> "$shell_css"

        printf 'Applied GNOME Shell 50+ compatibility patch: %s\n' "$theme_name"
    elif [[ -n "$AGATA_GNOME_SHELL_MAJOR" &&
            "$AGATA_GNOME_SHELL_MAJOR" -lt 50 ]]; then
        printf 'GNOME Shell %s: keeping standard Agata shell styling (no GNOME 50+ patch).\n' \
            "$AGATA_GNOME_SHELL_MAJOR"
    fi
}

# --------------------------------------------------
# Installation
# --------------------------------------------------

install_themes() {
    local theme
    local source
    local target
    local temp

    [[ -d "$THEMES_DIR" ]] ||
        fail "themes directory not found: $THEMES_DIR"

    [[ -n "$DEST" && "$DEST" != "/" ]] ||
        fail "unsafe destination directory: $DEST"

    mkdir -p -- "$DEST"

    for theme in "${THEMES[@]}"; do
        source="${THEMES_DIR}/${theme}"
        target="${DEST%/}/${theme}"
        temp="${DEST%/}/.${theme}.install.$$"

        [[ -d "$source" ]] ||
            fail "theme not found: $source"

        [[ -f "${source}/index.theme" ]] ||
            fail "missing index.theme in $source"

        [[ -f "${source}/gtk-3.0/gtk.css" ]] ||
            fail "missing GTK 3 stylesheet in $source"

        [[ -f "${source}/gtk-4.0/gtk.css" ]] ||
            fail "missing GTK 4 stylesheet in $source"

        rm -rf -- "$temp"
        cp -a -- "$source" "$temp"

        rm -rf -- "$target"
        mv -- "$temp" "$target"

        apply_gnome_shell_50_patch "$target"

        printf 'Installed: %s\n' "$target"
    done

    if ((LIBADWAITA)); then
        link_libadwaita
    fi

    printf '\nInstallation completed successfully.\n'
    printf 'If necessary, log out and back in to apply the theme.\n'
}

# --------------------------------------------------
# Removal
# --------------------------------------------------

remove_themes() {
    local theme
    local target

    for theme in "${THEMES[@]}"; do
        target="${DEST%/}/${theme}"

        if [[ -d "$target" || -L "$target" ]]; then
            rm -rf -- "$target"
            printf 'Removed: %s\n' "$target"
        else
            printf 'Not found, skipping: %s\n' "$target"
        fi
    done

    printf '\nRemoval completed.\n'
}

# --------------------------------------------------
# Argument parsing
# --------------------------------------------------

if (($# == 0)); then
    interactive_menu
else
    ACTION="$1"
    shift

    case "$ACTION" in
        install|remove)
            (($# >= 1)) || fail "missing edition"

            EDITION="$1"
            shift

            if [[ "$EDITION" != "all" ]]; then
                (($# >= 1)) || fail "missing variant"
                VARIANT="$1"
                shift
            fi

            while (($#)); do
                case "$1" in
                    --libadwaita)
                        LIBADWAITA=1
                        shift
                        ;;
                    --dest)
                        (($# >= 2)) || fail "missing directory after --dest"
                        DEST="$2"
                        shift 2
                        ;;
                    *)
                        fail "unknown option: $1"
                        ;;
                esac
            done

            [[ "$EDITION" == "nord" ||
               "$EDITION" == "gruvbox" ||
               "$EDITION" == "all" ]] ||
                fail "edition must be nord, gruvbox or all"

            if [[ "$ACTION" == "install" && "$EDITION" == "all" ]]; then
                fail "install all is not supported; choose nord or gruvbox"
            fi

            if [[ "$EDITION" != "all" ]]; then
                [[ "$VARIANT" == "dark" ||
                   "$VARIANT" == "light" ||
                   "$VARIANT" == "both" ]] ||
                    fail "variant must be dark, light or both"
            fi

            if [[ "$ACTION" == "remove" && "$LIBADWAITA" == 1 ]]; then
                fail "--libadwaita cannot be used with remove"
            fi
            ;;
        remove-libadwaita)
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            fail "unknown command: $ACTION (use --help)"
            ;;
    esac
fi

detect_gnome_shell_version

# --------------------------------------------------
# Execute
# --------------------------------------------------

case "$ACTION" in
    install)
        build_theme_list
        install_themes
        ;;
    remove)
        if [[ "$EDITION" == "all" ]]; then
            THEMES=(
                "Agata-Nord-Dark"
                "Agata-Nord-Light"
                "Agata-Gruvbox-Dark"
                "Agata-Gruvbox-Light"
            )
        else
            build_theme_list
        fi
        remove_themes
        ;;
    remove-libadwaita)
        unlink_libadwaita
        ;;
    *)
        fail "invalid action"
        ;;
esac
