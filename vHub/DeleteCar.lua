local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local shutdown = Instance.new("TextButton")
local deltool = Instance.new("TextButton")
local removelimbs = Instance.new("TextButton")
local removelegs = Instance.new("TextButton")
local nked = Instance.new("TextButton")
local kill = Instance.new("TextButton")
local ragdoll = Instance.new("TextButton")
local bald = Instance.new("TextButton")
local kick = Instance.new("TextButton")
local removemap = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")
local madeby = Instance.new("TextLabel")
local lin = Instance.new("TextLabel")

local input = game:GetService("UserInputService")
local dragging = false
local dragInput, mousePos, framePos

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

input.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		Frame.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
	end
end)

function del(ins)
	spawn(function()
		game:GetService("ReplicatedStorage").DeleteCar:FireServer(ins)
	end)
end

local msg = TextBox.Text

local function findPlayer(stringg)
	for _, v in pairs(game.Players:GetPlayers()) do
		if stringg:lower() == (v.Name:lower()):sub(1, #stringg) then
			return v
		end
	end
end

local oplayer = findPlayer(msg)

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BackgroundTransparency = 0.500
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.565984488, 0, 0.408521295, 0)
Frame.Size = UDim2.new(0, 199, 0, 273)

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextLabel.BackgroundTransparency = 0.500
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(0, 200, 0, 25)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "vHub (deletecar edition)"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

shutdown.Name = "shutdown"
shutdown.Parent = Frame
shutdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
shutdown.BackgroundTransparency = 0.500
shutdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
shutdown.BorderSizePixel = 0
shutdown.Position = UDim2.new(0.0552763827, 0, 0.131868139, 0)
shutdown.Size = UDim2.new(0, 75, 0, 20)
shutdown.Font = Enum.Font.SourceSansBold
shutdown.Text = "Shutdown"
shutdown.TextColor3 = Color3.fromRGB(255, 255, 255)
shutdown.TextScaled = true
shutdown.TextSize = 14.000
shutdown.TextWrapped = true
shutdown.MouseButton1Click:Connect(function()
	for i, v in pairs(game.Players:GetPlayers()) do
		del(v)
	end
end)

deltool.Name = "deltool"
deltool.Parent = Frame
deltool.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
deltool.BackgroundTransparency = 0.500
deltool.BorderColor3 = Color3.fromRGB(0, 0, 0)
deltool.BorderSizePixel = 0
deltool.Position = UDim2.new(0.577889442, 0, 0.131868139, 0)
deltool.Size = UDim2.new(0, 75, 0, 20)
deltool.Font = Enum.Font.SourceSansBold
deltool.Text = "Delete Tool"
deltool.TextColor3 = Color3.fromRGB(255, 255, 255)
deltool.TextScaled = true
deltool.TextSize = 14.000
deltool.TextWrapped = true
deltool.MouseButton1Click:Connect(function()
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local backpack = player:WaitForChild("Backpack")
	local mouse = player:GetMouse()

	local tool = Instance.new("Tool")
	tool.TextureId = "rbxasset://icons/delete.png"
	tool.Name = "del"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = backpack

	local function onActivated()
		local target = mouse.Target
		if target and target:IsA("BasePart") then
			del(target)
		end
	end

	tool.Activated:Connect(onActivated)
end)

