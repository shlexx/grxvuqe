repeat task.wait() until game:IsLoaded()
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/scripts/AntiChatLogger.lua", true))()
wait()

local CB = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonHolder = Instance.new("Frame")
local Minimize = Instance.new("ImageButton")
local Close = Instance.new("ImageButton")
local InputHolder = Instance.new("Frame")
local Input = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")
local Clear = Instance.new("ImageButton")
local IsEnabled = Instance.new("ImageButton")
local Send = Instance.new("TextButton")
local FakeSend = Instance.new("TextButton")
local Open = Instance.new("ImageButton")
local UIStroke = Instance.new("UIStroke")
local UIStroke_2 = Instance.new("UIStroke")
local UIStroke_3 = Instance.new("UIStroke")
local UIStroke_4 = Instance.new("UIStroke")
local UIStroke_5 = Instance.new("UIStroke")
local UIStroke_6 = Instance.new("UIStroke")
local UIStroke_7 = Instance.new("UIStroke")
local UIStroke_8 = Instance.new("UIStroke")
CB.Name = "CB"
CB.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
CB.ResetOnSpawn = false
MainFrame.Name = "MainFrame"
MainFrame.Parent = CB
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.357752502, 0, 0.374371856, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 200)
ButtonHolder.Name = "ButtonHolder"
ButtonHolder.Parent = MainFrame
ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonHolder.BackgroundTransparency = 1.000
ButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtonHolder.BorderSizePixel = 0
ButtonHolder.Position = UDim2.new(0.850000024, 0, 0, 0)
ButtonHolder.Size = UDim2.new(0, 60, 0, 30)
Minimize.Name = "Minimize"
Minimize.Parent = ButtonHolder
Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Minimize.BackgroundTransparency = 1.000
Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
Minimize.BorderSizePixel = 0
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Image = "rbxassetid://10734896206"
Close.Name = "Close"
Close.Parent = ButtonHolder
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundTransparency = 1.000
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.5, 0, 0, 0)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Image = "rbxassetid://10747384394"
InputHolder.Name = "InputHolder"
InputHolder.Parent = MainFrame
InputHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InputHolder.BackgroundTransparency = 1.000
InputHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
InputHolder.BorderSizePixel = 0
InputHolder.Position = UDim2.new(0.25, 0, 0.200000003, 0)
InputHolder.Size = UDim2.new(0, 200, 0, 50)
Input.Name = "Input"
Input.Parent = InputHolder
Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Input.BackgroundTransparency = 1.000
Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
Input.BorderSizePixel = 0
Input.Size = UDim2.new(0, 200, 0, 50)
Input.Font = Enum.Font.FredokaOne
Input.MultiLine = true
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextSize = 20.000
Input.TextWrapped = true
UICorner.Parent = Input
Clear.Name = "Clear"
Clear.Parent = MainFrame
Clear.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Clear.BackgroundTransparency = 1.000
Clear.BorderColor3 = Color3.fromRGB(0, 0, 0)
Clear.BorderSizePixel = 0
Clear.Position = UDim2.new(0.075000003, 0, 0.25, 0)
Clear.Size = UDim2.new(0, 40, 0, 40)
Clear.Image = "rbxassetid://10747362241"
IsEnabled.Name = "IsEnabled"
IsEnabled.Parent = MainFrame
IsEnabled.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IsEnabled.BackgroundTransparency = 1.000
IsEnabled.BorderColor3 = Color3.fromRGB(0, 0, 0)
IsEnabled.BorderSizePixel = 0
IsEnabled.Position = UDim2.new(0.824999988, 0, 0.25, 0)
IsEnabled.Size = UDim2.new(0, 40, 0, 40)
IsEnabled.Image = "rbxassetid://10709790537"
Send.Name = "Send"
Send.Parent = MainFrame
Send.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Send.BackgroundTransparency = 1.000
Send.BorderColor3 = Color3.fromRGB(0, 0, 0)
Send.BorderSizePixel = 0
Send.Position = UDim2.new(0.0375000015, 0, 0.654999971, 0)
Send.Size = UDim2.new(0, 370, 0, 50)
Send.Font = Enum.Font.FredokaOne
Send.Text = "send!"
Send.TextColor3 = Color3.fromRGB(255, 255, 255)
Send.TextScaled = true
Send.TextSize = 14.000
Open.Name = "Open"
Open.Parent = CB
Open.AnchorPoint = Vector2.new(0, 1)
Open.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Open.BorderColor3 = Color3.fromRGB(0, 0, 0)
Open.BorderSizePixel = 0
Open.Position = UDim2.new(0, 0, 1, 0)
Open.Size = UDim2.new(0, 50, 0, 50)
Open.Image = "rbxassetid://10709813281"
Open.Visible = false
FakeSend.Name = "FakeSend"
FakeSend.Parent = MainFrame
FakeSend.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FakeSend.BackgroundTransparency = 1.000
FakeSend.BorderColor3 = Color3.fromRGB(0, 0, 0)
FakeSend.BorderSizePixel = 0
FakeSend.Position = UDim2.new(0.0375000015, 0, 0.654999971, 0)
FakeSend.Size = UDim2.new(0, 370, 0, 50)
FakeSend.Font = Enum.Font.FredokaOne
FakeSend.Text = "send!"
FakeSend.TextColor3 = Color3.fromRGB(255, 255, 255)
FakeSend.TextScaled = true
FakeSend.TextSize = 14.000
FakeSend.Visible = false
UIStroke.Parent = MainFrame
UIStroke.Thickness = 6
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UIStroke.Color = Color3.new(0,0,0)
UIStroke_2.Parent = ButtonHolder
UIStroke_2.Thickness = 6
UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UIStroke_2.Color = Color3.new(0,0,0)
UIStroke_3.Parent = InputHolder
UIStroke_3.Thickness = 6
UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UIStroke_3.Color = Color3.new(0,0,0)
UIStroke_4.Parent = Clear
UIStroke_4.Thickness = 6
UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UIStroke_4.Color = Color3.new(0,0,0)
UIStroke_5.Parent = IsEnabled
UIStroke_5.Thickness = 6
UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UIStroke_5.Color = Color3.new(0,0,0)
UIStroke_6.Parent = Send
UIStroke_6.Thickness = 6
UIStroke_6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_6.Color = Color3.new(0,0,0)
UIStroke_7.Parent = FakeSend
UIStroke_7.Thickness = 6
UIStroke_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_7.Color = Color3.new(0,0,0)
UIStroke_8.Parent = Open
UIStroke_8.Thickness = 6
UIStroke_8.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UIStroke_8.Color = Color3.new(0,0,0)

