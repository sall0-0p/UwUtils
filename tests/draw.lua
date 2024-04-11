local file = fs.open("/log.txt", "w")
file.close()

term.clear()
term.setCursorPos(1, 1)
require(".UwUtils")
Terminal:Init()

local tree = require(".UwUtils.Utility.Tree")
local log = require(".UwUtils.Utility.Log")

local termX, termY = term.getSize()

local Instance = Terminal:GetService("Instance")

local Background = Instance.new("Frame", Terminal)
Background.Name = "Background"
Background.Size = {51, 19}
Background.BackgroundColor = colors.lightGray

local Header = Instance.new("Frame", Background)
Header.Name = "Header"
Header.Size = {51, 2}
Header.Position = {1, 1}
Header.BackgroundColor = colors.gray

local Main = Instance.new("Frame", Background)
Main.Name = "Container"
Main.Size = {51, 17}
Main.Position = {1, 3}
Main.Visible = false

local Banner = Instance.new("Frame", Main)
Banner.Name = "Banner"
Banner.Size = {10, 15}
Banner.Position = {2, 2}
Banner.BackgroundColor = colors.gray

local Thing = Instance.new("Frame", Banner)
Thing.Name = "Thing"
Thing.Size = {10, 3}
Thing.BackgroundColor = colors.black

local function updateScreen()
    local update = require(".UwUtils.update")
end

local function updateRuntimeExample()
    while true do
        os.sleep(0.1)
        Banner.Position = {math.random(1, 10), math.random(1, 10)}
    end
end

parallel.waitForAll(updateScreen, updateRuntimeExample)