local hied = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local fr = Instance.new("TextLabel")
local avt = Instance.new("ImageLabel")
local TextBox = Instance.new("TextBox")
local TextButton = Instance.new("TextButton")
hied.Name = "hied"
hied.Parent = game.CoreGui
Frame.Parent = hied
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.265795201, 0, 0.219849244, 0)
Frame.Size = UDim2.new(0, 274, 0, 336)
fr.Name = "fr"
fr.Parent = Frame
fr.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fr.BorderColor3 = Color3.fromRGB(0, 0, 0)
fr.BorderSizePixel = 0
fr.Position = UDim2.new(-0.000628172071, 0, -0.00552764907, 0)
fr.Size = UDim2.new(0, 274, 0, 60)
fr.Font = Enum.Font.SourceSans
fr.Text = "kat modded kil gui!1"
fr.TextColor3 = Color3.fromRGB(255, 255, 255)
fr.TextScaled = true
fr.TextSize = 14.000
fr.TextWrapped = true
avt.Name = "avt"
avt.Parent = Frame
avt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
avt.BackgroundTransparency = 1.000
avt.BorderColor3 = Color3.fromRGB(0, 0, 0)
avt.BorderSizePixel = 0
avt.Position = UDim2.new(0, 0, 0.172619045, 0)
avt.Size = UDim2.new(0, 273, 0, 278)
avt.Image = "http://www.roblox.com/asset/?id=16015421742"
TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.135036498, 0, 0.318452388, 0)
TextBox.Size = UDim2.new(0, 200, 0, 50)
TextBox.Font = Enum.Font.SourceSans
TextBox.PlaceholderText = "enter name"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextScaled = true
TextBox.TextSize = 14.000
TextBox.TextWrapped = true
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.135036498, 0, 0.589285731, 0)
TextButton.Size = UDim2.new(0, 200, 0, 50)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "kill skid fr"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true

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
dragify(Frame)

TextButton.MouseButton1Click:Connect(function()
	local t = TextBox.Text
	if t == "all" then
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name ~= game.Players.LocalPlayer.Name then
				local args = {
					[1] = "Revolver",
					[2] = v.Name,
					[3] = {
						[1] = "GunDefault",
						[2] = "Torso",
						[3] = Vector3.new(0,0,0),
						[4] = "Default"
					}
				}
				workspace.GameMain.Triggers.ServerRequest.Damage:FireServer(unpack(args))
			end
		end
	else
		local args = {
			[1] = "Revolver",
			[2] = t,
			[3] = {
				[1] = "GunDefault",
				[2] = "Torso",
				[3] = Vector3.new(0,0,0),
				[4] = "Default"
			}
		}
		workspace.GameMain.Triggers.ServerRequest.Damage:FireServer(unpack(args))
	end
end)
