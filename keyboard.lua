local ____lualib = require("lualib_bundle")
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 3,["10"] = 4,["11"] = 6,["12"] = 7,["13"] = 8,["14"] = 8,["15"] = 8,["16"] = 8,["17"] = 9,["18"] = 10,["20"] = 6,["21"] = 14,["22"] = 15,["23"] = 16,["24"] = 14,["25"] = 19,["26"] = 20,["27"] = 21,["28"] = 19,["29"] = 24,["30"] = 25,["31"] = 24});
local ____exports = {}
---
-- @noSelfInFile
____exports.moduleName = "keyboard"
____exports.log = hs.logger.new(____exports.moduleName, "info")
function ____exports.useSquirrel()
    local methods = hs.keycodes.methods()
    local squirrel = __TS__ArrayFind(
        methods,
        function(____, method) return __TS__StringIncludes(method, "Squirrel") end
    )
    if squirrel then
        hs.keycodes.setMethod(squirrel)
    end
end
function ____exports.bindSquirrelHotkey()
    ____exports.log.i("Binding squirrel hotkey...")
    hs.hotkey.bind({"cmd"}, "escape", ____exports.useSquirrel)
end
local function init()
    ____exports.log.i(("Initializing [" .. ____exports.moduleName) .. "] module...")
    ____exports.bindSquirrelHotkey()
end
function ____exports.apply()
    init()
end
return ____exports
