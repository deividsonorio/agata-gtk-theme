#!/usr/bin/env bash
set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
THEMES_DIR="${REPO_DIR}/themes"
DEST="${HOME}/.local/share/themes"
CHOICE=""
UNINSTALL=0
LIBADWAITA=0
UNLINK_LIBADWAITA=0

usage() {
  cat <<'EOF'
Agata GTK Theme Installer

Usage:
  ./install.sh                         Interactive menu
  ./install.sh --dark                   Install Agata-Dark
  ./install.sh --light                  Install Agata-Light
  ./install.sh --both                   Install both variants
  ./install.sh --dark --libadwaita      Install Dark and link GTK 4 config
  ./install.sh --light --libadwaita     Install Light and link GTK 4 config
  ./install.sh --uninstall dark|light|both
  ./install.sh --unlink-libadwaita      Remove Agata GTK 4 config link
  ./install.sh --dest DIR               Set theme installation directory
  ./install.sh --help                   Show this help

Default theme directory:
  ~/.local/share/themes

Optional GTK 4/libadwaita integration:
  --libadwaita links the selected variant's gtk-4.0 directory to:
  ~/.config/gtk-4.0

If ~/.config/gtk-4.0 already exists, it is moved to a timestamped
backup before the link is created. Use --unlink-libadwaita to remove
the Agata link and restore the newest available backup.

No compilation or sudo is required.
EOF
}

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

while (($#)); do
  case "$1" in
    --dark|-d) CHOICE="dark"; shift ;;
    --light|-l) CHOICE="light"; shift ;;
    --both|-b) CHOICE="both"; shift ;;
    --dest)
      (($# >= 2)) || fail "missing directory after --dest"
      DEST="$2"
      shift 2
      ;;
    --uninstall|-u)
      (($# >= 2)) || fail "use --uninstall dark|light|both"
      UNINSTALL=1
      CHOICE="$2"
      shift 2
      ;;
    --libadwaita|-l4)
      LIBADWAITA=1
      shift
      ;;
    --unlink-libadwaita)
      UNLINK_LIBADWAITA=1
      shift
      ;;
    --help|-h) usage; exit 0 ;;
    *) fail "unknown option: $1 (use --help)" ;;
  esac
done

CONFIG_DIR="${HOME}/.config"
GTK4_CONFIG="${CONFIG_DIR}/gtk-4.0"

unlink_libadwaita() {
  local backup
  if [[ -L "$GTK4_CONFIG" ]]; then
    local current_target
    current_target="$(readlink -f -- "$GTK4_CONFIG" 2>/dev/null || true)"
    case "$current_target" in
      */Agata-Dark/gtk-4.0|*/Agata-Light/gtk-4.0)
        rm -- "$GTK4_CONFIG"
        printf 'Removed Agata GTK 4 link: %s\n' "$GTK4_CONFIG"
        ;;
      *)
        printf 'The GTK 4 config link does not point to Agata; leaving it untouched.\n'
        return 0
        ;;
    esac
  elif [[ -e "$GTK4_CONFIG" ]]; then
    printf 'No Agata symlink found at %s; leaving it untouched.\n' "$GTK4_CONFIG"
    return 0
  else
    printf 'No GTK 4 config link found.\n'
  fi

  backup="$(find "$CONFIG_DIR" -maxdepth 1 -mindepth 1 -name 'gtk-4.0.backup-*' -printf '%f\n' 2>/dev/null | sort | tail -n 1 || true)"
  if [[ -n "$backup" && ! -e "$GTK4_CONFIG" && ! -L "$GTK4_CONFIG" ]]; then
    mv -- "${CONFIG_DIR}/${backup}" "$GTK4_CONFIG"
    printf 'Restored backup: %s\n' "$GTK4_CONFIG"
  fi
}

if ((UNLINK_LIBADWAITA)); then
  unlink_libadwaita
  exit 0
fi

if [[ -z "$CHOICE" ]]; then
  printf '%s\n' \
    "Agata — GTK Theme Installer" \
    "" \
    "  1) Install Agata-Dark" \
    "  2) Install Agata-Light" \
    "  3) Install both variants" \
    "  4) Install Agata-Dark + libadwaita integration" \
    "  5) Install Agata-Light + libadwaita integration" \
    "  6) Install both + choose libadwaita variant" \
    "  7) Remove Agata-Dark" \
    "  8) Remove Agata-Light" \
    "  9) Remove libadwaita integration" \
    " 10) Exit"
  read -r -p "Choose [1-10]: " answer
  case "$answer" in
    1) CHOICE="dark" ;;
    2) CHOICE="light" ;;
    3) CHOICE="both" ;;
    4) CHOICE="dark"; LIBADWAITA=1 ;;
    5) CHOICE="light"; LIBADWAITA=1 ;;
    6) CHOICE="both"; LIBADWAITA=1 ;;
    7) CHOICE="dark"; UNINSTALL=1 ;;
    8) CHOICE="light"; UNINSTALL=1 ;;
    9) unlink_libadwaita; exit 0 ;;
    10) printf 'No changes made.\n'; exit 0 ;;
    *) printf 'Invalid choice. No changes made.\n'; exit 1 ;;
  esac
