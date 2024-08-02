local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local target = Instance.new("TextBox")
local exe = Instance.new("TextButton")
local cmd = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local ScrollingFrame = Instance.new("ScrollingFrame")
local Frame_2 = Instance.new("Frame")
local TextLabel_2 = Instance.new("TextLabel")
local TextLabel_3 = Instance.new("TextLabel")
local TextLabel_4 = Instance.new("TextLabel")
local TextLabel_5 = Instance.new("TextLabel")
local TextLabel_6 = Instance.new("TextLabel")
local TextLabel_7 = Instance.new("TextLabel")
local TextLabel_8 = Instance.new("TextLabel")
local TextLabel_9 = Instance.new("TextLabel")
local TextLabel_10 = Instance.new("TextLabel")
local TextLabel_11 = Instance.new("TextLabel")
local TextLabel_12 = Instance.new("TextLabel")
local TextLabel_13 = Instance.new("TextLabel")
local TextLabel_14 = Instance.new("TextLabel")
local TextLabel_15 = Instance.new("TextLabel")
local TextLabel_16 = Instance.new("TextLabel")
local TextLabel_17 = Instance.new("TextLabel")
local TextLabel_18 = Instance.new("TextLabel")
local TextLabel_19 = Instance.new("TextLabel")
local TextLabel_20 = Instance.new("TextLabel")
local TextLabel_21 = Instance.new("TextLabel")
local TextLabel_22 = Instance.new("TextLabel")
local TextLabel_23 = Instance.new("TextLabel")
local TextLabel_24 = Instance.new("TextLabel")
local TextLabel_25 = Instance.new("TextLabel")
local TextLabel_26 = Instance.new("TextLabel")
local TextLabel_27 = Instance.new("TextLabel")
local TextLabel_28 = Instance.new("TextLabel")
local TextLabel_29 = Instance.new("TextLabel")
local TextLabel_30 = Instance.new("TextLabel")
local clos = Instance.new("ImageButton")
local serch = Instance.new("ImageButton")
local TextBox = Instance.new("TextBox")
local Players = game:GetService("Players")

