local function Chinese()
    hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

-- app to expected ime config
local app2Ime = {
    {'/System/Library/CoreServices/Finder.app', 'Chinese'},
    {'/Applications/Alfred 4.app', 'Chinese'},
    {'/Applications/Bitwarden.app', 'Chinese'},
    {'/Applications/Dash.app', 'Chinese'},
    {'/Applications/iTerm.app', 'Chinese'},
    {'/Applications/Lark.app', 'Chinese'},
    {'/Applications/Xcode.app', 'Chinese'},
    {'/Applications/GoldenDict.app', 'Chinese'},
    {'/Applications/Google Chrome.app', 'Chinese'},
    {'/Applications/DingTalk.app', 'Chinese'},
    {'/Applications/Kindle.app', 'Chinese'},
    {'/Applications/NeteaseMusic.app', 'Chinese'},
    {'/Applications/WeChat.app', 'Chinese'},
    {'/Applications/Lark.app', 'Chinese'},
    {'/Applications/System Preferences.app', 'Chinese'},
    {'/Applications/MindNode.app', 'Chinese'},
    {'/Applications/Obsidian.app', 'Chinese'},
    {'/Applications/Preview.app', 'Chinese'},
    {'/Applications/Sketch.app', 'Chinese'},
    {'/Applications/wechatwebdevtools.app', 'Chinese'},
    {'/Applications/WeChat.app', 'Chinese'},
    {'/Users/einverne/Library/Application Support/JetBrains/Toolbox/apps/IDEA-U/ch-0/201.8538.31/IntelliJ IDEA.app', 'Chinese'},
}

function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
	-- hs.alert.show(focusAppPath)
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            if expectedIme == 'English' then
                English()
            else
                Chinese()
            end
            break
        end
    end
end

-- helper hotkey to figure out the app path and name of current focused window
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

