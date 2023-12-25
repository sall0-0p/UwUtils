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

local Instance = {
    -- attributes
    Name = "",
    ClassName = "Instance",
    Parent = "",

    -- events
    ChildAdded = Signal.new(),
    ChildRemoved = Signal.new(),
    DescendantAdded = Signal.new(),
    DescendantRemoved = Signal.new(),
    Changed = Signal.new(),
    
    -- private
    __public = true,
    __children = {},
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
            obj[key] = value
        end
    })

    table.insert(parent.__children, object)
    
    return object
end

-- inheritable functions: 

function Instance:Clone(self)
    local cloned_instance = table.deepcopy(self)
    cloned_instance.Parent = nil

    return cloned_instance
end

function Instance:Destroy(self)
    self.Parent = nil

    for index, _ in self do
        self[index] = nil
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

        if instance.Name == name then
            return instance
        end
    end

    return nil
end

function Instance:FindFirstAncestorOfClass(className)
    local instance = self

    while instance and self.Parent do
        ---@diagnostic disable-next-line: cast-local-type
        instance = self.Parent

        if instance.ClassName == className then
            return instance
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
    if self.ClassNmae == className then
        return true
    else
        return false
    end
end

return Instance