local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["11"] = 3,["12"] = 4,["13"] = 6,["14"] = 7,["15"] = 7,["16"] = 7,["17"] = 7,["18"] = 7,["19"] = 9,["20"] = 10,["21"] = 12,["22"] = 13,["23"] = 14,["24"] = 15,["26"] = 12,["27"] = 19,["28"] = 20,["29"] = 21,["31"] = 23,["32"] = 23,["33"] = 23,["34"] = 23,["35"] = 23,["36"] = 23,["37"] = 30,["38"] = 31,["39"] = 31,["40"] = 31,["41"] = 32,["42"] = 31,["43"] = 31,["44"] = 19,["45"] = 36,["46"] = 37,["47"] = 38,["48"] = 39,["50"] = 41,["51"] = 36,["52"] = 44,["53"] = 44,["54"] = 44,["55"] = 44,["56"] = 45,["57"] = 47,["58"] = 48,["59"] = 50,["60"] = 50,["61"] = 50,["62"] = 50,["63"] = 44,["64"] = 44,["65"] = 53,["66"] = 53,["67"] = 53,["68"] = 53,["69"] = 54,["70"] = 56,["71"] = 57,["72"] = 58,["75"] = 62,["76"] = 62,["77"] = 62,["78"] = 62,["79"] = 64,["80"] = 65,["83"] = 69,["84"] = 69,["85"] = 69,["86"] = 70,["87"] = 70,["88"] = 70,["89"] = 70,["90"] = 70,["91"] = 69,["92"] = 69,["93"] = 77,["94"] = 78,["95"] = 79,["96"] = 80,["97"] = 81,["98"] = 82,["101"] = 77,["102"] = 87,["103"] = 53,["104"] = 53,["105"] = 93,["106"] = 93,["107"] = 93,["108"] = 93,["109"] = 94,["110"] = 96,["111"] = 97,["112"] = 98,["115"] = 102,["116"] = 102,["117"] = 102,["118"] = 102,["119"] = 104,["120"] = 105,["123"] = 109,["124"] = 109,["125"] = 109,["126"] = 110,["127"] = 110,["128"] = 110,["129"] = 110,["130"] = 110,["131"] = 109,["132"] = 109,["133"] = 117,["134"] = 118,["135"] = 119,["136"] = 120,["137"] = 121,["138"] = 122,["141"] = 117,["142"] = 127,["143"] = 93,["144"] = 93,["145"] = 133,["146"] = 133,["147"] = 133,["148"] = 133,["149"] = 134,["150"] = 136,["151"] = 153,["152"] = 155,["153"] = 156,["156"] = 160,["157"] = 160,["158"] = 160,["159"] = 161,["160"] = 161,["161"] = 161,["162"] = 161,["163"] = 161,["164"] = 162,["165"] = 162,["166"] = 162,["167"] = 162,["168"] = 162,["169"] = 162,["170"] = 160,["171"] = 160,["172"] = 170,["173"] = 171,["174"] = 172,["175"] = 179,["177"] = 170,["178"] = 183,["179"] = 133,["180"] = 133,["181"] = 189,["182"] = 190,["183"] = 189});
local ____exports = {}
---
-- @noSelfInFile
____exports.moduleName = "prefix-C-s"
____exports.log = hs.logger.new(____exports.moduleName, "info")
local prefixModal = hs.hotkey.modal.new()
local prefixHotkey = hs.hotkey.bind(
    {"ctrl"},
    "s",
    function() return prefixModal:enter() end
)
local alertId
local timeoutTimer
local function clearTimer()
    if timeoutTimer then
        timeoutTimer:stop()
        timeoutTimer = nil
    end
end
prefixModal.entered = function()
    if alertId then
        hs.alert.closeSpecific(alertId)
    end
    alertId = hs.alert.show(
        "Prefix Mode (Ctrl+S)",
        {textSize = 20, radius = 10, fillColor = {white = 0, alpha = 0.7}, strokeColor = {white = 1, alpha = 0.5}},
        hs.screen.mainScreen(),
        999999
    )
    clearTimer()
    timeoutTimer = hs.timer.doAfter(
        2,
        function()
            prefixModal:exit()
        end
    )
