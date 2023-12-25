local globals = require(".UwUtils.globals")

for key, some_global in pairs(globals) do
    _G[key] = some_global
end