--[[
    Frames are most basic element that you can see on screen.
]]

local Signal = require(".UWUtils.Utility.Signal")
local log = require(".UWUtils.Utility.Log")
local Frame = {
    Changed = Signal.new(),

    -- private
    __public = true,
    __children = {},
    __inherit = {
        "Frame",
        "GuiObject",
        "Instance",
    },
}

-- generates empty frame
local function create_empty() 
    local termWidth, termHeight = term.getSize()
    local blank_layer = {}
    
    for row = 1, termHeight, 1 do
        blank_layer[row] = {}
        for column = 1, termWidth, 1 do
            blank_layer[row][column] = "NONE"
        end
    end

    return blank_layer
end

-- renderer
function Frame:__renderLayer() 
    local render_result = {}

    local anchorX = self.AnchorPoint[1]
    local anchorY = self.AnchorPoint[2]
    local positionX = self.Position[1]
    local positionY = self.Position[2]
    local width = self.Size[1]
    local height = self.Size[2]
    local background_color = self.BackgroundColor

    local termWidth, termHeight = term.getSize()

    local offsetX = positionX - math.round(anchorX * width)
    local offsetY = positionY - math.round(anchorY * height)

    if self.Parent then
        if self.Parent:IsA("GuiObject") then
            offsetX = offsetX + self.Parent.AbsolutePosition[1] - 1
            offsetY = offsetY + self.Parent.AbsolutePosition[2] - 1
        end
    end

    self.AbsolutePosition = {offsetX, offsetY}

    if not self.Visible then
        return create_empty()
    end

    for row = 1, termHeight, 1 do
        render_result[row] = {}
        for column = 1, termWidth, 1 do
            if ((column >= offsetX) and (column < offsetX + width)) and ((row >= offsetY) and (row < offsetY + height)) then
                render_result[row][column] = {
                    symbol = "\0",
                    bg = background_color,
                    fg = background_color,
                    zindex = self.ZIndex,
                    object = self.__proxy,
                }
            else
                render_result[row][column] = "NONE"
            end
        end
    end

    return render_result
end

function Frame:__renderBorder()

end

return Frame