-- Signals
--[[
    Attributes: 
    None

    Methods:
    - Connect
    - Once
    - Wait
]]

local Signal = {
    __bindedFunctions = {},
}
Signal.__index = Signal
Signal.__tostring = function() 
    return "Signal"
end

function Signal.new()
    local signal = {}
    setmetatable(signal, Signal)

    return signal
end

function Signal:Connect(func)
    table.insert(self.__bindedFunctions, func)
end

function Signal:Fire(...)
    for _, func in ipairs(self.__bindedFunctions) do
        func(...)
    end
end

return Signal