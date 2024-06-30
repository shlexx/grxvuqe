local epicscren = Instance.new("ScreenGui")
local fram = Instance.new("Frame")
local monilebel = Instance.new("TextLabel")
local moninum = Instance.new("TextBox")
local monegiv = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

epicscren.Name = "epicscren"
epicscren.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

fram.Name = "fram"
fram.Parent = epicscren
fram.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fram.BorderColor3 = Color3.fromRGB(0, 0, 0)
fram.BorderSizePixel = 0
fram.Position = UDim2.new(0.182969734, 0, 0.17418547, 0)
fram.Size = UDim2.new(0, 198, 0, 125)

monilebel.Name = "monilebel"
monilebel.Parent = fram
monilebel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
monilebel.BackgroundTransparency = 1.000
monilebel.BorderColor3 = Color3.fromRGB(0, 0, 0)
monilebel.BorderSizePixel = 0
monilebel.Size = UDim2.new(0, 200, 0, 31)
monilebel.Font = Enum.Font.SourceSansBold
monilebel.Text = "moni generator!!!"
monilebel.TextColor3 = Color3.fromRGB(255, 255, 255)
monilebel.TextScaled = true
monilebel.TextSize = 14.000
monilebel.TextWrapped = true

moninum.Name = "moninum"
moninum.Parent = fram
moninum.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
moninum.BackgroundTransparency = 1.000
moninum.BorderColor3 = Color3.fromRGB(0, 0, 0)
moninum.BorderSizePixel = 0
moninum.Position = UDim2.new(0, 0, 0.375999987, 0)
moninum.Size = UDim2.new(0, 200, 0, 30)
moninum.ClearTextOnFocus = false
moninum.Font = Enum.Font.SourceSansBold
moninum.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
moninum.PlaceholderText = "enter number"
moninum.Text = ""
moninum.TextColor3 = Color3.fromRGB(255, 255, 255)
moninum.TextScaled = true
moninum.TextSize = 14.000
moninum.TextWrapped = true

monegiv.Name = "monegiv"
monegiv.Parent = fram
monegiv.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
monegiv.BackgroundTransparency = 1.000
monegiv.BorderColor3 = Color3.fromRGB(0, 0, 0)
monegiv.BorderSizePixel = 0
monegiv.Position = UDim2.new(-0.0101010101, 0, 0.600000024, 0)
monegiv.Size = UDim2.new(0, 200, 0, 50)
monegiv.Font = Enum.Font.SourceSansBold
monegiv.Text = "giv money"
monegiv.TextColor3 = Color3.fromRGB(255, 255, 255)
monegiv.TextScaled = true
monegiv.TextSize = 14.000
monegiv.TextWrapped = true
monegiv.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("fewjnfejwb3"):FireServer(moninum.Text)
end)

UICorner.Parent = fram
