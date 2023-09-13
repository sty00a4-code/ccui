local expect = require "ccui.expect"

---@alias cc.EventType "alarm"|"char"|"computer_command"|"disk"|"disk_eject"|"file_transfer"|"http_check"|"http_failure"|"http_success"|"key"|"key_up"|"modem_message"|"monitor_resize"|"monitor_touch"|"mouse_click"|"mouse_drag"|"mouse_scroll"|"mouse_up"|"paste"|"peripheral"|"peripheral_detach"|"rednet_message"|"redstone"|"speaker_audio_empty"|"task_complete"|"term_resize"|"terminate"|"timer"|"turtle_inventory"|"websocket_closed"|"websocket_failure"|"websocket_message"|"websocket_success"
---@alias cc.Color "white"|"black"|"gray"|"lightGray"|"red"|"green"|"blue"|"orange"|"cyan"|"lime"|"lightBlue"|"pink"|"magenta"|"purple"|"yellow"|"brown"

---@class ccui.Config
---@field position "absolute"|"relative"?
---@field anchor "top-left"|"top"|"top-right"|"left"|"center"|"right"|"bottom-left"|"bottom"|"bottom-right"?
---@field scale "absolute"|"relative"?
---@field relx number?
---@field rely number?
---@field relw number?
---@field relh number?
---@field absx integer?
---@field absy integer?
---@field absw integer?
---@field absh integer?
---@field color cc.Color|integer?
---@field backgroundColor cc.Color|integer?

local Element = {
    mt = {
        __name = "ccui.element"
    }
}
---@param config ccui.Config
---@return ccui.Element
function Element.new(config)
    ---@class ccui.Element
    ---@field x integer
    ---@field y integer
    ---@field w integer
    ---@field h integer
    ---@field fg integer
    ---@field bg integer
    ---@field window table?
    ---@field draw function
    ---@field update function
    ---@field event function
    ---@field mouseOver function
    ---@field applyConfig function
    ---@field config ccui.Config
    return setmetatable({
        x = 1,
        y = 1,
        w = 1,
        h = 1,
        fg = colors.white,
        bg = colors.black,
        draw = function () end,
        update = function () end,
        event = function () end,
        ---@param self ccui.Element
        ---@param parent ccui.Element
        ---@param mx integer
        ---@param my integer
        mouseOver = function (self, parent, mx, my)
            mx = mx - (parent.x - 1)
            my = my - (parent.y - 1)
            return (
                (mx >= self.x) and
                (my >= self.y)
            ) and (
                (mx <= self.x + self.w - 1) and
                (my <= self.y + self.h - 1)
            )
        end,
        ---@param self ccui.Element
        applyConfig = function (self)
            self.config.position = self.config.position or "absolute"
            self.config.anchor = self.config.anchor or "top-left"
            self.config.scale = self.config.scale or "absolute"
            if self.config.position == "absolute" then
                self.x = self.config.absx or self.x
                self.y = self.config.absy or self.y
            elseif self.config.position == "relative" then
                local W, H = term.getSize()
                self.x = self.config.relx and math.floor(self.config.relx * W) + 1 or self.x
                self.y = self.config.rely and math.floor(self.config.rely * H) + 1 or self.y
            end
            if self.config.scale == "absolute" then
                self.w = self.config.absw or self.w
                self.h = self.config.absh or self.h
            elseif self.config.scale == "relative" then
                local W, H = term.getSize()
                self.w = self.config.relw and math.floor(self.config.relw * W) or self.w
                self.h = self.config.relh and math.floor(self.config.relh * H) or self.h
            end
            if self.config.anchor == "top" or self.config.anchor == "center" or self.config.anchor == "bottom" then
                self.x = self.x - math.floor(self.w / 2)
            end
            if self.config.anchor == "left" or self.config.anchor == "center" or self.config.anchor == "right" then
                self.y = self.y - math.floor(self.h / 2)
            end
            if self.config.anchor == "top-right" or self.config.anchor == "right" or self.config.anchor == "bottom-right" then
                self.x = self.x - self.w + 1
            end
            if self.config.anchor == "bottom-left" or self.config.anchor == "bottom" or self.config.anchor == "bottom-right" then
                self.y = self.y - self.h + 1
            end
            if self.config.color then
                if type(self.config.color) == "string" then
                    self.fg = colors[self.config.color] or self.fg
                elseif type(self.config.color) == "number" then
                    ---@diagnostic disable-next-line: assign-type-mismatch
                    self.fg = self.config.color
                end
            end
            if self.config.backgroundColor then
                if type(self.config.backgroundColor) == "string" then
                    self.bg = colors[self.config.backgroundColor] or self.fg
                elseif type(self.config.backgroundColor) == "number" then
                    ---@diagnostic disable-next-line: assign-type-mismatch
                    self.bg = self.config.backgroundColor
                end
            end
        end,
        config = config,
    }, Element.mt)
end
return Element