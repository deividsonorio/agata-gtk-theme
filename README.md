# Agata GTK Theme
v1.0.3

Agata is a modern GTK theme inspired by the **Nord color palette**, featuring muted blue accents, cool blue-gray surfaces, and carefully balanced contrast.

Designed to provide a clean, elegant, and consistent desktop experience, Agata is available in two variants:

- **Agata-Dark** — a dark interface with deep blue-gray surfaces and soft blue highlights.
- **Agata-Light** — a light interface with subtle gray-blue tones and balanced contrast.

### Features

- Nord-inspired color scheme with restrained blue accents.
- Dark and Light variants.
- GTK 3 and GTK 4 styling.
- Desktop components for GNOME, Cinnamon, and XFCE/XFWM.
- XFCE panel and menu styling.
- Optional GTK 4/libadwaita application integration through the installer.
- Ready-to-use theme files — no compilation required.

### Installation

Download and extract the latest release, open a terminal in the extracted directory, and run:

```bash
chmod +x install.sh
./install.sh
```

The installer provides an interactive menu to install Agata-Dark, Agata-Light, or both variants.

Themes are installed locally for the current user in:

```text
~/.local/share/themes/
```

No administrator privileges or `sudo` are required.

#### Command-line installation

Install a specific variant:

```bash
./install.sh --dark
./install.sh --light
./install.sh --both
```

#### GTK 4 / libadwaita integration

To make GTK 4 applications use Agata's GTK 4 stylesheet, install a variant and enable the optional configuration link:

```bash
./install.sh --light --libadwaita
```

For the dark variant:

```bash
./install.sh --dark --libadwaita
```

The installer links the selected theme's `gtk-4.0` directory to `~/.config/gtk-4.0`. If an existing configuration directory is found, it is backed up before the link is created.

**Note:** libadwaita applications may restrict or partially ignore third-party GTK themes, depending on the application and libadwaita version. This option provides GTK 4 theme integration where supported; it cannot guarantee that every libadwaita application will follow all theme styles.

#### Uninstall

```bash
./install.sh --uninstall dark
./install.sh --uninstall light
./install.sh --uninstall both
```

To remove the optional GTK 4 configuration link and restore the previous configuration:

```bash
./install.sh --unlink-libadwaita
```

### Compatibility

Agata is designed for Linux desktop environments that support GTK themes, including GNOME, Cinnamon, and XFCE. Appearance may vary depending on the desktop environment, GTK version, compositor, and extensions.

### Credits

Agata is based on the [Jasper GTK theme](https://github.com/vinceliuice/Jasper-gtk-theme).

Please refer to the repository for attribution and licensing information.
