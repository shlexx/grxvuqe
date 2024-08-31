local Players = game:GetService("Players")
local ChatSpy = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MainName = Instance.new("TextLabel")
local Close = Instance.new("ImageButton")
local ChatHandler = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
ChatSpy.Name = "ChatSpy"
ChatSpy.Parent = game.CoreGui
MainFrame.Name = "MainFrame"
MainFrame.Parent = ChatSpy
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.375356138, 0, 0.386304915, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 175)
MainName.Name = "MainName"
MainName.Parent = MainFrame
MainName.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
MainName.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainName.BorderSizePixel = 0
MainName.Size = UDim2.new(0, 350, 0, 20)
MainName.Font = Enum.Font.SourceSansSemibold
MainName.Text = "Chat Spy"
MainName.TextColor3 = Color3.fromRGB(255, 255, 255)
MainName.TextSize = 14.000
Close.Name = "Close"
Close.Parent = MainFrame
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundTransparency = 1.000
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.942857146, 0, 0, 0)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Image = "rbxassetid://10747384394"
ChatHandler.Name = "ChatHandler"
ChatHandler.Parent = MainFrame
ChatHandler.Active = true
ChatHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ChatHandler.BackgroundTransparency = 1.000
ChatHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
ChatHandler.BorderSizePixel = 0
ChatHandler.Position = UDim2.new(0, 0, 0.114285715, 0)
ChatHandler.Size = UDim2.new(0, 350, 0, 155)
ChatHandler.AutomaticCanvasSize = Enum.AutomaticSize.XY
UIListLayout.Parent = ChatHandler
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local UserInputService = game:GetService("UserInputService")
local runService = (game:GetService("RunService"));
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

function create(player,message)
	local label = Instance.new("TextLabel", game.CoreGui.ChatSpy.MainFrame.ChatHandler)
	label.Size = UDim2.new(0,350,0,20)
	label.BorderSizePixel = 0
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Text = "  " .. player.Name .. ": " .. message
	label.TextXAlignment = Enum.TextXAlignment.Left
end

for _,v in pairs(Players:GetPlayers()) do
	v.Chatted:Connect(function(message)
		create(v,message)
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		create(player,message)
	end)
end)

Close.MouseButton1Click:Connect(function()
	ChatSpy:Destroy()
end)
