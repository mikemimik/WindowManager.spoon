--- === WindowManager ===
---

local m = {}
m.log = hs.logger.new("WindowManager")

m.name = "WindowManager"
m.version = "1.0.0"
m.author = "Michael Perrotte <mike@mikecorp.ca>"
m.license = "MIT <https://opensource.org/licenses/MIT>"
m.homepage = "https://github.com/mikemimik/WindowManager.spoon"

--- WindowManager:init() -> {}
--- Method
--- WindowsManager initialization.
---
--- Returns:
---  * self
function m:init()
  -- Defaults
  hs.window.animationDuration = 0.00
  hs.grid.setMargins(hs.geometry.point(0.0, 0.0))

  m.ROWS = 2
  m.MENU_HEIGHT = 25.0
  m.POSITIONS = {}
  m.cache = dofile(hs.spoons.resourcePath("cache.lua"))(self)

  local positions = dofile(hs.spoons.resourcePath("positions.lua"))(self)

  local allScreens = hs.screen.allScreens()

  for index=1, #allScreens do
    -- Manage Screen Size
    local screen = allScreens[index]
    local screenName = screen:name()
    local frame = screen:frame();

    if (m.POSITIONS[screenName] == nil) then m.POSITIONS[screenName] = {} end

    if (screenName == "Built-in Retina Display") then
      m.COLUMNS = 2
      positions:configure(screen, frame)
      m.POSITIONS[screenName] = positions:generate(frame)
    else
      m.COLUMNS = 4
      positions:configure(screen, frame)
      m.POSITIONS[screenName] = positions:generate(frame)
    end
  end

  return self
end

--- WindowManager:start() -> {}
--- Method
--- Starts the WindowsManager.
---
--- Returns:
---  * self
function m:start()
  return self
end

--- WindowManager:stop() -> {}
--- Method
--- Stops the WindowsManager.
---
--- Returns:
---  * self
function m:stop()
  return self
end

--- WindowManager:bindHotKeys(table) -> {}
--- Method
--- Expects a config table in the form of {}
---
--- Returns:
---  * self
function m:bindHotKeys(mapping)
  local utils = dofile(hs.spoons.resourcePath("utils.lua"))(self)

  local defaults = {
    moveLeft = {
      {"cmd", "alt"}, "left",
      function() utils:moveHandler("left") end
    },
    moveLeftTop = {
      {"cmd", "ctrl"}, "left",
      function() utils:moveHandler("row0left", "top left") end
    },
    moveLeftBottom = {
      {"cmd", "ctrl", "shift"}, "left",
      function() utils:moveHandler("row1left", "bottom left") end
    },
    moveRight = {
      {"cmd", "alt"}, "right",
      function() utils:moveHandler("right") end
    },
    moveRightTop = {
      {"cmd", "ctrl"}, "right",
      function() utils:moveHandler("row0right", "top right") end
    },
    moveRightBottom = {
      {"cmd", "ctrl", "shift"}, "right",
      function() utils:moveHandler("row1right", "bottom right") end
    },
    moveCenter = {
      {"cmd", "alt"}, "c",
      function()
        self.log.d("handle shift - center")
        local win = utils:findWindow()
        local screenName = win:screen():name()
        local curFrame = utils:findCurrentFrame(win)
        local xAdjusted = m.POSITIONS[screenName]["center"].x - (curFrame.w / 2)
        local yAdjusted = m.POSITIONS[screenName]["center"].y - (curFrame.h / 2)
        local centerPosition = hs.geometry.rect(xAdjusted, yAdjusted, curFrame.w, curFrame.h)
        utils:shiftWindow(win, centerPosition)
        self.log.d("done shift")
      end
    },
    moveFull = {
      {"cmd", "alt"}, "f",
      function()
        self.log.d("handle shift - full")
        local win = utils:findWindow()
        local screenName = win:screen():name()
        -- local curFrame = findCurrentFrame(win)
        local fullFrame = m.POSITIONS[screenName]["full"]
        utils:shiftWindow(win, fullFrame)
        self.log.d("done shift")
      end
    },
  }

  local merged = {}

  for k,v in pairs(defaults) do
    merged[k] = v
  end

  for k,v in pairs(mapping) do
    merged[k] = v
  end

  for _,v in pairs(merged) do
    local mod, key, func = table.unpack(v)
    hs.hotkey.bind(mod, key, func)
  end

  return self
end

return m
