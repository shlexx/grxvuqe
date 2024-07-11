local method = math.random(1, 2)

if method == 1 then
    local alphabet = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local randomString = ""
    local randomString2 = ""
    local randomString3 = ""
    local randomString4 = ""

    for i = 1, 4 do
        local randomIndex = math.random(1, #alphabet)
        randomString = randomString .. alphabet:sub(randomIndex, randomIndex)
    end
    
    for i = 1, 4 do
        local randomIndex = math.random(1, #alphabet)
        randomString2 = randomString2 .. alphabet:sub(randomIndex, randomIndex)
    end

    for i = 1, 4 do
        local randomIndex = math.random(1, #alphabet)
        randomString3 = randomString3 .. alphabet:sub(randomIndex, randomIndex)
    end

    for i = 1, 4 do
        local randomIndex = math.random(1, #alphabet)
        randomString4 = randomString4 .. alphabet:sub(randomIndex, randomIndex)
    end

    setclipboard(randomString .. "-" .. randomString2 .. "-" .. randomString3 .. "-" .. randomString4)
elseif method == 2 then
    local alphabet = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local randomString = ""
    local randomString2 = ""
    local randomString3 = ""

    for i = 1, 5 do
        local randomIndex = math.random(1, #alphabet)
        randomString = randomString .. alphabet:sub(randomIndex, randomIndex)
    end
    
    for i = 1, 5 do
        local randomIndex = math.random(1, #alphabet)
        randomString2 = randomString2 .. alphabet:sub(randomIndex, randomIndex)
    end

    for i = 1, 5 do
        local randomIndex = math.random(1, #alphabet)
        randomString3 = randomString3 .. alphabet:sub(randomIndex, randomIndex)
    end

    setclipboard(randomString .. "-" .. randomString2 .. "-" .. randomString3)
end
