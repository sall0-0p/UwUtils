-- Instances
--[[
    Attributes:
    - Name
    - ClassName
    - Parent

    Methods:
    - ClearAllChildren() : void
    - Clone() : Instance
    - Destroy() : void

    -- FindFirstAncestor(name) : Instance
    -- FindFirstDescendant(name) : Instance
    -- FindFirstDescendantOfClass(className) : Instance
    -- FindFirstAncestorOfClass(className) : Instance
    -- FindFirstChild(name) : Instance
    -- FindFirstChildOfClass(className) : Instance
    -- GetChildren() : table
    -- GetDescendants() : table
    - GetFullName() : string
    -- IsA() : boolean ()

    - GetPropertyChangedSignal(property)
    - WaitForChild(maybe): Instance

    Events: 
    - Changed(property)

    - ChildAdded()
    - ChildRemoved()
    - DescendantAdded()
    - DescendantRemoved()
    - Destroying()
]]

local Signal = require(".UWUtils.Utility.Signal")
local TableUtils = require(".UwUtils.Utility.TableUtils")
local log = require(".UwUtils.Utility.Log")

local Instance = {
    -- attributes
    Name = "",
    ClassName = "Instance",
    Parent = nil,

    -- events
    ChildAdded = Signal.new(),
    ChildRemoved = Signal.new(),
    DescendantAdded = Signal.new(),
    DescendantRemoved = Signal.new(),
    Destroying = Signal.new(),
    Changed = Signal.new(),
    
    -- private
    __public = true,
    __children = {},
    __readOnly = {
        "ClassName",
        "__public",
        "__readOnly",
        "__onChangeFunctions",
        "__inherit",
    },
    __onChangeFunctions = {},

    __inherit = {
        "Instance",
    },
}

-- special function Instance.new():
function Instance.new(className, parent)
    local object = {
        Name = className,
        ClassName = className,
        Parent = parent,

        __children = {},
        __proxy = {},
    }
    local mainClass = require(".UwUtils.Classes." .. className)
    assert(mainClass.__public, "Cannot create Instance of class '" .. className .. "' (private)")

    local proxy = {}

    setmetatable(object, {
        __tostring = function(obj) 
            return obj.Name
        end
    })

    setmetatable(proxy, {
        __index = function(obj, key)
            if rawget(object, key) ~= nil then
                return rawget(object, key)
            end

            for _, subclass_name in ipairs(mainClass.__inherit) do
                local subclass = require(".UwUtils.Classes." .. subclass_name)
                if subclass[key] then
                    return subclass[key]
                end
            end

            local child = obj:FindFirstChild(key)
            if child ~= nil then
                return child
            end

            error(key .. " is not a member of " .. rawget(object, "ClassName") .. " " .. rawget(object, "Name"))
        end,

        __newindex = function(obj, key, value)
            if key == "Parent" then
                if obj.Parent then
                    for index, child in ipairs(obj.Parent.__children) do
                        if child == obj then
                            obj.Parent.__children[index] = nil
                        end
                    end
                end
                
                rawset(object, "Parent", value)
                obj.Changed:Fire()
                value.Changed:Fire()

                if value then
                    if value.__children then
                        table.insert(value.__children, proxy)
                    end
                end
                
                table.insert(Terminal.__updateQueue, {proxy, key})
                table.insert(Terminal.__updateQueue, {value, key})
            elseif key == "AbsolutePosition" or key == "AbsoluteSize" then
                rawset(object, key, value)
            else
                if obj.__readOnly then
                    for _, attribute in ipairs(obj.__readOnly) do
                        if key == attribute then
                            error("Cannot change read-only value '" .. key .. "'")
                        end
                    end
                end

                rawset(object, key, value)

                if obj.__onChangeFunctions then
                    if obj.__onChangeFunctions[key] then
                        obj.__onChangeFunctions[key](proxy, value)
                    end
                end

                obj.Changed:Fire()
                table.insert(Terminal.__updateQueue, {proxy, key})

                if key == "Size" or key == "Position" then
                    log("\n [M] Looping thru descendants!")
                    for _, descendant in ipairs(obj:GetChildren()) do
                        log("\n" .. descendant.Name .. " | " .. descendant.ClassName)
                        table.insert(Terminal.__updateQueue, {descendant, key})
                    end
                end
            end
        end,

        __tostring = function(obj)
            return obj.Name
        end,
    })
 
    object.__proxy = proxy

    if parent then
        proxy.Parent = parent
        if Terminal then
            table.insert(Terminal.__updateQueue, {proxy, key})
        end
    else
        if Terminal then
            table.insert(Terminal.__updateQueue, {proxy, key})
        end
    end

    return proxy
end

-- inheritable functions: 

function Instance:Clone()
    local cloned_instance = TableUtils.deepcopy(self)
    cloned_instance.Parent = nil

    return cloned_instance
end

function Instance:Destroy()
    self.Destroying:Fire()

    ---@diagnostic disable-next-line: undefined-field
    for key, object in ipairs(self.Parent.__children) do
        if object == self then
            ---@diagnostic disable-next-line: undefined-field
            table.remove(self.Parent.__children, key)
        end
    end

    for _, child in ipairs(self.__children) do
        child:Destroy()
    end
end

function Instance:FindFirstChild(name)
    for _, child in ipairs(self.__children) do
        if child.Name == name then
            return child
        end
    end

    return nil
end

function Instance:FindFirstChildOfClass(className)
    for _, child in ipairs(self.__children) do
        if child.ClassName == className then
            return child
        end
    end

    return nil
end

function Instance:FindFirstDescendant(name)
    for _, child in ipairs(self.__children) do
        if child.Name == name then
            return child
        else
            local temp_result = child:FindFirstDescendant(name)

            if temp_result then
                return temp_result
            end
        end
    end

    return nil
end

function Instance:FindFirstDescendantOfClass(className)
    for _, child in ipairs(self.__children) do
        if child.ClassName == className then
            return child
        else
            local temp_result = child:FindFirstDescendantOfClass(className)

            if temp_result then
                return temp_result
            end
        end
    end

    return nil
end

function Instance:FindFirstAncestor(name)
    local instance = self

    while instance and self.Parent do
        ---@diagnostic disable-next-line: cast-local-type
        instance = self.Parent

        if instance then
            if instance.Name == name then
                return instance
            end
        end
    end

    return nil
end

function Instance:IsDescendantOf(object)
    local instance = self

    while instance and self.Parent do
        if instance.ClassName ~= "Terminal" then
            instance = self.Parent

            if instance then
                if instance.Name == object.Name then
                    return true
                end
            end
        else
            break
        end
    end

    return false
end

function Instance:FindFirstAncestorOfClass(className)
    local instance = self

    while instance and self.Parent do
        ---@diagnostic disable-next-line: cast-local-type
        instance = self.Parent
        if instance then
            if instance.ClassName == className then
                return instance
            end
        end
    end

    return nil
end

function Instance:GetChildren()
    return self.__children
end

function Instance:GetDescendants()
    local descendants = {}

    for _, child in ipairs(self:GetChildren()) do
        table.insert(descendants, child)

        --@diagnostic disable-next-line: redundant-parameter
        local childDescendants = Instance:GetDescendants(child)
        for _, descendant in ipairs(childDescendants) do
            table.insert(descendants, descendant)
        end
    end

    return descendants
end

function Instance:IsA(className)
    for _, subclass in ipairs(self.__inherit) do
        if subclass == className then
            return true
        end
    end

    return false
end

return Instance