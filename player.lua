local ap = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local name = Instance.new("TextLabel")
local play = Instance.new("TextButton")
local stop = Instance.new("TextButton")
local input = Instance.new("TextBox")

ap.Name = ".ap"
ap.Parent = game.CoreGui.RobloxGui

main.Name = "main"
main.Parent = ap
main.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
main.BorderColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.427325577, 0, 0.437185943, 0)
main.Size = UDim2.new(0, 200, 0, 100)

name.Name = "name"
name.Parent = main
name.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
name.BorderColor3 = Color3.fromRGB(0, 0, 0)
name.BorderSizePixel = 0
name.Size = UDim2.new(0, 200, 0, 20)
name.Font = Enum.Font.Code
name.Text = " smol animation player"
name.TextColor3 = Color3.fromRGB(255, 255, 255)
name.TextSize = 14.000
name.TextXAlignment = Enum.TextXAlignment.Left

play.Name = "play"
play.Parent = main
play.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
play.BorderColor3 = Color3.fromRGB(0, 0, 0)
play.BorderSizePixel = 0
play.Position = UDim2.new(0.0500000007, 0, 0.600000024, 0)
play.Size = UDim2.new(0, 80, 0, 30)
play.Font = Enum.Font.Code
play.Text = "play"
play.TextColor3 = Color3.fromRGB(255, 255, 255)
play.TextSize = 24.000
play.TextWrapped = true

stop.Name = "stop"
stop.Parent = main
stop.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
stop.BorderColor3 = Color3.fromRGB(0, 0, 0)
stop.BorderSizePixel = 0
stop.Position = UDim2.new(0.550000012, 0, 0.300000012, 0)
stop.Size = UDim2.new(0, 80, 0, 60)
stop.Font = Enum.Font.Code
stop.Text = "stop all anims"
stop.TextColor3 = Color3.fromRGB(255, 255, 255)
stop.TextSize = 18.000
stop.TextWrapped = true

input.Name = "input"
input.Parent = main
input.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
input.BorderColor3 = Color3.fromRGB(0, 0, 0)
input.BorderSizePixel = 0
input.Position = UDim2.new(0.0500000007, 0, 0.300000012, 0)
input.Size = UDim2.new(0, 80, 0, 25)
input.ClearTextOnFocus = false
input.Font = Enum.Font.Code
input.PlaceholderText = "id"
input.Text = ""
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.TextSize = 12.000

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

play.MouseButton1Click:Connect(function()
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. input.Text
	local play = humanoid:LoadAnimation(anim)
	play:Play()
end)

stop.MouseButton1Click:Connect(function()
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or game.Players.LocalPlayer.Character:FindFirstChildOfClass("AnimationController")
	for i,v in next, humanoid:GetPlayingAnimationTracks() do
		v:Stop()
	end
end)
