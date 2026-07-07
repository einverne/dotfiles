# hammerspoon configuration

hammerspoon is my configuration for [Hammerspoon](http://www.hammerspoon.org/). It has highly modal-based, vim-style keybindings, provides some functionality like desktop widgets, window management, application launcher, instant search, ... etc.

## Get started

- Install [Hammerspoon](http://www.hammerspoon.org/) first `brew install --cask hammerspoon`
- `git clone https://github.com/einverne/dotfiles.git ~/dotfiles`
- `ln -s ~/dotfiles/hammerspoon ~/.hammerspoon`
- Reload the configuration.

## Keep update

`cd ~/dotfiles && git pull`

## File structure

- `autoscript.lua`, auto commit and push my personal notes.
- `ime.lua`, auto switch different Input methods in different applications
- `todo_overlay.lua`, floating Todo overlay on the top-right corner, reading todos from an Obsidian Kanban markdown file

## How to use
Use Karabiner-Elements to set <kbd>caps lock</kbd> as hyper key. Press caps lock is just like press Cmd+Control+Option+Shift at the same time.

## Reload config

- Hyper key + R, reload hammerspoon config

## Hyper key windows management

- Hyper key + H, set windows to left half of screen
- Hyper key + L, right half of screen
- Hyper key + J, bottom half
- Hyper key + K, top half
- Hyper key + F, full screen

### Windows management mode

Option+r Enter windows management:

- ASDW to move windows position
- HL/JK to set windows to left, right, up, down half of screen
- Y/O/U/I to set windows to LeftUp, RightUp, LeftDown, LeftDown corner
- Left/Right/Up/Down same as HL/JK
- F to set windows to full screen
- C to set windows to center
- Esc/Q to exit
- Tab to show help

### Switch windows
I personally use the application called [Context](https://contexts.co/) to switch between different windows, however this config provide another way to quickly switch between windows. Try with `Option+Tab`.

## Toggle hammerspoon console

`Option+z`

## Move windows between monitors
If you have multiple monitors, you can use the following shortcut to move window to different monitor:

- Hyper key + N, to move current window to next monitor
- Hpper key + P, to move current window to previous monitor

### Application launcher

Press `option + a` to enter application launcher. The shorcut information will show on the center of the screen. But I personally prefer [Alfred](https://www.alfredapp.com/).

## Hammerspoon API manual

`Option+h` open Hammerspoon API manual.

## Lock screen
`Option+l` to lock screen.

## Show time in the middle of screen

`Option+t` to toggle the time in screen.

## Auto type url in markdown format

`Option+v` to auto type url in markdown format.

## Todo Overlay

A floating panel pinned to the top-right corner of the screen, showing lanes of an Obsidian Kanban markdown file (default: `~/Sync/wiki/Kanban/Live Kanban.md`). The panel is click-through by default so it never steals clicks from the windows below, visible on all Spaces, refreshes automatically when the file changes, and follows the system light/dark appearance.

Two buttons sit on the panel's top-right corner and are always clickable:

- `✎` toggle edit mode (the button and the panel border turn accent-colored while active)
- `＋` add a todo (inserted under the first configured lane)

Shortcuts:

- Hyper key + T, show/hide the overlay
- Hyper key + A, quick add a todo

In edit mode, items become clickable:

- Click an item to toggle done (`- [ ]` <-> `- [x]`)
- <kbd>Option</kbd> + click to delete the item
- <kbd>Cmd</kbd> + click to open the kanban file in the default app (e.g. Obsidian)

All settings (file path, lanes, size, fonts, colors, hotkeys) live in the `M.config` table at the top of `todo_overlay.lua`.

## Toggle Hammerspoon console

`Option+z` to toggle Hammerspoon console.

### Screenshots

These screenshots demostrate what awesome-hammerspoon is capable of. Learn more about [built-in Spoons](https://github.com/ashfinal/awesome-hammerspoon/wiki/The-built-in-Spoons).

## Customization


```shell
cp ~/.hammerspoon/config-example.lua ~/.hammerspoon/private/config.lua
```

Then modify the file `~/.hammerspoon/private/config.lua`:

- Add/remove Spoons.

  Define `hspoon_list` to decide which Spoons (a distributing format of Hammerspoon module) to be loaded. There are 15 built-in Spoons, learn about them at [here](https://github.com/ashfinal/awesome-hammerspoon/wiki/The-built-in-Spoons).

  *There are more Spoons at [official spoon repository](http://www.hammerspoon.org/Spoons/) (you may need a little config before using them).*

- Customize keybindings

  Please read `~/.hammerspoon/private/config.lua`for more details.


## Reference
Some resources you may find helpful:

- [Learn Lua in Y minutes](http://learnxinyminutes.com/docs/lua/)

- [Getting Started with Hammerspoon](http://www.hammerspoon.org/go/)

- [Hammerspoon API Docs](http://www.hammerspoon.org/docs/index.html)

- [hammerspoon/SPOONS.md at master · Hammerspoon/hammerspoon](https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md)


## Thanks to

- [ashfinal](https://github.com/ashfinal/awesome-hammerspoon/)

- [https://github.com/zzamboni/oh-my-hammerspoon](https://github.com/zzamboni/oh-my-hammerspoon)

- [https://github.com/scottcs/dot_hammerspoon](https://github.com/scottcs/dot_hammerspoon)

- [https://github.com/dharmapoudel/hammerspoon-config](https://github.com/dharmapoudel/hammerspoon-config)

- [http://tracesof.net/uebersicht/](http://tracesof.net/uebersicht/)

