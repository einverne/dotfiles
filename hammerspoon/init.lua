hs.window.animationDuration = 0

local LOGLEVEL = 'debug'

log = hs.logger.new('init', 'debug')

-- require 'autoscript'
require 'ime'
-- require 'usb'


local module = {
    'ime',
    'autoscript'
}

local function loadModuleByName(modName)
end


-- hs.loadSpoon("ReloadConfiguration")
-- spoon.ReloadConfiguration:start()
-- hs.alert.show("Config reload!")

-- Hyper key in Sierra
k = hs.hotkey.modal.new({}, "F17")

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
    k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
    k:exit()
end

f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

hyper = { "ctrl", "alt", "cmd", "shift" }

-- hs.hotkey.bind(hyper, "C", function() hs.application.launchOrFocus("Google Chrome") end)
function moveWindowToDisplay(d)
    return function()
        local displays = hs.screen.allScreens()
        log.i(displays)
        local win = hs.window.focusedWindow()
        win:moveToScreen(displays[d], false, true)
    end
end

-- hs.hotkey.bind(hyper, "m", moveWindowToDisplay(1))
-- hs.hotkey.bind(hyper, "8", moveWindowToDisplay(2))
-- hs.hotkey.bind(hyper, "9", moveWindowToDisplay(3))

function movieWinBetweenMonitors(d)
    return function()
        local win = hs.window.focusedWindow()
        -- get the screen where the focused window is displayed, a.k.a current screen
        local screen = win:screen()
        -- compute the unitRect of the focused window relative to the current screen
        -- and move the window to the next screen setting the same unitRect
        -- https://www.hammerspoon.org/docs/hs.window.html#move
        if d == 'next' then
            win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
        elseif d == 'previous' then
            win:move(win:frame():toUnitRect(screen:frame()), screen:previous(), true, 0)
        end
    end
end

hs.hotkey.bind(hyper, 'N', movieWinBetweenMonitors('next'))
hs.hotkey.bind(hyper, 'P', movieWinBetweenMonitors('previous'))

local grid = require 'hs.grid'
hs.hotkey.bind(hyper, ",", grid.show)

middle_monitor = "DELL U2414H"
left_monitor = "DELL P2417H"
right_monitor = "DELL U2412M"

local reading_layout = {
    { "Google Chrome", nil, middle_monitor, hs.layout.maximized, nil, nil },
    { "iTerm", nil, left_monitor, hs.layout.maximized, nil, nil },
    { "Miwork", nil, right_monitor, hs.layout.top50, nil, nil },
}

-- hs.hotkey.bind(hyper, "1", function()
-- 	hs.application.launchOrFocus('Google Chrome')
-- 	hs.application.launchOrFocus('iTerm')
-- 	hs.application.launchOrFocus('Miwork')
-- 
-- 	hs.layout.apply(reading_layout)
-- end)

local coding_layout = {
    { "IntelliJ IDEA Ultimate", nil, middle_monitor, hs.layout.maximized, nil, nil },
    { "iTerm", nil, left_monitor, hs.layout.maximized, nil, nil },
}

-- hs.hotkey.bind(hyper, "2", function()
-- 	hs.application.launchOrFocus('IntelliJ IDEA')
-- 
-- 	hs.layout.apply(coding_layout)
-- end)


wifiWatcher = nil
homeSSID = "PhRouter_5G"
homeDDID1 = "EinVerne_5G"
lastSSID = hs.wifi.currentNetwork()

workSSID = "XXX-5G"

function selectKarabinerProfile(profile)
    hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile '" .. profile .. "'")
