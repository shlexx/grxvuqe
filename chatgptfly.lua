local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
 
local speed = 50
local bodyGyro
local bodyVelocity
local flying = false
local direction = Vector3.new(0, 0, 0)
local keysPressed = {}
 
function startFlying()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
 
    flying = true
 
    -- Create BodyGyro and BodyVelocity instances
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.Parent = humanoidRootPart
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = humanoidRootPart.CFrame
 
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Parent = humanoidRootPart
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
 
    -- Disable gravity
    character.Humanoid.PlatformStand = true
 
    -- Disable collisions
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
 
    -- Update the flying movement
    runService.Heartbeat:Connect(function()
        if flying then
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            local cameraCFrame = workspace.CurrentCamera.CFrame
            bodyVelocity.Velocity = (cameraCFrame.LookVector * direction.Z 
                                    + cameraCFrame.RightVector * direction.X) * speed
        end
    end)
end
 
function stopFlying()
    if flying then
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if player.Character then
            player.Character.Humanoid.PlatformStand = false
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        flying = false
    end
end
 
function updateDirection()
    local newDirection = Vector3.new(0, 0, 0)
    for key, value in pairs(keysPressed) do
        if value and key == Enum.KeyCode.W then
            newDirection = newDirection + Vector3.new(0, 0, 1)
        elseif value and key == Enum.KeyCode.S then
            newDirection = newDirection + Vector3.new(0, 0, -1)
        elseif value and key == Enum.KeyCode.A then
            newDirection = newDirection + Vector3.new(-1, 0, 0)
        elseif value and key == Enum.KeyCode.D then
            newDirection = newDirection + Vector3.new(1, 0, 0)
        end
    end
    direction = newDirection
end
 
function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    keysPressed[input.KeyCode] = true
    updateDirection()
end
 
function onInputEnded(input, gameProcessed)
    if gameProcessed then return end
    keysPressed[input.KeyCode] = nil
    updateDirection()
end
 
userInputService.InputBegan:Connect(onInputBegan)
userInputService.InputEnded:Connect(onInputEnded)
 
startFlying()
