return function(...) 
        local file = fs.open("/log.txt", "a")
        file.write(...)
        file.close()
end