--[[
    Terminal is root element of all UIs present in our system.
]]

local Terminal = {
    Name = "Terminal",
    ClassName = "Terminal",

    -- private
    __children = {},
    __readOnly = {
        "Name",
        "ClassName",
    },
    __inherit = {
        "Terminal",
    },
    __services = {
        Instance = require(".UwUtils.Classes.Instance")
    },
}

function Terminal:GetService(serviceName)
    assert(self.__services[serviceName], "Service '" .. serviceName .. "' does not exist!")
    return self.__services[serviceName]
end

setmetatable(Terminal, {
    __index = function(obj, key) 
        return obj.__children[key]
    end,
    __newindex = function(obj, key, value)
        if obj.__readOnly then
            for _, attribute in ipairs(obj.__readOnly) do
                if key == attribute then
                    error("Cannot change read-only value '" .. key .. "'")
                end
            end
        end

        rawset(obj, key, value)
    end,
    __tostring = function(obj) 
        return obj.Name
    end
})

return Terminal