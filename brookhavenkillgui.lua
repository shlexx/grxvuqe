local epikkil = Instance.new("ScreenGui")
local frem = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local leble = Instance.new("TextLabel")
local UICorner2 = Instance.new("UICorner")
local kilebutone = Instance.new("TextButton")

epikkil.Name = "epikkil"
epikkil.ResetOnSpawn = false
epikkil.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

frem.Name = "frem"
frem.Parent = epikkil
frem.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
frem.BorderColor3 = Color3.fromRGB(0, 0, 0)
frem.BorderSizePixel = 0
frem.Position = UDim2.new(0.0894996449, 0, 0.0263157897, 0)
frem.Size = UDim2.new(0, 184, 0, 101)

UICorner.Parent = frem

leble.Name = "leble"
leble.Parent = frem
leble.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
leble.BorderColor3 = Color3.fromRGB(0, 0, 0)
leble.BorderSizePixel = 0
leble.Position = UDim2.new(0.081521742, 0, 0.0792079195, 0)
leble.Size = UDim2.new(0, 153, 0, 30)
leble.Font = Enum.Font.SourceSansBold
leble.Text = "brookhaven kill gui o_0 (must have player in a cart or smth)"
leble.TextColor3 = Color3.fromRGB(255, 255, 255)
leble.TextScaled = true
leble.TextSize = 14.000
leble.TextWrapped = true

UICorner2.Name = "UICorner2"
UICorner2.Parent = leble

kilebutone.Name = "kilebutone"
kilebutone.Parent = frem
kilebutone.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
kilebutone.BorderColor3 = Color3.fromRGB(0, 0, 0)
kilebutone.BorderSizePixel = 0
kilebutone.Position = UDim2.new(0.081521742, 0, 0.603960395, 0)
kilebutone.Size = UDim2.new(0, 153, 0, 30)
kilebutone.Font = Enum.Font.SourceSansBold
kilebutone.Text = "kill"
kilebutone.TextColor3 = Color3.fromRGB(255, 255, 255)
kilebutone.TextSize = 14.000
kilebutone.MouseButton1Click:Connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -400, 0)
end)
