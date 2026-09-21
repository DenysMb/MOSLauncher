# MOS Launcher

Application launcher plasmoid for Margarida OS. A fork of KDE Plasma's Kickoff
applet, rebranded and maintained independently.

## Status

Early development. This is a faithful port of upstream Kickoff 6.7.5 with
branding changes only. Visual redesign is in progress.

## Requirements

- Plasma 6.0 or newer
- `plasma-workspace` (provides the `org.kde.plasma.private.kicker` QML module
  that supplies all application, favorites and runner models)

No compilation step is required: this is a pure QML plasmoid.

## Build and install

```sh
kpackagetool6 --type Plasma/Applet --install .
```

To update an installed copy:

```sh
kpackagetool6 --type Plasma/Applet --upgrade .
```

To remove:

```sh
kpackagetool6 --type Plasma/Applet --remove io.github.DenysMb.MOSLauncher
```

After installing, add it to a panel or desktop through *Add Widgets*, or
replace an existing Kickoff instance by right-clicking it and choosing
*Show Alternatives*.

## Favorites

Favorites are shared with the rest of the desktop. The set of pinned
applications is stored globally by the `org.kde.plasma.favorites.applications`
agent, so switching from Kickoff to MOS Launcher keeps your pinned apps.

Ordering is per-applet, stored under a
`Favorites-io.github.DenysMb.MOSLauncher.favorites.instance-<id>` group in
`kactivitymanagerd-statsrc`. On first run the model falls back to the ordering
of another launcher, so pinned positions carry over too. Reordering inside MOS
Launcher only affects MOS Launcher.

Instances are independent: you can place several on the desktop, each with its
own position and configuration.

## Layout

```
metadata.json            package manifest
contents/config/
    config.qml           configuration dialog model
    main.xml             KConfigXT schema for all settings
contents/ui/
    qmldir               declares the two QML singletons
    main.qml             applet entry point
    *.qml                panels, pages, views and delegates
    code/tools.js        favorite action helpers
```

`MosActionMenu.qml` and `MosSingleton.qml` are QML singletons, which is why
`qmldir` is required.

## Licensing

GPL-2.0-or-later. This project is derived from KDE Plasma's Kickoff applet and
carries the original copyright headers in each source file. See `LICENSE`.
