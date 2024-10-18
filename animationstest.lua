local humanoid = game.Players.LocalPlayer.Character.Humanoid
local Animations = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local name = Instance.new("TextLabel")
local play = Instance.new("TextButton")
local stop = Instance.new("TextButton")
local pr = Instance.new("TextBox")
local speedplay = Instance.new("TextBox")
local weightplay = Instance.new("TextBox")
local fadetimeplay = Instance.new("TextBox")
local line = Instance.new("TextLabel")
local fadetimestop = Instance.new("TextBox")
local _stop = Instance.new("TextBox")
local pause = Instance.new("TextButton")
local resume = Instance.new("TextButton")
local _play = Instance.new("TextBox")

Animations.Name = "Animations"
Animations.Parent = game.CoreGui.RobloxGui

main.Name = "main"
main.Parent = Animations
main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
main.BorderColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.353756368, 0, 0.326633155, 0)
main.Size = UDim2.new(0, 400, 0, 200)

name.Name = "name"
name.Parent = main
name.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
name.BorderColor3 = Color3.fromRGB(0, 0, 0)
name.BorderSizePixel = 0
name.Size = UDim2.new(0, 400, 0, 20)
name.Font = Enum.Font.Code
name.Text = "  animations                                {LOUDAUDlOS}"
name.TextColor3 = Color3.fromRGB(255, 255, 255)
name.TextSize = 14.000
name.TextXAlignment = Enum.TextXAlignment.Left

play.Name = "play"
play.Parent = main
play.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
play.BorderColor3 = Color3.fromRGB(0, 0, 0)
play.BorderSizePixel = 0
play.Position = UDim2.new(0.0250000004, 0, 0.800000012, 0)
play.Size = UDim2.new(0, 185, 0, 30)
play.Font = Enum.Font.Code
play.Text = "play animation"
play.TextColor3 = Color3.fromRGB(255, 255, 255)
play.TextSize = 14.000

stop.Name = "stop"
stop.Parent = main
stop.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
stop.BorderColor3 = Color3.fromRGB(0, 0, 0)
stop.BorderSizePixel = 0
stop.Position = UDim2.new(0.512499988, 0, 0.800000012, 0)
stop.Size = UDim2.new(0, 185, 0, 30)
stop.Font = Enum.Font.Code
stop.Text = "stop animation"
stop.TextColor3 = Color3.fromRGB(255, 255, 255)
stop.TextSize = 14.000

pr.Name = "pr"
pr.Parent = main
pr.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
pr.BorderColor3 = Color3.fromRGB(0, 0, 0)
pr.BorderSizePixel = 0
pr.Position = UDim2.new(0.512499988, 0, 0.200000003, 0)
pr.Size = UDim2.new(0, 185, 0, 20)
pr.Font = Enum.Font.Code
pr.PlaceholderText = "input animation id"
pr.Text = ""
pr.TextColor3 = Color3.fromRGB(255, 255, 255)
pr.TextSize = 14.000

speedplay.Name = "speedplay"
speedplay.Parent = main
speedplay.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
speedplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
speedplay.BorderSizePixel = 0
speedplay.Position = UDim2.new(0.0250000004, 0, 0.5, 0)
speedplay.Size = UDim2.new(0, 185, 0, 20)
speedplay.Font = Enum.Font.Code
speedplay.PlaceholderText = "speed (blank: 1)"
speedplay.Text = ""
speedplay.TextColor3 = Color3.fromRGB(255, 255, 255)
speedplay.TextSize = 14.000

weightplay.Name = "weightplay"
weightplay.Parent = main
weightplay.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
weightplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
weightplay.BorderSizePixel = 0
weightplay.Position = UDim2.new(0.0250000004, 0, 0.349999994, 0)
weightplay.Size = UDim2.new(0, 185, 0, 20)
weightplay.Font = Enum.Font.Code
weightplay.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
weightplay.PlaceholderText = "weight (blank: 1)"
weightplay.Text = ""
weightplay.TextColor3 = Color3.fromRGB(255, 255, 255)
weightplay.TextSize = 14.000

fadetimeplay.Name = "fadetimeplay"
fadetimeplay.Parent = main
fadetimeplay.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
fadetimeplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
fadetimeplay.BorderSizePixel = 0
fadetimeplay.Position = UDim2.new(0.0250000004, 0, 0.200000003, 0)
fadetimeplay.Size = UDim2.new(0, 185, 0, 20)
fadetimeplay.Font = Enum.Font.Code
fadetimeplay.PlaceholderText = "fadetime (blank: 0)"
fadetimeplay.Text = ""
fadetimeplay.TextColor3 = Color3.fromRGB(255, 255, 255)
fadetimeplay.TextSize = 14.000

