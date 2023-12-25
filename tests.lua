local file = fs.open("/log.txt", "w")
file.close()

term.clear()
term.setCursorPos(1, 1)
require(".UwUtils")

local tree = require(".UwUtils.Utility.Tree")

local Instance = Terminal:GetService("Instance")

print("// Created Root Element")
Element = Instance.new("GuiObject")
Element.Name = "Root"

print("// Created First Element")
local FirstElementChild = Instance.new("GuiObject")
FirstElementChild.Parent = Element
FirstElementChild.Name = "FirstChild"

print("// Created Second Element | No Parent")
local SecondElementChild = Instance.new("GuiObject")
SecondElementChild.Name = "SecondChild"

-- testing Parent assigment


tree(Element)

print("// Assigned Second Element Parent to First Element")
SecondElementChild.Parent = FirstElementChild

tree(FirstElementChild)

print("// Assigned Second Element Parent to Root Element")
SecondElementChild.Parent = Element

tree(Element)
tree(FirstElementChild)

-- tree(FirstElementChild)
-- -- testing Clone

-- print("// Cloned First Element")
-- local ClonedElement = FirstElementChild:Clone()

-- print("// Set Cloned Element Parent to Second Element")
-- ClonedElement.Parent = SecondElementChild
-- print("// Renamed Cloned Element to 'Smth'")
-- ClonedElement.Name = "Smth"

-- tree(Element)