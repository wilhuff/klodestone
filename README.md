# KLodestone

<img align="right" width="125" height="75" src="./media/icon.png">

KDE KWin Script for snapping windows into positions using keyboard shortcuts. Handy when using a mix of ultrawide and regular monitors and inspired by Magnet on macOS--an alternative to PowerToys FancyZones and Windows 11 snap layouts.

[![kde-store](https://img.shields.io/badge/KDE%20Store-download-blue?logo=KDE)](https://store.kde.org/p/1909220)

KLodestone is based heavily on [KZones](https://github.com/gerritdevriese/kzones). Many thanks to gerritdevriese for the ideas and code.

## Features

### Keyboard Shortcuts

KLodestone provides window position presets accessible via keyboard shortcuts. Move windows to thirds, halves, quarters, or two-thirds positions with a quick key combo. This is not an automatic tiling window manager; you still pick and choose where windows go, but now it's effortless to arrange things the way you like without having to pre-program or switch between static layouts.

### Edge Snapping

Drag windows to the edge or corner of the screen to snap them into position.

### Screen Cycling

When a window is already at an edge position, repeating the shortcut moves it to the same position on the next screen.

## Installation

To install KLodestone you can either use the built-in script manager or clone the repo and build it yourself.

### KWin Script Manager

Navigate to `System Settings / Window Management / KWin Scripts / Get New…` and search for KLodestone.

### Build it yourself

Make sure you have "zip" installed on your system before building.

```sh
git clone https://github.com/wilhuff/klodestone
cd klodestone && make
```

## Configuration

The script settings can be found under `System Settings / Window Management / KWin Scripts / KLodestone / ⚙️`

### General

#### Edge Snapping

Snap windows to positions by dragging them to the edge of the screen.

- Enable or disable edge snapping.
- Set the distance from the edge of the screen at which edge snapping activates.

#### Remember and restore window geometries

The script remembers the geometry of each window when it's moved to a position. When the window is moved out of the position, it will be restored to its original geometry.

- Enable or disable this behavior.

#### Display OSD messages

Disable this if you don't want to see any messages on-screen after moving a window.

- Enable or disable this behavior.

### Filters

Stop certain windows from snapping by adding them to the filter list.

- Select the filter mode, either **Include** or **Exclude**.
- Add window classes to the list separated by a newline.

You can enable the debug overlay to see the window class of the active window.

### Advanced

#### Polling rate

The polling rate is the amount of time between each position check when dragging a window. The default is 100ms, a faster polling rate is more accurate but will use more CPU.

#### Debugging

Here you can enable logging or turn on the debug overlay.

## Shortcuts

All shortcuts use <kbd>Ctrl</kbd> + <kbd>Alt</kbd> as the modifier:

| Position | Key |
| -------- | --- |
| Left Third | <kbd>D</kbd> |
| Center Third | <kbd>F</kbd> |
| Right Third | <kbd>G</kbd> |
| Left Two-Thirds | <kbd>E</kbd> |
| Right Two-Thirds | <kbd>T</kbd> |
| Left Half | <kbd>H</kbd> |
| Right Half | <kbd>L</kbd> |
| Top Half | <kbd>K</kbd> |
| Bottom Half | <kbd>J</kbd> |
| Top-Left Quarter | <kbd>U</kbd> |
| Top-Right Quarter | <kbd>I</kbd> |
| Bottom-Left Quarter | <kbd>N</kbd> |
| Bottom-Right Quarter | <kbd>M</kbd> |

*To change the default bindings, go to `System Settings / Shortcuts` and search for KLodestone*

## Tips and Tricks

### Animate window movements

Install the "Geometry change" KWin effect to animate window movements: https://store.kde.org/p/2136283

### Trigger KWin shortcuts using a command

Replace the last part with any shortcut from the list above:

```sh
qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "KLodestone: Halves - Move Left"
```

### Clean corrupted shortcuts

Sometimes KWin can leave behind corrupt or missing shortcuts in the Settings after uninstalling or updating scripts, you can remove those using this command:

```sh
qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.cleanUp
```

## Troubleshooting

### The script doesn't work

Check if your KDE Plasma version is 6 or higher.

### My settings are not saved

After changing settings, reload the script by disabling, saving and enabling it again.
This is a known issue with the KWin Scripting API.

### The screen turns black while moving a window

If you are using X11 make sure your compositor is enabled, as it is needed to draw transparent windows.
You can find this setting in `System Settings / Display and Monitor / Compositor`.
