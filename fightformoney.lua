local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

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
	local sarg = tonumber(args[2])
	if args[1] == "strength" then
		game.ReplicatedStorage.Event.Train:FireServer(sarg)
	elseif args[1] == "wins" then
		game.ReplicatedStorage.Event.WinGain:FireServer(sarg)
	elseif args[1] == "rebirth" then
		game.ReplicatedStorage.Event.HealthAdd:FireServer(0)
	elseif args[1] == "sword" then
		if args[2] == "all" then
			for i,v in pairs(game.Players:GetPlayers()) do
				game.ReplicatedStorage.Event.EquipEffect:FireServer(tostring(args[3]), workspace:WaitForChild(tostring(v.Name)))
			end
		elseif args[2] == "me" then
			game.ReplicatedStorage.Event.EquipEffect:FireServer(tostring(args[3]), workspace:WaitForChild(tostring(game.Players.LocalPlayer.Name)))
		else
			local msg = tostring(args[2])

			local function findPlayer(stringg)
				for _, v in pairs(game.Players:GetPlayers()) do
					if stringg:lower() == (v.Name:lower()):sub(1, #stringg) then
						return v
					end
				end
			end

			local player = findPlayer(msg)
			game.ReplicatedStorage.Event.EquipEffect:FireServer(tostring(args[3]), workspace:WaitForChild(player.Name))
		end
	elseif args[1] == "tpw" then
		local wnum = tonumber(args[2])
		local rpart = game.Players.LocalPlayer.Character.HumanoidRootPart
		game:GetService("ReplicatedStorage").PEV.PTP:FireServer("W" .. wnum)
		if wnum == 1 then
			rpart.CFrame = CFrame.new(-2.281571388244629, 38.41089630126953, -405.0544738769531)
		elseif wnum == 2 then
			rpart.CFrame = CFrame.new(-141.9577178955078, 38.077117919921875, 1948.8775634765625)
		elseif wnum == 3 then
			rpart.CFrame = CFrame.new(-2.68959379196167, 49.52509689331055, 4555.0810546875)
		elseif wnum == 4 then
			rpart.CFrame = CFrame.new(5.305574417114258, 48.773460388183594, 7771.18212890625)
		end
	elseif args[1] == "hatch" then
		local petlist = {
			["Doggy"] = "Starter",
			["Kitty"] = "Starter",
			["Mouse"] = "Starter",
			["Piggy"] = "Grass",
			["Bird"] = "Grass",
			["Crocodile"] = "Wild",
			["Ant"] = "Wild",
			["Stegosaurus"] = "Wild",
			["Fish"] = "Cyro",
			["Shark"] = "Cyro",
			["Reindeer"] = "Cyro",
			["Glacier"] = "Frostflare",
			["Sloth"] = "Sand",
			["Bolt"] = "Sand",
			["Flamingo"] = "Tropical",
			["Parrot"] = "Exotic",
			["Banana"] = "Exotic",
			["Tiger"] = "Exotic",
			["Celestia"] = "Exotic",
			["Crow"] = "Sinister",
			["Sugarflare"] = "Sinister",
			["Enchantico"] = "Nethera",
			["Demon"] = "Abyss",
			["Phoenix"] = "Abyss",
			["Flamethrower"] = "Abyss",
			["Sundo"] = "Shop1",
			["Hotdog"] = "Shop1",
			["Seraph"] = "Shop1",
			["Warpeeler"] = "Shop1",
		}
		
		local spacepetlist = {
			["Sapphire Dragon"] = "Grass",
			["Fairy Chihuahua"] = "Wild",
			["Blue Dominus"] = "Frostflare",
			["Arctic Golem"] = "Frostflare",
			["Mutant Purp"] = "Subo",
			["Space Kitty"] = "Subo",
			["Crystal Lord"] = "Subo",
			["Soul Golem"] = "Subo",
			["Sand Spider"] = "Sand",
			["Pineapple Cat"] = "Tropical",
			["King Ant"] = "Tropical",
			["Witch Dragon"] = "Sinister",
			["Mystery Cat"] = "Nethera",
			["Magma Golem"] = "Nethera",
			["Soul Warden"] = "Abyss",
		}
		
		for i,v in pairs(petlist) do
			if args[2] == i then
				game.ReplicatedStorage.PEV.Hatch:FireServer(v,i,1)
			end
		end
		
		for a,b in pairs(spacepetlist) do
			if args[2] .. " " .. args[3] == a then
				game.ReplicatedStorage.PEV.Hatch:FireServer(b,a,1)
			end
		end
	elseif args[1] == "getsword" then
		game:GetService("ReplicatedStorage").Event.BuyPower:FireServer(tostring(args[2]), 0)
	end
end)