end

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    local devices = hs.usb.attachedDevices()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        -- hs.alert.show("Welcome home!")
        hs.notify.new({ title = "Wifi", informativeText = "Welcome home" }):send()
        hs.audiodevice.defaultOutputDevice():setVolume(25)
        -- result = hs.network.configuration:setLocation("Home")
        -- hs.alert.show(result)
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        -- hs.alert.show("left home!")
        hs.notify.new({ title = "Wifi", informativeText = "Left home" }):send()
        hs.audiodevice.defaultOutputDevice():setVolume(0)
        -- result = hs.network.configuration:setLocation("Automatic")
        -- hs.alert.show(result)
    end

    if newSSID == workSSID then
        -- hs.alert.show("work karabiner setup")
        hs.notify.new({ title = "Wifi", informativeText = "work karabiner setup" }):send()
        selectKarabinerProfile("goku")
    else
        -- hs.alert.show("built-in karabiner setup")
        hs.notify.new({ title = "Wifi", informativeText = "built-in karabiner setup" }):send()
        selectKarabinerProfile("goku")
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

networkConf = hs.network.configuration.open()
location = networkConf:location()

function switchNetworkLocation(location)
    hs.execute('/usr/sbin/networksetup -switchtolocation ' .. location)
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "H", function()
    switchNetworkLocation("Home")
end)
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
    switchNetworkLocation("Automatic")
end)

homeDNS = "192.168.2.21"
automaticLocationUUID = "/Sets/5783E8CE-BA08-4BE2-9799-5F00E15E5837"
homeLocationUUID = "/Sets/C55127DB-F0CD-4573-890A-6F8EB59D9AFF"

hs  .network.reachability.forAddress(homeDNS):setCallback(function(self, flags)
    -- note that because having an internet connection at all will show the remote network
    -- as "reachable", we instead look at whether or not our specific address is "local" instead
    local networkConf = hs.network.configuration.open()
    if (flags & hs.network.reachability.flags.reachable) > 0 and currentLocation == homeLocationUUID then
        hs.alert.show("switch to Home network location")
        networkConf:setLocation("Home")
    elseif (flags & hs.network.reachability.flags.reachable) == 0 and currentLocation ~= homeLocationUUID then
        -- hs.alert.show("switch back to Automatic network location")
        hs.notify.new({ title = "", informativeText = "switch back to Automatic network location" }):send()
        networkConf:setLocation("Automatic")
    end
end):start()

hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- Use the standardized config location, if present
custom_config = hs.fs.pathToAbsolute(os.getenv("HOME") .. '/.config/hammerspoon/private/config.lua')
if custom_config then
    print("Loading custom config")
    dofile(os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
    privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
    if privatepath then
        hs.alert("You have config in both .config/hammerspoon and .hammerspoon/private.\nThe .config/hammerspoon one will be used.")
    end
else
    -- otherwise fallback to 'classic' location.
    if not privatepath then
        privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private')
        -- Create `~/.hammerspoon/private` directory if not exists.
        hs.fs.mkdir(hs.configdir .. '/private')
    end
    privateconf = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
    if privateconf then
        -- Load awesomeconfig file if exists
        require('private/config')
    end
end

function reloadConfig()
    hs.reload()
    hs.execute("/bin/launchctl kickstart -k \"gui/${UID}/homebrew.mxcl.yabai\"")
end

hsreload_keys = { hyper, "R" }
hsreload_keys = hsreload_keys or { { "cmd", "shift", "ctrl" }, "R" }
if string.len(hsreload_keys[2]) > 0 then
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "Reload Configuration", reloadConfig)
    hs.notify.new({ title = "Hammerspoon config reloaded", informativeText = "Manually trigged via keyboard shortcut" }):send()
end

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("ModalMgr")

-- Define default Spoons which will be loaded later
if not hspoon_list then
    hspoon_list = {
        "AClock",
        "BingDaily",
        "CircleClock",
        "ClipShow",
        --"CountDown",
        "HCalendar",
        --"HSaria2",
        "WinWin",
        --"WifiNotifier",
        "WinRectangle",
        "Caffeine",
        "PomodoroTimer",
    }
end

-- Load those Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