removelimbs.Name = "removelimbs"
removelimbs.Parent = Frame
removelimbs.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
removelimbs.BackgroundTransparency = 0.500
removelimbs.BorderColor3 = Color3.fromRGB(0, 0, 0)
removelimbs.BorderSizePixel = 0
removelimbs.Position = UDim2.new(0.577889442, 0, 0.260073274, 0)
removelimbs.Size = UDim2.new(0, 75, 0, 20)
removelimbs.Font = Enum.Font.SourceSansBold
removelimbs.Text = "Remove Limbs"
removelimbs.TextColor3 = Color3.fromRGB(255, 255, 255)
removelimbs.TextScaled = true
removelimbs.TextSize = 14.000
removelimbs.TextWrapped = true
removelimbs.MouseButton1Click:Connect(function()
	if msg == "all" then
		for _,v in pairs(game.Players:GetPlayers()) do
			local char = v.Character or v.CharacterAdded:wait()
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum.RigType == Enum.RigType.R15 then
				del(char.LeftHand)
				del(char.RightHand)
				del(char.RightUpperArm)
				del(char.LeftUpperArm)
				del(char.RightLowerArm)
				del(char.LeftLowerArm)
			else
				del(char["Right Arm"])
				del(char["Left Arm"])
			end
		end
	elseif msg == "others" then
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name == game.Players.LocalPlayer.Name then else
				local char = v.Character or v.CharacterAdded:wait()
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum.RigType == Enum.RigType.R15 then
					del(char.LeftHand)
					del(char.RightHand)
					del(char.RightUpperArm)
					del(char.LeftUpperArm)
					del(char.RightLowerArm)
					del(char.LeftLowerArm)
				else
					del(char["Right Arm"])
					del(char["Left Arm"])
				end
			end
		end
	else
		local char = oplayer.Character or oplayer.CharacterAdded:wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum.RigType == Enum.RigType.R15 then
			del(char.LeftHand)
			del(char.RightHand)
			del(char.RightUpperArm)
			del(char.LeftUpperArm)
			del(char.RightLowerArm)
			del(char.LeftLowerArm)
		else
			del(char["Right Arm"])
			del(char["Left Arm"])
		end
	end
end)

removelegs.Name = "removelegs"
removelegs.Parent = Frame
removelegs.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
removelegs.BackgroundTransparency = 0.500
removelegs.BorderColor3 = Color3.fromRGB(0, 0, 0)
removelegs.BorderSizePixel = 0
removelegs.Position = UDim2.new(0.0552763827, 0, 0.260073274, 0)
removelegs.Size = UDim2.new(0, 75, 0, 20)
removelegs.Font = Enum.Font.SourceSansBold
removelegs.Text = "Remove Legs"
removelegs.TextColor3 = Color3.fromRGB(255, 255, 255)
removelegs.TextScaled = true
removelegs.TextSize = 14.000
removelegs.TextWrapped = true
removelegs.MouseButton1Click:Connect(function()
	if msg == "all" then
		for _,v in pairs(game.Players:GetPlayers()) do
			local char = v.Character or v.CharacterAdded:wait()
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum.RigType == Enum.RigType.R15 then
				del(char.LeftFoot)
				del(char.RightFoot)
				del(char.RightLowerLeg)
				del(char.LeftLowerLeg)
				del(char.RightUpperLeg)
				del(char.LeftLowerLeg)
			else
				del(char["Left Leg"])
				del(char["Right Leg"])
			end
		end
	elseif msg == "others" then
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name == game.Players.LocalPlayer.Name then else
				local char = v.Character or v.CharacterAdded:wait()
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum.RigType == Enum.RigType.R15 then
					del(char.LeftFoot)
					del(char.RightFoot)
					del(char.RightLowerLeg)
					del(char.LeftLowerLeg)
					del(char.RightUpperLeg)
					del(char.LeftLowerLeg)
				else
					del(char["Left Leg"])
					del(char["Right Leg"])
				end
			end
		end
	else
		local char = oplayer.Character or oplayer.CharacterAdded:wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum.RigType == Enum.RigType.R15 then
			del(char.LeftFoot)
			del(char.RightFoot)
			del(char.RightLowerLeg)
			del(char.LeftLowerLeg)
			del(char.RightUpperLeg)
			del(char.LeftLowerLeg)
		else
			del(char["Left Leg"])
			del(char["Right Leg"])
		end
	end
end)

