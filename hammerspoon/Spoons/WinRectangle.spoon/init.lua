--- === WinRectangle ===
---
--- Manage windows
---
--- Download: []()

local obj={}
obj.__index = obj

--- Metadata
obj.name = "WinRectangle"
obj.version = "0.1"
obj.author = "Ein Verne <i@einverne.info>"
obj.homepage = "https://github.com/einverne/dotfiles"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- WinRectangle.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('WinRectangle')

log = hs.logger.new('WinRectangle', 'debug')


--- WinRectangle.defaultHotkeys
--- Variable
--- Table containing a sample set of hotkeys that can be
--- assigned to the different operations. These are not bound
--- by default - if you want to use them you have to call:
--- `spoon.WinRectangle:bindHotkeys(spoon.WinRectangle.defaultHotkeys)`
--- after loading the spoon. Value:
--- ```
--- function()
---   local win = hs.window.focusedWindow()
---   local f = win:frame()
---   local screen = win:screen()
---   local max = screen:frame()
---
---   f.x = max.x
---   f.y = max.y
---   f.w = max.w / 2
---   f.h = max.h
---   win:setFrame(f)
--- end
--- ```
obj.defaultHotkeys = {
   screen_left = { {"ctrl", "alt", "cmd", "shift"}, "H" },
   screen_right= { {"ctrl", "alt", "cmd", "shift"}, "L" },
   screen_down = { {"ctrl", "alt", "cmd", "shift"}, "J" },
   screen_up   = { {"ctrl", "alt", "cmd", "shift"}, "K" },
   screen_full = { {"ctrl", "alt", "cmd", "shift"}, "F" },
   screen_left_up = { {"ctrl", "alt", "cmd", "shift"}, "Y" },
   screen_right_up = { {"ctrl", "alt", "cmd", "shift"}, "O" },
   screen_left_bottom = { {"ctrl", "alt", "cmd", "shift"}, "U" },
   screen_right_bottom = { {"ctrl", "alt", "cmd", "shift"}, "I" },
}

--- WinRectangle.animationDuration
--- Variable
--- Length of the animation to use for the window movements across the
--- screens. `nil` means to use the existing value from
--- `hs.window.animationDuration`. 0 means to disable the
--- animations. Default: `nil`.
obj.animationDuration = nil

-- Internal functions to store/restore the current value of setFrameCorrectness and animationDuration
local function _setFC()
  obj._savedFC = hs.window.setFrameCorrectness
  obj._savedDuration = hs.window.animationDuration
  hs.window.setFrameCorrectness = obj.use_frame_correctness
  if obj.animationDuration ~= nil then
    hs.window.animationDuration = obj.animationDuration
  end
end

local function _restoreFC()
  hs.window.setFrameCorrectness = obj._savedFC
  if obj.animationDuration ~= nil then
    hs.window.animationDuration = obj._savedDuration
  end
end

-- Move current window to a different screen
function obj.moveCurrentWindowToScreen(how)
   local win = hs.window.focusedWindow()
   if win == nil then
      return
   end
   _setFC()
   if how == "left" then
      win:moveOneScreenWest()
   elseif how == "right" then
      win:moveOneScreenEast()
   end
   _restoreFC()
end

function obj.moveWindow(direction)
	log.i("movie window to " .. direction)
	local win      = hs.window.focusedWindow()
	local app      = win:application()
	local app_name = app:name()
	local f        = win:frame()
	local screen   = win:screen()
	local max      = screen:frame()
	if direction == "left" then
		f.x = max.x
		f.y = max.y
		f.w = (max.w / 2)
		f.h = max.h
	elseif direction == "right" then
		f.x = (max.x + (max.w / 2))
		f.y = max.y
		f.w = (max.w / 2)
		f.h = max.h
	elseif direction == "full" then
		f.x = max.x
		f.y = max.y
		f.w = max.w
		f.h = max.h
	elseif direction == "up" then
		f.x = max.x
		f.y = max.y
		f.w = max.w
		f.h = (max.h / 2)
	elseif direction == "down" then
		f.x = max.x
		f.y = max.y + (max.h / 2)
		f.w = max.w
		f.h = max.h / 2
	elseif direction == "leftUp" then
		f.x = max.x
		f.y = max.y
		f.w = max.w / 2
		f.h = max.h / 2
	elseif direction == "rightUp" then
		f.x = max.w / 2
		f.y = max.y
		f.w = max.w / 2
		f.h = max.h / 2
	elseif direction == "leftBottom" then
		f.x = max.x
		f.y = max.h / 2
		f.w = max.w / 2
		f.h = max.h / 2
	elseif direction == "rightBottom" then
		f.x = max.w / 2
		f.y = max.h / 2
		f.w = max.w / 2
		f.h = max.h / 2
	elseif direction == "normal" then
		f.x = (max.x + (max.w / 8)) + 6
		f.y = max.y
		f.w = (max.w * 3 / 4) - 12
		f.h = max.h
	end
	win:setFrame(f, 0.0)
end

-- --------------------------------------------------------------------
-- Shortcut functions for those above, for the hotkeys
-- --------------------------------------------------------------------

obj.oneScreenLeft  = hs.fnutils.partial(obj.moveWindow, "left")
obj.oneScreenRight = hs.fnutils.partial(obj.moveWindow, "right")
obj.oneScreenDown  = hs.fnutils.partial(obj.moveWindow, "down")
obj.oneScreenUp    = hs.fnutils.partial(obj.moveWindow, "up")
obj.oneScreenFull  = hs.fnutils.partial(obj.moveWindow, "full")
obj.oneScreenLeftUp  = hs.fnutils.partial(obj.moveWindow, "leftUp")
obj.oneScreenRightUp  = hs.fnutils.partial(obj.moveWindow, "rightUp")
obj.oneScreenLeftBottom  = hs.fnutils.partial(obj.moveWindow, "leftBottom")
obj.oneScreenRightBottom  = hs.fnutils.partial(obj.moveWindow, "rightBottom")

--- WinRectangle:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for WinRectangle
---
--- Parameters:
---  * mapping - A table containing hotkey objifier/key details for the following items:
---  * screen_left, screen_right - move the window to the left/right screen (if you have more than one monitor connected, does nothing otherwise)
function obj:bindHotkeys(mapping)
   local hotkeyDefinitions = {
      screen_left  = self.oneScreenLeft,
      screen_right = self.oneScreenRight,
	  screen_down  = self.oneScreenDown,
	  screen_up    = self.oneScreenUp,
	  screen_full  = self.oneScreenFull,
	  screen_left_up = self.oneScreenLeftUp,
	  screen_right_up = self.oneScreenRightUp,
	  screen_left_bottom = self.oneScreenLeftBottom,
	  screen_right_bottom = self.oneScreenRightBottom,
   }
   hs.spoons.bindHotkeysToSpec(hotkeyDefinitions, mapping)
   return self
end

return obj
