local mod = {}
---@param value any
---@param label string
---@param ... string
function mod.type(value, label, ...)
    local types = {...}
    for _, t in ipairs(types) do
        if type(value) == t then
            return
        end
    end
    error(("bad argument %s (expected %s, got %s)"):format(tostring(label), table.concat(types, "|"), type(value)), 3)
end
---@param value any
---@param label string
---@param ... string
function mod.typeOpt(value, label, ...)
    if type(value) == "nil" then return end
    local types = {...}
    for _, t in ipairs(types) do
        if type(value) == t then
            return
        end
    end
    error(("bad argument %s (expected %s?, got %s)"):format(tostring(label), table.concat(types, "|"), type(value)), 3)
end
---@generic T
---@param value any
---@param default T
---@param label string
---@param ... string
---@return T
function mod.typeOrDefault(value, default, label, ...)
    if type(value) == "nil" then return default end
    local types = {...}
    for _, t in ipairs(types) do
        if type(value) == t then
            return value
        end
    end
    error(("bad argument %s (expected %s, got %s)"):format(tostring(label), table.concat(types, "|"), type(value)), 3)
end
---@param value string
---@param label string
---@param ... string
function mod.string(value, label, ...)
    local strings = {...}
    if type(value) ~= "string" then
        for i, string in ipairs(strings) do
            strings[i] = ("%q"):format(string)
        end
        error(("bad argument %s (expected %s, got %s)"):format(tostring(label), table.concat(strings, "|"), type(value)), 3)
    end
    for _, s in ipairs(strings) do
        if value == s then
            return
        end
    end
    for i, string in ipairs(strings) do
        strings[i] = ("%q"):format(string)
    end
    error(("bad argument %s (expected %s, got %s)"):format(tostring(label), table.concat(strings, "|"), value), 3)
end
---@param value string
---@param default string
---@param label string
---@param ... string
---@return string
function mod.stringOrDefault(value, default, label, ...)
    if type(value) == "nil" then return default end
    local strings = {...}
    for _, s in ipairs(strings) do
        if value == s then
            return value
        end
    end
    for i, string in ipairs(strings) do
        strings[i] = ("%q"):format(string)
    end
    error(("bad argument %s (expected %s, got %s)"):format(tostring(label), table.concat(strings, "|"), value), 3)
end
---@param value number
---@param label string
---@param min number
---@param max number
function mod.range(value, label, min, max)
    if value >= min and value <= max then
        return
    end
    error(("bad argument %s (expected range of %s-%s, got %s)"):format(label, min, max, value), 3)
end
---@param value number
---@param label string
---@param min number
function mod.min(value, label, min)
    if value >= min then
        return
    end
    error(("bad argument %s (expected minimum of %s, got %s)"):format(label, min, value), 3)
end
---@param value number
---@param label string
---@param max number
function mod.max(value, label, max)
    if value >= max then
        return
    end
    error(("bad argument %s (expected maximum of %s, got %s)"):format(label, max, value), 3)
end

return mod