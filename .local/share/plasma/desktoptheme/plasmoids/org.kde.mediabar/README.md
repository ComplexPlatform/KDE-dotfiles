# MediaBar
Media Bar for dock/panel use, based on KDE Plasma Media Player Controls
![Expanded View](https://i.imgur.com/Oy0Idpj.png "MediaBar expanded view")

## Features
* View and control Media from inside a panel or dock (such as [Latte Dock](https://github.com/KDE/latte-dock))
* Simple format: `Artist Name - Track Title`
* View Album and Album Art on expanded view and tooltip
* View current position of track in expanded view
* Controllable with [Shortcuts](#shortcuts)
* Smart [auto-sizing and text scrolling](#auto-size)

Note: The plasmoid relies on the mpris2 protocol to view and control the media. If you can't see some stuff or you can't control some aspects it's possible that your media player doesn't provide those to the mpris2 protocol and there's nothing MediaBar can do about it.

## Requirements
 **Plasma 5** and **Qt >= 5.12**

## Manual installation
Download the code from this repository, enter the downloaded directory (where the metadata.desktop file is) and run: `kpackagetool5 -t Plasma/Applet --install ./`

## Configuration
Configuration is available if you right-click the plasmoid and select "Configure MediaBar..."

By default, MediaBar uses the `@multiplex` mpris2 source which is the combination of all sources. However you can limit to a specific source such as your preferred media player ([Elisa](https://kde.org/applications/multimedia/org.kde.elisa), Cantata, etc.).

## Shortcuts
**Panel:**

| Mouse button    | Action             |
|----------------:|--------------------|
| `Left button`   | Play/Pause         |
| `Right button`  | Open context menu  |
| `Middle button` | Open expanded view |
| `Wheel Down`    | Seek back 5s       |
| `Wheel Up`      | Seek forward 5s    |
| `Back button`   | Previous           |
| `Forward button`| Next               |

Note: Wheel Up/Down will only work if you tick "Use scroll wheel for seeking" in the plasmoid's options.

**Expanded:**

| Key          | Action          |
|-------------:|-----------------|
| `K`, `Space` | Play/Pause      |
| `P`          | Previous        |
| `N`          | Next            |
| `Left`, `J`  | Seek back 5s    |
| `Right`, `L` | Seek forward 5s |
| `Home`       | Seek start      |
| `Num: [0..9]`| Jump to porcentage, `Key 0: 0%, ..., Key 9: 90%` |

### Auto Size
The plasmoid will auto-size to fit the text up to a maximum configurable width. If the text is wider than the available space, it will be elided and an autoscroll animation will play whenever you hover over the plasmoid or the currently playing track changes.
