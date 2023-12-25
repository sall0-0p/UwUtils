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
    }
    local mainClass = require(".UwUtils.Classes." .. className)
    assert(mainClass.__public, "Cannot create Instance of class '" .. className .. "' (private)")

    setmetatable(object, {
        __index = function(self, key) 
            for _, subclass in ipairs(mainClass.__inherit) do
                local subclass = require(".UwUtils.Classes." .. subclass)
                if subclass[key] then
                    return subclass[key]
                end
            end

            if self:FindFirstChild(key) then
                return self:FindFirstChild(key)
            end

            return nil
        end,

        __newindex = function(obj, key, value)
            -- check for read-only
            if obj.__readOnly then
                for _, attribute in ipairs(obj.__readOnly) do
                    if key == attribute then
                        error("Cannot change read-only value '" .. key .. "'")
                    end
                end
            end

            -- if we are assigning parent
            if key == "Parent" then
                if obj.Parent then
                    for index, child in ipairs(obj.Parent.__children) do
                        if child == obj then
                            table.remove(obj.Parent.__children, index)
                        end
                    end
                end
                
                table.insert(value.__children, obj)
                rawset(obj, "Parent", value)
            else
                -- handle __onChangeFunctions
                if obj.__onChangeFunctions then
                    for _, attribute in ipairs(obj.__onChangeFunctions) do
                        if key == attribute then
                            obj.__onChangeFunctions[key](value)
                        end
                    end
                end

                -- assign value
                obj[key] = value
            end
        end,

        __tostring = function(obj)
            return obj.Name
        end
    })

    if parent then
        table.insert(parent.__children, object)
    end
    
    return object
end

-- inheritable functions: 

function Instance:Clone(self)
    ---@diagnostic disable-next-line: undefined-field
    local cloned_instance = table.deepcopy(self)
    cloned_instance.Parent = nil

    return cloned_instance
end

function Instance:Destroy(self)
    self.Destroying:Fire()

    for key, object in ipairs(self.Parent.__children) do
        if object == self then
            table.remove(self.Parent.__children, key)
        end
    end
    self = nil
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

function Instance:GetDescendants(self)
    local descendants = {}

    for _, child in ipairs(self:GetChildren()) do
        table.insert(descendants, child)

        local childDescendants = Instance:GetDescendants(child)
        for _, descendant in ipairs(childDescendants) do
            table.insert(descendants, descendant)
        end
    end

    return descendants
end

function Instance:IsA(className)
    for _, subclass in self.__inherit do
        if subclass == className then
            return true
        end
    end

    return false
end

return Instance