# Agata GTK Theme

**v1.1.1**

Agata is a modern desktop theme for **GTK 3 and GTK 4**, with matching styles for **GNOME Shell, Cinnamon, XFCE** and other GTK-based applications.

It is available in two color editions, **Nord** and **Gruvbox**, each with **Dark** and **Light** variants.

| Edition | Character | Dark | Light |
|---|---|---|---|
| **Nord** | Muted blue accents and cool blue-gray surfaces, based on the Nord palette | `#303744` / `#81A1C1` | `#ECEFF4` / `#81A1C1` |
| **Gruvbox** | Warm, earthy tones based on the Gruvbox palette | `#282828` / `#83A598` | `#F9F5D7` / `#458588` |

The four themes are installed as:

- `Agata-Nord-Dark`
- `Agata-Nord-Light`
- `Agata-Gruvbox-Dark`
- `Agata-Gruvbox-Light`

The theme is ready to use — **no compilation is required**. The installer uses Bash and installs the themes for the current user without requiring `sudo`.

---

## Features

- Nord and Gruvbox color editions.
- Dark and Light variants.
- GTK 3 and GTK 4 styling.
- GNOME Shell support for GNOME 46–51.
- Version-specific GNOME Shell component implementations.
- Cinnamon desktop styling.
- XFCE/XFWM styling.
- XFCE panel and menu styling.
- Optional GTK 4/libadwaita integration.
- Ready-to-use theme files.
- User-local installation without administrator privileges.

---

## Supported Desktop Environments

| Desktop Environment | Supported components |
|---|---|
| **GNOME** | GTK 3, GTK 4 and GNOME Shell |
| **Cinnamon** | GTK and Cinnamon desktop components |
| **XFCE** | GTK, XFWM, panel and menu |

Other GTK-based desktop environments may work as well, but are not part of the tested compatibility matrix.

---

## Requirements

- A desktop environment that supports GTK themes.
- **GNOME Shell:** the **User Themes** extension is required to load the Shell theme.
- **GTK 2 applications:** `gtk-engine-murrine` may be required by some distributions.

### GNOME User Themes extension

On distributions that package the extension separately, install and enable **User Themes** before applying the GNOME Shell theme.

The extension can also be enabled with:

```bash
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
```

On Wayland, a newly installed extension may require logging out and back in before it becomes available.

---

## Installation

Download and extract the latest release.

Open a terminal in the Agata directory and run:

```bash
chmod +x install.sh
./install.sh
```

The interactive installer asks:

1. Which color edition — **Nord** or **Gruvbox**.
2. Which variant — **Dark**, **Light** or **Both**.
3. Whether to enable optional **GTK 4/libadwaita** integration.

### Command-line installation

```bash
./install.sh install nord both
./install.sh install gruvbox dark --libadwaita
./install.sh install nord both --dest /path/to/themes
./install.sh --help
```

Themes are installed to:

```text
~/.local/share/themes/
```

Running the installer again completely replaces an installed Agata theme, allowing the installation to be updated safely.

---

## Applying the Theme

### GNOME

Select the theme in **GNOME Tweaks → Appearance**.

Alternatively:

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Agata-Nord-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Agata-Nord-Dark'
```

Use `Agata-Nord-Light`, `Agata-Gruvbox-Dark` or `Agata-Gruvbox-Light` as desired.

### Cinnamon

Open:

**System Settings → Themes**

Then select the Agata theme for the available desktop theme components.

### XFCE

Open:

**Settings → Appearance → Style**

and:

**Settings → Window Manager → Style**

GTK 3 applications normally update immediately. GTK 4 applications may need to be restarted, and GNOME Shell reloads when the Shell theme is switched.

---

## GNOME Shell

Agata provides dedicated GNOME Shell component sets for:

- GNOME 46
- GNOME 47
- GNOME 48
- GNOME 49
- GNOME 50
- GNOME 51

The installer detects the installed GNOME Shell version and applies the corresponding component set.

Each supported GNOME version has its own complete component set. Components that remain compatible are carried forward into the newer version, while components that changed are maintained separately for that GNOME release.

This keeps GNOME Shell styling organized by version and avoids accumulating unrelated CSS overrides from multiple GNOME releases.

---

## GTK 4 and libadwaita

GTK 4/libadwaita integration is optional.

For example:

```bash
./install.sh install nord light --libadwaita
```

When enabled, the installer links the selected theme's `gtk-4.0` directory to:

```text
~/.config/gtk-4.0
```

If an existing configuration is found and does not belong to Agata, it is backed up before the new configuration is installed.

Some libadwaita applications may still ignore parts of a third-party theme depending on the application and installed libadwaita version.

---

## Uninstallation

Remove Nord:

```bash
./install.sh remove nord both
```

Remove Gruvbox:

```bash
./install.sh remove gruvbox both
```

Remove all Agata themes:

```bash
./install.sh remove all
```

Remove the GTK 4/libadwaita configuration:

```bash
./install.sh remove-libadwaita
```

---

## Wallpapers

Matching wallpapers are included with the project for the four Agata variants:

- Nord Dark
- Nord Light
- Gruvbox Dark
- Gruvbox Light

Link: [wallpapers](https://github.com/deividsonorio/agata-gtk-theme/tree/main/wallpapers)

---

## Compatibility

Agata has been tested on the following systems:

### GNOME

| Distribution | Desktop |
|---|---|
| Fedora 41 | GNOME 47 |
| Fedora 42 | GNOME 48 |
| Fedora 43 | GNOME 49 |
| Fedora 44 | GNOME 50 |
| Fedora 45 | GNOME 51 |
| Zorin OS 18.1 | GNOME 46|
| Ubuntu 24.04 LTS | GNOME 46 |
| Ubuntu 26.04 LTS | GNOME 50|

### XFCE

| Distribution | Desktop |
|---|---|
| Fedora 44 | XFCE |
| Fedora 45 | XFCE |
| MX Linux 25.3 | XFCE |
| Linux Mint XFCE 22.3 | XFCE |
| Xubuntu 26.10 | XFCE |

### Cinnamon

| Distribution | Desktop |
|---|---|
| Linux Mint Cinnamon 22.3 | Cinnamon |

The appearance may vary depending on the desktop environment, GTK version, compositor and installed extensions.

---

## What's New in v1.1.1

- Redesigned GNOME Shell component architecture for GNOME 46–51.
- GNOME Shell components now use version-specific implementations.
- Improved GNOME 48, 49, 50 and 51 compatibility.
- Fixed GNOME Shell dialog button colors.
- Fixed GNOME Shell Quick Settings disabled-arrow appearance.
- Fixed Cinnamon notification colors.
- Updated GNOME Shell installation logic to select the appropriate component set automatically.
- Tested across GNOME 46–51.
- Additional testing on Cinnamon and XFCE systems.

---

## Credits

Agata is based on the **Jasper GTK Theme** by **vinceliuice**.

The color editions follow the **Nord** and **Gruvbox** palettes.

---

## License

Released under the **MIT License**.

See [`LICENSE`](LICENSE) for the complete license text.