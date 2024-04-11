return function(...) 
        local file = fs.open("/log.txt", "a")
        file.write("\n" .. ...)
        file.close()
end