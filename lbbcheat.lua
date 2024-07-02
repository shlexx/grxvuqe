local sigmalbbgui = Instance.new("ScreenGui")
local fram = Instance.new("Frame")
local el_label = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local lien = Instance.new("TextLabel")
local lucky = Instance.new("TextButton")
local super = Instance.new("TextButton")
local rainbow = Instance.new("TextButton")
local diamond = Instance.new("TextButton")
local galaxy = Instance.new("TextButton")
local invincible = Instance.new("TextButton")
local invisible = Instance.new("TextButton")
local tptocenter = Instance.new("TextButton")
local fly = Instance.new("TextButton")

sigmalbbgui.Name = "sigmalbbgui"
sigmalbbgui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

fram.Name = "fram"
fram.Parent = sigmalbbgui
fram.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fram.BorderColor3 = Color3.fromRGB(0, 0, 0)
fram.BorderSizePixel = 0
fram.Position = UDim2.new(0.140745953, 0, 0.120300755, 0)
fram.Size = UDim2.new(0, 189, 0, 262)

el_label.Name = "el_label"
el_label.Parent = fram
el_label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
el_label.BackgroundTransparency = 1.000
el_label.BorderColor3 = Color3.fromRGB(0, 0, 0)
el_label.BorderSizePixel = 0
el_label.Size = UDim2.new(0, 189, 0, 42)
el_label.Font = Enum.Font.SourceSansBold
el_label.Text = "lucky blocks battlegrounds (sigma)"
el_label.TextColor3 = Color3.fromRGB(255, 255, 255)
el_label.TextScaled = true
el_label.TextSize = 14.000
el_label.TextWrapped = true

UICorner.Parent = fram

lien.Name = "lien"
lien.Parent = fram
lien.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lien.BorderColor3 = Color3.fromRGB(0, 0, 0)
lien.BorderSizePixel = 0
lien.Position = UDim2.new(0, 0, 0.189723313, 0)
lien.Size = UDim2.new(0, 189, 0, 1)
lien.Font = Enum.Font.SourceSans
lien.Text = ""
lien.TextColor3 = Color3.fromRGB(0, 0, 0)
lien.TextSize = 14.000

lucky.Name = "lucky"
lucky.Parent = fram
lucky.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lucky.BackgroundTransparency = 1.000
lucky.BorderColor3 = Color3.fromRGB(0, 0, 0)
lucky.BorderSizePixel = 0
lucky.Position = UDim2.new(0, 0, 0.189723298, 0)
lucky.Size = UDim2.new(0, 189, 0, 22)
lucky.Font = Enum.Font.SourceSansBold
lucky.Text = "get lucky block"
lucky.TextColor3 = Color3.fromRGB(255, 255, 255)
lucky.TextScaled = true
lucky.TextSize = 14.000
lucky.TextWrapped = true
lucky.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage").SpawnLuckyBlock:FireServer()
end)

super.Name = "super"
super.Parent = fram
super.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
super.BackgroundTransparency = 1.000
super.BorderColor3 = Color3.fromRGB(0, 0, 0)
super.BorderSizePixel = 0
super.Position = UDim2.new(0, 0, 0.281327575, 0)
super.Size = UDim2.new(0, 189, 0, 22)
super.Font = Enum.Font.SourceSansBold
super.Text = "get super block"
super.TextColor3 = Color3.fromRGB(255, 255, 255)
super.TextScaled = true
super.TextSize = 14.000
super.TextWrapped = true
super.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage").SpawnSuperBlock:FireServer()
end)

rainbow.Name = "rainbow"
rainbow.Parent = fram
rainbow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
rainbow.BackgroundTransparency = 1.000
rainbow.BorderColor3 = Color3.fromRGB(0, 0, 0)
rainbow.BorderSizePixel = 0
rainbow.Position = UDim2.new(0, 0, 0.46453613, 0)
rainbow.Size = UDim2.new(0, 189, 0, 22)
rainbow.Font = Enum.Font.SourceSansBold
rainbow.Text = "get rainbow block"
rainbow.TextColor3 = Color3.fromRGB(255, 255, 255)
rainbow.TextScaled = true
rainbow.TextSize = 14.000
rainbow.TextWrapped = true
rainbow.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage").SpawnRainbowBlock:FireServer()
end)

diamond.Name = "diamond"
diamond.Parent = fram
diamond.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
diamond.BackgroundTransparency = 1.000
diamond.BorderColor3 = Color3.fromRGB(0, 0, 0)
diamond.BorderSizePixel = 0
diamond.Position = UDim2.new(0, 0, 0.372931838, 0)
diamond.Size = UDim2.new(0, 189, 0, 22)
diamond.Font = Enum.Font.SourceSansBold
diamond.Text = "get diamond block"
diamond.TextColor3 = Color3.fromRGB(255, 255, 255)
diamond.TextScaled = true
diamond.TextSize = 14.000
diamond.TextWrapped = true
diamond.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage").SpawnDiamondBlock:FireServer()
end)

