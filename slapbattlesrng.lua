local epifguii = Instance.new("ScreenGui")
local freem = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local lebil = Instance.new("TextLabel")
local lin = Instance.new("TextLabel")
local auratekst = Instance.new("TextBox")
local equipaura = Instance.new("TextButton")
local unequipaura = Instance.new("TextButton")
local nighttime = Instance.new("TextButton")
local glitchspam = Instance.new("TextButton")
local gettrail = Instance.new("TextButton")
local lightning = Instance.new("TextButton")
local blinded = Instance.new("TextButton")

epifguii.Name = "epifguii"
epifguii.ResetOnSpawn = false
epifguii.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

freem.Name = "freem"
freem.Parent = epifguii
freem.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
freem.BorderColor3 = Color3.fromRGB(0, 0, 0)
freem.BorderSizePixel = 0
freem.Position = UDim2.new(0.12684989, 0, 0.062656641, 0)
freem.Size = UDim2.new(0, 244, 0, 221)

UICorner.Parent = freem

lebil.Name = "lebil"
lebil.Parent = freem
lebil.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lebil.BackgroundTransparency = 1.000
lebil.BorderColor3 = Color3.fromRGB(0, 0, 0)
lebil.BorderSizePixel = 0
lebil.Size = UDim2.new(0, 244, 0, 20)
lebil.Font = Enum.Font.SourceSansBold
lebil.Text = "slap battles utg o_0"
lebil.TextColor3 = Color3.fromRGB(255, 255, 255)
lebil.TextSize = 14.000

lin.Name = "lin"
lin.Parent = freem
lin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lin.BorderColor3 = Color3.fromRGB(0, 0, 0)
lin.BorderSizePixel = 0
lin.Position = UDim2.new(0, 0, 0.0904977396, 0)
lin.Size = UDim2.new(0, 244, 0, 1)
lin.Font = Enum.Font.SourceSans
lin.Text = ""
lin.TextColor3 = Color3.fromRGB(0, 0, 0)
lin.TextSize = 14.000

auratekst.Name = "auratekst"
auratekst.Parent = freem
auratekst.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
auratekst.BackgroundTransparency = 1.000
auratekst.BorderColor3 = Color3.fromRGB(0, 0, 0)
auratekst.BorderSizePixel = 0
auratekst.Position = UDim2.new(0, 0, 0.0950226262, 0)
auratekst.Size = UDim2.new(0, 244, 0, 30)
auratekst.Font = Enum.Font.SourceSansBold
auratekst.PlaceholderText = "enter aura name here"
auratekst.Text = ""
auratekst.TextColor3 = Color3.fromRGB(255, 255, 255)
auratekst.TextSize = 14.000

equipaura.Name = "equipaura"
equipaura.Parent = freem
equipaura.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
equipaura.BackgroundTransparency = 1.000
equipaura.BorderColor3 = Color3.fromRGB(0, 0, 0)
equipaura.BorderSizePixel = 0
equipaura.Position = UDim2.new(0, 0, 0.230769232, 0)
equipaura.Size = UDim2.new(0, 122, 0, 25)
equipaura.Font = Enum.Font.SourceSansBold
equipaura.Text = "equip"
equipaura.TextColor3 = Color3.fromRGB(255, 255, 255)
equipaura.TextSize = 14.000
equipaura.MouseButton1Click:Connect(function()
	local args = {
		[1] = auratekst.Text,
		[2] = "equip"
	}

	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToggleEquip"):FireServer(unpack(args))
end)

