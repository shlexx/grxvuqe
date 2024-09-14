local key = Enum.KeyCode.Q
local fovdensity = 5
local mousedensity = 4

local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(input)
    if input.KeyCode == key then
        workspace:FindFirstChild("Camera").FieldOfView /= fovdensity
        uis.MouseDeltaSensitivity /= mousedensity
    end
end)

uis.InputEnded:Connect(function(input)
    if input.KeyCode == key then
        workspace:FindFirstChild("Camera").FieldOfView *= fovdensity
        uis.MouseDeltaSensitivity *= mousedensity
    end
end)
