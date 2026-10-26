# Agata GTK Themes

GTK themes inspired by the Nord color palette, featuring blue accents.

## Variants

- **Agata-Dark** — dark variant.
- **Agata-Light** — light variant.

## Installation

### Manual Installation

To install a theme manually, copy its directory into one of the theme directories supported by your Linux distribution.

Common locations include:

- `/usr/share/themes/`
- `~/.themes/`
- `~/.local/share/themes/`

### Installation Script

Download or clone this repository, open a terminal in its root directory, and run:

```bash
chmod +x install.sh
./install.sh
```

The installer displays a menu that lets you install `Agata-Dark`, `Agata-Light`, or both variants. You can also remove either variant through the menu.

By default, themes are installed for the current user in `~/.local/share/themes/`. The installer does not require `sudo` or compilation.

#### Install from the command line

Install a specific variant or both variants:

```bash
./install.sh --dark
./install.sh --light
./install.sh --both
```

Short options are also available:

```bash
./install.sh -d
./install.sh -l
./install.sh -b
```

#### Choose a destination directory

To install a theme into a different directory:

```bash
./install.sh --light --dest "$HOME/.themes"
```

The `--dest` option also applies to uninstall operations.

#### Uninstall themes

Remove a specific variant or both variants:

```bash
./install.sh --uninstall dark
./install.sh --uninstall light
./install.sh --uninstall both
```

To display the available options:

```bash
./install.sh --help
```

The installer replaces only the selected theme directories in the destination. Other theme directories are left untouched.

## Compatibility

The repository includes GTK theme files and desktop components for environments that support them, including GNOME, Cinnamon, and XFCE/XFWM. Appearance may vary depending on the desktop environment, GTK version, and installed extensions.

## Desktop Light/Dark Preference

Installing a theme does not automatically change GNOME's global light/dark preference. This setting is separate from the GTK theme and may need to be changed in the desktop environment's settings.

## Credits

Agata is based on the [Jasper GTK theme](https://github.com/vinceliuice/Jasper-gtk-theme).