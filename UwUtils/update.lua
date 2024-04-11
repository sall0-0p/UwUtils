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
        local symbolBlit = ""
        local colorBlit = ""
        local backgroundBlit = ""
        for column = 1, termWidth, 1 do
            if layer[row][column] ~= "NONE" then
                local cell = layer[row][column]

                symbolBlit = symbolBlit .. cell.symbol
                colorBlit = colorBlit .. colors.toBlit(cell.fg)
                backgroundBlit = backgroundBlit .. colors.toBlit(cell.bg)
            else
                symbolBlit = symbolBlit .. " "
                colorBlit = colorBlit .. "f"
                backgroundBlit = backgroundBlit .. "f"
            end
        end

        term.setCursorPos(1, row)
        term.blit(symbolBlit, colorBlit, backgroundBlit)
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
    if (not_trans(cell1) and not_trans(cell2)) then
        -- log(cell1.object.Name)
        -- log(cell2.object.Name)
        -- log(textutils.serialise(cell1))
        -- log(textutils.serialise(cell2))
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
        merged_result = merge(merged_result, layer[2])

        if merged_result == "SKIP" then
            return create_empty()
        end
    end

    return merged_result
end

-- tests

local Instance = Terminal:GetService("Instance")

local function updateScreen()
    while true do
        local ActiveObjects = Terminal.__updateQueue

        for key, order in ipairs(ActiveObjects) do
            local descendant = order[1]
            local reason = order[2] or "NO REASON"
            log(key.." Processing update of ".. descendant.Name .." for key ".. reason)
            if descendant:IsA("GuiObject") then
                local alreadyExists = false
                for key, layer in ipairs(ActiveLayers) do
                    if layer[1] == descendant then
                        layer[2] = descendant:__renderLayer()
                        alreadyExists = true
                    end
                end

                if not alreadyExists then
                    table.insert(ActiveLayers, {descendant, descendant:__renderLayer()})
                end
            end
        end

        if #Terminal.__updateQueue ~= 0 then
            local result = merge_all(ActiveLayers)
            draw(result)
        end
        Terminal.__updateQueue = {}
        os.sleep(0.05)
    end
end

updateScreen()