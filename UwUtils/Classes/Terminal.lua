--[[
    Terminal is root element of all UIs present in our system.
]]

local Terminal = {
    Name = "Terminal",
    ClassName = "Terminal",

    -- private
    __public = true,
    __children = {},
    __readOnly = {
        "Name",
        "ClassName",
    },
    __inherit = {
        "Terminal",
        "Instance",
    },
    __services = {
        Instance = require(".UwUtils.Classes.Instance")
    },
}

function Terminal:GetService(serviceName)
    assert(self.__services[serviceName], "Service '" .. serviceName .. "' does not exist!")
    return self.__services[serviceName]
end

return Terminal