end
prefixModal.exited = function()
    if alertId then
        hs.alert.closeSpecific(alertId)
        alertId = nil
    end
    clearTimer()
end
prefixModal:bind(
    {"ctrl"},
    "s",
    function()
        prefixModal:exit()
        prefixHotkey:disable()
        hs.eventtap.keyStroke({"ctrl"}, "s")
        hs.timer.doAfter(
            0.1,
            function() return prefixHotkey:enable() end
        )
    end
)
prefixModal:bind(
    {},
    "c",
    function()
        prefixModal:exit()
        local cursorApp = hs.application.get("Cursor")
        if not cursorApp then
            hs.alert.show("Cursor is not running")
            return
        end
        local windows = __TS__ArrayFilter(
            cursorApp:allWindows(),
            function(____, win) return win:isStandard() end
        )
        if #windows == 0 then
            hs.alert.show("No standard Cursor windows found")
            return
        end
        local choices = __TS__ArrayMap(
            windows,
            function(____, win)
                return {
                    text = win:title() or "Untitled Window",
                    subText = "Cursor",
                    window = win
                }
            end
        )
        local chooser = hs.chooser.new(function(choice)
            if choice and choice.window then
                local win = choice.window
                win:focus()
                if win:isMinimized() then
                    win:unminimize()
                end
            end
        end)
        chooser:choices(choices):placeholderText("Select a Cursor window..."):searchSubText(true):show()
    end
)
prefixModal:bind(
    {},
    "e",
    function()
        prefixModal:exit()
        local edgeApp = hs.application.get("Microsoft Edge")
        if not edgeApp then
            hs.alert.show("Microsoft Edge is not running")
            return
        end
        local windows = __TS__ArrayFilter(
            edgeApp:allWindows(),
            function(____, win) return win:isStandard() end
        )
        if #windows == 0 then
            hs.alert.show("No standard Edge windows found")
            return
        end
        local choices = __TS__ArrayMap(
            windows,
            function(____, win)
                return {
                    text = win:title() or "Untitled Window",
                    subText = "Microsoft Edge",
                    window = win
                }
            end
        )
        local chooser = hs.chooser.new(function(choice)
            if choice and choice.window then
                local win = choice.window
                win:focus()
                if win:isMinimized() then
                    win:unminimize()
                end
            end
        end)
        chooser:choices(choices):placeholderText("Select an Edge window..."):searchSubText(true):show()
    end
)
prefixModal:bind(
    {},
    "t",
    function()
        prefixModal:exit()
        local script = "\n    tell application \"Microsoft Edge\"\n        set res to {}\n        try\n            set winCount to count windows\n            repeat with wIdx from 1 to winCount\n                set tCount to count tabs of window wIdx\n                repeat with tIdx from 1 to tCount\n                    set tTitle to title of tab tIdx of window wIdx\n                    set end of res to tTitle & \"||\" & wIdx & \"||\" & tIdx\n                end repeat\n            end repeat\n        end try\n        return res\n    end tell\n  "
        local ok, result = hs.osascript.applescript(script)
        if not ok or not result then
            hs.alert.show("Failed to get Edge tabs")
            return
        end
        local choices = __TS__ArrayMap(
            result,
            function(____, line)
                local title, wIdx, tIdx = table.unpack(
                    __TS__StringSplit(line, "||"),
                    1,
                    3
                )
                return {
                    text = title,
                    subText = "Microsoft Edge Tab",
                    wIdx = __TS__ParseInt(wIdx),
                    tIdx = __TS__ParseInt(tIdx)
                }
            end
        )
        local chooser = hs.chooser.new(function(choice)
            if choice then
                local switchScript = ((("\n        tell application \"Microsoft Edge\"\n            set index of window " .. tostring(choice.wIdx)) .. " to 1\n            set active tab index of window 1 to ") .. tostring(choice.tIdx)) .. "\n            activate\n        end tell\n      "
                hs.osascript.applescript(switchScript)
            end
        end)
        chooser:choices(choices):placeholderText("Select an Edge tab..."):searchSubText(true):show()
    end
)
function ____exports.apply()
    ____exports.log.i(("Initializing [" .. ____exports.moduleName) .. "] module...")
end
return ____exports
