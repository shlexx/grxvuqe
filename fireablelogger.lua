local FireablesLogger = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Name = Instance.new("TextLabel")
local Close = Instance.new("ImageButton")
local Minimize = Instance.new("ImageButton")
local MainList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local Scan = Instance.new("TextButton")
local Open = Instance.new("ImageButton")
local FireableSelectionFrame = Instance.new("Frame")
local Name2 = Instance.new("TextLabel")
local Close2 = Instance.new("ImageButton")
local FullPathLabel = Instance.new("TextLabel")
local FullPath = Instance.new("TextBox")
local InstanceLabel = Instance.new("TextLabel")
local CopyPath = Instance.new("TextButton")
local Fire = Instance.new("TextButton")
FireablesLogger.Name = "FireablesLogger"
FireablesLogger.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
FireablesLogger.ResetOnSpawn = false
MainFrame.Name = "MainFrame"
MainFrame.Parent = FireablesLogger
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
Name.Name = "Name"
Name.Parent = MainFrame
Name.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Name.BorderSizePixel = 0
Name.Size = UDim2.new(0, 300, 0, 20)
Name.Font = Enum.Font.SourceSansSemibold
Name.Text = "grxvuqe's Fireables Logger"
Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Name.TextSize = 14.000
Close.Name = "Close"
Close.Parent = MainFrame
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundTransparency = 1.000
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.933333337, 0, 0, 0)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Image = "http://www.roblox.com/asset/?id=10830675223"
Minimize.Name = "Minimize"
Minimize.Parent = MainFrame
Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Minimize.BackgroundTransparency = 1.000
Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
Minimize.BorderSizePixel = 0
Minimize.Position = UDim2.new(0.866666675, 0, 0, 0)
Minimize.Size = UDim2.new(0, 20, 0, 20)
Minimize.ZIndex = 2
Minimize.Image = "http://www.roblox.com/asset/?id=8874551390"
MainList.Name = "MainList"
MainList.Parent = MainFrame
MainList.Active = true
MainList.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
MainList.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainList.BorderSizePixel = 0
MainList.Position = UDim2.new(0, 0, 0.0571428575, 0)
MainList.Size = UDim2.new(0, 300, 0, 310)
MainList.AutomaticCanvasSize = Enum.AutomaticSize.Y
UIListLayout.Parent = MainList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 1)
Scan.Name = "Scan"
Scan.Parent = MainFrame
Scan.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Scan.BorderColor3 = Color3.fromRGB(0, 0, 0)
Scan.BorderSizePixel = 0
Scan.Position = UDim2.new(0, 0, 0.942857146, 0)
Scan.Size = UDim2.new(0, 300, 0, 20)
Scan.Font = Enum.Font.SourceSansSemibold
Scan.Text = "Scan"
Scan.TextColor3 = Color3.fromRGB(255, 255, 255)
Scan.TextSize = 14.000
Open.Name = "Open"
Open.Parent = FireablesLogger
Open.AnchorPoint = Vector2.new(0, 1)
Open.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Open.BackgroundTransparency = 1.000
Open.BorderColor3 = Color3.fromRGB(0, 0, 0)
Open.BorderSizePixel = 0
Open.Position = UDim2.new(0, 0, 1, 0)
Open.Size = UDim2.new(0, 50, 0, 50)
Open.Visible = false
Open.Image = "rbxassetid://9290145428"
FireableSelectionFrame.Name = "FireableSelectionFrame"
FireableSelectionFrame.Parent = FireablesLogger
FireableSelectionFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FireableSelectionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FireableSelectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
FireableSelectionFrame.BorderSizePixel = 0
FireableSelectionFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FireableSelectionFrame.Size = UDim2.new(0, 400, 0, 200)
FireableSelectionFrame.Visible = false
Name2.Name = "Name2"
Name2.Parent = FireableSelectionFrame
Name2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Name2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Name2.BorderSizePixel = 0
Name2.Size = UDim2.new(0, 400, 0, 20)
Name2.Font = Enum.Font.SourceSans
Name2.Text = "epicname"
Name2.TextColor3 = Color3.fromRGB(255, 255, 255)
Name2.TextSize = 14.000
Close2.Name = "Close2"
Close2.Parent = FireableSelectionFrame
Close2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close2.BackgroundTransparency = 1.000
Close2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close2.BorderSizePixel = 0
Close2.Position = UDim2.new(0.948333442, 0, 0, 0)
Close2.Size = UDim2.new(0, 20, 0, 20)
Close2.Image = "http://www.roblox.com/asset/?id=10830675223"
FullPathLabel.Name = "FullPathLabel"
FullPathLabel.Parent = FireableSelectionFrame
FullPathLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FullPathLabel.BackgroundTransparency = 1.000
FullPathLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
FullPathLabel.BorderSizePixel = 0
FullPathLabel.Position = UDim2.new(0.0250000004, 0, 0.150000006, 0)
FullPathLabel.Size = UDim2.new(0, 80, 0, 15)
FullPathLabel.Font = Enum.Font.SourceSansSemibold
FullPathLabel.Text = "Full Path:"
FullPathLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FullPathLabel.TextSize = 14.000
FullPathLabel.TextXAlignment = Enum.TextXAlignment.Left
FullPath.Name = "FullPath"
FullPath.Parent = FireableSelectionFrame
FullPath.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FullPath.BackgroundTransparency = 1.000
FullPath.BorderColor3 = Color3.fromRGB(0, 0, 0)
FullPath.BorderSizePixel = 0
FullPath.Position = UDim2.new(0.0250000004, 0, 0.275000006, 0)
FullPath.Size = UDim2.new(0, 300, 0, 45)
FullPath.ClearTextOnFocus = false
FullPath.Font = Enum.Font.SourceSansSemibold
FullPath.MultiLine = true
FullPath.Text = "fullnamexd"
FullPath.TextColor3 = Color3.fromRGB(255, 255, 255)
FullPath.TextSize = 14.000
FullPath.TextWrapped = true
FullPath.TextXAlignment = Enum.TextXAlignment.Left
FullPath.TextYAlignment = Enum.TextYAlignment.Top
InstanceLabel.Name = "InstanceLabel"
InstanceLabel.Parent = FireableSelectionFrame
InstanceLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InstanceLabel.BackgroundTransparency = 1.000
InstanceLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
InstanceLabel.BorderSizePixel = 0
InstanceLabel.Position = UDim2.new(0.0250000004, 0, 0.550000012, 0)
InstanceLabel.Size = UDim2.new(0, 200, 0, 20)
InstanceLabel.Font = Enum.Font.SourceSansSemibold
InstanceLabel.Text = "Instance: ..."
InstanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InstanceLabel.TextSize = 14.000
InstanceLabel.TextXAlignment = Enum.TextXAlignment.Left
CopyPath.Name = "CopyPath"
CopyPath.Parent = FireableSelectionFrame
CopyPath.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyPath.BorderColor3 = Color3.fromRGB(0, 0, 0)
CopyPath.BorderSizePixel = 0
CopyPath.Position = UDim2.new(0.0250000004, 0, 0.699999988, 0)
CopyPath.Size = UDim2.new(0, 200, 0, 20)
CopyPath.Font = Enum.Font.SourceSansBold
CopyPath.Text = "Copy Path"
CopyPath.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyPath.TextSize = 14.000
Fire.Name = "Fire"
Fire.Parent = FireableSelectionFrame
Fire.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Fire.BorderColor3 = Color3.fromRGB(0, 0, 0)
Fire.BorderSizePixel = 0
Fire.Position = UDim2.new(0.0250000004, 0, 0.850000024, 0)
Fire.Size = UDim2.new(0, 200, 0, 20)
Fire.Font = Enum.Font.SourceSansBold
Fire.Text = "Fire"
Fire.TextColor3 = Color3.fromRGB(255, 255, 255)
Fire.TextSize = 14.000

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
dragify(MainFrame)
dragify(FireableSelectionFrame)

