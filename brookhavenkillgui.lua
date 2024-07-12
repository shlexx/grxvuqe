local epikkil = Instance.new("ScreenGui")
local frem = Instance.new("Frame")
local leble = Instance.new("TextLabel")
local kilebutone = Instance.new("TextButton")
local espbutone = Instance.new("TextButton")
local gotobutone = Instance.new("TextButton")
local gototexte = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")
local lien = Instance.new("TextLabel")
local lien2 = Instance.new("TextLabel")

epikkil.Name = "epikkil"
epikkil.ResetOnSpawn = false
epikkil.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

frem.Name = "frem"
frem.Parent = epikkil
frem.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
frem.BorderColor3 = Color3.fromRGB(0, 0, 0)
frem.BorderSizePixel = 0
frem.Position = UDim2.new(0.0894996449, 0, 0.0263157897, 0)
frem.Size = UDim2.new(0, 345, 0, 101)

leble.Name = "leble"
leble.Parent = frem
leble.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
leble.BorderColor3 = Color3.fromRGB(0, 0, 0)
leble.BorderSizePixel = 0
leble.Position = UDim2.new(0.0322463773, 0, 0.0891089141, 0)
leble.Size = UDim2.new(0, 153, 0, 30)
leble.Font = Enum.Font.SourceSansBold
leble.Text = "brookhaven kill gui o_0 (must have player in a cart or smth)"
leble.TextColor3 = Color3.fromRGB(255, 255, 255)
leble.TextScaled = true
leble.TextSize = 14.000
leble.TextWrapped = true

kilebutone.Name = "kilebutone"
kilebutone.Parent = frem
kilebutone.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
kilebutone.BorderColor3 = Color3.fromRGB(0, 0, 0)
kilebutone.BorderSizePixel = 0
kilebutone.Position = UDim2.new(0.0322463773, 0, 0.613861382, 0)
kilebutone.Size = UDim2.new(0, 153, 0, 30)
kilebutone.Font = Enum.Font.SourceSansBold
kilebutone.Text = "kill"
kilebutone.TextColor3 = Color3.fromRGB(255, 255, 255)
kilebutone.TextSize = 14.000
kilebutone.MouseButton1Click:Connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -400, 0)
end)

espbutone.Name = "espbutone"
espbutone.Parent = frem
espbutone.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
espbutone.BorderColor3 = Color3.fromRGB(0, 0, 0)
espbutone.BorderSizePixel = 0
espbutone.Position = UDim2.new(0.533695638, 0, 0.0891089141, 0)
espbutone.Size = UDim2.new(0, 153, 0, 30)
espbutone.Font = Enum.Font.SourceSansBold
espbutone.Text = "esp"
espbutone.TextColor3 = Color3.fromRGB(255, 255, 255)
espbutone.TextSize = 14.000
espbutone.MouseButton1Click:Connect(function()
	local dwEntities = game:GetService("Players")
	local dwLocalPlayer = dwEntities.LocalPlayer 
	local dwRunService = game:GetService("RunService")

	local settings_tbl = {
		ESP_Enabled = true,
		ESP_TeamCheck = false,
		Chams = true,
		Chams_Color = Color3.fromRGB(255,255,255),
		Chams_Transparency = 0.1,
		Chams_Glow_Color = Color3.fromRGB(255,255,255)
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

gototexte.Name = "gototexte"
gototexte.Parent = frem
gototexte.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
gototexte.BorderColor3 = Color3.fromRGB(0, 0, 0)
gototexte.BorderSizePixel = 0
gototexte.Position = UDim2.new(0.533333361, 0, 0.613861382, 0)
gototexte.Size = UDim2.new(0, 153, 0, 15)
gototexte.Font = Enum.Font.SourceSansBold
gototexte.PlaceholderText = "name (can be shortened)"
gototexte.Text = ""
gototexte.TextColor3 = Color3.fromRGB(255, 255, 255)
gototexte.TextSize = 14.000

gotobutone.Name = "gotobutone"
gotobutone.Parent = frem
gotobutone.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
gotobutone.BorderColor3 = Color3.fromRGB(0, 0, 0)
gotobutone.BorderSizePixel = 0
gotobutone.Position = UDim2.new(0.533695638, 0, 0.762376249, 0)
gotobutone.Size = UDim2.new(0, 153, 0, 15)
gotobutone.Font = Enum.Font.SourceSansBold
gotobutone.Text = "goto"
gotobutone.TextColor3 = Color3.fromRGB(255, 255, 255)
gotobutone.TextSize = 14.000
gotobutone.MouseButton1Click:Connect(function()
	local msg = gototexte.Text

	local function findPlayer(stringg)
		for _, v in pairs(game.Players:GetPlayers()) do
			if stringg:lower() == (v.Name:lower()):sub(1, #stringg) then
				return v
			end
		end
	end

	local player = findPlayer(msg)
	
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(3,1,0)
end)

UICorner.Parent = frem

lien.Name = "lien"
lien.Parent = frem
lien.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lien.BorderColor3 = Color3.fromRGB(0, 0, 0)
lien.BorderSizePixel = 0
lien.Position = UDim2.new(0, 0, 0.495049506, 0)
lien.Size = UDim2.new(0, 174, 0, 1)
lien.Font = Enum.Font.SourceSans
lien.Text = ""
lien.TextColor3 = Color3.fromRGB(0, 0, 0)
lien.TextSize = 14.000

lien2.Name = "lien2"
lien2.Parent = frem
lien2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lien2.BorderColor3 = Color3.fromRGB(0, 0, 0)
lien2.BorderSizePixel = 0
lien2.Position = UDim2.new(0.504347801, 0, 0.495049506, 0)
lien2.Size = UDim2.new(0, -1, 0, -50)
lien2.Font = Enum.Font.SourceSans
lien2.Text = ""
lien2.TextColor3 = Color3.fromRGB(0, 0, 0)
lien2.TextSize = 14.000