galaxy.Name = "galaxy"
galaxy.Parent = fram
galaxy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
galaxy.BackgroundTransparency = 1.000
galaxy.BorderColor3 = Color3.fromRGB(0, 0, 0)
galaxy.BorderSizePixel = 0
galaxy.Position = UDim2.new(0, 0, 0.556140363, 0)
galaxy.Size = UDim2.new(0, 189, 0, 22)
galaxy.Font = Enum.Font.SourceSansBold
galaxy.Text = "get galaxy block"
galaxy.TextColor3 = Color3.fromRGB(255, 255, 255)
galaxy.TextScaled = true
galaxy.TextSize = 14.000
galaxy.TextWrapped = true
galaxy.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage").SpawnGalaxyBlock:FireServer()
end)

invincible.Name = "invincible"
invincible.Parent = fram
invincible.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
invincible.BackgroundTransparency = 1.000
invincible.BorderColor3 = Color3.fromRGB(0, 0, 0)
invincible.BorderSizePixel = 0
invincible.Position = UDim2.new(0, 0, 0.647744477, 0)
invincible.Size = UDim2.new(0, 189, 0, 22)
invincible.Font = Enum.Font.SourceSansBold
invincible.Text = "[BROKEN, DELETED]"
invincible.TextColor3 = Color3.fromRGB(255, 255, 255)
invincible.TextScaled = true
invincible.TextSize = 14.000
invincible.TextWrapped = true

invisible.Name = "invisible"
invisible.Parent = fram
invisible.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
invisible.BackgroundTransparency = 1.000
invisible.BorderColor3 = Color3.fromRGB(0, 0, 0)
invisible.BorderSizePixel = 0
invisible.Position = UDim2.new(0, 0, 0.73934865, 0)
invisible.Size = UDim2.new(0, 189, 0, 22)
invisible.Font = Enum.Font.SourceSansBold
invisible.Text = "inVISible"
invisible.TextColor3 = Color3.fromRGB(255, 255, 255)
invisible.TextScaled = true
invisible.TextSize = 14.000
invisible.TextWrapped = true
invisible.MouseButton1Click:Connect(function()
	local ScriptStarted = false
	local Keybind = "E" --Set to whatever you want, has to be the name of a KeyCode Enum.
	local Transparency = true --Will make you slightly transparent when you are invisible. No reason to disable.
	local NoClip = false --Will make your fake character no clip.

	local Player = game:GetService("Players").LocalPlayer
	local RealCharacter = Player.Character or Player.CharacterAdded:Wait()

	local IsInvisible = false

	RealCharacter.Archivable = true
	local FakeCharacter = RealCharacter:Clone()
	local Part
	Part = Instance.new("Part", workspace)
	Part.Anchored = true
	Part.Size = Vector3.new(200, 1, 200)
	Part.CFrame = CFrame.new(0, -500, 0) --Set this to whatever you want, just far away from the map.
	Part.CanCollide = true
	FakeCharacter.Parent = workspace
	FakeCharacter.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 5, 0)

	for i, v in pairs(RealCharacter:GetChildren()) do
		if v:IsA("LocalScript") then
			local clone = v:Clone()
			clone.Disabled = true
			clone.Parent = FakeCharacter
		end
	end
	if Transparency then
		for i, v in pairs(FakeCharacter:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 0.7
			end
		end
	end
	local CanInvis = true
	function RealCharacterDied()
		CanInvis = false
		RealCharacter:Destroy()
		RealCharacter = Player.Character
		CanInvis = true
		isinvisible = false
		FakeCharacter:Destroy()
		workspace.CurrentCamera.CameraSubject = RealCharacter.Humanoid

		RealCharacter.Archivable = true
		FakeCharacter = RealCharacter:Clone()
		Part:Destroy()
		Part = Instance.new("Part", workspace)
		Part.Anchored = true
		Part.Size = Vector3.new(200, 1, 200)
		Part.CFrame = CFrame.new(9999, 9999, 9999) --Set this to whatever you want, just far away from the map.
		Part.CanCollide = true
		FakeCharacter.Parent = workspace
		FakeCharacter.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 5, 0)

		for i, v in pairs(RealCharacter:GetChildren()) do
			if v:IsA("LocalScript") then
				local clone = v:Clone()
				clone.Disabled = true
				clone.Parent = FakeCharacter
			end
		end
		if Transparency then
			for i, v in pairs(FakeCharacter:GetDescendants()) do
				if v:IsA("BasePart") then
					v.Transparency = 0.7
				end
			end
		end
		RealCharacter.Humanoid.Died:Connect(function()
			RealCharacter:Destroy()
			FakeCharacter:Destroy()
		end)
		Player.CharacterAppearanceLoaded:Connect(RealCharacterDied)
	end
	RealCharacter.Humanoid.Died:Connect(function()
		RealCharacter:Destroy()
		FakeCharacter:Destroy()
	end)
	Player.CharacterAppearanceLoaded:Connect(RealCharacterDied)
	local PseudoAnchor
	game:GetService "RunService".RenderStepped:Connect(
		function()
			if PseudoAnchor ~= nil then
				PseudoAnchor.CFrame = Part.CFrame * CFrame.new(0, 5, 0)
			end
			if NoClip then
				FakeCharacter.Humanoid:ChangeState(11)
			end
		end
	)

	PseudoAnchor = FakeCharacter.HumanoidRootPart
	local function Invisible()
		if IsInvisible == false then
			local StoredCF = RealCharacter.HumanoidRootPart.CFrame
			RealCharacter.HumanoidRootPart.CFrame = FakeCharacter.HumanoidRootPart.CFrame
			FakeCharacter.HumanoidRootPart.CFrame = StoredCF
			RealCharacter.Humanoid:UnequipTools()
			Player.Character = FakeCharacter
			workspace.CurrentCamera.CameraSubject = FakeCharacter.Humanoid
			PseudoAnchor = RealCharacter.HumanoidRootPart
			for i, v in pairs(FakeCharacter:GetChildren()) do
				if v:IsA("LocalScript") then
					v.Disabled = false
				end
			end

			IsInvisible = true
		else
			local StoredCF = FakeCharacter.HumanoidRootPart.CFrame
			FakeCharacter.HumanoidRootPart.CFrame = RealCharacter.HumanoidRootPart.CFrame

			RealCharacter.HumanoidRootPart.CFrame = StoredCF

			FakeCharacter.Humanoid:UnequipTools()
			Player.Character = RealCharacter
			workspace.CurrentCamera.CameraSubject = RealCharacter.Humanoid
			PseudoAnchor = FakeCharacter.HumanoidRootPart
			for i, v in pairs(FakeCharacter:GetChildren()) do
				if v:IsA("LocalScript") then
					v.Disabled = true
				end
			end
			IsInvisible = false
		end
	end

	game:GetService("UserInputService").InputBegan:Connect(function(key, gamep)
		if gamep then
			return
		end
		if key.KeyCode.Name:lower() == Keybind:lower() and CanInvis and RealCharacter and FakeCharacter then
			if RealCharacter:FindFirstChild("HumanoidRootPart") and FakeCharacter:FindFirstChild("HumanoidRootPart") then
				Invisible()
			end
		end
	end)
	local Sound = Instance.new("Sound",game:GetService("SoundService"))
	Sound.SoundId = "rbxassetid://232127604"
	Sound:Play()
	game:GetService("StarterGui"):SetCore("SendNotification",{["Title"] = "Invisible Toggle Loaded",["Text"] = "Press "..Keybind.." to become change visibility.",["Duration"] = 20,["Button1"] = "Okay."})
