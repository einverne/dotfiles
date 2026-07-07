-- todo_overlay.lua
-- Floating Todo overlay reading Obsidian Kanban markdown (Todo / Doing lanes).
--
-- Two canvases:
--  * main panel  - view mode (default): no mouseCallback -> true click-through;
--                  edit mode: items clickable (click = toggle done,
--                  alt-click = delete line, cmd-click = open file).
--  * control bar - tiny always-clickable canvas on the panel's top-right
--                  corner holding the [✎ edit toggle] and [＋ add] buttons.
--                  Click-through is window-level all-or-nothing, so the
--                  buttons must live on their own window to stay clickable
--                  while the main panel is transparent to clicks.
--
-- File edits are line-surgical: only the target line is rewritten, everything
-- else (including the %% kanban:settings %% block) is preserved byte-for-byte.

local M = {}

local log = hs.logger.new('todo_overlay', 'info')

----------------------------------------------------------------------------
-- Configuration (all tunables live here)
----------------------------------------------------------------------------
M.config = {
    filePath   = os.getenv("HOME") .. "/Sync/wiki/Kanban/Live Kanban.md",
    sections   = { "Todo" }, -- kanban lanes to display, in order
    maxItems   = 12,                  -- per-section display cap

    width      = 300,                 -- content width (pt)
    margin     = { x = 16, y = 8 },   -- offset from screen top-right corner
    padding    = { x = 14, y = 12 },  -- inner padding of the panel
    itemGap    = 5,                   -- vertical gap between items
    sectionGap = 10,                  -- extra gap before a section header
    corner     = 12,                  -- rounded corner radius
    shadowPad  = 18,                  -- canvas inset so the shadow isn't clipped

    fontSize       = 13,
    headerFontSize = 11,

    screen = "primary",               -- "primary" or "main" (screen w/ focused window)
    level  = "floating",              -- hs.canvas.windowLevels key

    hotkeys = {
        toggle = { { "ctrl", "alt", "cmd", "shift" }, "T" }, -- show / hide
        add    = { { "ctrl", "alt", "cmd", "shift" }, "A" }, -- quick add todo
    },

    theme = {
        light = {
            bg     = { white = 0.98, alpha = 0.85 },
            header = { white = 0.45, alpha = 1 },
            text   = { white = 0.15, alpha = 1 },
            done   = { white = 0.60, alpha = 1 },
            accent = { red = 0.95, green = 0.55, blue = 0.15, alpha = 1 },
            shadow = { alpha = 0.30 },
        },
        dark = {
            bg     = { white = 0.13, alpha = 0.85 },
            header = { white = 0.60, alpha = 1 },
            text   = { white = 0.92, alpha = 1 },
            done   = { white = 0.50, alpha = 1 },
            accent = { red = 1.0, green = 0.65, blue = 0.25, alpha = 1 },
            shadow = { alpha = 0.60 },
        },
    },
}

----------------------------------------------------------------------------
-- Internal state (single long-lived canvas + reusable watchers/timers)
----------------------------------------------------------------------------
local canvas          -- hs.canvas main panel, created once in start()
local controlCanvas   -- hs.canvas button bar, always clickable
local pathWatcher     -- hs.pathwatcher on the parent directory
local screenWatcher   -- hs.screen.watcher, repositions on display changes
local themeWatcher    -- hs.distributednotifications for dark mode switches
local refreshDebounce -- hs.timer.delayed, coalesces file-event bursts
local hotkeyObjs = {}

local items = {}       -- parsed items: { text, raw, lineNo, done, section }
local lastContent      -- raw file content of the last render (dirty check)
local visible  = true
local editMode = false -- view mode = click-through main panel

