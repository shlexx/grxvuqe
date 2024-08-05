local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local ImageLabel_2 = Instance.new("ImageLabel")
local TextLabel = Instance.new("TextLabel")
local target = Instance.new("TextBox")
local TextLabel_2 = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local defaultprefix = "/"

function Destroy(ins)
	spawn(function()
		for _,v in pairs(game.ReplicatedStorage:GetDescendants()) do
			if v.Name == "DeleteCar" then
				v:FireServer(ins)
			end
		end
	end)
end

function getChar(plr)
	local chr = workspace:WaitForChild(plr.Name) or workspace:WaitForChild(plr.DisplayName)
	return chr
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
Frame.BackgroundTransparency = 0.500
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 400, 0, 152)
Frame.Visible = false

UICorner.Parent = Frame

ImageLabel.Parent = Frame
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.0500000007, 0, 0.230263159, 0)
ImageLabel.Size = UDim2.new(0, 20, 0, 20)
ImageLabel.Image = "http://www.roblox.com/asset/?id=2418686949"

ImageLabel_2.Parent = Frame
ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_2.BackgroundTransparency = 1.000
ImageLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel_2.BorderSizePixel = 0
ImageLabel_2.Position = UDim2.new(0.0500000007, 0, 0.638157904, 0)
ImageLabel_2.Size = UDim2.new(0, 20, 0, 20)
ImageLabel_2.Image = "http://www.roblox.com/asset/?id=2418686949"

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.147499993, 0, 0.230263159, 0)
TextLabel.Size = UDim2.new(0, 1, 0, 20)
TextLabel.Font = Enum.Font.Code
TextLabel.Text = "$cmd"
TextLabel.TextColor3 = Color3.fromRGB(98, 255, 0)
TextLabel.TextSize = 14.000
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

