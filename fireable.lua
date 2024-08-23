print("🟢 - ClickDetector 🔵 - TouchInterest/TouchTransmitter 🟣 - ProximityPrompt")
for _,v in pairs(game:GetDescendants()) do
    if v:IsA("ClickDetector") then
        print("game." .. v:GetFullName() .. " 🟢")
    elseif v:IsA("TouchTransmitter") then
        print("game." .. v:GetFullName() .. " 🔵")
    elseif v:IsA("ProximityPrompt") then
        print("game." .. v:GetFullName() .. " 🟣")
    end
end
