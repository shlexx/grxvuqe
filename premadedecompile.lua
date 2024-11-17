_G.decompile = function(v:Script)
	local source
	if v.Name == "Vehicle" and v.Parent:FindFirstChild("LocalVehiclePromptGui") then
		source = [[local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Scripts = script.Parent
local TopModel = Scripts.Parent

local UniqueName = TopModel.Name.. "_" ..HttpService:GenerateGUID()

local ChassisModel = TopModel.Chassis
local EffectsFolder = TopModel.Effects

local Effects = require(Scripts.Effects)
local Chassis = require(Scripts.Chassis)
local VehicleSeating = require(Scripts.VehicleSeating)
local RemotesFolder = TopModel.Remotes
local BindableEventsFolder = TopModel.BindableEvents


-- LocalScripts that are cloned and deployed
local DriverScriptPrototype = Scripts.Driver
local PassengerScriptPrototype = Scripts.Passenger
local LocalGuiModulePrototype = Scripts.LocalVehicleGui

-- Note that this has not been refactored into a class yet
Chassis.InitializeDrivingValues()

-- This module is a class with a new() constructor function
local EffectsInstance = Effects.new(ChassisModel, EffectsFolder, TopModel)

VehicleSeating.SetRemotesFolder(RemotesFolder)
VehicleSeating.SetBindableEventsFolder(BindableEventsFolder)

local CharacterRemovingConnection = nil

local DriverSeat = Chassis.GetDriverSeat()
local AdditionalSeats = Chassis.GetPassengerSeats()

local LEG_PARTS_TO_REMOVE = {"RightFoot", "RightLowerLeg", "LeftFoot", "LeftLowerLeg"}
local ATTACHMENTS_TO_REMOVE = {"BodyBackAttachment", "WaistBackAttachment", "HatAttachment"}

local function setHatsAndLegsTransparency(obj, transparency)
	if obj:IsA("Humanoid") then
		obj = obj.Parent
	elseif obj:IsA("Player") then
		obj = obj.Character
	end

	for _, child in ipairs(obj:GetChildren()) do
		if child:IsA("Accoutrement") then
			local handle = child:FindFirstChild("Handle")
			if handle then
				local shouldRemove = false
				for _, attachmentName in ipairs(ATTACHMENTS_TO_REMOVE) do
					if handle:FindFirstChild(attachmentName) then
						shouldRemove = true
					end
				end

				if shouldRemove then
					handle.Transparency = transparency
				end
			end
		end
	end

	for _, legName in ipairs(LEG_PARTS_TO_REMOVE) do
		local legPart = obj:FindFirstChild(legName)
		if legPart then
			legPart.Transparency = transparency
		end
	end
end

local function onExitSeat(obj, seat)
	if obj:IsA("Player") then
		RemotesFolder.ExitSeat:FireClient(obj, false)

		local playerGui = obj:FindFirstChildOfClass("PlayerGui")
		if playerGui then
			local scriptContainer = playerGui:FindFirstChild(UniqueName .. "_ClientControls")
			if scriptContainer then
				scriptContainer:Destroy()
			end
		end
	end

	setHatsAndLegsTransparency(obj, 0)

	if obj:IsA("Humanoid") then
		obj.Sit = false
	end

	if CharacterRemovingConnection then
		CharacterRemovingConnection:Disconnect()
		CharacterRemovingConnection = nil
	end

	if seat == DriverSeat then
		DriverSeat:SetNetworkOwnershipAuto()
		Chassis.Reset()
		EffectsInstance:Disable()
	end
end

local function onEnterSeat(obj, seat)
	if seat and seat.Occupant then
		local ShouldTakeOffHats = true
		local prop = TopModel:GetAttribute("TakeOffAccessories")

		if prop ~= nil then
			ShouldTakeOffHats = prop
		end

		if ShouldTakeOffHats then
			setHatsAndLegsTransparency(seat.Occupant, 1)
		end
	end

	if not obj:IsA("Player") then
		return
	end

	local playerGui = obj:FindFirstChildOfClass("PlayerGui")
	if playerGui then
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = UniqueName .. "_ClientControls"
		screenGui.ResetOnSpawn = true
		screenGui.Parent = playerGui

		CharacterRemovingConnection = obj.CharacterRemoving:Connect(function()
			onExitSeat(obj)
		end)

		local localGuiModule = LocalGuiModulePrototype:Clone()
		localGuiModule.Parent = screenGui

		if seat == DriverSeat then
			local driverScript = DriverScriptPrototype:Clone()
			driverScript.CarValue.Value = TopModel
			driverScript.Parent = screenGui
			driverScript.Disabled = false

			DriverSeat:SetNetworkOwner(obj)
			EffectsInstance:Enable()
		else
			local passengerScript = PassengerScriptPrototype:Clone()
			passengerScript.CarValue.Value = TopModel
			passengerScript.Parent = screenGui
			passengerScript.Disabled = false
		end

		local scriptsReference = Instance.new("ObjectValue")
		scriptsReference.Name = "ScriptsReference"
		scriptsReference.Value = Scripts
		scriptsReference.Parent = screenGui
	end
end

--Listen to seat enter/exit
VehicleSeating.AddSeat(DriverSeat, onEnterSeat, onExitSeat)

for _, seat in ipairs(AdditionalSeats) do
	VehicleSeating.AddSeat(seat, onEnterSeat, onExitSeat)
end

local function playerAdded(player)
	local playerGui = player:WaitForChild("PlayerGui")

	if not playerGui:FindFirstChild("VehiclePromptScreenGui") then
		local screenGui = Instance.new("ScreenGui")
		screenGui.ResetOnSpawn = false
		screenGui.Name = "VehiclePromptScreenGui"
		screenGui.Parent = playerGui

		local newLocalVehiclePromptGui = Scripts.LocalVehiclePromptGui:Clone()
		newLocalVehiclePromptGui.CarValue.Value = TopModel
		newLocalVehiclePromptGui.Parent = screenGui
	end
end

Players.PlayerAdded:Connect(playerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	playerAdded(player)
end
]]
	elseif v.Name == "Health" and v.Parent:FindFirstChildOfClass("Humanoid") then
		source = [[-- Gradually regenerates the Humanoid's Health over time.

local REGEN_RATE = 1/100 -- Regenerate this fraction of MaxHealth per second.
local REGEN_STEP = 1 -- Wait this long between each regeneration step.

--------------------------------------------------------------------------------

local Character = script.Parent
local Humanoid = Character:WaitForChild'Humanoid'

--------------------------------------------------------------------------------

while true do
	while Humanoid.Health < Humanoid.MaxHealth do
		local dt = wait(REGEN_STEP)
		local dh = dt*REGEN_RATE*Humanoid.MaxHealth
		Humanoid.Health = math.min(Humanoid.Health + dh, Humanoid.MaxHealth)
	end
	Humanoid.HealthChanged:Wait()
end]]
	elseif v.Name == "BathroomSinkScript" then
		source = [[local water = script.Parent.Water.Mesh
local hotWater = 1
local coldWater = 1
local waterTemp = nil
local plugged = script.Parent.Plugged
local coldOn = script.Parent.ColdOn
local hotOn = script.Parent.HotOn
local faucet = script.Parent.Faucet
local drainSound = script.Parent.Water.WaterDrainSound
local waterSound = faucet.WaterRunningSound
local coldTap = script.Parent.ColdTapHandle
local hotTap = script.Parent.HotTapHandle
local plug = script.Parent.Plug

----- cold tap handler -----

coldTap.Interactive.ClickDetector.MouseClick:Connect(function()
	if coldOn.Value == false then
		coldOn.Value = true
		faucet.ParticleEmitter.Enabled = true
		waterSound:Play()
		coldTap:SetPrimaryPartCFrame(coldTap.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-45), 0))
	else
		coldOn.Value = false
		if hotOn.Value == false then
			faucet.ParticleEmitter.Enabled = false
			waterSound:Stop()
		end
		coldTap:SetPrimaryPartCFrame(coldTap.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(45), 0))
	end
end)

----- hot tap handler -----

hotTap.Interactive.ClickDetector.MouseClick:Connect(function()
	if hotOn.Value == false then
		hotOn.Value = true
		faucet.ParticleEmitter.Enabled = true
		waterSound:Play()
		hotTap:SetPrimaryPartCFrame(hotTap.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(45), 0))
	else
		hotOn.Value = false
		if coldOn.Value == false then
			faucet.ParticleEmitter.Enabled = false
			waterSound:Stop()
		end
		hotTap:SetPrimaryPartCFrame(hotTap.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-45), 0))
	end
end)

----- sink plug handler -----

plug.Interactive.ClickDetector.MouseClick:Connect(function()
	if plugged.Value == false then
		plugged.Value = true
		plug.Plug.CFrame = plug.Plug.CFrame * CFrame.new(0, -0.08, 0)
		plug.Interactive.CFrame = plug.Interactive.CFrame * CFrame.new(0, 0.14, 0)
		plug.Shaft.CFrame = plug.Shaft.CFrame * CFrame.new(0, 0.14, 0)
	else
		plugged.Value = false
		plug.Plug.CFrame = plug.Plug.CFrame * CFrame.new(0, 0.08, 0)
		plug.Interactive.CFrame = plug.Interactive.CFrame * CFrame.new(0, -0.14, 0)
		plug.Shaft.CFrame = plug.Shaft.CFrame * CFrame.new(0, -0.14, 0)
	end
end)

----- water handler -----

while true do
	if script.Parent.HotOn.Value == true and script.Parent.ColdOn.Value == true and script.Parent.Plugged.Value == true and water.Scale.Y <= 0.6 then -- if BOTH ON and PLUGGED		
		water.Scale = water.Scale + Vector3.new(0, 0.01, 0)
		water.Offset = Vector3.new(0, water.Scale.Y/2, 0)
		hotWater = hotWater + 1
		coldWater = coldWater + 1
		drainSound:Stop()
	elseif (script.Parent.HotOn.Value == true or script.Parent.ColdOn.Value == true) and script.Parent.Plugged.Value == true and water.Scale.Y <= 0.6 then -- if ON and PLUGGED
		water.Scale = water.Scale + Vector3.new(0, 0.01, 0)
		water.Offset = Vector3.new(0, water.Scale.Y/2, 0)
		if script.Parent.HotOn.Value == true then
			hotWater = hotWater + 1
		else
			coldWater = coldWater + 1
		end
		drainSound:Stop()
	elseif (script.Parent.HotOn.Value == true or script.Parent.ColdOn.Value == true) and script.Parent.Plugged.Value == false and water.Scale.Y <= 0.6 then -- if ON and NOT PLUGGED
		if script.Parent.HotOn.Value == true then
			coldWater = coldWater - 1			
		else
			hotWater = hotWater - 1
		end
		drainSound:Stop()
	elseif (script.Parent.HotOn.Value == false and script.Parent.ColdOn.Value == false) and script.Parent.Plugged.Value == false and water.Scale.Y > 0 then -- if NOT ON and NOT PLUGGED
		water.Scale = water.Scale + Vector3.new(0, -0.01, 0)
		water.Offset = Vector3.new(0, water.Scale.Y/2, 0)
		coldWater = coldWater - 1
		hotWater = hotWater - 1
		drainSound.TimePosition = 0
		drainSound:Play()
	end
	
	if coldWater < 1 then
		coldWater = 1
	end
	if hotWater < 1 then
		hotWater = 1
	end
	
	waterTemp = hotWater/coldWater	
	
	if waterTemp > 1 then
		water.Parent.SteamEmitter.Enabled = true
	else
		water.Parent.SteamEmitter.Enabled = false
	end
	wait(0.1)
	
	if script.Parent.ColdOn.Value == true or script.Parent.HotOn.Value == true then
		script.Parent.Splash.ParticleEmitter.Enabled = true
	else
		script.Parent.Splash.ParticleEmitter.Enabled = false
	end
	
	if water.Scale.Y <= 0 then
		drainSound:Stop()
	end
end]]
	elseif v.Name == "ToiletScript" then
		source = [[local interactive = script.Parent.Interactive
local handle = script.Parent.Handle
local flushing = false
local water = script.Parent.Water
local sound = water.FlushSound
local seat = script.Parent.Seat

seat.ChildAdded:connect(function(obj) -- if someone sits on the seat
	if obj.Name == "SeatWeld" then
		local player = game.Players:GetPlayerFromCharacter(obj.Part1.Parent)
		if player then
			script.Parent.Water.BrickColor = BrickColor.new("Cool yellow")
			script.Parent.ToiletUsed.Value = true
		end
	end
end)

function toiletHandle() -- handling toilet handle movement
	for i = 1, 5 do
		interactive.CFrame = handle.CFrame * CFrame.Angles(math.pi/2, 0, math.rad(12) * i) * CFrame.new(0, -0.1, -0.1)
		wait()
	end
	wait(1)
	for i = 5, 1, -1 do
		interactive.CFrame = handle.CFrame * CFrame.Angles(math.pi/2, 0, math.rad(12) * (i - 1)) * CFrame.new(0, -0.1, -0.1)
		wait()
	end
end

interactive.ClickDetector.MouseClick:Connect(function() -- when someone clicks on the handle
	if flushing == false then
		flushing = true
		spawn(toiletHandle)
		sound:Play()
		for i, v in pairs(script.Parent:GetChildren()) do
			if v.Name == "WaterSwirl" then
				v.ParticleEmitter.Transparency = NumberSequence.new(0.9)
				v.ParticleEmitter.Rate = 40
			end
		end
		
		for i = 1, 4 do
			water.CFrame = water.CFrame * CFrame.new(0, 0.01, 0)
			wait()
		end
		for i = 1, 22 do
			water.Mesh.Scale = water.Mesh.Scale + Vector3.new(-0.02, 0, -0.02)
			water.CFrame = water.CFrame * CFrame.new(0, -0.015, 0)
			wait()
		end
		
		if script.Parent.ToiletUsed.Value == true then
			water.BrickColor = BrickColor.new("Pastel yellow")
		end
		
		wait(1)
		
		for i = 1, 10 do
			for ii, v in pairs(script.Parent:GetChildren()) do
				if v.Name == "WaterSwirl" then
					v.ParticleEmitter.Transparency = NumberSequence.new(0.9 + (0.015 * i))
					if i == 10 then
						v.ParticleEmitter.Rate = 0
					end
				end
			end
			wait(0.2)
		end
		
		script.Parent.ToiletUsed.Value = false
		water.BrickColor = BrickColor.new("Fog")
		
		for i = 1, 66 do
			water.Mesh.Scale = water.Mesh.Scale + Vector3.new(0.0066, 0, 0.0066)
			water.CFrame = water.CFrame * CFrame.new(0, 0.00409, 0)
			wait()
		end
		water.CFrame = script.Parent.WaterResetPos.CFrame
		water.Mesh.Scale = Vector3.new(1,0,1)
		flushing = false
	end
end)]]
	elseif v.Name == "KitchenSinkScript" then
		source = [[local water = script.Parent.Water.Mesh
local hotWater = 1
local coldWater = 1
local waterTemp = nil
local plugged = script.Parent.Plugged
local coldOn = script.Parent.ColdOn
local hotOn = script.Parent.HotOn
local faucet = script.Parent.Faucet
local drainSound = script.Parent.Water.WaterDrainSound
local waterSound = faucet.WaterRunningSound
local coldTap = script.Parent.ColdTapHandle
local hotTap = script.Parent.HotTapHandle
local plug = script.Parent.Plug

----- cold tap handler -----

for i, v in pairs(coldTap:GetChildren()) do
	if v:FindFirstChild("ClickDetector") then
		v.ClickDetector.MouseClick:Connect(function()
			if coldOn.Value == false then
				coldOn.Value = true
				faucet.ParticleEmitter.Enabled = true
				waterSound:Play()
				coldTap:SetPrimaryPartCFrame(coldTap.PrimaryPart.CFrame * CFrame.Angles(math.rad(-45),0,0))
			else
				coldOn.Value = false
				if hotOn.Value == false then
					faucet.ParticleEmitter.Enabled = false
					waterSound:Stop()
				end
				coldTap:SetPrimaryPartCFrame(coldTap.PrimaryPart.CFrame * CFrame.Angles(math.rad(45),0,0))
			end
		end)
	end
end

----- hot tap handler

for i, v in pairs(hotTap:GetChildren()) do
	if v:FindFirstChild("ClickDetector") then
		v.ClickDetector.MouseClick:Connect(function()
			if hotOn.Value == false then
				hotOn.Value = true
				faucet.ParticleEmitter.Enabled = true
				waterSound:Play()
				hotTap:SetPrimaryPartCFrame(hotTap.PrimaryPart.CFrame * CFrame.Angles(math.rad(45),0,0))
			else
				hotOn.Value = false
				if coldOn.Value == false then
					faucet.ParticleEmitter.Enabled = false
					waterSound:Stop()
				end
				hotTap:SetPrimaryPartCFrame(hotTap.PrimaryPart.CFrame * CFrame.Angles(math.rad(-45),0,0))
			end
		end)
	end
end

----- sink plug handler -----

plug.Interactive.ClickDetector.MouseClick:Connect(function()
	if plugged.Value == false then
		plugged.Value = true
		plug.Plug.CFrame = plug.Plug.CFrame * CFrame.new(0,-0.1,0)
	else
		plugged.Value = false
		plug.Plug.CFrame = plug.Plug.CFrame * CFrame.new(0,0.1,0)
	end
end)

----- water handler -----

while true do
	if script.Parent.HotOn.Value == true and script.Parent.ColdOn.Value == true and script.Parent.Plugged.Value == true and water.Scale.Y <= 2 then -- if BOTH ON and PLUGGED		
		water.Scale = water.Scale + Vector3.new(0,0.01,0)
		water.Offset = Vector3.new(0,water.Scale.Y/2,0)
		hotWater = hotWater + 1
		coldWater = coldWater + 1
		drainSound:Stop()
	elseif (script.Parent.HotOn.Value == true or script.Parent.ColdOn.Value == true) and script.Parent.Plugged.Value == true and water.Scale.Y <= 2 then -- if ON and PLUGGED
		water.Scale = water.Scale + Vector3.new(0,0.01,0)
		water.Offset = Vector3.new(0,water.Scale.Y/2,0)
		if script.Parent.HotOn.Value == true then
			hotWater = hotWater + 1
		else
			coldWater = coldWater + 1
		end
		drainSound:Stop()
	elseif (script.Parent.HotOn.Value == true or script.Parent.ColdOn.Value == true) and script.Parent.Plugged.Value == false and water.Scale.Y <= 2 then -- if ON and NOT PLUGGED
		if script.Parent.HotOn.Value == true then
			coldWater = coldWater - 1			
		else
			hotWater = hotWater - 1
		end
		drainSound:Stop()
	elseif (script.Parent.HotOn.Value == false and script.Parent.ColdOn.Value == false) and script.Parent.Plugged.Value == false and water.Scale.Y > 0 then -- if NOT ON and NOT PLUGGED
		water.Scale = water.Scale + Vector3.new(0,-0.01,0)
		water.Offset = Vector3.new(0,water.Scale.Y/2,0)
		coldWater = coldWater - 1
		hotWater = hotWater - 1
		drainSound:Play()
	end
	
	if coldWater < 1 then
		coldWater = 1
	end
	if hotWater < 1 then
		hotWater = 1
	end
	
	waterTemp = hotWater/coldWater	
	
	if waterTemp > 1 then
		water.Parent.SteamEmitter.Enabled = true
	else
		water.Parent.SteamEmitter.Enabled = false
	end
	wait(0.1)
	
	
	if script.Parent.ColdOn.Value == true or script.Parent.HotOn.Value == true then
		script.Parent.Splash.ParticleEmitter.Enabled = true
	else
		script.Parent.Splash.ParticleEmitter.Enabled = false
	end	
	
	if water.Scale.Y <= 0 then
		drainSound:Stop()
	end
end]]
	elseif v.Name == "Put this inside your block" then
		source = [[---------------------------------
---Day/Night Script for Blocks---
---------------------------------
b = script.Parent

local oh,om = 6,10	-- Open Time (hours,minutes) DON'T TOUCH!
local ch,cm = 17,30	-- Close Time (hours, minutes) DON'T TOUCH!

local l = game:service("Lighting")
if (om == nil) then om = 0 end
if (cm == nil) then cm = 0 end


function TimeChanged()
	local ot = (oh + (om/60)) * 60
	local ct = (ch + (cm/60)) * 60
	if (ot < ct) then
		if (l:GetMinutesAfterMidnight() >= ot) and (l:GetMinutesAfterMidnight() <= ct) then
b.Material = ("SmoothPlastic")
b.Color = Color3.fromRGB(255, 195, 0)
		else
b.Material = ("Neon")
b.Color = Color3.fromRGB(180, 135, 0)
		end
	elseif (ot > ct) then
		if (l:GetMinutesAfterMidnight() >= ot) or (l:GetMinutesAfterMidnight() <= ct) then
b.Material = ("SmoothPlastic")
b.Color = Color3.fromRGB(255, 195, 0)
		else
b.Material = ("Neon")
b.Color = Color3.fromRGB(180, 135, 0)
		end
	end
end

TimeChanged()
game.Lighting.Changed:connect(function(property)
			if (property == "TimeOfDay") then
				TimeChanged()
			end
		end)

-- Ganondude]]
	elseif v.Name == "Put this inside your light" then
		source = [[b = script.Parent

local oh,om = 6,10	-- Open Time (hours,minutes)
local ch,cm = 17,30	-- Close Time (hours, minutes)

local l = game:service("Lighting")
if (om == nil) then om = 0 end
if (cm == nil) then cm = 0 end


function TimeChanged()
	local ot = (oh + (om/60)) * 60
	local ct = (ch + (cm/60)) * 60
	if (ot < ct) then
		if (l:GetMinutesAfterMidnight() >= ot) and (l:GetMinutesAfterMidnight() <= ct) then
b.Enabled = false
		else
b.Enabled = true
		end
	elseif (ot > ct) then
		if (l:GetMinutesAfterMidnight() >= ot) or (l:GetMinutesAfterMidnight() <= ct) then
b.Enabled = false
		else
b.Enabled = true
		end
	end
end

TimeChanged()
game.Lighting.Changed:connect(function(property)
			if (property == "TimeOfDay") then
				TimeChanged()
			end
		end)

-- Ganondude]]
	elseif v.Name == "Control" and v.Parent.Name == "HN" then
		source = [[if script.Parent.Parent:IsA("VehicleSeat") then
	script.Parent.Parent.ChildAdded:connect(function(child)
		if child:IsA("Weld") and game.Players:GetPlayerFromCharacter(child.Part1.Parent)~=nil then
			local p=game.Players:GetPlayerFromCharacter(child.Part1.Parent)
			local g=script.G:Clone()
			g.Parent=p.PlayerGui
			g:WaitForChild("src")
			g.src.Value=script.Parent
			g.Horn.Disabled=false		
		end
	end)
end]]
	elseif v.Parent.Name == "AC6_FE_Sounds" then
		source = [[local car = script.Parent.Parent
local Sounds = {}
local F = {}

F.newSound = function(name,par,id,pitch,volume,loop)
	for i,v in pairs(Sounds) do
		if i==name then
			v:Stop()
			v:Destroy()
		end
	end
	local sn = Instance.new("Sound",par)
	sn.Name = name
	sn.SoundId = id
	sn.Pitch = pitch
	sn.Volume = volume
	sn.Looped = loop
	Sounds[name]=sn
end

F.updateSound = function(sound,id,pit,vol)
	local sn = Sounds[sound]
	if id~=sn.SoundId then sn.SoundId = id end
	if pit~=sn.Pitch then sn.Pitch = pit end
	if vol~=sn.Volume then sn.Volume = vol end
end

F.playSound = function(sound)
	Sounds[sound]:Play()
end

F.pauseSound = function(sound)
	Sounds[sound]:Pause()
end

F.stopSound = function(sound)
	Sounds[sound]:Stop()
end

F.removeSound = function(sound)
	Sounds[sound]:Stop()
	Sounds[sound]:Destroy()
	Sounds[sound]=nil
end

script.Parent.OnServerEvent:connect(function(pl,Fnc,...)
	F[Fnc](...)
end)

car.DriveSeat.ChildRemoved:connect(function(child)
	if child.Name=="SeatWeld" then
		F.removeSound("Rev")
	end
end)]]
	elseif v.Parent.Name == "Backfire_FE" then
		source = [[local car = script.Parent.Parent
local F = {}

F.Backfire1 = function()
	car.Body.Exhaust.Backfire1.Backfire1:play()
	car.Body.Exhaust.Backfire2.Backfire1:play()
	car.Body.Exhaust.Backfire1.Fire.Enabled = true
	car.Body.Exhaust.Backfire2.Fire.Enabled = true
	car.Body.Exhaust.BFLight1.SpotLight.Enabled = true
	car.Body.Exhaust.BFLight2.SpotLight.Enabled = true
	wait (0.03)
	car.Body.Exhaust.Backfire1.Fire.Enabled = false
	car.Body.Exhaust.Backfire2.Fire.Enabled = false
	car.Body.Exhaust.BFLight1.SpotLight.Enabled = false
	car.Body.Exhaust.BFLight2.SpotLight.Enabled = false
	wait (0.07)
end

F.Backfire2 = function()
	car.Body.Exhaust.Backfire1.Backfire2:play()
	car.Body.Exhaust.Backfire2.Backfire2:play()
	car.Body.Exhaust.Backfire1.Fire.Enabled = true
	car.Body.Exhaust.Backfire2.Fire.Enabled = true
	car.Body.Exhaust.BFLight1.SpotLight.Enabled = true
	car.Body.Exhaust.BFLight2.SpotLight.Enabled = true
	wait (0.03)
	car.Body.Exhaust.Backfire1.Fire.Enabled = false
	car.Body.Exhaust.Backfire2.Fire.Enabled = false
	car.Body.Exhaust.BFLight1.SpotLight.Enabled = false
	car.Body.Exhaust.BFLight2.SpotLight.Enabled = false
	wait (0.07)
end


script.Parent.OnServerEvent:connect(function(pl,Fnc,...)
	F[Fnc](...)
end)

car.DriveSeat.ChildRemoved:connect(function(child)
	if child.Name=="SeatWeld" then
		car.Body.Exhaust.Backfire1.Fire.Enabled = false
		car.Body.Exhaust.Backfire2.Fire.Enabled = false
		car.Body.Exhaust.BFLight1.SpotLight.Enabled = false
		car.Body.Exhaust.BFLight2.SpotLight.Enabled = false
	end
end)]]
	elseif v.Parent.Name == "Smoke_FE" then
		source = [[local car = script.Parent.Parent
local F = {}

F.UpdateSmoke = function(rl,rr)
	car.Wheels.RL.Smoke.Rate = rl
	car.Wheels.RR.Smoke.Rate = rr
	car.Wheels.RL.SQ.Volume = rl/50
	car.Wheels.RR.SQ.Volume = rr/50
end

script.Parent.OnServerEvent:connect(function(pl,Fnc,...)
	F[Fnc](...)
end)

car.DriveSeat.ChildRemoved:connect(function(child)
	if child.Name=="SeatWeld" then
		car.Wheels.RL.SQ:Stop()
		car.Wheels.RR.SQ:Stop()
		car.Wheels.RL.Smoke.Rate=0
		car.Wheels.RR.Smoke.Rate=0
	end
end)

for i,v in pairs(car.Wheels:GetChildren()) do
	if v.Name=="RL" or v.Name=="RR" or v.Name=="R" then
		local sq = script.Parent.SQ:Clone()
		sq.Parent=v
		local sm = script.Parent.Smoke:Clone()
		sm.Parent=v
	end
end]]
	elseif v.Name == "Initialize" and v:FindFirstChild("MiscWeld") then
		source = [[--[[
		___      _______                _     
	   / _ |____/ ___/ /  ___ ____ ___ (_)__ 
	  / __ /___/ /__/ _ \/ _ `(_-<(_-</ (_-<
	 /_/ |_|   \___/_//_/\_,_/___/___/_/___/
 						SecondLogic @ Inspare
]

		--[[START]

		_BuildVersion = require(script.Parent.README)

		--[[Weld functions]

		local JS = game:GetService("JointsService")
		local PGS_ON = workspace:PGSIsEnabled()

		function MakeWeld(x,y,type,s) 
			if type==nil then type="Weld" end
			local W=Instance.new(type,JS) 
			W.Part0=x W.Part1=y 
			W.C0=x.CFrame:inverse()*x.CFrame 
			W.C1=y.CFrame:inverse()*x.CFrame 
			if type=="Motor" and s~=nil then 
				W.MaxVelocity=s 
			end 
			return W	
		end

		function ModelWeld(a,b) 
			if a:IsA("BasePart") then 
				MakeWeld(b,a,"Weld") 
			elseif a:IsA("Model") then 
				for i,v in pairs(a:GetChildren()) do 
					ModelWeld(v,b) 
				end 
			end 
		end

		function UnAnchor(a) 
			if a:IsA("BasePart") then a.Anchored=false  end for i,v in pairs(a:GetChildren()) do UnAnchor(v) end 
		end



		--[[Initialize]

		script.Parent:WaitForChild("A-Chassis Interface")
		script.Parent:WaitForChild("Plugins")
		script.Parent:WaitForChild("README")

		local car=script.Parent.Parent
		local _Tune=require(script.Parent)

		wait(_Tune.LoadDelay)

		--Weight Scaling
		local weightScaling = _Tune.WeightScaling
		if not workspace:PGSIsEnabled() then
			weightScaling = _Tune.LegacyScaling
		end

		local Drive=car.Wheels:GetChildren()

		--Remove Existing Mass
		function DReduce(p)
			for i,v in pairs(p:GetChildren())do
				if v:IsA("BasePart") then
					if v.CustomPhysicalProperties == nil then v.CustomPhysicalProperties = PhysicalProperties.new(v.Material) end
					v.CustomPhysicalProperties = PhysicalProperties.new(
						0,
						v.CustomPhysicalProperties.Friction,
						v.CustomPhysicalProperties.Elasticity,
						v.CustomPhysicalProperties.FrictionWeight,
						v.CustomPhysicalProperties.ElasticityWeight
					)
				end
				DReduce(v)
			end
		end
		DReduce(car)



		--[[Wheel Configuration]	

		--Store Reference Orientation Function
		function getParts(model,t,a)
			for i,v in pairs(model:GetChildren()) do
				if v:IsA("BasePart") then table.insert(t,{v,a.CFrame:toObjectSpace(v.CFrame)})
				elseif v:IsA("Model") then getParts(v,t,a)
				end
			end
		end

		--PGS/Legacy
		local fDensity = _Tune.FWheelDensity
		local rDensity = _Tune.RWheelDensity
		if not PGS_ON then
			fDensity = _Tune.FWLgcyDensity
			rDensity = _Tune.RWLgcyDensity
		end

		local fDistX=_Tune.FWsBoneLen*math.cos(math.rad(_Tune.FWsBoneAngle))
		local fDistY=_Tune.FWsBoneLen*math.sin(math.rad(_Tune.FWsBoneAngle))
		local rDistX=_Tune.RWsBoneLen*math.cos(math.rad(_Tune.RWsBoneAngle))
		local rDistY=_Tune.RWsBoneLen*math.sin(math.rad(_Tune.RWsBoneAngle))

		local fSLX=_Tune.FSusLength*math.cos(math.rad(_Tune.FSusAngle))
		local fSLY=_Tune.FSusLength*math.sin(math.rad(_Tune.FSusAngle))
		local rSLX=_Tune.RSusLength*math.cos(math.rad(_Tune.RSusAngle))
		local rSLY=_Tune.RSusLength*math.sin(math.rad(_Tune.RSusAngle))

		for _,v in pairs(Drive) do
			--Apply Wheel Density
			if v.Name=="FL" or v.Name=="FR" or v.Name=="F" then
				if v:IsA("BasePart") then
					if v.CustomPhysicalProperties == nil then v.CustomPhysicalProperties = PhysicalProperties.new(v.Material) end
					v.CustomPhysicalProperties = PhysicalProperties.new(
						fDensity,
						v.CustomPhysicalProperties.Friction,
						v.CustomPhysicalProperties.Elasticity,
						v.CustomPhysicalProperties.FrictionWeight,
						v.CustomPhysicalProperties.ElasticityWeight
					)
				end
			else
				if v:IsA("BasePart") then
					if v.CustomPhysicalProperties == nil then v.CustomPhysicalProperties = PhysicalProperties.new(v.Material) end
					v.CustomPhysicalProperties = PhysicalProperties.new(
						rDensity,
						v.CustomPhysicalProperties.Friction,
						v.CustomPhysicalProperties.Elasticity,
						v.CustomPhysicalProperties.FrictionWeight,
						v.CustomPhysicalProperties.ElasticityWeight
					)
				end		
			end

			--Resurface Wheels
			for _,a in pairs({"Top","Bottom","Left","Right","Front","Back"}) do
				v[a.."Surface"]=Enum.SurfaceType.SmoothNoOutlines
			end

			--Store Axle-Anchored/Suspension-Anchored Part Orientation
			local WParts = {}

			local tPos = v.Position-car.DriveSeat.Position
			if v.Name=="FL" or v.Name=="RL" then
				v.CFrame = car.DriveSeat.CFrame*CFrame.Angles(math.rad(90),0,math.rad(90))
			else
				v.CFrame = car.DriveSeat.CFrame*CFrame.Angles(math.rad(90),0,math.rad(-90))
			end
			v.CFrame = v.CFrame+tPos

			if v:FindFirstChild("Parts")~=nil then
				getParts(v.Parts,WParts,v)
			end
			if v:FindFirstChild("Fixed")~=nil then
				getParts(v.Fixed,WParts,v)
			end

			--Align Wheels
			if v.Name=="FL" or v.Name=="FR" then
				v.CFrame = v.CFrame*CFrame.Angles(math.rad(_Tune.FCamber),0,0)
				if v.Name=="FL" then
					v.CFrame = v.CFrame*CFrame.Angles(0,0,math.rad(_Tune.FToe))
				else
					v.CFrame = v.CFrame*CFrame.Angles(0,0,math.rad(-_Tune.FToe))
				end
			elseif v.Name=="RL" or v.Name=="RR" then
				v.CFrame = v.CFrame*CFrame.Angles(math.rad(_Tune.RCamber),0,0)
				if v.Name=="RL" then
					v.CFrame = v.CFrame*CFrame.Angles(0,0,math.rad(_Tune.RToe))
				else
					v.CFrame = v.CFrame*CFrame.Angles(0,0,math.rad(-_Tune.RToe))
				end
			end

			--Re-orient Axle-Anchored/Suspension-Anchored Parts
			for _,a in pairs(WParts) do
				a[1].CFrame=v.CFrame:toWorldSpace(a[2])
			end



			--[[Chassis Assembly]
			--Create Steering Axle
			local arm=Instance.new("Part",v)
			arm.Name="Arm"
			arm.Anchored=true
			arm.CanCollide=false
			arm.FormFactor=Enum.FormFactor.Custom
			arm.Size=Vector3.new(_Tune.AxleSize,_Tune.AxleSize,_Tune.AxleSize)
			arm.CFrame=(v.CFrame*CFrame.new(0,_Tune.StAxisOffset,0))*CFrame.Angles(-math.pi/2,-math.pi/2,0)
			arm.CustomPhysicalProperties = PhysicalProperties.new(_Tune.AxleDensity,0,0,100,100)
			arm.TopSurface=Enum.SurfaceType.Smooth
			arm.BottomSurface=Enum.SurfaceType.Smooth
			arm.Transparency=1

			--Create Wheel Spindle
			local base=arm:Clone()
			base.Parent=v
			base.Name="Base"
			base.CFrame=base.CFrame*CFrame.new(0,_Tune.AxleSize,0)
			base.BottomSurface=Enum.SurfaceType.Hinge

			--Create Steering Anchor
			local axle=arm:Clone()
			axle.Parent=v
			axle.Name="Axle"
			axle.CFrame=CFrame.new(v.Position-((v.CFrame*CFrame.Angles(math.pi/2,0,0)).lookVector*((v.Size.x/2)+(axle.Size.x/2))),v.Position)*CFrame.Angles(0,math.pi,0)
			axle.BackSurface=Enum.SurfaceType.Hinge

			if v.Name=="F" or v.Name=="R" then
				local axle2=arm:Clone()
				axle2.Parent=v
				axle2.Name="Axle"
				axle2.CFrame=CFrame.new(v.Position+((v.CFrame*CFrame.Angles(math.pi/2,0,0)).lookVector*((v.Size.x/2)+(axle2.Size.x/2))),v.Position)*CFrame.Angles(0,math.pi,0)
				axle2.BackSurface=Enum.SurfaceType.Hinge
				MakeWeld(arm,axle2)
			end

			--Create Suspension
			if PGS_ON and _Tune.SusEnabled then			
				local sa=arm:Clone()
				sa.Parent=v
				sa.Name="#SA"
				if v.Name == "FL" or v.Name=="FR" or v.Name =="F" then
					local aOff = _Tune.FAnchorOffset
					sa.CFrame=v.CFrame*CFrame.new(_Tune.AxleSize/2,-fDistX,-fDistY)*CFrame.new(aOff[3],aOff[1],-aOff[2])*CFrame.Angles(-math.pi/2,-math.pi/2,0)
				else
					local aOff = _Tune.RAnchorOffset
					sa.CFrame=v.CFrame*CFrame.new(_Tune.AxleSize/2,-rDistX,-rDistY)*CFrame.new(aOff[3],aOff[1],-aOff[2])*CFrame.Angles(-math.pi/2,-math.pi/2,0)
				end

				local sb=sa:Clone()
				sb.Parent=v
				sb.Name="#SB"
				sb.CFrame=sa.CFrame*CFrame.new(0,0,_Tune.AxleSize)

				sb.FrontSurface=Enum.SurfaceType.Hinge	

				local g = Instance.new("BodyGyro",sb)
				g.Name = "Stabilizer"
				g.MaxTorque = Vector3.new(0,0,1)
				g.P = 0

				local sf1 = Instance.new("Attachment",sa)
				sf1.Name = "SAtt"

				local sf2 = sf1:Clone()
				sf2.Parent = sb


				if v.Name == "FL" or v.Name == "FR" or v.Name == "F" then
					sf1.Position = Vector3.new(fDistX-fSLX,-fDistY+fSLY,_Tune.AxleSize/2)
					sf2.Position = Vector3.new(fDistX,-fDistY,-_Tune.AxleSize/2)
				elseif v.Name == "RL" or v.Name=="RR" or v.Name == "R" then
					sf1.Position = Vector3.new(rDistX-rSLX,-rDistY+rSLY,_Tune.AxleSize/2)
					sf2.Position = Vector3.new(rDistX,-rDistY,-_Tune.AxleSize/2)
				end

				sb:MakeJoints()

				local sp = Instance.new("SpringConstraint",v)
				sp.Name = "Spring"
				sp.Attachment0 = sf1
				sp.Attachment1 = sf2
				sp.LimitsEnabled = true

				sp.Visible=_Tune.SusVisible
				sp.Radius=_Tune.SusRadius
				sp.Thickness=_Tune.SusThickness
				sp.Color=BrickColor.new(_Tune.SusColor)
				sp.Coils=_Tune.SusCoilCount

				if v.Name == "FL" or v.Name=="FR" or v.Name =="F" then
					g.D = _Tune.FAntiRoll
					sp.Damping = _Tune.FSusDamping
					sp.Stiffness = _Tune.FSusStiffness
					sp.FreeLength = _Tune.FSusLength+_Tune.FPreCompress
					sp.MaxLength = _Tune.FSusLength+_Tune.FExtensionLim
					sp.MinLength = _Tune.FSusLength-_Tune.FCompressLim
				else
					g.D = _Tune.RAntiRoll
					sp.Damping = _Tune.RSusDamping
					sp.Stiffness = _Tune.RSusStiffness
					sp.FreeLength = _Tune.RSusLength+_Tune.RPreCompress
					sp.MaxLength = _Tune.RSusLength+_Tune.RExtensionLim
					sp.MinLength = _Tune.RSusLength-_Tune.RCompressLim
				end

				MakeWeld(car.DriveSeat,sa)
				MakeWeld(sb,base)
			else
				MakeWeld(car.DriveSeat,base)
			end

			--Lock Rear Steering Axle
			if v.Name == "RL" or v.Name == "RR" or v.Name=="R" then
				MakeWeld(base,axle)
			end

			--Weld Assembly
			if v.Parent.Name == "RL" or v.Parent.Name == "RR" or v.Name=="R" then
				MakeWeld(car.DriveSeat,arm)
			end

			MakeWeld(arm,axle)

			arm:MakeJoints()
			axle:MakeJoints()

			--Weld Miscelaneous Parts
			if v:FindFirstChild("SuspensionFixed")~=nil then
				ModelWeld(v.SuspensionFixed,car.DriveSeat)
			end
			if v:FindFirstChild("WheelFixed")~=nil then
				ModelWeld(v.WheelFixed,axle)
			end
			if v:FindFirstChild("Fixed")~=nil then
				ModelWeld(v.Fixed,arm)
			end

			--Weld Wheel Parts
			if v:FindFirstChild("Parts")~=nil then
				ModelWeld(v.Parts,v)
			end

			--Add Steering Gyro
			if v:FindFirstChild("Steer") then
				v:FindFirstChild("Steer"):Destroy()
			end

			if v.Name=="FL" or v.Name=="FR" or v.Name=="F" then
				local steer=Instance.new("BodyGyro",arm)
				steer.Name="Steer"
				steer.P=_Tune.SteerP
				steer.D=_Tune.SteerD
				steer.MaxTorque=Vector3.new(0,_Tune.SteerMaxTorque,0)
				steer.cframe=v.CFrame*CFrame.Angles(0,-math.pi/2,0)
			end

			--Add Stabilization Gyro
			local gyro=Instance.new("BodyGyro",v)
			gyro.Name="Stabilizer"
			gyro.MaxTorque=Vector3.new(1,0,1)
			gyro.P=0
			if v.Name=="FL" or v.Name=="FR"  or v.Name=="F" then
				gyro.D=_Tune.FGyroDamp
			else
				gyro.D=_Tune.RGyroDamp
			end

			--Add Rotational BodyMover
			local AV=Instance.new("BodyAngularVelocity",v)
			AV.Name="#AV"
			AV.angularvelocity=Vector3.new(0,0,0)
			AV.maxTorque=Vector3.new(_Tune.PBrakeForce,0,_Tune.PBrakeForce)
			AV.P=1e9
		end



		--[[Vehicle Weight]	
		--Determine Current Mass
		local mass=0

		function getMass(p)
			for i,v in pairs(p:GetChildren())do
				if v:IsA("BasePart") then
					mass=mass+v:GetMass()
				end
				getMass(v)
			end	
		end
		getMass(car)

		--Apply Vehicle Weight
		if mass<_Tune.Weight*weightScaling then
			--Calculate Weight Distribution
			local centerF = Vector3.new()
			local centerR = Vector3.new()
			local countF = 0
			local countR = 0

			for i,v in pairs(Drive) do
				if v.Name=="FL" or v.Name=="FR" or v.Name=="F" then
					centerF = centerF+v.CFrame.p
					countF = countF+1
				else
					centerR = centerR+v.CFrame.p
					countR = countR+1
				end
			end
			centerF = centerF/countF
			centerR = centerR/countR
			local center = centerR:Lerp(centerF, _Tune.WeightDist/100)  

			--Create Weight Brick
			local weightB = Instance.new("Part",car.Body)
			weightB.Name = "#Weight"
			weightB.Anchored = true
			weightB.CanCollide = false
			weightB.BrickColor = BrickColor.new("Really black")
			weightB.TopSurface = Enum.SurfaceType.Smooth
			weightB.BottomSurface = Enum.SurfaceType.Smooth
			if _Tune.WBVisible then
				weightB.Transparency = .75			
			else
				weightB.Transparency = 1			
			end
			weightB.Size = Vector3.new(_Tune.WeightBSize[1],_Tune.WeightBSize[2],_Tune.WeightBSize[3])
			weightB.CustomPhysicalProperties = PhysicalProperties.new(((_Tune.Weight*weightScaling)-mass)/(weightB.Size.x*weightB.Size.y*weightB.Size.z),0,0,0,0)
			weightB.CFrame=(car.DriveSeat.CFrame-car.DriveSeat.Position+center)*CFrame.new(0,_Tune.CGHeight,0)
		else
			--Existing Weight Is Too Massive
			warn( "\n\t [AC".._BuildVersion.."]: Mass too high for specified weight."
				.."\n\t    Target Mass:\t"..(math.ceil(_Tune.Weight*weightScaling*100)/100)
				.."\n\t    Current Mass:\t"..(math.ceil(mass*100)/100)
				.."\n\t Reduce part size or axle density to achieve desired weight.")
		end

		local flipG = Instance.new("BodyGyro",car.DriveSeat)
		flipG.Name = "Flip"
		flipG.D = 0
		flipG.MaxTorque = Vector3.new(0,0,0)
		flipG.P = 0



		--[[Finalize Chassis]
		--Misc Weld
		wait()
		for i,v in pairs(script:GetChildren()) do
			if v:IsA("ModuleScript") then
				require(v)
			end
		end

		--Weld Body
		wait()
		ModelWeld(car.Body,car.DriveSeat)

		--Unanchor
		wait()	
		UnAnchor(car)

		--[[Manage Plugins]

		script.Parent["A-Chassis Interface"].Car.Value=car
		for i,v in pairs(script.Parent.Plugins:GetChildren()) do
			for _,a in pairs(v:GetChildren()) do
				if a:IsA("RemoteEvent") or a:IsA("RemoteFunction") then 
					a.Parent=car
					for _,b in pairs(a:GetChildren()) do
						if b:IsA("Script") then b.Disabled=false end
					end	
				end
			end
			v.Parent = script.Parent["A-Chassis Interface"]
		end
		script.Parent.Plugins:Destroy()



		--[[Remove Character Weight]
		--Get Seats
		local Seats = {}
		function getSeats(p)
			for i,v in pairs(p:GetChildren()) do
				if v:IsA("VehicleSeat") or v:IsA("Seat") then
					local seat = {}
					seat.Seat = v
					seat.Parts = {}
					table.insert(Seats,seat)
				end
				getSeats(v)
			end	
		end
		getSeats(car)

		--Store Physical Properties/Remove Mass Function
		function getPProperties(mod,t)
			for i,v in pairs(mod:GetChildren()) do
				if v:IsA("BasePart") then
					if v.CustomPhysicalProperties == nil then v.CustomPhysicalProperties = PhysicalProperties.new(v.Material) end
					table.insert(t,{v,v.CustomPhysicalProperties})
					v.CustomPhysicalProperties = PhysicalProperties.new(
						0,
						v.CustomPhysicalProperties.Friction,
						v.CustomPhysicalProperties.Elasticity,
						v.CustomPhysicalProperties.FrictionWeight,
						v.CustomPhysicalProperties.ElasticityWeight
					)
				end
				getPProperties(v,t)
			end			
		end

		--Apply Seat Handler
		for i,v in pairs(Seats) do
			--Sit Handler
			v.Seat.ChildAdded:connect(function(child)
				if child.Name=="SeatWeld" and child:IsA("Weld") and child.Part1~=nil and child.Part1.Parent ~= workspace and not child.Part1.Parent:IsDescendantOf(car) then
					v.Parts = {}
					getPProperties(child.Part1.Parent,v.Parts)
				end
			end)

			--Leave Handler
			v.Seat.ChildRemoved:connect(function(child)
				if child.Name=="SeatWeld" and child:IsA("Weld") then
					for i,v in pairs(v.Parts) do
						if v[1]~=nil and v[2]~=nil and v[1]:IsDescendantOf(workspace) then
							v[1].CustomPhysicalProperties = v[2]
						end
					end
					v.Parts = {}
				end
			end)
		end



		--[[Driver Handling]

		--Driver Sit	
		car.DriveSeat.ChildAdded:connect(function(child)
			if child.Name=="SeatWeld" and child:IsA("Weld") and game.Players:GetPlayerFromCharacter(child.Part1.Parent)~=nil then
				--Distribute Client Interface
				local p=game.Players:GetPlayerFromCharacter(child.Part1.Parent)
				car.DriveSeat:SetNetworkOwner(p)
				local g=script.Parent["A-Chassis Interface"]:Clone()
				g.Parent=p.PlayerGui
			end
		end)

		--Driver Leave
		car.DriveSeat.ChildRemoved:connect(function(child)
			if child.Name=="SeatWeld" and child:IsA("Weld") then
				--Remove Flip Force
				if car.DriveSeat:FindFirstChild("Flip")~=nil then
					car.DriveSeat.Flip.MaxTorque = Vector3.new()
				end

				--Remove Wheel Force
				for i,v in pairs(car.Wheels:GetChildren()) do
					if v:FindFirstChild("#AV")~=nil then
						if v["#AV"]:IsA("BodyAngularVelocity") then
							if v["#AV"].AngularVelocity.Magnitude>0 then
								v["#AV"].AngularVelocity = Vector3.new()
								v["#AV"].MaxTorque = Vector3.new()
							end
						else
							if v["#AV"].AngularVelocity>0 then
								v["#AV"].AngularVelocity = 0
								v["#AV"].MotorMaxTorque = 0
							end
						end
					end
				end
			end
		end)

		--[END]]
	elseif v.Name == "SwordScript" then
		source = [[--Rescripted by Luckymaxer
--EUROCOW WAS HERE BECAUSE I MADE THE PARTICLES AND THEREFORE THIS ENTIRE SWORD PRETTY AND LOOK PRETTY WORDS AND I'D LIKE TO DEDICATE THIS TO MY FRIENDS AND HI LUCKYMAXER PLS FIX SFOTH SWORDS TY LOVE Y'ALl
--Updated for R15 avatars by StarWars
--Re-updated by TakeoHonorable

Tool = script.Parent
Handle = Tool:WaitForChild("Handle")

function Create(ty)
	return function(data)
		local obj = Instance.new(ty)
		for k, v in pairs(data) do
			if type(k) == 'number' then
				v.Parent = obj
			else
				obj[k] = v
			end
		end
		return obj
	end
end

local BaseUrl = "rbxassetid://"

Players = game:GetService("Players")
Debris = game:GetService("Debris")
RunService = game:GetService("RunService")

DamageValues = {
	BaseDamage = 5,
	SlashDamage = 10,
	LungeDamage = 30
}

--For R15 avatars
Animations = {
	R15Slash = 522635514,
	R15Lunge = 522638767
}

Damage = DamageValues.BaseDamage

Grips = {
	Up = CFrame.new(0, 0, -1.70000005, 0, 0, 1, 1, 0, 0, 0, 1, 0),
	Out = CFrame.new(0, 0, -1.70000005, 0, 1, 0, 1, -0, 0, 0, 0, -1)
}

Sounds = {
	Slash = Handle:WaitForChild("SwordSlash"),
	Lunge = Handle:WaitForChild("SwordLunge"),
	Unsheath = Handle:WaitForChild("Unsheath")
}

ToolEquipped = false

--For Omega Rainbow Katana thumbnail to display a lot of particles.
for i, v in pairs(Handle:GetChildren()) do
	if v:IsA("ParticleEmitter") then
		v.Rate = 20
	end
end

Tool.Grip = Grips.Up
Tool.Enabled = true

function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end

function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end

function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end

function Blow(Hit)
	if not Hit or not Hit.Parent or not CheckIfAlive() or not ToolEquipped then
		return
	end
	local RightArm = Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
	if not RightArm then
		return
	end
	local RightGrip = RightArm:FindFirstChild("RightGrip")
	if not RightGrip or (RightGrip.Part0 ~= Handle and RightGrip.Part1 ~= Handle) then
		return
	end
	local character = Hit.Parent
	if character == Character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health == 0 then
		return
	end
	local player = Players:GetPlayerFromCharacter(character)
	if player and (player == Player or IsTeamMate(Player, player)) then
		return
	end
	UntagHumanoid(humanoid)
	TagHumanoid(humanoid, Player)
	humanoid:TakeDamage(Damage)	
end


function Attack()
	Damage = DamageValues.SlashDamage
	Sounds.Slash:Play()

	if Humanoid then
		if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			local Anim = Instance.new("StringValue")
			Anim.Name = "toolanim"
			Anim.Value = "Slash"
			Anim.Parent = Tool
		elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
			local Anim = Tool:FindFirstChild("R15Slash")
			if Anim then
				local Track = Humanoid:LoadAnimation(Anim)
				Track:Play(0)
			end
		end
	end	
end

function Lunge()
	Damage = DamageValues.LungeDamage

	Sounds.Lunge:Play()
	
	if Humanoid then
		if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			local Anim = Instance.new("StringValue")
			Anim.Name = "toolanim"
			Anim.Value = "Lunge"
			Anim.Parent = Tool
		elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
			local Anim = Tool:FindFirstChild("R15Lunge")
			if Anim then
				local Track = Humanoid:LoadAnimation(Anim)
				Track:Play(0)
			end
		end
	end	
	--[[
	if CheckIfAlive() then
		local Force = Instance.new("BodyVelocity")
		Force.velocity = Vector3.new(0, 10, 0) 
		Force.maxForce = Vector3.new(0, 4000, 0)
		Debris:AddItem(Force, 0.4)
		Force.Parent = Torso
	end
	]

		wait(0.2)
		Tool.Grip = Grips.Out
		wait(0.6)
		Tool.Grip = Grips.Up

		Damage = DamageValues.SlashDamage
	end

	Tool.Enabled = true
	LastAttack = 0

	function Activated()
		if not Tool.Enabled or not ToolEquipped or not CheckIfAlive() then
			return
		end
		Tool.Enabled = false
		local Tick = RunService.Stepped:wait()
		if (Tick - LastAttack < 0.2) then
			Lunge()
		else
			Attack()
		end
		LastAttack = Tick
		--wait(0.5)
		Damage = DamageValues.BaseDamage
		local SlashAnim = (Tool:FindFirstChild("R15Slash") or Create("Animation"){
			Name = "R15Slash",
			AnimationId = BaseUrl .. Animations.R15Slash,
			Parent = Tool
		})

		local LungeAnim = (Tool:FindFirstChild("R15Lunge") or Create("Animation"){
			Name = "R15Lunge",
			AnimationId = BaseUrl .. Animations.R15Lunge,
			Parent = Tool
		})
		Tool.Enabled = true
	end

	function CheckIfAlive()
		return (((Player and Player.Parent and Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent) and true) or false)
	end

	function Equipped()
		Character = Tool.Parent
		Player = Players:GetPlayerFromCharacter(Character)
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
		Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")
		if not CheckIfAlive() then
			return
		end
		ToolEquipped = true
		Sounds.Unsheath:Play()
	end

	function Unequipped()
		Tool.Grip = Grips.Up
		ToolEquipped = false
	end

	Tool.Activated:Connect(Activated)
	Tool.Equipped:Connect(Equipped)
	Tool.Unequipped:Connect(Unequipped)

	Connection = Handle.Touched:Connect(Blow)]]
	elseif v.Parent.Name == "WeaponSpawner" then
		source = [[-- See if I have a tool
local spawner = script.Parent
local tool = nil
local region = Region3.new(Vector3.new(spawner.Position.X - spawner.Size.X/2, spawner.Position.Y + spawner.Size.Y/2, spawner.Position.Z - spawner.Size.Z/2),
   Vector3.new(spawner.Position.X + spawner.Size.X/2, spawner.Position.Y + 4, spawner.Position.Z + spawner.Size.Z/2))
local parts = game.Workspace:FindPartsInRegion3(region)
for _, part in pairs(parts) do
	if part and part.Parent and part.Parent:IsA("Tool") then
		tool = part.Parent
		break
	end
end

local configTable = spawner.Configurations
local configs = {}
local function loadConfig(configName, defaultValue)
	if configTable:FindFirstChild(configName) then
		configs[configName] = configTable:FindFirstChild(configName).Value
	else
		configs[configName] = defaultValue
	end
end

loadConfig("SpawnCooldown", 5)

if tool then
	tool.Parent = game.ServerStorage
	
	while true do
		-- put tool on pad
		local toolCopy = tool:Clone()
		local handle = toolCopy:FindFirstChild("Handle")
		toolCopy.Parent = game.Workspace
		local toolOnPad = true
		local parentConnection
		parentConnection = toolCopy.AncestryChanged:connect(function()
			if handle then handle.Anchored = false end
			toolOnPad = false
			parentConnection:disconnect()
		end)
		if handle then
			handle.CFrame = (spawner.CFrame + Vector3.new(0,handle.Size.Z/2 + 1,0)) * CFrame.Angles(-math.pi/2,0,0)
			handle.Anchored = true
		end
		-- wait for tool to be removed
		while toolOnPad do 
			if handle then
				handle.CFrame = handle.CFrame * CFrame.Angles(0,0,math.pi/60)
			end
			wait() 
		end
		
		-- wait for cooldown
		wait(configs["SpawnCooldown"])		
	end
	
end



--if tool then
--	local handle = tool:FindFirstChild("Handle")
--	local toolCopy = tool:Clone()
--	toolCopy.Parent = game.ServerStorage
--	local toolOnPad = true	
--	
--	local parentConnection
--	parentConnection = tool.AncestryChanged:connect(function()
--		if handle then handle.Anchored = false end
--		toolOnPad = false
--		parentConnection:disconnect()
--	end)
--	
--	if handle then
--		handle.CFrame = (spawner.CFrame + Vector3.new(0,handle.Size.Z/2 + 1,0)) * CFrame.Angles(-math.pi/2,0,0)
--		handle.Anchored = true
--	end
--	
--	while true do
--		while toolOnPad do
--			if handle then
--				handle.CFrame = handle.CFrame * CFrame.Angles(0,0,math.pi/60)
--			end
--			wait()
--		end
--		wait(configs["SpawnCooldown"])
--		local newTool = toolCopy:Clone()
--		newTool.Parent = game.Workspace
--		handle = newTool:FindFirstChild("Handle")
--		toolOnPad = true
--	end
--end]]
	elseif v.Name == "ShootServer" then
		source = [[local DebrisService = game:GetService("Debris")
local IconURL = script.Parent.TextureId
local Tool = script.Parent

--------Main Events----------
local Events = Tool:WaitForChild("Events")
local ShootEvent = Events:WaitForChild("ShootRE")
local CreateBulletEvent = Events:WaitForChild("CreateBullet")

pcall(function()
	script.Parent:FindFirstChild("ThumbnailCamera"):Destroy()
	script.Parent:WaitForChild("READ ME"):Destroy()
	
	if not workspace:FindFirstChild("BulletFolder") then
	local BulletsFolder = Instance.new("Folder", workspace)
	BulletsFolder.Name = "BulletsFolder"
	end
end)
	
function TagHumanoid(humanoid, player)
	if humanoid.Health > 0 then
	while humanoid:FindFirstChild('creator') do
		humanoid:FindFirstChild('creator'):Destroy()
	end 
	
	local creatorTag = Instance.new("ObjectValue")
	creatorTag.Value = player
	creatorTag.Name = "creator"
	creatorTag.Parent = humanoid
	DebrisService:AddItem(creatorTag, 1.5)

	local weaponIconTag = Instance.new("StringValue")
	weaponIconTag.Value = IconURL
	weaponIconTag.Name = "icon"
		weaponIconTag.Parent = creatorTag
	end
end

function CreateBullet(bulletPos)
	if not workspace:FindFirstChild("BulletFolder") then
		local BulletFolder = Instance.new("Folder")
		BulletFolder.Name = "Bullets"
	end
	local bullet = Instance.new('Part', workspace.BulletsFolder)
	bullet.FormFactor = Enum.FormFactor.Custom
	bullet.Size = Vector3.new(0.1, 0.1, 0.1)
	bullet.BrickColor = BrickColor.new("Black")
	bullet.Shape = Enum.PartType.Block
	bullet.CanCollide = false
	bullet.CFrame = CFrame.new(bulletPos)
	bullet.Anchored = true
	bullet.TopSurface = Enum.SurfaceType.Smooth
	bullet.BottomSurface = Enum.SurfaceType.Smooth
	bullet.Name = 'Bullet'
	DebrisService:AddItem(bullet, 2.5)
	
	local shell = Instance.new("Part")
	shell.CFrame = Tool.Handle.CFrame * CFrame.fromEulerAnglesXYZ(1.5,0,0)
	shell.Size = Vector3.new(1,1,1)
	shell.BrickColor = BrickColor.new(226)
	shell.Parent = game.Workspace.BulletsFolder
	shell.CFrame = script.Parent.Handle.CFrame
	shell.CanCollide = false
	shell.Transparency = 0
	shell.BottomSurface = 0
	shell.TopSurface = 0
	shell.Name = "Shell"
	shell.Velocity = Tool.Handle.CFrame.lookVector * 35 + Vector3.new(math.random(-10,10),20,math.random(-10,20))
	shell.RotVelocity = Vector3.new(0,200,0)
	DebrisService:AddItem(shell, 1)
	
	local shellmesh = Instance.new("SpecialMesh")
	shellmesh.Scale = Vector3.new(.15,.4,.15)
	shellmesh.Parent = shell
end

ShootEvent.OnServerEvent:Connect(function(plr, hum ,damage)
	hum:TakeDamage(damage)
	TagHumanoid(hum, plr)
end)

CreateBulletEvent.OnServerEvent:Connect(function(plr, pos)
	CreateBullet(pos)
end)]]
	elseif v.Parent.Name == "Img" then
		source = [[local imgs = {103740493,103804266,103804383}
for _,v in pairs(imgs) do
	game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?ID="..v)
end

script.Parent.Parent.Changed:connect(function ()
	if script.Parent.Parent.Enabled == true then
		wait(0.09)
		script.Parent.Parent.Enabled = false
	end
end)

while true do
	for i = 1,#imgs do
		script.Parent.Image = "http://www.roblox.com/asset/?ID="..imgs[i]
		wait(0.03)
	end
end
]]
	elseif v.Name == "Animate" and v.Parent:FindFirstChildOfClass("Humanoid") then
		source = [[function   waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)
	if child then return child end
	while true do
		child = parent.ChildAdded:wait()
		if child.Name==childName then return child end
	end
end

local Figure = script.Parent
local Torso = waitForChild(Figure, "Torso")
local RightShoulder = waitForChild(Torso, "Right Shoulder")
local LeftShoulder = waitForChild(Torso, "Left Shoulder")
local RightHip = waitForChild(Torso, "Right Hip")
local LeftHip = waitForChild(Torso, "Left Hip")
local Neck = waitForChild(Torso, "Neck")
local Humanoid = waitForChild(Figure, "Humanoid")
local pose = "Standing"

local currentAnim = ""
local currentAnimTrack = nil
local currentAnimKeyframeHandler = nil
local currentAnimSpeed = 1.0
local animTable = {}
local animNames = { 
	idle = 	{	
				{ id = "http://www.roblox.com/asset/?id=125750544", weight = 9 },
				{ id = "http://www.roblox.com/asset/?id=125750618", weight = 1 }
			},
	walk = 	{ 	
				{ id = "http://www.roblox.com/asset/?id=125749145", weight = 10 } 
			}, 
	run = 	{
				{ id = "run.xml", weight = 10 } 
			}, 
	jump = 	{
				{ id = "http://www.roblox.com/asset/?id=125750702", weight = 10 } 
			}, 
	fall = 	{
				{ id = "http://www.roblox.com/asset/?id=125750759", weight = 10 } 
			}, 
	climb = {
				{ id = "http://www.roblox.com/asset/?id=125750800", weight = 10 } 
			}, 
	toolnone = {
				{ id = "http://www.roblox.com/asset/?id=125750867", weight = 10 } 
			},
	toolslash = {
				{ id = "http://www.roblox.com/asset/?id=129967390", weight = 10 } 
--				{ id = "slash.xml", weight = 10 } 
			},
	toollunge = {
				{ id = "http://www.roblox.com/asset/?id=129967478", weight = 10 } 
			},
	wave = {
				{ id = "http://www.roblox.com/asset/?id=128777973", weight = 10 } 
			},
	point = {
				{ id = "http://www.roblox.com/asset/?id=128853357", weight = 10 } 
			},
	dance = {
				{ id = "http://www.roblox.com/asset/?id=130018893", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=132546839", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=132546884", weight = 10 } 
			},
	dance2 = {
				{ id = "http://www.roblox.com/asset/?id=160934142", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=160934298", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=160934376", weight = 10 } 
			},
	dance3 = {
				{ id = "http://www.roblox.com/asset/?id=160934458", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=160934530", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=160934593", weight = 10 } 
			},
	laugh = {
				{ id = "http://www.roblox.com/asset/?id=129423131", weight = 10 } 
			},
	cheer = {
				{ id = "http://www.roblox.com/asset/?id=129423030", weight = 10 } 
			},
}

-- Existance in this list signifies that it is an emote, the value indicates if it is a looping emote
local emoteNames = { wave = false, point = false, dance = true, dance2 = true, dance3 = true, laugh = false, cheer = false}

math.randomseed(tick())

function configureAnimationSet(name, fileList)
	if (animTable[name] ~= nil) then
		for _, connection in pairs(animTable[name].connections) do
			connection:disconnect()
		end
	end
	animTable[name] = {}
	animTable[name].count = 0
	animTable[name].totalWeight = 0	
	animTable[name].connections = {}

	-- check for config values
	local config = script:FindFirstChild(name)
	if (config ~= nil) then
--		print("Loading anims " .. name)
		table.insert(animTable[name].connections, config.ChildAdded:connect(function(child) configureAnimationSet(name, fileList) end))
		table.insert(animTable[name].connections, config.ChildRemoved:connect(function(child) configureAnimationSet(name, fileList) end))
		local idx = 1
		for _, childPart in pairs(config:GetChildren()) do
			if (childPart:IsA("Animation")) then
				table.insert(animTable[name].connections, childPart.Changed:connect(function(property) configureAnimationSet(name, fileList) end))
				animTable[name][idx] = {}
				animTable[name][idx].anim = childPart
				local weightObject = childPart:FindFirstChild("Weight")
				if (weightObject == nil) then
					animTable[name][idx].weight = 1
				else
					animTable[name][idx].weight = weightObject.Value
				end
				animTable[name].count = animTable[name].count + 1
				animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
	--			print(name .. " [" .. idx .. "] " .. animTable[name][idx].anim.AnimationId .. " (" .. animTable[name][idx].weight .. ")")
				idx = idx + 1
			end
		end
	end

	-- fallback to defaults
	if (animTable[name].count <= 0) then
		for idx, anim in pairs(fileList) do
			animTable[name][idx] = {}
			animTable[name][idx].anim = Instance.new("Animation")
			animTable[name][idx].anim.Name = name
			animTable[name][idx].anim.AnimationId = anim.id
			animTable[name][idx].weight = anim.weight
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
--			print(name .. " [" .. idx .. "] " .. anim.id .. " (" .. anim.weight .. ")")
		end
	end
end

-- Setup animation objects
function scriptChildModified(child)
	local fileList = animNames[child.Name]
	if (fileList ~= nil) then
		configureAnimationSet(child.Name, fileList)
	end	
end

script.ChildAdded:connect(scriptChildModified)
script.ChildRemoved:connect(scriptChildModified)


for name, fileList in pairs(animNames) do 
	configureAnimationSet(name, fileList)
end	

-- ANIMATION

-- declarations
local toolAnim = "None"
local toolAnimTime = 0

local jumpAnimTime = 0
local jumpAnimDuration = 0.3

local toolTransitionTime = 0.1
local fallTransitionTime = 0.3
local jumpMaxLimbVelocity = 0.75

-- functions

function stopAllAnimations()
	local oldAnim = currentAnim

	-- return to idle if finishing an emote
	if (emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false) then
		oldAnim = "idle"
	end

	currentAnim = ""
	if (currentAnimKeyframeHandler ~= nil) then
		currentAnimKeyframeHandler:disconnect()
	end

	if (currentAnimTrack ~= nil) then
		currentAnimTrack:Stop()
		currentAnimTrack:Destroy()
		currentAnimTrack = nil
	end
	return oldAnim
end

function setAnimationSpeed(speed)
	if speed ~= currentAnimSpeed then
		currentAnimSpeed = speed
		currentAnimTrack:AdjustSpeed(currentAnimSpeed)
	end
end

function keyFrameReachedFunc(frameName)
	if (frameName == "End") then
--		print("Keyframe : ".. frameName)
		local repeatAnim = stopAllAnimations()
		local animSpeed = currentAnimSpeed
		playAnimation(repeatAnim, 0.0, Humanoid)
		setAnimationSpeed(animSpeed)
	end
end

-- Preload animations
function playAnimation(animName, transitionTime, humanoid)
	local idleFromEmote = (animName == "idle" and emoteNames[currentAnim] ~= nil)
	if (animName ~= currentAnim and not idleFromEmote) then		 
		
		if (currentAnimTrack ~= nil) then
			currentAnimTrack:Stop(transitionTime)
			currentAnimTrack:Destroy()
		end

		currentAnimSpeed = 1.0
		local roll = math.random(1, animTable[animName].totalWeight) 
		local origRoll = roll
		local idx = 1
		while (roll > animTable[animName][idx].weight) do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end
--		print(animName .. " " .. idx .. " [" .. origRoll .. "]")
		local anim = animTable[animName][idx].anim

		-- load it to the humanoid; get AnimationTrack
		currentAnimTrack = humanoid:LoadAnimation(anim)
		 
		-- play the animation
		currentAnimTrack:Play(transitionTime)
		currentAnim = animName

		-- set up keyframe name triggers
		if (currentAnimKeyframeHandler ~= nil) then
			currentAnimKeyframeHandler:disconnect()
		end
		currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
	end
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

local toolAnimName = ""
local toolAnimTrack = nil
local currentToolAnimKeyframeHandler = nil

function toolKeyFrameReachedFunc(frameName)
	if (frameName == "End") then
--		print("Keyframe : ".. frameName)
		local repeatAnim = stopToolAnimations()
		playToolAnimation(repeatAnim, 0.0, Humanoid)
	end
end


function playToolAnimation(animName, transitionTime, humanoid)
	if (animName ~= toolAnimName) then		 
		
		if (toolAnimTrack ~= nil) then
			toolAnimTrack:Stop()
			toolAnimTrack:Destroy()
			transitionTime = 0
		end

		local roll = math.random(1, animTable[animName].totalWeight) 
		local origRoll = roll
		local idx = 1
		while (roll > animTable[animName][idx].weight) do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end
--		print(animName .. " * " .. idx .. " [" .. origRoll .. "]")
		local anim = animTable[animName][idx].anim

		-- load it to the humanoid; get AnimationTrack
		toolAnimTrack = humanoid:LoadAnimation(anim)
		 
		-- play the animation
		toolAnimTrack:Play(transitionTime)
		toolAnimName = animName

		currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc)
	end
end

function stopToolAnimations()
	local oldAnim = toolAnimName

	if (currentToolAnimKeyframeHandler ~= nil) then
		currentToolAnimKeyframeHandler:disconnect()
	end

	toolAnimName = ""
	if (toolAnimTrack ~= nil) then
		toolAnimTrack:Stop()
		toolAnimTrack:Destroy()
		toolAnimTrack = nil
	end


	return oldAnim
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------


function onRunning(speed)
	if speed>0.01 then
		playAnimation("walk", 0.1, Humanoid)
		pose = "Running"
	else
		playAnimation("idle", 0.1, Humanoid)
		pose = "Standing"
	end
end

function onDied()
	pose = "Dead"
end

function onJumping()
	playAnimation("jump", 0.1, Humanoid)
	jumpAnimTime = jumpAnimDuration
	pose = "Jumping"
end

function onClimbing(speed)
	playAnimation("climb", 0.1, Humanoid)
	setAnimationSpeed(speed / 12.0)
	pose = "Climbing"
end

function onGettingUp()
	pose = "GettingUp"
end

function onFreeFall()
	if (jumpAnimTime <= 0) then
		playAnimation("fall", fallTransitionTime, Humanoid)
	end
	pose = "FreeFall"
end

function onFallingDown()
	pose = "FallingDown"
end

function onSeated()
	pose = "Seated"
end

function onPlatformStanding()
	pose = "PlatformStanding"
end

function onSwimming(speed)
	if speed>0 then
		pose = "Running"
	else
		pose = "Standing"
	end
end

function getTool()	
	for _, kid in ipairs(Figure:GetChildren()) do
		if kid.className == "Tool" then return kid end
	end
	return nil
end

function getToolAnim(tool)
	for _, c in ipairs(tool:GetChildren()) do
		if c.Name == "toolanim" and c.className == "StringValue" then
			return c
		end
	end
	return nil
end

function animateTool()
	
	if (toolAnim == "None") then
		playToolAnimation("toolnone", toolTransitionTime, Humanoid)
		return
	end

	if (toolAnim == "Slash") then
		playToolAnimation("toolslash", 0, Humanoid)
		return
	end

	if (toolAnim == "Lunge") then
		playToolAnimation("toollunge", 0, Humanoid)
		return
	end
end

function moveSit()
	RightShoulder.MaxVelocity = 0.15
	LeftShoulder.MaxVelocity = 0.15
	RightShoulder:SetDesiredAngle(3.14 /2)
	LeftShoulder:SetDesiredAngle(-3.14 /2)
	RightHip:SetDesiredAngle(3.14 /2)
	LeftHip:SetDesiredAngle(-3.14 /2)
end

local lastTick = 0

function move(time)
	local amplitude = 1
	local frequency = 1
  	local deltaTime = time - lastTick
  	lastTick = time

	local climbFudge = 0
	local setAngles = false

  	if (jumpAnimTime > 0) then
  		jumpAnimTime = jumpAnimTime - deltaTime
  	end

	if (pose == "FreeFall" and jumpAnimTime <= 0) then
		playAnimation("fall", fallTransitionTime, Humanoid)
	elseif (pose == "Seated") then
		stopAllAnimations()
		moveSit()
		return
	elseif (pose == "Running") then
		playAnimation("walk", 0.1, Humanoid)
	elseif (pose == "Dead" or pose == "GettingUp" or pose == "FallingDown" or pose == "Seated" or pose == "PlatformStanding") then
--		print("Wha " .. pose)
		amplitude = 0.1
		frequency = 1
		setAngles = true
	end

	if (setAngles) then
		desiredAngle = amplitude * math.sin(time * frequency)

		RightShoulder:SetDesiredAngle(desiredAngle + climbFudge)
		LeftShoulder:SetDesiredAngle(desiredAngle - climbFudge)
		RightHip:SetDesiredAngle(-desiredAngle)
		LeftHip:SetDesiredAngle(-desiredAngle)
	end

	-- Tool Animation handling
	local tool = getTool()
	if tool then
	
		animStringValueObject = getToolAnim(tool)

		if animStringValueObject then
			toolAnim = animStringValueObject.Value
			-- message recieved, delete StringValue
			animStringValueObject.Parent = nil
			toolAnimTime = time + .3
		end

		if time > toolAnimTime then
			toolAnimTime = 0
			toolAnim = "None"
		end

		animateTool()		
	else
		stopToolAnimations()
		toolAnim = "None"
		toolAnimTime = 0
	end
end

-- connect events
Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(onJumping)
Humanoid.Climbing:connect(onClimbing)
Humanoid.GettingUp:connect(onGettingUp)
Humanoid.FreeFalling:connect(onFreeFall)
Humanoid.FallingDown:connect(onFallingDown)
Humanoid.Seated:connect(onSeated)
Humanoid.PlatformStanding:connect(onPlatformStanding)
Humanoid.Swimming:connect(onSwimming)

-- main program

local runService = game:service("RunService");

-- initialize to idle
playAnimation("idle", 0.1, Humanoid)
pose = "Standing"

while Figure.Parent~=nil do
	local _, time = wait(0.1)
	move(time)
end


]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("ModuleScripts") then
		source = [[local zombie = script.Parent

for _, script in pairs(zombie.ModuleScripts:GetChildren()) do
	if not game.ServerStorage:FindFirstChild(script.Name) then
		script:Clone().Parent = game.ServerStorage
	end
end

local AI = require(game.ServerStorage.ROBLOX_ZombieAI).new(zombie)
local DestroyService = require(game.ServerStorage.ROBLOX_DestroyService)


local function clearParts(parent)
	for _, part in pairs(parent:GetChildren()) do
		clearParts(part)
	end
	local delay
	if parent:IsA("Part") then
		delay = math.random(5,10)
	else
		delay = 11
	end
	DestroyService:AddItem(parent, delay)
end

zombie.Humanoid.Died:connect(function()
	AI.Stop()
	math.randomseed(tick())
	clearParts(zombie)
	script.Disabled = true
end)

local lastMoan = os.time()
math.randomseed(os.time())
while true do
	local animationTrack = zombie.Humanoid:LoadAnimation(zombie.Animations.Arms)
	animationTrack:Play()
--	local now = os.time()
--	if now - lastMoan > 5 then	
--		if math.random() > .3 then
--			zombie.Moan:Play()
----			print("playing moan")
--			lastMoan = now
--		end
--	end
	wait(2)
end

]]
	elseif v.Name == "Sprint on shift" then
		source = [[function onPlayerEntered(player)
	repeat wait () until player.Character ~= nil
	local s = script.SprintScript:clone()
	s.Parent = player.Character
	s.Disabled = false
	player.CharacterAdded:connect(function (char)
		local s = script.SprintScript:clone()
		s.Parent = char
		s.Disabled = false		
	end)
end

game.Players.PlayerAdded:connect(onPlayerEntered)

--Fozetts was here--]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("Decal") and v.Parent.Name == "Checkpoint" then
		source = [[local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local checkpoint = script.Parent

function onTouched(hit)
	if hit and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid") then
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		local checkpointData = ServerStorage:FindFirstChild("CheckpointData")
		if not checkpointData then
			checkpointData = Instance.new("Folder")
			checkpointData.Name = "CheckpointData"
			checkpointData.Parent = ServerStorage
		end
		
		local userIdString = tostring(player.UserId)
		local checkpointValue = checkpointData:FindFirstChild(userIdString)
		if not checkpointValue then
			checkpointValue = Instance.new("ObjectValue")
			checkpointValue.Name = userIdString
			checkpointValue.Parent = checkpointData
			
			player.CharacterAdded:connect(function(character)
				wait()
				local storedCheckpoint = ServerStorage.CheckpointData[userIdString].Value
				character:MoveTo(storedCheckpoint.Position + Vector3.new(math.random(-4, 4), 4, math.random(-4, 4)))
			end)
		end
		
		checkpointValue.Value = checkpoint
	end
end

checkpoint.Touched:Connect(onTouched)]]
	end
	if v.Name == "Script" and v.Parent:FindFirstChild("firing") then
		source = [[script.Parent.ChildAdded:connect(function(child)
	if child.Name=="SeatWeld" then
		local flyer=script.LocalScript:Clone()
		flyer.Disabled= false
		flyer.Parent=script.Parent.Parent
		script.Parent.Parent.Parent=child.Part1.Parent
		script.Parent.Parent.Rotor1.sound:Play()
		for i,v in ipairs(script.Parent.Parent:GetChildren()) do
			if v:IsA("Seat") then
				v.Disabled = false
			end
		end
	end
end)

script.Parent.ChildRemoved:connect(function(child)
	if child.Name=="SeatWeld" then
		script.Parent.Parent.Parent=workspace
		---script.Parent.Parent.Engine:ClearAllChildren()
--		if script.Parent.Parent.Engine:FindFirstChild("BodyGyro") then
--			script.Parent.Parent.Engine.BodyGyro:Destroy()
--		end
--		if script.Parent.Parent.Engine:FindFirstChild("BodyVelocity") then
--			script.Parent.Parent.Engine.BodyBodyVelocity:Destroy()
--		end
		if script.Parent.Parent:FindFirstChild("LocalScript") then
			script.Parent.Parent:FindFirstChild("LocalScript"):Destroy()
		end
		script.Parent.Parent.Rotor1.sound:Stop()
		for i,v in ipairs(script.Parent.Parent:GetChildren()) do
			if v:IsA("Seat") then
				v.Disabled = true
			end
		end
	end
end)]]
	elseif v.Parent.Name == "firing" then
		source = [[local firin = false

script.Parent.OnServerEvent:Connect(function(plr,value,mouseHit,mouseTarget)
	firin = value
	wait()
	while firin do 
	wait()
		if mouseTarget == nil then return end
		if mouseTarget.Parent ~= script.Parent.Parent.Parent and mouseTarget.Parent.Parent ~= script.Parent.Parent.Parent then
			for i = 1, math.random(4,5) do
				script.Parent.Parent.fire:Play()
				local theTar = mouseHit.p + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
				local bull = Instance.new("Part")
				bull.Parent = game.Workspace
				bull.CFrame = CFrame.new((theTar + script.Parent.Parent.Parent.Gun1.Position)/2,script.Parent.Parent.Parent.Gun1.Position) --- script.Parent.Parent is the vehicle seat
				bull.CanCollide = false
				bull.BrickColor = BrickColor.new(24)
				bull.Anchored = true
				bull.Size = Vector3.new(1,1.2,1)
				game.Debris:AddItem(bull,0.1)
				local mesher = Instance.new("BlockMesh")
				mesher.Parent = bull
				mesher.Scale = Vector3.new(0.2, 0.2, (mouseHit.p - script.Parent.Parent.Parent.Gun1.Position).magnitude)
				local ex = Instance.new("Explosion")
				ex.BlastRadius = 5
				ex.BlastPressure = 5000
				ex.Position = theTar
				ex.Parent = game.Workspace
				wait(0.06)
			end
		end
	end
end)]]
	elseif v.Name == "Weld Script" then
		source = [[script.Parent:MakeJoints()]]
	elseif v.Name == "regen" and v.Parent.Name == "Button1" then
		source = [[-- dark886's click regen script 
-- just place this script to the button
-- just place the button to the model
-- just place the model to anywhere lol

location = script.Parent.Parent.Parent
regen = script.Parent.Parent
save = regen:clone()

function onClicked()
	regen:remove()
	back = save:clone()
	back.Parent = location
	back:MakeJoints()
end 

script.Parent.ClickDetector.MouseClick:connect(onClicked)]]
	elseif v.Parent.Parent:GetChildren()[72] and v.Parent.Name == "Part" and v.Name == "Script" then
		source = [[local block = script.Parent
db = false

function onTouch()
	if db == false then
		db = true
		for i = 1, 20 do
			block.Transparency = i/20
			wait(0.05)
		end
		block.CanCollide = false
		wait(2)
		block.CanCollide = true
		block.Transparency = 0
		db = false
	end
end

block.Touched:connect(onTouch)
]]
	elseif v.Name == "Script" and v.Parent.Name == "SitPart" then
		source = [[script.Parent.Touched:connect(function(obj)
	if obj.Parent:FindFirstChild("Humanoid") then
		obj.Parent.Humanoid.Sit = true
	end
end)]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("Hinge") and v.Parent.Name == "Obby" then
		source = [[local hinge = script.Parent.Hinge
local pole = script.Parent.Pole
local base = script.Parent.Base

pole.BodyGyro.cframe = pole.CFrame
base.BodyPosition.Position = base.Position

for i, v in pairs(script.Parent:GetChildren()) do
	if v:IsA("BasePart") and v ~= hinge then
		v.Anchored = false
	end
end]]
	elseif v.Name == "SeeSawScript" then
		source = [[local Swing = script.Parent:WaitForChild("Swing")

-- Seats
local Seat1 = Swing:WaitForChild("Seat1")
local Seat2 = Swing:WaitForChild("Seat2")

-- Motor(s)
local SeeSawMotor = script.Parent:WaitForChild("SeeSawMotor")

local function OnSeatsChange(ChangedSeat)
	local Seat1Occupant = Seat1.Occupant
	local Seat2Occupant = Seat2.Occupant
	local Seat1T = Seat1.Throttle
	local Seat2T = Seat2.Throttle
	
	if Seat1Occupant and Seat2Occupant == nil then
		SeeSawMotor.DesiredAngle = 0.3
	elseif Seat2Occupant and Seat1Occupant == nil then
		SeeSawMotor.DesiredAngle = -0.3
	end
	
	if Seat1Occupant and Seat2Occupant then

		-- When both inputs are equal or would seem equal, make it balanced
		if Seat2T == 0 and Seat1T == 0 or Seat1T == -1 and Seat2T == -1 or Seat1T == 1 and Seat2T == 1 or Seat1T == -1 and Seat2T == 0 or Seat1T == 0 and Seat2T == -1 then
			SeeSawMotor.DesiredAngle = 0
			return
		end

		-- Seat1 logic
		if Seat1T == 1 and Seat2T == 0 or Seat1T == 1 and Seat2T == -1 then
			SeeSawMotor.DesiredAngle = 0.3
		end
		
		-- Seat2 logic
		if Seat2T == 1 and Seat1T == 0 or Seat2T == 1 and Seat1T == -1 then
			SeeSawMotor.DesiredAngle = -0.3
		end
	end
end

-- Events to listen to any player inputs
Seat1.Changed:connect(OnSeatsChange)
Seat2.Changed:connect(OnSeatsChange)]]
	elseif v.Name == "SwingScript" then
		source = [[local Home = script.Parent
local Supports = Home:WaitForChild("Supports")
local Swing1 = Home:WaitForChild("Swing1")
local Swing2 = Home:WaitForChild("Swing2")

-- Parts
local Frame = Home:WaitForChild("Frame")

local Hook1 = Swing1:WaitForChild("Hook1")
local Hook2 = Swing1:WaitForChild("Hook2")
local Hook3 = Swing2:WaitForChild("Hook3")
local Hook4 = Swing2:WaitForChild("Hook4")
local SwingSeat1 = Swing1:WaitForChild("SwingSeat1")
local SwingSeat2 = Swing2:WaitForChild("SwingSeat2")
local SwingMesh1 = Swing1:WaitForChild("SwingMesh1")
local SwingMesh2 = Swing2:WaitForChild("SwingMesh2")

local RopeSupport1 = Supports:WaitForChild("RopeSupport1")
local RopeSupport2 = Supports:WaitForChild("RopeSupport2")
local RopeSupport3 = Supports:WaitForChild("RopeSupport3")
local RopeSupport4 = Supports:WaitForChild("RopeSupport4")

-- Other
local CurrentOccupant = nil
local Vector3New,CFrameNew,CFrameAngles,MathRad,MathAbs = Vector3.new,CFrame.new,CFrame.Angles,math.rad,math.abs

-- Settings
local Configuration = Home:WaitForChild("Configuration")
local SwingPower = Configuration:WaitForChild("SwingPower")

local function SetPhysicalProperties(Part,Density)
	if Part then
		Part.CustomPhysicalProperties = PhysicalProperties.new(Density,Part.Friction,Part.Elasticity)
	end
end

GetAllDescendants = function(instance, func)
	func(instance)
	for _, child in next, instance:GetChildren() do
		GetAllDescendants(child, func)
	end
end

local function SetCharacterToWeight(ToDensity,Char)
	GetAllDescendants(Char,function(d)
		if d and d.Parent and d:IsA("BasePart") then
			SetPhysicalProperties(d,ToDensity)
		end
	end)
end

local function OnSeatChange(Seat)
	if Seat.Occupant then
		local CurrentThrottle = Seat.Throttle
		local BodyForce = Seat:WaitForChild("BodyForce")
		
		-- Adjust swing when interacted
		if CurrentThrottle == 1 then
			BodyForce.Force = Seat.CFrame.lookVector * SwingPower.Value * 100
		elseif CurrentThrottle == -1 then
			BodyForce.Force = Seat.CFrame.lookVector * SwingPower.Value * -100
		else
			BodyForce.Force = Vector3New()
		end
		
		delay(0.2,function()
			BodyForce.Force = Vector3New()
		end)
		
		-- Make the character weightless for the swing to behave correctly
		if CurrentOccupant == nil then
			CurrentOccupant = Seat.Occupant
			SetCharacterToWeight(0,CurrentOccupant.Parent)
		end
		
	elseif CurrentOccupant then
		-- Set the character's weight back
		SetCharacterToWeight(0.7,CurrentOccupant.Parent)
		CurrentOccupant = nil
	end
end

SwingSeat1.Changed:connect(function()
	OnSeatChange(SwingSeat1)
end)

SwingSeat2.Changed:connect(function()
	OnSeatChange(SwingSeat2)
end)]]
	elseif v.Name == "TireSwingScript" then
		source = [[local Home = script.Parent
local Tire = Home:WaitForChild("Tire")
local TopBar = Home:WaitForChild("TopBar")

-- Parts
local TopBarPart = Home:WaitForChild("TopBarPart")


local Hook1 = Tire:WaitForChild("Hook1")
local Hook2 = Tire:WaitForChild("Hook2")
local TireMesh = Tire:WaitForChild("TireMesh")
local TireSeat = Tire:WaitForChild("TireSeat")

local RopeSupport1 = TopBar:WaitForChild("RopeSupport1")
local RopeSupport2 = TopBar:WaitForChild("RopeSupport2")

-- Body objects
local BodyForce = TireMesh:WaitForChild("BodyForce")

-- Other
local CurrentOccupant = nil
local Vector3New,CFrameNew,CFrameAngles,MathRad,MathAbs = Vector3.new,CFrame.new,CFrame.Angles,math.rad,math.abs

-- Settings
local Configuration = Home:WaitForChild("Configuration")
local SwingPower = Configuration:WaitForChild("SwingPower")

local function SetPhysicalProperties(Part,Density)
	if Part then
		Part.CustomPhysicalProperties = PhysicalProperties.new(Density,Part.Friction,Part.Elasticity)
	end
end

GetAllDescendants = function(instance, func)
	func(instance)
	for _, child in next, instance:GetChildren() do
		GetAllDescendants(child, func)
	end
end

local function SetCharacterToWeight(ToDensity,Char)
	GetAllDescendants(Char,function(d)
		if d and d.Parent and d:IsA("BasePart") then
			SetPhysicalProperties(d,ToDensity)
		end
	end)
end

TireSeat.Changed:connect(function()
	if TireSeat.Occupant then
		local CurrentThrottle = TireSeat.Throttle
		
		-- Adjust swing when interacted
		if CurrentThrottle == 1 then
			BodyForce.Force = TireMesh.CFrame.lookVector * SwingPower.Value * 100
		elseif CurrentThrottle == -1 then
			BodyForce.Force = TireMesh.CFrame.lookVector * SwingPower.Value * -100
		else
			BodyForce.Force = Vector3New()
		end
		
		delay(0.2,function()
			BodyForce.Force = Vector3New()
		end)
		
		-- Make the character weightless for the swing to behave correctly
		if CurrentOccupant == nil then
			CurrentOccupant = TireSeat.Occupant
			SetCharacterToWeight(0,CurrentOccupant.Parent)
		end
		
	elseif CurrentOccupant then
		-- Set the character's weight back
		SetCharacterToWeight(0.7,CurrentOccupant.Parent)
		CurrentOccupant = nil
	end
end)]]
	elseif v.Name == "SlideScript" and v.Parent.Name == "Tube Slide" then
		source = [[local Slide = script.Parent:WaitForChild("Slide")

-- Parts
local Entry = Slide:WaitForChild("Entry")

local function MovePlayer(Part)
	if game.Players:GetPlayerFromCharacter(Part.Parent) then
		local Character = Part.Parent
		local Humanoid = Character:WaitForChild("Humanoid")
		local RootPart = Character:WaitForChild("HumanoidRootPart")
		
		if Humanoid.Sit == false then
			-- Make player sit
			Humanoid.Sit = true
			
			if Character.PrimaryPart then
				-- Move player
				Character:SetPrimaryPartCFrame(Entry.CFrame * CFrame.Angles(0,0,math.rad(90)) + Entry.CFrame.lookVector*2)
			else
				-- Extra precaution
				RootPart.CFrame = CFrame.new(Entry.CFrame * CFrame.Angles(0,0,math.rad(90)) + Entry.CFrame.lookVector*2)
			end
		end
	end
end

-- Listen for touches
Entry.Touched:connect(MovePlayer)]]
	elseif v.Name == "Ignore" and v.Parent.Name == "TeleportParts" then
		source = [[local TeleportPart1 = script.Parent.TeleportPart1
local TeleportPart2 = script.Parent.TeleportPart2

TeleportPart1.Touched:Connect(function(hit)
	local w = hit.Parent:FindFirstChild("HumanoidRootPart")
	if w then
		w.CFrame = TeleportPart2.CFrame + Vector3.new(0, 5, 0)
		TeleportPart2.CanTouch = false
		wait(1)
		TeleportPart2.CanTouch = true
	end
end)

TeleportPart2.Touched:Connect(function(hit)
	local w = hit.Parent:FindFirstChild("HumanoidRootPart")
	if w then
		w.CFrame = TeleportPart1.CFrame + Vector3.new(0, 5, 0)
		TeleportPart1.CanTouch = false
		wait(1)
		TeleportPart1.CanTouch = true
	end
end)]]
	elseif v.Name == "TurnOffScript" then
		source = [[local Click = script.Parent
local CellParts = script.Parent.Parent.Parent.Parent.CellPartsTotal.CellPartsImportant

print("Jail Cell by kwkxbxkdkdjjd loaded.")

Click.MouseClick:Connect(function()
	CellParts.CellPart1.Transparency = 0
	CellParts.CellPart1.CanCollide = true
	
	CellParts.CellPart2.Transparency = 0
	CellParts.CellPart2.CanCollide = true
	
	CellParts.CellPart3.Transparency = 0
	CellParts.CellPart3.CanCollide = true
	
	CellParts.CellPart4.Transparency = 0
	CellParts.CellPart4.CanCollide = true
	
	CellParts.CellPart5.Transparency = 0
	CellParts.CellPart5.CanCollide = true
	
	CellParts.CellPart6.Transparency = 0
	CellParts.CellPart6.CanCollide = true
	
	CellParts.CellPart7.Transparency = 0
	CellParts.CellPart7.CanCollide = true
	
	wait(.2)
	
end)]]
	elseif v.Name == "TurnOnScript" then
		source = [[local Click = script.Parent
local CellParts = script.Parent.Parent.Parent.Parent.CellPartsTotal.CellPartsImportant

Click.MouseClick:Connect(function()
	CellParts.CellPart1.Transparency = 1
	CellParts.CellPart1.CanCollide = false

	CellParts.CellPart2.Transparency = 1
	CellParts.CellPart2.CanCollide = false

	CellParts.CellPart3.Transparency = 1
	CellParts.CellPart3.CanCollide = false

	CellParts.CellPart4.Transparency = 1
	CellParts.CellPart4.CanCollide = false

	CellParts.CellPart5.Transparency = 1
	CellParts.CellPart5.CanCollide = false

	CellParts.CellPart6.Transparency = 1
	CellParts.CellPart6.CanCollide = false

	CellParts.CellPart7.Transparency = 1
	CellParts.CellPart7.CanCollide = false

	wait(.2)

end)]]
	elseif v.Name == "Day/Night Cycle" then
		source = [[-- dayLength defines how long, in minutes, a day in your game is. Feel free to alter it.
local dayLength = 12

local cycleTime = dayLength*60
local minutesInADay = 24*60

local lighting = game:GetService("Lighting")

local startTime = tick() - (lighting:getMinutesAfterMidnight() / minutesInADay)*cycleTime
local endTime = startTime + cycleTime

local timeRatio = minutesInADay / cycleTime

if dayLength == 0 then
	dayLength = 1
end

repeat
	local currentTime = tick()
	
	if currentTime > endTime then
		startTime = endTime
		endTime = startTime + cycleTime
	end
	
	lighting:setMinutesAfterMidnight((currentTime - startTime)*timeRatio)
	wait(1/15)
until false
]]
	elseif v.Name == "KillWall" or v.Name == "KillScript" then
		source = [[script.Parent.Touched:connect(function(hit)
	if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
		hit.Parent.Humanoid.Health = 0
	end
end)]]
	elseif v.Name == "MasterScript" then
		source = [[Code = "2323" --change To any numbers You like
Input = ""


--This Is for my buddy siros

--created by
------------------------------------------
--Clear And Enter

function Clear()
print("Cleared")
Input = ""
end

script.Parent.Clear.ClickDetector.MouseClick:connect(Clear)




function Enter()
if Input == Code then
print("Entered")
Input = ""

local door = script.Parent.Parent.Door

door.CanCollide = false
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = 0.8
wait(3)--
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = 0
door.CanCollide = true



return end
Input = ""
print("Wrong Code")
end




script.Parent.Enter.ClickDetector.MouseClick:connect(Enter)

------------------------------------------
--Digets


function Click0()
Input = Input..0
print("0") 
script.Parent.B0.Decal.Texture = "http://www.roblox.com/asset/?id=2767674"
wait(0.1)
script.Parent.B0.Decal.Texture = "http://www.roblox.com/asset/?id=2761903"
end

script.Parent.B0.ClickDetector.MouseClick:connect(Click0)

function Click1()
Input = Input..1
print("1")
script.Parent.B1.Decal.Texture = "http://www.roblox.com/asset/?id=2767677"
wait(0.1)
script.Parent.B1.Decal.Texture = "http://www.roblox.com/asset/?id=2761913"
end

script.Parent.B1.ClickDetector.MouseClick:connect(Click1)

function Click2()
Input = Input..2
print("2")
script.Parent.B2.Decal.Texture = "http://www.roblox.com/asset/?id=2767680"
wait(0.1)
script.Parent.B2.Decal.Texture = "http://www.roblox.com/asset/?id=2761922"
end

script.Parent.B2.ClickDetector.MouseClick:connect(Click2)

function Click3()
Input = Input..3
print("3")
script.Parent.B3.Decal.Texture = "http://www.roblox.com/asset/?id=2767686"
wait(0.1)
script.Parent.B3.Decal.Texture = "http://www.roblox.com/asset/?id=2761927"
end

script.Parent.B3.ClickDetector.MouseClick:connect(Click3)

function Click4()
Input = Input..4
print("4")
script.Parent.B4.Decal.Texture = "http://www.roblox.com/asset/?id=2767693"
wait(0.1)
script.Parent.B4.Decal.Texture = "http://www.roblox.com/asset/?id=2761938"
end

script.Parent.B4.ClickDetector.MouseClick:connect(Click4)

function Click5()
Input = Input..5
print("5")
script.Parent.B5.Decal.Texture = "http://www.roblox.com/asset/?id=2767695"
wait(0.1)
script.Parent.B5.Decal.Texture = "http://www.roblox.com/asset/?id=2761943"
end

script.Parent.B5.ClickDetector.MouseClick:connect(Click5)

function Click6()
Input = Input..6
print("6")
script.Parent.B6.Decal.Texture = "http://www.roblox.com/asset/?id=2767699"
wait(0.1)
script.Parent.B6.Decal.Texture = "http://www.roblox.com/asset/?id=2761948"
end

script.Parent.B6.ClickDetector.MouseClick:connect(Click6)

function Click7()
Input = Input..7
print("7")
script.Parent.B7.Decal.Texture = "http://www.roblox.com/asset/?id=2767701"
wait(0.1)
script.Parent.B7.Decal.Texture = "http://www.roblox.com/asset/?id=2761956"
end

script.Parent.B7.ClickDetector.MouseClick:connect(Click7)

function Click8()
Input = Input..8
print("8")
script.Parent.B8.Decal.Texture = "http://www.roblox.com/asset/?id=2767707"
wait(0.1)
script.Parent.B8.Decal.Texture = "http://www.roblox.com/asset/?id=2761961"
end

script.Parent.B8.ClickDetector.MouseClick:connect(Click8)

function Click9()
Input = Input..9
print("9")
script.Parent.B9.Decal.Texture = "http://www.roblox.com/asset/?id=2767714"
wait(0.1)
script.Parent.B9.Decal.Texture = "http://www.roblox.com/asset/?id=2761971"
end

script.Parent.B9.ClickDetector.MouseClick:connect(Click9)















]]
	elseif v.Name == "Script" and v.Parent.Name == "Open" and v:FindFirstChild("Value") then
		source = [[door = script.Parent.Parent.Door

function clicked()
if script.Value.Value == 0 then
print("Opened")
script.Value.Value = 1
local door = script.Parent.Parent.Door

door.CanCollide = false
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = 0.8
wait(3)--
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = 0
door.CanCollide = true
script.Value.Value = 0
end
end


script.Parent.ClickDetector.MouseClick:connect(clicked)]]
	elseif v.Parent.Name == "Teleport" and v.Parent.Parent:FindFirstChild("Border") then
		source = [[local portal_name = "Portal2" --Portal Name here
local portal = script.Parent.Parent.Parent:FindFirstChild(portal_name)

script.Parent.Touched:Connect(function(hit)
	if game.Players:GetPlayerFromCharacter(hit.Parent) then
		local humanoidRootPart = hit.Parent:WaitForChild("HumanoidRootPart")
		
		humanoidRootPart.CFrame = CFrame.new(portal.Teleport.Position.X - 5,portal.Teleport.Position.Y,portal.Teleport.Position.Z)
	end
end)]]
	elseif v.Name == "Giver Script" and v.Parent:FindFirstChild("Local Gui") then
		source = [[local debounce = false

function getPlayer(humanoid) 
local players = game.Players:children() 
for i = 1, #players do 
if players[i].Character.Humanoid == humanoid then return players[i] end 
end 
return nil 
end 

function onTouch(part) 

local human = part.Parent:findFirstChild("Humanoid") 
if (human ~= nil) and debounce == false then

debounce = true

local player = getPlayer(human) 

if (player == nil) then return end 

script.Parent:clone().Parent = player.Backpack

wait(2)
debounce = false
end
end


script.Parent.Parent.Touched:connect(onTouch) 
]]
	elseif v.Name == "CleanUp" and v.Parent.Name == "Local Gui" then
		source = [[wait(5)  --Change this if you want the path to dissapear faster!
script.Parent:remove()]]
	elseif v.Parent.Name == "Fly" and v.Name == "Script" then
		source = [[Name = "Fly"
pi = 3.141592653589793238462643383279502884197163993751
a = 0
s = 0
ndist = 13
rs = 0.025
siz = Vector3.new(1, 1, 1)
form = 0
flow = {}
function CFC(P1,P2)
	local Place0 = CFrame.new(P1.CFrame.x,P1.CFrame.y,P1.CFrame.z) 
	local Place1 = P2.Position
	P1.Size = Vector3.new(P1.Size.x,P1.Size.y,(Place0.p - Place1).magnitude) 
	P1.CFrame = CFrame.new((Place0.p + Place1)/2,Place0.p)
end
function checktable(table, parentneeded)
	local i
	local t = {}
	for i = 1, #table do
		if table[i] ~= nil then
			if string.lower(type(table[i])) == "userdata" then
				if parentneeded == true then
					if table[i].Parent ~= nil then
						t[#t + 1] = table[i]
					end
				else
					t[#t + 1] = table[i]
				end
			end
		end
	end
	return t
end
if script.Parent.Name ~= Name then
User = game:service("Players").Nineza
HB = Instance.new("HopperBin")
HB.Name = Name
HB.Parent = User.StarterGear
script.Parent = HB
User.Character:BreakJoints()
end
speed = 50
script.Parent.Selected:connect(function(mar)
	s = 1
	torso = script.Parent.Parent.Parent.Character.Torso
	LeftShoulder = torso["Left Shoulder"]
	RightShoulder = torso["Right Shoulder"]
	LeftHip = torso["Left Hip"]
	RightHip = torso["Right Hip"]
	human = script.Parent.Parent.Parent.Character.Humanoid
	bv = Instance.new("BodyVelocity")
	bv.maxForce = Vector3.new(0,math.huge,0)
	bv.velocity = Vector3.new(0,0,0)
	bv.Parent = torso
	bg = Instance.new("BodyGyro")
	bg.maxTorque = Vector3.new(0,0,0)
	bg.Parent = torso 
	connection = mar.Button1Down:connect(function()
		a = 1
		bv.maxForce = Vector3.new(math.huge,math.huge,math.huge)
		bg.maxTorque = Vector3.new(900000,900000,900000)
		bg.cframe = CFrame.new(torso.Position,mar.hit.p) * CFrame.fromEulerAnglesXYZ(math.rad(-90),0,0)
		bv.velocity = CFrame.new(torso.Position,mar.hit.p).lookVector * speed
		moveconnect = mar.Move:connect(function()
			bg.maxTorque = Vector3.new(900000,900000,900000)
			bg.cframe = CFrame.new(torso.Position,mar.hit.p) * CFrame.fromEulerAnglesXYZ(math.rad(-90),0,0)
			bv.velocity = CFrame.new(torso.Position,mar.hit.p).lookVector * speed
		end)
		upconnect = mar.Button1Up:connect(function()
			a = 0
			moveconnect:disconnect()
			upconnect:disconnect()
			bv.velocity = Vector3.new(0,0,0)
			bv.maxForce = Vector3.new(0,math.huge,0)
			torso.Velocity = Vector3.new(0,0,0)
			bg.cframe = CFrame.new(torso.Position,torso.Position + Vector3.new(torso.CFrame.lookVector.x,0,torso.CFrame.lookVector.z))
			wait(1)
		end)
	end)
	while s == 1 do
		wait(0.02)
		flow = checktable(flow, true)
		local i
		for i = 1,#flow do
			flow[i].Transparency = flow[i].Transparency + rs
			if flow[i].Transparency >= 1 then flow[i]:remove() end
		end
		if a == 1 then
			flow[#flow + 1] = Instance.new("Part")
			local p = flow[#flow]
			p.formFactor = form
			p.Size = siz
			p.Anchored = true
			p.CanCollide = false
			p.TopSurface = 0
			p.BottomSurface = 0
			if #flow - 1 > 0 then
				local pr = flow[#flow - 1]
				p.Position = torso.Position - torso.Velocity/ndist
				CFC(p, pr)
			else
				p.CFrame = CFrame.new(torso.Position - torso.Velocity/ndist, torso.CFrame.lookVector)
			end
			p.BrickColor = BrickColor.new("Cyan")
			p.Transparency = 1
			p.Parent = torso
			local marm = Instance.new("BlockMesh")
			marm.Scale = Vector3.new(1.9, 0.9, 1.725)
			marm.Parent = p
			local amplitude
			local frequency
			amplitude = pi
			desiredAngle = amplitude
			RightShoulder.MaxVelocity = 0.4
			LeftShoulder.MaxVelocity = 0.4
			RightHip.MaxVelocity = pi/10
			LeftHip.MaxVelocity = pi/10
			RightShoulder.DesiredAngle = desiredAngle
			LeftShoulder.DesiredAngle = -desiredAngle
			RightHip.DesiredAngle = 0
			LeftHip.DesiredAngle = 0
		end
	end
end)
script.Parent.Deselected:connect(function()
a = 0
s = 0
bv:remove()
bg:remove()
if connection ~= nil then
connection:disconnect()
end
if moveconnect ~= nil then
moveconnect:disconnect()
end
if upconnect ~= nil then
upconnect:disconnect()
end
while s == 0 do
	wait()
	if #flow > 0 then
		flow = checktable(flow, true)
		local i
		for i = 1,#flow do
			flow[i].Transparency = flow[i].Transparency + rs
			if flow[i].Transparency >= 1 then flow[i]:remove() end
		end
	end
end
end)
while true do
	wait()
	if s == 1 then
		return
	end
end
script:remove()
]]
	elseif v.Name == "JumperJumpScript" then
		source = [[while true do
wait(0)
script.Parent:FindFirstChildOfClass("Humanoid").Jump = true
end
]]
	elseif v.Name == "JumperMoveScript" then
		source = [[--[[ By: Joe_1447. --
		local AdamScript=script;
		repeat Wait(0)until script and script.Parent and script.Parent:IsA("Model")and script.Parent:FindFirstChild("Head")and script.Parent:FindFirstChild("Torso");
		local Adam=AdamScript.Parent;
		local AdamHumanoid;
		for _,Child in pairs(Adam:GetChildren())do
			if Child and Child:IsA("Humanoid")and Child.Health>0.001 then
				AdamHumanoid=Child;
			end;
		end;
		local HasGear=false;
		function raycast(Spos,vec,currentdist)
			local Hit2,pos2=game.Workspace:FindPartOnRay(Ray.new(Spos+(vec*.05),vec*currentdist),Adam);
			if Hit2~=nil and pos2 then
				if Hit2.Name=="Handle"and not Hit2.CanCollide or string.sub(Hit2.Name,1,6)=="Effect"and not Hit2.CanCollide then
					local currentdist=currentdist-(pos2-Spos).magnitude;
					return raycast(pos2,vec,currentdist);
				end;
			end;
			return Hit2,pos2;
		end;
		for _,Child in pairs(Adam:GetChildren())do
			if Child and Child:IsA("Tool")then
			end;
		end;
		function RayCast(Position,Direction,MaxDistance,IgnoreList)
			return Game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(Position,Direction.unit*(MaxDistance or 999.999)),IgnoreList);
		end;
		local AttackDebounce=false;
		while Wait(0)do
			if AdamScript and Adam and Adam:FindFirstChild("Head")and AdamHumanoid and AdamHumanoid.Health==0 then
				break
			end;
			if AdamScript and Adam and Adam:FindFirstChild("Torso")and AdamHumanoid and AdamHumanoid.Health>0.001 then
				local TargetPoint=AdamHumanoid.TargetPoint;
				local Blockage,BlockagePos=RayCast((Adam:FindFirstChild("Torso").CFrame+CFrame.new(Adam:FindFirstChild("Torso").Position,Vector3.new(TargetPoint.X,Adam:FindFirstChild("Torso").Position.Y,TargetPoint.Z)).lookVector*(Adam:FindFirstChild("Torso").Size.Z/2)).p,Adam:FindFirstChild("Torso").CFrame.lookVector,(Adam:FindFirstChild("Torso").Size.Z*2.5),{Adam,Adam})
				if Blockage then
					if Blockage and Blockage.Parent and Blockage.Parent.ClassName~="Workspace"then
						local BlockageHumanoid;
						for _,Child in pairs(Blockage.Parent:GetChildren())do
							if Child and Child:IsA("Humanoid")and Child.Health>0.001 then
								BlockageHumanoid=Child;
							end;
						end;
						if Blockage and Blockage:IsA("Terrain")then
							local CellPos=Blockage:WorldToCellPreferSolid((BlockagePos-Vector3.new(0,2,0)));
							local CellMaterial,CellShape,CellOrientation=Blockage:GetCell(CellPos.X,CellPos.Y,CellPos.Z);
							if CellMaterial==Enum.CellMaterial.Water then
							end
						elseif BlockageHumanoid or Blockage.ClassName=="TrussPart"or Blockage.ClassName=="WedgePart"or Blockage.Name=="Handle"and Blockage.Parent:IsA("Hat")or Blockage.Name=="Handle"and Blockage.Parent:IsA("Tool")then
						end;
					end;
					if AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 and not AdamHumanoid.Sit and Jumpable then
					end;
				end;
				if AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 and not AdamHumanoid.AutoJumpEnabled then
				end;
				if AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 and not AdamHumanoid.AutoRotate then
				end;
				if AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 and AdamHumanoid.PlatformStand then
				end;
				if AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 and AdamHumanoid.Sit then
				end;
				if AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 then
				end;
				local NoticeDistance=0;
				for _,TargetModel in pairs(Game:GetService("Workspace"):GetChildren())do
					if TargetModel and TargetModel:IsA("Model")and TargetModel~=Adam and TargetModel.Name~=Adam.Name and TargetModel:FindFirstChild("Head")and TargetModel:FindFirstChild("Torso")and not HasGear then
						local TargetPart=TargetModel:FindFirstChild("Torso");
						local FoundHumanoid;
						local FoundGear;
						for _,Child in pairs(TargetModel:GetChildren())do
							if Child and Child:IsA("Humanoid")and Child.Health>0.001 then
								FoundHumanoid=Child;
							end;
						end;
						for _,Child in pairs(TargetModel:GetChildren())do
							if Child and Child:IsA("Tool")then
								FoundGear=Child
							end;
						end;
						if AdamScript and Adam and Adam:FindFirstChild("HumanoidRootPart")and AdamHumanoid and AdamHumanoid.Health>0.001 and TargetPart and FoundHumanoid and FoundHumanoid.Health>0.001 and TargetModel and TargetPart and(TargetPart.Position-Adam:FindFirstChild("HumanoidRootPart").Position).magnitude<NoticeDistance and FoundGear then
							NoticeDistance=(TargetPart.Position-Adam:FindFirstChild("HumanoidRootPart").Position).magnitude;
							if AdamScript and Adam and Adam:FindFirstChild("HumanoidRootPart")and AdamHumanoid and AdamHumanoid.Health>0.001 and TargetPart and FoundHumanoid and FoundHumanoid.Health>0.001 and FoundHumanoid.Jump then
							end;
							if AdamScript and Adam and Adam:FindFirstChild("HumanoidRootPart")and AdamHumanoid and AdamHumanoid.Health>0.001 and TargetPart and FoundHumanoid and FoundHumanoid.Health>0.001 and TargetModel and TargetPart and(TargetPart.Position-Adam:FindFirstChild("HumanoidRootPart").Position).magnitude<5 and FoundGear and not AttackDebounce then
								local Hit,pos=raycast(Adam:FindFirstChild("Torso").Position,(TargetPart.Position-Adam:FindFirstChild("Torso").Position).unit,500)
								if Hit and Hit.Parent and Hit.Parent:IsA("Model")and Hit.Parent:FindFirstChild("Torso")and Hit.Parent:FindFirstChild("Head")then
									Delay(0.5+math.random()*1,function()
										AttackDebounce=false;
									end);
									AttackDebounce=true;
									local SwingAnimation=AdamHumanoid:LoadAnimation(Adam:FindFirstChild("SwingAnimation"));
									SwingAnimation:Play();
									SwingAnimation:AdjustSpeed(1);
									Spawn(function()
										Wait(0.4);
										if AdamScript and Adam and Adam:FindFirstChild("HumanoidRootPart")and AdamHumanoid and AdamHumanoid.Health>0.001 and TargetPart and FoundHumanoid and FoundHumanoid.Health>0.001 then
											if AdamScript and Adam and Adam:FindFirstChild("HumanoidRootPart")and AdamHumanoid and AdamHumanoid.Health>0.001 and TargetPart and FoundHumanoid and FoundHumanoid.Health>0.001 and TargetModel and TargetPart and(TargetPart.Position-Adam:FindFirstChild("HumanoidRootPart").Position).magnitude<5 and FoundGear and FoundGear.Parent.ClassName~="Backpack"then
												if AdamScript and Adam and Adam:FindFirstChild("Right Arm")and Adam:FindFirstChild("Right Arm"):FindFirstChild("AdamSlap")then
													Adam:FindFirstChild("Right Arm"):FindFirstChild("AdamSlap"):Play();
												end;
											else
											end;
										end;
									end);
								end;
							end;
							AdamHumanoid:MoveTo(TargetPart.Position);
						end;
					else
						if AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 and HasGear then
							local GearReleaseChance=math.random(1,5000);
							local Tools=0;
							for _,Child in pairs(Adam:GetChildren())do
								if Child and Child:IsA("Tool")then
								end;
							end;
							if AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 and Tools==0 or AdamScript and Adam and AdamHumanoid and AdamHumanoid.Health>0.001 and Tools<0 then
							end;
							if GearReleaseChance==1 then
								Wait(0);
								for _,Child in pairs(Adam:GetChildren())do
									if Child and Child:IsA("Tool")then
									end;
								end;
							end;
						end;
						local RandomWalk=math.random(1,300);
						local RandomJump=math.random(1,700);
						if RandomWalk==1 then
							AdamHumanoid:MoveTo(Game:GetService("Workspace"):FindFirstChild("Terrain").Position+Vector3.new(math.random(-2048,2048),0,math.random(-2048,2048)),Game:GetService("Workspace"):FindFirstChild("Terrain"));
						end;
						if RandomJump==0 then
						end;
					end;
				end;
			end;
		end;
		--[[ By: Joe_1447.]]
	elseif v.Name == "JumperRespawnScript" then
		source = [[--[[ By: Joe_1447. --
		local AdvancedRespawnScript=script;
		repeat Wait(0)until script and script.Parent and script.Parent.ClassName=="Model";
		local Adam=AdvancedRespawnScript.Parent;
		local GameDerbis=Game:GetService("Debris");
		local AdamHumanoid;
		for _,Child in pairs(Adam:GetChildren())do
			if Child and Child.ClassName=="Humanoid"and Child.Health>0.001 then
				AdamHumanoid=Child;
			end;
		end;
		local Respawndant=Adam:Clone();
		coroutine.resume(coroutine.create(function()
			if Adam and AdamHumanoid and AdamHumanoid:FindFirstChild("Status")and not AdamHumanoid:FindFirstChild("Status"):FindFirstChild("AvalibleSpawns")then
				SpawnModel=Instance.new("Model");
				SpawnModel.Parent=AdamHumanoid.Status;
				SpawnModel.Name="AvalibleSpawns";
			else
				SpawnModel=AdamHumanoid:FindFirstChild("Status"):FindFirstChild("AvalibleSpawns");
			end;
			function FindSpawn(SearchValue)
				local PartsArchivable=SearchValue:GetChildren();
				for AreaSearch=1,#PartsArchivable do
					if PartsArchivable[AreaSearch].className=="SpawnLocation"then
						local PositionValue=Instance.new("Vector3Value",SpawnModel);
						PositionValue.Value=PartsArchivable[AreaSearch].Position;
						PositionValue.Name=PartsArchivable[AreaSearch].Duration;
					end;
					FindSpawn(PartsArchivable[AreaSearch]);
				end;
			end;
			FindSpawn(Game.Workspace);
			local SpawnChilden=SpawnModel:GetChildren();
			if#SpawnChilden>0 then
				local SpawnItself=SpawnChilden[math.random(1,#SpawnChilden)];
				local RespawningForceField=Instance.new("ForceField");
				RespawningForceField.Parent=Adam;
				RespawningForceField.Name="SpawnForceField";
				GameDerbis:AddItem(RespawningForceField,SpawnItself.Name);
				Adam:MoveTo(SpawnItself.Value+Vector3.new(0,3.5,0));
			else
				if Adam:FindFirstChild("SpawnForceField")then
					Adam:FindFirstChild("SpawnForceField"):Destroy();
				end;
				Adam:MoveTo(Vector3.new(0,115,0));
			end;
		end));
		function Respawn()
			Wait(5);
			Respawndant.Parent=Adam.Parent;
			Respawndant:makeJoints();
			Respawndant:FindFirstChild("Head"):MakeJoints();
			Respawndant:FindFirstChild("Torso"):MakeJoints();
			Adam:remove();
		end;
		AdamHumanoid.Died:connect(Respawn);
		--[[ By: Joe_1447 ]]
	elseif v.Name == "Sound" and v.Parent:FindFirstChild("JumperAnimateScript") then
		source = [[-- util

function waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)
	if child then return child end
	while true do
		child = parent.ChildAdded:wait()
		if child.Name==childName then return child end
	end
end

function newSound(id)
	local sound = Instance.new("Sound")
	sound.SoundId = id
	sound.archivable = false
	sound.Parent = script.Parent.Head
	return sound
end

-- declarations

local sDied = newSound("rbxasset://sounds/uuhhh.wav")
sDied.Pitch = 0.75
local sFallingDown = newSound("rbxasset://sounds/splat.wav")
local sFreeFalling = newSound("rbxasset://sounds/swoosh.wav")
local sGettingUp = newSound("rbxasset://sounds/hit.wav")
local sJumping = newSound("rbxasset://sounds/button.wav")
local sRunning = newSound("rbxasset://sounds/bfsl-minifigfoots1.mp3")
sRunning.Looped = true

local Figure = script.Parent
local Head = waitForChild(Figure, "Head")
local Humanoid = waitForChild(Figure, "Humanoid")

-- functions

function onDied()
	sDied:Play()
	wait(2.5)
	script.Parent:Destroy()
end

function onState(state, sound)
	if state then
		sound:Play()
	else
		sound:Pause()
	end
end

function onRunning(speed)
	if speed>0 then
		sRunning:Play()
	else
		sRunning:Pause()
	end
end

-- connect up

Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(function(state) onState(state, sJumping) end)
Humanoid.GettingUp:connect(function(state) onState(state, sGettingUp) end)
Humanoid.FreeFalling:connect(function(state) onState(state, sFreeFalling) end)
Humanoid.FallingDown:connect(function(state) onState(state, sFallingDown) end)
]]
	elseif v.Name == "ZombieScript" then
		source = [[--Made by Stickmasterluke

--Zombie artificial stupidity script


sp=script.Parent
lastattack=0
nextrandom=0
nextsound=0
nextjump=0
chasing=false

variance=4

damage=50
attackrange=4.5
sightrange=999--60
runspeed=40
wonderspeed=8
healthregen=false
colors={"Sand red","Dusty Rose","Medium blue","Sand blue","Lavender","Earth green","Brown","Medium stone grey","Brick yellow"}

function raycast(spos,vec,currentdist)
	local hit2,pos2=game.Workspace:FindPartOnRay(Ray.new(spos+(vec*.01),vec*currentdist),script.Parent)
	if hit2~=nil and pos2 then
		if hit2.Parent==script.Parent and hit2.Transparency>=.8 or hit2.Name=="Handle" or string.sub(hit2.Name,1,6)=="Effect" or hit2.Parent:IsA("Hat") or hit2.Parent:IsA("Tool") or (hit2.Parent:FindFirstChild("Humanoid") and hit2.Parent:FindFirstChild("TEAM") and hit2.Parent:FindFirstChild("TEAM").Value == script.Parent.TEAM.Value) or (not hit2.Parent:FindFirstChild("Humanoid") and hit2.CanCollide==false) then
			local currentdist=currentdist-(pos2-spos).magnitude
			return raycast(pos2,vec,currentdist)
		end
	end
	return hit2,pos2
end

function waitForChild(parent,childName)
	local child=parent:findFirstChild(childName)
	if child then return child end
	while true do
		child=parent.ChildAdded:wait()
		if child.Name==childName then return child end
	end
end

-- ANIMATION

-- declarations

local Torso=waitForChild(sp,"Torso")
local Head=waitForChild(sp,"Head")
local RightShoulder=waitForChild(Torso,"Right Shoulder")
local LeftShoulder=waitForChild(Torso,"Left Shoulder")
local RightHip=waitForChild(Torso,"Right Hip")
local LeftHip=waitForChild(Torso,"Left Hip")
local Neck=waitForChild(Torso,"Tail")
local Humanoid=waitForChild(sp,"Humanoid")
local BodyColors=waitForChild(sp,"Body Colors")
local pose="Standing"
local hitsound=waitForChild(Head,"Bite Bark")
local BARKING=waitForChild(Head,"Seal Barking")


--[[local sounds={
	waitForChild(Torso,"GroanSound"),
	waitForChild(Torso,"RawrSound")
}]

		if healthregen then
			local regenscript=waitForChild(sp,"HealthRegenerationScript")
			regenscript.Disabled=false
		end
		Humanoid.WalkSpeed=wonderspeed

		local toolAnim="None"
		local toolAnimTime=0

--[[BodyColors.HeadColor=BrickColor.new("Grime")
local randomcolor1=colors[math.random(1,#colors)]
BodyColors.TorsoColor=BrickColor.new(randomcolor1)
BodyColors.LeftArmColor=BrickColor.new(randomcolor1)
BodyColors.RightArmColor=BrickColor.new(randomcolor1)
local randomcolor2=colors[math.random(1,#colors)]
BodyColors.LeftLegColor=BrickColor.new(randomcolor2)
BodyColors.RightLegColor=BrickColor.new(randomcolor2)]


		function onRunning(speed)
			if speed>0 then
				pose="Running"
			else
				pose="Standing"
			end
		end
		function onDied()
			pose="Dead"
		end
		function onJumping()
			pose="Jumping"
		end
		function onClimbing()
			pose="Climbing"
		end
		function onGettingUp()
			pose = "GettingUp"
		end
		function onFreeFall()
			pose = "FreeFall"
		end
		function onFallingDown()
			pose = "FallingDown"
		end
		function onSeated()
			pose = "Seated"
		end
		function onPlatformStanding()
			pose = "PlatformStanding"
		end

		function moveJump()
			RightShoulder.MaxVelocity = 0.5
			LeftShoulder.MaxVelocity = 0.5
			RightShoulder.DesiredAngle=3.14
			LeftShoulder.DesiredAngle=-3.14
			RightHip.DesiredAngle=0
			LeftHip.DesiredAngle=0
		end

		function moveFreeFall()
			RightShoulder.MaxVelocity = 0.5
			LeftShoulder.MaxVelocity =0.5
			RightShoulder.DesiredAngle=3.14
			LeftShoulder.DesiredAngle=-3.14
			RightHip.DesiredAngle=0
			LeftHip.DesiredAngle=0
		end

		function moveSit()
			RightShoulder.MaxVelocity = 0.15
			LeftShoulder.MaxVelocity = 0.15
			RightShoulder.DesiredAngle=3.14 /2
			LeftShoulder.DesiredAngle=-3.14 /2
			RightHip.DesiredAngle=3.14 /2
			LeftHip.DesiredAngle=-3.14 /2
		end

		function animate(time)
			local amplitude
			local frequency
			if (pose == "Jumping") then
				moveJump()
				return
			end
			if (pose == "FreeFall") then
				moveFreeFall()
				return
			end
			if (pose == "Seated") then
				moveSit()
				return
			end
			local climbFudge = 0
			if (pose == "Running") then
				RightShoulder.MaxVelocity = 0.15
				LeftShoulder.MaxVelocity = 0.15
				amplitude = 1
				frequency = 9
			elseif (pose == "Climbing") then
				RightShoulder.MaxVelocity = 0.5 
				LeftShoulder.MaxVelocity = 0.5
				amplitude = 1
				frequency = 9
				climbFudge = 3.14
			else
				amplitude = 0.1
				frequency = 1
			end
			desiredAngle = amplitude * math.sin(time*frequency)
			if not chasing and frequency==9 then
				frequency=4
			end
			if chasing then
		--[[RightShoulder.DesiredAngle=math.pi/2
		LeftShoulder.DesiredAngle=-math.pi/2
		RightHip.DesiredAngle=-desiredAngle*2
		LeftHip.DesiredAngle=-desiredAngle*2]
			else
				RightShoulder.DesiredAngle=desiredAngle + climbFudge
				LeftShoulder.DesiredAngle=desiredAngle - climbFudge
				RightHip.DesiredAngle=-desiredAngle
				LeftHip.DesiredAngle=-desiredAngle
			end
		end


		function attack(time,attackpos)
			if time-lastattack>=0.25 then
				local hit,pos=raycast(Torso.Position,(attackpos-Torso.Position).unit,attackrange)
				if hit and hit.Parent~=nil then
					local h=hit.Parent:FindFirstChild("Humanoid")
					local TEAM=hit.Parent:FindFirstChild("TEAM")
					if h and TEAM and TEAM.Value~=sp.TEAM.Value then
						local creator=sp:FindFirstChild("creator")
						if creator then
							if creator.Value~=nil then
								if creator.Value~=game.Players:GetPlayerFromCharacter(h.Parent) then
									for i,oldtag in ipairs(h:GetChildren()) do
										if oldtag.Name=="creator" then
											oldtag:remove()
										end
									end
									creator:clone().Parent=h
								else
									return
								end
							end
						end
						hitsound.Volume=1
						hitsound.Pitch=.75+(math.random()*.5)
						hitsound:Play()
						wait(0.15)
						h:TakeDamage(damage)
				--[[if RightShoulder and LeftShoulder then
					RightShoulder.CurrentAngle=0
					LeftShoulder.CurrentAngle=0
				end]
					end
				end
				lastattack=time
			end
		end


		Humanoid.Died:connect(onDied)
		Humanoid.Running:connect(onRunning)
		Humanoid.Jumping:connect(onJumping)
		Humanoid.Climbing:connect(onClimbing)
		Humanoid.GettingUp:connect(onGettingUp)
		Humanoid.FreeFalling:connect(onFreeFall)
		Humanoid.FallingDown:connect(onFallingDown)
		Humanoid.Seated:connect(onSeated)
		Humanoid.PlatformStanding:connect(onPlatformStanding)


		function populatehumanoids(mdl)
			if mdl.ClassName=="Humanoid" then
				if mdl.Parent:FindFirstChild("TEAM") and mdl.Parent:FindFirstChild("TEAM").Value~=sp.TEAM.Value then
					table.insert(humanoids,mdl)
				end
			end
			for i2,mdl2 in ipairs(mdl:GetChildren()) do
				populatehumanoids(mdl2)
			end
		end

--[[function playsound(time)
	nextsound=time+5+(math.random()*5)
	local randomsound=sounds[math.random(1,#sounds)]
	randomsound.Volume=.5+(.5*math.random())
	randomsound.Pitch=.5+(.5*math.random())
	randomsound:Play()
end]

		while sp.Parent~=nil and Humanoid and Humanoid.Parent~=nil and Humanoid.Health>0 and Torso and Head and Torso~=nil and Torso.Parent~=nil do
			local _,time=wait(0.25)--wait(1/3)
			humanoids={}
			populatehumanoids(game.Workspace)
			closesttarget=nil
			closestdist=sightrange
			local creator=sp:FindFirstChild("creator")
			for i,h in ipairs(humanoids) do
				if h and h.Parent~=nil then
					if h.Health>0 and h.Parent~=sp then
						local plr=game.Players:GetPlayerFromCharacter(h.Parent)
						if creator==nil or plr==nil or creator.Value~=plr then
							local t=h.Parent:FindFirstChild("Torso")
							if t~=nil then
								local dist=(t.Position-Torso.Position).magnitude
								if dist<closestdist then
									closestdist=dist
									closesttarget=t
								end
							end
						end
					end
				end
			end
			if closesttarget~=nil then
				if not chasing then
					--playsound(time)
					chasing=true
					Humanoid.WalkSpeed=runspeed
					BARKING:Play()
				end
				Humanoid:MoveTo(closesttarget.Position+(Vector3.new(1,1,1)*(variance*((math.random()*2)-1))),closesttarget)
				if math.random()<.5 then
					attack(time,closesttarget.Position)
				end
			else
				if chasing then
					chasing=false
					Humanoid.WalkSpeed=wonderspeed
					BARKING:Stop()
				end
				if time>nextrandom then
					nextrandom=time+3+(math.random()*5)
					local randompos=Torso.Position+((Vector3.new(1,1,1)*math.random()-Vector3.new(.5,.5,.5))*40)
					Humanoid:MoveTo(randompos,game.Workspace.Terrain)
				end
			end
			if time>nextsound then
				--playsound(time)
			end
			if time>nextjump then
				nextjump=time+7+(math.random()*5)
				Humanoid.Jump=true
			end
			animate(time)
		end

		wait(4)
		sp:remove() --Rest In Pizza
		]]
	elseif v.Name == "Script" and v.Parent.Name == "Trampoline" then
		source = [[local defaultJumpPower = game:GetService("StarterPlayer").CharacterJumpPower

script.Parent.Touched:connect(function(obj)
	local humanoid = obj.Parent:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
	    humanoid.JumpPower = script.Parent.Parent.Configurations.JumpForce.Value
	    humanoid.Jump = true
	    wait(1)
	    humanoid.JumpPower = defaultJumpPower
	end
end)]]
	elseif v.Name == "WalkSpeed Changer" then
		source = [[debounce = true

function onTouched(hit)
	local h = hit.Parent:findFirstChild("Humanoid")
	if (h ~= nil and debounce == true) then
		debounce = false
		h.WalkSpeed = 1
		wait(1)
		debounce = true
	end
end

script.Parent.Touched:connect(onTouched)]]
	elseif v.Name == "Script" and v.Parent.Name == "SuperJump V2.0" then
		source = [[local e = Instance.new("BodyPosition")

local flying = false

function onButton1Down(mouse)
flying = true
	while flying do
	e.Parent = script.Parent.Parent.Parent.Character.Torso
	e.position = Vector3.new(0,script.Parent.Parent.Parent.Character.Torso.Position.Y + 2.00000004,0)
	e.maxForce = Vector3.new(0,9000,0)
	wait(0.00000000000000000000000000000000000000000001)
	end
end

function onButton1Up(mouse)
flying = false
e:Remove()
end

function onSelected(mouse)
	mouse.Icon = "rbxasset://textures\\GunCursor.png"
	mouse.Button1Up:connect(function() onButton1Up(mouse) end)
	mouse.Button1Down:connect(function() onButton1Down(mouse) end)
end

script.Parent.Selected:connect(onSelected)]]
	elseif v.Name == "Script" and v.Parent.Parent:FindFirstChild("Blueseel Bathelm") and v.Parent.Name == "Brick" then
		source = [[bin = script.Parent

function onTouched(part)
	part.BrickColor = BrickColor.new(23)
	wait(0.01)
	part.Transparency.Reflectance = 0.1
	wait(0.1)
	part.Transparency.Reflectance  = 0.2
	wait(0.1)
	part.Transparency.Reflectance  = 0.3
	wait(0.1)
	part.Transparency.Reflectance  = 0.4
	wait(0.1)
	part.Transparency.Reflectance  = 0.5
	wait(0.1)
	part.Transparency.Reflectance  = 0.6
	wait(0.1)
	part.Transparency.Reflectance  = 0.7
	wait(0.1)
	part.Transparency.Reflectance  = 0.8
	wait(0.1)
        part.Transparency.Reflectance  = 0.9
	wait(0.1)
	part.Parent = nil
end

connection = bin.Touched:connect(onTouched)]]
	elseif v.Name == "CarScript" and v:FindFirstChild("LocalCarScript") then
		source = [[--Scripted by DermonDarble

local car = script.Parent
local stats = car.Configurations
local Raycast = require(script.RaycastModule)

local mass = 0

for i, v in pairs(car:GetChildren()) do
	if v:IsA("BasePart") then
		mass = mass + (v:GetMass() * 196.2)
	end
end

local bodyPosition = car.Chassis.BodyPosition
local bodyGyro = car.Chassis.BodyGyro

--local bodyPosition = Instance.new("BodyPosition", car.Chassis)
--bodyPosition.MaxForce = Vector3.new()
--local bodyGyro = Instance.new("BodyGyro", car.Chassis)
--bodyGyro.MaxTorque = Vector3.new()

local function UpdateThruster(thruster)
	-- Raycasting
	local hit, position = Raycast.new(thruster.Position, thruster.CFrame:vectorToWorldSpace(Vector3.new(0, -1, 0)) * stats.Height.Value) --game.Workspace:FindPartOnRay(ray, car)
	local thrusterHeight = (position - thruster.Position).magnitude
	
	-- Wheel
	local wheelWeld = thruster:FindFirstChild("WheelWeld")
	wheelWeld.C0 = CFrame.new(0, -math.min(thrusterHeight, stats.Height.Value * 0.8) + (wheelWeld.Part1.Size.Y / 2), 0)
	-- Wheel turning
	local offset = car.Chassis.CFrame:inverse() * thruster.CFrame
	local speed = car.Chassis.CFrame:vectorToObjectSpace(car.Chassis.Velocity)
	if offset.Z < 0 then
		local direction = 1
		if speed.Z > 0 then
			direction = -1
		end
		wheelWeld.C0 = wheelWeld.C0 * CFrame.Angles(0, (car.Chassis.RotVelocity.Y / 2) * direction, 0)
	end
	
	-- Particles
	if hit and thruster.Velocity.magnitude >= 5 then
		wheelWeld.Part1.ParticleEmitter.Enabled = true
	else
		wheelWeld.Part1.ParticleEmitter.Enabled = false
	end
end

car.DriveSeat.Changed:connect(function(property)
	if property == "Occupant" then
		if car.DriveSeat.Occupant then
			car.EngineBlock.Running.Pitch = 1
			car.EngineBlock.Running:Play()
			local player = game.Players:GetPlayerFromCharacter(car.DriveSeat.Occupant.Parent)
			if player then
				car.DriveSeat:SetNetworkOwner(player)
				local localCarScript = script.LocalCarScript:Clone()
				localCarScript.Parent = player.PlayerGui
				localCarScript.Car.Value = car
				localCarScript.Disabled = false
			end
		else
			car.EngineBlock.Running:Stop()
		end
	end
end)

--spawn(function()
	while true do
		game:GetService("RunService").Stepped:wait()
		for i, part in pairs(car:GetChildren()) do
			if part.Name == "Thruster" then
				UpdateThruster(part)
			end
		end
		if car.DriveSeat.Occupant then
			local ratio = car.DriveSeat.Velocity.magnitude / stats.Speed.Value
			car.EngineBlock.Running.Pitch = 1 + ratio / 4
			bodyPosition.MaxForce = Vector3.new()
			bodyGyro.MaxTorque = Vector3.new()
		else
			local hit, position, normal = Raycast.new(car.Chassis.Position, car.Chassis.CFrame:vectorToWorldSpace(Vector3.new(0, -1, 0)) * stats.Height.Value)
			if hit and hit.CanCollide then
				bodyPosition.MaxForce = Vector3.new(mass / 5, math.huge, mass / 5)
				bodyPosition.Position = (CFrame.new(position, position + normal) * CFrame.new(0, 0, -stats.Height.Value + 0.5)).p
				bodyGyro.MaxTorque = Vector3.new(math.huge, 0, math.huge)
				bodyGyro.CFrame = CFrame.new(position, position + normal) * CFrame.Angles(-math.pi/2, 0, 0)
			else
				bodyPosition.MaxForce = Vector3.new()
				bodyGyro.MaxTorque = Vector3.new()
			end
		end
	end
--end)]]
	elseif v.Name == "PUT THIS IN THE WEAPON" then
		source = [[local debounce = false

function getPlayer(humanoid) 
local players = game.Players:children() 
for i = 1, #players do 
if players[i].Character.Humanoid == humanoid then return players[i] end 
end 
return nil 
end 

function onTouch(part) 

local human = part.Parent:findFirstChild("Humanoid") 
if (human ~= nil) and debounce == false then

debounce = true

local player = getPlayer(human) 

if (player == nil) then return end 

script.Parent:clone().Parent = player.Backpack

wait(2)
debounce = false
end
end


script.Parent.Parent.Touched:connect(onTouch) 
]]
	elseif v.Name == "BloxyColaScript" then
		source = [[local Tool = script.Parent;

enabled = true


function onActivated()
	if not enabled  then
		return
	end

	enabled = false
	Player.Torso["Right Shoulder"].C0 = CFrame.new(0.9,0.5,-0.05) * CFrame.Angles(0.2,2,0)
	wait(0.05)
	Player.Torso["Right Shoulder"].C0 = CFrame.new(0.8,0.5,-0.1) * CFrame.Angles(0.4,2.4,0)

	Tool.Handle.DrinkSound:Play()

	for i = 1,30 do
	wait(0.1)
	Player.Humanoid.Health = Player.Humanoid.Health + 1
	end
	Player.Torso["Right Shoulder"].C0 = CFrame.new(0.9,0.5,-0.05) * CFrame.Angles(0.2,2,0)
	wait(0.05)
	Player.Torso["Right Shoulder"].C0 = CFrame.new(1,0.5,-0) * CFrame.Angles(0,1.57,0)
	wait(0.5)
	enabled = true
end

function onEquipped()
	Player = script.Parent.Parent
	Tool.Handle.OpenSound:play()
end

function onEnequipped()
	Player.Torso["Right Shoulder"].C0 = CFrame.new(1,0.5,-0) * CFrame.Angles(0,1.57,0)
end

script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)
script.Parent.Unequipped:connect(onEnequipped)
]]
	elseif v.Name == "Force Script" then
		source = [[--SoundStudioRoblox--

while true do
script.Parent.Velocity = script.Parent.CFrame.lookVector *60
wait(0.1)
end
]]
	elseif v.Name == "ClassicBuildTools" then
		source = [[-------------------------------------------------------------------------------------------------------------------------
-- @CloneTrooper1019, 2017-2018 <3
-- ClassicBuildTools.lua
-- A FilteringEnabled port of Roblox's classic build tools.
-------------------------------------------------------------------------------------------------------------------------
-- Initial Declarations
-------------------------------------------------------------------------------------------------------------------------

local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DraggerService = Instance.new("Folder")
DraggerService.Name = "DraggerService"
DraggerService.Parent = ReplicatedStorage

local DraggerGateway = Instance.new("RemoteFunction")
DraggerGateway.Name = "DraggerGateway"
DraggerGateway.Parent = DraggerService

local SubmitUpdate = Instance.new("RemoteEvent")
SubmitUpdate.Name = "SubmitUpdate"
SubmitUpdate.Parent = DraggerService

local DECLARED_BUILD_TOOLS = {
	_KGameTool = true,
	_KClone = true,
	_KHammer = true,
}

-------------------------------------------------------------------------------------------------------------------------
-- Server Gateway Logic
-------------------------------------------------------------------------------------------------------------------------
--[[

~ HOW THIS WORKS ~

	* In order to drag a part, a player must request permission from the server to drag the part.
	* If any of the following conditions are true, the request will be rejected:
		* The part is Locked.
		* The player is dragging another part, and hasn't released it.
		* The part is being dragged by another player.
		* The player does not have a character.
		* The player does not have the tool corresponding to the action equipped.
	* If the player is granted permission...
		* A key is generated representing the current drag action, and this key is passed back to the player.
		* This key marks both the part being dragged, and the player.
		* The player can submit the key and a CFrame to the SubmitUpdate event to move the part.
		* The player MUST release the key in order to drag another part, or their request is rejected.
		* Key is automatically released if the part is destroyed, or the player leaves the game.
--]

		local activeKeys = {}
		local deleteDebounce = {}

		local partToKey = {}
		local playerToKey = {}

		local function assertClass(obj, class)
			assert(obj)
			assert(typeof(obj) == "Instance")
			assert(obj:IsA(class))
		end

		local function canGiveKey(player, part)
			if part.Locked then
				return false
			end

			if playerToKey[player] then
				return false
			end

			if partToKey[part] then
				return false
			end

			return true
		end

		local function claimAssembly(player, part)
			if part:CanSetNetworkOwnership() then
				part:SetNetworkOwner(player)
			end
		end

		local function removePartKey(key)
			local data = activeKeys[key]

			if data then
				local player = data.Player
				local part = data.Part

				if player then
					playerToKey[player] = nil
				end

				if part then
					-- Connect this part to a nearby surface
					workspace:JoinToOutsiders({ part }, "Surface")

					part.Anchored = data.Anchored
					claimAssembly(player, part)

					partToKey[part] = nil
				end

				activeKeys[key] = nil
			end
		end

		local function playerIsUsingTool(player, toolName)
			local char = player.Character

			if char then
				local tool = char:FindFirstChildWhichIsA("Tool")
				if tool and CollectionService:HasTag(tool, toolName) then
					return true, tool
				end
			end

			return false
		end

		local function swingBuildTool(player)
			local char = player.Character
			if char then
				local tool = char:FindFirstChildWhichIsA("Tool")
				if tool and tool.RequiresHandle and CollectionService:HasTag(tool, "_KBuildTool") then
					local toolAnim = Instance.new("StringValue")
					toolAnim.Name = "toolanim"
					toolAnim.Value = "Slash"
					toolAnim.Parent = tool
				end
			end
		end

		function DraggerGateway.OnServerInvoke(player, request, ...)
			if request == "GetKey" then
				local part, asClone = ...
				assertClass(part, "BasePart")

				if asClone then
					if playerIsUsingTool(player, "_KClone") then
						local newPart = part:Clone()
						newPart:BreakJoints()
						newPart.Parent = workspace

						local copySound = Instance.new("Sound")
						copySound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
						copySound.Parent = newPart
						copySound.Archivable = false
						copySound:Play()

						part = newPart
					else
						return false
					end
				elseif not playerIsUsingTool(player, "_KGameTool") then
					return false
				end

				if canGiveKey(player, part) then
					local char = player.Character
					if char then
						local key = HttpService:GenerateGUID(false)
						playerToKey[player] = key
						partToKey[part] = key

						claimAssembly(player, part)
						swingBuildTool(player)

						local anchored = part.Anchored
						part:BreakJoints()
						part.Anchored = true

						activeKeys[key] = {
							Player = player,
							Part = part,
							Anchored = anchored,
						}

						return true, key, part
					end
				end

				return false
			elseif request == "ClearKey" then
				local key = ...

				if not key then
					key = playerToKey[player]
				end

				if key then
					local data = activeKeys[key]
					if data then
						local owner = data.Player
						if player == owner then
							removePartKey(key)
						end
					end
				end
			elseif request == "RequestDelete" then
				if not deleteDebounce[player] and playerIsUsingTool(player, "_KHammer") then
					local part = ...
					assertClass(part, "BasePart")

					if canGiveKey(player, part) then
						local e = Instance.new("Explosion")
						e.BlastPressure = 0
						e.Position = part.Position
						e.Parent = workspace

						local s = Instance.new("Sound")
						s.PlayOnRemove = true
						s.SoundId = "rbxasset://sounds/collide.wav"
						s.Volume = 1
						s.Parent = part

						swingBuildTool(player)
						claimAssembly(player, part)

						part:Destroy()
					end

					wait(0.1)
					deleteDebounce[player] = false
				end
			end
		end

		local function onSubmitUpdate(player, key, cframe)
			local keyData = activeKeys[key]
			if keyData then
				local owner = keyData.Player
				if owner == player then
					local part = keyData.Part
					if part and part:IsDescendantOf(workspace) then
						part.CFrame = cframe
					end
				end
			end
		end

		SubmitUpdate.OnServerEvent:Connect(onSubmitUpdate)

		----------------------------------------------------------------------------------------------------------------------------
		-- Tool Initialization
		----------------------------------------------------------------------------------------------------------------------------

		local draggerScript = script:WaitForChild("DraggerScript")

		for toolName in pairs(DECLARED_BUILD_TOOLS) do
			local BuildToolAdded = CollectionService:GetInstanceAddedSignal(toolName)
			local BuildToolRemoved = CollectionService:GetInstanceRemovedSignal(toolName)

			local function onBuildToolAdded(tool)
				if tool:IsA("Tool") and not CollectionService:HasTag(tool, "_KBuildTool") then
					tool.Name = toolName
					tool.CanBeDropped = false

					local dragger = draggerScript:Clone()
					dragger.Parent = tool
					dragger.Disabled = false

					CollectionService:AddTag(tool, "_KBuildTool")
				end
			end

			local function onBuildToolRemoved(tool)
				if tool:IsA("Tool") and CollectionService:HasTag(tool, "_KBuildTool") then
					CollectionService:RemoveTag(tool, toolName)
					CollectionService:RemoveTag(tool, "_KBuildTool")

					local char = tool.Parent
					if char and char:IsA("Model") then
						local humanoid = char:FindFirstChildOfClass("Humanoid")
						if humanoid then
							humanoid:UnequipTools()
						end
					end

					if tool:FindFirstChild("DraggerScript") then
						tool.DraggerScript:Destroy()
					end
				end
			end

			for _, buildTool in pairs(CollectionService:GetTagged(toolName)) do
				onBuildToolAdded(buildTool)
			end

			BuildToolAdded:Connect(onBuildToolAdded)
			BuildToolRemoved:Connect(onBuildToolRemoved)
		end

		----------------------------------------------------------------------------------------------------------------------------
		-- Player/HopperBin tracking
		----------------------------------------------------------------------------------------------------------------------------

		local function onDescendantAdded(desc)
			if desc:IsA("HopperBin") then
				local toolName = desc.BinType.Name
				if DECLARED_BUILD_TOOLS[toolName] then
					local tool = Instance.new("Tool")
					tool.RequiresHandle = false
					tool.Parent = desc.Parent

					CollectionService:AddTag(tool, toolName)
					desc:Destroy()
				end
			end
		end

		local function onPlayerAdded(player)
			for _, desc in pairs(player:GetDescendants()) do
				onDescendantAdded(desc)
			end
			player.DescendantAdded:Connect(onDescendantAdded)
		end

		local function onPlayerRemoved(player)
			local key = playerToKey[player]
			if key then
				removePartKey(key)
			end
		end

		for _, player in pairs(Players:GetPlayers()) do
			onPlayerAdded(player)
		end

		Players.PlayerAdded:Connect(onPlayerAdded)
		Players.PlayerRemoving:Connect(onPlayerRemoved)

		----------------------------------------------------------------------------------------------------------------------------
		-- Garbage Collection
		----------------------------------------------------------------------------------------------------------------------------

		while wait(1) do
			for part, key in pairs(partToKey) do
				if not part:IsDescendantOf(workspace) then
					removePartKey(key)
				end
			end
		end

		----------------------------------------------------------------------------------------------------------------------------
		]]
	elseif v.Name == "Script" and v.Parent.Name == "Sword" and v.Parent:FindFirstChild("GLib") then
		source = [[--[[
	Rewritten by ArceusInator
	- Completely rewrote the sword
	- Added a Configurations folder so damage settings can be easily modified
	- The sword runs on the client in non-FE to reduce the impression of input delay
	- Fixed the floaty lunge issue
	
	This script will run the sword code on the server if filtering is enabled
--]
		local Tool = script.Parent
		local GLib = require(script.Parent:WaitForChild('GLib'))
		local GLibScript = GLib.Script
		GLibScript.Name = 'GLib'
		GLibScript.Parent = Tool
		local Sword = require(Tool:WaitForChild'Sword')

		if workspace.FilteringEnabled then
			-- Run the sword code on the server and accept input from the client

			Sword:Initialize()

			Tool:WaitForChild'RemoteClick'.OnServerEvent:connect(function(client, action)
				if client.Character == Tool.Parent then
					Sword:Attack()
				end
			end)
		end
		Tool.Unequipped:connect(function()
			Sword:Unequip()
		end)]]
	elseif v.Name == "Server" and v:FindFirstChild("Rocket") then
		source = [[-----------------
--| Constants |--
-----------------

local GRAVITY_ACCELERATION = workspace.Gravity

local RELOAD_TIME = 3 -- Seconds until tool can be used again
local ROCKET_SPEED = 60 -- Speed of the projectile

local MISSILE_MESH_ID = 'http://www.roblox.com/asset/?id=2251534'
local MISSILE_MESH_SCALE = Vector3.new(0.35, 0.35, 0.25)
local ROCKET_PART_SIZE = Vector3.new(1.2, 1.2, 3.27)

-----------------
--| Variables |--
-----------------

local DebrisService = game:GetService('Debris')
local PlayersService = game:GetService('Players')

local MyPlayer

local Tool = script.Parent
local ToolHandle = Tool:WaitForChild("Handle")

local MouseLoc = Tool:WaitForChild("MouseLoc",10)

local RocketScript = script:WaitForChild('Rocket')
local SwooshSound = script:WaitForChild('Swoosh')
local BoomSound = script:WaitForChild('Boom')

--NOTE: We create the rocket once and then clone it when the player fires
local Rocket = Instance.new('Part') do
	-- Set up the rocket part
	Rocket.Name = 'Rocket'
	Rocket.FormFactor = Enum.FormFactor.Custom --NOTE: This must be done before changing Size
	Rocket.Size = ROCKET_PART_SIZE
	Rocket.CanCollide = false

	-- Add the mesh
	local mesh = Instance.new('SpecialMesh', Rocket)
	mesh.MeshId = MISSILE_MESH_ID
	mesh.Scale = MISSILE_MESH_SCALE

	-- Add fire
	local fire = Instance.new('Fire', Rocket)
	fire.Heat = 5
	fire.Size = 2

	-- Add a force to counteract gravity
	local bodyForce = Instance.new('BodyForce', Rocket)
	bodyForce.Name = 'Antigravity'
	bodyForce.Force = Vector3.new(0, Rocket:GetMass() * GRAVITY_ACCELERATION, 0)

	-- Clone the sounds and set Boom to PlayOnRemove
	local swooshSoundClone = SwooshSound:Clone()
	swooshSoundClone.Parent = Rocket
	local boomSoundClone = BoomSound:Clone()
	boomSoundClone.PlayOnRemove = true
	boomSoundClone.Parent = Rocket

	-- Attach creator tags to the rocket early on
	local creatorTag = Instance.new('ObjectValue', Rocket)
	creatorTag.Value = MyPlayer
	creatorTag.Name = 'creator' --NOTE: Must be called 'creator' for website stats
	local iconTag = Instance.new('StringValue', creatorTag)
	iconTag.Value = Tool.TextureId
	iconTag.Name = 'icon'

	-- Finally, clone the rocket script and enable it
	local rocketScriptClone = RocketScript:Clone()
	rocketScriptClone.Parent = Rocket
	rocketScriptClone.Disabled = false
end

-----------------
--| Functions |--
-----------------

local function OnActivated()
	local myModel = MyPlayer.Character
	if Tool.Enabled and myModel and myModel:FindFirstChildOfClass("Humanoid") and myModel.Humanoid.Health > 0 then
		Tool.Enabled = false
		local Pos = MouseLoc:InvokeClient(MyPlayer)
		-- Create a clone of Rocket and set its color
		local rocketClone = Rocket:Clone()
		DebrisService:AddItem(rocketClone, 30)
		rocketClone.BrickColor = MyPlayer.TeamColor

		-- Position the rocket clone and launch!
		local spawnPosition = (ToolHandle.CFrame * CFrame.new(5, 0, 0)).p
		rocketClone.CFrame = CFrame.new(spawnPosition, Pos) --NOTE: This must be done before assigning Parent
		rocketClone.Velocity = rocketClone.CFrame.lookVector * ROCKET_SPEED --NOTE: This should be done before assigning Parent
		rocketClone.Parent = workspace
		rocketClone:SetNetworkOwner(nil)

		wait(RELOAD_TIME)

		Tool.Enabled = true
	end
end

function OnEquipped()
	MyPlayer = PlayersService:GetPlayerFromCharacter(Tool.Parent)
end

--------------------
--| Script Logic |--
--------------------

Tool.Equipped:Connect(OnEquipped)
Tool.Activated:Connect(OnActivated)
]]
	elseif v.Name == "Rocket" and v.Parent.Name == "Server" then
		source = [[-----------------
--| Constants |--
-----------------

local BLAST_RADIUS = 8 -- Blast radius of the explosion
local BLAST_DAMAGE = 60 -- Amount of damage done to players
local BLAST_FORCE = 1000 -- Amount of force applied to parts

local IGNORE_LIST = {rocket = 1, handle = 1, effect = 1, water = 1} -- Rocket will fly through things named these
--NOTE: Keys must be lowercase, values must evaluate to true

-----------------
--| Variables |--
-----------------

local DebrisService = game:GetService('Debris')
local PlayersService = game:GetService('Players')

local Rocket = script.Parent

local CreatorTag = Rocket:WaitForChild('creator')
local SwooshSound = Rocket:WaitForChild('Swoosh')

-----------------
--| Functions |--
-----------------

-- Removes any old creator tags and applies a new one to the target
local function ApplyTags(target)
	while target:FindFirstChild('creator') do
		target.creator:Destroy()
	end

	local creatorTagClone = CreatorTag:Clone()
	DebrisService:AddItem(creatorTagClone, 1.5)
	creatorTagClone.Parent = target
end

-- Returns the ancestor that contains a Humanoid, if it exists
local function FindCharacterAncestor(subject)
	if subject and subject ~= workspace then
		local humanoid = subject:FindFirstChildOfClass('Humanoid')
		if humanoid then
			return subject, humanoid
		else
			return FindCharacterAncestor(subject.Parent)
		end
	end
	return nil
end

local function IsInTable(Table,Value)
	for _,v in pairs(Table) do
		if v == Value then
			return true
		end
	end
	return false
end

-- Customized explosive effect that doesn't affect teammates and only breaks joints on dead parts
local TaggedHumanoids = {}
local function OnExplosionHit(hitPart, hitDistance, blastCenter)
	if hitPart and hitDistance then
		local character, humanoid = FindCharacterAncestor(hitPart.Parent)

		if character then
			local myPlayer = CreatorTag.Value
			if myPlayer and not myPlayer.Neutral then -- Ignore friendlies caught in the blast
				local player = PlayersService:GetPlayerFromCharacter(character)
				if player and player ~= myPlayer and player.TeamColor == Rocket.BrickColor then
					return
				end
			end
		end

		if humanoid and humanoid.Health > 0 then -- Humanoids are tagged and damaged
			if not IsInTable(TaggedHumanoids,humanoid) then
				print("Tagged")
				table.insert(TaggedHumanoids,humanoid)
				ApplyTags(humanoid)
				humanoid:TakeDamage(BLAST_DAMAGE)
			end
		else -- Loose parts and dead parts are blasted
			if hitPart.Name ~= 'Handle' then
				hitPart:BreakJoints()
				local blastForce = Instance.new('BodyForce', hitPart) --NOTE: We will multiply by mass so bigger parts get blasted more
				blastForce.Force = (hitPart.Position - blastCenter).unit * BLAST_FORCE * hitPart:GetMass()
				DebrisService:AddItem(blastForce, 0.1)
			end
		end
	end
end

local function OnTouched(otherPart)
	if Rocket and otherPart then
		-- Fly through anything in the ignore list
		if IGNORE_LIST[string.lower(otherPart.Name)] then
			return
		end

		local myPlayer = CreatorTag.Value
		if myPlayer then
			-- Fly through the creator
			if myPlayer.Character and myPlayer.Character:IsAncestorOf(otherPart) then
				return
			end

			 -- Fly through friendlies
			if not myPlayer.Neutral then
				local character = FindCharacterAncestor(otherPart.Parent)
				local player = PlayersService:GetPlayerFromCharacter(character)
				if player and player ~= myPlayer and player.TeamColor == Rocket.BrickColor then
					return
				end
			end
		end

		-- Fly through terrain water
		if otherPart == workspace.Terrain then
			--NOTE: If the rocket is large, then the simplifications made here will cause it to fly through terrain in some cases
			local frontOfRocket = Rocket.Position + (Rocket.CFrame.lookVector * (Rocket.Size.Z / 2))
			local cellLocation = workspace.Terrain:WorldToCellPreferSolid(frontOfRocket)
			local cellMaterial = workspace.Terrain:GetCell(cellLocation.X, cellLocation.Y, cellLocation.Z)
			if cellMaterial == Enum.CellMaterial.Water or cellMaterial == Enum.CellMaterial.Empty then
				return
			end
		end

		-- Create the explosion
		local explosion = Instance.new('Explosion')
		explosion.BlastPressure = 0 -- Completely safe explosion
		explosion.BlastRadius = BLAST_RADIUS
		explosion.ExplosionType = Enum.ExplosionType.NoCraters
		explosion.Position = Rocket.Position
		explosion.Parent = workspace

		-- Connect custom logic for the explosion
		explosion.Hit:Connect(function(hitPart, hitDistance) OnExplosionHit(hitPart, hitDistance, explosion.Position) end)

		-- Move this script and the creator tag (so our custom logic can execute), then destroy the rocket
		script.Parent = explosion
		CreatorTag.Parent = script
		Rocket:Destroy()
	end
end

--------------------
--| Script Logic |--
--------------------

SwooshSound:Play()

Rocket.Touched:Connect(OnTouched)
]]
	elseif v.Name == "PlantBomb" then
		source = [[local bombScript = script.Parent.Bomb
local Tool = script.Parent
local Bomb = Tool.Handle

function plant()
	local bomb2 = Instance.new("Part")
   
	local vCharacter = Tool.Parent
	local vPlayer = game.Players:playerFromCharacter(vCharacter)

	local spawnPos = Bomb.Position

	bomb2.Position = Vector3.new(spawnPos.x, spawnPos.y+3, spawnPos.z)
	bomb2.Size = Vector3.new(2,2,2)
	
	bomb2.BrickColor = BrickColor.new(21)
	bomb2.Shape = 0
	bomb2.BottomSurface = 0
	bomb2.TopSurface = 0
	bomb2.Reflectance = 1
	bomb2.Name = "TimeBomb"
	bomb2.Locked = true

	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = vPlayer
	creator_tag.Name = "creator"
	creator_tag.Parent = bomb2

	bomb2.Parent = game.Workspace
	local new_script = bombScript:clone()
	new_script.Disabled = false
	new_script.Parent = bomb2
end


Tool.Enabled = true
function onActivated()

	if not Tool.Enabled then
		return
	end

	Tool.Enabled = false

	local character = Tool.Parent;
	local humanoid = character.Humanoid
	if humanoid == nil then
		print("Humanoid not found")
		return 
	end

	local targetPos = humanoid.TargetPoint
	Bomb.Transparency = 1.0

	plant()

	wait(6)
	Bomb.Transparency = 0.0

	Tool.Enabled = true
end

function onUnequipped()
end


Tool.Activated:connect(onActivated)
Tool.Unequipped:connect(onUnequipped)]]
	elseif v.Name == "Bomb" then
		source = [[local updateInterval = .4

local currentColor = 1
local colors = {26, 21} 

local ticksound = Instance.new("Sound")
ticksound.SoundId = "rbxasset://sounds\\clickfast.wav"
ticksound.Parent = script.Parent

function update()
	updateInterval = updateInterval * .9
	script.Parent.BrickColor = BrickColor.new(colors[currentColor])
	currentColor = currentColor + 1
	if (currentColor > 2) then currentColor = 1 end
end


function blowUp()
	local sound = Instance.new("Sound")
		sound.SoundId = "rbxasset://sounds\\Rocket shot.wav"
		sound.Parent = script.Parent
		sound.Volume = 1
		sound:play()
	explosion = Instance.new("Explosion")
	explosion.BlastRadius = 12
	explosion.BlastPressure = 1000000 -- these are really wussy units

	-- find instigator tag
	local creator = script.Parent:findFirstChild("creator")
	if creator ~= nil then
		explosion.Hit:connect(function(part, distance)  onPlayerBlownUp(part, distance, creator) end)
	end

	explosion.Position = script.Parent.Position
	explosion.Parent = game.Workspace
	script.Parent.Transparency = 1
end

function onPlayerBlownUp(part, distance, creator)
	if part.Name == "Head" then
		local humanoid = part.Parent.Humanoid
		tagHumanoid(humanoid, creator)
	end
end

function tagHumanoid(humanoid, creator)
	-- tag does not need to expire iff all explosions lethal	
	if creator ~= nil then
		local new_tag = creator:clone()
		new_tag.Parent = humanoid
	end
end

function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end

while updateInterval > .1 do
	wait(updateInterval)
	update()	
	ticksound:play()	
end

blowUp()
wait(2)
script.Parent:remove()
]]
	elseif v.Parent.Name == "Image Ad Unit 2" then
		source = [[local package = script.Parent
local adGui = package:WaitForChild('ADpart'):WaitForChild('AdGui')

local function updateFallbackImage()
	local fallbackImage = package:GetAttribute('FallbackImage')

	-- prepend "rbxassetid://" if the value is a base 10 number
	if tostring(tonumber(fallbackImage)) == fallbackImage then
		fallbackImage = "rbxassetid://" .. fallbackImage
	end

	adGui.FallbackImage = fallbackImage
end

package:GetAttributeChangedSignal('FallbackImage'):Connect(updateFallbackImage)

-- run for the first time
if package:GetAttribute('FallbackImage') then 
	updateFallbackImage() 
end]]
	elseif v.Name == "Slingshot" then
		source = [[Tool = script.Parent

local MouseLoc = Tool:WaitForChild("MouseLoc")

VELOCITY = 85 -- constant

local Pellet = Instance.new("Part")
Pellet.Locked = true
Pellet.BackSurface = 0
Pellet.BottomSurface = 0
Pellet.FrontSurface = 0
Pellet.LeftSurface = 0
Pellet.RightSurface = 0
Pellet.TopSurface = 0
Pellet.Shape = 0
Pellet.Size = Vector3.new(1,1,1)
Pellet.BrickColor = BrickColor.new(21)
script.Parent.PelletScript:Clone().Parent = Pellet

function fire(mouse_pos)


	Tool.Handle.SlingshotSound:Play()

-- find player's head pos

	local vCharacter = Tool.Parent
	local vPlayer = game.Players:GetPlayerFromCharacter(vCharacter)

	local head = vCharacter:FindFirstChild("Head")
	if not head then return end

	local dir = mouse_pos - head.Position
	dir = computeDirection(dir)

	local launch = head.Position + 5 * dir

	local delta = mouse_pos - launch
	
	local dy = delta.y
	
	local new_delta = Vector3.new(delta.x, 0, delta.z)
	delta = new_delta

	local dx = delta.magnitude
	local unit_delta = delta.unit
	
	-- acceleration due to gravity in RBX units
	local g = (-9.81 * 20)

	local theta = computeLaunchAngle( dx, dy, g)

	local vy = math.sin(theta)
	local xz = math.cos(theta)
	local vx = unit_delta.x * xz
	local vz = unit_delta.z * xz
	

	local missile = Pellet:Clone()
        

		

	missile.Position = launch
	missile.Velocity = Vector3.new(vx,vy,vz) * VELOCITY

	missile.PelletScript.Disabled = false

	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = vPlayer
	creator_tag.Name = "creator"
	creator_tag.Parent = missile
	
	missile.Parent = workspace

end


function computeLaunchAngle(dx,dy,grav)
	-- arcane
	-- http://en.wikipedia.org/wiki/Trajectory_of_a_projectile
	
	local g = math.abs(grav)
	local inRoot = (VELOCITY*VELOCITY*VELOCITY*VELOCITY) - (g * ((g*dx*dx) + (2*dy*VELOCITY*VELOCITY)))
	if inRoot <= 0 then
		return .25 * math.pi
	end
	local root = math.sqrt(inRoot)
	local inATan1 = ((VELOCITY*VELOCITY) + root) / (g*dx)

	local inATan2 = ((VELOCITY*VELOCITY) - root) / (g*dx)
	local answer1 = math.atan(inATan1)
	local answer2 = math.atan(inATan2)
	if answer1 < answer2 then return answer1 end
	return answer2
end

function computeDirection(vec)
	local lenSquared = vec.magnitude * vec.magnitude
	local invSqrt = 1 / math.sqrt(lenSquared)
	return Vector3.new(vec.x * invSqrt, vec.y * invSqrt, vec.z * invSqrt)
end




Tool.Enabled = true
function onActivated()

	if not Tool.Enabled then
		return
	end

	Tool.Enabled = false

	local character = Tool.Parent;
	local humanoid = character.Humanoid
	if not humanoid  then
		print("Humanoid not found")
		return 
	end

	local targetPos = MouseLoc:InvokeClient(game:GetService("Players"):GetPlayerFromCharacter(character))

	fire(targetPos)

	wait(.2)

	Tool.Enabled = true
end

script.Parent.Activated:Connect(onActivated)
]]
	elseif v.Name == "PelletScript" then
		source = [[local debris = game:service("Debris")
pellet = script.Parent
damage = 8

function onTouched(hit)
	if not hit or not hit.Parent then return end
	local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
	if humanoid then
		tagHumanoid(humanoid)
		humanoid:TakeDamage(damage)
	else
		damage = damage / 2
		if damage < 1 then
			connection:Disconnect()
			pellet.Parent = nil
		end
	end
end

function tagHumanoid(humanoid)
	-- todo: make tag expire
	local tag = pellet:FindFirstChild("creator")
	if tag then
		-- kill all other tags
		while(humanoid:FindFirstChild("creator")) do
			humanoid:findFirstChild("creator").Parent = nil
		end

		local new_tag = tag:Clone()
		new_tag.Parent = humanoid
		debris:AddItem(new_tag, 1)
	end
end

connection = pellet.Touched:Connect(onTouched)

r = game:service("RunService")
t, s = r.Stepped:Wait()
d = t + 2.0 - s
while t < d do
	t = r.Stepped:Wait()
end

pellet:Destroy()
]]
	elseif v.Name == "ServerWeaponsScript" then
		source = [[local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local curWeaponsSystemFolder = script.Parent
local weaponsSystemFolder = ReplicatedStorage:FindFirstChild("WeaponsSystem")
local weaponsSystemInitialized = false

local function initializeWeaponsSystemAssets()
	if not weaponsSystemInitialized then
		-- Enable/make visible all necessary assets
		local effectsFolder = weaponsSystemFolder.Assets.Effects
		local partNonZeroTransparencyValues = {
			["BulletHole"] = 1, ["Explosion"] = 1, ["Pellet"] = 1, ["Scorch"] = 1,
			["Bullet"] = 1, ["Plasma"] = 1, ["Railgun"] = 1,
		}
		local decalNonZeroTransparencyValues = { ["ScorchMark"] = 0.25 }
		local particleEmittersToDisable = { ["Smoke"] = true }
		local imageLabelNonZeroTransparencyValues = { ["Impact"] = 0.25 }
		for _, descendant in pairs(effectsFolder:GetDescendants()) do
			if descendant:IsA("BasePart") then
				if partNonZeroTransparencyValues[descendant.Name] ~= nil then
					descendant.Transparency = partNonZeroTransparencyValues[descendant.Name]
				else
					descendant.Transparency = 0
				end
			elseif descendant:IsA("Decal") then
				descendant.Transparency = 0
				if decalNonZeroTransparencyValues[descendant.Name] ~= nil then
					descendant.Transparency = decalNonZeroTransparencyValues[descendant.Name]
				else
					descendant.Transparency = 0
				end
			elseif descendant:IsA("ParticleEmitter") then
				descendant.Enabled = true
				if particleEmittersToDisable[descendant.Name] ~= nil then
					descendant.Enabled = false
				else
					descendant.Enabled = true
				end
			elseif descendant:IsA("ImageLabel") then
				if imageLabelNonZeroTransparencyValues[descendant.Name] ~= nil then
					descendant.ImageTransparency = imageLabelNonZeroTransparencyValues[descendant.Name]
				else
					descendant.ImageTransparency = 0
				end
			end
		end
		
		weaponsSystemInitialized = true
	end
end

if weaponsSystemFolder == nil then
	weaponsSystemFolder = curWeaponsSystemFolder:Clone()
	initializeWeaponsSystemAssets()
	weaponsSystemFolder.Parent = ReplicatedStorage
end

if ServerScriptService:FindFirstChild("ServerWeaponsScript") == nil then
	script.Parent = ServerScriptService
	initializeWeaponsSystemAssets()

	local WeaponsSystem = require(weaponsSystemFolder.WeaponsSystem)
	if not WeaponsSystem.doingSetup and not WeaponsSystem.didSetup then
		WeaponsSystem.setup()
	end
	
	local function setupClientWeaponsScript(player)
		local clientWeaponsScript = player.PlayerGui:FindFirstChild("ClientWeaponsScript")
		if clientWeaponsScript == nil then
			clientWeaponsScript = weaponsSystemFolder.ClientWeaponsScript:Clone()
			clientWeaponsScript.Parent = player.PlayerGui
		end
	end
	
	Players.PlayerAdded:Connect(function(player)
		setupClientWeaponsScript(player)
	end)
	
	for _, player in ipairs(Players:GetPlayers()) do
		setupClientWeaponsScript(player)
	end
end

if curWeaponsSystemFolder.Name == "WeaponsSystem" then
	curWeaponsSystemFolder:Destroy()
end]]
	elseif v.Name == "BrickCleanup" and v.Parent:FindFirstChild("WallMaker") then
		source = [[-- this script removes its parent from the workspace after 24 seconds
local Debris = game:GetService("Debris")
Debris:AddItem(script.Parent,24)

]]
	elseif v.Name == "WallMaker" then
		source = [[local wallHeight = 4
local brickSpeed = 0.04
local wallWidth = 12

local Tool = script.Parent

local MouseLoc = Tool:WaitForChild("MouseLoc",10)

-- places a brick at pos and returns the position of the brick's opposite corner
function placeBrick(cf, pos, color)
	local brick = Instance.new("Part")
	brick.BrickColor = color
	brick.CFrame = cf * CFrame.new(pos + brick.Size / 2)
	script.Parent.BrickCleanup:Clone().Parent = brick -- attach cleanup script to this brick
	brick.BrickCleanup.Disabled = false
	brick.Parent = game.Workspace
	brick:MakeJoints()
	return  brick, pos +  brick.Size
end

function buildWall(cf)

	local color = BrickColor.Random()
	local bricks = {}

	assert(wallWidth>0)
	local y = 0
	while y < wallHeight do
		local p
		local x = -wallWidth/2
		while x < wallWidth/2 do
			local brick
			brick, p = placeBrick(cf, Vector3.new(x, y, 0), color)
			x = p.x
			table.insert(bricks, brick)
			wait(brickSpeed)
		end
		y = p.y
	end

	return bricks

end


function snap(v)
	if math.abs(v.x)>math.abs(v.z) then
		if v.x>0 then
			return Vector3.new(1,0,0)
		else
			return Vector3.new(-1,0,0)
		end
	else
		if v.z>0 then
			return Vector3.new(0,0,1)
		else
			return Vector3.new(0,0,-1)
		end
	end
end


Tool.Enabled = true
function onActivated()

	if not Tool.Enabled then
		return
	end

	Tool.Enabled = false

	local character = Tool.Parent;
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return 
	end

	local targetPos = MouseLoc:InvokeClient(game:GetService("Players"):GetPlayerFromCharacter(character))
	local lookAt = snap( (targetPos - character.Head.Position).unit )
	local cf = CFrame.new(targetPos, targetPos + lookAt)

	Tool.Handle.BuildSound:Play()

	buildWall(cf)

	wait(5)

	Tool.Enabled = true
end

Tool.Activated:Connect(onActivated)

]]
	elseif v.Name == "BrickCleanup" and v.Parent:FindFirstChild("PaintballShooter") then
		source = [[-- this script removes its parent from the workspace after 120 seconds

		wait(120)
		script.Parent.Parent = nil
		]]
	elseif v.Name == "Paintball" then
		source = [[ball = script.Parent
damage = 2

function onTouched(hit)
	local humanoid = hit.Parent:findFirstChild("Humanoid")
	
		
	if hit:getMass() < 1.2 * 200 then
		hit.BrickColor = ball.BrickColor
	end
	-- make a splat
	for i=1,3 do
		local s = Instance.new("Part")
		s.Shape = 1 -- block
		s.formFactor = 2 -- plate
		s.Size = Vector3.new(1,.4,1)
		s.BrickColor = ball.BrickColor
		local v = Vector3.new(math.random(-1,1), math.random(0,1), math.random(-1,1))
		s.Velocity = 15 * v
		s.CFrame = CFrame.new(ball.Position + v, v)
		ball.BrickCleanup:clone().Parent = s
		s.BrickCleanup.Disabled = false
		s.Parent = game.Workspace
		
	end
	

	if humanoid ~= nil then
		tagHumanoid(humanoid)
		humanoid:TakeDamage(damage)
		wait(2)
		untagHumanoid(humanoid)
	end

	connection:disconnect()
	ball.Parent = nil
end

function tagHumanoid(humanoid)
	-- todo: make tag expire
	local tag = ball:findFirstChild("creator")
	if tag ~= nil then
		local new_tag = tag:clone()
		new_tag.Parent = humanoid
	end
end


function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end

connection = ball.Touched:connect(onTouched)

wait(8)
ball.Parent = nil
]]
	elseif v.Name == "PaintballShooter" then
		source = [[Tool = script.Parent

colors = {45, 119, 21, 24, 23, 105, 104}

function fire(v)

	Tool.Handle.Fire:play()
	

	local vCharacter = Tool.Parent
	local vPlayer = game.Players:playerFromCharacter(vCharacter)

	local missile = Instance.new("Part")

        

	local spawnPos = vCharacter.PrimaryPart.Position
	


	spawnPos  = spawnPos + (v * 8)

	missile.Position = spawnPos
	missile.Size = Vector3.new(1,1,1)
	missile.Velocity = v * 100
	missile.BrickColor = BrickColor.new(colors[math.random(1, #colors)])
	missile.Shape = 0
	missile.BottomSurface = 0
	missile.TopSurface = 0
	missile.Name = "Paintball"
	missile.Elasticity = 0
	missile.Reflectance = 0
	missile.Friction = .9

	local force = Instance.new("BodyForce")
	force.force = Vector3.new(0,90 * missile:GetMass(),0)
	force.Parent = missile
	
	Tool.BrickCleanup:clone().Parent = missile

	local new_script = script.Parent.Paintball:clone()
	new_script.Disabled = false
	new_script.Parent = missile

	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = vPlayer
	creator_tag.Name = "creator"
	creator_tag.Parent = missile
	


	missile.Parent = game.Workspace

end



Tool.Enabled = true
function onActivated()

	if not Tool.Enabled then
		return
	end

	Tool.Enabled = false

	local character = Tool.Parent;
	local humanoid = character.Humanoid
	if humanoid == nil then
		print("Humanoid not found")
		return 
	end

	local targetPos = humanoid.TargetPoint
	local lookAt = (targetPos - character.Head.Position).unit

	fire(lookAt)

	wait(.5)

	Tool.Enabled = true
end


script.Parent.Activated:connect(onActivated)
]]
	elseif v.Name == "PizzaScript" then
		source = [[--[[ alexnewtron 2014 ]--
		local Tool = script.Parent;
		enabled = true;
		function onActivated()
			if not enabled  then
				return;
			end
			enabled = false;
			Tool.GripForward = Vector3.new(.995, -.0995, -8);
			Tool.GripPos = Vector3.new(-1.5, -0.9, 0.5);
			Tool.GripRight = Vector3.new(-1, 0, 0);
			Tool.GripUp = Vector3.new(0, 1, 0);
			Tool.Handle.DrinkSound:Play();
			wait(.8);
			local h = Tool.Parent:FindFirstChild("Humanoid");
			if (h ~= nil) then
				if (h.MaxHealth > h.Health + 1.6) then
					h.Health = h.Health + 1.6
				else	
					h.Health = h.MaxHealth
				end
			end
			Tool.GripForward = Vector3.new(0, 0, -1);
			Tool.GripPos = Vector3.new(0, 0, 0.5);
			Tool.GripRight = Vector3.new(1, 0, 0);
			Tool.GripUp = Vector3.new(0,1,0);
			enabled = true;
		end
		function onEquipped()
			Tool.Handle.OpenSound:play();
		end
		script.Parent.Activated:connect(onActivated);
		script.Parent.Equipped:connect(onEquipped);]]
	elseif v.Name == "PianoScript" then
		source = [[local seat = script.Parent.Bench.Seat
local sheetMusic = script.Parent.Piano.SheetMusic
local occupant = nil
local tune = nil
local oldTune = nil
local animation = nil
local r6Anim = script.PlayingR6
local r15Anim = script.PlayingR15

tunes = {
	"rbxassetid://1835519330",
}

seat.ChildAdded:Connect(function(obj)
	if obj.Name == "SeatWeld" then
		local player = game.Players:GetPlayerFromCharacter(obj.Part1.Parent)
		if player then
			local hum = player.Character:FindFirstChild("Humanoid")
			occupant = obj.Part1.Parent
			if hum.RigType == Enum.HumanoidRigType.R6 then
				animation = hum:LoadAnimation(r6Anim)
			else
				animation = hum:LoadAnimation(r15Anim)
			end
			animation:Play()
		end
	end
end)

seat.ChildRemoved:Connect(function(obj)
	if obj.Name == "SeatWeld" then
		local player = game.Players:GetPlayerFromCharacter(obj.Part1.Parent)
		if player then
			animation:Stop()
			occupant = nil
			sheetMusic.Sound:Stop()
		end
	end
end)

while wait(0.1) do
	if occupant ~= nil then
		repeat
			tune = tunes[math.random(1, #tunes)]
		until tune ~= oldTune
		oldTune = tune
		sheetMusic.Sound.SoundId = tune	
		sheetMusic.Sound:Play()
		repeat
			wait()
		until not sheetMusic.Sound.Playing
	end
end]]
	elseif v.Name == "AttributesController" then
		source = [[local portalTemplate = script.Parent.Parent
local basePortal = portalTemplate:WaitForChild('BasePortal')

local function updateFallbackImage()
	local fallbackImage = portalTemplate:GetAttribute('FallbackImage')
	basePortal:setAttribute('FallbackImage', fallbackImage)
end

portalTemplate:GetAttributeChangedSignal('FallbackImage'):Connect(updateFallbackImage)

-- run for the first time
if portalTemplate:GetAttribute('FallbackImage') then 
	updateFallbackImage() 
end]]
	elseif v.Name == "CannonScript" then
		source = [[local Tool = script.Parent
local Ball = Tool.Handle
local MouseLoc = Tool:WaitForChild("MouseLoc",10)

function fire(direction)

	Tool.Handle.Boing:Play()

	local vCharacter = Tool.Parent
	local vPlayer = game.Players:GetPlayerFromCharacter(vCharacter)

	local missile = Instance.new("Part")       

	local spawnPos = vCharacter.PrimaryPart.Position

	spawnPos  = spawnPos + (direction * 5)

	missile.Position = spawnPos
	missile.Size = Vector3.new(2,2,2)
	missile.Velocity = direction * 200
	missile.BrickColor = BrickColor.Random()
	missile.Shape = 0
	missile.Locked = true
	missile.BottomSurface = 0
	missile.TopSurface = 0
	missile.Name = "Cannon Shot"
	missile.Elasticity = 1
	missile.Reflectance = .2
	missile.Friction = 0

	Tool.Handle.Boing:Clone().Parent = missile
	
	local new_script = script.Parent.CannonBall:Clone()
	new_script.Disabled = false
	new_script.Parent = missile

	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = vPlayer
	creator_tag.Name = "creator"
	creator_tag.Parent = missile

	missile.Parent = workspace
end



Tool.Enabled = true
function onActivated()
	if not Tool.Enabled then
		return
	end
	Tool.Enabled = false
	local character = Tool.Parent;
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		print("Humanoid not found")
		return 
	end
	local targetPos = MouseLoc:InvokeClient(game:GetService("Players"):GetPlayerFromCharacter(character))
	local lookAt = (targetPos - character.Head.Position).unit
	fire(lookAt)
	wait(2)
	Tool.Enabled = true
end


Tool.Activated:Connect(onActivated)

]]
	elseif v.Name == "CannonBall" then
		source = [[local Ball = script.Parent
local damage = 25

local r = game:GetService("RunService")
local debris = game:GetService("Debris")

local last_sound_time = r.Stepped:Wait()

function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end

function onTouched(hit)
	if not hit or not hit.Parent then return end 
	local now = r.Stepped:Wait()
	if (now - last_sound_time > .1) then
		Ball.Boing:Play()
		last_sound_time = now
	else
		return
	end

	local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
	local tag = Ball:FindFirstChild("creator")
	if tag and humanoid then
		if not IsTeamMate(tag.Value,game.Players:GetPlayerFromCharacter(humanoid.Parent)) then
			tagHumanoid(humanoid)		
			humanoid:TakeDamage(damage)	
		if connection then connection:Disconnect() end
		end
	else
		damage = damage / 2
		if damage < 2 then
			if connection then connection:Disconnect() end
		end
	end
end

function tagHumanoid(humanoid)
	-- todo: make tag expire
	local tag = Ball:FindFirstChild("creator")
	if tag then
		-- kill all other tags
		while(humanoid:FindFirstChild("creator")) do
			humanoid:FindFirstChild("creator").Parent:Destroy()
		end

		local new_tag = tag:Clone()
		new_tag.Parent = humanoid
		debris:AddItem(new_tag, 1)
	end
end


connection = Ball.Touched:Connect(onTouched)

t, s = r.Stepped:Wait()
d = t + 5.0 - s
while t < d do
	t = r.Stepped:Wait()
end

Ball:Destroy()]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("Memorial Day 2010") then
		source = [[local soldier = script.Parent
soldier.GunStorage.Gun.Parent = soldier

for _, script in pairs(soldier.ModuleScripts:GetChildren()) do
	if not game.ServerStorage:FindFirstChild(script.Name) then
		script:Clone().Parent = game.ServerStorage
	end
end

wait(1)


local AI = require(game.ServerStorage.ROBLOX_SoldierAI).new(soldier)


local DestroyService = require(game.ServerStorage.ROBLOX_DestroyService)

local function clearParts(parent)
	for _, part in pairs(parent:GetChildren()) do
		clearParts(part)
	end
	local delay
	if parent:IsA("Part") then
		delay = math.random(5,10)
	else
		delay = 11
	end
	DestroyService:AddItem(parent, delay)
end

soldier.Humanoid.Died:connect(function()
	AI.Stop()
	math.randomseed(tick())
	clearParts(soldier)
	script.Disabled = true
end)]]
	elseif v.Name == "HealthRegenerationScript" then
		source = [[-- Renegeration Script for the bot
-- Renegerates about 1% of max hp per second until it reaches max health
bot = script.Parent
Humanoid = bot:FindFirstChild("Humanoid")

local regen = false

function regenerate() 
	if regen then return end
	-- Lock this function until the regeneration to max health is complete by using a boolean toggle
	regen = true
	while Humanoid.Health < Humanoid.MaxHealth do
		local delta = wait(1)
		local health = Humanoid.Health
		if health > 0 and health < Humanoid.MaxHealth then 
			-- This delta is for regenerating 1% of max hp per second instead of 1 hp per second
			delta = 0.01 * delta * Humanoid.MaxHealth
			health = health + delta
			Humanoid.Health = math.min(health, Humanoid.MaxHealth)			
		end
	end	
	-- release the lock, since the health is at max now, and if the character loses health again
	-- it needs to start regenerating 
	regen = false
end	

if Humanoid then 
	-- Better than a while true do loop since it only fires when the health actually changes
	Humanoid.HealthChanged:connect(regenerate)	
end
]]
	elseif v.Name == "GhostScript" then
		source = [[--Made by Stickmasterluke

--Ghost Script


sp=script.Parent
lastattack=0
nextrandom=0
nextsound=0
nextjump=0
chasing=false

variance=3

damage=15
attackrange=6
sightrange=40
runspeed=24
wonderspeed=8
healthregen=false

function raycast(spos,vec,currentdist)
	local hit2,pos2=game.Workspace:FindPartOnRay(Ray.new(spos+(vec*.01),vec*currentdist),sp)
	if hit2~=nil and pos2 then
		if hit2.Transparency>=.8 or hit2.Name=="Handle" or string.sub(hit2.Name,1,6)=="Effect" then
			local currentdist=currentdist-(pos2-spos).magnitude
			return raycast(pos2,vec,currentdist)
		end
	end
	return hit2,pos2
end

function waitForChild(parent,childName)
	local child=parent:findFirstChild(childName)
	if child then return child end
	while true do
		child=parent.ChildAdded:wait()
		if child.Name==childName then return child end
	end
end

-- ANIMATION

-- declarations

local Torso=waitForChild(sp,"Torso")
local Head=waitForChild(sp,"Head")
local RightShoulder=waitForChild(Torso,"Right Shoulder")
local LeftShoulder=waitForChild(Torso,"Left Shoulder")
local RightHip=waitForChild(Torso,"Right Hip")
local LeftHip=waitForChild(Torso,"Left Hip")
local Neck=waitForChild(Torso,"Neck")
local Humanoid=waitForChild(sp,"Humanoid")
local pose="Standing"
local hitsound=waitForChild(Torso,"HitSound")

local sounds={
	waitForChild(Torso,"Ghost1Sound"),
	waitForChild(Torso,"Ghost2Sound"),
	waitForChild(Torso,"DiieieSound"),
	waitForChild(Torso,"ScreamSound"),
}

--[[creepy ghost sounds
Ghost1 94247611
Ghost2 94247729
Diieie 94247798
Scream 94247848
Rustle 94247873
]

		if healthregen then
			local regenscript=waitForChild(sp,"HealthRegenerationScript")
			regenscript.Disabled=false
		end
		Humanoid.WalkSpeed=wonderspeed

		local toolAnim="None"
		local toolAnimTime=0


		function onRunning(speed)
			if speed>0 then
				pose="Running"
			else
				pose="Standing"
			end
		end
		function onDied()
			pose="Dead"
		end
		function onJumping()
			pose="Jumping"
		end
		function onClimbing()
			pose="Climbing"
		end
		function onGettingUp()
			pose = "GettingUp"
		end
		function onFreeFall()
			pose = "FreeFall"
		end
		function onFallingDown()
			pose = "FallingDown"
		end
		function onSeated()
			pose = "Seated"
		end
		function onPlatformStanding()
			pose = "PlatformStanding"
		end

		function moveJump()
			RightShoulder.MaxVelocity = 0.5
			LeftShoulder.MaxVelocity = 0.5
			RightShoulder.DesiredAngle=3.14
			LeftShoulder.DesiredAngle=-3.14
			RightHip.DesiredAngle=0
			LeftHip.DesiredAngle=0
		end

		function moveFreeFall()
			RightShoulder.MaxVelocity = 0.5
			LeftShoulder.MaxVelocity =0.5
			RightShoulder.DesiredAngle=3.14
			LeftShoulder.DesiredAngle=-3.14
			RightHip.DesiredAngle=0
			LeftHip.DesiredAngle=0
		end

		function moveSit()
			RightShoulder.MaxVelocity = 0.15
			LeftShoulder.MaxVelocity = 0.15
			RightShoulder.DesiredAngle=3.14 /2
			LeftShoulder.DesiredAngle=-3.14 /2
			RightHip.DesiredAngle=3.14 /2
			LeftHip.DesiredAngle=-3.14 /2
		end

		function animate(time)
			local amplitude
			local frequency
			if (pose == "Jumping") then
				moveJump()
				return
			end
			if (pose == "FreeFall") then
				moveFreeFall()
				return
			end
			if (pose == "Seated") then
				moveSit()
				return
			end
			local climbFudge = 0
			if (pose == "Running") then
				RightShoulder.MaxVelocity = 0.15
				LeftShoulder.MaxVelocity = 0.15
				amplitude = 1
				frequency = 9
			elseif (pose == "Climbing") then
				RightShoulder.MaxVelocity = 0.5 
				LeftShoulder.MaxVelocity = 0.5
				amplitude = 1
				frequency = 9
				climbFudge = 3.14
			else
				amplitude = 0.1
				frequency = 1
			end
			desiredAngle = amplitude * math.sin(time*frequency)
			if not chasing and frequency==9 then
				frequency=4
			end
			if chasing then
				RightShoulder.DesiredAngle=math.pi/2
				LeftShoulder.DesiredAngle=-math.pi/2
				RightHip.DesiredAngle=-desiredAngle*2
				LeftHip.DesiredAngle=-desiredAngle*2
			else
				RightShoulder.DesiredAngle=desiredAngle + climbFudge
				LeftShoulder.DesiredAngle=desiredAngle - climbFudge
				RightHip.DesiredAngle=-desiredAngle
				LeftHip.DesiredAngle=-desiredAngle
			end
		end


		function attack(time,attackpos)
			if time-lastattack>=1 then
				local hit,pos=raycast(Torso.Position,(attackpos-Torso.Position).unit,attackrange)
				if hit and hit.Parent~=nil and hit.Parent.Name~=sp.Name then
					local h=hit.Parent:FindFirstChild("Humanoid")
					if h then
						local creator=sp:FindFirstChild("creator")
						if creator then
							if creator.Value~=nil then
								if creator.Value~=game.Players:GetPlayerFromCharacter(h.Parent) then
									for i,oldtag in ipairs(h:GetChildren()) do
										if oldtag.Name=="creator" then
											oldtag:remove()
										end
									end
									creator:clone().Parent=h
								else
									return
								end
							end
						end
						h:TakeDamage(damage)
						hitsound.Volume=.5+(.5*math.random())
						hitsound.Pitch=.5+math.random()
						hitsound:Play()
						if RightShoulder and LeftShoulder then
							RightShoulder.CurrentAngle=0
							LeftShoulder.CurrentAngle=0
						end
					end
				end
				lastattack=time
			end
		end


		Humanoid.Died:connect(onDied)
		Humanoid.Running:connect(onRunning)
		Humanoid.Jumping:connect(onJumping)
		Humanoid.Climbing:connect(onClimbing)
		Humanoid.GettingUp:connect(onGettingUp)
		Humanoid.FreeFalling:connect(onFreeFall)
		Humanoid.FallingDown:connect(onFallingDown)
		Humanoid.Seated:connect(onSeated)
		Humanoid.PlatformStanding:connect(onPlatformStanding)


		function populatehumanoids(mdl)
			if mdl.ClassName=="Humanoid" then
				table.insert(humanoids,mdl)
			end
			for i2,mdl2 in ipairs(mdl:GetChildren()) do
				populatehumanoids(mdl2)
			end
		end

		function playsound(time)
			nextsound=time+5+(math.random()*5)
			local randomsound=sounds[math.random(1,#sounds)]
			randomsound.Volume=.5+(.5*math.random())
			randomsound.Pitch=.5+(.5*math.random())
			randomsound:Play()
		end

		while sp.Parent~=nil and Humanoid and Humanoid.Parent~=nil and Humanoid.Health>0 and Torso and Head and Torso~=nil and Torso.Parent~=nil do
			local _,time=wait(1/3)
			humanoids={}
			populatehumanoids(game.Workspace)
			closesttarget=nil
			closestdist=sightrange
			local creator=sp:FindFirstChild("creator")
			for i,h in ipairs(humanoids) do
				if h and h.Parent~=nil then
					if h.Health>0 and h.Parent.Name~=sp.Name and h.Parent~=sp then
						local plr=game.Players:GetPlayerFromCharacter(h.Parent)
						if creator==nil or plr==nil or creator.Value~=plr then
							local t=h.Parent:FindFirstChild("Torso")
							if t~=nil then
								local dist=(t.Position-Torso.Position).magnitude
								if dist<closestdist then
									closestdist=dist
									closesttarget=t
								end
							end
						end
					end
				end
			end
			if closesttarget~=nil then
				if not chasing then
					playsound(time)
					chasing=true
					Humanoid.WalkSpeed=runspeed
				end
				Humanoid:MoveTo(closesttarget.Position+(Vector3.new(1,1,1)*(variance*((math.random()*2)-1))),closesttarget)
				if math.random()<.5 then
					attack(time,closesttarget.Position)
				end
			else
				if chasing then
					chasing=false
					Humanoid.WalkSpeed=wonderspeed
				end
				if time>nextrandom then
					nextrandom=time+3+(math.random()*5)
					local randompos=Torso.Position+((Vector3.new(1,1,1)*math.random()-Vector3.new(.5,.5,.5))*40)
					Humanoid:MoveTo(randompos,game.Workspace.Terrain)
				end
			end
			if time>nextsound then
				playsound(time)
			end
			if time>nextjump then
				nextjump=time+7+(math.random()*5)
				Humanoid.Jump=true
			end
			animate(time)
		end
		if sp~=nil then
			for i,v in ipairs(sp:GetChildren()) do
				if v.className=="Part" then
					v.CanCollide=false
				end
			end
		end
		wait(4)
		sp:remove() --Rest In Pizza
		]]
	elseif v.Name == "Script" and v.Parent.Name == "BloxyColaVendingMachine" then
		source = [[-- asset Id of the bloxy cola gear: http://www.roblox.com/Bloxy-Cola-item?id=10472779
local bloxyColaId = 10472779

-- when a player clicks on the vending machine, ask if they want to buy bloxy cola
script.Parent.ClickDetector.MouseClick:connect(function(player)
	Game:GetService("MarketplaceService"):PromptPurchase(player, bloxyColaId)
end)]]
	elseif v.Name == "StamperFloorRemover" then
		source = [[function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

local model = script.Parent
waitForChild(model, "StamperFloor")

model.StamperFloor:Remove()

script:Remove()]]
	elseif v.Name == "VehicleScript" then
		source = [[function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

local model = script.Parent
waitForChild(model, "Brakelight_Left")
waitForChild(model, "Brakelight_Right")
waitForChild(model, "Headlight_Left")
waitForChild(model, "Headlight_Right")
waitForChild(model, "Wheel_FrontLeft")
waitForChild(model, "Wheel_FrontRight")
waitForChild(model, "Wheel_BackLeft")
waitForChild(model, "Wheel_BackRight")
waitForChild(model, "ExhaustPipe")
waitForChild(model.ExhaustPipe, "Smoke")
waitForChild(model.ExhaustPipe, "Fire")
waitForChild(model, "VehicleSeat")
waitForChild(model, "VehicleSeatBack")
waitForChild(model.VehicleSeatBack, "BodyGyro")
waitForChild(model, "Bumper_Front")
waitForChild(model, "Bumper_Back")

local seat = model.VehicleSeat
local driverInSeat = false
local smoke = model.ExhaustPipe.Smoke
local fire = model.ExhaustPipe.Fire
local brake_L = model.Brakelight_Left
local brake_R = model.Brakelight_Right
local light_L = model.Headlight_Left
local light_R = model.Headlight_Right
local vehicleSeatBack = model.VehicleSeatBack
local gyro = vehicleSeatBack.BodyGyro
local backBumperForce = model.Bumper_Back.BodyForce
local frontBumperForce = model.Bumper_Front.BodyForce


-- SETTINGS
local brakeColor_on = BrickColor.new("Really red")
local brakeColor_off = BrickColor.new("Reddish brown")
local lightColor_on = BrickColor.new("Institutional white")
local lightColor_off = light_L.BrickColor
print("headlight off color will be " .. lightColor_off.Name)
local smokeOpacity_throttleOn = 0.5
local smokeOpacity_throttleOff = 0.1
local fireSize_big = 7
local fireSize_small = 3

function seatChildAddedHandler(child)
	if child.Name=="SeatWeld" then
		print("Turn car ON")
		driverInSeat = true
		smoke.Enabled = true
		smoke.Opacity = smokeOpacity_throttleOff
		light_L.BrickColor = lightColor_on
		light_R.BrickColor = lightColor_on
		fire.Size = fireSize_big
		fire.Enabled = true
		wait(0.3)
		fire.Size = fireSize_small
		if seat.Throttle==0 then
			fire.Enabled = false
		end
	end
end

function seatChildRemovedHandler(child)
	if child.Name=="SeatWeld" then
		print("Turn car OFF")
		driverInSeat = false
		smoke.Enabled = false
		light_L.BrickColor = lightColor_off
		light_R.BrickColor = lightColor_off
	end
end

function showBigFire()
	fire.Size = fireSize_big
	fire.Enabled = true
	wait(0.3)
	if seat.Throttle==1 then
		fire.Size = fireSize_small
	end
	wait(1)
	if seat.Throttle==1 then
		fire.Enabled = false
	end
end

local tiltForce = 84000
local tiltTime = 1
function tiltJeepBack()
	print("tiltJeepBack()")
	wait(tiltTime)
end

function tiltJeepForward()
	print("tiltJeepForward()")
	wait(tiltTime)
end

function seatChangedHandler(prop)
	if prop=="Throttle" then
		if seat.Throttle==1 then
			-- Throttle Forward
			brake_L.BrickColor = brakeColor_off
			brake_R.BrickColor = brakeColor_off
			smoke.Opacity = smokeOpacity_throttleOn
			local co = coroutine.create(showBigFire)
			coroutine.resume(co)
			local co2 = coroutine.create(tiltJeepBack)
			coroutine.resume(co2)
		elseif seat.Throttle==0 then
			-- Throttle Off
			brake_L.BrickColor = brakeColor_on
			brake_R.BrickColor = brakeColor_on
			smoke.Opacity = smokeOpacity_throttleOff
			fire.Enabled = false
			wait(0.9)
			if brake_L.BrickColor==brakeColor_on then
				brake_L.BrickColor = brakeColor_off
			end
			if brake_R.BrickColor==brakeColor_on then
				brake_R.BrickColor = brakeColor_off
			end
		elseif seat.Throttle==-1 then
			-- Throttle Reverse
			brake_L.BrickColor = lightColor_on
			brake_R.BrickColor = lightColor_on
			smoke.Opacity = smokeOpacity_throttleOff
			fire.Enabled = false
			local co = coroutine.create(tiltJeepForward)
			coroutine.resume(co)
		end
	end
end

-- Set initial colors
light_L.BrickColor = lightColor_off
light_R.BrickColor = lightColor_off
brake_L.BrickColor = brakeColor_off
brake_R.BrickColor = brakeColor_off
smoke.Enabled = false
fire.Enabled = false

print("JeepScript: connecting events...")
seat.ChildAdded:connect(seatChildAddedHandler)
seat.ChildRemoved:connect(seatChildRemovedHandler)
seat.Changed:connect(seatChangedHandler)
print("JeepScript: events connected.")

while true do
	-- Every 15 seconds, poll if jeep has turned upside down.  If true, then flip back upright.
	if(vehicleSeatBack.CFrame.lookVector.y <= 0.707) then
		print("Jeep is flipped.  Flipping right side up...")
		gyro.cframe = CFrame.new( Vector3.new(0,0,0), Vector3.new(0,1,0) )
		gyro.maxTorque = Vector3.new(1000, 1000, 1000)
		wait(2)
		gyro.maxTorque = Vector3.new(0,0,0)
	end
	wait(8)
end
]]
	elseif v.Name == "VehicleSmashScript" then
		source = [[function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

local model = script.Parent
waitForChild(model, "Brakelight_Left")
waitForChild(model, "Brakelight_Right")
waitForChild(model, "Headlight_Left")
waitForChild(model, "Headlight_Right")
waitForChild(model, "Wheel_FrontLeft")
waitForChild(model, "Wheel_FrontRight")
waitForChild(model, "Wheel_BackLeft")
waitForChild(model, "Wheel_BackRight")
waitForChild(model, "ExhaustPipe")
waitForChild(model.ExhaustPipe, "Smoke")
waitForChild(model.ExhaustPipe, "Fire")
waitForChild(model, "VehicleSeat")
waitForChild(model, "VehicleSeatBack")
waitForChild(model.VehicleSeatBack, "BodyGyro")
waitForChild(model, "Bumper_Front")
waitForChild(model, "Bumper_Back")

local seat = model.VehicleSeat
local driverInSeat = false
local smoke = model.ExhaustPipe.Smoke
local fire = model.ExhaustPipe.Fire
local brake_L = model.Brakelight_Left
local brake_R = model.Brakelight_Right
local light_L = model.Headlight_Left
local light_R = model.Headlight_Right
local vehicleSeatBack = model.VehicleSeatBack
local gyro = vehicleSeatBack.BodyGyro
local backBumperForce = model.Bumper_Back.BodyForce
local frontBumperForce = model.Bumper_Front.BodyForce


-- SETTINGS
local brakeColor_on = BrickColor.new("Really red")
local brakeColor_off = BrickColor.new("Reddish brown")
local lightColor_on = BrickColor.new("Institutional white")
local lightColor_off = light_L.BrickColor
print("headlight off color will be " .. lightColor_off.Name)
local smokeOpacity_throttleOn = 0.5
local smokeOpacity_throttleOff = 0.1
local fireSize_big = 7
local fireSize_small = 3

function seatChildAddedHandler(child)
	if child.Name=="SeatWeld" then
		print("Turn car ON")
		driverInSeat = true
		smoke.Enabled = true
		smoke.Opacity = smokeOpacity_throttleOff
		light_L.BrickColor = lightColor_on
		light_R.BrickColor = lightColor_on
		fire.Size = fireSize_big
		fire.Enabled = true
		wait(0.3)
		fire.Size = fireSize_small
		if seat.Throttle==0 then
			fire.Enabled = false
		end
	end
end

function seatChildRemovedHandler(child)
	if child.Name=="SeatWeld" then
		print("Turn car OFF")
		driverInSeat = false
		smoke.Enabled = false
		light_L.BrickColor = lightColor_off
		light_R.BrickColor = lightColor_off
	end
end

function showBigFire()
	fire.Size = fireSize_big
	fire.Enabled = true
	wait(0.3)
	if seat.Throttle==1 then
		fire.Size = fireSize_small
	end
	wait(1)
	if seat.Throttle==1 then
		fire.Enabled = false
	end
end

local tiltForce = 84000
local tiltTime = 1
function tiltJeepBack()
	print("tiltJeepBack()")
	wait(tiltTime)
end

function tiltJeepForward()
	print("tiltJeepForward()")
	wait(tiltTime)
end

function seatChangedHandler(prop)
	if prop=="Throttle" then
		if seat.Throttle==1 then
			-- Throttle Forward
			brake_L.BrickColor = brakeColor_off
			brake_R.BrickColor = brakeColor_off
			smoke.Opacity = smokeOpacity_throttleOn
			local co = coroutine.create(showBigFire)
			coroutine.resume(co)
			local co2 = coroutine.create(tiltJeepBack)
			coroutine.resume(co2)
		elseif seat.Throttle==0 then
			-- Throttle Off
			brake_L.BrickColor = brakeColor_on
			brake_R.BrickColor = brakeColor_on
			smoke.Opacity = smokeOpacity_throttleOff
			fire.Enabled = false
			wait(0.9)
			if brake_L.BrickColor==brakeColor_on then
				brake_L.BrickColor = brakeColor_off
			end
			if brake_R.BrickColor==brakeColor_on then
				brake_R.BrickColor = brakeColor_off
			end
		elseif seat.Throttle==-1 then
			-- Throttle Reverse
			brake_L.BrickColor = lightColor_on
			brake_R.BrickColor = lightColor_on
			smoke.Opacity = smokeOpacity_throttleOff
			fire.Enabled = false
			local co = coroutine.create(tiltJeepForward)
			coroutine.resume(co)
		end
	end
end

-- Set initial colors
light_L.BrickColor = lightColor_off
light_R.BrickColor = lightColor_off
brake_L.BrickColor = brakeColor_off
brake_R.BrickColor = brakeColor_off
smoke.Enabled = false
fire.Enabled = false

print("JeepScript: connecting events...")
seat.ChildAdded:connect(seatChildAddedHandler)
seat.ChildRemoved:connect(seatChildRemovedHandler)
seat.Changed:connect(seatChangedHandler)
print("JeepScript: events connected.")

while true do
	-- Every 15 seconds, poll if jeep has turned upside down.  If true, then flip back upright.
	if(vehicleSeatBack.CFrame.lookVector.y <= 0.707) then
		print("Jeep is flipped.  Flipping right side up...")
		gyro.cframe = CFrame.new( Vector3.new(0,0,0), Vector3.new(0,1,0) )
		gyro.maxTorque = Vector3.new(1000, 1000, 1000)
		wait(2)
		gyro.maxTorque = Vector3.new(0,0,0)
	end
	wait(8)
end
]]
	elseif v.Name == "SpikeScript" then
		source = [[-- useless comment

function onTouched(hit)
	if not hit or not hit.Parent then return end
	local human = hit.Parent:findFirstChild("Humanoid")
	if human and human:IsA("Humanoid") then		human:TakeDamage(100)
	end
end
script.Parent.Touched:connect(onTouched)]]
	elseif v:FindFirstChild("RemoteConnection") then
		source = [[--Made by Luckymaxer

Seat = script.Parent
Model = Seat.Parent

Engine = Model:WaitForChild("Engine")
BeamPart = Model:WaitForChild("BeamPart")
Lights = Model:WaitForChild("Lights")
Seats = Model:WaitForChild("Seats")

Sounds = {
	Flying = Engine:WaitForChild("UFO_Flying"),
	Beam = Engine:WaitForChild("UFO_Beam"),
	Idle = Engine:WaitForChild("UFO_Idle"),
	TakingOff = Engine:WaitForChild("UFO_Taking_Off")
}

Players = game:GetService("Players")
Debris = game:GetService("Debris")

BeamSize = 50
CurrentBeamSize = 0

MaxVelocity = 40
MinVelocity = -40

MaxSideVelocity = 40
MinSideVelocity = -40

Acceleration = 2
Deceleration = 2
AutoDeceleration = 2

SideAcceleration = 2
SideDeceleration = 2
AutoSideDeceleration = 2

LiftOffSpeed = 5
LiftSpeed = 10
LowerSpeed = -10

Velocity = Vector3.new(0, 0, 0)
SideVelocity = 0

FlipForce = 1000000

InUse = false
PlayerUsing = nil
PlayerControlScript = nil
PlayerConnection = nil
BeamActive = false
TakingOff = false

LightsEnabled = false

Enabled = false

Controls = {
	Forward = {Key = "W", Byte = 17, Mode = false},
	Backward = {Key = "S", Byte = 18, Mode = false},
	Left = {Key = "A", Byte = 20, Mode = false},
	Right = {Key = "D", Byte = 19, Mode = false},
	Up = {Key = "Q", Byte = 113, Mode = false},
	Down = {Key = "E", Byte = 101, Mode = false},
}

ControlScript = script:WaitForChild("ControlScript")

Beam = Instance.new("Part")
Beam.Name = "Beam"
Beam.Transparency = 0.3
Beam.BrickColor = BrickColor.new("Pastel Blue")
Beam.Material = Enum.Material.Plastic
Beam.Shape = Enum.PartType.Block
Beam.TopSurface = Enum.SurfaceType.Smooth
Beam.BottomSurface = Enum.SurfaceType.Smooth
Beam.FormFactor = Enum.FormFactor.Custom
Beam.Size = Vector3.new(BeamPart.Size.X, 0.2, BeamPart.Size.Z)
Beam.Anchored = false
Beam.CanCollide = false
BeamMesh = Instance.new("CylinderMesh")
BeamMesh.Parent = Beam

for i, v in pairs(Sounds) do
	v:Stop()
end

RemoteConnection = script:FindFirstChild("RemoteConnection")
if not RemoteConnection then
	RemoteConnection = Instance.new("RemoteFunction")
	RemoteConnection.Name = "RemoteConnection"
	RemoteConnection.Parent = script
end

BodyGyro = Engine:FindFirstChild("BodyGyro")
if not BodyGyro then
	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.Parent = Engine
end
BodyGyro.maxTorque = Vector3.new(0, 0, 0)
BodyGyro.D = 7500
BodyGyro.P = 10000

BodyPosition = Engine:FindFirstChild("BodyPosition")
if not BodyPosition then
	BodyPosition = Instance.new("BodyPosition")
	BodyPosition.Parent = Engine
end
BodyPosition.maxForce = Vector3.new(0, 0, 0)
BodyPosition.D = 10000
BodyPosition.P = 50000

BodyVelocity = Engine:FindFirstChild("BodyVelocity")
if not BodyVelocity then
	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.Parent = Engine
end
BodyVelocity.velocity = Vector3.new(0, 0, 0)
BodyVelocity.maxForce = Vector3.new(0, 0, 0)
BodyVelocity.P = 10000

FlipGyro = BeamPart:FindFirstChild("FlipGyro")
if not FlipGyro then
	FlipGyro = Instance.new("BodyGyro")
	FlipGyro.Name = "FlipGyro"
	FlipGyro.Parent = BeamPart
end
FlipGyro.maxTorque = Vector3.new(0, 0, 0)
FlipGyro.D = 500
FlipGyro.P = 3000

RiseVelocity = BeamPart:FindFirstChild("RiseVelocity")
if not RiseVelocity then
	RiseVelocity = Instance.new("BodyVelocity")
	RiseVelocity.Name = "RiseVelocity"
	RiseVelocity.Parent = BeamPart
end
RiseVelocity.velocity = Vector3.new(0, 0, 0)
RiseVelocity.maxForce = Vector3.new(0, 0, 0)
RiseVelocity.P = 10000

function RayCast(Position, Direction, MaxDistance, IgnoreList)
	return game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(Position, Direction.unit * (MaxDistance or 999.999)), IgnoreList) 
end

function ToggleLights()
	for i, v in pairs(Lights:GetChildren()) do
		if v:IsA("BasePart") then
			for ii, vv in pairs(v:GetChildren()) do
				if vv:IsA("Light") then
					vv.Enabled = LightsEnabled
				end
			end
		end
	end
end

ToggleLights()

function CheckTable(Table, Instance)
	for i, v in pairs(Table) do
		if v == Instance then
			return true
		end
	end
	return false
end

function RandomizeTable(Table)
	local TableCopy = {}
	for i = 1, #Table do
		local Index = math.random(1, #Table)
		table.insert(TableCopy, Table[Index])
		table.remove(Table, Index)
	end
	return TableCopy
end

for i, v in pairs(Model:GetChildren()) do
	if v:IsA("BasePart") and v.Name == "Beam" then
		v:Destroy()
	end
end

function GetPartsInBeam(beam)
	local IgnoreObjects = {(((PlayerUsing and PlayerUsing.Character) and PlayerUsing.Character) or nil), Model}
	local NegativePartRadius = Vector3.new((beam.Size.X / 2), ((CurrentBeamSize / 5) / 2), (beam.Size.Z / 2))
	local PositivePartRadius = Vector3.new((beam.Size.X / 2), ((CurrentBeamSize / 5) / 2), (beam.Size.Z / 2))
	local Parts = game:GetService("Workspace"):FindPartsInRegion3WithIgnoreList(Region3.new(beam.Position - NegativePartRadius, beam.Position + PositivePartRadius), IgnoreObjects, 100)
	local Humanoids = {}
	local Torsos = {}
	for i, v in pairs(Parts) do
		if v and v.Parent then
			local humanoid = v.Parent:FindFirstChild("Humanoid")
			local torso = v.Parent:FindFirstChild("Torso")
			local player = Players:GetPlayerFromCharacter(v.Parent)
			if player and humanoid and humanoid.Health > 0 and torso and not CheckTable(Humanoids, humanoid) then
				table.insert(Humanoids, humanoid)
				table.insert(Torsos, {Humanoid = humanoid, Torso = torso})
			end
		end
	end
	return Torsos
end

RemoteConnection.OnServerInvoke = (function(Player, Script, Action, Value)
	if Script and Script ~= PlayerControlScript then
		Script.Disabled = true
		Script:Destroy()
	else
		if Action == "KeyDown" then
			if Value == "l" then
				LightsEnabled = not LightsEnabled
				ToggleLights()
			elseif Value == "t" then
				if TemporaryBeam and TemporaryBeam.Parent then
					local Torsos = GetPartsInBeam(TemporaryBeam)
					local TorsosUsed = {}
					Torsos = RandomizeTable(Torsos)
					for i, v in pairs(Seats:GetChildren()) do
						if v:IsA("Seat") and not v:FindFirstChild("SeatWeld") then
							for ii, vv in pairs(Torsos) do
								if vv.Humanoid and vv.Humanoid.Parent and vv.Humanoid.Health > 0 and not vv.Humanoid.Sit and vv.Torso and vv.Torso.Parent and not CheckTable(TorsosUsed, vv.Torso) then
									table.insert(TorsosUsed, vv.Torso)
									vv.Torso.CFrame = v.CFrame
									break
								end
							end
						end
					end
				end
			end
			if not TakingOff then
				for i, v in pairs(Controls) do
					if string.lower(v.Key) == string.lower(Value) or v.Byte == string.byte(Value) then
						v.Mode = true
					end
				end
				if Controls.Up.Mode or Controls.Down.Mode then
					RiseVelocity.maxForce = Vector3.new(0, 1000000, 0)
				end
				if Controls.Forward.Mode or Controls.Backward.Mode or Controls.Left.Mode or Controls.Right.Mode or Controls.Up.Mode or Controls.Down.Mode then
					Sounds.Idle:Stop()
					Sounds.Flying:Play()
				end
			end
		elseif Action == "KeyUp" then
			if not TakingOff then
				for i, v in pairs(Controls) do
					if string.lower(v.Key) == string.lower(Value) or v.Byte == string.byte(Value) then
						v.Mode = false
					end
				end
				if not Controls.Up.Mode and not Controls.Down.Mode then
					BodyPosition.position = Engine.Position
					BodyPosition.maxForce = Vector3.new(0, 100000000, 0)
					RiseVelocity.maxForce = Vector3.new(0, 0, 0)
					RiseVelocity.velocity = Vector3.new(0, 0, 0)
				end
				if not Controls.Forward.Mode and not Controls.Backward.Mode and not Controls.Left.Mode and not Controls.Right.Mode and not Controls.Up.Mode and not Controls.Down.Mode then
					Sounds.Flying:Stop()
					Sounds.Idle:Play()
				end
			end
		elseif Action == "Button1Down" then
			if not BeamActive and not TakingOff then
				BeamActive = true
				if TemporaryBeam and TemporaryBeam.Parent then
					TemporaryBeam:Destroy()
				end
				TemporaryBeam = Beam:Clone()
				TemporaryBeam.Parent = Model
				Spawn(function()
					while TemporaryBeam and TemporaryBeam.Parent do
						local Torsos = GetPartsInBeam(TemporaryBeam)
						for i, v in pairs(Torsos) do
							if v.Humanoid and v.Humanoid.Parent and v.Humanoid.Health > 0 and v.Torso and v.Torso.Parent and not v.Torso:FindFirstChild("UFOPullForce") and not v.Torso:FindFirstChild("UFOBalanceForce") then
								local UFOPullForce = Instance.new("BodyVelocity")
								UFOPullForce.Name = "UFOPullForce"
								UFOPullForce.maxForce = Vector3.new(0, 1000000, 0)
								UFOPullForce.velocity = CFrame.new(v.Torso.Position, BeamPart.Position).lookVector * 25
								Debris:AddItem(UFOPullForce, 0.25)
								UFOPullForce.Parent = v.Torso
								local UFOBalanceForce = Instance.new("BodyGyro")
								UFOBalanceForce.Name = "UFOBalanceForce"
								UFOBalanceForce.maxTorque = Vector3.new(1000000, 0, 1000000)
								Debris:AddItem(UFOBalanceForce, 0.25)
								UFOBalanceForce.Parent = v.Torso
							end
						end
						wait()
					end
				end)
				local BeamWeld = Instance.new("Weld")
				BeamWeld.Part0 = BeamPart
				BeamWeld.Part1 = TemporaryBeam
				Spawn(function()
					Sounds.Beam:Play()
					while Enabled and BeamActive and TemporaryBeam and TemporaryBeam.Parent do
						local IgnoreTable = {Model}
						for i, v in pairs(Players:GetChildren()) do
							if v:IsA("Player") and v.Character then
								table.insert(IgnoreTable, v.Character)
							end
						end
						local BeamPartClone = BeamPart:Clone()
						local BeamPartCloneY = BeamPartClone:Clone()
						BeamPartCloneY.CFrame = BeamPartCloneY.CFrame * CFrame.Angles(-math.rad(90), 0, 0)		
						BeamPartCloneY.CFrame = BeamPartCloneY.CFrame - BeamPartCloneY.CFrame.lookVector * ((BeamPart.Size.Y / 2))
						local Hit, Position = RayCast(BeamPart.Position, BeamPartCloneY.CFrame.lookVector, BeamSize, IgnoreTable)
						CurrentBeamSize = ((BeamPart.Position - Position).magnitude * 5)
						TemporaryBeam.Mesh.Scale = Vector3.new(1, CurrentBeamSize, 1)
						BeamWeld.Parent = TemporaryBeam
						BeamWeld.C0 = CFrame.new(0, 0, 0) - Vector3.new(0, ((CurrentBeamSize / 2) + (BeamPart.Size.Y / 2)) / 5 , 0)
						wait()
					end
					BeamActive = false
					Sounds.Beam:Stop()
					if TemporaryBeam and TemporaryBeam.Parent then
						TemporaryBeam:Destroy()
					end
				end)
			end
		elseif Action == "Button1Up" then
			BeamActive = false
		end
	end
end)

function ManageMotionStep(ForceLift, CoordinateFrame)
	
	local CameraForwards = -CoordinateFrame:vectorToWorldSpace(Vector3.new(0, 0, 1))
	local CameraSideways = -CoordinateFrame:vectorToWorldSpace(Vector3.new(1, 0, 0))
	local CameraRotation = -CoordinateFrame:vectorToWorldSpace(Vector3.new(0, 1, 0))

	CameraForwards = CameraForwards * Vector3.new(1, 0, 1)
	CameraSideways = CameraSideways * Vector3.new(1, 0, 1)

	if CameraForwards:Dot(CameraForwards) < 0.1 or CameraSideways:Dot(CameraSideways) < 0.1 then
		return
	end
	
	CameraForwards = CameraForwards.unit
	CameraSideways = CameraSideways.unit

	if math.abs(Velocity.X) < 2 and math.abs(Velocity.Z) < 2 then
		BodyVelocity.velocity = Vector3.new(0, 0, 0)
	else
		BodyVelocity.velocity = Velocity
	end
	BodyGyro.cframe = CFrame.new(0, 0, 0) * CFrame.Angles(Velocity:Dot(Vector3.new(0, 0, 1)) * (math.pi / 320), 0, math.pi - Velocity:Dot(Vector3.new(1, 0, 0)) * (math.pi / 320))
	if Controls.Forward.Mode and (not Controls.Backward.Mode) and Velocity:Dot(CameraForwards) < MaxVelocity then
		Velocity = Velocity + Acceleration * CameraForwards
	elseif Controls.Backward.Mode and (not Controls.Forward.Mode) and Velocity:Dot(CameraForwards) > MinVelocity then
		Velocity = Velocity - Deceleration * CameraForwards
	elseif (not Controls.Backward.Mode) and (not Controls.Forward.Mode) and Velocity:Dot(CameraForwards) > 0 then
		Velocity = Velocity - AutoDeceleration * CameraForwards
	elseif (not Controls.Backward.Mode) and (not Controls.Forward.Mode) and Velocity:Dot(CameraForwards) < 0 then
		Velocity = Velocity + AutoDeceleration * CameraForwards
	end

	if Controls.Left.Mode and (not Controls.Right.Mode) and Velocity:Dot(CameraSideways) < MaxSideVelocity then
		Velocity = Velocity + SideAcceleration * CameraSideways
	elseif Controls.Right.Mode and (not Controls.Left.Mode) and Velocity:Dot(CameraSideways) > MinSideVelocity then
		Velocity = Velocity - SideDeceleration * CameraSideways
	elseif (not Controls.Right.Mode) and (not Controls.Left.Mode) and Velocity:Dot(CameraSideways) > 0 then
		Velocity = Velocity - AutoSideDeceleration * CameraSideways
	elseif (not Controls.Right.Mode) and (not Controls.Left.Mode) and Velocity:Dot(CameraSideways) < 0 then
		Velocity = Velocity + AutoSideDeceleration * CameraSideways
	end

	if ForceLift then
		RiseVelocity.velocity = Vector3.new(0, LiftOffSpeed, 0)
	else
		if Controls.Up.Mode and (not Controls.Down.Mode) then
			RiseVelocity.velocity = Vector3.new(0, LiftSpeed, 0)
			BodyPosition.maxForce = Vector3.new(0, 0, 0)
		elseif Controls.Down.Mode and (not Controls.Up.Mode) then
			RiseVelocity.velocity = Vector3.new(0, LowerSpeed, 0)
			BodyPosition.maxForce = Vector3.new(0, 0, 0)
		end
	end
	
end

function MotionManager()
	Spawn(function()
		TakingOff = true
		RiseVelocity.maxForce = Vector3.new(0, 1000000, 0)
		local StartTime = tick()
		Sounds.TakingOff:Play()
		while Enabled and PlayerConnection and (tick() - StartTime) < 3 do
			local CoordinateFrame = PlayerConnection:InvokeClient(PlayerUsing, "CoordinateFrame")
			ManageMotionStep(true, CoordinateFrame)
			wait()
		end
		TakingOff = false
		Sounds.TakingOff:Stop()
		while PlayerConnection and (Enabled or Velocity:Dot(Velocity) > 0.5) do
			local CoordinateFrame = PlayerConnection:InvokeClient(PlayerUsing, "CoordinateFrame")
			ManageMotionStep(false, CoordinateFrame)
			wait()
		end
	end)
end

function LiftOff()
	
	BodyGyro.maxTorque = Vector3.new(1000000, 1000000, 1000000)
	BodyVelocity.maxForce = Vector3.new(1000000, 0, 1000000)
	
	Velocity = Vector3.new(0, 0, 0)

	Enabled = true
	
	MotionManager()

end

function Equipped(Player)
	local Backpack = Player:FindFirstChild("Backpack")
	if Backpack then
		InUse = true
		PlayerUsing = Player
		PlayerControlScript = ControlScript:Clone()
		local RemoteController = Instance.new("ObjectValue")
		RemoteController.Name = "RemoteController"
		RemoteController.Value = RemoteConnection
		RemoteController.Parent = PlayerControlScript
		local VehicleSeat = Instance.new("ObjectValue")
		VehicleSeat.Name = "VehicleSeat"
		VehicleSeat.Value = Seat
		VehicleSeat.Parent = PlayerControlScript
		PlayerConnection = Instance.new("RemoteFunction")
		PlayerConnection.Name = "PlayerConnection"
		PlayerConnection.Parent = PlayerControlScript
		PlayerControlScript.Disabled = false
		PlayerControlScript.Parent = Backpack
		LiftOff()
	end
end

function Unequipped()
	if PlayerControlScript and PlayerControlScript.Parent then
		PlayerControlScript:Destroy()
	end
	Enabled = false
	PlayerControlScript = nil
	PlayerUsing = nil
	PlayerConnection = nil
	BeamActive = false
	TakingOff = false
	InUse = false
	BodyGyro.maxTorque = Vector3.new(0, 0, 0)
	BodyPosition.maxForce = Vector3.new(0, 0, 0)
	BodyVelocity.maxForce = Vector3.new(0, 0, 0)
	BodyVelocity.velocity = Vector3.new(0, 0, 0)
	RiseVelocity.maxForce = Vector3.new(0, 0, 0)
	RiseVelocity.velocity = Vector3.new(0, 0, 0)
	for i, v in pairs(Controls) do
		v.Mode = false
	end
end

function Flip()
	local EngineCloneY = Engine:Clone()
	EngineCloneY.CFrame = EngineCloneY.CFrame * CFrame.Angles(-math.rad(90), 0, 0)
	if EngineCloneY.CFrame.lookVector.Y < 0.707 then
		FlipGyro.cframe = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0)) * CFrame.Angles((-math.pi / 2), 0, 0)
		FlipGyro.maxTorque = Vector3.new(FlipForce, FlipForce, FlipForce)
		wait(2)
		FlipGyro.maxTorque = Vector3.new(0,0,0)
	end
end

Seat.ChildAdded:connect(function(Child)
	if Child:IsA("Weld") and Child.Name == "SeatWeld" then
		if Child.Part0 and Child.Part0 == Seat and Child.Part1 and Child.Part1.Parent then
			local Player = Players:GetPlayerFromCharacter(Child.Part1.Parent)
			if Player then
				Equipped(Player)
			end
		end
	end
end)

Seat.ChildRemoved:connect(function(Child)
	if Child:IsA("Weld") and Child.Name == "SeatWeld" then
		if Child.Part0 and Child.Part0 == Seat and Child.Part1 and Child.Part1.Parent then
			local Player = Players:GetPlayerFromCharacter(Child.Part1.Parent)
			if Player and Player == PlayerUsing then
				Unequipped(Player)
			end
		end
	end
end)

Spawn(function()
	while true do
		Flip()
		wait(5)
	end
end)]]
	elseif v.Parent:FindFirstChild("AnchoredParts") then
		source = [[script.Parent.Base.BodyGyro.cframe = script.Parent.Base.CFrame
		script.Parent.Base.Anchored = false]]
	elseif v.Name == "RegenerateHealth" then
		source = [[--Made by Luckymaxer

Figure = script.Parent

Humanoid = Figure:WaitForChild("Humanoid")

Regenerating = false

function RegenerateHealth()
	if Regenerating then
		return
	end
	Regenerating = true
	while Humanoid.Health < Humanoid.MaxHealth do
		local Second = wait(1)
		local Health = Humanoid.Health
		if Health > 0 and Health < Humanoid.MaxHealth then
			local NewHealthDelta = (0.01 * Second * Humanoid.MaxHealth)
			Health = (Health + NewHealthDelta)
			Humanoid.Health = math.min(Health, Humanoid.MaxHealth)
		end
	end
	if Humanoid.Health > Humanoid.MaxHealth then
		Humanoid.Health = Humanoid.MaxHealth
	end
	Regenerating = false
end

Humanoid.HealthChanged:connect(RegenerateHealth)  ]]
	elseif v.Name == "AlienAIScript" then
		source = [[local zombie = script.Parent 

while zombie:FindFirstChild("ParentTag") == nil do 
	wait()
end

while zombie:FindFirstChild("Humanoid") == nil or zombie:FindFirstChild("Torso") == nil do 
	wait()
end

local zombieHumanoid = zombie.Humanoid
local zombieTorso = zombie.Torso

local parentTag = zombie.ParentTag
local summoner = parentTag.Value 

local summonerTorso = summoner:FindFirstChild("Torso")
local summonerHumanoid = summoner:FindFirstChild("Humanoid")

function bite(hit)
	if hit and hit.Parent and hit.Parent.Name ~= "Zombie" then 		
		local humanoid = hit.Parent:FindFirstChild("Humanoid") 
		if humanoid and humanoid ~= zombieHumanoid and zombieHumanoid ~= nil and humanoid.Health > 0 and humanoid ~= summonerHumanoid then 			
			humanoid:TakeDamage(15)			
		end
	end
end

zombieTorso.Touched:connect(bite)

while zombieHumanoid.Health < 250 do 
	zombieHumanoid.Health = 250 
	wait()
end 

local targetEnemyTorso = nil

local checkAOE = Vector3.new(15, 15, 15)

while true do 
	if summoner == nil or summonerTorso == nil then zombie:Remove() end 
	local ray = game.Workspace:FindPartOnRay(Ray.new(zombieTorso.Position + Vector3.new(0, -2, 0),  zombieTorso.CFrame.lookVector * 5.0), nil)
	if ray and zombieHumanoid then 
		zombieHumanoid.Jump = true 
	end
	if targetEnemyTorso == nil then				
		local parts = game.Workspace:FindPartsInRegion3(Region3.new(zombieTorso.Position - checkAOE, zombieTorso.Position + checkAOE), summoner, 100)
		for i = 1, #parts do 
			if parts[i] and parts[i].Parent then 
				local character = parts[i].Parent 
				if character ~= zombie and character.Name ~= "Zombie" and character:FindFirstChild("Torso") and character:FindFirstChild("Humanoid") then 
					targetEnemyTorso = character.Torso					
				end
			end
		end
	end
	if targetEnemyTorso then 		
		local distance = (targetEnemyTorso.Position - zombieTorso.Position).magnitude
		local targetEnemy = targetEnemyTorso.Parent 
		local targetEnemyHumanoid = targetEnemy:FindFirstChild("Humanoid")
		if distance < 20 and targetEnemyHumanoid and targetEnemyHumanoid.Health > 0 then
			zombie.Humanoid:MoveTo(targetEnemyTorso.Position, targetEnemyTorso) 		
		else 
			targetEnemyTorso = nil
			if summoner and summonerTorso then 
				zombie.Humanoid:MoveTo(summonerTorso.Position + (CFrame.Angles(0, math.random(1, 4) * math.pi/4, 0) * summonerTorso.CFrame.lookVector * 4.0), summonerTorso) 
			else 
				if zombie then zombie:Remove()  end
			end
		end
	else 
		targetEnemyTorso = nil
		if summoner and summonerTorso then 	
			tick()
			zombie.Humanoid:MoveTo(summonerTorso.Position + (CFrame.Angles(0, math.random(1, 4) * math.pi/4, 0) * summonerTorso.CFrame.lookVector * math.random(2.0, 6.0)), summonerTorso) 
		else 
			if zombie then zombie:Remove()  end
		end	
	end
	wait(0.1) 
end

]]
	elseif v.Name == "UFOScript" then
		source = [[local seat = script.Parent
local vChar = nil
local vPlayer = nil
local driveTool = nil

local rayBeam = seat.Parent.RayBeam

function waitForChild(parent, child)
	while not parent:FindFirstChild(child) do parent.ChildAdded:wait() end
end

-- fix rayBeam to be right size and transparent
waitForChild(seat.Parent, "btm")
waitForChild(seat.Parent.btm, "rayWeld")

local rayWeld = seat.Parent.btm.rayWeld
rayWeld.Parent = nil
rayBeam.Size = Vector3.new(2, 53.2, 2)
rayWeld.Parent = seat.Parent.btm
rayWeld.C0 = rayWeld.C0 - rayWeld.C0.p + Vector3.new(-4, 0.5, 4)

rayBeam.Transparency = 1

function bindToNewPlayer()
 vPlayer = game.Players:GetPlayerFromCharacter(vChar)

 if vPlayer then
  -- remove motion damper script
  local motionDamper = seat.Parent.btm:FindFirstChild("MotionDamper")
  if motionDamper then motionDamper:Remove() end

  -- copy over UFO drive tool
  --driveTool = script.UFODriveTool:Clone()
  driveToolClone = script.UFODriveTool:Clone()
  driveTool = script.UFODriveTool

  local newHandle = Instance.new("Part")
  newHandle.Size = Vector3.new(.1, .1, .1)
  newHandle.Transparency = 1
  newHandle.Name = "Handle"
  newHandle.Parent = driveTool
  driveTool.UFOPointer.Value = seat.Parent

  -- remove existing tools
  local vChildren = vChar:GetChildren()
  for i = 1, #vChildren do
   if vChildren[i]:IsA("Tool") then
    vChildren[i].Parent = vPlayer.Backpack
   end
  end

  -- give 'em the saucer tool!
  driveToolClone.Parent = script
  driveTool.Parent = vChar
 end
end

function checkAddChild(newChild)
	if newChild.Name == "SeatWeld" then
		if newChild.Part0 == seat then vChar = newChild.Part1.Parent
		else vChar = newChild.Part0.Parent end

		bindToNewPlayer()
	end
end

function checkRemoveChild(oldChild)
	if oldChild.Name == "SeatWeld" then
		vChar = nil
		vPlayer = nil
		driveTool:Remove()
		driveTool = nil

		local newMotionDamper = script.Parent.Parent.btm:FindFirstChild("MotionDamper")
		if newMotionDamper == nil then
			newMotionDamper = script.UFODriveTool.UFODriveScript.MotionDamper:Clone()
			newMotionDamper.Parent = script.Parent.Parent.btm
			newMotionDamper.Disabled = false
		end

		script.Parent.Parent.btm.UFOPosition.maxForce = Vector3.new(0, 0, 0)
		script.Parent.Parent.btm.UFOGyro.maxTorque = Vector3.new(0, 0, 0)

		rayBeam.Transparency = 1
	end
end


seat.ChildAdded:connect(checkAddChild)
seat.ChildRemoved:connect(checkRemoveChild)]]
	elseif v.Name == "MotionDamper" then
		source = [[local engine = script.Parent
local engineForce = engine.UFOVelocity

local autoDeceleration = .25

while engineForce.velocity:Dot(engineForce.velocity) > .05 do
	engineForce.velocity = engineForce.velocity - engineForce.velocity.unit * autoDeceleration
	wait()
end
]]
	elseif v.Name == "FlipUpright" then
		source = [[function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

local model = script.Parent
waitForChild(model, "VehicleSeatback")
local vehicleSeatback = model.VehicleSeatback
waitForChild(model, "VehicleSeat")
local vehicleSeat = model.VehicleSeat
waitForChild(vehicleSeat, "BodyGyro")
local gyro = vehicleSeat.BodyGyro

--------------------
local flipForce = 500
--------------------

while true do
	-- Every 15 seconds, poll if jeep has turned upside down.  If true, then flip back upright.
	if(vehicleSeatback.CFrame.lookVector.y <= 0.707) then
		print("UFO is flipped.  Flipping right side up...")
		gyro.cframe = CFrame.new( Vector3.new(0,0,0), Vector3.new(0,1,0) )
		gyro.maxTorque = Vector3.new(flipForce, flipForce, flipForce)
		wait(2)
		gyro.maxTorque = Vector3.new(0,0,0)
	end
	wait(8)
end
]]
	elseif v.Name == "Fountain 1" then
		source = [[local lifetime = 0.6

while true do
	wait(.1)
	local pos = script.Parent
	local b = Instance.new("Part")	

	b.Position = pos.Position + pos.CFrame.lookVector
	b.Size = Vector3.new(1, 1, 1)
	b.Shape = 0
        b.BrickColor=BrickColor.new("Bright blue")
	b.Transparency = 0.3
	b.TopSurface = "Smooth"
	b.BottomSurface = "Smooth"
	b.CanCollide = true
	b.Parent = game.Workspace
	b.Velocity = Vector3.new(1, 75, 1)
	game:GetService("Debris"):AddItem(b, lifetime)
end
]]
	elseif v.Name == "Fountain 2" then
		source = [[bin = script.Parent

function onTouched(part)
	part.BrickColor = BrickColor.new(26)
	wait(.3)
	part.Transparency = .2
	wait(.1)
	part.Transparency = .4
	wait(.1)
	part.Transparency = .6
	wait(.1)
	part.Transparency = .8
	wait(.1)
	part.Parent = nil
end

connection = bin.Touched:connect(onTouched)
]]
	elseif v.Name == "Flipper" and v.Parent.Name == "SkateboardPlatform" then
		source = [[local parts = script.Parent.Parent:GetChildren()
print("count" .. #parts)
local uprightCF = script.Parent.CFrame

local con = nil

function boardIsFlipped()
	local v1 = script.Parent.CFrame:vectorToWorldSpace(Vector3.FromNormalId(Enum.NormalId.Top))
	local v2 = Vector3.new(0,1,0)

	local ang = math.acos(v1:Dot(v2))

	return ang > 2
end

function onTouched(hit)

	if (hit.Parent ~= nil and hit.Parent:FindFirstChild("Humanoid") ~= nil) then
		if (script.Parent.Controller == nil) then
			if (boardIsFlipped()) then
				con:disconnect()
				con = nil

				print("FLIP IT")
				-- no one is riding this thing

				script.Parent.StickyWheels = false

				-- pin
				local bp = Instance.new("BodyPosition")
				bp.maxForce = Vector3.new(5e7,5e7,5e7)
				bp.position = script.Parent.Position + Vector3.new(0,4,0)
				bp.Parent = script.Parent

				-- flip
				local fg = Instance.new("BodyGyro")
				fg.maxTorque = Vector3.new(5e7,5e7,5e7)
				fg.cframe = uprightCF
				fg.Parent = script.Parent
				wait(1)
				fg:Remove()
				wait(1)
				bp:Remove()

				script.Parent.StickyWheels = true
			end
		end
	end
	wait(1)
	
	if (con == nil) then con = script.Parent.Touched:connect(onTouched) end
end

con = script.Parent.Touched:connect(onTouched)

while true do
	for i=1,#parts do
		if parts[i].className == "Part" and (script.Parent.Position - parts[i].Position).magnitude > 5 then
			script.Parent.Parent:Remove()
		end
	end
	wait(1)
end
]]
	elseif v.Name == "IdleDelete" then
		source = [[local Board = script.Parent

-- DISGUSTING. NEVER DO THIS.
function nearPlayer()
	local p = game.Players:GetPlayers()

	for i=1,#p do

		if (p[i].Character) then
			local t = p[i].Character:FindFirstChild("Torso")
			if t then
				if (Board.Position - t.Position).magnitude < 20 then
					return true
				end
			end
		end
	
	end
	return false

end

function sepuku()
	if not nearPlayer() then
		Board:Remove()
	end
end

while true do
	wait(30)
	sepuku()
end

]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("Weld") and v.Parent.Name == "Smooth Block Model" then
		source = [[while true do 
script.Parent.Color = Color3.new(math.random(), math.random(), math.random()) 
wait(2.0) 
end 
]]
	elseif v.Name == "WalkAndTalk" then
		source = [[function getRandomPhrase()
	local playerName = script.Parent.Target.Value.Parent.Name
	local phrases = {
		playerName:upper() .. " IS IN THIS SERVER!!1",
		"I MET " .. playerName:upper(),
		"give " .. playerName:lower() .. " some space!",
		"how did you get famous?",
		"omg " .. playerName .. " plz don8",
		"OMG LEAVE " .. playerName:upper() .. "ALONE",
		playerName:upper() .. "!!1",
		playerName .. " is just a normal person guys",
		"will u don8",
		"i am your biggest fan",
		"how much robux u got?",
		"plz join my group",
		"HOLY TELAMON ITS " .. playerName:upper(),
		"my brother loves ur game",
		"im putting this in my blurb",
		"second famous person i met 2day",
		"GIVE " .. playerName:upper() .. " SPACE!!",
		playerName:upper(),
		playerName:lower(),
		"no wonder famous people never talk",
		"do you talk?",
		"will you donate 100k R$ to me?",
		"come to my place i need to show u a glitch",
		"how much will u donate?",
		"i can't believe it's " .. playerName,
		"can u make me famous?",
		"are you afk?",
		"why wont you talk to me?",
		"famous ppl never donate",
		"famous people are greedy",
		playerName .. " do you donate?",
		"whats it like being a famous person?",
		"how much tix u got man?",
		"make me famous and ill give u 23 tix",
		"can i copy ur game?",
		"there are hackers at your game, plz ban them",
		"buy gear from my place",
		"can i take a screenshot?",
		"i am recording this lol"
	}
 	return phrases[math.random(#phrases)]
end

local function plusOrMinus(number)
	return math.random(number - 4, number + 4)	
end

local function randomize(v)
	return Vector3.new(plusOrMinus(v.X), plusOrMinus(v.Y), plusOrMinus(v.Z))
end

wait(math.random())
local walkspeed = script.Parent.Humanoid.WalkSpeed
local hum = script.Parent.Humanoid
local head = script.Parent.Head
local torso = script.Parent.Torso
local target = script.Parent.Target.Value
while true do
	if (torso.Position - target.Position).magnitude < 2 then
		hum.WalkSpeed = 0
	else
		hum.WalkSpeed = walkspeed
		hum:MoveTo(randomize(target.Position), target)
	end
	game:GetService("Chat"):Chat(head, getRandomPhrase())
	wait(1)
end]]
	elseif string.match(v.Name,"DispenserScript") then
		source = [[local dispenser = script.Parent
local asset = dispenser:FindFirstChild("Asset")
local gear 
local item 

local base = dispenser:FindFirstChild("FirePart")
local firePart = dispenser:FindFirstChild("FirePart")

local fake = dispenser:FindFirstChild("SwordThumbnailClone")
if fake then fake:Remove() end
local fire

local children = dispenser:GetChildren()
for i = 1, #children do 
	if children[i]:IsA("Tool") then 
		children[i]:Destroy() 
	end 
end 

local assetId 

function spawnGear()	
	gear = dispenser:FindFirstChild("Gear")
	if gear.Value == false then		
		item = game:GetService("InsertService"):LoadAsset(assetId)
		if item then 
			gear.Value = true
			item = item:GetChildren()[1] -- The first child is our tool
			if item then
				item.Parent = dispenser 
				item.AncestryChanged:connect(function() 
						if item.Parent and item.Handle then 
							item.Handle.CanCollide = true
							local float = item.Handle:FindFirstChild("FLOAT")
							local bav = item.Handle:FindFirstChild("BAV")
							local bp = item.Handle:FindFirstChild("BP")
							if float then float:Remove() end 
							if bav then bav:Remove() end
							if bp then bp:Remove() end
							if fire then fire:Remove() end
							wait(1.5) 
							gear.Value = false 
						end 
				end)
				if base then 
					item.Handle.CFrame = (base.CFrame + Vector3.new(0, 3, 0)) * CFrame.Angles(math.pi/2, 0, 0)
					local floatForce = Instance.new("BodyForce")
					floatForce.Name = "FLOAT"
					floatForce.force = Vector3.new(0, item.Handle:GetMass() * 196.1, 0) 
					floatForce.Parent = item.Handle

					local bp = Instance.new("BodyPosition")
					bp.Name = "BP"
					bp.maxForce = Vector3.new(500000, 500000, 500000)
					bp.P = 500000
					bp.position = item.Handle.Position
					bp.Parent = item.Handle

					local bav = Instance.new("BodyAngularVelocity")
					bav.Name = "BAV"
					bav.P = 700000
					bav.maxTorque = Vector3.new(0, bav.P, 0)
					bav.angularvelocity = Vector3.new(0, 100, 0)
					bav.Parent = item.Handle
					
					tick()
					fire = Instance.new("Fire")
					fire.Heat = 15
					fire.Size = 4
					fire.Color = Color3.new(math.random(1, 255)/255, math.random(1, 255)/255, math.random(1, 255)/255) 
					fire.SecondaryColor = Color3.new(math.random(1, 255)/255, math.random(1, 255)/255, math.random(1, 255)/255)
					fire.Parent = firePart
					
					item.Handle.CanCollide = false
				end
			end
		end
	else 
		-- do nothing
	end
end

if asset then 
	assetId = asset.Value
	while assetId do 		
		spawnGear()
		wait(25.0)
	end
end
]]
	elseif v.Name == "AutomaticUpdating" then
		source = [[local Tool = script.Parent.Parent;

function IsVersionOutdated(Version)
	-- Returns whether the given version of Building Tools is out of date

	-- Check most recent version number
	local AssetInfo = Game:GetService('MarketplaceService'):GetProductInfo(142785488, Enum.InfoType.Asset);
	local LatestMajorVersion, LatestMinorVersion, LatestPatchVersion = AssetInfo.Description:match '%[Version: ([0-9]+)%.([0-9]+)%.([0-9]+)%]';
	local CurrentMajorVersion, CurrentMinorVersion, CurrentPatchVersion = Version:match '([0-9]+)%.([0-9]+)%.([0-9]+)';

	-- Convert version data into numbers
	local LatestMajorVersion, LatestMinorVersion, LatestPatchVersion =
		tonumber(LatestMajorVersion), tonumber(LatestMinorVersion), tonumber(LatestPatchVersion);
	local CurrentMajorVersion, CurrentMinorVersion, CurrentPatchVersion =
		tonumber(CurrentMajorVersion), tonumber(CurrentMinorVersion), tonumber(CurrentPatchVersion);

	-- Determine whether current version is outdated
	if LatestMajorVersion > CurrentMajorVersion then
		return true;
	elseif LatestMajorVersion == CurrentMajorVersion then
		if LatestMinorVersion > CurrentMinorVersion then
			return true;
		elseif LatestMinorVersion == CurrentMinorVersion then
			return LatestPatchVersion > CurrentPatchVersion;
		end;
	end;

	-- Return an up-to-date status if not oudated
	return false;

end;

-- Ensure tool mode is enabled, auto-updating is enabled, and version is outdated
if not (Tool:IsA 'Tool' and Tool.AutoUpdate.Value and IsVersionOutdated(Tool.Version.Value)) then
	return;
end;

-- Use module to insert latest tool
local GetLatestTool = require(580330877);
if not GetLatestTool then
	return;
end;

-- Get latest copy of tool
local NewTool = GetLatestTool();
if NewTool then

	-- Prevent update attempt loops since fetched version is now cached
	NewTool.AutoUpdate.Value = false;

	-- Cancel replacing current tool if fetched version is the same
	if NewTool.Version.Value == Tool.Version.Value then
		return;
	end;

	-- Detach update script from tool and save old tool parent
	script.Parent = nil;
	local ToolParent = Tool.Parent;

	-- Remove current tool (delayed to prevent parenting conflicts)
	wait(0.05);
	Tool.Parent = nil;

	-- Remove the tool again if anything attempts to reparent it
	Tool.Changed:Connect(function (Property)
		if Property == 'Parent' and Tool.Parent then
			wait(0.05);
			Tool.Parent = nil;
		end;
	end);

	-- Add the new tool
	NewTool.Parent = ToolParent;

end;]]
	elseif v.Name == "DescendantCounter" then
		source = [[local Count = script.Parent;
local Tool = Count.Parent.Parent;

-- Exclude counting autoremoving items (thumbnail and autoupdating script)
local AutoremovingItemsCount = 5 + 1;

-- Provide total count of all descendants
Count.Value = #Tool:GetDescendants() - AutoremovingItemsCount;]]
	elseif v.Name == "ServerEndpoint" then
		source = [[local ServerEndpoint = script.Parent;
local SyncAPI = ServerEndpoint.Parent;
local Tool = SyncAPI.Parent;

-- Start the server-side sync module
SyncModule = require(SyncAPI:WaitForChild 'SyncModule');

-- Provide functionality to the server API endpoint instance
ServerEndpoint.OnServerInvoke = function (Client, ...)
	return SyncModule.PerformAction(Client, ...);
end;]]
	elseif v.Name == "PluginInitializer" then
		source = [[if plugin then
    require(script.Parent)
end]]
	elseif v.Name == "Smooth Color Changing Script" then
		source = [[r = 255
g = 0
b = 0

while true do
	wait(0.005)
	
    while (r == 255 and g ~= 255) do
	wait(0.005)
	g = g + 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	end
	wait(0.005)
	r = r - 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	while (r ~= 0) do
	wait(0.005)
	r = r - 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	end

    while (g == 255 and b ~= 255) do
	wait(0.005)
	b = b + 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	end
	wait(0.005)
	g = g - 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	while (g ~= 0) do
	wait(0.005)
	g = g - 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	end
	
	while (b == 255 and r ~= 255) do
	wait(0.005)
	r = r + 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	end
	wait(0.005)
	b = b - 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	while (b ~= 0) do
	wait(0.005)
	b = b - 1
	script.Parent.Color = Color3.fromRGB(r,g,b)
	end
	
end]]
	elseif v.Name == "BerezaaGamesNuclearScript" then
		source = [[-- Fun nuke by berezaa
-- Credit to FriendlyBiscuit/eric for uploading the loopable alarm sound for me

wait(1)

script.Parent.Missle.Base.Anchored = true

debounce = false

script.Parent.Button.ClickDetector.MouseClick:connect(function()
	if debounce == false then
		debounce = true
		script.Parent.Button.Sound:Play()
		
		local siren = script.Parent.Button.Siren
		siren.Parent = workspace
		siren:Play()
		
		coroutine.resume(coroutine.create(function()
			local lights = script.Parent.Lights:GetChildren()
			for i=1,100 do
				for i,v in pairs(lights) do
					v.SpotLight.Enabled = true
				end
				wait(0.54)
				for i,v in pairs(lights) do
					v.SpotLight.Enabled = false
				end
				wait(0.54)			
			end
		end))
		
		wait(2)
		
		script.Parent.Missle.Base.Fire.Enabled = true
		script.Parent.Missle.Base.Smoke.Enabled = true
		
		wait(3)
		
		script.Parent.Missle.PrimaryPart = script.Parent.Missle.Base	
		for i=1,320 do
			script.Parent.Missle:SetPrimaryPartCFrame(script.Parent.Missle:GetPrimaryPartCFrame()+Vector3.new(0,0.05*((1.1^(i/5))/3),0))
			wait()
		end
		wait()
		for i=1,100 do
			script.Parent.Missle:SetPrimaryPartCFrame(script.Parent.Missle:GetPrimaryPartCFrame()+Vector3.new(0,0.05*(1.1^((250-i)/5)/3),0))
				script.Parent.Missle:SetPrimaryPartCFrame(script.Parent.Missle:GetPrimaryPartCFrame()*CFrame.Angles(0,math.pi/100,0))
				script.Parent.Missle:SetPrimaryPartCFrame(script.Parent.Missle:GetPrimaryPartCFrame()+Vector3.new(0,0,-i/100))	
			wait()
		end
		wait()
		for i=200,120,-1 do
			script.Parent.Missle:SetPrimaryPartCFrame(script.Parent.Missle:GetPrimaryPartCFrame()-Vector3.new(0,0.1*((1.1^(i/2.95))/4),0))
			wait()
		end	
		
		script.Parent.Missle.Tip.Transparency = 0.5
		script.Parent.Missle.Tip.CanCollide = false
		script.Parent.Missle.Tip.Mesh.Scale = Vector3.new(1,1,1)
		local boom = script.Parent.Button.Boom
		boom.Parent=workspace
		boom:Play()
		local frame = script.Parent.Missle.Tip.CFrame
		
		script.Parent.Missle.Tip.Boom.Disabled = false	
		
		for i=1,400 do
			script.Parent.Missle.Tip.Size=script.Parent.Missle.Tip.Size+Vector3.new(3,3,3)
			script.Parent.Missle.Tip.CFrame=frame
			wait()
		end
		script.Parent.Missle.Tip.Boom.Disabled=true
		script.Parent.Missle:Destroy()
		siren:Stop()
		boom:Stop()
		
		
	end
end)]]
	elseif v.Name == "Boom" and v.Parent.Name == "Tip" then
		source = [[while true do
c = game.Workspace:GetChildren()
for i =1,#c do
if ((c[i].className == "Part" or c[i].className == "TrussPart" or c[i].className == "WedgePart" or c[i].className == "Seat" or c[i].className == "VehicleSeat") and (c[i].Position - script.Parent.Position).magnitude < (script.Parent.Size.X / 2.1) - 5) then
if c[i].Locked == false then
c[i].Material = Enum.Material.CorrodedMetal
c[i].Anchored = false
c[i]:BreakJoints()
local miniboom = script.Parent.Parent.Parent.Button.SmallBoom:Clone()
miniboom.Parent=c[i]
miniboom:Play()
game.Debris:AddItem(miniboom,1)
end
end
if (c[i].className == "Model") then
end
g = c[i]:GetChildren()
for j =1,#g do
if ((g[j].className == "Part" or g[j].className == "TrussPart" or g[j].className == "WedgePart" or g[j].className == "Seat" or g[j].className == "VehicleSeat") and g[j].Name ~= script.Parent.Name and g[j].Name ~= "Glow" and (g[j].Position - script.Parent.Position).magnitude < (script.Parent.Size.X / 2.1) - 5) then
g[j].Material = Enum.Material.CorrodedMetal
g[j].Anchored = false
g[j]:BreakJoints()
local miniboom = script.Parent.Parent.Parent.Button.SmallBoom:Clone()
miniboom.Parent=c[i]
miniboom:Play()
game.Debris:AddItem(miniboom,1)
end
if (g[j].className == "Model") then
end
t = g[j]:GetChildren()
for s =1,#t do
if ((t[s].className == "Part" or t[s].className == "TrussPart" or t[s].className == "WedgePart" or t[s].className == "Seat" or t[s].className == "VehicleSeat") and t[s].Name ~= script.Parent.Name and t[s].Name ~= "Glow" and (t[s].Position - script.Parent.Position).magnitude < (script.Parent.Size.X / 2.1) - 5) then
t[s].Material = Enum.Material.CorrodedMetal
t[s].Anchored = false
t[s]:BreakJoints()
end
if (t[s].className == "Model") then
end
a = t[s]:GetChildren()
for z =1,#a do
if ((a[z].className == "Part" or a[z].className == "TrussPart" or a[z].className == "WedgePart" or a[z].className == "Seat" or a[z].className == "VehicleSeat") and a[z].Name ~= script.Parent.Name and a[z].Name ~= "Glow" and (a[z].Position - script.Parent.Position).magnitude < (script.Parent.Size.X / 2.1) - 5) then
a[z].Material = Enum.Material.CorrodedMetal
a[z].Anchored = false
a[z]:BreakJoints()
end
if (a[z].className == "Model") then
end
p = a[z]:GetChildren()
for l =1,#p do
if ((p[l].className == "Part" or p[l].className == "TrussPart" or p[l].className == "WedgePart" or p[l].className == "Seat" or p[l].className == "VehicleSeat") and p[l].Name ~= script.Parent.Name and p[l].Name ~= "Glow" and (p[l].Position - script.Parent.Position).magnitude < (script.Parent.Size.X / 2.1) - 5) then
p[l].Material = Enum.Material.CorrodedMetal
p[l].Anchored = false
p[l]:BreakJoints()
end
end
end
end
end
end
wait(.3)
end
]]
	elseif v.Name == "TeleporterScript" then
		source = [[local buttons = {}
local doors = {}
local teleports = {}
local running = false
local opening = false

function CheckChildren(obj)
	for i, v in pairs(obj:GetChildren()) do
		if v.Name == "Doors" then
			table.insert(doors, v)
		elseif v.Name == "Button" then
			table.insert(buttons, v)
		elseif v.Name == "Teleport" then
			table.insert(teleports, v)
		end
		CheckChildren(v)
	end
end

CheckChildren(script.Parent)

function openDoors()
	if not opening then
		opening = true
		for i, v in pairs(buttons) do
			v.DoorSound:Play()
		end
		for i = 1, 37 do
			for i, v in pairs(doors) do
				v.LeftDoor:SetPrimaryPartCFrame(v.LeftDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(2), 0))
				v.RightDoor:SetPrimaryPartCFrame(v.RightDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-2), 0))
			end
			wait()
		end
		running = false
	end
	opening = false
end

function closeDoors()
	for i = 1, 37 do
		for i, v in pairs(buttons) do
			v.DoorSound:Play()
		end
		for i, v in pairs(doors) do
			v.LeftDoor:SetPrimaryPartCFrame(v.LeftDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-2), 0))
			v.RightDoor:SetPrimaryPartCFrame(v.RightDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(2), 0))
		end
		wait()
	end
end

function moveChars(teleport)
	local p = teleport.Parent.Floor.Position
	local region = Region3.new(p - Vector3.new(2.2, 0, 2.2), p + Vector3.new(2.2, 7, 2.2))
	local parts = workspace:FindPartsInRegion3(region, nil, math.huge)
	local chars = {}
	
	for _, v in pairs(parts) do
		if v.Parent:FindFirstChild("Humanoid") then
			local match = false
			for i, c in pairs(chars) do
				if chars[i] == v.Parent then
					match = true
				end
			end
			if not match then
				table.insert(chars, v.Parent)
			end
		end
	end	
	
	for i = 0, 1, 0.05 do
		for _, v in pairs(chars) do
			for x, c in pairs(v:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
					c.Transparency = i
				elseif c:FindFirstChild("Handle") then
					c.Handle.Transparency = i
				end
			end
		end
		wait()
	end
	
	local newTeleport
	for i, v in pairs(teleports) do
		if v ~= teleport then
			newTeleport = v
		end
	end
	local posA = teleport.Parent.Floor.Position
	local posB = newTeleport.Parent.Floor.Position
	local offset = posB - posA
	print(offset)
	
	for _, v in pairs(chars) do
		v:TranslateBy(offset)
	end
	
	for i = 1, 0, -0.05 do
		for _, v in pairs(chars) do
			for x, c in pairs(v:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
					c.Transparency = i
				elseif c:FindFirstChild("Handle") then
					c.Handle.Transparency = i
				end
			end
		end
		wait()
	end
end

function runEffect(teleport)
	local emitters = {}
	local t = 100 -- delay timer
	local maxP = 50 -- max particles
	local n = 240 -- number of iterations for startup and cooldown
	local r = 100 -- run time at full speed
	
	for i, v in pairs(teleport:GetChildren()) do
		if v:FindFirstChild("ParticleEmitter") then
			table.insert(emitters, v)
		end
	end
	
	for i = 1, n do
		teleport:SetPrimaryPartCFrame(teleport.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(i/10), 0))
		for e = 1, 4 do
			emitters[e].Transparency = math.max((t-i)/t, 0)
			emitters[e].ParticleEmitter.Rate = math.min(i - t, maxP)
		end
		wait()
	end
	for i = 1, 100 do
		teleport:SetPrimaryPartCFrame(teleport.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(20), 0))
		wait()
		if i == 40 then
			spawn(function()
				moveChars(teleport)
			end)
		end
	end
	for i = n, 0, -1 do
		teleport:SetPrimaryPartCFrame(teleport.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(i/10), 0))
		for e = 1, 4 do
			emitters[e].Transparency = math.max(t/i, 0)
			emitters[e].ParticleEmitter.Rate = math.min(i -1 , maxP)
		end
		wait()
	end
	wait(1)
	openDoors()
end




for i, v in pairs(buttons) do -- when a player clicks on the teleport button
	v.ClickDetector.MouseClick:connect(function()
		v.ButtonSound:Play()
		v.CFrame = v.CFrame * CFrame.new(0.05, 0, 0)
		wait()
		v.CFrame = v.CFrame * CFrame.new(-0.05, 0, 0)
		if not running then
			running = true
			wait(1)
			closeDoors()
			wait(1)
			for i, v in pairs(teleports) do
				spawn(function()
					runEffect(v)
				end)
			end
		end
	end)
end

for i, v in pairs(doors) do -- set up initial door positions
	v.LeftDoor:SetPrimaryPartCFrame(v.LeftDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(74), 0))
	v.RightDoor:SetPrimaryPartCFrame(v.RightDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-74), 0))
end]]
	elseif v.Name == "DoorsScript" then
		source = [[local lDoor = script.Parent.LeftDoor
local rDoor = script.Parent.RightDoor
local button = script.Parent.Button
local closed = false

lDoor:SetPrimaryPartCFrame(lDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(74), 0))
rDoor:SetPrimaryPartCFrame(rDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-74), 0))

button.ClickDetector.MouseClick:connect(function(player)
	if closed == false then
		closed = true
		for i = 1, 37 do
			lDoor:SetPrimaryPartCFrame(lDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-2), 0))
			rDoor:SetPrimaryPartCFrame(rDoor.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(2), 0))
			wait()
		end
	end
end)]]
	elseif v.Name == "Script" and v.Parent.Name == "Fan" then
		source = [[while true do
	script.Parent.CFrame = script.Parent.CFrame * CFrame.Angles(0, math.rad(-10), 0)
	wait()
end]]
	elseif v.Name == "AffectScript" then
		source = [[local emitters = {}
local t = 100 -- delay timer
local maxP = 50 -- max particles
local n = 240 -- number of iterations for startup and cooldown
local r = 100 -- run time at full speed

for i, v in pairs(script.Parent:GetChildren()) do
	if v:FindFirstChild("ParticleEmitter") then
		table.insert(emitters, v)
	end
end

while true do
	wait(10)
	for i = 1, n do
		script.Parent:SetPrimaryPartCFrame(script.Parent.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(i/10), 0))
		for e = 1, 4 do
			emitters[e].Transparency = math.max((t-i)/t, 0)
			emitters[e].ParticleEmitter.Rate = math.min(i - t, maxP)
		end
		wait()
	end
	for i = 1, 100 do
		script.Parent:SetPrimaryPartCFrame(script.Parent.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(20), 0))
		wait()
	end
	for i = n, 0, -1 do
		script.Parent:SetPrimaryPartCFrame(script.Parent.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(i/10), 0))
		for e = 1, 4 do
			emitters[e].Transparency = math.max(t/i, 0)
			emitters[e].ParticleEmitter.Rate = math.min(i -1 , maxP)
		end
		wait()
	end
	print("done")
end
]]
	elseif v.Name == "qPerfectionWeld" then
		source = [[-- Created by Quenty (@Quenty, follow me on twitter).
-- Should work with only ONE copy, seamlessly with weapons, trains, et cetera.
-- Parts should be ANCHORED before use. It will, however, store relatives values and so when tools are reparented, it'll fix them.

--[[ INSTRUCTIONS
- Place in the model
- Make sure model is anchored
- That's it. It will weld the model and all children. 

THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 

This script is designed to be used is a regular script. In a local script it will weld, but it will not attempt to handle ancestory changes. 
]

--[[ DOCUMENTATION
- Will work in tools. If ran more than once it will not create more than one weld.  This is especially useful for tools that are dropped and then picked up again.
- Will work in PBS servers
- Will work as long as it starts out with the part anchored
- Stores the relative CFrame as a CFrame value
- Takes careful measure to reduce lag by not having a joint set off or affected by the parts offset from origin
- Utilizes a recursive algorith to find all parts in the model
- Will reweld on script reparent if the script is initially parented to a tool.
- Welds as fast as possible
]

		-- qPerfectionWeld.lua
		-- Created 10/6/2014
		-- Author: Quenty
		-- Version 1.0.3

		-- Updated 10/14/2014 - Updated to 1.0.1
		--- Bug fix with existing ROBLOX welds ? Repro by asimo3089

		-- Updated 10/14/2014 - Updated to 1.0.2
		--- Fixed bug fix. 

		-- Updated 10/14/2014 - Updated to 1.0.3
		--- Now handles joints semi-acceptably. May be rather hacky with some joints. :/

		local NEVER_BREAK_JOINTS = false -- If you set this to true it will never break joints (this can create some welding issues, but can save stuff like hinges).


		local function CallOnChildren(Instance, FunctionToCall)
			-- Calls a function on each of the children of a certain object, using recursion.  

			FunctionToCall(Instance)

			for _, Child in next, Instance:GetChildren() do
				CallOnChildren(Child, FunctionToCall)
			end
		end

		local function GetNearestParent(Instance, ClassName)
			-- Returns the nearest parent of a certain class, or returns nil

			local Ancestor = Instance
			repeat
				Ancestor = Ancestor.Parent
				if Ancestor == nil then
					return nil
				end
			until Ancestor:IsA(ClassName)

			return Ancestor
		end

		local function GetBricks(StartInstance)
			local List = {}

			-- if StartInstance:IsA("BasePart") then
			-- 	List[#List+1] = StartInstance
			-- end

			CallOnChildren(StartInstance, function(Item)
				if Item:IsA("BasePart") then
					List[#List+1] = Item;
				end
			end)

			return List
		end

		local function Modify(Instance, Values)
			-- Modifies an Instance by using a table.  

			assert(type(Values) == "table", "Values is not a table");

			for Index, Value in next, Values do
				if type(Index) == "number" then
					Value.Parent = Instance
				else
					Instance[Index] = Value
				end
			end
			return Instance
		end

		local function Make(ClassType, Properties)
			-- Using a syntax hack to create a nice way to Make new items.  

			return Modify(Instance.new(ClassType), Properties)
		end

		local Surfaces = {"TopSurface", "BottomSurface", "LeftSurface", "RightSurface", "FrontSurface", "BackSurface"}
		local HingSurfaces = {"Hinge", "Motor", "SteppingMotor"}

		local function HasWheelJoint(Part)
			for _, SurfaceName in pairs(Surfaces) do
				for _, HingSurfaceName in pairs(HingSurfaces) do
					if Part[SurfaceName].Name == HingSurfaceName then
						return true
					end
				end
			end

			return false
		end

		local function ShouldBreakJoints(Part)
			--- We do not want to break joints of wheels/hinges. This takes the utmost care to not do this. There are
			--  definitely some edge cases. 

			if NEVER_BREAK_JOINTS then
				return false
			end

			if HasWheelJoint(Part) then
				return false
			end

			local Connected = Part:GetConnectedParts()

			if #Connected == 1 then
				return false
			end

			for _, Item in pairs(Connected) do
				if HasWheelJoint(Item) then
					return false
				elseif not Item:IsDescendantOf(script.Parent) then
					return false
				end
			end

			return true
		end

		local function WeldTogether(Part0, Part1, JointType, WeldParent)
			--- Weld's 2 parts together
			-- @param Part0 The first part
			-- @param Part1 The second part (Dependent part most of the time).
			-- @param [JointType] The type of joint. Defaults to weld.
			-- @param [WeldParent] Parent of the weld, Defaults to Part0 (so GC is better).
			-- @return The weld created.

			JointType = JointType or "Weld"
			local RelativeValue = Part1:FindFirstChild("qRelativeCFrameWeldValue")

			local NewWeld = Part1:FindFirstChild("qCFrameWeldThingy") or Instance.new(JointType)
			Modify(NewWeld, {
				Name = "qCFrameWeldThingy";
				Part0  = Part0;
				Part1  = Part1;
				C0     = CFrame.new();--Part0.CFrame:inverse();
				C1     = RelativeValue and RelativeValue.Value or Part1.CFrame:toObjectSpace(Part0.CFrame); --Part1.CFrame:inverse() * Part0.CFrame;-- Part1.CFrame:inverse();
				Parent = Part1;
			})

			if not RelativeValue then
				RelativeValue = Make("CFrameValue", {
					Parent     = Part1;
					Name       = "qRelativeCFrameWeldValue";
					Archivable = true;
					Value      = NewWeld.C1;
				})
			end

			return NewWeld
		end

		local function WeldParts(Parts, MainPart, JointType, DoNotUnanchor)
			-- @param Parts The Parts to weld. Should be anchored to prevent really horrible results.
			-- @param MainPart The part to weld the model to (can be in the model).
			-- @param [JointType] The type of joint. Defaults to weld. 
			-- @parm DoNotUnanchor Boolean, if true, will not unachor the model after cmopletion.

			for _, Part in pairs(Parts) do
				if ShouldBreakJoints(Part) then
					Part:BreakJoints()
				end
			end

			for _, Part in pairs(Parts) do
				if Part ~= MainPart then
					WeldTogether(MainPart, Part, JointType, MainPart)
				end
			end

			if not DoNotUnanchor then
				for _, Part in pairs(Parts) do
					Part.Anchored = false
				end
				MainPart.Anchored = false
			end
		end

		local function PerfectionWeld()	
			local Tool = GetNearestParent(script, "Tool")

			local Parts = GetBricks(script.Parent)
			local PrimaryPart = Tool and Tool:FindFirstChild("Handle") and Tool.Handle:IsA("BasePart") and Tool.Handle or script.Parent:IsA("Model") and script.Parent.PrimaryPart or Parts[1]

			if PrimaryPart then
				WeldParts(Parts, PrimaryPart, "Weld", false)
			else
				warn("qWeld - Unable to weld part")
			end

			return Tool
		end

		local Tool = PerfectionWeld()


		if Tool and script.ClassName == "Script" then
			--- Don't bother with local scripts

			script.Parent.AncestryChanged:connect(function()
				PerfectionWeld()
			end)
		end

		-- Created by Quenty (@Quenty, follow me on twitter).
		]]
	elseif v.Name == "TimePlayedClass" then
		source = [[--[[
  TimePlayedClass, RenanMSV @2023

  A script designed to update a leaderboard with
  the top 10 players who most play your game.
  
  Do not change this script. All configurations can be found
  in the Settings script.
]

		local PlayersService = game:GetService("Players")
		local DataStoreService = game:GetService("DataStoreService")
		local RunService = game:GetService("RunService")
		local ServerStorage = game:GetService("ServerStorage")

		local Config = require(script.Parent.Settings)

		local TimePlayedClass = {}
		TimePlayedClass.__index = TimePlayedClass


		function TimePlayedClass.new()
			local new = {}
			setmetatable(new, TimePlayedClass)

			new._dataStoreName = Config.DATA_STORE
			new._dataStoreStatName = Config.NAME_OF_STAT
			new._scoreUpdateDelay = Config.SCORE_UPDATE * 60
			new._boardUpdateDelay = Config.LEADERBOARD_UPDATE * 60
			new._useLeaderstats = Config.USE_LEADERSTATS
			new._nameLeaderstats = Config.NAME_LEADERSTATS
			new._show1stPlaceAvatar = Config.SHOW_1ST_PLACE_AVATAR
			if new._show1stPlaceAvatar == nil then new._show1stPlaceAvatar = true end
			new._doDebug = Config.DO_DEBUG

			new._datastore = nil
			new._scoreBlock = script.Parent.ScoreBlock
			new._updateBoardTimer = script.Parent.UpdateBoardTimer.Timer.TextLabel

			new._apiServicesEnabled = false
			new._isMainScript = nil

			new._isDancingRigEnabled = false
			new._dancingRigModule = nil

			new._usernameCache = {}
			new._thumbnailCache = {}

			new:_init()

			return new
		end


		function TimePlayedClass:_init()

			if self._doDebug then
				warn("TopTimePlayed Board: Debugging is enabled.")
			end

			self:_checkIsMainScript()

			if self._isMainScript then
				if not self:_checkDataStoreUp() then
					self:_clearBoard()
					self._scoreBlock.NoAPIServices.Warning.Visible = true
					return
				end
			else
				self._apiServicesEnabled = (ServerStorage:WaitForChild("TopTimePlayedLeaderboard_NoAPIServices_Flag", 99) :: BoolValue).Value
				if not self._apiServicesEnabled then
					self:_clearBoard()
					self._scoreBlock.NoAPIServices.Warning.Visible = true
					return
				end
			end

			local suc, err = pcall(function ()
				self._datastore = game:GetService("DataStoreService"):GetOrderedDataStore(self._dataStoreName)
			end)
			if not suc or self._datastore == nil then warn("Failed to load OrderedDataStore. Error:", err) script.Parent:Destroy() end

			self:_checkDancingRigEnabled()

			-- puts leaderstat value in player
			if self._useLeaderstats and self._isMainScript then
				local function createLeaderstats (player)
					task.spawn(function ()
						local stat = Instance.new("NumberValue")
						stat.Name = self._nameLeaderstats
						if self._doDebug then print("Searching for the player's leaderstats folder") end
						-- creates the leaderstats folder in case it does not find one in 8 seconds
						local leaderstatsFolder = player:WaitForChild("leaderstats", 8)
						if not leaderstatsFolder then
							if self._doDebug then print("Could not find the player's leaderstats folder. Creating one.") end
							leaderstatsFolder = Instance.new("Configuration")
							leaderstatsFolder.Name = "leaderstats"
							leaderstatsFolder.Parent = player
						end
						stat.Parent = leaderstatsFolder
						-- retrieves and updates leaderstat value to the player's time saved in the datastore
						local success, resultOrError = pcall(function ()
							return self._datastore:GetAsync(self._dataStoreStatName .. player.UserId)
						end)
						stat.Value = not success and 0 or resultOrError
						if self._doDebug and not success then print("Failed to GetAsync the player's time played. Will retry later.") end
					end)
				end
				for _, player: Player in pairs(PlayersService:GetPlayers()) do
					createLeaderstats(player)
				end
				PlayersService.PlayerAdded:Connect(function (player)
					createLeaderstats(player)
				end)
			end
			-- increments players time in the datastore
			task.spawn(function ()
				if not self._isMainScript then return end
				while true do
					task.wait(self._scoreUpdateDelay)
					self:_updateScore()
				end
			end)

			-- update leaderboard
			task.spawn(function ()
				self:_updateBoard() -- update once
				local count = self._boardUpdateDelay
				while true do
					task.wait(1)
					count -= 1
					self._updateBoardTimer.Text = ("Updating the board in %d seconds"):format(count)
					if count <= 0 then
						self:_updateBoard()
						count = self._boardUpdateDelay
					end
				end
			end)

		end


		function TimePlayedClass:_clearBoard ()
			for _, folder in pairs({self._scoreBlock.Leaderboard.Names, self._scoreBlock.Leaderboard.Photos, self._scoreBlock.Leaderboard.Score}) do
				for _, item in pairs(folder:GetChildren()) do
					item.Visible = false
				end
			end
		end


		function TimePlayedClass:_updateBoard ()
			if self._doDebug then print("Updating board") end
			local results = nil

			local suc, results = pcall(function ()
				return self._datastore:GetSortedAsync(false, 10, 1):GetCurrentPage()
			end)

			if not suc or not results then
				if self._doDebug then warn("Failed to retrieve top 10 with most time. Error:", results) end
				return
			end

			local sufgui = self._scoreBlock.Leaderboard
			self._scoreBlock.Credits.Enabled = true
			self._scoreBlock.Leaderboard.Enabled = #results ~= 0
			self._scoreBlock.NoDataFound.Enabled = #results == 0
			self:_clearBoard()
			for k, v in pairs(results) do
				local userid = tonumber(string.split(v.key, self._dataStoreStatName)[2])
				local name: string, thumbnail: string
				if userid <= 0 then -- ids below 0 are given for roblox studio test players
					name = "Studio Test Profile"
					thumbnail = "rbxassetid://11569282129"
				else
					name = self:_getUsernameAsync(userid)
					thumbnail = self:_getThumbnailAsync(userid)
				end
				local score = self:_timeToString(v.value)
				self:_onPlayerScoreUpdate(userid, v.value)
				sufgui.Names["Name"..k].Visible = true
				sufgui.Score["Score"..k].Visible = true
				sufgui.Photos["Photo"..k].Visible = true
				sufgui.Names["Name"..k].Text = name
				sufgui.Score["Score"..k].Text = score
				sufgui.Photos["Photo"..k].Image = thumbnail
				if k == 1 and self._dancingRigModule then
					task.spawn(function ()
						self._dancingRigModule.SetRigHumanoidDescription(userid > 0 and userid or 1)
					end)
				end
			end
			if self._scoreBlock:FindFirstChild("_backside") then self._scoreBlock["_backside"]:Destroy() end
			local temp = self._scoreBlock.Leaderboard:Clone()
			temp.Parent = self._scoreBlock
			temp.Name = "_backside"
			temp.Face = Enum.NormalId.Back
			if self._doDebug then print("Board updated sucessfully") end
		end


		function TimePlayedClass:_updateScore ()
			local suc, err = coroutine.resume(coroutine.create(function ()
				local players = PlayersService:GetPlayers()
				for _, player in pairs(players) do
					local stat = self._dataStoreStatName .. player.UserId
					local newval = self._datastore:IncrementAsync(stat, self._scoreUpdateDelay / 60)
					if self._doDebug then print("Incremented time played stat of", player, stat, "to", newval) end
				end
			end))
			if not suc then warn(err) end
		end


		function TimePlayedClass:_onPlayerScoreUpdate (userid, minutes)
			-- updates leaderstats if enabled
			if not self._useLeaderstats then return end
			if not self._isMainScript then return end
			local player = PlayersService:GetPlayerByUserId(userid)
			if not player or not player:FindFirstChild("leaderstats") then return end
			local leaderstat = player.leaderstats[self._nameLeaderstats]
			leaderstat.Value = tonumber(minutes)
		end


		function TimePlayedClass:_checkDancingRigEnabled()
			if self._show1stPlaceAvatar then
				local rigFolder = script.Parent:FindFirstChild("First Place Avatar")
				if not rigFolder then return end
				local rig = rigFolder:FindFirstChild("Rig")
				local rigModule = rigFolder:FindFirstChild("PlayAnimationInRig")
				if not rig or not rigModule then return end
				self._dancingRigModule = require(rigModule)
				if self._dancingRigModule then
					self._isDancingRigEnabled = true
				end
			else
				local rigFolder = script.Parent:FindFirstChild("First Place Avatar")
				if not rigFolder then return end
				rigFolder:Destroy()
			end
		end


		function TimePlayedClass:_checkIsMainScript()
			local timePlayedClassRunning = ServerStorage:FindFirstChild("TopTimePlayedLeaderboard_Running_Flag")
			if timePlayedClassRunning then
				self._isMainScript = false
			else
				self._isMainScript = true
				local boolValue = Instance.new("BoolValue", ServerStorage)
				boolValue.Name = "TopTimePlayedLeaderboard_Running_Flag"
				boolValue.Value = true
			end
		end


		function TimePlayedClass:_checkDataStoreUp()
			local status, message = pcall(function()
				-- This will error if current instance has no Studio API access:
				DataStoreService:GetDataStore("____PS"):SetAsync("____PS", os.time())
			end)
			if status == false and
				(string.find(message, "404", 1, true) ~= nil or 
					string.find(message, "403", 1, true) ~= nil or -- Cannot write to DataStore from studio if API access is not enabled
					string.find(message, "must publish", 1, true) ~= nil) then -- Game must be published to access live keys
				local boolValue = Instance.new("BoolValue", ServerStorage)
				boolValue.Value = false
				boolValue.Name = "TopTimePlayedLeaderboard_NoAPIServices_Flag"
				return false
			end
			self._apiServicesEnabled = true
			local boolValue = Instance.new("BoolValue", ServerStorage)
			boolValue.Value = true
			boolValue.Name = "TopTimePlayedLeaderboard_NoAPIServices_Flag"
			return self._apiServicesEnabled
		end


		function TimePlayedClass:_getUsernameAsync(userid: number)
			if self._usernameCache[userid] then -- already cached, return
				return self._usernameCache[userid]
			end
			local success: boolean, resultOrError: string = pcall(function ()
				return PlayersService:GetNameFromUserIdAsync(userid)
			end)
			if not success then
				if self._doDebug then
					warn(("TopTimePlayed Board: Error retrieving username for userid %d. Cause: %s"):format(userid, resultOrError))
				end
				return "Name not found"
			else
				self._usernameCache[userid] = resultOrError
				return resultOrError
			end
		end


		function TimePlayedClass:_getThumbnailAsync(userid: number)
			if self._thumbnailCache[userid] then -- already cached, return
				return self._thumbnailCache[userid]
			end
			local success: boolean, resultOrError: string = pcall(function ()
				return PlayersService:GetUserThumbnailAsync(userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
			end)
			if not success then
				if self._doDebug then
					warn(("TopTimePlayed Board: Error retrieving thumbnail for userid %d. Cause: %s"):format(userid, resultOrError))
				end
				return "rbxassetid://5107154082"
			else
				self._thumbnailCache[userid] = resultOrError
				return resultOrError
			end
		end


		function TimePlayedClass:_timeToString(_time)
			_time = _time * 60
			local days = math.floor(_time / 86400)
			local hours = math.floor(math.fmod(_time, 86400) / 3600)
			local minutes = math.floor(math.fmod(_time, 3600) / 60)
			return string.format("%02dd : %02dh : %02dm",days,hours,minutes)
		end


		TimePlayedClass.new()
		]]
	elseif v.Name == "DemoMode" and v.Parent.Name == "AMECOTouch" then
		source = [[script.Parent.FanClick.ClickDetector.MouseClick:Connect(function()
	if script.Parent.Demo.Value == 0 then
		script.Parent.Demo.Value = 1
		wait(5)
		script.Parent.Demo.Value = 0
	end
end)

script.Parent.LightClick.ClickDetector.MouseClick:Connect(function()
	if script.Parent.Demo.Value == 1 then
		script.Parent.Demo.Value = 2
	end
end)

script.Parent.FanClick.ClickDetector.MouseClick:Connect(function()
	if script.Parent.Demo.Value == 2 then
		script.Parent.Demo.Value = 3
	end
end)

script.Parent.LightClick.ClickDetector.MouseClick:Connect(function()
	if script.Parent.Demo.Value == 3 then
		script.Parent.Demo.Value = 4
	end
end)

script.Parent.FanClick.ClickDetector.MouseClick:Connect(function()
	if script.Parent.Demo.Value == 4 then
		script.Parent.Demo.Value = 5
		script.Parent.Light.Value = 5
		script.Parent.Parent.Fan.Light.Material = "SmoothPlastic"
		script.Parent.Parent.Fan.Light.PointLight.Enabled = false
		script.Parent.Parent.Fan.Light.PointLight.Brightness = 0
		wait(1.6)
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.AngularVelocity = Vector3.new(0,-100,0)
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new(0,0,0)
		script.Parent.Speed.Value = 7
		wait(8)
		script.Parent.Parent.Fan.Light.Material = "Neon"
		script.Parent.Parent.Fan.Light.PointLight.Enabled = true
		script.Parent.Parent.Fan.Light.PointLight.Brightness = 1
		wait(1)
		script.Parent.Parent.Fan.Light.PointLight.Brightness = 2
		wait(1)
		script.Parent.Parent.Fan.Light.PointLight.Brightness = 3
		wait(11)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,.5,0)
		wait(1)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,1,0)
		wait(1)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,1.25,0)
		wait(5)
		script.Parent.Parent.Fan.Light.PointLight.Brightness = 2
		wait(1)
		script.Parent.Parent.Fan.Light.PointLight.Brightness = 1
		wait(7)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,1.55,0)
		wait(1)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,2,0)
		wait(1)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new (0,2.5,0)
		wait(4.8)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.AngularVelocity = Vector3.new(0,100,0)
		wait(15.6)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.AngularVelocity = Vector3.new(0,-100,0)
		wait(4.7)
		script.Parent.FanClick.beep:Play()
		script.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new(0,0,0)
		wait(4.5)
		script.Parent.Parent.Fan.Light.Material = "SmoothPlastic"
		script.Parent.Parent.Fan.Light.PointLight.Enabled = false
		script.Parent.Parent.Fan.Light.PointLight.Brightness = 0
		script.Parent.Demo.Value = 0
		script.Parent.Speed.Value = 0
		script.Parent.Light.Value = 1
	end
end)]]
	elseif v.Parent.Name == "FanClick" then
		source = [[script.Parent.ClickDetector.MouseClick:Connect(function()
	if script.Parent.Parent.Speed.Value == 0 then
		script.Parent.Parent.Speed.Value = 7
		script.Parent.beep:Play()
		script.Parent.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new(0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Speed.Value = 1
		elseif script.Parent.Parent.Speed.Value == 1 then
		script.Parent.Parent.Speed.Value = 7
		script.Parent.beep:Play()
		script.Parent.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new(0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Speed.Value = 2
		elseif script.Parent.Parent.Speed.Value == 2 then
		script.Parent.Parent.Speed.Value = 7
		script.Parent.beep:Play()
		script.Parent.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new(0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Speed.Value = 3
		elseif script.Parent.Parent.Speed.Value == 3 then
		script.Parent.Parent.Speed.Value = 7
		script.Parent.beep:Play()
		script.Parent.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new(0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Speed.Value = 4
		elseif script.Parent.Parent.Speed.Value == 4 then
		script.Parent.Parent.Speed.Value = 7
		script.Parent.beep:Play()
		script.Parent.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.MaxTorque = Vector3.new(0,2.5,0)
		wait(1.5)
		script.Parent.Parent.Speed.Value = 5
		elseif script.Parent.Parent.Speed.Value == 5 then
		script.Parent.beep:Play()
		script.Parent.Parent.Speed.Value = 6
		elseif script.Parent.Parent.Speed.Value == 6 then
		script.Parent.beep:Play()
		script.Parent.Parent.Speed.Value = 0
	end
end)]]
	elseif v.Parent.Name == "LightClick" then
		source = [[script.Parent.ClickDetector.MouseClick:Connect(function()
	if script.Parent.Parent.Light.Value == 1 then
		script.Parent.Parent.Light.Value = 2
	elseif script.Parent.Parent.Light.Value == 2 then
		script.Parent.Parent.Light.Value = 3
	elseif script.Parent.Parent.Light.Value == 3 then
		script.Parent.Parent.Light.Value = 4
	elseif script.Parent.Parent.Light.Value == 4 then
		script.Parent.Parent.Light.Value = 1
	end
end)]]
	elseif v.Parent.Name == "ReverseClick" then
		source = [[script.Parent.ClickDetector.MouseClick:connect(function()
	if script.Parent.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.AngularVelocity == Vector3.new(0,-100,0) then
		script.Parent.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.AngularVelocity = Vector3.new(0,100,0)
		script.Parent.Parent.FanClick.beep:Play()
	else
		script.Parent.Parent.Parent.Fan.Motorset.Motor.BodyAngularVelocity.AngularVelocity = Vector3.new(0,-100,0)
		script.Parent.Parent.FanClick.beep:Play()
	end
end)]]
	elseif v.Parent.Name == "Motorset" and v.Name == "Script" then
		source = [[script.Parent:MakeJoints()]]
	elseif v.Name == "WeldScript" and v.Parent.Name == "Motorset" then
		source = [[function Weld(x, y)
 local weld = Instance.new("Weld")
 weld.Part0 = x
 weld.Part1 = y
 weld.C0 = x.CFrame:inverse() * CFrame.new(x.Position)
 weld.C1 = y.CFrame:inverse() * CFrame.new(x.Position)
 weld.Parent = x
end

local prev
local unanchor = {}

function search ( n )
 n = n or script.Parent
	for i, v in pairs(n:getChildren()) do
		if v:IsA("BasePart") and not v.Name:find("Wheel") then
			if prev then
	Weld(v, prev)
	prev = v
	unanchor[#unanchor + 0] = v
	else
	prev = v
	unanchor[#unanchor + 0] = v
	   end
	  end
	search(v)
	 end
	end

function unanchormodel(m)
	local g = m:GetChildren()
	for i = 1, #g do
		if (g[i]:IsA("BasePart")) then
			g[i].Anchored = false
		elseif (g[i]:IsA("Model")) then
			unanchormodel(g[i])
		end
	end
end



search()
wait()
unanchormodel(script.Parent)
]]
	elseif v.Name == "SpeedScript" and v.Parent.Name == "Motor" then
		source = [[while true do
	if script.Parent.Parent.Parent.Parent.AMECOTouch.Speed.Value == 0 then
		script.Parent.BodyAngularVelocity.MaxTorque = Vector3.new(0,0,0)
	elseif script.Parent.Parent.Parent.Parent.AMECOTouch.Speed.Value == 1 then
		script.Parent.BodyAngularVelocity.MaxTorque = Vector3.new(0,.5,0)
	elseif script.Parent.Parent.Parent.Parent.AMECOTouch.Speed.Value == 2 then
		script.Parent.BodyAngularVelocity.MaxTorque = Vector3.new(0,1,0)
	elseif script.Parent.Parent.Parent.Parent.AMECOTouch.Speed.Value == 3 then
		script.Parent.BodyAngularVelocity.MaxTorque = Vector3.new(0,1.25,0)
	elseif script.Parent.Parent.Parent.Parent.AMECOTouch.Speed.Value == 4 then
		script.Parent.BodyAngularVelocity.MaxTorque = Vector3.new(0,1.55,0)
	elseif script.Parent.Parent.Parent.Parent.AMECOTouch.Speed.Value == 5 then
		script.Parent.BodyAngularVelocity.MaxTorque = Vector3.new(0,2,0)
	elseif script.Parent.Parent.Parent.Parent.AMECOTouch.Speed.Value == 6 then
		script.Parent.BodyAngularVelocity.MaxTorque = Vector3.new(0,2.5,0)
	end
	wait()
end]]
	elseif v.Name == "LightScript" and v.Parent.Name == "Light" then
		source = [[while true do
	if script.Parent.Parent.Parent.AMECOTouch.Light.Value == 0 then
		script.Parent.PointLight.Brightness = 0
		script.Parent.PointLight.Enabled = false
		script.Parent.Material = "SmoothPlastic"
	elseif script.Parent.Parent.Parent.AMECOTouch.Light.Value == 1 then
		script.Parent.PointLight.Brightness = 0
		script.Parent.PointLight.Enabled = false
		script.Parent.Material = "SmoothPlastic"
	elseif script.Parent.Parent.Parent.AMECOTouch.Light.Value == 2 then
		script.Parent.PointLight.Brightness = 1
		script.Parent.PointLight.Enabled = true
		script.Parent.Material = "Neon"
	elseif script.Parent.Parent.Parent.AMECOTouch.Light.Value == 3 then
		script.Parent.PointLight.Brightness = 2
		script.Parent.PointLight.Enabled = true
		script.Parent.Material = "Neon"
	elseif script.Parent.Parent.Parent.AMECOTouch.Light.Value == 4 then
		script.Parent.PointLight.Brightness = 3
		script.Parent.PointLight.Enabled = true
		script.Parent.Material = "Neon"
	end
	wait()
end]]
	elseif v.Name == "HatHelperGuideGiverScript" then
		source = [[-- Guide to how to make a hat giver.

-- To adjust where your hat will be postioned on your head, go to the script line that says "h.AttachmentPos = Vector3.new(0,0,0)
-- The first number in the (0,0,0) will make your hat go to the left, or to the right, making the number positive will make your hat be
-- placed to the left, making it negative( ex. "-1") will make it be placed to the right. If your hat is pretty semetrical, you wont have to
-- adjust the first number, it stays usually in the middle, a zero.

-- The middle number adjusts how high/low the hat will be placed on the head. The higher the number is, the lower the hat will be
-- placed. If  you are at zero, and you want the hat to go  lower, make the number a negative. Negative numbers will make the hat
-- be place higher on your robloxian head.

-- The third number determines how far ahead/back your hat will be placed. Making the number positive will place the hat ahead of 
-- you, while making the number negative will place the hat behind you some.

-- NOTE, on the first, and last numbers, the ones that make your hat go left/right/ahead/back shouldn't be changed by whole numbers
-- to make your hat giver perfect, if you have to use those two numbers, move it slowly by ".1's"
-- This can also go for the middle number. If your hat is slightly higher than its supposed to be, than edit the number slightly. 
-- Do not change the numbers by whole numbers, or else it will go really far off.  Change the numbers by ".1's" and ".2's"



-- If you want to after how many seconds can you get another hat on your head, change the line that says "wait(5)"
-- Changing this will change after how many seconds can someone touch the giver, and get a hat. It's best to leave it as it is, 
-- Changing it really doesnt matter.

-- In build mode, after every time you change this script, copy the script, delete it, and paste it back into your hat, if you don't, 
-- nothing will change, I don't know why, but this is how I make my givers.

-- If you want to change the hat that you are trying on, change the "Mesh" Just delete the one in the brick that this script is in,
-- and copy a mesh from a different hat, that you want to try on with this script.

-- Do not rename the name of the "Mesh", leave it saying Mesh, or the giver wont work.


-- Ask any questions here:  http://www.roblox.com/Forum/ShowPost.aspx?PostID=13178947


-- If you want to know how to retexture a hat, read this:  http://www.roblox.com/Forum/ShowPost.aspx?PostID=10502388








debounce = true

function onTouched(hit)
	if (hit.Parent:findFirstChild("Humanoid") ~= nil and debounce == true) then
		debounce = false
		h = Instance.new("Hat")
		p = Instance.new("Part")
		h.Name = "Hat"   -- It doesn't make a difference, but if you want to make your place in Explorer neater, change this to the name of your hat.
		p.Parent = h
		p.Position = hit.Parent:findFirstChild("Head").Position
		p.Name = "Handle" 
		p.formFactor = 0
		p.Size = Vector3.new(-0,-0,-1) 
		p.BottomSurface = 0 
		p.TopSurface = 0 
		p.Locked = true 
		script.Parent.Mesh:clone().Parent = p
		h.Parent = hit.Parent
		h.AttachmentPos = Vector3.new(0, -0.05, 0.25) -- Change these to change the positiones of your hat, as I said earlier.
		wait(5)		debounce = true
	end
end

script.Parent.Touched:connect(onTouched)

-- Script Guide by HatHelper - kukuinya]]
	elseif v.Name == "Delete if used for decoration" then
		source = [[debounce = true

function onTouched(hit)
	if (hit.Parent:findFirstChild("Humanoid") ~= nil and debounce == true) then
		debounce = false
		h = Instance.new("Hat")
		p = Instance.new("Part")
		h.Name = "Hat" 
		p.Parent = h
		p.Position = hit.Parent:findFirstChild("Head").Position
		p.Name = "Handle" 
		p.formFactor = 0
		p.Size = Vector3.new(-0,-0,-1) 
		p.BottomSurface = 0 
		p.TopSurface = 0 
		p.Locked = true 
		script.Parent.Mesh:clone().Parent = p
		h.Parent = hit.Parent
		h.AttachmentPos = Vector3.new(0, -0.05, 0.25)
		wait(5)		debounce = true
	end
end

script.Parent.Touched:connect(onTouched)
]]
	elseif v.Name == "Welcome Badge" then
		source = [[--BonBonBakery--
BadgetId = 2124489069 --put the code here

game.Players.PlayerAdded:connect(function(p)-- Do not change 
wait(.5) --How long the person stays to earn the badge
b = game:GetService("BadgeService")-- Do not change 
b:AwardBadge(p.userId,BadgetId)-- Do not change
end)-- Do not change 
-- Time badge by rickymarckstadt]]
	elseif v.Name == "CheckpointScript" then
		source = [[local spawn = script.Parent
spawn.Touched:connect(function(hit)
	if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
		local player = game.Players:GetPlayerFromCharacter(hit.Parent)
		local checkpointData = game.ServerStorage:FindFirstChild("CheckpointData")
		if not checkpointData then
			checkpointData = Instance.new("Model", game.ServerStorage)
			checkpointData.Name = "CheckpointData"
		end
		
		local checkpoint = checkpointData:FindFirstChild(tostring(player.userId))
		if not checkpoint then
			checkpoint = Instance.new("ObjectValue", checkpointData)
			checkpoint.Name = tostring(player.userId)
			
			player.CharacterAdded:connect(function(character)
				wait()
				character:WaitForChild("HumanoidRootPart").CFrame = game.ServerStorage.CheckpointData[tostring(player.userId)].Value.CFrame + Vector3.new(0, 4, 0)
			end)
		end
		
		checkpoint.Value = spawn
	end
end)]]
	elseif v.Parent.Name == "SoundBlock" then
		source = [[function onTouched(hit)
	local humanoid = hit.Parent:findFirstChild("Humanoid")
	if humanoid~=nil then
		wait(0.01)
		script.Parent.Sound:Play()
	end 
end 

script.Parent.Touched:connect(onTouched)
]]
	elseif v.Name == "Kills/Deaths" then
		source = [[local Players = game.Players

local Template = Instance.new 'BoolValue'
Template.Name = 'leaderstats'

Instance.new('IntValue', Template).Name = "Kills"
Instance.new('IntValue', Template).Name = "Deaths"


Players.PlayerAdded:connect(function(Player)
	wait(1)
	local Stats = Template:Clone()
	Stats.Parent = Player
	local Deaths = Stats.Deaths
	Player.CharacterAdded:connect(function(Character)
		Deaths.Value = Deaths.Value + 1
		local Humanoid = Character:FindFirstChild "Humanoid"
		if Humanoid then
			Humanoid.Died:connect(function()
				for i, Child in pairs(Humanoid:GetChildren()) do
					if Child:IsA('ObjectValue') and Child.Value and Child.Value:IsA('Player') then
						local Killer = Child.Value
						if Killer:FindFirstChild 'leaderstats' and Killer.leaderstats:FindFirstChild "Kills" then
							local Kills = Killer.leaderstats.Kills
							Kills.Value = Kills.Value + 1
						end
						return -- Only one player can get a KO for killing a player. Not 2, not 3. Only one.
					end
				end
			end)
		end
	end)
end)
-- Coded by JulienDethurens using gedit.]]
	elseif v.Name == "AssetLoader" and v.Parent:FindFirstChild("DeveloperProductHandler") then
		source = [[require(11370150761).Parent = script.Parent
-- Hello, User removing this script will break the board. If you need to ask something dm Yeah_Ember

--[[
	-----------[ THEMES ]-----------
  

	- LIGHT MODE:
	  If you want the light theme version of the board,
	  replace line 1 with: 
	  
	  require(11370150761).Parent = script.Parent
	
	- DARK MODE:
	  If you want the dark theme version of the board,
	  replace line 1 with: 
	  
	  require(11370294847).Parent = script.Parent

--]]
	elseif v.Name == "DeveloperProductHandler" then
		source = [[local runService = game:GetService('RunService')

if runService:IsStudio() then
	return
end

local products = require(script.Parent:WaitForChild('Products'))
local enabled = true

function GetData()
	local datastore = game:GetService("DataStoreService"):GetDataStore("BoardData")
	local data = datastore:GetAsync("Data")
	if data == nil then
		data = {ListSize = 15, Datastore = 1, Refresh = 1, Version = 2}
	end

	local tD = "TopDonators"

	if data.Datastore ~= 1 then
		tD = "TopDonators"..data.Datastore
	end

	return tD
end

function ReceiptHandler()
	warn("Donation Board: ProcessReceipt Activated")

	game:GetService("MarketplaceService").ProcessReceipt = function(receiptInfo)
		local playerProductKey = "player_" .. receiptInfo.PlayerId .. "_product_" .. receiptInfo.ProductId
		local numberBought = game:GetService("DataStoreService"):GetDataStore("PurchaseHistory"):IncrementAsync(playerProductKey, 1)
		local productBought = game:GetService("DataStoreService"):GetDataStore("PurchaseHistoryCount"):IncrementAsync(receiptInfo.ProductId, 1)
		local playerFound = false

		for i, v in pairs (game.Players:GetChildren()) do
			if v:IsA('Player') then
				if v.userId == receiptInfo.PlayerId then
					for _, p in pairs (products.Products) do
						if p.ProductId == receiptInfo.ProductId then
							if v ~= nil then
								playerFound = true
								game:GetService("DataStoreService"):GetOrderedDataStore(GetData()):IncrementAsync(receiptInfo.PlayerId, p.ProductPrice)
							end
						end
					end
				end
			end
		end

		if playerFound ~= true then
			return Enum.ProductPurchaseDecision.NotProcessedYet 
		else
			return Enum.ProductPurchaseDecision.PurchaseGranted		
		end
	end	
end

if products.AbortCustomPurchases then
	if products.AbortCustomPurchases == true then
		Enabled = false
		warn("Donation Board: Custom ProcessReceipt Enabled!")
	else
		ReceiptHandler()
	end
else
	ReceiptHandler()
end]]
	elseif v.Name == "SettingsHandler" and v.Parent:FindFirstChild("DeveloperProductHandler") then
		source = [[local runService = game:GetService('RunService')

if runService:IsStudio() then
	return
end

local products = require(script.Parent:WaitForChild("Products"))
local custom = false

if products.AbortCustomPurchases then
	if products.AbortCustomPurchases == true then
		custom = true
		warn("Donation Board: Changing the donation board datastore is disabled if AbortCustomPurchases is true!")
	end
end

local retriever = script:WaitForChild("Retriever")
local datastore = game:GetService("DataStoreService"):GetDataStore("BoardData")
local data = datastore:GetAsync("Data")

if data == nil then
	data = {ListSize = 15, Datastore = 1, Refresh = 1, Version = 2}
else
	if (not data.Version) then
		data = {ListSize = 15, Datastore = 1, Refresh = 1, Version = 2}
		datastore:SetAsync("Data",data)
	elseif (data.Version ~= 2) then
		data = {ListSize = 15, Datastore = 1, Refresh = 1, Version = 2}
		datastore:SetAsync("Data",data)		
	end
end

function getOwner()
	if game.CreatorType == Enum.CreatorType.User then
		return game.CreatorId,game.Players:GetNameFromUserIdAsync(game.CreatorId)
	else
		local owningGroupInfo = game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId)
		return owningGroupInfo.Owner.Id, owningGroupInfo.Owner.Name
	end
end

function retriever.OnServerInvoke(player,action,data)
	if action == "Authenticate" then
		local ownerId,ownerName = getOwner()
		if player.userId == ownerId then
			return true
		else 
			return false
		end
	elseif action == "GetData" then
		local data = datastore:GetAsync("Data")
		if data == nil then
			data = {ListSize = 15, Datastore = 1, Refresh = 1, Version = 2}
		end
		return data,custom
	elseif action == "SetData" then
		local ownerId,ownerName = getOwner()
		if player.userId == ownerId then		
			datastore:SetAsync("Data",data)
		end
	end
end
]]
	elseif v.Name == "Loader" and v.Parent:FindFirstChild("PlayAnimation") then
		source = [[local Model = script.Parent
local Config = Model.Configuration
local userId = Config.userId.Value

local Loader

if Config.AutoUpdateLoader.Value then
	Loader = require(10599737239)
else
	Loader = require(script.MainModule)
end


-------------------------------------------------------------------------------------

Loader:updateModel(Model, Config.userId.Value)

if Config.AutoUpdateCharacter.Value then
	while wait(Config.AutoUpdateCharacter.Delay.Value) do
		Loader:updateModel(Model, Config.userId.Value)
	end
end]]
	elseif v.Name == "AnchorScript" then
		source = [[script.Parent.Anchored = true]]
	elseif v.Parent.Name == "pName" then
		source = [[local thing = script.Parent
local uiGradient = thing:WaitForChild("UIGradient")
local tweenService = game:GetService("TweenService")

while true do
	local tween = tweenService:Create(uiGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1, 0)})
	tween:Play()
	wait(2)
	uiGradient.Offset = Vector2.new(1, 0)
	local tween2 = tweenService:Create(uiGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(0, 0)})
	tween2:Play()
	wait(2)
end
]]
	elseif v.Name == "Updater" and v.Parent.Name == "Buttons" then
		source = [[local runService = game:GetService('RunService')

local surfaceGui = script.Parent:WaitForChild('SurfaceGui')

if runService:IsStudio() then
	surfaceGui.MainFrame.ScrollingFrame.Message.Visible = true
	return
else
	surfaceGui.MainFrame.ScrollingFrame.Message:Destroy()		
end

local products = require(script.Parent.Parent:WaitForChild('Products')).Products

function updateBoard(data)
	for _,v in pairs (surfaceGui.MainFrame.ScrollingFrame:GetChildren()) do
		v:TweenPosition(UDim2.new(-1,0,0,v.Position.Y.Offset),'In','Quad',1,true)
		delay(1,function()
			v:Destroy()
		end)
	end

	local n = 0

	for k, v in pairs(data) do
		local clone = script.Frame:Clone()
		clone.Title.Text = "Donate "..v.ProductPrice.." Robux"
		clone.Id.Value = v.ProductId
		clone.Position = UDim2.new(1,0,0,(n* 20) + (n*5))
		clone.Parent = surfaceGui.MainFrame.ScrollingFrame
		clone:TweenPosition(UDim2.new(0,0,0,(n* 20) + (n*5)),'In','Quad',1,true)	
		n = n + 1		
		surfaceGui.MainFrame.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,(n * 20) + (n*5))
		wait()
	end	
end

updateBoard(products)]]
	elseif v.Name == "ScoreUpdater" then
		source = [[local runService = game:GetService('RunService')

local surfaceGui = script.Parent:WaitForChild('SurfaceGui')

if runService:IsStudio() then
	surfaceGui.MainFrame.ScrollingFrame.Message.Visible = true
	return
else
	surfaceGui.MainFrame.ScrollingFrame.Message:Destroy()
end

function GetData()
	local Datastore = game:GetService("DataStoreService"):GetDataStore("BoardData")
	local Data = Datastore:GetAsync("Data")
	if Data == nil then
		Data = {ListSize = 15, Datastore = 1, Refresh = 1, Version = 2}
	end
	
	local TD = game:GetService("DataStoreService"):GetOrderedDataStore("TopDonators")
	
	if Data.Datastore ~= 1 then
		TD = game:GetService("DataStoreService"):GetOrderedDataStore("TopDonators"..Data.Datastore)
	end
	
	return TD:GetSortedAsync(false, Data.ListSize),Data.ListSize,Data.Refresh
end

function updateBoard(board, data, num)
	surfaceGui.MainFrame.Title.Title.Title.Text = "Top "..num.." Donators"

	for _,v in pairs (script.Parent.SurfaceGui.MainFrame.ScrollingFrame:GetChildren()) do
		v:TweenPosition(UDim2.new(-1,0,0,v.Position.Y.Offset),'InOut','Quart',.5,true)
		wait()
		delay(1,function()
			v:Destroy()
		end)
	end

	local n = 0

	for k, v in pairs(data) do
		local name = v.key
		local score = v.value
		local clone = script.Frame:Clone()	
		local ln = n + 1

		spawn(function()
			pcall(function()
				clone.Number.Text = ln.."."
				clone.Title.Text = game.Players:GetNameFromUserIdAsync(name)
			end)
		end)

		clone.Explaination.Text = score
		clone.Position = UDim2.new(1,0,0,(n* 25) + (n*5))
		clone.Parent = surfaceGui.MainFrame.ScrollingFrame
		clone:TweenPosition(UDim2.new(0,0,0,(n* 25) + (n*5)),'InOut','Quart',.5,true)		
		n = n + 1
		if n == 1 then
			clone.Title.TextColor3 = Color3.new(1, 1, 0)
			clone.Number.TextColor3 = Color3.new(1, 1, 0)
			game.Workspace.Boards.R15Loader.Configuration.userId.Value = name
			game.Workspace.Boards.R15Loader.Tags.Container.pName.Text = game.Players:GetNameFromUserIdAsync(name)
		elseif n == 2 then
			clone.Title.TextColor3 = Color3.new(1, 1, 1)
			clone.Number.TextColor3 = Color3.new(1, 1, 1)
		elseif n == 3 then		
			clone.Title.TextColor3 = Color3.new(1, 0.666667, 0)
			clone.Number.TextColor3 = Color3.new(1, 0.666667, 0)

		end
		surfaceGui.MainFrame.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,(n * 25) + (n*5))
		wait()
	end	
end

while true do
	local refreshTime = 1
	pcall(function()
		local pages,num,refresh = GetData()
		local data = pages:GetCurrentPage()
		updateBoard(script.Parent, data, num)
		if refresh and typeof(refresh) == 'number' then
			refreshTime = refresh
		end
	end)
	wait(refreshTime * 60)
end]]
	elseif v.Name == "MainScript" and v.Parent.Name == "DonoBoard" then
		source = [[local leaderboardbuttons = script:WaitForChild("LeaderBoardButtons")
local firstplace = script.Parent:WaitForChild("FirstPlace")
local secondplace = script.Parent:WaitForChild("SecondPlace")
local therdplace = script.Parent:WaitForChild("ThirdPlace")
local buttons = script.Parent:WaitForChild("Buttons")
local screen = script.Parent:WaitForChild("Screen")
local infomation = script.Parent:WaitForChild("Infomation")

local datastore = game:GetService("DataStoreService")
local DSLB = datastore:GetOrderedDataStore("DonoPurchaseLB")
local productsmodule = require(script.Parent:WaitForChild("Products"))
local market = game:GetService("MarketplaceService")
local products = productsmodule.Products
local PeopleDonatedinlast1minute = {}

leaderboardbuttons.Disabled = false
leaderboardbuttons.Parent = game.StarterPlayer.StarterPlayerScripts

function Defult()
  coroutine.wrap(updatecharacter)(78217237,1)coroutine.wrap(updatecharacter)(78217237,2)coroutine.wrap(updatecharacter)(78217237,3)
  screen.SurfaceGui.MainFrame.Title.Title.Title.Text = "Top "..infomation.AmountofPlayers.Value.." Donors"
  buttons.SurfaceGui.MainFrame.Scroll.TempDono.Parent = script
  screen.SurfaceGui.MainFrame.Scroll.TempScreen.Parent = script
  for _,v in pairs(screen.SurfaceGui.MainFrame.Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
  if infomation.DoPages.Value then
    local numberofplayers = math.ceil(infomation.AmountofPlayers.Value/15)
    local numberofproducts = math.ceil(#products/4)
    for i = 1,numberofplayers do
      local temp = screen.SurfaceGui.MainFrame.Pages.ScreenPageTemp:Clone()
      temp.Parent = screen.SurfaceGui.MainFrame.Pages
      temp.Name = "P"..i
    end
    screen.SurfaceGui.MainFrame.Pages.P1.Visible = true
    screen.SurfaceGui.MainFrame.Pages.ScreenPageTemp:Destroy()
    screen.SurfaceGui.MainFrame.Scroll:Destroy()
    for i = 1,numberofproducts do
      local temp = buttons.SurfaceGui.MainFrame.Pages.ButtonPageTemp:Clone()
      temp.Parent = buttons.SurfaceGui.MainFrame.Pages
      temp.Name = "P"..i
    end
    buttons.SurfaceGui.MainFrame.Pages.ButtonPageTemp:Destroy()
    buttons.SurfaceGui.MainFrame.Scroll:Destroy()
    if #screen.SurfaceGui.MainFrame.Pages:GetChildren() == 1 then
      screen.SurfaceGui.MainFrame.Footer.PageNumbers:Destroy()
    end
    if #buttons.SurfaceGui.MainFrame.Pages:GetChildren() == 1 then
      buttons.SurfaceGui.MainFrame.Footer.PageNumbers:Destroy()
    end
  else
    buttons.SurfaceGui.MainFrame.Pages:Destroy()
    buttons.SurfaceGui.MainFrame.Footer.PageNumbers:Destroy()
    screen.SurfaceGui.MainFrame.Footer.PageNumbers:Destroy()
    screen.SurfaceGui.MainFrame.Pages:Destroy()
  end
  for place,v in pairs(products) do
    local button = script.TempDono:Clone()
    button.Text = NumberConvert(v.ProductPrice).." Robuxs"
    button.LayoutOrder = place
    button.Name = v.ProductId
    if infomation.DoPages.Value then
      button.Parent = buttons.SurfaceGui.MainFrame.Pages["P"..math.ceil(place/4)]
    else
      button.Parent = buttons.SurfaceGui.MainFrame.Scroll
    end
  end
end
function find(tab,object,Type)
  for i,v in pairs(tab) do
    if Type == "i" then
      if i == object then
        return true
      end
    elseif Type == "v" then
      if v == object then
        return true
      end
    end
  end
  return false
end
function updatecharacter(userid,number)
  local description = game.Players:GetHumanoidDescriptionFromUserId(tonumber(userid))
  local character
  local animName = "First"

  if number ==1 then
    character = firstplace
    animName = "First"
  elseif number ==2 then
    character = secondplace
    animName = "Second"
  elseif number ==3 then
    character = therdplace
    animName = "Third"
  end

  local humanoid = character:WaitForChild("Humanoid")
  local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator",humanoid)
  local animation = nil
  local playingtrack = animator:GetPlayingAnimationTracks()
  for i,track in pairs(playingtrack) do
    if track.Name == animName then
      animation = track
    end
  end
  if animation == nil then
    animation = humanoid:LoadAnimation(infomation.CharacterAnimations[animName])
  end
  animation.Looped = true
  animation:Play()

  character.Humanoid:ApplyDescription(description)
  if character:FindFirstChild("Tags") then
    character.Tags.Container.pName.Text = game.Players:GetNameFromUserIdAsync(tonumber(userid))
  end

end
function NumberConvert(num)
  local x = tostring(num)
  if #x:split("") < 7 then
    if #x>=10 then
      local important = (#x-9)
      return x:sub(0,(important))..","..x:sub(important+1,important+3)..","..x:sub(important+4,important+6)..","..x:sub(important+7)
    elseif #x>= 7 then
      local important = (#x-6)
      return x:sub(0,(important))..","..x:sub(important+1,important+3)..","..x:sub(important+4)
    elseif #x>=4 then
      return x:sub(0,(#x-3))..","..x:sub((#x-3)+1)
    else
      return num
    end
  else
    local suffixes = {"k","M","B","T","qd","Qn","sx","Sp","O","N","de","Ud","DD","tdD","qdD","QnD","sxD","SpD","OcD","NvD","Vgn","UVg","DVg","TVg","qtV","QnV","SeV","SPG","OVG","NVG"}
    local amnt = math.floor(((#x)-1)/3)
    local remove = 3*amnt
    local important = (#x-6)
    if suffixes [amnt] then
      local retuen
      if important+1 > 0 then
        retuen = x:sub(0,(important)).."."..x:sub(important+1,important+1)..suffixes[amnt]
      else
        retuen =  x:sub(0,(important))..suffixes[amnt]
      end
      return retuen
    end
  end
end
function receipt(receiptInfo)
  DSLB:IncrementAsync(receiptInfo.PlayerId,receiptInfo.CurrencySpent)
  return Enum.ProductPurchaseDecision.PurchaseGranted
end

market.ProcessReceipt = receipt Defult()

function updateboard()
  if infomation.DoPages.Value then
    for _,page in pairs(screen.SurfaceGui.MainFrame.Pages:GetChildren()) do for _,v in pairs(page:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end end
  else
    for _,v in pairs(screen.SurfaceGui.MainFrame.Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
  end

  local success, errorMessage = pcall(function()
    local Data
    if infomation.AmountofPlayers.Value < 0 then
      Data= DSLB:GetSortedAsync(false,15)
    elseif infomation.AmountofPlayers.Value > 60 then
      Data= DSLB:GetSortedAsync(false,60)
    else
      Data= DSLB:GetSortedAsync(false,infomation.AmountofPlayers.Value)
    end
    local WinPage = Data:GetCurrentPage()
    for Rank, data in ipairs(WinPage) do
      local userName = game.Players:GetNameFromUserIdAsync(data.key)
      local Name = userName
      local amount = data.value
      local isOnLeaderboard = false
      if infomation.DoPages.Value then
        for _,page in pairs(screen.SurfaceGui.MainFrame.Pages:GetChildren()) do for _,v in pairs(page:GetChildren()) do if v.Name == Name then isOnLeaderboard = true break end end end
      else
        for _,v in pairs(screen.SurfaceGui.MainFrame.Scroll:GetChildren()) do if v.Name == Name then isOnLeaderboard = true break end end
      end
      if amount > 0 and isOnLeaderboard == false  then
        if Rank <= 3 then
          coroutine.wrap(updatecharacter)(data.key,Rank)
        end
        local newLBFrame = script.TempScreen:Clone()
        newLBFrame.Title.Text = Name
        newLBFrame.Explaination.Text = coroutine.wrap(NumberConvert)(amount)
        newLBFrame.LayoutOrder = Rank
        newLBFrame.Name = Name
        newLBFrame.Visible = true
        if infomation.ShowUserThumbnail.Value then
          newLBFrame.Icon.Image = game.Players:GetUserThumbnailAsync(data.key,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
        else
          newLBFrame.Icon:Destroy()
        end
        if infomation.DoPages.Value then 
          newLBFrame.Parent = screen.SurfaceGui.MainFrame.Pages["P"..math.ceil(Rank/15)]
        else 
          newLBFrame.Parent = screen.SurfaceGui.MainFrame.Scroll
        end
        local color = nil
        if Rank == 1 then color = infomation.PlaceColors.First.Value
        elseif Rank == 2 then color = infomation.PlaceColors.Second.Value
        elseif Rank == 3 then color = infomation.PlaceColors.Third.Value
        elseif Rank <= 5 and Rank > 3  then color = infomation.PlaceColors.FouthAndFith.Value
        else color = infomation.PlaceColors.Rest.Value end

        newLBFrame.Title.BackgroundColor3 = color
        newLBFrame.Explaination.BackgroundColor3 = color
      end
    end
  end)

  if not success then
    print("TimeLB error: "..errorMessage)
  end
end

script.UpdateplayerDonoStats.OnServerEvent:Connect(function(player,product)
  market:PromptProductPurchase(player,tonumber(product))
end)
game.Players.PlayerRemoving:Connect(function(player)
  local num = 0
  if find(PeopleDonatedinlast1minute,player.UserId,"i") then
    if DSLB:GetAsync(player.UserId) then
      num = DSLB:GetAsync(player.UserId)
    end
    DSLB:SetAsync(player.UserId,PeopleDonatedinlast1minute[player.UserId] + num)
    PeopleDonatedinlast1minute[player.UserId] = 0
  end
end)

updateboard()
while wait(0) do
  for i,v in pairs(PeopleDonatedinlast1minute) do
    if v > 0 then
      if DSLB:GetAsync(i) then
        num = DSLB:GetAsync(i)
      end
      DSLB:SetAsync(i,v)
    end
  end
  table.clear(PeopleDonatedinlast1minute)
  print(PeopleDonatedinlast1minute)
  wait(1)
  updateboard()
  wait(60)
end
]]
	elseif v.Name == "Script" and v.Parent.Name == "Screen" then
		source = [[--OldestFatherEver

ProductID		= 1920901969
ProductPrice	= 10
CurrencyType	= "R$"																				-- ROBUX > "R$"     |     Tickets > "TIX"
Debounce		= true

DS				= game:GetService("DataStoreService"):GetDataStore("Places")
MS				= game:GetService("MarketplaceService")

if not DS:GetAsync(CurrencyType.."_Raised") then
DS:SetAsync(CurrencyType.."_Raised",0)
end

Raised = DS:GetAsync(CurrencyType.."_Raised")
script.Parent.SurfaceGui.Raised.ROBUX.Text = CurrencyType.." "..DS:GetAsync(CurrencyType.."_Raised")

function PrintOut(Value)
print(Value)
end

script.Parent.CD.MouseClick:connect(function(Player)
if Debounce then
if Player.userId > 0 then
print 'Player is not a Guest!'
MS:PromptProductPurchase(Player,ProductID)
end
end
end)

MS.PromptProductPurchaseFinished:connect(function(UserId,ProductId,IsPurchased)
if Debounce then
Debounce = false
if IsPurchased then
DS:IncrementAsync(CurrencyType.."_Raised",ProductPrice)
DS:OnUpdate(CurrencyType.."_Raised",PrintOut)
script.Parent.SurfaceGui.Raised.ROBUX.Text = CurrencyType.." "..DS:GetAsync(CurrencyType.."_Raised")
script.Parent.Jingle.Volume = 1
script.Parent.Purchased:play()
script.Parent.Jingle:play()
wait(7)
for i = .5,0,-.05 do
script.Parent.Jingle.Volume = i
wait()
end
script.Parent.Jingle:stop()
end
Debounce = true
end
end)

coroutine.resume(coroutine.create(function()
while wait() do
Raised = DS:GetAsync(CurrencyType.."_Raised")
script.Parent.SurfaceGui.Raised.ROBUX.Text = CurrencyType.." "..DS:GetAsync(CurrencyType.."_Raised")
end
end))]]
	elseif v.Name == "AssetLoader" and v.Parent.Name == "Boards" then
		source = [[--Do not delete this script. This is what makes the board work.
require(389325813).Parent = script.Parent
]]
	elseif v.Name == "Main" and v.Parent.Name == "Piano" then
		source = [[Settings = require(script.Parent.Settings)
Piano = script.Parent
Box = Piano.Keys.KeyBox

----------------------------------
----------------------------------
----------------------------------
---------PIANO CONNECTION---------
----------------------------------
----------------------------------
----------------------------------

----------------------------------
------------VARIABLES-------------
----------------------------------

User = nil

Connector = game.Workspace:FindFirstChild("GlobalPianoConnector")
if not Connector or not Connector:IsA("RemoteEvent") then
	error("The piano requires a RemoteEvent named GlobalPianoConnector to be in Workspace.")
end

----------------------------------
------------FUNCTIONS-------------
----------------------------------

function Receive(player, action, ...)
	local args = {...}
	if player == User and action == "play" then
		HighlightPianoKey(args[1])
		Connector:FireAllClients("play", User, args[1], Settings.SoundSource.Position, Settings.PianoSoundRange, Settings.PianoSounds)
	elseif player == User and action == "abort" then
		Deactivate()
		if SeatWeld then
			SeatWeld:remove()
		end
	end
end
function Activate(player)
	Connector:FireClient(player, "activate", Settings.CameraCFrame, Settings.PianoSounds)
	User = player
end
function Deactivate()
	Connector:FireClient(User, "deactivate")
	User = nil
end

----------------------------------
-----------CONNECTIONS------------
----------------------------------

Connector.OnServerEvent:connect(Receive)

----------------------------------
----------------------------------
----------------------------------
----------SEAT MECHANISM----------
----------------------------------
----------------------------------
----------------------------------

----------------------------------
------------VARIABLES-------------
----------------------------------

Seat = script.Parent.Bench.Seat
SeatWeld = nil


----------------------------------
------------FUNCTIONS-------------
----------------------------------

function WeldChanged(property)
	if property == "Parent" and SeatWeld.Parent == nil then
		SeatWeld = nil
		Deactivate()
		BreakSeatConnections()
	end
end
function ChildAdded(child)
	if child:IsA("Weld") then
		local root = child.Part1
		local character = root.Parent
		local player = game.Players:GetPlayerFromCharacter(character)
		if player then
			SeatWeld = child
			Activate(player)
			MakeSeatConnections()
		end
	end
end

----------------------------------
-----------CONNECTIONS------------
----------------------------------

SeatWeldConnection = nil

function MakeSeatConnections()
	SeatWeldConnection = SeatWeld.Changed:connect(WeldChanged)
end
function BreakSeatConnections()
	SeatWeldConnection:disconnect()
end

Seat.ChildAdded:connect(ChildAdded)

----------------------------------
----------------------------------
----------------------------------
------------AESTHETICS------------
----------------------------------
----------------------------------
----------------------------------

----------------------------------
------------VARIABLES-------------
----------------------------------

Keys = script.Parent.Keys

----------------------------------
------------FUNCTIONS-------------
----------------------------------

function IsBlack(note)
	if note%12 == 2 or note%12 == 4 or note%12 == 7 or note%12 == 9 or note%12 == 11 then
		return true
	end
end
function HighlightPianoKey(note1)
	if not Settings.KeyAesthetics then return end
	--print("highlight!")
	local octave = math.ceil(note1/12)
	local note2 = (note1 - 1)%12 + 1
	local key = Keys[octave][note2]
	if IsBlack(note1) then
		key.Mesh.Offset = Vector3.new(0.02, -0.15, 0)
	else
		key.Mesh.Offset = Vector3.new(0, -.05, 0)
	end
	delay(.5, function() RestorePianoKey(note1) end)
end
function RestorePianoKey(note1)
	local octave = math.ceil(note1/12)
	local note2 = (note1 - 1)%12 + 1
	local key = Keys[octave][note2]
	if IsBlack(note1) then
		key.Mesh.Offset = Vector3.new(0.02, -0.1, 0)
	else
		key.Mesh.Offset = Vector3.new(0, 0, 0)
	end
end
]]
	end
	return source
end
