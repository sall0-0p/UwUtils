local file = fs.open("/log.txt", "w")
file.close()

term.clear()
term.setCursorPos(1, 1)
sleep(0.2)
require(".UwUtils")

local tree = require(".UwUtils.Utility.Tree")
local log = require(".UwUtils.Utility.Log")

local Instance = Terminal:GetService("Instance")

log("// Created Root Element")
Element = Instance.new("GuiObject", Terminal)
Element.Name = "Root"

log("// Created First Element")
local FirstElementChild = Instance.new("GuiObject")
FirstElementChild.Parent = Element
FirstElementChild.Name = "FirstChild"

log("// Created Second Element | No Parent")
local SecondElementChild = Instance.new("GuiObject")
SecondElementChild.Name = "SecondChild"

-- testing Parent assigment
tree(Element)

log("\n [ACTION] Assigned Second Element Parent to First Element")
SecondElementChild.Parent = FirstElementChild

tree(Element)
tree(FirstElementChild)

log("\n [ACTION] Assigned Second Element Parent to Root Element")
SecondElementChild.Parent = Element -- this part

tree(Element)
tree(FirstElementChild)

-- testing Clone

log("\n [ACTION] Cloned First Element")
local ClonedElement = FirstElementChild:Clone()

log("\n [ACTION] Set Cloned Element Parent to Second Element")
ClonedElement.Parent = SecondElementChild
log("\n [ACTION] Renamed Cloned Element to 'Smth'")
ClonedElement.Name = "Smth"

tree(Element)
tree(SecondElementChild)

tree(Terminal)

term.setTextColor(colors.lime)
print("Done!")
term.setTextColor(colors.white)