local function addSpacing(n)
    local result = ""
    for i=1, n, 1 do
        result = result .. " "
    end

    return result
end

local function show_tree(object)
    print()
    print("/ Tree of " .. object.Name .. " | " .. object.ClassName)
    for _, child in ipairs(object.__children) do
        print(child.Name .. " | " .. child.ClassName .. " | " .. child.Parent.Name)
        -- show_tree(child)
    end
end

return show_tree