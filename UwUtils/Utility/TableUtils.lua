local TableUtils = {}

local log = require(".UwUtils.Utility.Log")

function TableUtils.deepcopy(tbl)
    log("\n [DEEPCOPY] Started")
    local result = {}

    for index, value in pairs(tbl) do
        if type(value) == "table" then
            log("\n [DEEPCOPY] Started Recursion for " .. index)
            TableUtils.deepcopy(value)
        else
            log("\n [DEEPCOPY] Copied " .. index)
            result[index] = value
        end
    end

    setmetatable(result, getmetatable(tbl))
    return result
end

return TableUtils