local file = fs.open("/log.txt", "w")
file.close()

term.clear()
term.setCursorPos(1, 1)
require(".UwUtils")

local tree = require(".UwUtils.Utility.Tree")
local log = require(".UwUtils.Utility.Log")

local update = require(".UwUtils.update")