end)

tptocenter.Name = "tptocenter"
tptocenter.Parent = fram
tptocenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tptocenter.BackgroundTransparency = 1.000
tptocenter.BorderColor3 = Color3.fromRGB(0, 0, 0)
tptocenter.BorderSizePixel = 0
tptocenter.Position = UDim2.new(0, 0, 0.830953121, 0)
tptocenter.Size = UDim2.new(0, 189, 0, 22)
tptocenter.Font = Enum.Font.SourceSansBold
tptocenter.Text = "teleport to center"
tptocenter.TextColor3 = Color3.fromRGB(255, 255, 255)
tptocenter.TextScaled = true
tptocenter.TextSize = 14.000
tptocenter.TextWrapped = true
tptocenter.MouseButton1Click:Connect(function()
	function getRoot(character)
		local rootPart = character:FindFirstChild('HumanoidRootPart') or character:FindFirstChild('Torso') or character:FindFirstChild('UpperTorso')
		return rootPart
	end
	local speaker = game.Players.LocalPlayer
	local tpX,tpY,tpZ = -1040,194,91
	local char = speaker.Character
	if char and getRoot(char) then
		getRoot(char).CFrame = CFrame.new(tpX,tpY,tpZ)
	end
end)

fly.Name = "fly"
fly.Parent = fram
fly.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fly.BackgroundTransparency = 1.000
fly.BorderColor3 = Color3.fromRGB(0, 0, 0)
fly.BorderSizePixel = 0
fly.Position = UDim2.new(0, 0, 0.915476561, 0)
fly.Size = UDim2.new(0, 189, 0, 22)
fly.Font = Enum.Font.SourceSansBold
fly.Text = "fly"
fly.TextColor3 = Color3.fromRGB(255, 255, 255)
fly.TextScaled = true
fly.TextSize = 14.000
fly.TextWrapped = true
fly.MouseButton1Click:Connect(function()
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
		
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.P = 9e4
		bodyGyro.Parent = humanoidRootPart
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = humanoidRootPart.CFrame

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Parent = humanoidRootPart
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		
		character.Humanoid.PlatformStand = true
		
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
		
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
