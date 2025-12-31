local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["11"] = 3,["12"] = 4,["13"] = 6,["14"] = 8,["15"] = 9,["16"] = 11,["17"] = 12,["18"] = 13,["19"] = 14,["21"] = 11,["22"] = 18,["23"] = 19,["24"] = 20,["26"] = 22,["27"] = 22,["28"] = 22,["29"] = 22,["30"] = 22,["31"] = 22,["32"] = 29,["33"] = 30,["34"] = 30,["35"] = 30,["36"] = 31,["37"] = 30,["38"] = 30,["39"] = 18,["40"] = 35,["41"] = 36,["42"] = 37,["43"] = 38,["45"] = 40,["46"] = 35,["47"] = 43,["48"] = 43,["49"] = 43,["50"] = 43,["51"] = 44,["52"] = 45,["53"] = 43,["54"] = 43,["55"] = 48,["56"] = 48,["57"] = 48,["58"] = 48,["59"] = 49,["60"] = 51,["61"] = 52,["62"] = 53,["65"] = 57,["66"] = 57,["67"] = 57,["68"] = 57,["69"] = 59,["70"] = 60,["73"] = 64,["74"] = 64,["75"] = 64,["76"] = 65,["77"] = 65,["78"] = 65,["79"] = 65,["80"] = 65,["81"] = 64,["82"] = 64,["83"] = 72,["84"] = 73,["85"] = 74,["86"] = 75,["87"] = 76,["88"] = 77,["91"] = 72,["92"] = 82,["93"] = 48,["94"] = 48,["95"] = 88,["96"] = 88,["97"] = 88,["98"] = 88,["99"] = 89,["100"] = 91,["101"] = 92,["102"] = 93,["105"] = 97,["106"] = 97,["107"] = 97,["108"] = 97,["109"] = 99,["110"] = 100,["113"] = 104,["114"] = 104,["115"] = 104,["116"] = 105,["117"] = 105,["118"] = 105,["119"] = 105,["120"] = 105,["121"] = 104,["122"] = 104,["123"] = 112,["124"] = 113,["125"] = 114,["126"] = 115,["127"] = 116,["128"] = 117,["131"] = 112,["132"] = 122,["133"] = 88,["134"] = 88,["135"] = 128,["136"] = 128,["137"] = 128,["138"] = 128,["139"] = 129,["140"] = 131,["141"] = 148,["142"] = 150,["143"] = 151,["146"] = 155,["147"] = 155,["148"] = 155,["149"] = 156,["150"] = 156,["151"] = 156,["152"] = 156,["153"] = 156,["154"] = 157,["155"] = 157,["156"] = 157,["157"] = 157,["158"] = 157,["159"] = 157,["160"] = 155,["161"] = 155,["162"] = 165,["163"] = 166,["164"] = 167,["165"] = 174,["167"] = 165,["168"] = 178,["169"] = 128,["170"] = 128,["171"] = 184,["172"] = 185,["173"] = 184});
local ____exports = {}
---
-- @noSelfInFile
____exports.moduleName = "prefix-C-s"
____exports.log = hs.logger.new(____exports.moduleName, "info")
local prefixModal = hs.hotkey.modal.new({"ctrl"}, "s")
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
        hs.eventtap.keyStroke({"ctrl"}, "s")
        prefixModal:exit()
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
