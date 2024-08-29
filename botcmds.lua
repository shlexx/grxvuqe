local owners = {"LOUDAUDlOS"}
local admins = {}
local prefix = "."
local commandsplitter = "/"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathService = game:GetService("PathfindingService")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")

function chat(chatmsg)
	if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(chatmsg, "All")
	else
		TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(chatmsg)
	end
end

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

function r15(plr)
	if plr.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15 then
		return true
	end
end

for _,v in pairs(owners) do
	local mainplayer = Players:FindFirstChild(v)
	mainplayer.Chatted:Connect(function(msg)
		msg = msg:lower()
		local args = msg:split(commandsplitter)
		local localplayer = Players.LocalPlayer
		local character = localplayer.Character
		local hum = character:FindFirstChildOfClass("Humanoid")
		local mainplayercharacter = mainplayer.Character
		local sargplayer = Players:FindFirstChild(args[2])
		local sargcharacter = sargplayer.Character
		
		local flinging = false
		local banging = false
		local following = false
		local stacking = false
		local noclip = false
		local floatName = randomString()
		
		if args[1] == prefix .. "cmds" then
			chat("Owners Chat Commands: bring, goto, bang, follow, owner, admin, stack, fling, respawn, freeze, jump, stun, leave, say, speed, jumppower, unbang, unfollow, unadmin, unstack, unfling, unfreeze, unstun, prefix, commandsplitter, rejoin")
		elseif args[1] == prefix .. "bring" then
			getRoot(character).CFrame = getRoot(mainplayercharacter).CFrame + Vector3.new(3, 1, 0)
		elseif args[1] == prefix .. "goto" then
			getRoot(character).CFrame = getRoot(sargcharacter).CFrame + Vector3.new(3, 1, 0)
		elseif args[1] == prefix .. "bang" then
			banging = true
			local bangAnim = Instance.new("Animation")
			bangAnim.AnimationId = not r15(localplayer) and "rbxassetid://148840371" or "rbxassetid://5918726674"
			local bang = hum:LoadAnimation(bangAnim)
			bang:Play(0.1, 1, 1)
			bang:AdjustSpeed(tonumber(args[3]) or 3)
			local bangOffset = CFrame.new(0, 0, 1.1)
			local otherRoot = getRoot(sargcharacter)
			while banging do
				getRoot(character).CFrame = otherRoot.CFrame * bangOffset
			end
		elseif args[1] == prefix .. "follow" then
			following = true
			local path = PathService:CreatePath()
			while following do
				path:ComputeAsync(getRoot(character).Position, getRoot(sargcharacter.Character).Position)
				local waypoints = path:GetWaypoints()
				local distance
				for waypointIndex, waypoint in pairs(waypoints) do
					local waypointPosition = waypoint.Position
					hum:MoveTo(waypointPosition)
					repeat 
						distance = (waypointPosition - hum.Parent.PrimaryPart.Position).magnitude
						wait()
					until distance <= 5
				end
			end
		elseif args[1] == prefix .. "owner" then
			table.insert(owners, tostring(args[2]))
		elseif args[1] == prefix .. "admin" then
			table.insert(admins, tostring(args[2]))
		elseif args[1] == prefix .. "stack" then
			stacking = true
			hum.Sit = true
			while stacking do
				getRoot(character).CFrame = getRoot(sargplayer).CFrame * CFrame.Angles(0,math.rad(0),0)* CFrame.new(0,1.6,0.4)
			end
		elseif args[1] == prefix .. "fling" then
			flinging = true
			for _,x in pairs(character:GetDescendants()) do
				if x:IsA("BasePart") then
					x.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
				end
			end
			noclip = false
			wait(0.1)
			while noclip do
				if noclip == true and character ~= nil then
					for _, child in pairs(character:GetDescendants()) do
						if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
							child.CanCollide = false
						end
					end
				end
			end
			local bambam = Instance.new("BodyAngularVelocity")
			bambam.Name = randomString()
			bambam.Parent = getRoot(character)
			bambam.AngularVelocity = Vector3.new(0,99999,0)
			bambam.MaxTorque = Vector3.new(0,math.huge,0)
			bambam.P = math.huge
			local Char = character:GetChildren()
			for _,g in next, Char do
				if g:IsA("BasePart") then
					g.CanCollide = false
					g.Massless = true
					g.Velocity = Vector3.new(0, 0, 0)
				end
			end
			while flinging do
				bambam.AngularVelocity = Vector3.new(0,99999,0)
				wait(.2)
				bambam.AngularVelocity = Vector3.new(0,0,0)
				wait(.1)
			end
		elseif args[1] == prefix .. "respawn" then
			hum:ChangeState(Enum.HumanoidStateType.Dead)
		elseif args[1] == prefix .. "freeze" then
			getRoot(character).Anchored = true
		elseif args[1] == prefix .. "jump" then
			hum.Jump = true
		elseif args[1] == prefix .. "stun" then
			hum.PlatformStand = true
		elseif args[1] == prefix .. "leave" then
			game:Shutdown()
		elseif args[1] == prefix .. "say" then
			chat(tostring(args[2]))
		elseif args[1] == prefix .. "speed" then
			hum.WalkSpeed = tonumber(args[2])
		elseif args[1] == prefix .. "jumppower" then
			hum.JumpPower = tonumber(args[2])
		elseif args[1] == prefix .. "unbang" then
			banging = false
		elseif args[1] == prefix .. "unfollow" then
			following = false
		elseif args[1] == prefix .. "unadmin" then
			table.remove(admins, tostring(args[2]))
		elseif args[1] == prefix .. "unstack" then
			stacking = false
		elseif args[1] == prefix .. "unfling" then
			flinging = false
			wait(.1)
			local speakerChar = character
			if not speakerChar or not getRoot(speakerChar) then return end
			for i,c in pairs(getRoot(speakerChar):GetChildren()) do
				if c.ClassName == 'BodyAngularVelocity' then
					c:Destroy()
				end
			end
			for _, child in pairs(speakerChar:GetDescendants()) do
				if child.ClassName == "Part" or child.ClassName == "MeshPart" then
					child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
				end
			end
		elseif args[1] == prefix .. "unfreeze" then
			getRoot(character).Anchored = false
		elseif args[1] == prefix .. "unstun" then
			hum.PlatformStand = false
		elseif args[1] == prefix .. "prefix" then
			prefix = tostring(args[2])
		elseif args[1] == prefix .. "commandsplitter" then
			commandsplitter = tostring(args[2])
		elseif args[1] == prefix .. "rejoin" then
			if #Players:GetPlayers() <= 1 then
				Players.LocalPlayer:Kick("\nRejoining...")
				wait()
				TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
			else
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localplayer)
			end
		end
	end)
