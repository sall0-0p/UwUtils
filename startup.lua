local Instance = require(".UwUtils.Classes.Instance")

local SomeInstance = Instance.new("Instance", {
    __children = {}
})

local GuiObject = Instance.new("GuiObject", SomeInstance)
GuiObject.Name = "Bucket"

print(SomeInstance.Bucket.ZIndex)
print(GuiObject.ZIndex)
print(SomeInstance:FindFirstChildOfClass("GuiObject").ZIndex)