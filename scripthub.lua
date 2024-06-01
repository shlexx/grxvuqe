local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("grxvuqe's Script Hub", "Synapse")

local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Main")

MainSection:NewButton("Infinite Yield", "gives you infinite yield script", function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

MainSection:NewButton("Nameless Admin", "gives you nameless admin script", function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
end)

MainSection:NewButton("Esp", "makes you see everyone through walls", function()
	local dwEntities = game:GetService("Players")
	local dwLocalPlayer = dwEntities.LocalPlayer 
	local dwRunService = game:GetService("RunService")

	local settings_tbl = {
		ESP_Enabled = true,
		ESP_TeamCheck = false,
		Chams = true,
		Chams_Color = Color3.fromRGB(0,0,255),
		Chams_Transparency = 0.1,
		Chams_Glow_Color = Color3.fromRGB(255,0,0)
	}

	local function destroy_chams(char)
		for k,v in next, char:GetChildren() do 
			if v:IsA("BasePart") and v.Transparency ~= 1 then
				if v:FindFirstChild("Glow") and 
					v:FindFirstChild("Chams") then
					v.Glow:Destroy()
					v.Chams:Destroy() 
				end 
			end 
		end 
	end

	dwRunService.Heartbeat:Connect(function()
		if settings_tbl.ESP_Enabled then
			for k,v in next, dwEntities:GetPlayers() do 
				if v ~= dwLocalPlayer then
					if v.Character and
						v.Character:FindFirstChild("HumanoidRootPart") and 
						v.Character:FindFirstChild("Humanoid") and 
						v.Character:FindFirstChild("Humanoid").Health ~= 0 then
						if settings_tbl.ESP_TeamCheck == false then
							local char = v.Character 
							for k,b in next, char:GetChildren() do 
								if b:IsA("BasePart") and 
									b.Transparency ~= 1 then
									if settings_tbl.Chams then
										if not b:FindFirstChild("Glow") and
											not b:FindFirstChild("Chams") then

											local chams_box = Instance.new("BoxHandleAdornment", b)
											chams_box.Name = "Chams"
											chams_box.AlwaysOnTop = true 
											chams_box.ZIndex = 4 
											chams_box.Adornee = b 
											chams_box.Color3 = settings_tbl.Chams_Color
											chams_box.Transparency = settings_tbl.Chams_Transparency
											chams_box.Size = b.Size + Vector3.new(0.02, 0.02, 0.02)

											local glow_box = Instance.new("BoxHandleAdornment", b)
											glow_box.Name = "Glow"
											glow_box.AlwaysOnTop = false 
											glow_box.ZIndex = 3 
											glow_box.Adornee = b 
											glow_box.Color3 = settings_tbl.Chams_Glow_Color
											glow_box.Size = chams_box.Size + Vector3.new(0.13, 0.13, 0.13)
										end
									else
										destroy_chams(char)
									end
								end
							end
						else
							if v.Team == dwLocalPlayer.Team then
								destroy_chams(v.Character)
							end
						end
					else
						destroy_chams(v.Character)
					end
				end
			end
		else 
			for k,v in next, dwEntities:GetPlayers() do 
				if v ~= dwLocalPlayer and 
					v.Character and 
					v.Character:FindFirstChild("HumanoidRootPart") and 
					v.Character:FindFirstChild("Humanoid") and 
					v.Character:FindFirstChild("Humanoid").Health ~= 0 then

					destroy_chams(v.Character)
				end
			end
		end
	end)
end)

MainSection:NewButton("Aimbot", "gives you an aimbot script", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Hyper-Escape/main/DeleteMobCheatEngine.lua"))()
end)

MainSection:NewButton("Flight", "makes you fly", function()
	local player = game.Players.LocalPlayer
	local userInputService = game:GetService("UserInputService")
	local runService = game:GetService("RunService")

	local speed = 50
	local bodyGyro
	local bodyVelocity
	local flying = false
	local direction = Vector3.new(0, 0, 0)
	local keysPressed = {}

	local function startFlying()
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

	local function stopFlying()
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

	local function updateDirection()
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

	local function onInputBegan(input, gameProcessed)
		if gameProcessed then return end
		keysPressed[input.KeyCode] = true
		updateDirection()
	end

	local function onInputEnded(input, gameProcessed)
		if gameProcessed then return end
		keysPressed[input.KeyCode] = nil
		updateDirection()
	end

	userInputService.InputBegan:Connect(onInputBegan)
	userInputService.InputEnded:Connect(onInputEnded)

	startFlying()
end)

MainSection:NewButton("Chat Bypass", "gives you a chat bypass gui", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/BakaPraselol/MRCBV4LSB4KRS/main/Loader"))()
end)

MainSection:NewButton("Turtle Spy", "gives you a remote spy gui", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/BDhSQqUU", true))()
end)

MainSection:NewSlider("Walkspeed", "changes how fast you walk, default: 16", 250, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

MainSection:NewSlider("JumpPower", "changes how fast you jump, default: 50", 250, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

local Credits = Window:NewTab("Credits")
local CreditsSection = Credits:NewSection("Credits")

CreditsSection:NewLabel("Created by grxvuqe")
