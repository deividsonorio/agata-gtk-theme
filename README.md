# *Agata GTK Theme*

**v1.1.0**

Agata is a modern GTK theme featuring two carefully crafted color editions: **Nord** and **Gruvbox**. It combines elegant surfaces, balanced contrast, and distinctive color accents to provide a clean and consistent desktop experience.

- **Nord** — muted blue accents and cool blue-gray surfaces, inspired by the Nord color palette.
- **Gruvbox** — warm, earthy tones inspired by the Gruvbox color palette.

Both editions are available in Dark and Light variants.

## *Features*

- Two color editions: Nord and Gruvbox.
- Dark and Light variants.
- GTK 3 and GTK 4 styling.
- Version-specific GNOME Shell component styling.
- GNOME Shell components adapted for supported GNOME versions.
- Desktop components for GNOME, Cinnamon, and XFCE/XFWM.
- XFCE panel and menu styling.
- Optional GTK 4/libadwaita application integration.
- Ready-to-use theme files — no compilation required.
- User-local installation — no administrator privileges required.

## *Tests*

The themes were tested in the following distributions and desktop environments:

- Fedora 41 — GNOME 47
- Fedora 42 — GNOME 48
- Fedora 43 — GNOME 49
- Fedora 44 — GNOME 50
- Fedora 45 — GNOME 51
- Fedora 44 — XFCE
- Fedora 45 — XFCE
- MX Linux 25.3 — Cinnamon
- Linux Mint Cinnamon 22.3 — Cinnamon
- Linux Mint XFCE 22.3 — XFCE
- Xubuntu 26.10 — XFCE
- Zorin OS 18.1 — GNOME 46

GNOME Shell component styling was specifically tested across GNOME 46 through GNOME 51. The installer detects the installed GNOME Shell version and applies the corresponding component set, so each supported GNOME version uses its appropriate component implementations.

## *Installation*

Download and extract the latest release, open a terminal in the extracted directory, and run:

```bash
chmod +x install.sh
./install.sh
```

The interactive installer guides you through three simple choices:

1. Select the color edition: Nord or Gruvbox.
2. Select the variant: Dark, Light, or Both.
3. Choose whether to enable optional GTK 4/libadwaita integration.

Themes are installed locally for the current user in:

```text
~/.local/share/themes/
```

No administrator privileges or `sudo` are required.

## *Command-line installation*

You can also install themes directly from the terminal without using the interactive menu.

### *Nord edition*

Install both variants:

```bash
./install.sh install nord both
```

Install only Dark or Light:

```bash
./install.sh install nord dark
./install.sh install nord light
```

### *Gruvbox edition*

Install both variants:

```bash
./install.sh install gruvbox both
```

Install only Dark or Light:

```bash
./install.sh install gruvbox dark
./install.sh install gruvbox light
```

### *GTK 4 / libadwaita integration*

Add `--libadwaita` to an installation command to enable optional GTK 4 theme integration.

For example:

```bash
./install.sh install nord light --libadwaita
```

Or:

```bash
./install.sh install gruvbox dark --libadwaita
```

When both variants are installed, the installer asks which variant should be used for GTK 4 applications.

The installer links the selected theme's `gtk-4.0` directory to:

```text
~/.config/gtk-4.0
```

If an existing GTK 4 configuration is found, it is backed up before the link is created.

**Note:** Some libadwaita applications may restrict or partially ignore third-party GTK themes, depending on the application and libadwaita version. This option provides GTK 4 theme integration where supported, but cannot guarantee that every libadwaita application will follow all theme styles.

## *GNOME Shell component support*

Agata includes dedicated GNOME Shell component sets for the supported GNOME versions.

The installer detects the installed GNOME Shell version and applies the corresponding component set. Components that remain compatible across GNOME versions are retained in the appropriate version set, while components that changed between GNOME releases use their version-specific implementation.

This avoids relying on a cumulative chain of GNOME Shell CSS overrides and keeps the component selection isolated by GNOME version.

## *Uninstallation*

Use the interactive menu or remove a specific edition from the terminal.

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

To remove the optional GTK 4 configuration link and restore the previous configuration:

```bash
./install.sh remove-libadwaita
```

## *Advanced options*

Use a custom installation directory:

```bash
./install.sh install nord both --dest /path/to/themes
```

Display all available commands:

```bash
./install.sh --help
```

## *Compatibility*

Agata is designed for Linux desktop environments that support GTK themes, including GNOME, Cinnamon, and XFCE.

GNOME Shell styling is version-aware and is maintained separately from the GTK theme components. Appearance may vary depending on the desktop environment, GTK version, compositor, GNOME Shell extensions, and other system-specific components.

## *Wallpapers*

Matching wallpapers for the Agata theme are available in the repository:

[Wallpapers](https://github.com/deividsonorio/agata-gtk-theme/tree/main/wallpapers)

## *Credits*

Agata is based on the [Jasper GTK theme](https://github.com/vinceliuice/Jasper-gtk-theme).

Please refer to the repository for attribution and licensing information.