local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local lockDistance = 50
 
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = lockDistance
 
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local char = otherPlayer.Character
            local rootPart = char.HumanoidRootPart
            local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
            local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
 
            if distance < shortestDistance then
                closestPlayer = otherPlayer
                shortestDistance = distance
            end
        end
    end
 
    return closestPlayer
end
 
game:GetService("RunService").RenderStepped:Connect(function()
    local closestPlayer = getClosestPlayer()
 
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = closestPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
 
        local direction = (rootPart.Position - camera.CFrame.Position).unit
 
        local newCameraCFrame = CFrame.new(camera.CFrame.Position, rootPart.Position)
 
        camera.CFrame = newCameraCFrame
    end
end)