CopyPath.MouseButton1Click:Connect(function()
	setclipboard(tostring(FullPath.Text))
end)

local function create(ins)
	local button = Instance.new("TextButton",MainList)
	button.Name = "Button"
	button.BorderSizePixel = 0
	button.BackgroundColor3 = Color3.fromRGB(50,50,50)
	button.Size = UDim2.new(1,0,0,20)
	button.Text = ins.Name
	button.TextColor3 = Color3.new(255,255,255)
	button.Font = Enum.Font.SourceSansSemibold
	button.TextSize = 14.000
	button.MouseButton1Click:Connect(function()
		Name2.Text = ins.Name
		FullPath.Text = "game." .. ins:GetFullName()
		InstanceLabel.Text = "Instance: " .. ins.ClassName
		FireableSelectionFrame.Visible = true
        	function rins()
            		return ins
        	end
	end)
end

Scan.MouseButton1Click:Connect(function()
	for _,x in pairs(MainList:GetChildren()) do
		if x:IsA("TextButton") then
			x:Destroy()
		end
	end
	task.wait()
	for _,v in pairs(game:GetDescendants()) do
		if v:IsA("ClickDetector") or v:IsA("TouchTransmitter") or v:IsA("ProximityPrompt") then
			create(v)
		end
	end
end)

Fire.MouseButton1Click:Connect(function()
	if InstanceLabel.Text == "Instance: ClickDetector" then
		fireclickdetector(rins())
	elseif InstanceLabel.Text == "Instance: TouchTransmitter/TouchInterest" then
		firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), rins(), 0)
	elseif InstanceLabel.Text == "Instance: ProximityPrompt" then
		fireproximityprompt(rins())
	end
end)

Close.MouseButton1Click:Connect(function()
	FireablesLogger:Destroy()
end)

Close2.MouseButton1Click:Connect(function()
	FireableSelectionFrame.Visible = false
end)

Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	Open.Visible = true
end)

Open.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	Open.Visible = false
end)
