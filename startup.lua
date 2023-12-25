local file = fs.open("/log.txt", "w")
file.close()

require(".UwUtils")

local Instance = Terminal:GetService("Instance")

local Element = Instance.new("GuiObject")
Element.Parent = Terminal
Element.Name = "UwU_Frame"

print(Element)
print(Element.Parent)
Element.Destroying:Connect(function() 
    print("Im Getting Destroyed! HELP ME! PLEASEEE!")
end)

Element:Destroy()

print(Element)
print(Terminal.Element)