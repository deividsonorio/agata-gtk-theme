#!/usr/bin/env bash
set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
THEMES_DIR="${REPO_DIR}/themes"
DEST="${HOME}/.local/share/themes"
CHOICE=""
UNINSTALL=0

usage() {
  cat <<'EOF'
Agata GTK Theme Installer

Usage:
  ./install.sh             Interactive menu
  ./install.sh --dark      Install Agata-Dark
  ./install.sh --light     Install Agata-Light
  ./install.sh --both      Install both variants
  ./install.sh --uninstall dark|light|both
  ./install.sh --dest DIR  Set the destination directory
  ./install.sh --help      Show this help

By default, themes are installed for the current user in:
  ~/.local/share/themes

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
    --help|-h) usage; exit 0 ;;
    *) fail "unknown option: $1 (use --help)" ;;
  esac
done

if [[ -z "$CHOICE" ]]; then
  printf '%s\n' \
    "Agata — GTK Theme Installer" \
    "" \
    "  1) Install Agata-Dark" \
    "  2) Install Agata-Light" \
    "  3) Install both variants" \
    "  4) Remove Agata-Dark" \
    "  5) Remove Agata-Light" \
    "  6) Exit"
  read -r -p "Choose [1-6]: " answer
  case "$answer" in
    1) CHOICE="dark" ;;
    2) CHOICE="light" ;;
    3) CHOICE="both" ;;
    4) CHOICE="dark"; UNINSTALL=1 ;;
    5) CHOICE="light"; UNINSTALL=1 ;;
    *) printf 'No changes made.\n'; exit 0 ;;
  esac
fi

case "$CHOICE" in
  dark) THEMES=("Agata-Dark") ;;
  light) THEMES=("Agata-Light") ;;
  both) THEMES=("Agata-Dark" "Agata-Light") ;;
  *) fail "invalid variant: $CHOICE (use dark, light, or both)" ;;
esac

if ((UNINSTALL)); then
  for theme in "${THEMES[@]}"; do
    target="${DEST%/}/${theme}"
    if [[ -d "$target" ]]; then
      rm -rf -- "$target"
      printf 'Removed: %s\n' "$target"
    else
      printf 'Not found, skipping: %s\n' "$target"
    fi
  done
  exit 0
fi

[[ -d "$THEMES_DIR" ]] || fail "themes directory not found: $THEMES_DIR"
mkdir -p -- "$DEST"

for theme in "${THEMES[@]}"; do
  source_dir="${THEMES_DIR}/${theme}"
  target_dir="${DEST%/}/${theme}"
  [[ -d "$source_dir" ]] || fail "theme not found in repository: $source_dir"
  [[ -f "${source_dir}/index.theme" ]] || fail "missing index.theme in $source_dir"

  # Replace only the selected variant; leave all other themes untouched.
  if [[ -e "$target_dir" ]]; then
    rm -rf -- "$target_dir"
  fi
  cp -a -- "$source_dir" "$target_dir"
  printf 'Installed: %s\n' "$target_dir"
done

printf '\nDone. If the theme does not appear immediately, log out and back in.\n'
