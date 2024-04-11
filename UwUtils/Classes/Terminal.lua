--[[
    Terminal is root element of all UIs present in our system.
]]
local log = require(".UwUtils.Utility.Log")

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
        -- after initialising, changes to respective tables.
        Instance = ".UwUtils.Classes.Instance"
    },

    __onChangeFunctions = {
        ["__updateQueue"] = function(obj, value) 
            -- log(textutils.serialise(value, {allow_repetitions = true}))
        end
    },

    __updateQueue = {

    }
}

function Terminal:GetService(serviceName)
    assert(self.__services[serviceName], "Service '" .. serviceName .. "' does not exist!")
    return self.__services[serviceName]
end

function Terminal:Init()
    for key, service in pairs(self.__services) do
        self.__services[key] = require(service)
    end
end

return Terminal