local epicdogiqgui = Instance.new("ScreenGui")
local fram = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local eltxt = Instance.new("TextLabel")
local lien = Instance.new("TextLabel")
local getalltools = Instance.new("TextButton")
local flybtn = Instance.new("TextButton")
local dexbtn = Instance.new("TextButton")

epicdogiqgui.Name = "epicdogiqgui"
epicdogiqgui.ResetOnSpawn = false
epicdogiqgui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

fram.Name = "fram"
fram.Parent = epicdogiqgui
fram.BackgroundColor3 = Color3.fromRGB(61, 61, 61)
fram.BorderColor3 = Color3.fromRGB(0, 0, 0)
fram.BorderSizePixel = 0
fram.Position = UDim2.new(0.152005628, 0, 0.0476190485, 0)
fram.Size = UDim2.new(0, 216, 0, 176)

UICorner.Parent = fram

eltxt.Name = "eltxt"
eltxt.Parent = fram
eltxt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
eltxt.BackgroundTransparency = 1.000
eltxt.BorderColor3 = Color3.fromRGB(0, 0, 0)
eltxt.BorderSizePixel = 0
eltxt.Size = UDim2.new(0, 216, 0, 44)
eltxt.Font = Enum.Font.SourceSansBold
eltxt.Text = "doge iq obby gui o_0"
eltxt.TextColor3 = Color3.fromRGB(255, 255, 255)
eltxt.TextScaled = true
eltxt.TextSize = 14.000
eltxt.TextWrapped = true

lien.Name = "lien"
lien.Parent = fram
lien.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lien.BorderColor3 = Color3.fromRGB(0, 0, 0)
lien.BorderSizePixel = 0
lien.Position = UDim2.new(0, 0, 0.25, 0)
lien.Size = UDim2.new(0, 216, 0, 1)
lien.Font = Enum.Font.SourceSans
lien.Text = ""
lien.TextColor3 = Color3.fromRGB(0, 0, 0)
lien.TextSize = 14.000

getalltools.Name = "getalltools"
getalltools.Parent = fram
getalltools.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
getalltools.BackgroundTransparency = 1.000
getalltools.BorderColor3 = Color3.fromRGB(0, 0, 0)
getalltools.BorderSizePixel = 0
getalltools.Position = UDim2.new(0, 0, 0.25, 0)
getalltools.Size = UDim2.new(0, 216, 0, 44)
getalltools.Font = Enum.Font.SourceSansBold
getalltools.Text = "get tools"
getalltools.TextColor3 = Color3.fromRGB(255, 255, 255)
getalltools.TextScaled = true
getalltools.TextSize = 14.000
getalltools.TextWrapped = true
getalltools.MouseButton1Click:Connect(function()
	local speaker = game.Players.LocalPlayer
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Lighting = game:GetService("Lighting")
	local function copy(instance)
		for i,c in pairs(instance:GetChildren())do
			if c:IsA('Tool') or c:IsA('HopperBin') then
				c:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
			end
			copy(c)
		end
	end
	copy(Lighting)
	copy(ReplicatedStorage)
end)

flybtn.Name = "flybtn"
flybtn.Parent = fram
flybtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flybtn.BackgroundTransparency = 1.000
flybtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
flybtn.BorderSizePixel = 0
flybtn.Position = UDim2.new(0, 0, 0.5, 0)
flybtn.Size = UDim2.new(0, 216, 0, 44)
flybtn.Font = Enum.Font.SourceSansBold
flybtn.Text = "fly"
flybtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flybtn.TextScaled = true
flybtn.TextSize = 14.000
flybtn.TextWrapped = true
flybtn.MouseButton1Click:Connect(function()
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
end)

dexbtn.Name = "dexbtn"
dexbtn.Parent = fram
dexbtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dexbtn.BackgroundTransparency = 1.000
dexbtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
dexbtn.BorderSizePixel = 0
dexbtn.Position = UDim2.new(0, 0, 0.75, 0)
dexbtn.Size = UDim2.new(0, 216, 0, 44)
dexbtn.Font = Enum.Font.SourceSansBold
dexbtn.Text = "dex"
dexbtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dexbtn.TextScaled = true
dexbtn.TextSize = 14.000
dexbtn.TextWrapped = true
dexbtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)
