game.Players.LocalPlayer.Chatted:Connect(function(message)
	if message == ".grapplinghook" then
		local grappling = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
		grappling.Name = "GrapplingHook"
		grappling.CanBeDropped = false
		grappling.RequiresHandle = false
		grappling.TextureId = "rbxassetid://30327988"
		local mouse = game.Players.LocalPlayer:GetMouse()
		local equipped = false
		local tweenSpeed = 1
		local TweenService = game:GetService("TweenService")

		grappling.Equipped:Connect(function()
			equipped = true
		end)

		grappling.Unequipped:Connect(function()
			equipped = false
		end)

		grappling.Activated:Connect(function()
			if equipped == true then
				if mouse.Target then
					TweenService:Create(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = mouse.Hit + Vector3.new(0, 2, 0)}):Play()
				end
			else end
		end)
	elseif message == ".gravitycoil" then
		local gravcoil = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
		local grav = 50
		gravcoil.Name = "GravityCoil"
		gravcoil.RequiresHandle = false
		gravcoil.CanBeDropped = false
		gravcoil.TextureId = "rbxassetid://16619617"

		gravcoil.Equipped:Connect(function()
			workspace.Gravity = grav
		end)

		gravcoil.Unequipped:Connect(function()
			workspace.Gravity = 196.2
		end)
	elseif message == ".speedcoil" then
		local spcoil = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
		local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
		local speed = 32
		spcoil.Name = "SpeedCoil"
		spcoil.RequiresHandle = false
		spcoil.CanBeDropped = false
		spcoil.TextureId = "rbxassetid://99170415"

		spcoil.Equipped:Connect(function()
			hum.WalkSpeed = speed
		end)

		spcoil.Unequipped:Connect(function()
			hum.WalkSpeed = 16
		end)
	elseif message == ".magiccarpet" then
		local carpet = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
		local equipped = false
		carpet.Name = "MagicCarpet"
		carpet.RequiresHandle = false
		carpet.CanBeDropped = false
		carpet.TextureId = "rbxassetid://223080070"

		carpet.Equipped:Connect(function()
			equipped = true
		end)

		carpet.Unequipped:Connect(function()
			equipped = false
		end)
		
		carpet.Activated:Connect(function()
			if equipped then
				local player = game.Players.LocalPlayer
				local userInputService = game:GetService("UserInputService")
				local runService = game:GetService("RunService")

				local speed = 50
				local bodyGyro
				local bodyVelocity
				local flying = false
				local direction = Vector3.new(0, 0, 0)
				local keysPressed = {}

				function startFlying()
					local character = player.Character
					if not character then return end
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					if not humanoidRootPart then return end

					flying = true

					bodyGyro = Instance.new("BodyGyro")
					bodyGyro.P = 9e4
					bodyGyro.Parent = humanoidRootPart
					bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
					bodyGyro.CFrame = humanoidRootPart.CFrame

					bodyVelocity = Instance.new("BodyVelocity")
					bodyVelocity.Parent = humanoidRootPart
					bodyVelocity.Velocity = Vector3.new(0, 0, 0)
					bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

					character.Humanoid.PlatformStand = true

					for _, part in pairs(character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
					
					runService.Heartbeat:Connect(function()
						if flying then
							bodyGyro.CFrame = workspace.CurrentCamera.CFrame
							local cameraCFrame = workspace.CurrentCamera.CFrame
							bodyVelocity.Velocity = (cameraCFrame.LookVector * direction.Z + cameraCFrame.RightVector * direction.X) * speed
						end
					end)
				end

				function stopFlying()
					if flying then
						if bodyGyro then bodyGyro:Destroy() end
						if bodyVelocity then bodyVelocity:Destroy() end
						if player.Character then
							player.Character.Humanoid.PlatformStand = false
							for _, part in pairs(player.Character:GetDescendants()) do
								if part:IsA("BasePart") then
									part.CanCollide = true
								end
							end
						end
						flying = false
					end
				end

				function updateDirection()
					local newDirection = Vector3.new(0, 0, 0)
					for key, value in pairs(keysPressed) do
						if value and key == Enum.KeyCode.W then
							newDirection = newDirection + Vector3.new(0, 0, 1)
						elseif value and key == Enum.KeyCode.S then
							newDirection = newDirection + Vector3.new(0, 0, -1)
						elseif value and key == Enum.KeyCode.A then
							newDirection = newDirection + Vector3.new(-1, 0, 0)
						elseif value and key == Enum.KeyCode.D then
							newDirection = newDirection + Vector3.new(1, 0, 0)
						end
					end
					direction = newDirection
				end

				function onInputBegan(input, gameProcessed)
					if gameProcessed then return end
					keysPressed[input.KeyCode] = true
					updateDirection()
				end

				function onInputEnded(input, gameProcessed)
					if gameProcessed then return end
					keysPressed[input.KeyCode] = nil
					updateDirection()
				end

				userInputService.InputBegan:Connect(onInputBegan)
				userInputService.InputEnded:Connect(onInputEnded)

				startFlying()
			end
		end)
		
		carpet.Deactivated:Connect(function()
			stopFlying()
		end)
	elseif message == ".jetpack" then
		local cam = workspace.CurrentCamera
		local equipped = false
		local plr = game.Players.LocalPlayer
		local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
		local jetpack = Instance.new("Tool", plr.Backpack)
		jetpack.Name = "Jetpack"
		jetpack.TextureId = "rbxassetid://31310254"
		jetpack.RequiresHandle = false
		jetpack.CanBeDropped = false
		
		jetpack.Equipped:Connect(function()
			equipped = true
		end)
		
		jetpack.Unequipped:Connect(function()
			equipped = false
		end)
		
		jetpack.Activated:Connect(function()
			if equipped then
				local bodyGyro = Instance.new("BodyGyro", hrp)
				local force = Instance.new("BodyVelocity", hrp)
				bodyGyro.cframe = cam.CoordinateFrame
				force.velocity = Vector3.new(0,30,0)
			end
		end)
		
		jetpack.Deactivated:Connect(function()
			hrp:FindFirstChildOfClass("BodyGyro"):Destroy()
			hrp:FindFirstChildOfClass("BodyVelocity"):Destroy()
		end)
	end
end)
