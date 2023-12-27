local function addSpacing(n)
    local result = ""
    for i=1, n, 1 do
        result = result .. " "
    end

    return result
end

local log = require(".UwUtils.Utility.Log")

local function show_tree(object, isChild)
    if not isChild then
        log("\n ------------")
        log("\n [TREE TITLE] Tree of " .. object.Name .. " | " .. object.ClassName)
    end

    for _, child in ipairs(object.__children) do
        log("\n [TREE ITEM] " .. child.Name .. " | " .. child.ClassName .. " | " .. child.Parent.Name)
        show_tree(child, true)
    end
end

return show_tree