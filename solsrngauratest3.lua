local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(1, 1)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(1, 0, 1.00100005, 0)
Frame.Size = UDim2.new(0, 150, 0, 50)

TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(-4.2317708e-05, 0, -0.0245114136, 0)
TextBox.Size = UDim2.new(0, 150, 0, 25)
TextBox.Font = Enum.Font.SourceSansBold
TextBox.PlaceholderText = "ENTER CHEAT CODE"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14.000
TextBox.ClearTextOnFocus = false

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(-4.2317708e-05, 0, 0.474089652, 0)
TextButton.Size = UDim2.new(0, 150, 0, 25)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "execute"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14.000
TextButton.MouseButton1Click:Connect(function()
	local t = TextBox.Text
	local args = t:split(" ")
	local auras = {
		"DESPERATION",
		"Basic",
		"Disfigured",
		"VOXEL",
		"Unique",
		"Uncommon",
		"Test",
		"Stargazer",
		"Sentinel",
		"SINGULARITY",
		"Resonation",
		"Rare",
		"Purgatory",
		"Problematic",
		"Mythic",
		"Epic",
		"Legendary",
		"Layers",
		"Timefallen",
		"Gold",
		"Liberation",
		"Angellica",
		"Aggressor",
		"Sand",
		"SandStorm",
		"Lucky",
		"Blitzspeed",
		"ProblematicRe",
		"SOA",
		"Infinity",
		"Rockstar",
		"EMPYREAN",
		"Novice",
		"Space",
		"Fire",
		"DETERMINATED",
		"Arcanic",
		"LIMBO",
		"EndlessVoid",
		"Divinity",
		"DivinitySakurian",
		"Toxicology",
		"DISASTER",
		"Adjustify",
		"Shadowbeast",
		"LayersRe",
		"SINGULARITYOG",
	}

	if args[1] == "equip" then
		for i, v in nsauras do
			if v == args[2] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
	elseif t == "unequip" then
		game:GetService("ReplicatedStorage").Remotes.AuraUnequipAll:FireServer()
	end
end)
