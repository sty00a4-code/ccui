local expect = require "ccui.expect"
local Element = require "ccui.element"

---@class ccui.Config.Box : ccui.Config
---@field children ccui.Element[]?

---@class ccui.Box : ccui.Element
---@field config ccui.Config.Box

---@param self ccui.Box
---@param parent ccui.Element
local function draw(self, parent)
    local current = term.current()
    if self.window then term.redirect(self.window) end
    term.setBackgroundColor(self.bg)
    term.setTextColor(self.fg)
    term.clear()
    if self.config.children then
        for _, e in ipairs(self.config.children) do
            e:draw(self)
        end
    end
    term.redirect(current)
end
---@param self ccui.Box
---@param parent ccui.Element
local function update(self, parent)
    if self.config.children then
        local current = term.current()
        if self.window then term.redirect(self.window) end
        for _, e in ipairs(self.config.children) do
            e:update(self)
        end
        term.redirect(current)
    end
end
---@param self ccui.Box
---@param parent ccui.Element
---@param kind cc.EventType
local function event(self, parent, kind, ...)
    if self.config.children then
        local current = term.current()
        if self.window then term.redirect(self.window) end
        for _, e in ipairs(self.config.children) do
            e:event(self, kind, ...)
        end
        term.redirect(current)
    end
end

---@param config ccui.Config.Box
---@return ccui.Element
return function (config)
    expect.typeOpt(config.children, "field 'children'", "table")
    local element = Element.new(config)
    element:applyConfig()
    element.draw = draw
    element.update = update
    element.event = event
    return element
end