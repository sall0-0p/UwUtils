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
            offsetX = offsetX + self.Parent.AbsolutePosition[1]
            offsetY = offsetY + self.Parent.AbsolutePosition[2]
        end
    end

    self.AbsolutePosition = {offsetX, offsetY}

    local check = false
    for row = 1, termHeight, 1 do
        render_result[row] = {}
        for column = 1, termWidth, 1 do
            if self.Visible then
                if ((column >= offsetX) and (column < offsetX + width)) and ((row >= offsetY) and (row < offsetY + height)) then
                    render_result[row][column] = {
                        symbol = "\0",
                        bg = background_color,
                        fg = background_color,
                        zindex = self.ZIndex,
                        object = self.__proxy,
                    }

                    if self.__debugCheckboard then
                        -- TODO: Remove this!
                        if check then 
                            render_result[row][column].bg = background_color
                            render_result[row][column].fg = background_color
                        else
                            render_result[row][column].bg = colors.white
                            render_result[row][column].fg = colors.white
                        end
                    end

                    check = not check
                else
                    render_result[row][column] = "NONE"
                end
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