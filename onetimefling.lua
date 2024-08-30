local Players = game:GetService("Players")
local player = Players.LocalPlayer
local maxdistance = 6

local punch = Instance.new("Tool",player.Backpack)
punch.Name = "die (one time probably)"
punch.RequiresHandle = false
punch.CanBeDropped = false

punch.Activated:Connect(function()
	repeat wait() until player.Character.Humanoid
	local humanoid = player.Character.Humanoid
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:FindFirstChild("HumanoidRootPart")

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://243827693"

	local playAnim = humanoid:LoadAnimation(anim)
	playAnim:Play()
	wait(0.5)
	for i,v in pairs(Players:GetPlayers()) do
		local distance = player:DistanceFromCharacter(v.Character:FindFirstChild("HumanoidRootPart").CFrame.Position)
		if v.Character and v.Character ~= character and distance < maxdistance then
			local Thrust = Instance.new("BodyThrust", character:FindFirstChild("HumanoidRootPart"))
			Thrust.Force = Vector3.new(9999,9999,9999)
			Thrust.Name = "YeetForce"
			repeat
				hrp.CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
				Thrust.Location = v.Character:FindFirstChild("HumanoidRootPart").Position
				game:GetService("RunService").Heartbeat:Wait()
			until not v.Character:FindFirstChild("Head")
			Thrust:Destroy()
		end
	end
end)