hs.hotkey.bind({}, "F12", function()
    local app = hs.application.get("dev.warp.Warp-Stable")
    if app then
        if not app:mainWindow() then
            app:selectMenuItem({ "Warp", "New Window" })
        elseif app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
        app:mainWindow():moveToUnit '[100, 80, 0, 0]'
    else
        hs.application.launchOrFocus("/Applications/Warp.app")
        app = hs.application.get("dev.warp.Warp-Stable")
    end
end)

----------------------------------------------------------------------------------------------------
-- Then we create/register all kinds of modal keybindings environments.
----------------------------------------------------------------------------------------------------
-- Register windowHints (Register a keybinding which is NOT modal environment with modal supervisor)
hswhints_keys = hswhints_keys or { "alt", "tab" }
if string.len(hswhints_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hswhints_keys[1], hswhints_keys[2], 'Show Window Hints', function()
        spoon.ModalMgr:deactivateAll()
        hs.hints.windowHints()
    end)
end

----------------------------------------------------------------------------------------------------
-- appM modal environment
spoon.ModalMgr:new("appM")
local cmodal = spoon.ModalMgr.modal_list["appM"]
cmodal:bind('', 'escape', 'Deactivate appM', function()
    spoon.ModalMgr:deactivate({ "appM" })
end)
cmodal:bind('', 'Q', 'Deactivate appM', function()
    spoon.ModalMgr:deactivate({ "appM" })
end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function()
    spoon.ModalMgr:toggleCheatsheet()
end)
if not hsapp_list then
    hsapp_list = {
        { key = 'f', name = 'Finder' },
        { key = 'c', name = 'Google Chrome' },
        { key = 'o', name = 'Obsidian' },
        { key = 's', name = 'Safari' },
        { key = 't', name = 'Terminal' },
        { key = 'v', id = 'com.apple.ActivityMonitor' },
        { key = 'y', id = 'com.apple.systempreferences' },
    }
end
for _, v in ipairs(hsapp_list) do
    if v.id then
        local located_name = hs.application.nameForBundleID(v.id)
        if located_name then
            cmodal:bind('', v.key, located_name, function()
                hs.application.launchOrFocusByBundleID(v.id)
                spoon.ModalMgr:deactivate({ "appM" })
            end)
        end
    elseif v.name then
        cmodal:bind('', v.key, v.name, function()
            hs.application.launchOrFocus(v.name)
            spoon.ModalMgr:deactivate({ "appM" })
        end)
    end
end

-- Then we register some keybindings with modal supervisor
hsappM_keys = hsappM_keys or { "alt", "A" }
if string.len(hsappM_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsappM_keys[1], hsappM_keys[2], "Enter AppM Environment", function()
        spoon.ModalMgr:deactivateAll()
        -- Show the keybindings cheatsheet once appM is activated
        spoon.ModalMgr:activate({ "appM" }, "#FFBD2E", true)
    end)
end

