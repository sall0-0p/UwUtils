local TerminalGrid = {}
local log = require(".UwUtils.Utility.Log")
local tree = require(".UwUtils.Utility.Tree")

local function clear() 
    term.clear()
    local term_width, term_height = term.getSize()

    TerminalGrid = {}

    for y = 1, term_height, 1 do
        TerminalGrid[y] = {}
        for x = 1, term_width, 1 do
            -- log("\n" .. x .. " " .. y)
            TerminalGrid[y][x] = {
                symbol = "\0",
                background = colors.black,
                foreground = colors.black,
            }
        end
    end
end

local function blit(row) 
    local text = ""
    local foreground = ""
    local background = ""
    for _, cell in ipairs(row) do
        text = text .. cell.symbol
        foreground = foreground .. colors.toBlit(cell.foreground)
        background = background .. colors.toBlit(cell.background)
    end

    term.blit(text, foreground, background)
end

local function draw()
    local term_width, term_height = term.getSize()

    for column, row_content in ipairs(TerminalGrid) do
        term.setCursorPos(1, column)
        blit(row_content)
    end
end

local function render()
    local render_result = {}
    local raw_descendants = Terminal:GetDescendants()
    local descendants = {}
    
    for _, descendant in ipairs(raw_descendants) do
        if descendant:IsA("GuiObject") then
            table.insert(descendants, descendant)
        end
    end
end

local function Update() 

end

local Instance = Terminal:GetService("Instance")
local Frame = Instance.new("Frame", Terminal)
Frame.Size = {term.getSize()}
Frame.Position = {1, 1}
Frame.BackgroundColor = colors.black

render()
clear()
draw()

Frame.Changed:Connect(function() 
    TerminalGrid = Frame:__render()
    draw()
end)

while true do
    Frame.BackgroundColor = colors.gray
    sleep(.1)
    Frame.BackgroundColor = colors.lightGray
    sleep(.1)
end