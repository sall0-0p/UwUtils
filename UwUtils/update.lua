local TerminalGrid = {}
local ActiveLayers = {}
local log = require(".UwUtils.Utility.Log")
local tree = require(".UwUtils.Utility.Tree")

local termWidth, termHeight = term.getSize()

local function not_trans(value)
    return type(value) == "table"
end

local function draw(layer)
    local termWidth, termHeight = term.getSize()

    for row = 1, termHeight, 1 do
        for column = 1, termWidth, 1 do
            if layer[row][column] ~= "NONE" then
                local cell = layer[row][column]
                term.setCursorPos(column, row)
                term.setTextColor(cell.fg)
                term.setBackgroundColor(cell.bg)

                term.write(cell.symbol)
            end
        end
    end
end

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

local function merge_cell(cell1, cell2)
    -- log("\n " .. textutils.serialise(cell1) .. " | " .. textutils.serialise(cell2))
    -- log("\n" .. tostring(not_trans(cell1)) .. " | " .. tostring(not_trans(cell2)))
    if not_trans(cell1) and not_trans(cell2) then
        if cell1.zindex > cell2.zindex then
            return cell1
        else
            return cell2
        end
    elseif not_trans(cell1) and (not not_trans(cell2)) then
        return cell1
    elseif (not not_trans(cell1)) and not_trans(cell2) then
        return cell2
    else
        return "NONE"
    end
end

local function merge(layer1, layer2)
    local termWidth, termHeight = term.getSize()
    local merge_result = {}

    for row = 1, termHeight, 1 do
        merge_result[row] = {}
        for column = 1, termWidth, 1 do
            -- log(textutils.serialise(layer1[row], {allow_repetitions = true}))
            -- log(textutils.serialise(layer2[row], {allow_repetitions = true}))
            local cell1 = layer1[row][column]
            local cell2 = layer2[row][column]

            merge_result[row][column] = merge_cell(cell1, cell2)
        end
    end

    return merge_result
end

local function merge_all(layers)
    local merged_result = create_empty()
    
    for _, layer in ipairs(layers) do
        merged_result = merge(merged_result, layer)
    end

    return merged_result
end

-- tests

local Instance = Terminal:GetService("Instance")

local Frame = Instance.new("Frame", Terminal)

Frame.Size = {15, 10}
Frame.Position = {5, 3}
Frame.BackgroundColor = colors.blue

local HighFrame = Instance.new("Frame", Terminal)

HighFrame.Size = {15, 10}
HighFrame.Position = {7, 5}
HighFrame.BackgroundColor = colors.red

local LowestFrame = Instance.new("Frame", Terminal)

LowestFrame.Size = {41, 10}
LowestFrame.Position = {2, 2}
LowestFrame.BackgroundColor = colors.green
LowestFrame.ZIndex = 0

local ChildFrame = Instance.new("Frame", HighFrame)

ChildFrame.Size = {3, 2}
ChildFrame.BackgroundColor = colors.yellow

table.insert(ActiveLayers, Frame:__renderLayer())
table.insert(ActiveLayers, HighFrame:__renderLayer())
table.insert(ActiveLayers, ChildFrame:__renderLayer())
table.insert(ActiveLayers, LowestFrame:__renderLayer())

local result = merge_all(ActiveLayers)
draw(result)
-- log(textutils.serialise(result, {allow_repetitions = true}))