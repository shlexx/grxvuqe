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
	if args[1] == "equip" then
		if args[2] == "Apex" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Apex"))
		elseif args[2] == "RGBBlossom" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("RGBBlossom"))
		elseif args[2] == "Bloodlust" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Bloodlust"))
		elseif args[2] == "Blossom" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Blossom"))
		elseif args[2] == "Cataclysm" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Cataclysm"))
		elseif args[2] == "Dutchman" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Dutchman"))
		elseif args[2] == "Impeach" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Impeach"))
		elseif args[2] == "Genesis" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Genesis"))
		elseif args[2] == "History" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("History"))
		elseif args[2] == "Hugepeached" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Hugepeached"))
		elseif args[2] == "AbyssalHunter" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("AbyssalHunter"))
		elseif args[2] == "Impeached" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Impeached"))
		elseif args[2] == "Iridescent" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Iridescent"))
		elseif args[2] == "Archangel" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Archangel"))
		elseif args[2] == "Lightning" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Lightning"))
		elseif args[2] == "Matrix" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Matrix"))
		elseif args[2] == "Oppression" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Oppression"))
		elseif args[2] == "Overture" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Overture"))
		elseif args[2] == "Gargantua" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Gargantua"))
		elseif args[2] == "Radiant" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Radiant"))
		elseif args[2] == "RoadTrip" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("RoadTrip"))
		elseif args[2] == "Sovereign" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Sovereign"))
		elseif args[2] == "Layers" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Layers"))
		elseif args[2] == "Symphony" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Symphony"))
		elseif args[2] == "Oblivion" then
			game.ReplicatedStorage.Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage"):WaitForChild("Auras"):WaitForChild("Oblivion"))
		end
	elseif t == "unequip" then
		game.ReplicatedStorage.Remotes.AuraUnequipAll:FireServer()
	end
end)