unequipaura.Name = "unequipaura"
unequipaura.Parent = freem
unequipaura.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
unequipaura.BackgroundTransparency = 1.000
unequipaura.BorderColor3 = Color3.fromRGB(0, 0, 0)
unequipaura.BorderSizePixel = 0
unequipaura.Position = UDim2.new(0.5, 0, 0.230769232, 0)
unequipaura.Size = UDim2.new(0, 122, 0, 25)
unequipaura.Font = Enum.Font.SourceSansBold
unequipaura.Text = "unequip"
unequipaura.TextColor3 = Color3.fromRGB(255, 255, 255)
unequipaura.TextSize = 14.000
unequipaura.MouseButton1Click:Connect(function()
	local args = {
		[1] = auratekst.Text,
		[2] = "unequip"
	}

	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToggleEquip"):FireServer(unpack(args))
end)

nighttime.Name = "nighttime"
nighttime.Parent = freem
nighttime.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
nighttime.BackgroundTransparency = 1.000
nighttime.BorderColor3 = Color3.fromRGB(0, 0, 0)
nighttime.BorderSizePixel = 0
nighttime.Position = UDim2.new(0, 0, 0.384615391, 0)
nighttime.Size = UDim2.new(0, 244, 0, 25)
nighttime.Font = Enum.Font.SourceSansBold
nighttime.Text = "night time"
nighttime.TextColor3 = Color3.fromRGB(255, 255, 255)
nighttime.TextSize = 14.000
nighttime.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.AbilityEvents["Shadow Reign"]:FireServer()
end)

glitchspam.Name = "glitchspam"
glitchspam.Parent = freem
glitchspam.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glitchspam.BackgroundTransparency = 1.000
glitchspam.BorderColor3 = Color3.fromRGB(0, 0, 0)
glitchspam.BorderSizePixel = 0
glitchspam.Position = UDim2.new(0, 0, 0.497737557, 0)
glitchspam.Size = UDim2.new(0, 244, 0, 25)
glitchspam.Font = Enum.Font.SourceSansBold
glitchspam.Text = "spam glitch effect on server"
glitchspam.TextColor3 = Color3.fromRGB(255, 255, 255)
glitchspam.TextSize = 14.000
glitchspam.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.AbilityEvents["Distortion"]:FireServer()
end)

gettrail.Name = "gettrail"
gettrail.Parent = freem
gettrail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gettrail.BackgroundTransparency = 1.000
gettrail.BorderColor3 = Color3.fromRGB(0, 0, 0)
gettrail.BorderSizePixel = 0
gettrail.Position = UDim2.new(0, 0, 0.610859752, 0)
gettrail.Size = UDim2.new(0, 244, 0, 25)
gettrail.Font = Enum.Font.SourceSansBold
gettrail.Text = "get trail"
gettrail.TextColor3 = Color3.fromRGB(255, 255, 255)
gettrail.TextSize = 14.000
gettrail.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.AbilityEvents["God's Power"]:FireServer()
end)

lightning.Name = "lightning"
lightning.Parent = freem
lightning.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lightning.BackgroundTransparency = 1.000
lightning.BorderColor3 = Color3.fromRGB(0, 0, 0)
lightning.BorderSizePixel = 0
lightning.Position = UDim2.new(0, 0, 0.723981917, 0)
lightning.Size = UDim2.new(0, 244, 0, 25)
lightning.Font = Enum.Font.SourceSansBold
lightning.Text = "spawn lightning"
lightning.TextColor3 = Color3.fromRGB(255, 255, 255)
lightning.TextSize = 14.000
lightning.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.AbilityEvents["Zeus Lightning"]:FireServer()
end)

blinded.Name = "blinded"
blinded.Parent = freem
blinded.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
blinded.BackgroundTransparency = 1.000
blinded.BorderColor3 = Color3.fromRGB(0, 0, 0)
blinded.BorderSizePixel = 0
blinded.Position = UDim2.new(0, 0, 0.837104082, 0)
blinded.Size = UDim2.new(0, 244, 0, 25)
blinded.Font = Enum.Font.SourceSansBold
blinded.Text = "blinded"
blinded.TextColor3 = Color3.fromRGB(255, 255, 255)
blinded.TextSize = 14.000
blinded.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.AbilityEvents["Era of Light"]:FireServer()
end)
