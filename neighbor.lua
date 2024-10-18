--[[
https://www.roblox.com/games/16069451109/Hello-Neighbor-Forsaken
https://www.roblox.com/games/15726741427/Hello-Neighbor-Diablo-s-Circus-Halloween-Update
https://www.roblox.com/games/16218670884/Hello-Neighbor-Lost-To-Serpent-XBOX-Support
https://www.roblox.com/games/17211494376/Hello-Neighbor-for-Modders-Early-Access
https://www.roblox.com/games/16948519258/Hello-Neighbor-Pre-Alpha-2-Old
--]]

local _main = game.ReplicatedStorage.Menyu
local Trolling = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local name = Instance.new("TextLabel")
local bringall = Instance.new("TextButton")
local bringn = Instance.new("TextButton")
local bringp = Instance.new("TextButton")
local player = Instance.new("TextBox")
local btools = Instance.new("TextButton")
local http = Instance.new("TextButton")
local waypoint = Instance.new("TextButton")
local highlight = Instance.new("TextButton")
local player2 = Instance.new("TextBox")
local badge = Instance.new("TextBox")
local apply = Instance.new("TextButton")

Trolling.Name = "Trolling"
Trolling.Parent = game.CoreGui.RobloxGui

main.Name = "main"
main.Parent = Trolling
main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
main.BorderColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.353756368, 0, 0.374371856, 0)
main.Size = UDim2.new(0, 400, 0, 200)

name.Name = "name"
name.Parent = main
name.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
name.BorderColor3 = Color3.fromRGB(0, 0, 0)
name.BorderSizePixel = 0
name.Size = UDim2.new(0, 400, 0, 20)
name.Font = Enum.Font.Code
name.Text = "  trolling!! >:)                        {by LOUDAUDlOS}"
name.TextColor3 = Color3.fromRGB(255, 255, 255)
name.TextSize = 14.000
name.TextXAlignment = Enum.TextXAlignment.Left

bringall.Name = "bringall"
bringall.Parent = main
bringall.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
bringall.BorderColor3 = Color3.fromRGB(0, 0, 0)
bringall.BorderSizePixel = 0
bringall.Position = UDim2.new(0.0250000004, 0, 0.150000006, 0)
bringall.Size = UDim2.new(0, 185, 0, 25)
bringall.Font = Enum.Font.Code
bringall.Text = "bring everyone"
bringall.TextColor3 = Color3.fromRGB(255, 255, 255)
bringall.TextSize = 14.000

bringn.Name = "bringn"
bringn.Parent = main
bringn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
bringn.BorderColor3 = Color3.fromRGB(0, 0, 0)
bringn.BorderSizePixel = 0
bringn.Position = UDim2.new(0.0250000004, 0, 0.324999988, 0)
bringn.Size = UDim2.new(0, 185, 0, 25)
bringn.Font = Enum.Font.Code
bringn.Text = "bring neighbor"
bringn.TextColor3 = Color3.fromRGB(255, 255, 255)
bringn.TextSize = 14.000

bringp.Name = "bringp"
bringp.Parent = main
bringp.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
bringp.BorderColor3 = Color3.fromRGB(0, 0, 0)
bringp.BorderSizePixel = 0
bringp.Position = UDim2.new(0.512499988, 0, 0.324999988, 0)
bringp.Size = UDim2.new(0, 185, 0, 25)
bringp.Font = Enum.Font.Code
bringp.Text = "bring player"
bringp.TextColor3 = Color3.fromRGB(255, 255, 255)
bringp.TextSize = 14.000

player.Name = "player"
player.Parent = main
player.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
player.BorderColor3 = Color3.fromRGB(0, 0, 0)
player.BorderSizePixel = 0
player.Position = UDim2.new(0.512499988, 0, 0.150000006, 0)
player.Size = UDim2.new(0, 185, 0, 25)
player.Font = Enum.Font.Code
player.PlaceholderText = "player name here"
player.Text = ""
player.TextColor3 = Color3.fromRGB(0, 0, 0)
player.TextSize = 14.000

btools.Name = "btools"
btools.Parent = main
btools.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
btools.BorderColor3 = Color3.fromRGB(0, 0, 0)
btools.BorderSizePixel = 0
btools.Position = UDim2.new(0.0250000004, 0, 0.5, 0)
btools.Size = UDim2.new(0, 185, 0, 25)
btools.Font = Enum.Font.Code
btools.Text = "btools (1 to equip)"
btools.TextColor3 = Color3.fromRGB(255, 255, 255)
btools.TextSize = 14.000

