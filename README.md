<p align="center"><a name="top" href="#"><img src="https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/.assets/header_.png"></a></p>

<h2 align="center"> Preview </h2>

<h3 align="center"> Neutral </h3>

![](https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/previews/neutral.png)

<h3 align="center"> Cherry Blossom </h3>

![](https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/previews/cherryblossom.png)

<h3 align="center"> Urban </h3>

![](https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/previews/urban.png)

<h3 align="center"> Flowers </h3>

![](https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/previews/flowers.png)

<h3 align="center"> Coffee </h3>

![](https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/previews/coffee.png)

<h3 align="center"> Foggy Mountain </h3>

![](https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/previews/foggy-mountain.png)

## :sparkles: Thanks for visiting! 

To give you an idea on how this works, I use `wpgtk` with templates to make setting color schemes across many applications convenient. Each color scheme has its own corresponding GTK and icon themes.

-  **OS:** Manjaro
-  **DE:** Plasma
-  **WM:** KWin
-  **Terminal:** Konsole
-  **Shell:** zsh + Oh My Zsh + Powerlevel10k
-  **Terminal Font:** SFMono Nerd Font, JetBrainsMono NF, Iosevka
-  **System Font:** SF Pro Text
-  **Bar/Panel:** ~~Latte-Dock~~ Polybar
-  **File Manager:** ~~Dolphin~~ Thunar
-  **Editor:** VS Code, Vim
-  **Browser:** Firefox
-  **Music Player:** Spotify & ncmpcpp