fi

case "$CHOICE" in
  dark) THEMES=("Agata-Dark") ;;
  light) THEMES=("Agata-Light") ;;
  both) THEMES=("Agata-Dark" "Agata-Light") ;;
  *) fail "invalid variant: $CHOICE (use dark, light, or both)" ;;
esac

if ((LIBADWAITA && UNINSTALL)); then
  fail "--libadwaita cannot be combined with --uninstall; use --unlink-libadwaita separately"
fi

if ((UNINSTALL)); then
  for theme in "${THEMES[@]}"; do
    target="${DEST%/}/${theme}"
    if [[ -d "$target" || -L "$target" ]]; then
      rm -rf -- "$target"
      printf 'Removed: %s\n' "$target"
    else
      printf 'Not found, skipping: %s\n' "$target"
    fi
  done
  exit 0
fi

[[ -d "$THEMES_DIR" ]] || fail "themes directory not found: $THEMES_DIR"
[[ -n "$DEST" && "$DEST" != "/" ]] || fail "unsafe destination directory: $DEST"

mkdir -p -- "$DEST"

for theme in "${THEMES[@]}"; do
  source_dir="${THEMES_DIR}/${theme}"
  target_dir="${DEST%/}/${theme}"
  [[ -d "$source_dir" ]] || fail "theme not found in repository: $source_dir"
  [[ -f "${source_dir}/index.theme" ]] || fail "missing index.theme in $source_dir"
  [[ -f "${source_dir}/gtk-3.0/gtk.css" ]] || fail "missing GTK 3 stylesheet in $source_dir"
  [[ -f "${source_dir}/gtk-4.0/gtk.css" ]] || fail "missing GTK 4 stylesheet in $source_dir"

  temp_dir="${DEST%/}/.${theme}.install.$$"
  rm -rf -- "$temp_dir"
  cp -a -- "$source_dir" "$temp_dir"
  rm -rf -- "$target_dir"
  mv -- "$temp_dir" "$target_dir"
  printf 'Installed: %s\n' "$target_dir"
done

if ((LIBADWAITA)); then
  if [[ "$CHOICE" == "both" ]]; then
    printf '\nBoth variants were installed. Which GTK 4 stylesheet should be linked?\n'
    printf '  1) Agata-Dark\n  2) Agata-Light\n'
    read -r -p "Choose [1-2]: " link_choice
    case "$link_choice" in
      1) LINK_THEME="Agata-Dark" ;;
      2) LINK_THEME="Agata-Light" ;;
      *) fail "invalid choice; themes were installed, but no GTK 4 link was created" ;;
    esac
  else
    LINK_THEME="${THEMES[0]}"
  fi

  LINK_SOURCE="${DEST%/}/${LINK_THEME}/gtk-4.0"
  [[ -d "$LINK_SOURCE" ]] || fail "GTK 4 theme directory not found: $LINK_SOURCE"
  mkdir -p -- "$CONFIG_DIR"

  if [[ -e "$GTK4_CONFIG" || -L "$GTK4_CONFIG" ]]; then
    if [[ -L "$GTK4_CONFIG" ]]; then
      old_target="$(readlink -f -- "$GTK4_CONFIG" 2>/dev/null || true)"
      case "$old_target" in
        */Agata-Dark/gtk-4.0|*/Agata-Light/gtk-4.0)
          rm -- "$GTK4_CONFIG"
          ;;
        *)
          backup="${GTK4_CONFIG}.backup-$(date +%Y%m%d-%H%M%S)"
          mv -- "$GTK4_CONFIG" "$backup"
          printf 'Existing GTK 4 symlink backed up to: %s\n' "$backup"
          ;;
      esac
    else
      backup="${GTK4_CONFIG}.backup-$(date +%Y%m%d-%H%M%S)"
      mv -- "$GTK4_CONFIG" "$backup"
      printf 'Existing GTK 4 configuration backed up to: %s\n' "$backup"
    fi
  fi

  ln -s -- "$LINK_SOURCE" "$GTK4_CONFIG"
  printf 'Linked %s -> %s\n' "$GTK4_CONFIG" "$LINK_SOURCE"
  printf 'Note: libadwaita applications may partially or fully ignore third-party GTK styling.\n'
fi

printf '\nDone. If the theme does not appear immediately, log out and back in.\n'
