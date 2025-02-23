# WindowManager.spoon

Window manager for hammerspoon

## Installation

In order for `hammerspoon` to know of this Spoon you must install it to the
`hammerspoon` configuration directory. This is usually `~/.hammerspoon` on most
systems.

```bash
git clone git@github.com:mikemimik/WindowManager.spoon.git ~/.hammerspoon/Spoons/
```

## Usage

In your `init.lua` file for `hammerspoon` you can add the following lines:

```lua
WindowManager = hs.loadSpoon("WindowManager")

-- WindowManager Config
-- Use custom key bindings by passing them into this function
WindowManager:bindHotKeys({})
-- Initialise this Spoon with the following function
WindowManager:start()
```

## Default Keybindings

```lua
  local defaults = {
    moveLeft = { {"cmd", "alt"}, "left" },
    moveLeftTop = { {"cmd", "ctrl", "shift"}, "left" },
    moveLeftBottom = { {"cmd", "ctrl"}, "left" },
    moveRight = { {"cmd", "alt"}, "right" },
    moveRightTop = { {"cmd", "ctrl", "shift"}, "right" },
    moveRightBottom = { {"cmd", "ctrl"}, "right" },
    moveCenter = { {"cmd", "alt"}, "c" },
    moveFull = { {"cmd", "alt"}, "f" },
    undo = { {"cmd", "ctrl"}, "u" },
  }
```