http.Name = "http"
http.Parent = main
http.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
http.BorderColor3 = Color3.fromRGB(0, 0, 0)
http.BorderSizePixel = 0
http.Position = UDim2.new(0.512499988, 0, 0.5, 0)
http.Size = UDim2.new(0, 185, 0, 25)
http.Font = Enum.Font.Code
http.Text = "remove http popup"
http.TextColor3 = Color3.fromRGB(255, 255, 255)
http.TextSize = 14.000

waypoint.Name = "waypoint"
waypoint.Parent = main
waypoint.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
waypoint.BorderColor3 = Color3.fromRGB(0, 0, 0)
waypoint.BorderSizePixel = 0
waypoint.Position = UDim2.new(0.0250000004, 0, 0.675000012, 0)
waypoint.Size = UDim2.new(0, 185, 0, 25)
waypoint.Font = Enum.Font.Code
waypoint.Text = "waypoint"
waypoint.TextColor3 = Color3.fromRGB(255, 255, 255)
waypoint.TextSize = 14.000

highlight.Name = "highlight"
highlight.Parent = main
highlight.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
highlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
highlight.BorderSizePixel = 0
highlight.Position = UDim2.new(0.0250000004, 0, 0.845000029, 0)
highlight.Size = UDim2.new(0, 185, 0, 25)
highlight.Font = Enum.Font.Code
highlight.Text = "highlight"
highlight.TextColor3 = Color3.fromRGB(255, 255, 255)
highlight.TextSize = 14.000

player2.Name = "player2"
player2.Parent = main
player2.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
player2.BorderColor3 = Color3.fromRGB(0, 0, 0)
player2.BorderSizePixel = 0
player2.Position = UDim2.new(0.512499988, 0, 0.675000012, 0)
player2.Size = UDim2.new(0, 90, 0, 25)
player2.Font = Enum.Font.Code
player2.PlaceholderText = "player"
player2.Text = ""
player2.TextColor3 = Color3.fromRGB(0, 0, 0)
player2.TextSize = 14.000

badge.Name = "badge"
badge.Parent = main
badge.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
badge.BorderColor3 = Color3.fromRGB(0, 0, 0)
badge.BorderSizePixel = 0
badge.Position = UDim2.new(0.75, 0, 0.675000012, 0)
badge.Size = UDim2.new(0, 90, 0, 25)
badge.Font = Enum.Font.Code
badge.PlaceholderText = "badge id"
badge.Text = ""
badge.TextColor3 = Color3.fromRGB(0, 0, 0)
badge.TextSize = 14.000

apply.Name = "apply"
apply.Parent = main
apply.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
apply.BorderColor3 = Color3.fromRGB(0, 0, 0)
apply.BorderSizePixel = 0
apply.Position = UDim2.new(0.512499988, 0, 0.845000029, 0)
apply.Size = UDim2.new(0, 185, 0, 25)
apply.Font = Enum.Font.Code
apply.Text = "get badge"
apply.TextColor3 = Color3.fromRGB(255, 255, 255)
apply.TextSize = 14.000

local UIS = game:GetService("UserInputService")
local function dragify(Frame,boool)
	local frametomove = Frame
	local dragToggle,dragInput,dragStart,startPos
	local dragSpeed = 0
	local function updateInput(input)
		local Delta = input.Position - dragStart
		frametomove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
	end
	Frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = frametomove.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)	
		end
	end)
	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			updateInput(input)
		end
	end)
end
dragify(main)

bringall.MouseButton1Click:Connect(function()
	_main.TP.All:FireServer()
end)

bringn.MouseButton1Click:Connect(function()
	_main.TP.TpN:FireServer()
end)

bringp.MouseButton1Click:Connect(function()
	_main.TP.One:FireServer(player.Text)
end)

btools.MouseButton1Click:Connect(function()
	_main.BTools:FireServer()
end)

http.MouseButton1Click:Connect(function()
	game.Players.LocalPlayer.PlayerGui["Building Tools by F3X (UI)"].Notifications.Container.HTTPEnabledNotification.Visible = false
end)

waypoint.MouseButton1Click:Connect(function()
	_main.WayPoint:FireServer()
end)

highlight.MouseButton1Click:Connect(function()
	_main.Highlight:FireServer()
end)

apply.MouseButton1Click:Connect(function()
	_main.Badge:FireServer(player2.Text,badge.Text)
end)