local UserInputService = game:GetService("UserInputService")
local runService = (game:GetService("RunService"));
local TweenService = game:GetService("TweenService")
local dragging
local dragInput
local dragStart
local startPos

local gui = MainFrame

local function Lerp(a, b, m)
	return a + (b - a) * m
end;

local lastMousePos
local lastGoalPos
local DRAG_SPEED = (8); -- // The speed of the UI drag.
local function Update(dt)
	if not (startPos) then return end;
	if not (dragging) and (lastGoalPos) then
		gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
		return 
	end;

	local delta = (lastMousePos - UserInputService:GetMouseLocation())
	local xGoal = (startPos.X.Offset - delta.X);
	local yGoal = (startPos.Y.Offset - delta.Y);
	lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
	gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
end;

gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Position
		lastMousePos = UserInputService:GetMouseLocation()

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

gui.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

runService.Heartbeat:Connect(Update)

Send.MouseButton1Click:Connect(function()
	local str = Input.Text
	local TextChatService = game:GetService("TextChatService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local chat = TextChatService.ChatInputBarConfiguration.TargetTextChannel
	str = string.gsub(str, "a", "🅰")
	str = string.gsub(str, "b", "🅱")
	str = string.gsub(str, "c", "🅲")
	str = string.gsub(str, "d", "🅳")
	str = string.gsub(str, "e", "🅴")
	str = string.gsub(str, "f", "🅵")
	str = string.gsub(str, "g", "🅶")
	str = string.gsub(str, "h", "🅷")
	str = string.gsub(str, "i", "🅸")
	str = string.gsub(str, "j", "🅹")
	str = string.gsub(str, "k", "🅺")
	str = string.gsub(str, "l", "🅻")
	str = string.gsub(str, "m", "🅼")
	str = string.gsub(str, "n", "🅽")
	str = string.gsub(str, "o", "🅾")
	str = string.gsub(str, "p", "🅿")
	str = string.gsub(str, "q", "🆀")
	str = string.gsub(str, "r", "🆁")
	str = string.gsub(str, "s", "🆂")
	str = string.gsub(str, "t", "🆃")
	str = string.gsub(str, "u", "🆄")
	str = string.gsub(str, "v", "🆅")
	str = string.gsub(str, "w", "🆆")
	str = string.gsub(str, "x", "🆇")
	str = string.gsub(str, "y", "🆈")
	str = string.gsub(str, "z", "🆉")
	str = string.gsub(str, "A", "🅰")
	str = string.gsub(str, "B", "🅱")
	str = string.gsub(str, "C", "🅲")
	str = string.gsub(str, "D", "🅳")
	str = string.gsub(str, "E", "🅴")
	str = string.gsub(str, "F", "🅵")
	str = string.gsub(str, "G", "🅶")
	str = string.gsub(str, "H", "🅷")
	str = string.gsub(str, "I", "🅸")
	str = string.gsub(str, "J", "🅹")
	str = string.gsub(str, "K", "🅺")
	str = string.gsub(str, "L", "🅻")
	str = string.gsub(str, "M", "🅼")
	str = string.gsub(str, "N", "🅽")
	str = string.gsub(str, "O", "🅾")
	str = string.gsub(str, "P", "🅿")
	str = string.gsub(str, "Q", "🆀")
	str = string.gsub(str, "R", "🆁")
	str = string.gsub(str, "S", "🆂")
	str = string.gsub(str, "T", "🆃")
	str = string.gsub(str, "U", "🆄")
	str = string.gsub(str, "V", "🆅")
	str = string.gsub(str, "W", "🆆")
	str = string.gsub(str, "X", "🆇")
	str = string.gsub(str, "Y", "🆈")
	str = string.gsub(str, "Z", "🆉")
	str = string.gsub(str, " ", " ")

	if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
		ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(str, "All")
	else
		chat:SendAsync(str)
	end
end)

Clear.MouseButton1Click:Connect(function()
	Input.Text = ""
end)

IsEnabled.MouseButton1Click:Connect(function()
	if Send.Visible == true then
		Send.Visible = false
		FakeSend.Visible = true
		IsEnabled.Image = "rbxassetid://10734965702"
	else
		Send.Visible = true
		FakeSend.Visible = false
		IsEnabled.Image = "rbxassetid://10709790537"
	end
end)

Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	Open.Visible = true
end)

Open.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	Open.Visible = false
end)

Close.MouseButton1Click:Connect(function()
	CB:Destroy()
end)
