local mouse = game.Players.LocalPlayer:GetMouse()
local click = function() game:GetService("VirtualUser"):ClickButton1(game:GetService("UserInputService"):GetMouseLocation(), mouse.Hit) end

while task.wait() do
    if mouse then
        if mouse.Target then
            if mouse.Target.Parent:FindFirstChild("Humanoid") then
                click()
            end
        end
    end
end
