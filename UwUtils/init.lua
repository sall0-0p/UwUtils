-- Assigning custom functions

function table.deepcopy(tbl)
    local result = {}

    for index, value in pairs(tbl) do
        if type(value) == "table" then
            table.deepcopy(value)
        else
            result[index] = value
        end

        setmetatable(result, getmetatable(tbl))
        return result
    end
end