function Destroy(ins)
	spawn(function()
		for _,v in pairs(game:GetDescendants()) do
			if v:IsA("RemoveEvent") and v.Name == "DestroySegway" then
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

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(1, 1)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(1, 0, 1.00100005, 0)
Frame.Size = UDim2.new(0, 150, 0, 50)

target.Name = "target"
target.Parent = Frame
target.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
target.BorderColor3 = Color3.fromRGB(0, 0, 0)
target.BorderSizePixel = 0
target.Position = UDim2.new(-4.2317708e-05, 0, -0.0245114136, 0)
target.Size = UDim2.new(0, 150, 0, 25)
target.ClearTextOnFocus = false
target.Font = Enum.Font.SourceSansBold
target.PlaceholderText = "ENTER CHEAT CODE"
target.Text = ""
target.TextColor3 = Color3.fromRGB(255, 255, 255)
target.TextSize = 14.000

exe.Name = "exe"
exe.Parent = Frame
exe.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
exe.BorderColor3 = Color3.fromRGB(0, 0, 0)
exe.BorderSizePixel = 0
exe.Position = UDim2.new(-4.2317708e-05, 0, 0.474089652, 0)
exe.Size = UDim2.new(0, 150, 0, 25)
exe.Font = Enum.Font.SourceSansBold
exe.Text = "execute"
exe.TextColor3 = Color3.fromRGB(255, 255, 255)
exe.TextSize = 14.000
exe.MouseButton1Click:Connect(function()
	local msg = target.Text
	local args = msg:split(" ")
	if args[1] == "bald" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				repeat
					wait(0.1)
					Destroy(vchar:FindFirstChildOfClass("Accessory"))
				until vchar:FindFirstChildOfClass("Accessory") == nil
			end
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
		else
			local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			repeat
				wait(0.1)
				Destroy(pchar:FindFirstChildOfClass("Accessory"))
			until pchar:FindFirstChildOfClass("Accessory") == nil
		end
	elseif args[1] == "ragdoll" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar:FindFirstChildOfClass("Humanoid"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Humanoid"))
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar:FindFirstChildOfClass("Humanoid"))
		end
	elseif args[1] == "kill" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar.Head)
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar.Head)
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar.Head)
		end
	elseif args[1] == "naked" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar.Shirt)
				Destroy(vchar.Pants)
				Destroy(vchar["Shirt Graphic"])
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar.Shirt)
					Destroy(vchar.Pants)
					Destroy(vchar["Shirt Graphic"])
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar.Shirt)
			Destroy(pchar.Pants)
			Destroy(pchar["Shirt Graphic"])
		end
	elseif args[1] == "goto" then
		local pchar = getChar(Players:WaitForChild(tostring(args[2])))
		if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
			Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false
			wait(.1)
		end
		getRoot(Players.LocalPlayer.Character).CFrame = getRoot(pchar).CFrame + Vector3.new(3,1,0)
	elseif args[1] == "rtools" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				for _, x in pairs(v:FindFirstChildOfClass("Backpack"):GetChildren()) do
					Destroy(x)
				end
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					for _, x in pairs(v:FindFirstChildOfClass("Backpack"):GetChildren()) do
						Destroy(x)
					end
				end
			end
		else
		    local p = Players:WaitForChild(tostring(args[2]))
			for _, x in pairs(p:FindFirstChildOfClass("Backpack"):GetChildren()) do
				Destroy(x)
			end
		end
	elseif args[1] == "box" then
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
		end
	elseif args[1] == "sink" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar.HumanoidRootPart)
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar.HumanoidRootPart)
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar.HumanoidRootPart)
		end
	elseif args[1] == "del" then
		for _,v in pairs(game:GetDescendants()) do
			if v.Name == args[2] then
				Destroy(v)
			end
		end
	elseif args[1] == "explorer" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexx/grxvuqe/main/dex.lua"))()
	elseif args[1] == "slock" then
		Players.PlayerAdded:Connect(function(pl)
		    wait(0.5)
			Destroy(pl)
		end)
	elseif args[1] == "kick" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				Destroy(v)
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					Destroy(v)
				end
			end
		else
		    local p = Players:WaitForChild(tostring(args[2]))
			Destroy(p)
		end
	elseif args[1] == "blockhead" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar.Head:FindFirstChildOfClass("SpecialMesh"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar.Head:FindFirstChildOfClass("SpecialMesh"))
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar.Head:FindFirstChildOfClass("SpecialMesh"))
		end
	elseif args[1] == "stools" then
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
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar:FindFirstChildOfClass("Humanoid"))
			repeat wait() until pchar:FindFirstChildOfClass("Humanoid").Parent == nil
			for _, x in ipairs(pchar:GetChildren()) do
				if x:IsA("BackpackItem") and x:FindFirstChild("Handle") then
					Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(x)
				end
			end
		end
	elseif args[1] == "noface" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar.Head:FindFirstChildOfClass("Decal"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar.Head:FindFirstChildOfClass("Decal"))
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar.Head:FindFirstChildOfClass("Decal"))
		end
	elseif args[1] == "punish" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar)
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar)
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar)
		end
	elseif args[1] == "pantsless" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar:FindFirstChildOfClass("Pants"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Pants"))
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar:FindFirstChildOfClass("Pants"))
		end
	elseif args[1] == "shirtless" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar:FindFirstChildOfClass("Shirt"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Shirt"))
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar:FindFirstChildOfClass("Shirt"))
		end
	elseif args[1] == "tshirtless" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar:FindFirstChildOfClass("ShirtGraphic"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("ShirtGraphic"))
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar:FindFirstChildOfClass("ShirtGraphic"))
		end
	elseif args[1] == "noregen" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar:FindFirstChild("Health"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChild("Health"))
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar:FindFirstChild("Health"))
		end
	elseif args[1] == "stopanim" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				Destroy(vchar:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator"))
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					Destroy(vchar:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator"))
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			Destroy(pchar:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator"))
		end
	elseif args[1] == "blockchar" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				for i, x in pairs(vchar:GetChildren()) do
					if x:IsA("CharacterMesh") then
						Destroy(x)
					end
				end
			end
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
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			for i, x in pairs(pchar:GetChildren()) do
				if x:IsA("CharacterMesh") then
					Destroy(x)
				end
			end
		end
	elseif args[1] == "nolimbs" then
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
		end
	elseif args[1] == "nola" then
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
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
				Destroy(pchar["Left Arm"])
			else
				Destroy(pchar["LeftUpperArm"])
				Destroy(pchar["LeftLowerArm"])
				Destroy(pchar["LeftHand"])
			end
		end
	elseif args[1] == "noll" then
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
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
				Destroy(pchar["Left Leg"])
			else
				Destroy(pchar["LeftUpperLeg"])
				Destroy(pchar["LeftLowerLeg"])
				Destroy(pchar["LeftFoot"])
			end
		end
	elseif args[1] == "nora" then
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
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
				Destroy(pchar["Right Arm"])
			else
				Destroy(pchar["RightUpperArm"])
				Destroy(pchar["RightLowerArm"])
				Destroy(pchar["RightHand"])
			end
		end
	elseif args[1] == "norl" then
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
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
				Destroy(pchar["Right Leg"])
			else
				Destroy(pchar["RightUpperLeg"])
				Destroy(pchar["RightLowerLeg"])
				Destroy(pchar["RightFoot"])
			end
		end
	elseif args[1] == "nowaist" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
					Destroy(vchar.UpperTorso.Waist)
				end
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
						Destroy(vchar.UpperTorso.Waist)
					end
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
				Destroy(pchar.UpperTorso.Waist)
			end
		end
	elseif args[1] == "noroot" then
		if args[2] == "all" then
			for _,v in pairs(game.Players:GetPlayers()) do
				local vchar = getChar(v)
				if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
					Destroy(vchar.LowerTorso.Root)
				end
			end
		elseif args[2] == "others" then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v.Name == game.Players.LocalPlayer.Name then else
					local vchar = getChar(v)
					if vchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
						Destroy(vchar.LowerTorso.Root)
					end
				end
			end
		else
		    local pchar = getChar(Players:WaitForChild(tostring(args[2])))
			if pchar:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
				Destroy(pchar.LowerTorso.Root)
			end
		end
	elseif args[1] == "cmds" then
		cmd.Visible = true
	else
		print("Invalid command")
	end
end)

cmd.Name = "cmd"
cmd.Parent = ScreenGui
cmd.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
cmd.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd.BorderSizePixel = 0
cmd.Position = UDim2.new(0.410021186, 0, 0.296992481, 0)
cmd.Size = UDim2.new(0, 254, 0, 323)
cmd.Visible = false

TextLabel.Parent = cmd
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.0787401572, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 127, 0, 17)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "vCmd"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Right

ScrollingFrame.Parent = cmd
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.BackgroundTransparency = 1.000
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, 0, 0.123839006, 0)
ScrollingFrame.Size = UDim2.new(0, 254, 0, 283)
ScrollingFrame.CanvasPosition = Vector2.new(0, 300)

