local Terminal = {
    {
        {
            symbol = "\149",
            background = colors.blue,
            foreground = colors.white,
        },
        {
            symbol = "\149",
            background = colors.red,
            foreground = colors.white,
        }
    }
}
local Cell = {
    symbol = 149,
    background = colors.black,
    foreground = colors.white,
}

local function blit(symbol, foreground, background)
    term.setTextColor(foreground)
    term.setTextColor(background)

    term.write(symbol)
end

local function Draw()
    term.clear()
    local termWidth, termHeight = term.getSize()

    for x = 1, termWidth, 1 do
        for y = 1, termHeight, 1 do
            local cell
            local column = Terminal[y]
            if column then
                cell = column[x]
            end
            
            if cell then
                term.setCursorPos(x, y)
                blit(cell.symbol, cell.foreground, cell.background)
            end
        end
    end
end

Draw()