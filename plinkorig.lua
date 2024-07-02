local plinkoepich4x = Instance.new("ScreenGui")
local fram = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local labl = Instance.new("TextLabel")
local moni = Instance.new("TextBox")
local bestwin = Instance.new("TextBox")
local monibtn = Instance.new("TextButton")
local bestwinbtn = Instance.new("TextButton")

plinkoepich4x.Name = "plinkoepich4x"
plinkoepich4x.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

fram.Name = "fram"
fram.Parent = plinkoepich4x
fram.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fram.BorderColor3 = Color3.fromRGB(0, 0, 0)
fram.BorderSizePixel = 0
fram.Position = UDim2.new(0.0999296233, 0, 0.127819553, 0)
fram.Size = UDim2.new(0, 273, 0, 102)

UICorner.Parent = fram

labl.Name = "labl"
labl.Parent = fram
labl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
labl.BackgroundTransparency = 1.000
labl.BorderColor3 = Color3.fromRGB(0, 0, 0)
labl.BorderSizePixel = 0
labl.Size = UDim2.new(0, 273, 0, 28)
labl.Font = Enum.Font.SourceSansBold
labl.Text = "rig plinko (sigma)"
labl.TextColor3 = Color3.fromRGB(255, 255, 255)
labl.TextScaled = true
labl.TextSize = 14.000
labl.TextWrapped = true

moni.Name = "moni"
moni.Parent = fram
moni.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
moni.BackgroundTransparency = 1.000
moni.BorderColor3 = Color3.fromRGB(0, 0, 0)
moni.BorderSizePixel = 0
moni.Position = UDim2.new(0, 0, 0.359641731, 0)
moni.Size = UDim2.new(0, 125, 0, 26)
moni.Font = Enum.Font.SourceSansBold
moni.PlaceholderText = "input number (MAX 1Q)"
moni.Text = ""
moni.TextColor3 = Color3.fromRGB(255, 255, 255)
moni.TextScaled = true
moni.TextSize = 14.000
moni.TextWrapped = true

bestwin.Name = "bestwin"
bestwin.Parent = fram
bestwin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bestwin.BackgroundTransparency = 1.000
bestwin.BorderColor3 = Color3.fromRGB(0, 0, 0)
bestwin.BorderSizePixel = 0
bestwin.Position = UDim2.new(0.542124569, 0, 0.359641731, 0)
bestwin.Size = UDim2.new(0, 125, 0, 26)
bestwin.Font = Enum.Font.SourceSansBold
bestwin.PlaceholderText = "input number (MAX 1Q)"
bestwin.Text = ""
bestwin.TextColor3 = Color3.fromRGB(255, 255, 255)
bestwin.TextScaled = true
bestwin.TextSize = 14.000
bestwin.TextWrapped = true

monibtn.Name = "monibtn"
monibtn.Parent = fram
monibtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
monibtn.BackgroundTransparency = 1.000
monibtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
monibtn.BorderSizePixel = 0
monibtn.Position = UDim2.new(0, 0, 0.704894841, 0)
monibtn.Size = UDim2.new(0, 125, 0, 30)
monibtn.Font = Enum.Font.SourceSansBold
monibtn.Text = "giv me money"
monibtn.TextColor3 = Color3.fromRGB(255, 255, 255)
monibtn.TextScaled = true
monibtn.TextSize = 14.000
monibtn.TextWrapped = true
monibtn.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("CashTransfer1"):FireServer(tonumber(moni.Text), "Cash")
end)

bestwinbtn.Name = "bestwinbtn"
bestwinbtn.Parent = fram
bestwinbtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bestwinbtn.BackgroundTransparency = 1.000
bestwinbtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
bestwinbtn.BorderSizePixel = 0
bestwinbtn.Position = UDim2.new(0.542124569, 0, 0.704894841, 0)
bestwinbtn.Size = UDim2.new(0, 125, 0, 30)
bestwinbtn.Font = Enum.Font.SourceSansBold
bestwinbtn.Text = "set me best win"
bestwinbtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bestwinbtn.TextScaled = true
bestwinbtn.TextSize = 14.000
bestwinbtn.TextWrapped = true
bestwinbtn.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("CashTransfer1"):FireServer(tonumber(bestwin.Text), "BestWin")
end)