----------------------------------------------------------------------------------------------------
-- clipshowM modal environment
if spoon.ClipShow then
    spoon.ModalMgr:new("clipshowM")
    local cmodal = spoon.ModalMgr.modal_list["clipshowM"]
    cmodal:bind('', 'escape', 'Deactivate clipshowM', function()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)
    cmodal:bind('', 'Q', 'Deactivate clipshowM', function()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)
    cmodal:bind('', 'N', 'Save this Session', function()
        spoon.ClipShow:saveToSession()
    end)
    cmodal:bind('', 'R', 'Restore last Session', function()
        spoon.ClipShow:restoreLastSession()
    end)
    cmodal:bind('', 'B', 'Open in Browser', function()
        spoon.ClipShow:openInBrowserWithRef()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)
    cmodal:bind('', 'S', 'Search with Bing', function()
        spoon.ClipShow:openInBrowserWithRef("https://www.bing.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)
    cmodal:bind('', 'M', 'Open in MacVim', function()
        spoon.ClipShow:openWithCommand("/usr/local/bin/mvim")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)
    cmodal:bind('', 'F', 'Save to Desktop', function()
        spoon.ClipShow:saveToFile()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)
    cmodal:bind('', 'H', 'Search in Github', function()
        spoon.ClipShow:openInBrowserWithRef("https://github.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)
    cmodal:bind('', 'G', 'Search with Google', function()
        spoon.ClipShow:openInBrowserWithRef("https://www.google.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)
    cmodal:bind('', 'L', 'Open in Sublime Text', function()
        spoon.ClipShow:openWithCommand("/usr/local/bin/subl")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({ "clipshowM" })
    end)

end

----------------------------------------------------------------------------------------------------
-- Register HSaria2
if spoon.HSaria2 then
    -- First we need to connect to aria2 rpc host
    hsaria2_host = hsaria2_host or "http://localhost:6800/jsonrpc"
    hsaria2_secret = hsaria2_secret or "token"
    spoon.HSaria2:connectToHost(hsaria2_host, hsaria2_secret)

    hsaria2_keys = hsaria2_keys or { "alt", "D" }
    if string.len(hsaria2_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsaria2_keys[1], hsaria2_keys[2], 'Toggle aria2 Panel', function()
            spoon.HSaria2:togglePanel()
        end)
    end
end


----------------------------------------------------------------------------------------------------
-- Register Hammerspoon API manual: Open Hammerspoon manual in default browser
-- hsman_keys = hsman_keys or {"alt", "H"}
-- if string.len(hsman_keys[2]) > 0 then
--     spoon.ModalMgr.supervisor:bind(hsman_keys[1], hsman_keys[2], "Read Hammerspoon Manual", function()
--         hs.doc.hsdocs.forceExternalBrowser(true)
--         hs.doc.hsdocs.moduleEntitiesInSidebar(true)
--         hs.doc.hsdocs.help()
--     end)
-- end

----------------------------------------------------------------------------------------------------
-- countdownM modal environment
if spoon.CountDown then
    spoon.ModalMgr:new("countdownM")
    local cmodal = spoon.ModalMgr.modal_list["countdownM"]
    cmodal:bind('', 'escape', 'Deactivate countdownM', function()
        spoon.ModalMgr:deactivate({ "countdownM" })
    end)
    cmodal:bind('', 'Q', 'Deactivate countdownM', function()
        spoon.ModalMgr:deactivate({ "countdownM" })
    end)
    cmodal:bind('', 'tab', 'Toggle Cheatsheet', function()
        spoon.ModalMgr:toggleCheatsheet()
    end)
    cmodal:bind('', '0', '5 Minutes Countdown', function()
        spoon.CountDown:startFor(5)
        spoon.ModalMgr:deactivate({ "countdownM" })
    end)
    for i = 1, 9 do
        cmodal:bind('', tostring(i), string.format("%s Minutes Countdown", 10 * i), function()
            spoon.CountDown:startFor(10 * i)
            spoon.ModalMgr:deactivate({ "countdownM" })
        end)
    end
    cmodal:bind('', 'return', '25 Minutes Countdown', function()
        spoon.CountDown:startFor(25)
        spoon.ModalMgr:deactivate({ "countdownM" })
    end)
    cmodal:bind('', 'space', 'Pause/Resume CountDown', function()
        spoon.CountDown:pauseOrResume()
        spoon.ModalMgr:deactivate({ "countdownM" })
    end)

    -- Register countdownM with modal supervisor
    hscountdM_keys = hscountdM_keys or { "alt", "I" }
    if string.len(hscountdM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hscountdM_keys[1], hscountdM_keys[2], "Enter countdownM Environment", function()
            spoon.ModalMgr:deactivateAll()
            -- Show the keybindings cheatsheet once countdownM is activated
            spoon.ModalMgr:activate({ "countdownM" }, "#FF6347", true)
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- resizeM modal environment
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'escape', 'Deactivate resizeM', function()
        spoon.ModalMgr:deactivate({ "resizeM" })
    end)
    cmodal:bind('', 'Q', 'Deactivate resizeM', function()
        spoon.ModalMgr:deactivate({ "resizeM" })
    end)
    cmodal:bind('', 'tab', 'Toggle Cheatsheet', function()
        spoon.ModalMgr:toggleCheatsheet()
    end)
    cmodal:bind('', 'A', 'Move Leftward', function()
        spoon.WinWin:stepMove("left")
    end, nil, function()
        spoon.WinWin:stepMove("left")
    end)
    cmodal:bind('', 'D', 'Move Rightward', function()
        spoon.WinWin:stepMove("right")
    end, nil, function()
        spoon.WinWin:stepMove("right")
    end)
    cmodal:bind('', 'W', 'Move Upward', function()
        spoon.WinWin:stepMove("up")
    end, nil, function()
        spoon.WinWin:stepMove("up")
    end)
    cmodal:bind('', 'S', 'Move Downward', function()
        spoon.WinWin:stepMove("down")
    end, nil, function()
        spoon.WinWin:stepMove("down")
    end)
    cmodal:bind('', 'H', 'Lefthalf of Screen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfleft")
    end)
    cmodal:bind('', 'L', 'Righthalf of Screen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfright")
    end)
    cmodal:bind('', 'K', 'Uphalf of Screen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfup")
    end)
    cmodal:bind('', 'J', 'Downhalf of Screen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfdown")
    end)
    cmodal:bind('', 'Y', 'NorthWest Corner', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerNW")
    end)
    cmodal:bind('', 'O', 'NorthEast Corner', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerNE")
    end)
    cmodal:bind('', 'U', 'SouthWest Corner', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerSW")
    end)
    cmodal:bind('', 'I', 'SouthEast Corner', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerSE")
    end)
    cmodal:bind('', 'F', 'Fullscreen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("fullscreen")
    end)
    cmodal:bind('', 'C', 'Center Window', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("center")
    end)
    cmodal:bind('', '=', 'Stretch Outward', function()
        spoon.WinWin:moveAndResize("expand")
    end, nil, function()
        spoon.WinWin:moveAndResize("expand")
    end)
    cmodal:bind('', '-', 'Shrink Inward', function()
        spoon.WinWin:moveAndResize("shrink")
    end, nil, function()
        spoon.WinWin:moveAndResize("shrink")
    end)
    cmodal:bind('shift', 'H', 'Move Leftward', function()
        spoon.WinWin:stepResize("left")
    end, nil, function()
        spoon.WinWin:stepResize("left")
    end)
    cmodal:bind('shift', 'L', 'Move Rightward', function()
        spoon.WinWin:stepResize("right")
    end, nil, function()
        spoon.WinWin:stepResize("right")
    end)
    cmodal:bind('shift', 'K', 'Move Upward', function()
        spoon.WinWin:stepResize("up")
    end, nil, function()
        spoon.WinWin:stepResize("up")
    end)
    cmodal:bind('shift', 'J', 'Move Downward', function()
        spoon.WinWin:stepResize("down")
    end, nil, function()
        spoon.WinWin:stepResize("down")
    end)
    cmodal:bind('', 'left', 'Move to Left Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("left")
    end)
    cmodal:bind('', 'right', 'Move to Right Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("right")
    end)
    cmodal:bind('', 'up', 'Move to Above Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("up")
    end)
    cmodal:bind('', 'down', 'Move to Below Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("down")
    end)
    cmodal:bind('', 'space', 'Move to Next Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("next")
    end)
    cmodal:bind('', '[', 'Undo Window Manipulation', function()
        spoon.WinWin:undo()
    end)
    cmodal:bind('', ']', 'Redo Window Manipulation', function()
        spoon.WinWin:redo()
    end)
    cmodal:bind('', '`', 'Center Cursor', function()
        spoon.WinWin:centerCursor()
    end)

    -- Register resizeM with modal supervisor
    hsresizeM_keys = hsresizeM_keys or { "alt", "R" }
    if string.len(hsresizeM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "Enter resizeM Environment", function()
            -- Deactivate some modal environments or not before activating a new one
            spoon.ModalMgr:deactivateAll()
            -- Show an status indicator so we know we're in some modal environment now
            spoon.ModalMgr:activate({ "resizeM" }, "#B22222")
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- cheatsheetM modal environment (Because KSheet Spoon is NOT loaded, cheatsheetM will NOT be activated)
-- if spoon.KSheet then
--     spoon.ModalMgr:new("cheatsheetM")
--     local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
--     cmodal:bind('', 'escape', 'Deactivate cheatsheetM', function()
--         spoon.KSheet:hide()
--         spoon.ModalMgr:deactivate({"cheatsheetM"})
--     end)
--     cmodal:bind('', 'Q', 'Deactivate cheatsheetM', function()
--         spoon.KSheet:hide()
--         spoon.ModalMgr:deactivate({"cheatsheetM"})
--     end)
-- 
--     -- Register cheatsheetM with modal supervisor
--     hscheats_keys = hscheats_keys or {"alt", "S"}
--     if string.len(hscheats_keys[2]) > 0 then
--         spoon.ModalMgr.supervisor:bind(hscheats_keys[1], hscheats_keys[2], "Enter cheatsheetM Environment", function()
--             spoon.KSheet:show()
--             spoon.ModalMgr:deactivateAll()
--             spoon.ModalMgr:activate({"cheatsheetM"})
--         end)
--     end
-- end

----------------------------------------------------------------------------------------------------
-- Register AClock
-- if spoon.AClock then
--     hsaclock_keys = hsaclock_keys or {"alt", "T"}
--     if string.len(hsaclock_keys[2]) > 0 then
--         spoon.ModalMgr.supervisor:bind(hsaclock_keys[1], hsaclock_keys[2], "Toggle Floating Clock", function() spoon.AClock:toggleShow() end)
--     end
-- end

-- Register WinRectangle
if spoon.WinRectangle then
    spoon.WinRectangle:bindHotkeys(spoon.WinRectangle.defaultHotkeys)
end

-- Register Caffeine
-- if spoon.Caffeine then
-- 	spoon.Caffeine:start()
-- end

--if spoon.wifiNotifier then
--	spoon.wifiNotifier:start()
--end

log.d("PomodoroTimer Spoon loaded successfully")
if spoon.PomodoroTimer then
    hs.hotkey.bind({ "cmd", "ctrl" }, "0", function()
        log.d("PomodoroTimer hotkey pressed")
        spoon.PomodoroTimer:toggle()
    end)
    log.d("PomodoroTimer hotkey bound")
end

----------------------------------------------------------------------------------------------------
-- Register browser tab typist: Type URL of current tab of running browser in markdown format. i.e. [title](link)
-- hstype_keys = hstype_keys or {"alt", "V"}
-- if string.len(hstype_keys[2]) > 0 then
--     spoon.ModalMgr.supervisor:bind(hstype_keys[1], hstype_keys[2], "Type Browser Link", function()
--         local safari_running = hs.application.applicationsForBundleID("com.apple.Safari")
--         local chrome_running = hs.application.applicationsForBundleID("com.google.Chrome")
--         if #safari_running > 0 then
--             local stat, data = hs.applescript('tell application "Safari" to get {URL, name} of current tab of window 1')
--             if stat then hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")") end
--         elseif #chrome_running > 0 then
--             local stat, data = hs.applescript('tell application "Google Chrome" to get {URL, title} of active tab of window 1')
--             if stat then hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")") end
--         end
--     end)
-- end

----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
