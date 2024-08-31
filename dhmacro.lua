if getgenv then
    local UIS = game:GetService("UserInputService")
    local hum = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local keybind = Enum.KeyCode.Q
    local macrows = 175
    getgenv().oldWalkSpeed = hum.WalkSpeed
    
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == keybind then
            hum.WalkSpeed = macrows
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.KeyCode == keybind then
            hum.WalkSpeed = getgenv().oldWalkSpeed
        end
    end)
else
    local UIS = game:GetService("UserInputService")
    local hum = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local keybind = Enum.KeyCode.Q
    local macrows = 175
    
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == keybind then
            hum.WalkSpeed = macrows
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.KeyCode == keybind then
            hum.WalkSpeed = 16
        end
    end)
end
