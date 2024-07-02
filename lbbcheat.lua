local epiclucky = Instance.new("ScreenGui")
local fram = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local line = Instance.new("TextLabel")
local text = Instance.new("TextLabel")
local lucky = Instance.new("TextButton")
local super = Instance.new("TextButton")
local diamond = Instance.new("TextButton")
local rainbow = Instance.new("TextButton")
local galaxy = Instance.new("TextButton")

epiclucky.Name = "epiclucky"
epiclucky.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

fram.Name = "fram"
fram.Parent = epiclucky
fram.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
fram.BorderColor3 = Color3.fromRGB(0, 0, 0)
fram.BorderSizePixel = 0
fram.Position = UDim2.new(0.125967622, 0, 0.095238097, 0)
fram.Size = UDim2.new(0, 234, 0, 290)

UICorner.Parent = fram

line.Name = "line"
line.Parent = fram
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BorderColor3 = Color3.fromRGB(255, 255, 255)
line.BorderSizePixel = 0
line.Position = UDim2.new(0, 0, 0.168965518, 0)
line.Size = UDim2.new(0, 233, 0, 1)
line.Font = Enum.Font.SourceSans
line.Text = ""
line.TextColor3 = Color3.fromRGB(0, 0, 0)
line.TextSize = 14.000

text.Name = "text"
text.Parent = fram
text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
text.BackgroundTransparency = 1.000
text.BorderColor3 = Color3.fromRGB(0, 0, 0)
text.BorderSizePixel = 0
text.Position = UDim2.new(0.0726495758, 0, 0, 0)
text.Size = UDim2.new(0, 200, 0, 50)
text.Font = Enum.Font.SourceSansBold
text.Text = "lucky block battlegrounds (sigma)"
text.TextColor3 = Color3.fromRGB(255, 255, 255)
text.TextScaled = true
text.TextSize = 14.000
text.TextWrapped = true

lucky.Name = "lucky"
lucky.Parent = fram
lucky.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lucky.BackgroundTransparency = 1.000
lucky.BorderColor3 = Color3.fromRGB(0, 0, 0)
lucky.BorderSizePixel = 0
lucky.Position = UDim2.new(0, 0, 0.172413796, 0)
lucky.Size = UDim2.new(0, 233, 0, 48)
lucky.Font = Enum.Font.SourceSansBold
lucky.Text = "get lucky block"
lucky.TextColor3 = Color3.fromRGB(255, 255, 255)
lucky.TextScaled = true
lucky.TextSize = 14.000
lucky.TextWrapped = true
lucky.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("SpawnLuckyBlock"):FireServer()
end)

super.Name = "super"
super.Parent = fram
super.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
super.BackgroundTransparency = 1.000
super.BorderColor3 = Color3.fromRGB(0, 0, 0)
super.BorderSizePixel = 0
super.Position = UDim2.new(0, 0, 0.337931037, 0)
super.Size = UDim2.new(0, 233, 0, 48)
super.Font = Enum.Font.SourceSansBold
super.Text = "get super block"
super.TextColor3 = Color3.fromRGB(255, 255, 255)
super.TextScaled = true
super.TextSize = 14.000
super.TextWrapped = true
super.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("SpawnSuperBlock"):FireServer()
end)

diamond.Name = "diamond"
diamond.Parent = fram
diamond.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
diamond.BackgroundTransparency = 1.000
diamond.BorderColor3 = Color3.fromRGB(0, 0, 0)
diamond.BorderSizePixel = 0
diamond.Position = UDim2.new(0, 0, 0.503448248, 0)
diamond.Size = UDim2.new(0, 233, 0, 47)
diamond.Font = Enum.Font.SourceSansBold
diamond.Text = "get diamond block"
diamond.TextColor3 = Color3.fromRGB(255, 255, 255)
diamond.TextScaled = true
diamond.TextSize = 14.000
diamond.TextWrapped = true
diamond.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("SpawnDiamondBlock"):FireServer()
end)

rainbow.Name = "rainbow"
rainbow.Parent = fram
rainbow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
rainbow.BackgroundTransparency = 1.000
rainbow.BorderColor3 = Color3.fromRGB(0, 0, 0)
rainbow.BorderSizePixel = 0
rainbow.Position = UDim2.new(0, 0, 0.668965518, 0)
rainbow.Size = UDim2.new(0, 233, 0, 48)
rainbow.Font = Enum.Font.SourceSansBold
rainbow.Text = "get rainbow block"
rainbow.TextColor3 = Color3.fromRGB(255, 255, 255)
rainbow.TextScaled = true
rainbow.TextSize = 14.000
rainbow.TextWrapped = true
rainbow.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("SpawnRainbowBlock"):FireServer()
end)

galaxy.Name = "galaxy"
galaxy.Parent = fram
galaxy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
galaxy.BackgroundTransparency = 1.000
galaxy.BorderColor3 = Color3.fromRGB(0, 0, 0)
galaxy.BorderSizePixel = 0
galaxy.Position = UDim2.new(0, 0, 0.834482729, 0)
galaxy.Size = UDim2.new(0, 233, 0, 48)
galaxy.Font = Enum.Font.SourceSansBold
galaxy.Text = "get galaxy block"
galaxy.TextColor3 = Color3.fromRGB(255, 255, 255)
galaxy.TextScaled = true
galaxy.TextSize = 14.000
galaxy.TextWrapped = true
galaxy.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("SpawnGalaxyBlock"):FireServer()
end)