Firefox CSS sources: [minimal-functional-fox (old)](https://github.com/mut-ex/minimal-functional-fox) & [not-firefox-review](https://github.com/JavaCafe01/not-firefox-review)

Startpage sources: https://notabug.org/nytly/home (old) & https://github.com/JavaCafe01/startpage

Latte layout is based on [Moe Layout](https://store.kde.org/p/1373008/).

ncmpcpp config source: [elenapan](https://github.com/elenapan/dotfiles/blob/master/config/ncmpcpp/config) and [owl4ce](https://github.com/owl4ce/dotfiles/blob/master/.ncmpcpp/config)

Materia GTK themes and Papirus icons are made using [oomox](https://github.com/themix-project/oomox)

## :pushpin: Dependencies

-  [Latte-Dock](https://github.com/KDE/latte-dock) (git version)
-  [wpgtk](https://github.com/deviantfero/wpgtk) & [pywal](https://github.com/dylanaraps/pywal)
-  [qt5-styleplugins](https://github.com/qt/qtstyleplugins) ([AUR](https://aur.archlinux.org/packages/qt5-styleplugins/), can also be installed with `pacman`)

## :paperclip: Recommendations

-  [Spicetify-cli](https://github.com/khanhas/spicetify-cli) (make sure to install [Dribbblish](https://github.com/morpheusthewhite/spicetify-themes/tree/master/Dribbblish) as well.)
- VS Code Extension - [Wal Theme](https://marketplace.visualstudio.com/items?itemName=dlasagno.wal-theme)
-  [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
-  [Krohnkite](https://store.kde.org/p/1281790/)
-  [Zathura-Pywal](https://github.com/GideonWolfe/Zathura-Pywal)
-  [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)
-  [betterdiscordctl](https://github.com/bb010g/betterdiscordctl) & [pywal-discord](https://github.com/FilipLitwora/pywal-discord)
- [Tabliss](https://tabliss.io/)
- [Animated Image Wallpaper](https://store.kde.org/p/1339104/)
- [polybar](https://github.com/polybar/polybar) - replacement for latte-dock
- [rofi](https://github.com/davatorium/rofi) - replacement for krunner
- [dunst](https://github.com/dunst-project/dunst) - replacement for KDE's notification daemon

## :hammer_and_wrench: Setup

**(work in progress)**

Note: I just got started ricing back in August so I'm very new to this. I don't guarantee anything to be working as intended.

Set your Global Theme to Breeze Dark before you proceed.

**Install the dependencies:**

- ```bash
  # Use your helper of choice
  yay -S latte-dock-git wpgtk-git qt5-styleplugins python-pywal
  ```
<details open>
<summary><strong>Clone and copy most of the stuff</strong></summary>
  
- ```bash
  git clone https://github.com/ComplexPlatform/KDE-dotfiles
    ```
- ```bash
  # Copy .local, .config, .themes, and .ncmpcpp to your home directory.
  cd KDE-dotfiles/ && cp -r {.local,.config,.themes,.ncmpcpp} ~/
  ```
   
</details>

To remove title bars and add active/inactive frame colors, follow [this guide](https://github.com/esjeon/krohnkite#removing-title-bars)

To change your Latte layout, right click on your dock/panel > Layouts > pick your layout of choice.

<details open>
  <summary><strong>Extract Icons</strong></summary>
  
- ```bash
  cd ~/.local/share/icons/
  ls *.xz |xargs -n1 tar -xf

  # Delete leftover archives
  rm *.tar.xz
  ```
     
</details>

<details open>
  <summary><strong>wpgtk</strong></summary>

1. Add wallpapers and import color schemes:

- ```bash
  # Assuming you're in KDE-Dotfiles directory
  # Add wallpapers
  wpg -a walls/foggy-mountain_01.jpg
  wpg -a walls/coffee.jpg
  wpg -a walls/flowers.jpg
  wpg -a walls/urban.jpg
  wpg -a walls/cherryblossom.jpg
  wpg -a walls/neutral.jpg
  ```
- ```bash
  # Assuming you're in KDE-Dotfiles directory
  # Import color schemes
  wpg -i foggy-mountain_01.jpg colorschemes/foggy-mountain.json
  wpg -i coffee.jpg colorschemes/coffee.json
  wpg -i flowers.jpg colorschemes/flowers.json
  wpg -i urban.jpg colorschemes/urban.json
  wpg -i cherryblossom.jpg colorschemes/cherryblossom.json
  wpg -i neutral.jpg colorschemes/neutral.json
  ```

2. Add templates:

- ```bash
  # Backups are automatically made just in case something goes wrong.
  wpg -ta ~/.config/kdeglobals
  wpg -ta ~/.local/share/konsole/wpgtk.colorscheme
  wpg -ta ~/.local/share/plasma/desktoptheme/CullaX/colors
  ```

3. Add variables/keywords to the templates:

- ```bash
  # Identify the templates` filenames first on ~/.config/wpg/templates
  # Replace <filename>.base with yours
  # Assuming you're in KDE-dotfiles directory
  cd wpgtktemplates
  cat kdeglobals.base > ~/.config/wpg/templates/<your_kdeglobals>.base
  cat colors.base > ~/.config/wpg/templates/<your_cullax_colors>.base
  cat konsole.base > ~/.config/wpg/templates/<your_konsole>.base
  ```

4. Set the color scheme:

- ```bash
  wpg -s <scheme>.jpg
  # Replace <scheme> with your color scheme of choice.
  # For example
  wpg -s Flowers.jpg
  ```

Unfortunately, you have to set your wallpaper manually.
</details>

If you're using `Spicetify` with `Dribbblish`, run the following:

```bash
xrdb -merge ~/.cache/wal/colors.Xresources
spicetify config color_scheme pywal
spicetify apply
```

<details open>
<summary><strong>Set Plasma theme</strong></summary>
  
 - System Settings > Plasma Style, set it to CullaX.
 - System Settings > Application Style, set it to gtk2. Click `Configure GNOME/GTK Application Style...`, set the GTK2 and GTK3 theme your theme of choice.
- System Settings > Icons, set the icon theme to your theme of choice.

To remove the titlebar buttons:
- System Settings > Application Style > Window Decorations > Titlebar Buttons, drag the buttons and drop them down to the list.

To change the titlebar size:
- System Settings > Application Style > Window Decorations, click the edit icon on `Breeze`. Change button size to whatever you want.

</details>

## :ice_cream: Optional Stuff

<details open>
<summary><strong>dunst</strong></summary>
  
You can use [`dunst`](https://github.com/dunst-project/dunst) instead by renaming KDE's notification service so it gets ignored.

```bash
# Make sure dunst is installed beforehand
cd /usr/share/dbus-1/services
sudo mv org.kde.plasma.Notifications.service org.kde.plasma.Notifications.service-disabled
```
Log out and log back in again to see the changes.

</details>

## :sparkling_heart: Credits

- [6gk](https://github.com/6gk/)
- [JavaCafe01](https://github.com/JavaCafe01/)
- [KevinNThomas](https://gitlab.com/KevinNThomas)
- [addy-dclxvi](https://github.com/addy-dclxvi/)
- [adi1090x](https://github.com/adi1090x)
- [deviantfero](https://github.com/deviantfero/)
- [elenapan](https://github.com/elenapan/)
- [fehawen](https://github.com/fehawen/)
- [gillescastel](https://github.com/gillescastel)
- [ngynLk](https://github.com/ngynLk/)
- [owl4ce](https://github.com/owl4ce/)