Frame_2.Parent = ScrollingFrame
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BackgroundTransparency = 1.000
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0, 0, -1.07835966e-07, 0)
Frame_2.Size = UDim2.new(0, 233, 0, 520)

TextLabel_2.Parent = Frame_2
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.0257510729, 0, 0, 0)
TextLabel_2.Size = UDim2.new(0, 227, 0, 15)
TextLabel_2.Font = Enum.Font.SourceSansBold
TextLabel_2.Text = "bald <player/all/others>"
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextSize = 14.000
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_3.Parent = Frame_2
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1.000
TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0.0257510729, 0, 0.028846154, 0)
TextLabel_3.Size = UDim2.new(0, 227, 0, 15)
TextLabel_3.Font = Enum.Font.SourceSansBold
TextLabel_3.Text = "ragdoll <player/all/others>"
TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.TextSize = 14.000
TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_4.Parent = Frame_2
TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.BackgroundTransparency = 1.000
TextLabel_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_4.BorderSizePixel = 0
TextLabel_4.Position = UDim2.new(0.0257510729, 0, 0.0865384638, 0)
TextLabel_4.Size = UDim2.new(0, 227, 0, 15)
TextLabel_4.Font = Enum.Font.SourceSansBold
TextLabel_4.Text = "naked <player/all/others>"
TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.TextSize = 14.000
TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_5.Parent = Frame_2
TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.BackgroundTransparency = 1.000
TextLabel_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_5.BorderSizePixel = 0
TextLabel_5.Position = UDim2.new(0.0257510729, 0, 0.057692308, 0)
TextLabel_5.Size = UDim2.new(0, 227, 0, 15)
TextLabel_5.Font = Enum.Font.SourceSansBold
TextLabel_5.Text = "kill <player/all/others>"
TextLabel_5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.TextSize = 14.000
TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_6.Parent = Frame_2
TextLabel_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.BackgroundTransparency = 1.000
TextLabel_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_6.BorderSizePixel = 0
TextLabel_6.Position = UDim2.new(0.0257510729, 0, 0.144230768, 0)
TextLabel_6.Size = UDim2.new(0, 227, 0, 15)
TextLabel_6.Font = Enum.Font.SourceSansBold
TextLabel_6.Text = "rtools <player/all/others>"
TextLabel_6.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.TextSize = 14.000
TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_7.Parent = Frame_2
TextLabel_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_7.BackgroundTransparency = 1.000
TextLabel_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_7.BorderSizePixel = 0
TextLabel_7.Position = UDim2.new(0.0257510729, 0, 0.173076928, 0)
TextLabel_7.Size = UDim2.new(0, 227, 0, 15)
TextLabel_7.Font = Enum.Font.SourceSansBold
TextLabel_7.Text = "box <player/all/others>"
TextLabel_7.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_7.TextSize = 14.000
TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_8.Parent = Frame_2
TextLabel_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_8.BackgroundTransparency = 1.000
TextLabel_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_8.BorderSizePixel = 0
TextLabel_8.Position = UDim2.new(0.0257510729, 0, 0.201923072, 0)
TextLabel_8.Size = UDim2.new(0, 227, 0, 15)
TextLabel_8.Font = Enum.Font.SourceSansBold
TextLabel_8.Text = "sink <player/all/others>"
TextLabel_8.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_8.TextSize = 14.000
TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_9.Parent = Frame_2
TextLabel_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_9.BackgroundTransparency = 1.000
TextLabel_9.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_9.BorderSizePixel = 0
TextLabel_9.Position = UDim2.new(0.0257510729, 0, 0.115384616, 0)
TextLabel_9.Size = UDim2.new(0, 227, 0, 15)
TextLabel_9.Font = Enum.Font.SourceSansBold
TextLabel_9.Text = "goto <player>"
TextLabel_9.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_9.TextSize = 14.000
TextLabel_9.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_10.Parent = Frame_2
TextLabel_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_10.BackgroundTransparency = 1.000
TextLabel_10.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_10.BorderSizePixel = 0
TextLabel_10.Position = UDim2.new(0.0257510729, 0, 0.230769232, 0)
TextLabel_10.Size = UDim2.new(0, 227, 0, 15)
TextLabel_10.Font = Enum.Font.SourceSansBold
TextLabel_10.Text = "del <name>"
TextLabel_10.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_10.TextSize = 14.000
TextLabel_10.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_11.Parent = Frame_2
TextLabel_11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_11.BackgroundTransparency = 1.000
TextLabel_11.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_11.BorderSizePixel = 0
TextLabel_11.Position = UDim2.new(0.0257510729, 0, 0.259615391, 0)
TextLabel_11.Size = UDim2.new(0, 227, 0, 15)
TextLabel_11.Font = Enum.Font.SourceSansBold
TextLabel_11.Text = "explorer"
TextLabel_11.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_11.TextSize = 14.000
TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_12.Parent = Frame_2
TextLabel_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_12.BackgroundTransparency = 1.000
TextLabel_12.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_12.BorderSizePixel = 0
TextLabel_12.Position = UDim2.new(0.0257510729, 0, 0.317307681, 0)
TextLabel_12.Size = UDim2.new(0, 227, 0, 15)
TextLabel_12.Font = Enum.Font.SourceSansBold
TextLabel_12.Text = "kick <player/all/others>"
TextLabel_12.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_12.TextSize = 14.000
TextLabel_12.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_13.Parent = Frame_2
TextLabel_13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_13.BackgroundTransparency = 1.000
TextLabel_13.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_13.BorderSizePixel = 0
TextLabel_13.Position = UDim2.new(0.0257510729, 0, 0.346153855, 0)
TextLabel_13.Size = UDim2.new(0, 227, 0, 15)
TextLabel_13.Font = Enum.Font.SourceSansBold
TextLabel_13.Text = "blockhead <player/all/others>"
TextLabel_13.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_13.TextSize = 14.000
TextLabel_13.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_14.Parent = Frame_2
TextLabel_14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_14.BackgroundTransparency = 1.000
TextLabel_14.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_14.BorderSizePixel = 0
TextLabel_14.Position = UDim2.new(0.0257510729, 0, 0.375, 0)
TextLabel_14.Size = UDim2.new(0, 227, 0, 15)
TextLabel_14.Font = Enum.Font.SourceSansBold
TextLabel_14.Text = "stools <player/all/others>"
TextLabel_14.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_14.TextSize = 14.000
TextLabel_14.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_15.Parent = Frame_2
TextLabel_15.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_15.BackgroundTransparency = 1.000
TextLabel_15.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_15.BorderSizePixel = 0
TextLabel_15.Position = UDim2.new(0.0257510729, 0, 0.432692319, 0)
TextLabel_15.Size = UDim2.new(0, 227, 0, 15)
TextLabel_15.Font = Enum.Font.SourceSansBold
TextLabel_15.Text = "punish <player/all/others>"
TextLabel_15.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_15.TextSize = 14.000
TextLabel_15.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_16.Parent = Frame_2
TextLabel_16.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_16.BackgroundTransparency = 1.000
TextLabel_16.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_16.BorderSizePixel = 0
TextLabel_16.Position = UDim2.new(0.0257510729, 0, 0.490384609, 0)
TextLabel_16.Size = UDim2.new(0, 227, 0, 15)
TextLabel_16.Font = Enum.Font.SourceSansBold
TextLabel_16.Text = "shirtless <player/all/others>"
TextLabel_16.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_16.TextSize = 14.000
TextLabel_16.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_17.Parent = Frame_2
TextLabel_17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_17.BackgroundTransparency = 1.000
TextLabel_17.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_17.BorderSizePixel = 0
TextLabel_17.Position = UDim2.new(0.0257510729, 0, 0.461538464, 0)
TextLabel_17.Size = UDim2.new(0, 227, 0, 15)
TextLabel_17.Font = Enum.Font.SourceSansBold
TextLabel_17.Text = "pantsless <player/all/others>"
TextLabel_17.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_17.TextSize = 14.000
TextLabel_17.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_18.Parent = Frame_2
TextLabel_18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_18.BackgroundTransparency = 1.000
TextLabel_18.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_18.BorderSizePixel = 0
TextLabel_18.Position = UDim2.new(0.0257510729, 0, 0.403846145, 0)
TextLabel_18.Size = UDim2.new(0, 227, 0, 15)
TextLabel_18.Font = Enum.Font.SourceSansBold
TextLabel_18.Text = "noface <player/all/others>"
TextLabel_18.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_18.TextSize = 14.000
TextLabel_18.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_19.Parent = Frame_2
TextLabel_19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_19.BackgroundTransparency = 1.000
TextLabel_19.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_19.BorderSizePixel = 0
TextLabel_19.Position = UDim2.new(0.0257510729, 0, 0.548076928, 0)
TextLabel_19.Size = UDim2.new(0, 227, 0, 15)
TextLabel_19.Font = Enum.Font.SourceSansBold
TextLabel_19.Text = "noregen <player/all/others>"
TextLabel_19.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_19.TextSize = 14.000
TextLabel_19.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_20.Parent = Frame_2
TextLabel_20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_20.BackgroundTransparency = 1.000
TextLabel_20.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_20.BorderSizePixel = 0
TextLabel_20.Position = UDim2.new(0.0257510729, 0, 0.519230783, 0)
TextLabel_20.Size = UDim2.new(0, 227, 0, 15)
TextLabel_20.Font = Enum.Font.SourceSansBold
TextLabel_20.Text = "tshirtless <player/all/others>"
TextLabel_20.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_20.TextSize = 14.000
TextLabel_20.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_21.Parent = Frame_2
TextLabel_21.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_21.BackgroundTransparency = 1.000
TextLabel_21.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_21.BorderSizePixel = 0
TextLabel_21.Position = UDim2.new(0.0257510729, 0, 0.288461536, 0)
TextLabel_21.Size = UDim2.new(0, 227, 0, 15)
TextLabel_21.Font = Enum.Font.SourceSansBold
TextLabel_21.Text = "slock"
TextLabel_21.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_21.TextSize = 14.000
TextLabel_21.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_22.Parent = Frame_2
TextLabel_22.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_22.BackgroundTransparency = 1.000
TextLabel_22.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_22.BorderSizePixel = 0
TextLabel_22.Position = UDim2.new(0.0257510729, 0, 0.75, 0)
TextLabel_22.Size = UDim2.new(0, 227, 0, 15)
TextLabel_22.Font = Enum.Font.SourceSansBold
TextLabel_22.Text = "norl <player/all/others>"
TextLabel_22.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_22.TextSize = 14.000
TextLabel_22.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_23.Parent = Frame_2
TextLabel_23.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_23.BackgroundTransparency = 1.000
TextLabel_23.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_23.BorderSizePixel = 0
TextLabel_23.Position = UDim2.new(0.0257510729, 0, 0.634615362, 0)
TextLabel_23.Size = UDim2.new(0, 227, 0, 15)
TextLabel_23.Font = Enum.Font.SourceSansBold
TextLabel_23.Text = "nolimbs <player/all/others>"
TextLabel_23.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_23.TextSize = 14.000
TextLabel_23.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_24.Parent = Frame_2
TextLabel_24.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_24.BackgroundTransparency = 1.000
TextLabel_24.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_24.BorderSizePixel = 0
TextLabel_24.Position = UDim2.new(0.0257510729, 0, 0.605769217, 0)
TextLabel_24.Size = UDim2.new(0, 227, 0, 15)
TextLabel_24.Font = Enum.Font.SourceSansBold
TextLabel_24.Text = "blockchar <player/all/others>"
TextLabel_24.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_24.TextSize = 14.000
TextLabel_24.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_25.Parent = Frame_2
TextLabel_25.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_25.BackgroundTransparency = 1.000
TextLabel_25.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_25.BorderSizePixel = 0
TextLabel_25.Position = UDim2.new(0.0257510729, 0, 0.663461566, 0)
TextLabel_25.Size = UDim2.new(0, 227, 0, 15)
TextLabel_25.Font = Enum.Font.SourceSansBold
TextLabel_25.Text = "nola <player/all/others>"
TextLabel_25.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_25.TextSize = 14.000
TextLabel_25.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_26.Parent = Frame_2
TextLabel_26.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_26.BackgroundTransparency = 1.000
TextLabel_26.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_26.BorderSizePixel = 0
TextLabel_26.Position = UDim2.new(0.0257510729, 0, 0.721153855, 0)
TextLabel_26.Size = UDim2.new(0, 227, 0, 15)
TextLabel_26.Font = Enum.Font.SourceSansBold
TextLabel_26.Text = "nora <player/all/others>"
TextLabel_26.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_26.TextSize = 14.000
TextLabel_26.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_27.Parent = Frame_2
TextLabel_27.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_27.BackgroundTransparency = 1.000
TextLabel_27.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_27.BorderSizePixel = 0
TextLabel_27.Position = UDim2.new(0.0257510729, 0, 0.778846145, 0)
TextLabel_27.Size = UDim2.new(0, 227, 0, 15)
TextLabel_27.Font = Enum.Font.SourceSansBold
TextLabel_27.Text = "nowaist <player/all/others>"
TextLabel_27.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_27.TextSize = 14.000
TextLabel_27.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_28.Parent = Frame_2
TextLabel_28.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_28.BackgroundTransparency = 1.000
TextLabel_28.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_28.BorderSizePixel = 0
TextLabel_28.Position = UDim2.new(0.0257510729, 0, 0.807692289, 0)
TextLabel_28.Size = UDim2.new(0, 227, 0, 15)
TextLabel_28.Font = Enum.Font.SourceSansBold
TextLabel_28.Text = "noroot <player/all/others>"
TextLabel_28.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_28.TextSize = 14.000
TextLabel_28.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_29.Parent = Frame_2
TextLabel_29.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_29.BackgroundTransparency = 1.000
TextLabel_29.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_29.BorderSizePixel = 0
TextLabel_29.Position = UDim2.new(0.0257510729, 0, 0.576923072, 0)
TextLabel_29.Size = UDim2.new(0, 227, 0, 15)
TextLabel_29.Font = Enum.Font.SourceSansBold
TextLabel_29.Text = "stopanim <player/all/others>"
TextLabel_29.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_29.TextSize = 14.000
TextLabel_29.TextXAlignment = Enum.TextXAlignment.Left

