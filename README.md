# KDE-dotfiles

![Preview](https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/foggy-mountain-preview.png)


## Important stuff

 - [Latte-Dock](https://github.com/KDE/latte-dock) & [Moe Layout](https://store.kde.org/p/1373008/)
 - [wpgtk](https://github.com/deviantfero/wpgtk) & [pywal](https://github.com/dylanaraps/pywal)
 - [qt5-styleplugins](https://github.com/qt/qtstyleplugins) ([AUR](https://aur.archlinux.org/packages/qt5-styleplugins/))
 - [CullaX](https://www.opendesktop.org/p/1278039/)

## Optional stuff
 - [Spicetify](https://github.com/khanhas/Spicetify) (make sure to install dribbblish as well.)
 - VS Code Extension - [Wal Theme](https://marketplace.visualstudio.com/items?itemName=dlasagno.wal-theme)
 - [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
 - [Krohnkite](https://store.kde.org/p/1281790/)
 - [pywal-discord](https://github.com/FilipLitwora/pywal-discord)

The fetch shown in the preview above is [fet.sh](https://github.com/6gk/fet.sh)

Firefox CSS is based on [minimal-functional-fox](https://github.com/mut-ex/minimal-functional-fox)

Latte layout is based on [Moe Layout](https://store.kde.org/p/1373008/). Make sure to install the required widgets if you're going to use it.

## Setup
**(work in progress)**

Disclaimer: I only discovered ricing back in August so I'm very new to these kinds of things. I don't guarantee anything to be working as expected.

You may skip this and just copy the dotfiles in this repo if you want, but I don't know if that will work.

 1. Install the programs mentioned above.
 2. For wpgtk, install the gtk and icon-set template as instructed [here.](https://github.com/deviantfero/wpgtk/wiki/Installation#default-templates) For custom templates, follow the documentation. I have a template for `kdeglobals`, `konsole`, and `CullaX` ([here](https://github.com/ComplexPlatform/KDE-dotfiles/tree/master/.config/wpg/templates)). You may copy the values but make sure to add them manually, as the files use symbolic links.
 3. For removing the title bar and adding active/inactive window frame colors, follow [this guide.](https://github.com/waltereikrem/KWin-TilingGuide/) (I recommend using krohnkite for tiling.)
 4. Launch Latte-dock, import my layout, then apply.
 5. Launch wpgtk. under Colors tab, click import and choose `foggy-mountain-color-scheme.json` If you're using spicetify, add `spicetify apply` under `Command:` in wpgtk options so you don't have to do it manually. under Wallpaper tab, click set.
 7. Go to System Settings. For Plasma Style, set it to CullaX. For Application Style, set it to gtk2. Click `Configure GNOME/GTK Application Style...`, set the GTK2 and GTK3 theme to FlatColor. For icons, set it to FlattrColor.