----------------------------------------------------------------------------
-- Markdown parsing / file surgery
----------------------------------------------------------------------------
local function readFile()
    local f = io.open(M.config.filePath, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return content
end

local function splitLines(content)
    local lines = {}
    for line in (content .. "\n"):gmatch("(.-)\n") do
        lines[#lines + 1] = line
    end
    return lines
end

local function writeLines(lines)
    local f = io.open(M.config.filePath, "w")
    if not f then
        hs.alert.show("TodoOverlay: cannot write file")
        return false
    end
    f:write(table.concat(lines, "\n"))
    f:close()
    return true
end

-- Strip Obsidian/markdown decorations for display: [[page|alias]], [[page]],
-- [text](url), **bold**.
local function cleanText(s)
    s = s:gsub("%[%[([^%]|]-)|([^%]]-)%]%]", "%2")
    s = s:gsub("%[%[([^%]]-)%]%]", "%1")
    s = s:gsub("%[([^%]]-)%]%(([^%)]-)%)", "%1")
    s = s:gsub("%*%*(.-)%*%*", "%1")
    return s
end

-- Parse kanban content into a flat item list, keeping 1-based line numbers so
-- edits can address the exact source line later.
local function parseContent(content)
    local wanted = {}
    for _, name in ipairs(M.config.sections) do wanted[name] = true end

    local result, section = {}, nil
    local lineNo = 0
    for line in (content .. "\n"):gmatch("(.-)\n") do
        lineNo = lineNo + 1
        if line:match("^%%%%") then break end -- kanban settings block: stop
        local header = line:match("^##%s+(.-)%s*$")
        if header then
            section = wanted[header] and header or nil
        elseif section then
            local mark, text = line:match("^%- %[([ xX])%]%s*(.-)%s*$")
            if mark and text ~= "" then
                result[#result + 1] = {
                    raw     = line,
                    lineNo  = lineNo,
                    section = section,
                    done    = mark ~= " ",
                    text    = cleanText(text),
                }
            end
        end
    end
    return result
end

-- Re-read the file and apply `fn(lines, idx)` to the item's line, but only if
-- the line still matches what we rendered (guards against sync races).
local function surgicalEdit(item, fn)
    local content = readFile()
    if not content then return end
    local lines = splitLines(content)
    if lines[item.lineNo] ~= item.raw then
        hs.alert.show("Todo file changed, refreshing…")
        M.refresh(true)
        return
    end
    fn(lines, item.lineNo)
    if writeLines(lines) then M.refresh(true) end
end

local function toggleItem(item)
    surgicalEdit(item, function(lines, i)
        if item.done then
            lines[i] = lines[i]:gsub("^%- %[[xX]%]", "- [ ]", 1)
        else
            lines[i] = lines[i]:gsub("^%- %[ %]", "- [x]", 1)
        end
    end)
end

local function deleteItem(item)
    surgicalEdit(item, function(lines, i)
        table.remove(lines, i)
    end)
end

local function addItem(text)
    local content = readFile()
    if not content then return end
    local lines = splitLines(content)
    local headerPat = "^##%s+" .. M.config.sections[1] .. "%s*$"
    for i, line in ipairs(lines) do
        if line:match(headerPat) then
            table.insert(lines, i + 1, "- [ ] " .. text)
            if writeLines(lines) then M.refresh(true) end
            return
        end
    end
    hs.alert.show("TodoOverlay: section '## " .. M.config.sections[1] .. "' not found")
end

----------------------------------------------------------------------------
-- Rendering
----------------------------------------------------------------------------
local function currentTheme()
    local dark = (hs.host.interfaceStyle() == "Dark")
    return dark and M.config.theme.dark or M.config.theme.light
end

local function targetScreen()
    if M.config.screen == "main" then return hs.screen.mainScreen() end
    return hs.screen.primaryScreen()
end

local function styledItem(item, theme)
    local glyph = item.done and "✓ " or (item.section == "Doing" and "◉ " or "○ ")
    local color = item.done and theme.done or theme.text
    local attrs = {
        font  = { size = M.config.fontSize },
        color = color,
        paragraphStyle = { lineBreak = "truncatingTail" },
    }
    if item.done then
        attrs.strikethroughStyle = hs.styledtext.lineStyles.single
    end
    local st = hs.styledtext.new(glyph .. item.text, attrs)
    if not item.done and item.section == "Doing" then
        -- accent only the leading glyph so "in progress" items pop
        -- (styledtext ranges are character-based; the glyph is multi-byte UTF-8)
        st = st:setStyle({ color = theme.accent }, 1, utf8.len(glyph))
    end
    return st
end

-- Control bar: [✎ edit toggle][＋ add], anchored to the panel's top-right.
-- Lives on its own always-clickable canvas; see the file header for why.
local CTRL_BTN, CTRL_GAP = 20, 4

local function renderControls(theme, panelFrame)
    if not controlCanvas then return end
    local cfg = M.config
    local w = CTRL_BTN * 2 + CTRL_GAP
    controlCanvas:frame({
        x = panelFrame.x + panelFrame.w - cfg.shadowPad - cfg.padding.x - w + 4,
        y = panelFrame.y + cfg.shadowPad + cfg.padding.y - 3,
        w = w,
        h = CTRL_BTN,
    })
    controlCanvas:replaceElements({
        {
            type = "text", id = "edit", trackMouseDown = true,
            text = hs.styledtext.new("✎", {
                font = { size = cfg.fontSize + 1 },
                color = editMode and theme.accent or theme.header,
                paragraphStyle = { alignment = "center" },
            }),
            frame = { x = 0, y = 0, w = CTRL_BTN, h = CTRL_BTN },
        },
        {
            type = "text", id = "add", trackMouseDown = true,
            text = hs.styledtext.new("＋", {
                font = { size = cfg.fontSize + 2 },
                color = theme.header,
                paragraphStyle = { alignment = "center" },
            }),
            frame = { x = CTRL_BTN + CTRL_GAP, y = 0, w = CTRL_BTN, h = CTRL_BTN },
        },
    })
end

-- Rebuild all canvas elements and resize/reposition the canvas.
-- Called only when content, theme, edit mode or screen layout changed, so a
-- full element rebuild (single redraw) is cheap and flicker-free.
local function render()
    if not canvas then return end
    local cfg, theme = M.config, currentTheme()
    local pad, sp = cfg.padding, cfg.shadowPad
    local contentW = cfg.width - 2 * pad.x
    local els = {}

    -- [1] background: frame is filled in after we know the total height;
    -- accent border marks edit mode
    els[1] = {
        type = "rectangle",
        action = editMode and "strokeAndFill" or "fill",
        fillColor = theme.bg,
        strokeColor = theme.accent,
        strokeWidth = 2,
        roundedRectRadii = { xRadius = cfg.corner, yRadius = cfg.corner },
        withShadow = true,
        shadow = { blurRadius = 14, color = theme.shadow, offset = { h = -4, w = 0 } },
    }

    local y = sp + pad.y
    local function addText(st, id, extraGap)
        local size = canvas:minimumTextSize(st)
        local h = math.ceil(size.h) + 1
        els[#els + 1] = {
            type = "text", text = st, id = id,
            trackMouseDown = (id ~= nil),
            frame = { x = sp + pad.x, y = y, w = contentW, h = h },
        }
        y = y + h + (extraGap or cfg.itemGap)
    end

    local bySection = {}
    for _, it in ipairs(items) do
        bySection[it.section] = bySection[it.section] or {}
        table.insert(bySection[it.section], it)
    end

    local rendered = 0
    for _, name in ipairs(cfg.sections) do
        local list = bySection[name]
        if list and #list > 0 then
            if rendered > 0 then y = y + cfg.sectionGap end
            addText(hs.styledtext.new(name:upper(), {
                font = { size = cfg.headerFontSize },
                color = theme.header,
            }))
            for i, it in ipairs(list) do
                if i > cfg.maxItems then
                    addText(hs.styledtext.new(("+%d more…"):format(#list - cfg.maxItems), {
                        font = { size = cfg.headerFontSize }, color = theme.done,
                    }))
                    break
                end
                addText(styledItem(it, theme), "item:" .. tostring(it.lineNo))
                rendered = rendered + 1
            end
        end
    end

    if rendered == 0 then
        addText(hs.styledtext.new(#items == 0 and "Nothing to do 🎉" or "…", {
            font = { size = cfg.fontSize }, color = theme.done,
        }))
    end

    local totalH = (y - cfg.itemGap) + pad.y - sp
    els[1].frame = { x = sp, y = sp, w = cfg.width, h = totalH }

    local sf = targetScreen():frame()
    local panelFrame = {
        x = sf.x + sf.w - cfg.width - cfg.margin.x - sp,
        y = sf.y + cfg.margin.y - sp,
        w = cfg.width + 2 * sp,
        h = totalH + 2 * sp,
    }
    canvas:frame(panelFrame)
    canvas:replaceElements(els)
    renderControls(theme, panelFrame)
end

----------------------------------------------------------------------------
-- Refresh pipeline: pathwatcher -> debounce -> dirty check -> render
----------------------------------------------------------------------------
function M.refresh(force)
    local content = readFile()
    if content == nil then
        items, lastContent = {}, nil
        if canvas then
            canvas:replaceElements({ {
                type = "text",
                text = "⚠️ cannot read todo file",
                textSize = M.config.fontSize,
                frame = { x = M.config.shadowPad, y = M.config.shadowPad, w = M.config.width, h = 40 },
            } })
        end
        return
    end
    if not force and content == lastContent then return end -- nothing changed
    lastContent = content
    items = parseContent(content)
    render()
end

----------------------------------------------------------------------------
-- Interaction (edit mode)
----------------------------------------------------------------------------
local function findItemByLine(lineNo)
    for _, it in ipairs(items) do
        if it.lineNo == lineNo then return it end
    end
end

-- Main panel clicks (installed only in edit mode)
local function onMouse(_, event, id)
    if event ~= "mouseDown" then return end
    local lineNo = tonumber(tostring(id):match("^item:(%d+)$"))
    if not lineNo then return end
    local item = findItemByLine(lineNo)
    if not item then return end

    local mods = hs.eventtap.checkKeyboardModifiers()
    if mods.cmd then
        hs.execute(string.format('open "%s"', M.config.filePath))
    elseif mods.alt then
        deleteItem(item)
    else
        toggleItem(item)
    end
end

-- Control bar clicks (always active)
local function onControlMouse(_, event, id)
    if event ~= "mouseDown" then return end
    if id == "edit" then
        M.toggleEdit()
    elseif id == "add" then
        M.promptAdd()
    end
end

----------------------------------------------------------------------------
-- Public API
----------------------------------------------------------------------------
function M.toggleShow()
    visible = not visible
    if visible then
        M.refresh(true) -- content may have changed while hidden
        canvas:show()
        controlCanvas:show()
    else
        canvas:hide()
        controlCanvas:hide()
    end
end

function M.toggleEdit()
    editMode = not editMode
    -- mouseCallback(nil) restores ignoresMouseEvents on the underlying
    -- NSWindow, i.e. full click-through in view mode.
    canvas:mouseCallback(editMode and onMouse or nil)
    render() -- recolor the ✎ button to reflect the state
end

function M.promptAdd()
    hs.focus() -- textPrompt needs keyboard focus on Hammerspoon
    local button, text = hs.dialog.textPrompt("Add Todo", "", "", "Add", "Cancel")
    if button == "Add" and text ~= "" then addItem(text) end
end

function M.start()
    if canvas then return M end

    local level = hs.canvas.windowLevels[M.config.level] or hs.canvas.windowLevels.floating
    local behavior = hs.canvas.windowBehaviors.canJoinAllSpaces
        + hs.canvas.windowBehaviors.stationary
        + hs.canvas.windowBehaviors.fullScreenAuxiliary

    canvas = hs.canvas.new({ x = 0, y = 0, w = M.config.width, h = 10 })
    canvas:level(level)
    canvas:behavior(behavior)
    canvas:clickActivating(false)
    -- view mode by default: no mouseCallback -> click-through

    controlCanvas = hs.canvas.new({ x = 0, y = 0, w = 10, h = 10 })
    controlCanvas:level(level + 1) -- keep the buttons above the panel
    controlCanvas:behavior(behavior)
    controlCanvas:clickActivating(false)
    controlCanvas:mouseCallback(onControlMouse)

    refreshDebounce = hs.timer.delayed.new(0.25, function() M.refresh(false) end)

    -- Watch the parent directory: atomic saves (Obsidian/Syncthing) replace
    -- the file node, which silently kills a watcher pointed at the file itself.
    local dir = M.config.filePath:match("^(.*)/[^/]+$")
    local fileName = M.config.filePath:match("([^/]+)$")
    pathWatcher = hs.pathwatcher.new(dir, function(paths)
        for _, p in ipairs(paths) do
            if p:match("([^/]+)$") == fileName then
                refreshDebounce:start()
                return
            end
        end
    end):start()

    screenWatcher = hs.screen.watcher.new(function() render() end):start()

    themeWatcher = hs.distributednotifications.new(
        function() render() end, "AppleInterfaceThemeChangedNotification"):start()

    local hk = M.config.hotkeys
    hotkeyObjs[#hotkeyObjs + 1] = hs.hotkey.bind(hk.toggle[1], hk.toggle[2], "Toggle Todo Overlay", M.toggleShow)
    hotkeyObjs[#hotkeyObjs + 1] = hs.hotkey.bind(hk.add[1], hk.add[2], "Add Todo", M.promptAdd)

    M.refresh(true)
    canvas:show()
    controlCanvas:show()
    log.i("started, watching " .. M.config.filePath)
    return M
end

function M.stop()
    if pathWatcher then pathWatcher:stop(); pathWatcher = nil end
    if screenWatcher then screenWatcher:stop(); screenWatcher = nil end
    if themeWatcher then themeWatcher:stop(); themeWatcher = nil end
    if refreshDebounce then refreshDebounce:stop(); refreshDebounce = nil end
    for _, k in ipairs(hotkeyObjs) do k:delete() end
    hotkeyObjs = {}
    if controlCanvas then controlCanvas:delete(); controlCanvas = nil end
    if canvas then canvas:delete(); canvas = nil end
end

return M