nked.Name = "nked"
nked.Parent = Frame
nked.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
nked.BackgroundTransparency = 0.500
nked.BorderColor3 = Color3.fromRGB(0, 0, 0)
nked.BorderSizePixel = 0
nked.Position = UDim2.new(0.577889442, 0, 0.399267405, 0)
nked.Size = UDim2.new(0, 75, 0, 20)
nked.Font = Enum.Font.SourceSansBold
nked.Text = "Naked"
nked.TextColor3 = Color3.fromRGB(255, 255, 255)
nked.TextScaled = true
nked.TextSize = 14.000
nked.TextWrapped = true
nked.MouseButton1Click:Connect(function()
	if msg == "all" then
		for _,v in pairs(game.Players:GetPlayers()) do
			local char = v.Character or v.CharacterAdded:wait()
			del(char:FindFirstChildOfClass("Shirt"))
			del(char:FindFirstChildOfClass("Pants"))
			del(char:FindFirstChildOfClass("ShirtGraphic"))
		end
	elseif msg == "others" then
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name == game.Players.LocalPlayer.Name then else
				local char = v.Character or v.CharacterAdded:wait()
				del(char:FindFirstChildOfClass("Shirt"))
				del(char:FindFirstChildOfClass("Pants"))
				del(char:FindFirstChildOfClass("ShirtGraphic"))
			end
		end
	else
		local char = oplayer.Character or oplayer.CharacterAdded:wait()
		del(char:FindFirstChildOfClass("Shirt"))
		del(char:FindFirstChildOfClass("Pants"))
		del(char:FindFirstChildOfClass("ShirtGraphic"))
	end
end)

kill.Name = "kill"
kill.Parent = Frame
kill.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
kill.BackgroundTransparency = 0.500
kill.BorderColor3 = Color3.fromRGB(0, 0, 0)
kill.BorderSizePixel = 0
kill.Position = UDim2.new(0.577889442, 0, 0.527472556, 0)
kill.Size = UDim2.new(0, 75, 0, 20)
kill.Font = Enum.Font.SourceSansBold
kill.Text = "Kill"
kill.TextColor3 = Color3.fromRGB(255, 255, 255)
kill.TextScaled = true
kill.TextSize = 14.000
kill.TextWrapped = true
kill.MouseButton1Click:Connect(function()
	if msg == "all" then
		for _,v in pairs(game.Players:GetPlayers()) do
			local char = v.Character or v.CharacterAdded:wait()
			del(char.Head)
		end
	elseif msg == "others" then
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name == game.Players.LocalPlayer.Name then else
				local char = v.Character or v.CharacterAdded:wait()
				del(char.Head)
			end
		end
	else
		local char = oplayer.Character or oplayer.CharacterAdded:wait()
		del(char.Head)
	end
end)

ragdoll.Name = "ragdoll"
ragdoll.Parent = Frame
ragdoll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ragdoll.BackgroundTransparency = 0.500
ragdoll.BorderColor3 = Color3.fromRGB(0, 0, 0)
ragdoll.BorderSizePixel = 0
ragdoll.Position = UDim2.new(0.0552763827, 0, 0.527472556, 0)
ragdoll.Size = UDim2.new(0, 75, 0, 20)
ragdoll.Font = Enum.Font.SourceSansBold
ragdoll.Text = "Ragdoll"
ragdoll.TextColor3 = Color3.fromRGB(255, 255, 255)
ragdoll.TextScaled = true
ragdoll.TextSize = 14.000
ragdoll.TextWrapped = true
ragdoll.MouseButton1Click:Connect(function()
	if msg == "all" then
		for _,v in pairs(game.Players:GetPlayers()) do
			local char = v.Character or v.CharacterAdded:wait()
			del(char:FindFirstChildOfClass("Humanoid"))
		end
	elseif msg == "others" then
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name == game.Players.LocalPlayer.Name then else
				local char = v.Character or v.CharacterAdded:wait()
				del(char:FindFirstChildOfClass("Humanoid"))
			end
		end
	else
		local char = oplayer.Character or oplayer.CharacterAdded:wait()
		del(char:FindFirstChildOfClass("Humanoid"))
	end
end)