end

for _,v in pairs(admins) do
	local mainplayer = Players:FindFirstChild(v)
	mainplayer.Chatted:Connect(function(msg)
		msg = msg:lower()
		local args = msg:split(commandsplitter)
		local localplayer = Players.LocalPlayer
		local character = localplayer.Character
		local hum = character:FindFirstChildOfClass("Humanoid")
		local mainplayercharacter = mainplayer.Character
		local sargplayer = Players:FindFirstChild(args[2])
		local sargcharacter = sargplayer.Character

		local flinging = false
		local banging = false
		local following = false
		local stacking = false
		local noclip = false
		local floatName = randomString()

		if args[1] == prefix .. "cmds" then
			chat("Admins Chat Commands: bring, goto, bang, follow, admin, stack, fling, respawn, freeze, jump, stun, say, speed, jumppower, unbang, unfollow, unstack, unfling, unfreeze, unstun")
		elseif args[1] == prefix .. "bring" then
			getRoot(character).CFrame = getRoot(mainplayercharacter).CFrame + Vector3.new(3, 1, 0)
		elseif args[1] == prefix .. "goto" then
			getRoot(character).CFrame = getRoot(sargcharacter).CFrame + Vector3.new(3, 1, 0)
		elseif args[1] == prefix .. "bang" then
			banging = true
			local bangAnim = Instance.new("Animation")
			bangAnim.AnimationId = not r15(localplayer) and "rbxassetid://148840371" or "rbxassetid://5918726674"
			local bang = hum:LoadAnimation(bangAnim)
			bang:Play(0.1, 1, 1)
			bang:AdjustSpeed(tonumber(args[3]) or 3)
			local bangOffset = CFrame.new(0, 0, 1.1)
			local otherRoot = getRoot(sargcharacter)
			while banging do
				getRoot(character).CFrame = otherRoot.CFrame * bangOffset
			end
		elseif args[1] == prefix .. "follow" then
			following = true
			local path = PathService:CreatePath()
			while following do
				path:ComputeAsync(getRoot(character).Position, getRoot(sargcharacter.Character).Position)
				local waypoints = path:GetWaypoints()
				local distance
				for waypointIndex, waypoint in pairs(waypoints) do
					local waypointPosition = waypoint.Position
					hum:MoveTo(waypointPosition)
					repeat 
						distance = (waypointPosition - hum.Parent.PrimaryPart.Position).magnitude
						wait()
					until distance <= 5
				end
			end
		elseif args[1] == prefix .. "admin" then
			table.insert(admins, tostring(args[2]))
		elseif args[1] == prefix .. "stack" then
			stacking = true
			hum.Sit = true
			while stacking do
				getRoot(character).CFrame = getRoot(sargplayer).CFrame * CFrame.Angles(0,math.rad(0),0)* CFrame.new(0,1.6,0.4)
			end
		elseif args[1] == prefix .. "fling" then
			flinging = true
			for _,x in pairs(character:GetDescendants()) do
				if x:IsA("BasePart") then
					x.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
				end
			end
			noclip = false
			wait(0.1)
			while noclip do
				if noclip == true and character ~= nil then
					for _, child in pairs(character:GetDescendants()) do
						if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
							child.CanCollide = false
						end
					end
				end
			end
			local bambam = Instance.new("BodyAngularVelocity")
			bambam.Name = randomString()
			bambam.Parent = getRoot(character)
			bambam.AngularVelocity = Vector3.new(0,99999,0)
			bambam.MaxTorque = Vector3.new(0,math.huge,0)
			bambam.P = math.huge
			local Char = character:GetChildren()
			for _,g in next, Char do
				if g:IsA("BasePart") then
					g.CanCollide = false
					g.Massless = true
					g.Velocity = Vector3.new(0, 0, 0)
				end
			end
			while flinging do
				bambam.AngularVelocity = Vector3.new(0,99999,0)
				wait(.2)
				bambam.AngularVelocity = Vector3.new(0,0,0)
				wait(.1)
			end
		elseif args[1] == prefix .. "respawn" then
			hum:ChangeState(Enum.HumanoidStateType.Dead)
		elseif args[1] == prefix .. "freeze" then
			getRoot(character).Anchored = true
		elseif args[1] == prefix .. "jump" then
			hum.Jump = true
		elseif args[1] == prefix .. "stun" then
			hum.PlatformStand = true
		elseif args[1] == prefix .. "say" then
			chat(tostring(args[2]))
		elseif args[1] == prefix .. "speed" then
			hum.WalkSpeed = tonumber(args[2])
		elseif args[1] == prefix .. "jumppower" then
			hum.JumpPower = tonumber(args[2])
		elseif args[1] == prefix .. "unbang" then
			banging = false
		elseif args[1] == prefix .. "unfollow" then
			following = false
		elseif args[1] == prefix .. "unstack" then
			stacking = false
		elseif args[1] == prefix .. "unfling" then
			flinging = false
			wait(.1)
			local speakerChar = character
			if not speakerChar or not getRoot(speakerChar) then return end
			for i,c in pairs(getRoot(speakerChar):GetChildren()) do
				if c.ClassName == 'BodyAngularVelocity' then
					c:Destroy()
				end
			end
			for _, child in pairs(speakerChar:GetDescendants()) do
				if child.ClassName == "Part" or child.ClassName == "MeshPart" then
					child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
				end
			end
		elseif args[1] == prefix .. "unfreeze" then
			getRoot(character).Anchored = false
		elseif args[1] == prefix .. "unstun" then
			hum.PlatformStand = false
		end
	end)
end
