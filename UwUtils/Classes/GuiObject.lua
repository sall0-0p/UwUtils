-- BaseFrame
--[[
    Attirubutes:
    - Anchor Point
    - Automatic Size
    - Background Color
    - Border Color
    - Border Size
    - Border Mode (inline, outline)
    - Draggable
    - Position
    - Size
    - Visible
    - ZIndex

    - Absolute Position : read-only
    - Absolute Size : read-only

    Methods: 
    None

    Events:
    None

]]

local GuiObject = {
    -- attributes
    AnchorPoint = nil,
    AutomaticSize = true,
    BackgroundColor = colors.white,

    Bordered = false,
    BorderColor = colors.black,
    BorderMode = "inline",

    Draggable = false,
    Position = nil,
    Size = nil,
    Visible = true,
    ZIndex = 1,
    
    AbsolutePosition = nil,
    AbsoluteSize = nil,

    -- private
    __public = true,
    __children = {},
    __inherit = {
        "GuiObject",
        "Instance",
    },
}

return GuiObject