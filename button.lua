local expect = require "ccui.expect"
local Element = require "ccui.element"

---@class ccui.Config.Button : ccui.Config
---@field label string?
---@field brackets string?
---@field onClick function?

---@class ccui.Button : ccui.Element
---@field config ccui.Config.Button

---@param self ccui.Button
---@param parent ccui.Element?
local function draw(self, parent)
    term.setTextColor(self.fg)
    term.setBackgroundColor(self.bg)
    term.setCursorPos(self.x, self.y)
    term.write(self.config.brackets:sub(1, 1))
    term.write(self.config.label)
    term.write(self.config.brackets:sub(2, 2))
end
---@param self ccui.Button
---@param parent ccui.Element?
local function update(self, parent)
    
end
---@param self ccui.Button
---@param parent ccui.Element?
---@param kind cc.EventType
local function event(self, parent, kind, ...)
    if kind == "mouse_click" then
        local mb, mx, my = ...
        if mb == 1 then
            if self:mouseOver(parent, mx, my) then
                if self.config.onClick then
                    self.config.onClick(self, parent)
                end
            end
        end
    end
end

---@param config ccui.Config.Button
return function (config)
    expect.typeOpt(config.onClick, "field 'onClick'", "function")
    config.label = expect.typeOrDefault(config.label, "button", "field 'label'", "string")
    config.brackets = expect.typeOrDefault(config.brackets, "[]", "field 'brackets'", "string")
    local element = Element.new(config)

    element.w = 2 + #(config.label or "button")

    element:applyConfig()
    element.draw = draw
    element.update = update
    element.event = event
    return element
end