line.Name = "line"
line.Parent = main
line.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
line.BorderColor3 = Color3.fromRGB(0, 0, 0)
line.BorderSizePixel = 0
line.Position = UDim2.new(0.0250000004, 0, 0.125, 0)
line.Size = UDim2.new(0, 380, 0, 10)
line.Font = Enum.Font.SourceSans
line.Text = ""
line.TextColor3 = Color3.fromRGB(0, 0, 0)
line.TextSize = 14.000

fadetimestop.Name = "fadetimestop"
fadetimestop.Parent = main
fadetimestop.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
fadetimestop.BorderColor3 = Color3.fromRGB(0, 0, 0)
fadetimestop.BorderSizePixel = 0
fadetimestop.Position = UDim2.new(0.512499988, 0, 0.5, 0)
fadetimestop.Size = UDim2.new(0, 185, 0, 20)
fadetimestop.Font = Enum.Font.Code
fadetimestop.PlaceholderText = "fadetime (blank: 0)"
fadetimestop.Text = ""
fadetimestop.TextColor3 = Color3.fromRGB(255, 255, 255)
fadetimestop.TextSize = 14.000

_stop.Name = "_stop"
_stop.Parent = main
_stop.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
_stop.BorderColor3 = Color3.fromRGB(0, 0, 0)
_stop.BorderSizePixel = 0
_stop.Position = UDim2.new(0.512499988, 0, 0.649999976, 0)
_stop.Size = UDim2.new(0, 185, 0, 20)
_stop.Font = Enum.Font.Code
_stop.PlaceholderText = "input animation id"
_stop.Text = ""
_stop.TextColor3 = Color3.fromRGB(255, 255, 255)
_stop.TextSize = 14.000

pause.Name = "pause"
pause.Parent = main
pause.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
pause.BorderColor3 = Color3.fromRGB(0, 0, 0)
pause.BorderSizePixel = 0
pause.Position = UDim2.new(0.512499988, 0, 0.349999994, 0)
pause.Size = UDim2.new(0, 85, 0, 20)
pause.Font = Enum.Font.Code
pause.Text = "pause"
pause.TextColor3 = Color3.fromRGB(255, 255, 255)
pause.TextSize = 14.000

resume.Name = "resume"
resume.Parent = main
resume.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
resume.BorderColor3 = Color3.fromRGB(0, 0, 0)
resume.BorderSizePixel = 0
resume.Position = UDim2.new(0.762499988, 0, 0.349999994, 0)
resume.Size = UDim2.new(0, 85, 0, 20)
resume.Font = Enum.Font.Code
resume.Text = "resume"
resume.TextColor3 = Color3.fromRGB(255, 255, 255)
resume.TextSize = 14.000

_play.Name = "_play"
_play.Parent = main
_play.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
_play.BorderColor3 = Color3.fromRGB(0, 0, 0)
_play.BorderSizePixel = 0
_play.Position = UDim2.new(0.0250000004, 0, 0.649999976, 0)
_play.Size = UDim2.new(0, 185, 0, 20)
_play.Font = Enum.Font.Code
_play.PlaceholderText = "input animation id"
_play.Text = ""
_play.TextColor3 = Color3.fromRGB(255, 255, 255)
_play.TextSize = 14.000

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
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. _play.Text
	local playAnim = humanoid:LoadAnimation(anim)
	playAnim:Play(tonumber(fadetimeplay.Text),tonumber(weightplay.Text),tonumber(speedplay.Text))
end)

stop.MouseButton1Click:Connect(function()
	for _,v in pairs(humanoid:GetPlayingAnimationTracks()) do
		if v.Animation.AnimationId == tonumber(_stop.Text) then
			v:Stop(tonumber(fadetimestop.Text))
		end
	end
end)

pause.MouseButton1Click:Connect(function()
	for _,v in pairs(humanoid:GetPlayingAnimationTracks()) do
		if v.Animation.AnimationId == tonumber(_stop.Text) then
			v:AdjustSpeed(0)
		end
	end
end)

resume.MouseButton1Click:Connect(function()
	for _,v in pairs(humanoid:GetPlayingAnimationTracks()) do
		if v.Animation.AnimationId == tonumber(_stop.Text) then
			v:AdjustSpeed(1)
		end
	end
end)
