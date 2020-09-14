# hammerspoon configuration

hammerspoon is my configuration for [Hammerspoon](http://www.hammerspoon.org/). It has highly modal-based, vim-style keybindings, provides some functionality like desktop widgets, window management, application launcher, instant search, aria2 frontend ... etc.

## Get started

- Install [Hammerspoon](http://www.hammerspoon.org/) first.
- `git clone https://github.com/einverne/dotfiles.git ~/dotfiles`
- `ln -s ~/dotfiles/hammerspoon ~/.hammerspoon`
- Reload the configutation.

## Keep update

`cd ~/dotfiles && git pull`

## File structure

- `autoscript.lua`, auto commit and push my personal notes.
- `ime.lua`, auto switch different Input methods in different applications

## How to use
Use Karabier-Elements to set <kbd>caps lock</kbd> as hyper key. Press caps lock is just like press Cmd+Control+Option+Shift at the same time.

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
I personally use the application called Context to switch between different windows, however this config provider another way to quickly switch between windows. Try with `Option+Tab`.

## Toggle hammerspoon console

`Option+z`

## Move windows between monitors

- Hyper key + N, to move current window to next monitor
- Hpper key + P, to move current window to previous monitor

### Application launcher

Press `option + a` to enter application launcher. The shorcut information will show on the center of the screen. But I personally prefer Alfred.

## Hammerspoon API manual

`Option+h` open Hammerspoon API manual.

## Lock screen
`Option+l` to lock screen.

## Show time in the middle of screen

`Option+t` to toggle the time in screen.

## Auto type url in markdown format

`Option+v` to auto type url in markdown format.

## Toggle Hammerspoon console

`Option+z` to toggle Hammerspoon console.

### Screenshots

These screenshots demostrate what awesome-hammerspoon is capable of. Learn more about [built-in Spoons](https://github.com/ashfinal/awesome-hammerspoon/wiki/The-built-in-Spoons).

#### Desktop widgets

![widgets](https://github.com/ashfinal/bindata/raw/master/screenshots/awesome-hammerspoon-deskwidgets.png)


#### Window manpulation <kbd>⌥</kbd> + <kbd>R</kbd>

![winresize](https://github.com/ashfinal/bindata/raw/master/screenshots/awesome-hammerspoon-winresize.gif)


#### aria2 Frontend <kbd>⌥</kbd> + <kbd>D</kbd>

You need to [run aria2 with RPC enabled](https://github.com/ashfinal/awesome-hammerspoon/wiki/Run-aria2-with-rpc-enabled) before using this. Config aria2 host and token in `~/.hammerspoon/private/config.lua`, then you're ready to go.

```lua
hsaria2_host = "http://localhost:6800/jsonrpc" -- default host
hsaria2_secret = "token" -- YOUR OWN SECRET
```


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

- [https://github.com/zzamboni/oh-my-hammerspoon](https://github.com/zzamboni/oh-my-hammerspoon)

- [https://github.com/scottcs/dot_hammerspoon](https://github.com/scottcs/dot_hammerspoon)

- [https://github.com/dharmapoudel/hammerspoon-config](https://github.com/dharmapoudel/hammerspoon-config)

- [http://tracesof.net/uebersicht/](http://tracesof.net/uebersicht/)