TextLabel_30.Parent = Frame_2
TextLabel_30.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_30.BackgroundTransparency = 1.000
TextLabel_30.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_30.BorderSizePixel = 0
TextLabel_30.Position = UDim2.new(0.0257510729, 0, 0.692307711, 0)
TextLabel_30.Size = UDim2.new(0, 227, 0, 15)
TextLabel_30.Font = Enum.Font.SourceSansBold
TextLabel_30.Text = "noll <player/all/others>"
TextLabel_30.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_30.TextSize = 14.000
TextLabel_30.TextXAlignment = Enum.TextXAlignment.Left

clos.Name = "clos"
clos.Parent = cmd
clos.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
clos.BackgroundTransparency = 1.000
clos.BorderColor3 = Color3.fromRGB(0, 0, 0)
clos.BorderSizePixel = 0
clos.Size = UDim2.new(0, 20, 0, 20)
clos.Image = "http://www.roblox.com/asset/?id=8530043932"
clos.MouseButton1Click:Connect(function()
	cmd.Visible = false
end)

serch.Name = "serch"
serch.Parent = cmd
serch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
serch.BackgroundTransparency = 1.000
serch.BorderColor3 = Color3.fromRGB(0, 0, 0)
serch.BorderSizePixel = 0
serch.Position = UDim2.new(0.92125982, 0, 0.0619195029, 0)
serch.Size = UDim2.new(0, 20, 0, 20)
serch.Image = "http://www.roblox.com/asset/?id=5492253050"

TextBox.Parent = cmd
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundTransparency = 1.000
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.0433070883, 0, 0.0619195029, 0)
TextBox.Size = UDim2.new(0, 222, 0, 20)
TextBox.Font = Enum.Font.SourceSansBold
TextBox.PlaceholderText = "Search Command"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14.000
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left
