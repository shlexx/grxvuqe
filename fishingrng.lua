local epicguii = Instance.new("ScreenGui")
local fram = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local lebel = Instance.new("TextLabel")
local lin = Instance.new("TextLabel")
local getfihsbuton = Instance.new("TextButton")
local fihstekest = Instance.new("TextBox")

epicguii.Name = "epicguii"
epicguii.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

fram.Name = "fram"
fram.Parent = epicguii
fram.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
fram.BorderColor3 = Color3.fromRGB(0, 0, 0)
fram.BorderSizePixel = 0
fram.Position = UDim2.new(0.144968316, 0, 0.0513784476, 0)
fram.Size = UDim2.new(0, 129, 0, 111)

UICorner.Parent = fram

lebel.Name = "lebel"
lebel.Parent = fram
lebel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lebel.BackgroundTransparency = 1.000
lebel.BorderColor3 = Color3.fromRGB(0, 0, 0)
lebel.BorderSizePixel = 0
lebel.Size = UDim2.new(0, 128, 0, 20)
lebel.Font = Enum.Font.SourceSansBold
lebel.Text = "fishing rng gui o_0"
lebel.TextColor3 = Color3.fromRGB(255, 255, 255)
lebel.TextSize = 14.000

lin.Name = "lin"
lin.Parent = fram
lin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lin.BorderColor3 = Color3.fromRGB(0, 0, 0)
lin.BorderSizePixel = 0
lin.Position = UDim2.new(0, 0, 0.171554253, 0)
lin.Size = UDim2.new(0, 128, 0, 1)
lin.Font = Enum.Font.SourceSans
lin.Text = ""
lin.TextColor3 = Color3.fromRGB(0, 0, 0)
lin.TextSize = 14.000

fihstekest.Name = "fihstekest"
fihstekest.Parent = fram
fihstekest.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fihstekest.BackgroundTransparency = 1.000
fihstekest.BorderColor3 = Color3.fromRGB(0, 0, 0)
fihstekest.BorderSizePixel = 0
fihstekest.Position = UDim2.new(0, 0, 0.279279292, 0)
fihstekest.Size = UDim2.new(0, 128, 0, 40)
fihstekest.Font = Enum.Font.SourceSansBold
fihstekest.PlaceholderText = "enter fish name here"
fihstekest.Text = ""
fihstekest.TextColor3 = Color3.fromRGB(255, 255, 255)
fihstekest.TextScaled = true
fihstekest.TextSize = 14.000
fihstekest.TextWrapped = true

getfihsbuton.Name = "getfihsbuton"
getfihsbuton.Parent = fram
getfihsbuton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
getfihsbuton.BackgroundTransparency = 1.000
getfihsbuton.BorderColor3 = Color3.fromRGB(0, 0, 0)
getfihsbuton.BorderSizePixel = 0
getfihsbuton.Position = UDim2.new(0, 0, 0.639639616, 0)
getfihsbuton.Size = UDim2.new(0, 128, 0, 40)
getfihsbuton.Font = Enum.Font.SourceSansBold
getfihsbuton.Text = "get fish"
getfihsbuton.TextColor3 = Color3.fromRGB(255, 255, 255)
getfihsbuton.TextScaled = true
getfihsbuton.TextSize = 14.000
getfihsbuton.TextWrapped = true
getfihsbuton.MouseButton1Click:Connect(function()
	local plrname = game.Players.LocalPlayer:GetFullName()
	local fishname = fihstekest.Text
	function getNil(name,class) for _,v in next, getnilinstances() do if v.ClassName==class and v.Name==name then return v;end end end

	local args = {
		[1] = {
			[fishname] = 1
		},
		[2] = {
			[1] = getNil("Part", "Part"),
			[2] = getNil("Fish", "Part"),
			[3] = workspace:WaitForChild("Part"),
			[4] = getNil(plrname .. "_Lure", "Part")
		}
	}

	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Fishing"):WaitForChild("ClaimFish"):FireServer(unpack(args))
end)
