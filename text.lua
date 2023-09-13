local expect = require "ccui.expect"
local Element = require "ccui.element"

---@class ccui.Config.Text : ccui.Config
---@field text string
---@field update function?
---@field __lines string[]?

---@class ccui.Text : ccui.Element
---@field config ccui.Config.Text

---@param self ccui.Text
---@param parent ccui.Element?
local function draw(self, parent)
    term.setTextColor(self.fg)
    term.setBackgroundColor(self.bg)
    for i, line in ipairs(self.config.__lines) do
        term.setCursorPos(self.x, self.y + i - 1)
        term.write(line)
    end
end
---@param self ccui.Text
---@param parent ccui.Element?
local function update(self, parent)
    if self.config.update then
        local old = self.config.text
        self.config.text = self.config.update(self)
        if old ~= self.config.text then
            self.config.__lines = {} do
                local temp = ""
                local line, column = 1, 1
                for i = 1, #self.config.text do
                    if line > self.h then
                        break
                    end
                    if self.config.text:sub(i, i) == "\n" or column > self.w then
                        if temp then
                            self.config.__lines[line] = temp
                            column = 1
                            line = line + 1
                            temp = ""
                        end
                    else
                        column = column + 1
                        temp = temp .. self.config.text:sub(i, i)
                    end
                end
                if temp and not (line > self.h) then
                    self.config.__lines[line] = temp
                end
            end
        end
    end
end
---@param self ccui.Text
---@param parent ccui.Element?
---@param kind cc.EventType
local function event(self, parent, kind, ...)
    
end

---@param config ccui.Config.Text
return function (config)
    expect.type(config.update, "field 'update'", "function")
    expect.type(config.text, "field 'text'", "string")
    config.__lines = {} do
        local temp = ""
        for i = 1, #config.text do
            if config.text:sub(i, i) == "\n" then
                if temp then
                    table.insert(config.__lines, temp)
                    temp = ""
                end
            else
                temp = temp .. config.text:sub(i, i)
            end
        end
        if temp then
            table.insert(config.__lines, temp)
        end
    end
    local element = Element.new(config)
    for _, line in ipairs(config.__lines) do
        if #line > element.w then
            element.w = #line
        end
    end
    element.h = #config.__lines

    element:applyConfig()

    local newLines = {} do
        for _ = 1, element.h do
            local line = table.remove(config.__lines, 1)
            if #line > element.w then
                table.insert(newLines, line:sub(1, element.w))
                table.insert(config.__lines, 1, line:sub(element.w+1))
            else
                table.insert(config.__lines, line)
            end
        end
    end

    element.draw = draw
    element.update = update
    element.event = event
    return element
end