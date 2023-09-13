local mod = {}
mod.Element = require "ccui.element"
mod.button = require "ccui.button"
mod.box = require "ccui.box"
mod.text = require "ccui.text"

---@param children ccui.Element[]?
---@return ccui.Element
function mod.page(children)
    local W, H = term.getSize()
    return mod.box {
        position = "absolute",
        absx = 1,
        absy = 1,
        absw = W,
        absh = H,
        children = children,
    }
end
---@param element ccui.Element
---@param checkExit function?
function mod.run(element, checkExit)
    while true do
        element:update()
        element:draw()
        if checkExit then
            if checkExit() then
                break
            end
        end
        element:event(nil, os.pullEvent())
    end
end

return mod