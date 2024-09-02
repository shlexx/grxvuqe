local gun = Instance.new("Tool",game.Players.LocalPlayer.Backpack)
local handle = Instance.new("Part",gun)
local mouse = game.Players.LocalPlayer:GetMouse()
local equipped = false
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
end)

gun.Unequipped:Connect(function()
	equipped = false
	playAnim:Stop()
    gunframe.Visible = false
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
