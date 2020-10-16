<p align="center"><a name="top" href="#"><img src="https://raw.githubusercontent.com/ComplexPlatform/KDE-dotfiles/master/.assets/header_.png"></a></p>

<h2 align="center"> Preview </h2>

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
-  **Terminal Font:** SF Mono Powerline
-  **System Font:** SF UI Text
-  **Bar/Panel:** Latte-Dock
-  **File Manager:** ~~Dolphin~~ Thunar
-  **Editor:** VS Code
-  **Browser:** Firefox
-  **Music Player:** Spotify & ncmpcpp

The fetch shown in the preview above is [fet.sh](https://github.com/6gk/fet.sh)

Firefox CSS is based on [minimal-functional-fox](https://github.com/mut-ex/minimal-functional-fox)

Startpage source: https://notabug.org/nytly/home

Latte layout is based on [Moe Layout](https://store.kde.org/p/1373008/).

ncmpcpp config is from [elenapan](https://github.com/elenapan/dotfiles/blob/master/config/ncmpcpp/config) and [owl4ce](https://github.com/owl4ce/dotfiles/blob/master/.ncmpcpp/config)

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

## :hammer_and_wrench: Setup

**(work in progress)**

Note: I just got started ricing back in August so I'm very new to this. I don't guarantee anything to be working as intended.

Set your Global Theme to Breeze Dark before you proceed.

**Install the dependencies:**

- ```bash
  # Use your helper of choice
  yay -S latte-dock-git wpgtk-git qt5-styleplugins
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
     ```
   - ```bash
     tar -Jxvf Foggy-Mountain.tar.xz && tar -Jxvf Coffee.tar.xz && tar -Jxvf Flowers.tar.xz && tar -Jxvf Urban.tar.xz && tar -Jxvf CherryBlossom.tar.xz
     ```
   - ```bash
   	 # Delete leftover archives
     rm -r ~/.local/share/icons/{Foggy-Mountain.tar.xz,Coffee.tar.xz,Flowers.tar.xz,Urban.tar.xz,CherryBlossom.tar.xz}
     ```
     
</details>

<details open>
  <summary><strong>wpgtk</strong></summary>
	Add wallpapers and import color schemes

- ```bash
  # Assuming you're in KDE-Dotfiles directory
  # Add wallpapers
  wpg -a walls/foggy-mountain_01.jpg
  wpg -a walls/coffee.jpg
  wpg -a walls/flowers.jpg
  wpg -a walls/urban.jpg
  wpg -a walls/cherryblossom.jpg
  ```
- ```bash
  # Assuming you're in KDE-Dotfiles directory
  #Import color schemes
  wpg -i foggy-mountain_01.jpg colorschemes/foggy-mountain.json
  wpg -i coffee.jpg colorschemes/coffee.json
  wpg -i flowers.jpg colorschemes/flowers.json
  wpg -i urban.jpg colorschemes/urban.json
  wpg -i cherryblossom.jpg colorschemes/cherryblossom.json
  ```

Add templates:

- ```bash
  # Backups are automatically made just in case something goes wrong.
  wpg -ta ~/.config/kdeglobals
  wpg -ta ~/.local/share/konsole/wpgtk.colorscheme
  wpg -ta ~/.local/share/plasma/desktoptheme/CullaX/colors
  ```

Add variables/keywords to the templates:

- ```bash
  # Identify the templates` filenames first on ~/.config/wpg/templates
  # Replace <filename>.base with yours
  # Assuming you're in KDE-dotfiles directory
  cd wpgtktemplates
  cat kdeglobals.base > ~/.config/wpg/templates/<your_kdeglobals>.base
  cat colors.base > ~/.config/wpg/templates/<your_cullax_colors>.base
  cat konsole.base > ~/.config/wpg/templates/<your_konsole>.base
  ```

Set the color scheme:

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
spicetify config color_scheme pywal
spicetify apply
```

<details open>
<summary><strong>Set Plasma theme</strong></summary>
  
 - System Settings > Plasma Style, set it to CullaX.
 - System Settings > Application Style, set it to gtk2. Click `Configure GNOME/GTK Application Style...`, set the GTK2 and GTK3 theme your theme of choice.
- System Settings > Icons, set the icon theme to your theme of choice.

To remove the titlebar buttons:
- System Settings > Application Style > Window Decorations > Titlebar Buttons, drag the buttons and drop it down to the list.

To change the titlebar size:
- System Settings > Application Style > Window Decorations, click the edit icon on `Breeze`. Change button size to whatever you want.

</details>

## :sparkling_heart: Credits

- [owl4ce](https://github.com/owl4ce/)
- [elenapan](https://github.com/elenapan/)
- [addy-dclxvi](https://github.com/addy-dclxvi/)