bald.Name = "bald"
bald.Parent = Frame
bald.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bald.BackgroundTransparency = 0.500
bald.BorderColor3 = Color3.fromRGB(0, 0, 0)
bald.BorderSizePixel = 0
bald.Position = UDim2.new(0.0552763827, 0, 0.399267405, 0)
bald.Size = UDim2.new(0, 75, 0, 20)
bald.Font = Enum.Font.SourceSansBold
bald.Text = "Hatless"
bald.TextColor3 = Color3.fromRGB(255, 255, 255)
bald.TextScaled = true
bald.TextSize = 14.000
bald.TextWrapped = true
bald.MouseButton1Click:Connect(function()
	if msg == "all" then
		for _,v in pairs(game.Players:GetPlayers()) do
			local char = v.Character or v.CharacterAdded:wait()
			repeat
				del(char:FindFirstChildOfClass("Accessory"))
			until char:FindFirstChildOfClass("Accessory") == nil
		end
	elseif msg == "others" then
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name == game.Players.LocalPlayer.Name then else
				local char = v.Character or v.CharacterAdded:wait()
				repeat
					del(char:FindFirstChildOfClass("Accessory"))
				until char:FindFirstChildOfClass("Accessory") == nil
			end
		end
	else
		local char = oplayer.Character or oplayer.CharacterAdded:wait()
		repeat
			del(char:FindFirstChildOfClass("Accessory"))
		until char:FindFirstChildOfClass("Accessory") == nil
	end
end)

kick.Name = "kick"
kick.Parent = Frame
kick.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
kick.BackgroundTransparency = 0.500
kick.BorderColor3 = Color3.fromRGB(0, 0, 0)
kick.BorderSizePixel = 0
kick.Position = UDim2.new(0.577889442, 0, 0.666666687, 0)
kick.Size = UDim2.new(0, 75, 0, 20)
kick.Font = Enum.Font.SourceSansBold
kick.Text = "Kick"
kick.TextColor3 = Color3.fromRGB(255, 255, 255)
kick.TextScaled = true
kick.TextSize = 14.000
kick.TextWrapped = true
kick.MouseButton1Click:Connect(function()
	if msg == "all" then
		for _,v in pairs(game.Players:GetPlayers()) do
			del(v)
		end
	elseif msg == "others" then
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name == game.Players.LocalPlayer.Name then else
				del(v)
			end
		end
	else
		del(oplayer)
	end
end)

removemap.Name = "removemap"
removemap.Parent = Frame
removemap.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
removemap.BackgroundTransparency = 0.500
removemap.BorderColor3 = Color3.fromRGB(0, 0, 0)
removemap.BorderSizePixel = 0
removemap.Position = UDim2.new(0.0552763827, 0, 0.666666687, 0)
removemap.Size = UDim2.new(0, 75, 0, 20)
removemap.Font = Enum.Font.SourceSansBold
removemap.Text = "Remove Map"
removemap.TextColor3 = Color3.fromRGB(255, 255, 255)
removemap.TextScaled = true
removemap.TextSize = 14.000
removemap.TextWrapped = true
removemap.MouseButton1Click:Connect(function()
	for _,v in pairs(workspace:GetDescendants()) do
		del(v)
	end
end)

TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.BackgroundTransparency = 0.500
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0, 0, 0.783882797, 0)
TextBox.Size = UDim2.new(0, 200, 0, 30)
TextBox.Font = Enum.Font.SourceSansBold
TextBox.PlaceholderText = "player"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 25.000
TextBox.TextWrapped = true

madeby.Name = "madeby"
madeby.Parent = Frame
madeby.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
madeby.BackgroundTransparency = 0.500
madeby.BorderColor3 = Color3.fromRGB(0, 0, 0)
madeby.BorderSizePixel = 0
madeby.Position = UDim2.new(0, 0, 0.8937729, 0)
madeby.Size = UDim2.new(0, 200, 0, 29)
madeby.Font = Enum.Font.SourceSansBold
madeby.Text = "Made by roblox.stud"
madeby.TextColor3 = Color3.fromRGB(255, 255, 255)
madeby.TextSize = 14.000

lin.Name = "lin"
lin.Parent = Frame
lin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lin.BorderColor3 = Color3.fromRGB(0, 0, 0)
lin.BorderSizePixel = 0
lin.Position = UDim2.new(0, 0, 0.8937729, 0)
lin.Size = UDim2.new(0, 200, 0, -1)
lin.Font = Enum.Font.SourceSans
lin.Text = ""
lin.TextColor3 = Color3.fromRGB(0, 0, 0)
lin.TextSize = 14.000