target.Name = "target"
target.Parent = Frame
target.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
target.BackgroundTransparency = 1.000
target.BorderColor3 = Color3.fromRGB(0, 0, 0)
target.BorderSizePixel = 0
target.Position = UDim2.new(0.25, 0, 0.230263159, 0)
target.Size = UDim2.new(0, 200, 0, 20)
target.ClearTextOnFocus = false
target.Font = Enum.Font.Code
target.Text = ""
target.TextColor3 = Color3.fromRGB(255, 255, 255)
target.TextSize = 14.000
target.TextWrapped = true
target.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_2.Parent = Frame
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.150000006, 0, 0.638157904, 0)
TextLabel_2.Size = UDim2.new(0, 340, 0, 20)
TextLabel_2.Font = Enum.Font.Code
TextLabel_2.Text = ""
TextLabel_2.TextColor3 = Color3.fromRGB(98, 255, 0)
TextLabel_2.TextSize = 14.000
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Return then
		local msg = target.Text
		local args = msg:split(" ")
		Frame.SelectionLost:Connect(function()
			print("no selection")
		end)
		if args[1] == defaultprefix .. "bald" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					repeat
						wait(0.1)
						Destroy(vchar:FindFirstChildOfClass("Accessory"))
					until vchar:FindFirstChildOfClass("Accessory") == nil
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						repeat
							wait(0.1)
							Destroy(vchar:FindFirstChildOfClass("Accessory"))
						until vchar:FindFirstChildOfClass("Accessory") == nil
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				repeat
					wait(0.1)
					Destroy(pchar:FindFirstChildOfClass("Accessory"))
				until pchar:FindFirstChildOfClass("Accessory") == nil
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "ragdoll" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Humanoid"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar:FindFirstChildOfClass("Humanoid"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar:FindFirstChildOfClass("Humanoid"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "kill" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar.Head)
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar.Head)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar.Head)
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "naked" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar.Shirt)
					Destroy(vchar.Pants)
					Destroy(vchar["Shirt Graphic"])
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar.Shirt)
						Destroy(vchar.Pants)
						Destroy(vchar["Shirt Graphic"])
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar.Shirt)
				Destroy(pchar.Pants)
				Destroy(pchar["Shirt Graphic"])
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "goto" then
			local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			getRoot(Players.LocalPlayer.Character).CFrame = getRoot(pchar).CFrame + Vector3.new(3,1,0)
			TextLabel_2.Text = "Succesfully executed."
		elseif args[1] == defaultprefix .. "rtools" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					for _, x in pairs(v:FindFirstChildOfClass("Backpack"):GetChildren()) do
						Destroy(x)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						for _, x in pairs(v:FindFirstChildOfClass("Backpack"):GetChildren()) do
							Destroy(x)
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local p = Players:WaitForChild(tostring(args[2]))
				for _, x in pairs(p:FindFirstChildOfClass("Backpack"):GetChildren()) do
					Destroy(x)
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "box" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					for i, x in pairs(vchar:GetChildren()) do
						if x:IsA("Accessory") then
							Destroy(x)
						end
					end
					for i, x in pairs(vchar:GetChildren()) do
						if x:IsA("CharacterMesh") then
							Destroy(x)
						end
					end
					Destroy(vchar:FindFirstChildOfClass("Pants"))
					Destroy(vchar:FindFirstChildOfClass("Shirt"))
					Destroy(vchar:FindFirstChildOfClass("ShirtGraphic"))
					Destroy(vchar["Left Arm"])
					Destroy(vchar["Left Leg"])
					Destroy(vchar["Right Arm"])
					Destroy(vchar["Right Leg"])
					Destroy(vchar.Head:FindFirstChildOfClass("SpecialMesh"))
					Destroy(vchar.Head:FindFirstChildOfClass("Decal"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						for i, x in pairs(vchar:GetChildren()) do
							if x:IsA("Accessory") then
								Destroy(x)
							end
						end
						for i, x in pairs(vchar:GetChildren()) do
							if x:IsA("CharacterMesh") then
								Destroy(x)
							end
						end
						Destroy(vchar:FindFirstChildOfClass("Pants"))
						Destroy(vchar:FindFirstChildOfClass("Shirt"))
						Destroy(vchar:FindFirstChildOfClass("ShirtGraphic"))
						Destroy(vchar["Left Arm"])
						Destroy(vchar["Left Leg"])
						Destroy(vchar["Right Arm"])
						Destroy(vchar["Right Leg"])
						Destroy(vchar.Head:FindFirstChildOfClass("SpecialMesh"))
						Destroy(vchar.Head:FindFirstChildOfClass("Decal"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				for i, x in pairs(pchar:GetChildren()) do
					if x:IsA("Accessory") then
						Destroy(x)
					end
				end
				for i, x in pairs(pchar:GetChildren()) do
					if x:IsA("CharacterMesh") then
						Destroy(x)
					end
				end
				Destroy(pchar:FindFirstChildOfClass("Pants"))
				Destroy(pchar:FindFirstChildOfClass("Shirt"))
				Destroy(pchar:FindFirstChildOfClass("ShirtGraphic"))
				Destroy(pchar["Left Arm"])
				Destroy(pchar["Left Leg"])
				Destroy(pchar["Right Arm"])
				Destroy(pchar["Right Leg"])
				Destroy(pchar.Head:FindFirstChildOfClass("SpecialMesh"))
				Destroy(pchar.Head:FindFirstChildOfClass("Decal"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "sink" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar.HumanoidRootPart)
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar.HumanoidRootPart)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar.HumanoidRootPart)
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "del" then
			for _,v in pairs(game:GetDescendants()) do
				if v.Name == args[2] then
					Destroy(v)
				end
			end
			TextLabel_2.Text = "Succesfully executed."
		elseif args[1] == defaultprefix .. "explorer" then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexx/grxvuqe/main/dex.lua"))()
			TextLabel_2.Text = "Succesfully executed."
		elseif args[1] == defaultprefix .. "slock" then
			Players.PlayerAdded:Connect(function(pl)
				wait(0.5)
				Destroy(pl)
			end)
			TextLabel_2.Text = "Succesfully executed."
		elseif args[1] == defaultprefix .. "kick" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					Destroy(v)
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						Destroy(v)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local p = Players:WaitForChild(tostring(args[2]))
				Destroy(p)
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "blockhead" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar.Head:FindFirstChildOfClass("SpecialMesh"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar.Head:FindFirstChildOfClass("SpecialMesh"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar.Head:FindFirstChildOfClass("SpecialMesh"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "stools" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Humanoid"))
					repeat wait() until vchar:FindFirstChildOfClass("Humanoid").Parent == nil
					for _, x in ipairs(vchar:GetChildren()) do
						if x:IsA("BackpackItem") and x:FindFirstChild("Handle") then
							Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(x)
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar:FindFirstChildOfClass("Humanoid"))
						repeat wait() until vchar:FindFirstChildOfClass("Humanoid").Parent == nil
						for _, x in ipairs(vchar:GetChildren()) do
							if x:IsA("BackpackItem") and x:FindFirstChild("Handle") then
								Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(x)
							end
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar:FindFirstChildOfClass("Humanoid"))
				repeat wait() until pchar:FindFirstChildOfClass("Humanoid").Parent == nil
				for _, x in ipairs(pchar:GetChildren()) do
					if x:IsA("BackpackItem") and x:FindFirstChild("Handle") then
						Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(x)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "noface" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar.Head:FindFirstChildOfClass("Decal"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar.Head:FindFirstChildOfClass("Decal"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar.Head:FindFirstChildOfClass("Decal"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "punish" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar)
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar)
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "pantsless" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Pants"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar:FindFirstChildOfClass("Pants"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar:FindFirstChildOfClass("Pants"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "shirtless" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Shirt"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar:FindFirstChildOfClass("Shirt"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar:FindFirstChildOfClass("Shirt"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "tshirtless" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("ShirtGraphic"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar:FindFirstChildOfClass("ShirtGraphic"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar:FindFirstChildOfClass("ShirtGraphic"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "noregen" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChild("Health"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar:FindFirstChild("Health"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar:FindFirstChild("Health"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "stopanim" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator"))
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						Destroy(vchar:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator"))
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				Destroy(pchar:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator"))
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "blockchar" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					for i, x in pairs(vchar:GetChildren()) do
						if x:IsA("CharacterMesh") then
							Destroy(x)
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						for i, x in pairs(vchar:GetChildren()) do
							if x:IsA("CharacterMesh") then
								Destroy(x)
							end
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				for i, x in pairs(pchar:GetChildren()) do
					if x:IsA("CharacterMesh") then
						Destroy(x)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "nolimbs" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
						Destroy(vchar["Left Arm"])
						Destroy(vchar["Left Leg"])
						Destroy(vchar["Right Arm"])
						Destroy(vchar["Right Leg"])
					else
						Destroy(vchar["LeftUpperArm"])
						Destroy(vchar["LeftUpperLeg"])
						Destroy(vchar["RightUpperArm"])
						Destroy(vchar["RightUpperLeg"])
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
							Destroy(vchar["Left Arm"])
							Destroy(vchar["Left Leg"])
							Destroy(vchar["Right Arm"])
							Destroy(vchar["Right Leg"])
						else
							Destroy(vchar["LeftUpperArm"])
							Destroy(vchar["LeftUpperLeg"])
							Destroy(vchar["RightUpperArm"])
							Destroy(vchar["RightUpperLeg"])
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
					Destroy(pchar["Left Arm"])
					Destroy(pchar["Left Leg"])
					Destroy(pchar["Right Arm"])
					Destroy(pchar["Right Leg"])
				else
					Destroy(pchar["LeftUpperArm"])
					Destroy(pchar["LeftUpperLeg"])
					Destroy(pchar["RightUpperArm"])
					Destroy(pchar["RightUpperLeg"])
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "nola" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
						Destroy(vchar["Left Arm"])
					else
						Destroy(vchar["LeftUpperArm"])
						Destroy(vchar["LeftLowerArm"])
						Destroy(vchar["LeftHand"])
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
							Destroy(vchar["Left Arm"])
						else
							Destroy(vchar["LeftUpperArm"])
							Destroy(vchar["LeftLowerArm"])
							Destroy(vchar["LeftHand"])
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
					Destroy(pchar["Left Arm"])
				else
					Destroy(pchar["LeftUpperArm"])
					Destroy(pchar["LeftLowerArm"])
					Destroy(pchar["LeftHand"])
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "noll" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
						Destroy(vchar["Left Leg"])
					else
						Destroy(vchar["LeftUpperLeg"])
						Destroy(vchar["LeftLowerLeg"])
						Destroy(vchar["LeftFoot"])
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
							Destroy(vchar["Left Leg"])
						else
							Destroy(vchar["LeftUpperLeg"])
							Destroy(vchar["LeftLowerLeg"])
							Destroy(vchar["LeftFoot"])
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
					Destroy(pchar["Left Leg"])
				else
					Destroy(pchar["LeftUpperLeg"])
					Destroy(pchar["LeftLowerLeg"])
					Destroy(pchar["LeftFoot"])
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "nora" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
						Destroy(vchar["Right Arm"])
					else
						Destroy(vchar["RightUpperArm"])
						Destroy(vchar["RightLowerArm"])
						Destroy(vchar["RightHand"])
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
							Destroy(vchar["Right Arm"])
						else
							Destroy(vchar["RightUpperArm"])
							Destroy(vchar["RightLowerArm"])
							Destroy(vchar["RightHand"])
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
					Destroy(pchar["Right Arm"])
				else
					Destroy(pchar["RightUpperArm"])
					Destroy(pchar["RightLowerArm"])
					Destroy(pchar["RightHand"])
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "norl" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
						Destroy(vchar["Right Leg"])
					else
						Destroy(vchar["RightUpperLeg"])
						Destroy(vchar["RightLowerLeg"])
						Destroy(vchar["RightFoot"])
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
							Destroy(vchar["Right Leg"])
						else
							Destroy(vchar["RightUpperLeg"])
							Destroy(vchar["RightLowerLeg"])
							Destroy(vchar["RightFoot"])
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
					Destroy(pchar["Right Leg"])
				else
					Destroy(pchar["RightUpperLeg"])
					Destroy(pchar["RightLowerLeg"])
					Destroy(pchar["RightFoot"])
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "nowaist" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
						Destroy(vchar.UpperTorso.Waist)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
							Destroy(vchar.UpperTorso.Waist)
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
					Destroy(pchar.UpperTorso.Waist)
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == defaultprefix .. "noroot" then
			if args[2] == "all" then
				for _,v in pairs(game.Players:GetPlayers()) do
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
						Destroy(vchar.LowerTorso.Root)
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			elseif args[2] == "others" then
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Name == game.Players.LocalPlayer.Name then else
						local vchar = getChar(v)
						if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
							Destroy(vchar.LowerTorso.Root)
						end
					end
				end
				TextLabel_2.Text = "Succesfully executed."
			else
				local pchar = getChar(Players:WaitForChild(tostring(args[2])))
				if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
					Destroy(pchar.LowerTorso.Root)
				end
				TextLabel_2.Text = "Succesfully executed."
			end
		elseif args[1] == "prefix" then
			if string.len(args[2]) == 1 or string.len(args[2]) == 0 then
				defaultprefix = args[2]
				TextLabel_2.Text = "Succesfully changed the prefix."
			else
				TextLabel_2.Text = "Prefix is more than 1 character. Failed."
			end
		elseif msg == defaultprefix .. "r" then
			Frame.Size = UDim2.new(0, 400, 0, 152)
			TextLabel_2.Text = ""
			TextLabel_2.Position = UDim2.new(0.150000006, 0, 0.638157904, 0)
			target.Position = UDim2.new(0.25, 0, 0.230263159, 0)
			ImageLabel.Position = UDim2.new(0.0500000007, 0, 0.230263159, 0)
			ImageLabel_2.Position = UDim2.new(0.0500000007, 0, 0.638157904, 0)
			TextLabel.Position = UDim2.new(0.147499993, 0, 0.230263159, 0)
		elseif args[1] == defaultprefix .. "cmds" or args[1] == defaultprefix .. "help" then
			Frame.Size = UDim2.new(0, 400, 0, 600)
			ImageLabel.Position = UDim2.new(0.0500000007, 0, 0.0585965216, 0)
			ImageLabel_2.Position = UDim2.new(0.0500000007, 0, 0.125157908, 0)
			TextLabel.Position = UDim2.new(0.150000006, 0, 0.0585965216, 0)
			target.Position = UDim2.new(0.25, 0, 0.0585965216, 0)
			TextLabel_2.Position = UDim2.new(0.152500004, 0, 0.482824564, 0)
			TextLabel_2.Text = "bald <player/all/others> - makes the player bald\nragdoll <player/all/others> - makes the player ragdoll\nkill <player/all/others> - kills the specific player\ngoto <player> - teleports to the player\nnaked <player/all/others> - removes the player's clothes [winkyface]\nrtools <player/all/others> - removes the player's tools\nbox <player/all/others> - makes the player a box\nsink <player/all/others> - sinks the player (seizure)\ndel <name> - deletes a part with the given name\nexplorer - gives you an explorer\nslock - server lock\nkick <player/all/others> - kicks the player\nblockhead <player/all/others> - makes the player's head a square\stools <player/all/others> - i have no idea what this does, maybe broken\nnoface <player/all/others> - deletes the player's face\npunish <player/all/others> - punishes the player\npantsless <player/all/others> - deletes the player's pants\nshirtless <player/all/others> - deletes the player's shirt\ntshirtless <player/all/others> - deletes the player's tshirt\nnoregen <player/all/others> - makes the player never gain health\nstopanim <player/all/others> - stops the animation of the player\nblockchar <player/all/others> - makes the player blocky\nnolimbs <player/all/others> - removes the player's limbs\nnola <player/all/others> - deletes the player's left arm\nnoll <player/all/others> - deletes the player's left leg\nnorl <player/all/others> - deletes the player's right leg\nnora <player/all/others> - deletes the player's right arm\nnowaist <player/all/others> - deletes the player's waist\nnoroot <player/all/others> - deletes the player's root\nr - reset the command bar\nprefix <character> - makes the character the prefix\ncmds/help - show commands"
		else
			TextLabel_2.Text = "Invalid command or prefix."
		end
	msg = ""
	elseif input.KeyCode == Enum.KeyCode.F2 then
		if Frame.Visible == false then
			Frame.Visible = true
		else
			Frame.Visible = false
		end
	end
end)
