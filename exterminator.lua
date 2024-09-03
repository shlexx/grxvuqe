local gun = Instance.new("Tool",game.Players.LocalPlayer.Backpack)
local handle = Instance.new("Part",gun)
local mouse = game.Players.LocalPlayer:GetMouse()
local equipped = false
local HB = Instance.new("ScreenGui")
local Holder = Instance.new("Frame")
local HBBox = Instance.new("TextBox")
HB.Name = "HB"
HB.Parent = game.CoreGui
Holder.Name = "Holder"
Holder.Parent = HB
Holder.AnchorPoint = Vector2.new(1, 1)
Holder.BackgroundColor3 = Color3.fromRGB(0, 131, 212)
Holder.BackgroundTransparency = 0.250
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(0.708999991, 0, 0.967999995, 0)
Holder.Size = UDim2.new(0, 60, 0, 60)
Holder.Visible = false
HBBox.Name = "HBBox"
HBBox.Parent = Holder
HBBox.BackgroundColor3 = Color3.fromRGB(9, 25, 36)
HBBox.BackgroundTransparency = 0.750
HBBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
HBBox.BorderSizePixel = 0
HBBox.Position = UDim2.new(0.0833333358, 0, 0.0833333358, 0)
HBBox.Size = UDim2.new(0, 50, 0, 50)
HBBox.Font = Enum.Font.SourceSansBold
HBBox.Text = ""
HBBox.TextColor3 = Color3.fromRGB(255, 255, 255)
HBBox.TextSize = 28.000
gun.CanBeDropped = false
gun.Name = "criminal exterminator"
gun.ToolTip = "kill"
handle.Name = "Handle"
handle.Size = Vector3.new(0.5,0.5,2.5)
handle.Reflectance = 1

gun.Equipped:Connect(function()
	equipped = true
	local player = game.Players.LocalPlayer
	repeat wait() until player.Character.Humanoid
	local humanoid = player.Character.Humanoid
	local character = player.Character or player.CharacterAdded:Wait()
	local anim = Instance.new("Animation")
	gunframe = player.PlayerGui.Home.HUD.GunFrame
	anim.AnimationId = "rbxassetid://18137826278"
	playAnim = humanoid:LoadAnimation(anim)
	playAnim:Play()
	gunframe.Visible = true
	gunframe.Label.Text = "criminal exterminator"
	gunframe.Magazine.Text = "inf/inf"
	Holder.Visible = true
end)

gun.Unequipped:Connect(function()
	equipped = false
	playAnim:Stop()
	gunframe.Visible = false
	Holder.Visible = false
end)

gun.Activated:Connect(function()
	if equipped then
		local player = game.Players.LocalPlayer
		repeat wait() until player.Character.Humanoid
		local humanoid = player.Character.Humanoid
		local character = player.Character or player.CharacterAdded:Wait()
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://18137845992"
		local playAnim = humanoid:LoadAnimation(anim)
		playAnim:Play()
		if mouse then
			local beam = Instance.new("Part")
			local position = mouse.Hit.p
			beam.BrickColor = BrickColor.new("New Yeller")
			beam.FormFactor = Enum.FormFactor.Custom
			beam.Material = Enum.Material.Neon
			beam.Transparency = 0
			beam.Anchored = true
			beam.Locked = true
			beam.CanCollide = false
			beam.Parent = workspace
			local distance = (game.Players.LocalPlayer.Character:WaitForChild("Right Arm").CFrame.p - position).Magnitude
			beam.Size = Vector3.new(0.1, 0.1, distance)
			beam.CFrame = CFrame.new(game.Players.LocalPlayer.Character:WaitForChild("Right Arm").CFrame.p, position) * CFrame.new(0, 0, -distance / 2)
			wait(.025)
			beam:Destroy()
			if mouse.Target then
				if mouse.Target.Parent.Humanoid then
					game.ReplicatedStorage.Events.Arrest:InvokeServer(game.Players:FindFirstChild(mouse.Target.Parent.Name))
				end
			end
		end
	end
end)

HBBox.FocusLost:Connect(function(enter)
	if enter then
		for _,v in pairs(game.Players:GetPlayers()) do
			local head = v.Character.HumanoidRootPart
			if head then
				repeat wait() until head
				head.Size = Vector3.new(tonumber(HBBox.Text),tonumber(HBBox.Text),tonumber(HBBox.Text))
				v.Character:WaitForChild("Humanoid").Died:Connect(function()
					repeat wait() until head
					head.Size = Vector3.new(tonumber(HBBox.Text),tonumber(HBBox.Text),tonumber(HBBox.Text))
				end)
			end
		end
	end
end)
