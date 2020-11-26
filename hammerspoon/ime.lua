log = hs.logger.new('ime', 'debug')

local function zh()
    hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
end

local function en()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

local function ko()
    hs.keycodes.currentSourceID("com.apple.inputmethod.Korean.HNCRomaja")
end

-- app to expected ime config
local app2Ime = {
    {'/System/Library/CoreServices/Finder.app', 'zh'},
    {'/Applications/Alfred 4.app', 'zh'},
    {'/Applications/Bitwarden.app', 'zh'},
    {'/Applications/Dash.app', 'zh'},
    {'/Applications/iTerm.app', 'zh'},
    {'/Applications/Lark.app', 'zh'},
    {'/Applications/Xcode.app', 'zh'},
    {'/Applications/GoldenDict.app', 'zh'},
    {'/Applications/Google Chrome.app', 'zh'},
    {'/Applications/DingTalk.app', 'zh'},
    {'/Applications/KakaoTalk.app', 'ko'},
    {'/Applications/Kindle.app', 'zh'},
    {'/Applications/kitty.app', 'zh'},
    {'/Applications/NeteaseMusic.app', 'zh'},
    {'/Applications/Lark.app', 'zh'},
    {'/Applications/System Preferences.app', 'zh'},
    {'/Applications/MindNode.app', 'zh'},
    {'/Applications/Obsidian.app', 'zh'},
    {'/Applications/Preview.app', 'zh'},
    {'/Applications/Sketch.app', 'zh'},
    {'/Applications/wechatwebdevtools.app', 'zh'},
    {'/Applications/WeChat.app', 'zh'},
    {'/Users/einverne/Library/Application Support/JetBrains/Toolbox/apps/IDEA-U/ch-0/201.8538.31/IntelliJ IDEA.app', 'zh'},
}

function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
	log.d(focusAppPath)
	-- hs.alert.show(focusAppPath)
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            if expectedIme == 'en' then
                en()
            elseif expectedIme == 'zh' then
                zh()
			else
				ko()
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
	log.i(eventType)
	log.i("tet")
	log.i(hs.application.watcher.activated)
    if eventType == hs.application.watcher.activated then
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

