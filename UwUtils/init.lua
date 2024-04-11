local globals = require(".UwUtils.globals")

for key, some_global in pairs(globals) do
    _G[key] = some_global
end

function math.round(n)
    return n + 0.5 - (n + 0.5) % 1
end
