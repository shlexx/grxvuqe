local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(1, 1)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(1, 0, 1.00100005, 0)
Frame.Size = UDim2.new(0, 150, 0, 50)

TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(-4.2317708e-05, 0, -0.0245114136, 0)
TextBox.Size = UDim2.new(0, 150, 0, 25)
TextBox.Font = Enum.Font.SourceSansBold
TextBox.PlaceholderText = "ENTER CHEAT CODE"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14.000
TextBox.ClearTextOnFocus = false

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(-4.2317708e-05, 0, 0.474089652, 0)
TextButton.Size = UDim2.new(0, 150, 0, 25)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "execute"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14.000
TextButton.MouseButton1Click:Connect(function()
	local t = TextBox.Text
	local args = t:split(" ")
	if args[1] == "kill" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				game:GetService("ReplicatedStorage").Network:FindFirstChild("Tools: Use"):FireServer("Sniper", v.Character.Humanoid, v.Character.Humanoid:FindFirstChild("Head"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					game:GetService("ReplicatedStorage").Network:FindFirstChild("Tools: Use"):FireServer("Sniper", v.Character.Humanoid, v.Character.Humanoid:FindFirstChild("Head"))
				end
			end
		else
			game:GetService("ReplicatedStorage").Network:FindFirstChild("Tools: Use"):FireServer("Sniper", game.Players:FindFirstChild(tostring(args[2])).Character.Humanoid, game.Players:FindFirstChild(tostring(args[2])).Character.Humanoid:FindFirstChild("Head"))
		end
	elseif args[1] == "tase" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				game:GetService("ReplicatedStorage").Network:FindFirstChild("Tools: Use"):FireServer("Taser", v.Character.Humanoid, v.Character.Humanoid.Hitbox)
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name = game.Players.LocalPlayer.Name then else
					game:GetService("ReplicatedStorage").Network:FindFirstChild("Tools: Use"):FireServer("Taser", v.Character.Humanoid, v.Character.Humanoid.Hitbox)
				end
			end
		else
			game:GetService("ReplicatedStorage").Network:FindFirstChild("Tools: Use"):FireServer("Taser", game.Players:FindFirstChild(tostring(args[2])).Character.Humanoid, game.Players:FindFirstChild(tostring(args[2])).Character.Humanoid.Hitbox)
		end
	end
end)
