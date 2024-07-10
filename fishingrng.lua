local epicguii = Instance.new("ScreenGui")
local frem = Instance.new("Frame")
local lebel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local lien = Instance.new("TextLabel")
local fishnametxt = Instance.new("TextBox")
local numtxt = Instance.new("TextBox")
local getfishbtn = Instance.new("TextButton")

epicguii.Name = "epicguii"
epicguii.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

frem.Name = "frem"
frem.Parent = epicguii
frem.BackgroundColor3 = Color3.fromRGB(69, 69, 69)
frem.BorderColor3 = Color3.fromRGB(0, 0, 0)
frem.BorderSizePixel = 0
frem.Position = UDim2.new(0.140239611, 0, 0.0526315793, 0)
frem.Size = UDim2.new(0, 172, 0, 80)

lebel.Name = "lebel"
lebel.Parent = frem
lebel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lebel.BackgroundTransparency = 1.000
lebel.BorderColor3 = Color3.fromRGB(0, 0, 0)
lebel.BorderSizePixel = 0
lebel.Size = UDim2.new(0, 172, 0, 20)
lebel.Font = Enum.Font.SourceSansBold
lebel.Text = "fishing rng gui o_0"
lebel.TextColor3 = Color3.fromRGB(255, 255, 255)
lebel.TextSize = 14.000

UICorner.Parent = frem

lien.Name = "lien"
lien.Parent = frem
lien.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lien.BorderColor3 = Color3.fromRGB(0, 0, 0)
lien.BorderSizePixel = 0
lien.Position = UDim2.new(0, 0, 0.262499988, 0)
lien.Size = UDim2.new(0, 172, 0, -1)
lien.Font = Enum.Font.SourceSans
lien.Text = ""
lien.TextColor3 = Color3.fromRGB(0, 0, 0)
lien.TextSize = 14.000

fishnametxt.Name = "fishnametxt"
fishnametxt.Parent = frem
fishnametxt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fishnametxt.BackgroundTransparency = 1.000
fishnametxt.BorderColor3 = Color3.fromRGB(0, 0, 0)
fishnametxt.BorderSizePixel = 0
fishnametxt.Position = UDim2.new(0, 0, 0.262499988, 0)
fishnametxt.Size = UDim2.new(0, 86, 0, 30)
fishnametxt.Font = Enum.Font.SourceSansBold
fishnametxt.PlaceholderText = "enter fish name here"
fishnametxt.Text = ""
fishnametxt.TextColor3 = Color3.fromRGB(255, 255, 255)
fishnametxt.TextScaled = true
fishnametxt.TextSize = 14.000
fishnametxt.TextWrapped = true

numtxt.Name = "numtxt"
numtxt.Parent = frem
numtxt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
numtxt.BackgroundTransparency = 1.000
numtxt.BorderColor3 = Color3.fromRGB(0, 0, 0)
numtxt.BorderSizePixel = 0
numtxt.Position = UDim2.new(0.5, 0, 0.262499988, 0)
numtxt.Size = UDim2.new(0, 86, 0, 30)
numtxt.Font = Enum.Font.SourceSansBold
numtxt.PlaceholderText = "enter number here"
numtxt.Text = ""
numtxt.TextColor3 = Color3.fromRGB(255, 255, 255)
numtxt.TextScaled = true
numtxt.TextSize = 14.000
numtxt.TextWrapped = true

getfishbtn.Name = "getfishbtn"
getfishbtn.Parent = frem
getfishbtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
getfishbtn.BackgroundTransparency = 1.000
getfishbtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
getfishbtn.BorderSizePixel = 0
getfishbtn.Position = UDim2.new(0, 0, 0.6875, 0)
getfishbtn.Size = UDim2.new(0, 172, 0, 25)
getfishbtn.Font = Enum.Font.SourceSansBold
getfishbtn.Text = "get fish(es)"
getfishbtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getfishbtn.TextScaled = true
getfishbtn.TextSize = 14.000
getfishbtn.TextWrapped = true
getfishbtn.MouseButton1Click:Connect(function()
	local plrname = game.Players.LocalPlayer:GetFullName()
	local fishname = fishnametxt.Text
	local num = numtxt.Text
	function getNil(name,class) for _,v in next, getnilinstances() do if v.ClassName==class and v.Name==name then return v;end end end

	local args = {
		[1] = {
			[fishname] = tonumber(num)
		},
		[2] = {
			[1] = getNil(plrname .. "_Lure", "Part"),
			[2] = workspace:WaitForChild("Part"),
			[3] = workspace:WaitForChild("Maps"):WaitForChild("The Pond"):WaitForChild("Assets"):WaitForChild("Model"):WaitForChild("Model"):WaitForChild("Part"),
			[4] = getNil("Part", "Part"),
			[5] = getNil("Fish", "Part")
		}
	}

	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Fishing"):WaitForChild("ClaimFish"):FireServer(unpack(args))
end)
