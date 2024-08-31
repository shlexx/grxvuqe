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
		
		if msg == prefix .. "cmds" then
			chat("Owners Chat Commands: bring, goto, bang, follow, owner, admin, stack, respawn, freeze, jump, stun, leave, say, speed, jumppower, unbang, unfollow, unadmin, unstack, unfreeze, unstun, prefix, commandsplitter, rejoin")
		elseif msg == prefix .. "bring" then
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
		elseif msg == prefix .. "respawn" then
			hum:ChangeState(Enum.HumanoidStateType.Dead)
		elseif msg == prefix .. "freeze" then
			getRoot(character).Anchored = true
		elseif msg == prefix .. "jump" then
			hum.Jump = true
		elseif msg == prefix .. "stun" then
			hum.PlatformStand = true
		elseif msg == prefix .. "leave" then
			game:Shutdown()
		elseif args[1] == prefix .. "say" then
			chat(tostring(args[2]))
		elseif args[1] == prefix .. "speed" then
			hum.WalkSpeed = tonumber(args[2])
		elseif args[1] == prefix .. "jumppower" then
			hum.JumpPower = tonumber(args[2])
		elseif msg == prefix .. "unbang" then
			banging = false
		elseif msg == prefix .. "unfollow" then
			following = false
		elseif args[1] == prefix .. "unadmin" then
			table.remove(admins, tostring(args[2]))
		elseif msg == prefix .. "unstack" then
			stacking = false
		elseif msg == prefix .. "unfreeze" then
			getRoot(character).Anchored = false
		elseif msg == prefix .. "unstun" then
			hum.PlatformStand = false
		elseif args[1] == prefix .. "prefix" then
			prefix = tostring(args[2])
		elseif args[1] == prefix .. "commandsplitter" then
			commandsplitter = tostring(args[2])
		elseif msg == prefix .. "rejoin" then
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

		if msg == prefix .. "cmds" then
			chat("Admins Chat Commands: bring, goto, bang, follow, admin, stack, respawn, freeze, jump, stun, say, speed, jumppower, unbang, unfollow, unstack, unfreeze, unstun")
		elseif msg == prefix .. "bring" then
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
		elseif msg == prefix .. "respawn" then
			hum:ChangeState(Enum.HumanoidStateType.Dead)
		elseif msg == prefix .. "freeze" then
			getRoot(character).Anchored = true
		elseif msg == prefix .. "jump" then
			hum.Jump = true
		elseif msg == prefix .. "stun" then
			hum.PlatformStand = true
		elseif args[1] == prefix .. "say" then
			chat(tostring(args[2]))
		elseif args[1] == prefix .. "speed" then
			hum.WalkSpeed = tonumber(args[2])
		elseif args[1] == prefix .. "jumppower" then
			hum.JumpPower = tonumber(args[2])
		elseif msg == prefix .. "unbang" then
			banging = false
		elseif msg == prefix .. "unfollow" then
			following = false
		elseif msg == prefix .. "unstack" then
			stacking = false
		elseif msg == prefix .. "unfreeze" then
			getRoot(character).Anchored = false
		elseif msg == prefix .. "unstun" then
			hum.PlatformStand = false
		end
	end)
end
