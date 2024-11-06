local admingun = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local name = Instance.new("TextLabel")
local guns = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local gun = Instance.new("TextLabel")
local equip = Instance.new("TextButton")

admingun.Name = ".admingun"
admingun.Parent = game.CoreGui

main.Name = "main"
main.Parent = admingun
main.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
main.BorderColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.390670568, 0, 0.3115578, 0)
main.Size = UDim2.new(0, 300, 0, 300)

name.Name = "name"
name.Parent = main
name.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
name.BorderColor3 = Color3.fromRGB(0, 0, 0)
name.BorderSizePixel = 0
name.Size = UDim2.new(0, 300, 0, 25)
name.Font = Enum.Font.Code
name.Text = "Admin Guns"
name.TextColor3 = Color3.fromRGB(255, 255, 255)
name.TextSize = 14.000
name.TextWrapped = true

guns.Name = "guns"
guns.Parent = main
guns.Active = true
guns.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
guns.BackgroundTransparency = 1.000
guns.BorderColor3 = Color3.fromRGB(0, 0, 0)
guns.BorderSizePixel = 0
guns.CanvasSize = UDim2.new(0, 0, 20, 0)
guns.Position = UDim2.new(0, 0, 0.0833333358, 0)
guns.Size = UDim2.new(0, 300, 0, 275)

UIListLayout.Parent = guns
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

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

function add(name)
	local gun = Instance.new("TextLabel")
	local equip = Instance.new("TextButton")
	gun.Name = "gun"
	gun.Parent = guns
	gun.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
	gun.BorderColor3 = Color3.fromRGB(0, 0, 0)
	gun.BorderSizePixel = 0
	gun.Size = UDim2.new(0, 300, 0, 50)
	gun.Font = Enum.Font.Code
	gun.Text = " " .. name
	gun.TextColor3 = Color3.fromRGB(255, 255, 255)
	gun.TextSize = 20.000
	gun.TextXAlignment = Enum.TextXAlignment.Left
	equip.Name = "equip"
	equip.Parent = gun
	equip.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	equip.BorderColor3 = Color3.fromRGB(0, 0, 0)
	equip.BorderSizePixel = 0
	equip.Position = UDim2.new(0.583333313, 0, 0.200000003, 0)
	equip.Size = UDim2.new(0, 100, 0, 30)
	equip.Font = Enum.Font.Code
	equip.Text = "Equip Gun"
	equip.TextColor3 = Color3.fromRGB(255, 255, 255)
	equip.TextSize = 14.000
	equip.MouseButton1Click:Connect(function()
		game.ReplicatedStorage.NetworkEvents.RemoteEvent:FireServer("SERVER_EQUIP_GUN",name)
	end)
end

for _,v in ipairs(game.ReplicatedStorage.Assets.Guns:GetChildren()) do
	add(v.Name)
end
