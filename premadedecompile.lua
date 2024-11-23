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
	elseif v.Name == "SwingScript" and v.Parent:FindFirstChild("Hinge2") then
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
	elseif v.Name == "ChatServiceRunner" then
		source = [[--!nonstrict
--	// FileName: ChatServiceRunner.lua
--	// Written by: Xsitsu
--	// Description: Main script to initialize ChatService and run ChatModules.

local EventFolderName = "DefaultChatSystemChatEvents"
local EventFolderParent = game:GetService("ReplicatedStorage")
local modulesFolder = script

local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local Chat = game:GetService("Chat")

local ChatService = require(modulesFolder:WaitForChild("ChatService"))

local ReplicatedModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ReplicatedModules:WaitForChild("ChatSettings"))

local ChatLocalization = nil
pcall(function() ChatLocalization = require(Chat.ClientChatModules.ChatLocalization :: any) end)
ChatLocalization = ChatLocalization or {}

local MAX_CHANNEL_NAME_LENGTH = ChatSettings.MaxChannelNameCheckLength or 50
local MAX_MESSAGE_LENGTH = ChatSettings.MaximumMessageLength
local MAX_BYTES_PER_CODEPOINT = 6

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization:FormatMessageToSend(key,default) return default end
end

local MAX_BLOCKED_SPEAKERS_PER_REQ = 50

local useEvents = {}

local EventFolder = EventFolderParent:FindFirstChild(EventFolderName)
if (not EventFolder) then
	EventFolder = Instance.new("Folder")
	EventFolder.Name = EventFolderName
	EventFolder.Archivable = false
	EventFolder.Parent = EventFolderParent
end

local function validateMessageLength(msg)
    if msg:len() > MAX_MESSAGE_LENGTH*MAX_BYTES_PER_CODEPOINT then
        return false
    end

    if utf8.len(msg) == nil then
        return false
    end

    if utf8.len(utf8.nfcnormalize(msg)) > MAX_MESSAGE_LENGTH then
        return false
    end

    return true
end

local function validateChannelNameLength(channelName)
    if channelName:len() > MAX_CHANNEL_NAME_LENGTH*MAX_BYTES_PER_CODEPOINT then
        return false
    end

    if utf8.len(channelName) == nil then
        return false
    end

    if utf8.len(utf8.nfcnormalize(channelName)) > MAX_CHANNEL_NAME_LENGTH then
        return false
    end

    return true
end

--// No-opt connect Server>Client RemoteEvents to ensure they cannot be called
--// to fill the remote event queue.
local function emptyFunction()
	--intentially empty
end

local function GetObjectWithNameAndType(parentObject, objectName, objectType)
	for _, child in pairs(parentObject:GetChildren()) do
		if (child:IsA(objectType) and child.Name == objectName) then
			return child
		end
	end

	return nil
end

local function CreateIfDoesntExist(parentObject, objectName, objectType)
	local obj = GetObjectWithNameAndType(parentObject, objectName, objectType)
	if (not obj) then
		obj = Instance.new(objectType)
		obj.Name = objectName
		obj.Parent = parentObject
	end
	useEvents[objectName] = obj

	return obj
end

--// All remote events will have a no-opt OnServerEvent connecdted on construction
local function CreateEventIfItDoesntExist(parentObject, objectName)
	local obj = CreateIfDoesntExist(parentObject, objectName, "RemoteEvent")
	obj.OnServerEvent:Connect(emptyFunction)
	return obj
end

CreateEventIfItDoesntExist(EventFolder, "OnNewMessage")
CreateEventIfItDoesntExist(EventFolder, "OnMessageDoneFiltering")
CreateEventIfItDoesntExist(EventFolder, "OnNewSystemMessage")
CreateEventIfItDoesntExist(EventFolder, "OnChannelJoined")
CreateEventIfItDoesntExist(EventFolder, "OnChannelLeft")
CreateEventIfItDoesntExist(EventFolder, "OnMuted")
CreateEventIfItDoesntExist(EventFolder, "OnUnmuted")
CreateEventIfItDoesntExist(EventFolder, "OnMainChannelSet")
CreateEventIfItDoesntExist(EventFolder, "ChannelNameColorUpdated")

CreateEventIfItDoesntExist(EventFolder, "SayMessageRequest")
CreateEventIfItDoesntExist(EventFolder, "SetBlockedUserIdsRequest")
CreateIfDoesntExist(EventFolder, "GetInitDataRequest", "RemoteFunction")
CreateIfDoesntExist(EventFolder, "MutePlayerRequest", "RemoteFunction")
CreateIfDoesntExist(EventFolder, "UnMutePlayerRequest", "RemoteFunction")

EventFolder = useEvents

local function CreatePlayerSpeakerObject(playerObj)
	--// If a developer already created a speaker object with the
	--// name of a player and then a player joins and tries to
	--// take that name, we first need to remove the old speaker object
	local speaker = ChatService:GetSpeaker(playerObj.Name)
	if (speaker) then
		ChatService:RemoveSpeaker(playerObj.Name)
	end

	speaker = ChatService:InternalAddSpeakerWithPlayerObject(playerObj.Name, playerObj, false)

	for _, channel in pairs(ChatService:GetAutoJoinChannelList()) do
		speaker:JoinChannel(channel.Name)
	end

	speaker:InternalAssignEventFolder(EventFolder)

	speaker.ChannelJoined:connect(function(channel, welcomeMessage)
		local log = nil
		local channelNameColor = nil

		local channelObject = ChatService:GetChannel(channel)
		if (channelObject) then
			log = channelObject:GetHistoryLogForSpeaker(speaker)
			channelNameColor = channelObject.ChannelNameColor
		end
		EventFolder.OnChannelJoined:FireClient(playerObj, channel, welcomeMessage, log, channelNameColor)
	end)

	speaker.Muted:connect(function(channel, reason, length)
		EventFolder.OnMuted:FireClient(playerObj, channel, reason, length)
	end)

	speaker.Unmuted:connect(function(channel)
		EventFolder.OnUnmuted:FireClient(playerObj, channel)
	end)

	ChatService:InternalFireSpeakerAdded(speaker.Name)
end

EventFolder.SayMessageRequest.OnServerEvent:connect(function(playerObj, message, channel)
	if type(message) ~= "string" then
		return
	elseif not validateMessageLength(message) then
		return
	end

	if type(channel) ~= "string" then
		return
	elseif not validateChannelNameLength(channel) then
		return
	end

	local speaker = ChatService:GetSpeaker(playerObj.Name)
	if (speaker) then
		return speaker:SayMessage(message, channel)
	end

	return nil
end)

EventFolder.MutePlayerRequest.OnServerInvoke = function(playerObj, muteSpeakerName)
	if type(muteSpeakerName) ~= "string" then
		return
	end

	local speaker = ChatService:GetSpeaker(playerObj.Name)
	if speaker then
		local muteSpeaker = ChatService:GetSpeaker(muteSpeakerName)
		if muteSpeaker then
			speaker:AddMutedSpeaker(muteSpeaker.Name)
			return true
		end
	end
	return false
end

EventFolder.UnMutePlayerRequest.OnServerInvoke = function(playerObj, unmuteSpeakerName)
	if type(unmuteSpeakerName) ~= "string" then
		return
	end

	local speaker = ChatService:GetSpeaker(playerObj.Name)
	if speaker then
		local unmuteSpeaker = ChatService:GetSpeaker(unmuteSpeakerName)
		if unmuteSpeaker then
			speaker:RemoveMutedSpeaker(unmuteSpeaker.Name)
			return true
		end
	end
	return false
end

-- Map storing Player -> Blocked user Ids.
local BlockedUserIdsMap = {}

PlayersService.PlayerAdded:connect(function(newPlayer)
	for player, blockedUsers in pairs(BlockedUserIdsMap) do
		local speaker = ChatService:GetSpeaker(player.Name)
		if speaker then
			for i = 1, #blockedUsers do
				local blockedUserId = blockedUsers[i]
				if blockedUserId == newPlayer.UserId then
					speaker:AddMutedSpeaker(newPlayer.Name)
				end
			end
		end
	end
end)

PlayersService.PlayerRemoving:connect(function(removingPlayer)
	BlockedUserIdsMap[removingPlayer] = nil
end)

EventFolder.SetBlockedUserIdsRequest.OnServerEvent:Connect(function(player, blockedUserIdsList)
	if type(blockedUserIdsList) ~= "table" then
		return
	end

	local prunedBlockedUserIdsList = {}
	local speaker = ChatService:GetSpeaker(player.Name)
	if speaker then
		for i = 1, math.min(#blockedUserIdsList, MAX_BLOCKED_SPEAKERS_PER_REQ) do
			if type(blockedUserIdsList[i]) == "number" then

				table.insert(prunedBlockedUserIdsList, blockedUserIdsList[i])

				local blockedPlayer = PlayersService:GetPlayerByUserId(blockedUserIdsList[i])
				if blockedPlayer then
					speaker:AddMutedSpeaker(blockedPlayer.Name)
				end
			end
		end

		-- We only want to store the first
		-- MAX_BLOCKED_SPEAKERS_PER_REQ number of ids as needed
		BlockedUserIdsMap[player] = prunedBlockedUserIdsList
	end
end)

EventFolder.GetInitDataRequest.OnServerInvoke = (function(playerObj)
	local speaker = ChatService:GetSpeaker(playerObj.Name)
	if not (speaker and speaker:GetPlayer()) then
		CreatePlayerSpeakerObject(playerObj)
		speaker = ChatService:GetSpeaker(playerObj.Name)
	end

	local data = {}
	data.Channels = {}
	data.SpeakerExtraData = {}

	for _, channelName in pairs(speaker:GetChannelList()) do
		local channelObj = ChatService:GetChannel(channelName)
		if (channelObj) then
			local channelData =
			{
				channelName,
				channelObj:GetWelcomeMessageForSpeaker(speaker),
				channelObj:GetHistoryLogForSpeaker(speaker),
				channelObj.ChannelNameColor,
			}

			table.insert(data.Channels, channelData)
		end
	end

	for _, oSpeakerName in pairs(ChatService:GetSpeakerList()) do
		local oSpeaker = ChatService:GetSpeaker(oSpeakerName)
		data.SpeakerExtraData[oSpeakerName] = oSpeaker.ExtraData
	end

	return data
end)

local function DoJoinCommand(speakerName, channelName, fromChannelName)
	local speaker = ChatService:GetSpeaker(speakerName)
	local channel = ChatService:GetChannel(channelName)

	if (speaker) then
		if (channel) then
			if (channel.Joinable) then
				if (not speaker:IsInChannel(channel.Name)) then
					speaker:JoinChannel(channel.Name)
				else
					speaker:SetMainChannel(channel.Name)
					local msg = ChatLocalization:FormatMessageToSend(
						"GameChat_SwitchChannel_NowInChannel",
						string.format("You are now chatting in channel: '%s'", channel.Name),
						"RBX_NAME",
						channel.Name)
					speaker:SendSystemMessage(msg, channel.Name)
				end
			else
				local msg = ChatLocalization:FormatMessageToSend(
					"GameChat_ChatServiceRunner_YouCannotJoinChannel",
					"You cannot join channel '" .. channelName .. "'.",
					"RBX_NAME",
					channelName)
				speaker:SendSystemMessage(msg, fromChannelName)
			end
		else
			local msg = ChatLocalization:FormatMessageToSend(
				"GameChat_ChatServiceRunner_ChannelDoesNotExist",
				"Channel '" .. channelName .. "' does not exist.",
				"RBX_NAME",
				channelName)
			speaker:SendSystemMessage(msg, fromChannelName)
		end
	end
end

local function DoLeaveCommand(speakerName, channelName, fromChannelName)
	local speaker = ChatService:GetSpeaker(speakerName)
	local channel = ChatService:GetChannel(channelName)

	if (speaker) then
		if (speaker:IsInChannel(channelName)) then
			if (channel.Leavable) then
				speaker:LeaveChannel(channel.Name)
				local msg = ChatLocalization:FormatMessageToSend(
					"GameChat_ChatService_YouHaveLeftChannel",
					string.format("You have left channel '%s'", channelName),
					"RBX_NAME",
					channel.Name)
				speaker:SendSystemMessage(msg, "System")
			else
				local msg = ChatLocalization:FormatMessageToSend(
					"GameChat_ChatServiceRunner_YouCannotLeaveChannel",
					("You cannot leave channel '" .. channelName .. "'."),
					"RBX_NAME",
					channelName)
				speaker:SendSystemMessage(msg, fromChannelName)
			end
		else
			local msg = ChatLocalization:FormatMessageToSend(
				"GameChat_ChatServiceRunner_YouAreNotInChannel",
				("You are not in channel '" .. channelName .. "'."),
				"RBX_NAME",
				channelName)
			speaker:SendSystemMessage(msg, fromChannelName)
		end
	end
end

ChatService:RegisterProcessCommandsFunction("default_commands", function(fromSpeaker, message, channel)
	if (string.sub(message, 1, 6):lower() == "/join ") then
		DoJoinCommand(fromSpeaker, string.sub(message, 7), channel)
		return true
	elseif (string.sub(message, 1, 3):lower() == "/j ") then
		DoJoinCommand(fromSpeaker, string.sub(message, 4), channel)
		return true
	elseif (string.sub(message, 1, 7):lower() == "/leave ") then
		DoLeaveCommand(fromSpeaker, string.sub(message, 8), channel)
		return true
	elseif (string.sub(message, 1, 3):lower() == "/l ") then
		DoLeaveCommand(fromSpeaker, string.sub(message, 4), channel)
		return true
	end

	return false
end)

if ChatSettings.GeneralChannelName and ChatSettings.GeneralChannelName ~= "" then
	local allChannel = ChatService:AddChannel(ChatSettings.GeneralChannelName)

	allChannel.Leavable = false
	allChannel.AutoJoin = true

	allChannel:RegisterGetWelcomeMessageFunction(function(speaker)
		if RunService:IsStudio() then
			return nil
		end
		local player = speaker:GetPlayer()
		if player then
			local success, canChat = pcall(function()
				return Chat:CanUserChatAsync(player.UserId)
			end)
			if success and not canChat then
				return ""
			end
		end
	end)
end

local systemChannel = ChatService:AddChannel("System")
systemChannel.Leavable = false
systemChannel.AutoJoin = true
systemChannel.WelcomeMessage = ChatLocalization:FormatMessageToSend(
	"GameChat_ChatServiceRunner_SystemChannelWelcomeMessage", "This channel is for system and game notifications."
)

systemChannel.SpeakerJoined:connect(function(speakerName)
	systemChannel:MuteSpeaker(speakerName)
end)


local function TryRunModule(module)
	if module:IsA("ModuleScript") then
		local ret = require(module)
		if (type(ret) == "function") then
			ret(ChatService)
		end
	end
end

local modules = Chat:WaitForChild("ChatModules")
modules.ChildAdded:connect(function(child)
	local success, returnval = pcall(TryRunModule, child)
	if not success and returnval then
		print("Error running module " ..child.Name.. ": " ..returnval)
	end
end)

for _, module in pairs(modules:GetChildren()) do
	local success, returnval = pcall(TryRunModule, module)
	if not success and returnval then
		print("Error running module " ..module.Name.. ": " ..returnval)
	end
end

PlayersService.PlayerRemoving:connect(function(playerObj)
	if (ChatService:GetSpeaker(playerObj.Name)) then
		ChatService:RemoveSpeaker(playerObj.Name)
	end
end)
]]
	elseif v.Name == "TimePlayedScript" then
		source = [[local DATA_STORE 		= "TopTimePlayed" --< Name of the Data store values will be saved in
local SCORE_UPDATE 		= 1 --< How often you want the score to be sent to datastore in minutes (no less than 1)
local LEADERBOARD_UPDATE= 1 --< How often you want the leaderboard to update in minutes (no less than 1) 
local NAME_OF_STAT 		= "TimePlayed" --< Stat name to save in the database
local DO_DEBUG			= true --< Should it debug (print) messages to the console?

local scoreBlock = script.Parent.Model.ScoreBlock

-- gets the datastore, fails if could not find
local Database = nil
local suc, err = pcall(function ()
	Database = game:GetService("DataStoreService"):GetOrderedDataStore(DATA_STORE)
end)
if not suc or Database == nil then warn(err) script.Parent:Destroy() end

local function disp__time(_time)
	_time = _time * 60
	local days = math.floor(_time/86400)
	local hours = math.floor(math.fmod(_time, 86400)/3600)
	local minutes = math.floor(math.fmod(_time,3600)/60)
	return string.format("%02dd : %02dh : %02dm",days,hours,minutes)
end

local UpdateBoard = function ()
	if DO_DEBUG then print("Updating board") end
	local results = Database:GetSortedAsync(false, 10, 1):GetCurrentPage()
	for k, v in pairs(results) do
		local userid = tonumber(string.split(v.key, NAME_OF_STAT)[2])
		local name = game:GetService("Players"):GetNameFromUserIdAsync(userid)
		local score = disp__time(v.value)
		local sufgui = scoreBlock.SurfaceGui
		sufgui.Names["Name"..k].Text = name
		sufgui.Score["Score"..k].Text = score
		sufgui.Photos["Photo"..k].Image = game:GetService("Players"):GetUserThumbnailAsync(userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	end
	if DO_DEBUG then print("Board updated sucessfully") end
end

local suc, err = pcall(UpdateBoard) -- update once
if not suc then warn(err) end

-- increments players time in the datastore
spawn(function ()
	while wait(SCORE_UPDATE*60) do
		local suc, err = coroutine.resume(coroutine.create(function ()
			local players = game:GetService("Players"):GetPlayers()
			for _, player in pairs(players) do
				local stat = NAME_OF_STAT .. player.UserId
				local newval = Database:IncrementAsync(stat, SCORE_UPDATE)
				if DO_DEBUG then print("Incremented time played stat of", player, stat, "to", newval) end
			end
		end))
		if not suc then warn(err) end
	end
end)

-- update leaderboard
spawn(function ()
	while wait(LEADERBOARD_UPDATE*60) do
		UpdateBoard()
	end
end)


-- Green_Bromine woz here]]
	elseif v.Parent:FindFirstChild("ToolName") then
		source = [[--Rescripted by Luckymaxer
--Made by Stickmasterluke
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Sparkles = Handle:WaitForChild("Sparkles")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
WeaponHud = Tool:WaitForChild("WeaponHud")
WeaponNameTag = WeaponHud:WaitForChild("WeaponName")
GuiBar = WeaponHud:WaitForChild("Bar")
GuiBarFill = GuiBar:WaitForChild("Fill")
WeaponNameTag.Text = Tool:WaitForChild("ToolName").Value
BasePart = Instance.new("Part")
BasePart.Shape = Enum.PartType.Block
BasePart.Material = Enum.Material.Plastic
BasePart.TopSurface = Enum.SurfaceType.Smooth
BasePart.BottomSurface = Enum.SurfaceType.Smooth
BasePart.FormFactor = Enum.FormFactor.Custom
BasePart.Size = Vector3.new(0.2, 0.2, 0.2)
BasePart.CanCollide = true
BasePart.Locked = true
BasePart.Anchored = false
Animations = {
	Equip = {Animation = Tool:WaitForChild("Equip"), FadeTime = nil, Weight = nil, Speed = 1.5, Duration = nil},
	Hold = {Animation = Tool:WaitForChild("Hold"), FadeTime = nil, Weight = nil, Speed = nil, Duration = nil},
	LeftSlash = {Animation = Tool:WaitForChild("LeftSlash"), FadeTime = nil, Weight = nil, Speed = 1.2, Duration = nil},
	RightSlash = {Animation = Tool:WaitForChild("RightSlash"), FadeTime = nil, Weight = nil, Speed = 1.2, Duration = nil},
	Stab1 = {Animation = Tool:WaitForChild("Stab1"), FadeTime = nil, Weight = nil, Speed = 1.2, Duration = nil},
	Stab2 = {Animation = Tool:WaitForChild("Stab2"), FadeTime = nil, Weight = nil, Speed = 1.2, Duration = nil},
}
Sounds = {
	Swoosh1 = Handle:WaitForChild("Swoosh1"),
	Swoosh2 = Handle:WaitForChild("Swoosh2"),
	Hit1 = Handle:WaitForChild("Hit1"),
	Hit2 = Handle:WaitForChild("Hit2"),
	Hit3 = Handle:WaitForChild("Hit3"),
	Clash1 = Handle:WaitForChild("Clash1"),
	Clash2 = Handle:WaitForChild("Clash2"),
	Clash3 = Handle:WaitForChild("Clash3"),
	Clash4 = Handle:WaitForChild("Clash4"),
	Clash5 = Handle:WaitForChild("Clash5"),
}
Damage = 22 -- +/- 10%
DamageWindow = 1 --How long the player has to hit opponent to deal damage after click
SwingRate = 0.75
BloodEffects = false
Ready = false
ToolEquipped = false
Rate = (1 / 30)
LastSwing = 0
MouseDown = false
CurrentAnimation = nil
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
Tool.Enabled = true
ServerControl.OnServerInvoke = (function(player, Mode, Value)
	if player == Player then
		if Mode == "MouseClick" then
			MouseDown = Value.Down
			if MouseDown then
				Activated()
			end
		elseif Mode == "KeyPress" then
			local Key = Value.Key
			local Down = Value.Down
		end
	end
end)
function InvokeClient(Mode, Value)
	local ClientReturn = nil
	pcall(function()
		ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
	end)
	return ClientReturn
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
function Billboard(Pos, Text, Time, Color)
	local Pos = (Pos or Vector3.new(0, 0, 0))
	local Text = (Text or "Hello World!")
	local Time = (Time or 2)
	local Color = (Color or Color3.new(1, 0, 0))
	local Pos = (Pos + Vector3.new(0, 5, 0))
	local EffectPart = BasePart:Clone()
	EffectPart.Name = "Effect"
	EffectPart.Size = Vector3.new(0, 0, 0)
	EffectPart.CFrame=CFrame.new(Pos)
	EffectPart.Anchored = true
	EffectPart.CanCollide = false
	EffectPart.Transparency = 1
	local BillboardGui = Instance.new("BillboardGui")
	BillboardGui.Size = UDim2.new(3, 0, 3, 0)
	BillboardGui.Adornee = EffectPart
	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Text = Text
	TextLabel.TextColor3 = Color
	TextLabel.TextScaled = true
	TextLabel.Font = Enum.Font.ArialBold
	TextLabel.Parent = BillboardGui
	BillboardGui.Parent = EffectPart
	Debris:AddItem(EffectPart, (Time + 0.1))
	EffectPart.Parent = game:GetService("Workspace")
	Delay(0, function()
		local Frames = (Time / Rate)
		for Frame = 1, Frames do
			wait(Rate)
			local Percent = (Frame / Frames)
			EffectPart.CFrame=CFrame.new(Pos) + Vector3.new(0, (5 * Percent), 0)
			TextLabel.TextTransparency = Percent
		end
		if EffectPart and EffectPart.Parent then
			EffectPart:Destroy()
		end
	end)
end
function MakeBlood(Part)
	if not Part then
		return
	end
	local Blood = BasePart:Clone()
	Blood.BrickColor = BrickColor.new("Bright red")
	Blood.Transparency = (math.random(0, 1) * 0.5)
	Blood.CanCollide = ((math.random() < 0.5 and false) or true)
	Blood.Size = Vector3.new((0.2 * math.random(1, 5)), (0.2 * math.random(1, 5)), (0.2 * math.random(1, 5)))
	Blood.Velocity= Part.Velocity + (Vector3.new((math.random() - 0.5), (math.random() - 0.5), (math.random() - 0.5)) * 30)
	Blood.RotVelocity = Part.RotVelocity + (Vector3.new((math.random() - 0.5), (math.random() - 0.5), (math.random() - 0.5)) * 20)
	Blood.CFrame= Part.CFrame * CFrame.new(((math.random() - 0.5) * 3), ((math.random() - 0.5) * 3), ((math.random() - 0.5) * 3)) * CFrame.Angles((math.pi * 2 * math.random()), (math.pi * 2 * math.random()), (math.pi * 2 * math.random()))
	Debris:AddItem(Blood, (math.random() * 4))
	Blood.Parent = game:GetService("Workspace")
end
function Blow(Hit)
	if not Hit or not Hit.Parent or not CheckIfAlive() or not Ready or not ToolEquipped or (tick() - LastSwing) > DamageWindow then
		return
	end
	local character = Hit.Parent
	if character == Character then
		return
	end
	if Hit:FindFirstChild("CanBlock") and Handle:FindFirstChild("Blockable") then
		local Ready = false
		local PossibleSounds = {Sounds.Clash1, Sounds.Clash2, Sounds.Clash3, Sounds.Clash4, Sounds.Clash5}
		local Sound = PossibleSounds[math.random(1, #PossibleSounds)]
		Sound:Play()
		Sparkles.Enabled = true
		Delay(0.2, function()
			Sparkles.Enabled = false
		end)
		Billboard(Handle.Position, "Block", 2, Color3.new(1, 1, 0))
	end
	local humanoid = character:FindFirstChild("Humanoid")
	local player = Players:GetPlayerFromCharacter(character)
	local RightArm = Character:FindFirstChild("Right Arm")
	if humanoid and humanoid.Health > 0 and humanoid ~= Humanoid and RightArm then
		local RightGrip = RightArm:FindFirstChild("RightGrip")
		if RightGrip and (RightGrip.Part0 == Handle or RightGrip.Part1 == Handle) then
			if player and player ~= Player and not Player.Neutral and not player.Neutral and Player.TeamColor == player.TeamColor then
				return --No team killing
			end
			Ready = false
			UntagHumanoid(humanoid)
			TagHumanoid(humanoid)
			local LocalDamage= math.floor(Damage * (0.9 + (math.random() * 0.2)) + 0.5)
			humanoid:TakeDamage(LocalDamage)
			Billboard(Hit.Position, ("-" .. tostring(LocalDamage)))
			local PossibleSounds = {Sounds.Hit1, Sounds.Hit2, Sounds.Hit3}
			local Sound = PossibleSounds[math.random(1, #PossibleSounds)]
			Sound:Play()
			if BloodEffects then
				local NumBloodEffects = math.ceil(LocalDamage / 10)
				for i = 1, math.random((NumBloodEffects - 1), (NumBloodEffects + 1)) do
					MakeBlood(Hit)
				end
			end
		end
	end
end
function Activated()
	if ToolEquipped and (tick() - LastSwing) >= SwingRate then
		Tool.Enabled = false
		Ready = true
		
		local PossibleSounds = {Sounds.Swoosh1, Sounds.Swoosh2}
		local Sound = PossibleSounds[math.random(1, #PossibleSounds)]
		Sound:Play()
		
		local AttackAnimations = {Animations.LeftSlash, Animations.RightSlash, Animations.Stab1, Animations.Stab2}
		local NewAnimation = AttackAnimations[math.random(1, #AttackAnimations)]
		while NewAnimation == CurrentAnimation do
			NewAnimation = AttackAnimations[math.random(1, #AttackAnimations)]
		end
		
		CurrentAnimation = NewAnimation
		
		InvokeClient("PlayAnimation", CurrentAnimation)
		LastSwing = tick()
		wait(SwingRate)
		
		if MouseDown then
			Activated()
		end
		
		Tool.Enabled = true
	end
end
function UpdateGui()
	local SwingPercent = math.min(((tick() - LastSwing) / SwingRate), 1)
	if SwingPercent < 0.5 then	--fade from red to yellow then to green
		GuiBarFill.BackgroundColor3 = Color3.new(1, (SwingPercent * 2), 0)
	else
		GuiBarFill.BackgroundColor3 = Color3.new((1 - ((SwingPercent - 0.5 ) / 0.5)), 1, 0)
	end
	GuiBarFill.Size = UDim2.new(SwingPercent, 0, 1, 0)
end
function CheckIfAlive()
	return (Player and Player.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0)
end
function Equipped()
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	PlayerGui = Player:FindFirstChild("PlayerGui")
	Humanoid = Character:FindFirstChild("Humanoid")
	if not CheckIfAlive() then
		return
	end
	if PlayerGui then
		WeaponHud.Parent = PlayerGui
	end
	InvokeClient("PlayAnimation", Animations.Equip)
	LastSwing = tick()
	Ready = false
	ToolEquipped = true
	for i, v in pairs(Animations) do
		if v and v.Animation then
			InvokeClient("Preload", v.Animation.AnimationId)
		end
	end
	ToolEquipped = true
end
function Unequipped()
	for i, v in pairs(Animations) do
		InvokeClient("StopAnimation", v)
	end
	WeaponHud.Parent = Tool
	ToolEquipped = false
	Ready = false
end
Handle.Touched:connect(Blow)
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)
Spawn(function()
	while true do
		UpdateGui()
		wait(Rate)
	end
end)]]
	elseif v.Name == "TeddyScript" then
		source = [[local Tool = script.Parent;
enabled = true
s1 = Instance.new("Sound")
s1.SoundId = "http://www.roblox.com/asset/?id=12844799"
s1.Parent = Tool.Handle
s2 = Instance.new("Sound")
s2.SoundId = "http://www.roblox.com/asset/?id=12844794"
s2.Parent = Tool.Handle
s3 = Instance.new("Sound")
s3.SoundId = "http://www.roblox.com/asset/?id=12803520"
s3.Parent = Tool.Handle
s4 = Instance.new("Sound")
s4.SoundId = "http://www.roblox.com/asset/?id=12803507"
s4.Parent = Tool.Handle
s5 = Instance.new("Sound")
s5.SoundId = "http://www.roblox.com/asset/?id=12803498"
s5.Parent = Tool.Handle
local sayings = {s1,s2,s3,s4,s5}
function onActivated()
	if not enabled  then
		return
	end
	enabled = false
	
	Tool.GripForward = Vector3.new(1,0,0)
	Tool.GripPos = Vector3.new(.5,-1.5,-1.56)
	Tool.GripRight = Vector3.new(0,-.707,-.707)
	Tool.GripUp = Vector3.new(0,-.707,.707)
	sayings[math.random(1,#sayings)]:Play()
	wait(2)
	Tool.GripForward = Vector3.new(-1,0,0)
	Tool.GripPos = Vector3.new(0,0,-.4)
	Tool.GripRight = Vector3.new(0,1,0)
	Tool.GripUp = Vector3.new(0,0,1)
	
	enabled = true
end
function onEquipped()
	for i=1,#sayings do
		sayings[i].Volume = 1
	end
end
function onUnequipped()
	for i=1,#sayings do
		sayings[i].Volume = 0
	end
end
script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)
script.Parent.Unequipped:connect(onUnequipped)]]
	elseif v.Name == "HealingPotionScript" then
		source = [[--Updated for R15 avatar by StarWars
local Tool = script.Parent;
local GlassBreak = Instance.new("Sound")
GlassBreak.Name = "GlassBreak"
GlassBreak.SoundId = "http://www.roblox.com/asset/?id=11415738"
GlassBreak.Volume = 1
GlassBreak.Parent = Tool.Handle
local DrinkSound = Instance.new("Sound")
DrinkSound.Name = "Drink"
DrinkSound.SoundId = "http://www.roblox.com/asset/?id=10722059"
DrinkSound.Volume = .5
DrinkSound.Parent = Tool.Handle
function onActivated()
	if not Tool.Enabled  then
		return
	end
	Tool.Enabled = false
	Tool.GripForward = Vector3.new(0,-.759,-.651)
	Tool.GripPos = Vector3.new(1.5,-.35,.1)
	Tool.GripRight = Vector3.new(1,0,0)
	Tool.GripUp = Vector3.new(0,.651,-.759)
	DrinkSound:Play()
	DrinkSound:Destroy()
	wait(3)
	
	local h = Tool.Parent:FindFirstChild("Humanoid")
	if (h ~= nil) then
		h.Health = h.MaxHealth
	else
		return
	end
	Tool.GripForward = Vector3.new(-.976,0,-0.217)
	Tool.GripPos = Vector3.new(0.1,0,.1)
	Tool.GripRight = Vector3.new(.217,0,-.976)
	Tool.GripUp = Vector3.new(0,1,0)
	wait(1)
	local p = Tool.Handle:Clone()
	GlassBreak.Parent = p
	p.Transparency = 0
	local Torso = Tool.Parent:FindFirstChild("Torso") or Tool.Parent:FindFirstChild("RightUpperArm")
	
	if Torso then
		local RightArm = Torso:FindFirstChild("Right Shoulder") or Torso:FindFirstChild("RightShoulder")
		if RightArm then
			RightArm.MaxVelocity = 0.7
			RightArm.DesiredAngle = 3.6
			wait(.1)
			RightArm.MaxVelocity = 1
		end
	end
	local dir = h.Parent.Head.CFrame.lookVector
	p.Velocity = (dir * 60) + Vector3.new(0,30,0)
	p.CanCollide = true
	Tool.Glass.Parent = p
	p.Glass.Disabled = false
	p.Parent = game.Workspace
	script.Parent:Destroy()
end
function onEquipped()
	--Tool.Handle.OpenSound:play()
end
script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)]]
	elseif v.Name == "Glass" and v.Parent:FindFirstChild("HealingPotionScript") then
		source = [[function Touched(part)
	script.Parent.GlassBreak:Play()
	con:disconnect()
end
con = script.Parent.Touched:connect(Touched)
wait(30)
script.Parent:Destroy()]]
	elseif v:FindFirstChild("RemovalMonitor") then
		source = [[--Made by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
RemovalMonitor = script:WaitForChild("RemovalMonitor")
CarpetPieces = {
	{MeshId = 223079795, Angle = 160},
	{MeshId = 223079835, Angle = 100},
	{MeshId = 223079888, Angle = 100},
	{MeshId = 223079981, Angle = 160},
}
CarpetSize = Vector3.new(3, 0.5, 6.5)
BaseUrl = "http://www.roblox.com/asset/?id="
Rate = (1 / 10)
BasePart = Instance.new("Part")
BasePart.Material = Enum.Material.Plastic
BasePart.Shape = Enum.PartType.Block
BasePart.TopSurface = Enum.SurfaceType.Smooth
BasePart.BottomSurface = Enum.SurfaceType.Smooth
BasePart.FormFactor = Enum.FormFactor.Custom
BasePart.Size = Vector3.new(0.2, 0.2, 0.2)
BasePart.CanCollide = false
BasePart.Locked = true
ColorPart = BasePart:Clone()
ColorPart.Name = "ColorPart"
ColorPart.Reflectance = 0.25
ColorPart.Transparency = 0.1
ColorPart.Material = Enum.Material.SmoothPlastic
ColorPart.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
ColorPart.BackSurface = Enum.SurfaceType.SmoothNoOutlines
ColorPart.TopSurface = Enum.SurfaceType.SmoothNoOutlines
ColorPart.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
ColorPart.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
ColorPart.RightSurface = Enum.SurfaceType.SmoothNoOutlines
ColorPart.Size = Vector3.new(1, 1, 1)
ColorPart.Anchored = true
ColorPart.CanCollide = false
ColorMesh = Instance.new("SpecialMesh")
ColorMesh.Name = "Mesh"
ColorMesh.MeshType = Enum.MeshType.FileMesh
ColorMesh.MeshId = (BaseUrl .. "9856898")
ColorMesh.TextureId = (BaseUrl .. "1361097")
ColorMesh.Scale = (ColorPart.Size * 2) --Default mesh scale is 1/2 the size of a 1x1x1 brick.
ColorMesh.Offset = Vector3.new(0, 0, 0)
ColorMesh.VertexColor = Vector3.new(1, 1, 1)
ColorMesh.Parent = ColorPart
ColorLight = Instance.new("PointLight")
ColorLight.Name = "Light"
ColorLight.Brightness = 50
ColorLight.Range = 8
ColorLight.Shadows = false
ColorLight.Enabled = true
ColorLight.Parent = ColorPart
RainbowColors = {
	Vector3.new(1, 0, 0),
	Vector3.new(1, 0.5, 0),
	Vector3.new(1, 1, 0),
	Vector3.new(0, 1, 0),
	Vector3.new(0, 1, 1),
	Vector3.new(0, 0, 1),
	Vector3.new(0.5, 0, 1)
}
Animations = {
	Sit = {Animation = Tool:WaitForChild("Sit"), FadeTime = nil, Weight = nil, Speed = nil, Duration = nil},
}
Grips = {
	Normal = CFrame.new(-1.5, 0, 0, 0, 0, -1, -1, 8.90154915e-005, 0, 8.90154915e-005, 1, 0),
	Flying = CFrame.new(-1.5, 0.5, -0.75, -1, 0, -8.99756625e-009, -8.99756625e-009, 8.10000031e-008, 1, 7.28802977e-016, 0.99999994, -8.10000103e-008)
}
Flying = false
ToolEquipped = false
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
Handle.Transparency = 0
Tool.Grip = Grips.Normal
Tool.Enabled = true
function Clamp(Number, Min, Max)
	return math.max(math.min(Max, Number), Min)
end
function TransformModel(Objects, Center, NewCFrame, Recurse)
	local Objects = ((type(Objects) ~= "table" and {Objects}) or Objects)
	for i, v in pairs(Objects) do
		if v:IsA("BasePart") then
			v.CFrame = NewCFrame:toWorldSpace(Center:toObjectSpace(v.CFrame))
		end
		if Recurse then
			TransformModel(v:GetChildren(), Center, NewCFrame, true)
		end
	end
end
function Weld(Parent, PrimaryPart)
	local Parts = {}
	local Welds = {}
	local function WeldModel(Parent, PrimaryPart)
		for i, v in pairs(Parent:GetChildren()) do
			if v:IsA("BasePart") then
				if v ~= PrimaryPart then
					local Weld = Instance.new("Weld")
					Weld.Name = "Weld"
					Weld.Part0 = PrimaryPart
					Weld.Part1 = v
					Weld.C0 = PrimaryPart.CFrame:inverse()
					Weld.C1 = v.CFrame:inverse()
					Weld.Parent = PrimaryPart
					table.insert(Welds, Weld)
				end
				table.insert(Parts, v)
			end
			WeldModel(v, PrimaryPart)
		end
	end
	WeldModel(Parent, PrimaryPart)
	return Parts, Welds
end
function CleanUp()
	for i, v in pairs(Tool:GetChildren()) do
		if v:IsA("BasePart") and v ~= Handle then
			v:Destroy()
		end
	end
end
function CreateRainbow(Length)
	local RainbowModel = Instance.new("Model")
	RainbowModel.Name = "RainbowPart"
	for i, v in pairs(RainbowColors) do
		local Part = ColorPart:Clone()
		Part.Name = "Part"
		Part.Size = Vector3.new(0.5, 0.5, Length)
		Part.CFrame = Part.CFrame * CFrame.new((Part.Size.X * (i - 1)), 0, 0)
		Part.Mesh.Scale = (Part.Size * 2)
		Part.Mesh.VertexColor = v
		Part.Light.Color = Color3.new(v.X, v.Y, v.Z)
		Part.Parent = RainbowModel
	end
	local RainbowBoundingBox = BasePart:Clone()
	RainbowBoundingBox.Name = "BoundingBox"
	RainbowBoundingBox.Transparency = 1
	RainbowBoundingBox.Size = RainbowModel:GetModelSize()
	RainbowBoundingBox.Anchored = true
	RainbowBoundingBox.CanCollide = false
	RainbowBoundingBox.CFrame = RainbowModel:GetModelCFrame()
	RainbowBoundingBox.Parent = RainbowModel
	return RainbowModel
end
function GetRainbowModel()
	local ModelName = (Player.Name .. "'s Rainbow")
	local Model = game:GetService("Workspace"):FindFirstChild(ModelName)
	if not Model then
		Model = Instance.new("Model")
		Model.Name = ModelName
		local RemovalMonitorClone = RemovalMonitor:Clone()
		RemovalMonitorClone.Disabled = false
		RemovalMonitorClone.Parent = Model
	end
	return Model
end
function CheckIfAlive()
	return (((Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent and Player and Player.Parent) and true) or false)
end
function Activated()
	if not Tool.Enabled then
		return
	end
	Tool.Enabled = false
	Flying = not Flying
	if Flying then
		Handle.Transparency = 1
		CleanUp()
		local CarpetParts = {}
		for i, v in pairs(CarpetPieces) do
			local CarpetPart = BasePart:Clone()
			CarpetPart.CanCollide = false
			CarpetPart.Size = Vector3.new(CarpetSize.X, CarpetSize.Y, (CarpetSize.Z / #CarpetPieces))
			local Mesh = Instance.new("SpecialMesh")
			Mesh.MeshType = Enum.MeshType.FileMesh
			Mesh.MeshId = (BaseUrl .. v.MeshId)
			Mesh.TextureId = (BaseUrl .. "223080038")
			Mesh.Scale = Vector3.new(1.125, 1.125, 1.125)
			Mesh.VertexColor = Vector3.new(1, 1, 1)
			Mesh.Offset = Vector3.new(0, 0, 0)
			Mesh.Parent = CarpetPart
			local Weld = Instance.new("Weld")
			Weld.Part0 = Handle
			Weld.Part1 = CarpetPart
			local XOffset = (((i == 1 or i == #CarpetPieces) and -0.005) or 0)
			local YOffset = ((-((Handle.Size.Z / 2) - (CarpetPart.Size.Z / 2))) + ((CarpetPart.Size.Z * (i - 1))) + ((i == 2 and 0.245) or (i == 3 and 0.04) or (i == #CarpetPieces and 0.28) or 0))
			Weld.C1 = CFrame.new(0, XOffset, YOffset)
			Weld.Parent = CarpetPart
			table.insert(CarpetParts, {Part = CarpetPart, Weld = Weld, InitialCFrame = Weld.C0, Angle = v.Angle})
			CarpetPart.Parent = Tool
		end	
		
		spawn(function()
			InvokeClient("PlayAnimation", Animations.Sit)
			Tool.Grip = Grips.Flying
		end)
		Torso.Anchored = true
		delay(.2,function()
			Torso.Anchored = false
			Torso.Velocity = Vector3.new(0,0,0)
			Torso.RotVelocity = Vector3.new(0,0,0)
		end)
		
		FlightSpin = Instance.new("BodyGyro")
		FlightSpin.Name = "FlightSpin"
		FlightSpin.P = 10000
		FlightSpin.maxTorque = Vector3.new(FlightSpin.P, FlightSpin.P, FlightSpin.P)*100
		FlightSpin.cframe = Torso.CFrame
		
		FlightPower = Instance.new("BodyVelocity")
		FlightPower.Name = "FlightPower"
		FlightPower.velocity = Vector3.new(0, 0, 0)
		FlightPower.maxForce = Vector3.new(0, 0, 0)	--Vector3.new(1,1,1)*1000000
		FlightPower.P = 1000
		
		FlightHold = Instance.new("BodyPosition")
		FlightHold.Name = "FlightHold"
		FlightHold.P = 100000
		FlightHold.maxForce = Vector3.new(0, 0, 0)
		FlightHold.position = Torso.Position
		
		FlightSpin.Parent = Torso
		FlightPower.Parent = Torso
		FlightHold.Parent = Torso
		
		spawn(function()
			local LastPlace = nil
			while Flying and ToolEquipped and CheckIfAlive() do
				
				local CurrentPlace = Handle.Position
				local Velocity = Torso.Velocity
				Velocity = Vector3.new(Velocity.X, 0, Velocity.Z).magnitude
				
				if LastPlace and Velocity > 10 then
					
					spawn(function()
						local Model = GetRainbowModel()
						local Distance = (LastPlace - CurrentPlace).magnitude
						local Length = Distance + 3.5
						
						local RainbowModel = CreateRainbow(Length)
						
						--Thanks so much to ArceusInator for helping solve this part!
						local RainbowCFrame = CFrame.new((LastPlace + (CurrentPlace - LastPlace).unit * (Distance / 2)), CurrentPlace)
						
						TransformModel(RainbowModel, RainbowModel:GetModelCFrame(), RainbowCFrame, true)
						Debris:AddItem(RainbowModel, 1)
						RainbowModel.Parent = Model
						
						if Model and not Model.Parent then
							Model.Parent = game:GetService("Workspace")
						end
						
						LastPlace = CurrentPlace
					end)
				elseif not LastPlace then
					LastPlace = CurrentPlace
				end
				
				wait(Rate)
			end
		end)
	elseif not Flying then
		Torso.Velocity = Vector3.new(0, 0, 0)
		Torso.RotVelocity = Vector3.new(0, 0, 0)
		
		for i, v in pairs({FlightSpin, FlightPower, FlightHold}) do
			if v and v.Parent then
				v:Destroy()
			end
		end
		spawn(function()
			Tool.Grip = Grips.Normal
			InvokeClient("StopAnimation", Animations.Sit)
		end)
	end
	
	wait(2)
	
	Tool.Enabled = true
end
function Equipped(Mouse)
	Character = Tool.Parent
	Humanoid = Character:FindFirstChild("Humanoid")
	Torso = Character:FindFirstChild("HumanoidRootPart")
	Player = Players:GetPlayerFromCharacter(Character)
	if not CheckIfAlive() then
		return
	end
	if Humanoid then
		if Humanoid.RigType == Enum.HumanoidRigType.R15 then
			Animations = {
				Sit = {Animation = Tool:WaitForChild("SitR15"), FadeTime = nil, Weight = nil, Speed = nil, Duration = nil},
			}
		else
			Animations = {
				Sit = {Animation = Tool:WaitForChild("Sit"), FadeTime = nil, Weight = nil, Speed = nil, Duration = nil},
			}
		end
	end
	Tool.Grip = Grips.Normal
	ToolEquipped = true
end
function Unequipped()
	Flying = false
	for i, v in pairs({FlightSpin, FlightPower, FlightHold}) do
		if v and v.Parent then
			v:Destroy()
		end
	end
	CleanUp()
	Handle.Transparency = 0
	ToolEquipped = false
end
function OnServerInvoke(player, mode, value)
	if player ~= Player or not ToolEquipped or not value or not CheckIfAlive() then
		return
	end
end
function InvokeClient(Mode, Value)
	local ClientReturn = nil
	pcall(function()
		ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
	end)
	return ClientReturn
end
CleanUp()
ServerControl.OnServerInvoke = OnServerInvoke
Tool.Activated:connect(Activated)
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "RemovalMonitor" then
		source = [[--Made by Luckymaxer
Model = script.Parent
Debris = game:GetService("Debris")
Removing = false
function RemoveModel()
	if Removing then
		return
	end
	local Parts = {}
	for i, v in pairs(Model:GetChildren()) do
		if v:IsA("Model") then
			table.insert(Parts, v)
		end
	end
	if #Parts == 0 then
		Removing = true
		Model.Name = ""
		Debris:AddItem(Model, 1)
	end
end
Model.ChildRemoved:connect(function(Child)
	RemoveModel()
end)
RemoveModel()]]
	elseif v.Name == "Script" and v:FindFirstChild("Handle"):FindFirstChild("CoilSound") then
		source = [[--Rescripted by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Sounds = {
	CoilSound = Handle:WaitForChild("CoilSound"),
}
Gravity = 196.20
JumpHeightPercentage = 0.25
ToolEquipped = false
function GetAllConnectedParts(Object)
	local Parts = {}
	local function GetConnectedParts(Object)
		for i, v in pairs(Object:GetConnectedParts()) do
			local Ignore = false
			for ii, vv in pairs(Parts) do
				if v == vv then
					Ignore = true
				end
			end
			if not Ignore then
				table.insert(Parts, v)
				GetConnectedParts(v)
			end
		end
	end
	GetConnectedParts(Object)
	return Parts
end
function SetGravityEffect()
	if not GravityEffect or not GravityEffect.Parent then
		GravityEffect = Instance.new("BodyForce")
		GravityEffect.Name = "GravityCoilEffect"
		GravityEffect.Parent = Torso
	end
	local TotalMass = 0
	local ConnectedParts = GetAllConnectedParts(Torso)
	for i, v in pairs(ConnectedParts) do
		if v:IsA("BasePart") then
			TotalMass = (TotalMass + v:GetMass())
		end
	end
	local TotalMass = (TotalMass * 196.20 * (1 - JumpHeightPercentage))
	GravityEffect.force = Vector3.new(0, TotalMass, 0)
end
function HandleGravityEffect(Enabled)
	if not CheckIfAlive() then
		return
	end
	for i, v in pairs(Torso:GetChildren()) do
		if v:IsA("BodyForce") then
			v:Destroy()
		end
	end
	for i, v in pairs({ToolUnequipped, DescendantAdded, DescendantRemoving}) do
		if v then
			v:disconnect()
		end
	end
	if Enabled then
		CurrentlyEquipped = true
		ToolUnequipped = Tool.Unequipped:connect(function()
			CurrentlyEquipped = false
		end)
		SetGravityEffect()
		DescendantAdded = Character.DescendantAdded:connect(function()
			wait()
			if not CurrentlyEquipped or not CheckIfAlive() then
				return
			end
			SetGravityEffect()
		end)
		DescendantRemoving = Character.DescendantRemoving:connect(function()
			wait()
			if not CurrentlyEquipped or not CheckIfAlive() then
				return
			end
			SetGravityEffect()
		end)
	end
end
function CheckIfAlive()
	return (((Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent and Player and Player.Parent) and true) or false)
end
function Equipped(Mouse)
	Character = Tool.Parent
	Humanoid = Character:FindFirstChild("Humanoid")
	Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
	Player = Players:GetPlayerFromCharacter(Character)
	if not CheckIfAlive() then
		return
	end
	if HumanoidDied then
		HumanoidDied:disconnect()
	end
	HumanoidDied = Humanoid.Died:connect(function()
		if GravityEffect and GravityEffect.Parent then
			GravityEffect:Destroy()
		end
	end)
	Sounds.CoilSound:Play()
	HandleGravityEffect(true)
	ToolEquipped = true
end
function Unequipped()
	if HumanoidDied then
		HumanoidDied:disconnect()
	end
	HandleGravityEffect(false)
	ToolEquipped = false
end
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Parent:FindFirstChild("SwapWith") then
		source = [[local Tool = script.Parent
Tool.Enabled = true
local Players = game:GetService'Players'
function BuildCharacterRig(Character, AppearanceModel, IsR15)
	local Humanoid,FF = Character:FindFirstChildOfClass("Humanoid"),Character:FindFirstChildOfClass("ForceField")
	if not Humanoid and Humanoid.Health > 0 or FF then return end 	
	local AnimateScript = Character:FindFirstChild("Animate")
	if not AnimateScript then return end 
	
	for _, Object in next, Character:GetChildren() do
		if Object:IsA("Accessory") then
			Object:Destroy()
		elseif Object.Name == "Head" then
			local Face = Object:FindFirstChild("face")
			if Face then
				Face.Texture = "rbxasset://textures/face.png"
			end
		elseif Object:IsA("Shirt") or Object:IsA("Pants") or Object:IsA("ShirtGraphic") or Object:IsA("BodyColors") then
			Object:Destroy()
		end
	end
	
	if IsR15 then		
		for _, Object in next, AppearanceModel:GetChildren() do
			if Object.Name == "R15" and Object:IsA("Folder") then
				for _, Part in next, Object:GetChildren() do
					if Part:IsA("BasePart") then
						local HasLimb = Character:FindFirstChild(Part.Name)
						if HasLimb then
							HasLimb:Destroy()
						end
						Part.Parent = Character
						Humanoid:BuildRigFromAttachments()
					end
				end
			elseif Object.Name == "R15Anim" and Object:IsA("Folder") then
				for _, AnimationObject in next, Object:GetChildren() do
					local HasAnimObject = AnimateScript:FindFirstChild(AnimationObject.Name)
					if HasAnimObject then
						HasAnimObject:Destroy()
					end
					
					AnimationObject.Parent = AnimateScript
				end
			elseif Object:IsA("Accessory") then
				Humanoid:AddAccessory(Object)
			elseif Object:IsA("Pants") or Object:IsA("Shirt") or Object:IsA("ShirtGraphic") or Object:IsA("BodyColors") then
				Object.Parent = Character
			elseif Object.Name == "face" then
				local Head = Character:FindFirstChild("Head")
				if Head then
					local Face = Head:FindFirstChild("face")
					if Face then
						Face.Texture = Object.Texture
					else
						Object.Parent = Head
					end
				end
			elseif Object.Name == "BodyDepthScale" or Object.Name == "BodyHeightScale" or Object.Name == "BodyWidthScale" or Object.Name == "HeadScale" then
				local ValueObject = Humanoid:FindFirstChild(Object.Name)
				if ValueObject then
					ValueObject.Value = Object.Value
				else
					Object.Parent = Humanoid
				end
			end
		end				
	else
		for _, Object in next, AppearanceModel:GetChildren() do
			if Object:IsA("Accessory") then
				Humanoid:AddAccessory(Object)
			elseif Object:IsA("Pants") or Object:IsA("Shirt") or Object:IsA("ShirtGraphic") or Object:IsA("BodyColors") then
				Object.Parent = Character
			elseif Object.Name == "face" then
				Object.Parent = Character:FindFirstChild("Head")				
			end
		end
	end
end
Tool.SwapWith.OnServerEvent:Connect(function(client, character)
	if client == Players:GetPlayerFromCharacter(Tool.Parent) and client.Character and Tool.Enabled then
		local otherPlayer = Players:GetPlayerFromCharacter(character)
		if not otherPlayer then return end -- Remove to make it work with NPCs
		
		local clienttorso,targettorso = client.Character:FindFirstChild("Torso") or client.Character:FindFirstChild("UpperTorso"),character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
		if not clienttorso or not targettorso or (targettorso.Position-clienttorso.Position).Magnitude > 50 then return end
		
		local ClientCharacterAppearance = Players:GetCharacterAppearanceAsync(client.UserId)		
		local OtherCharacterAppearance = Players:GetCharacterAppearanceAsync(otherPlayer.UserId)
		
		
		local ClientHumanoid = client.Character:FindFirstChildOfClass("Humanoid")
		local OtherHumanoid = character:FindFirstChildOfClass("Humanoid")
		if ClientHumanoid and OtherHumanoid then
			BuildCharacterRig(client.Character, OtherCharacterAppearance, ClientHumanoid.RigType == Enum.HumanoidRigType.R15)
			BuildCharacterRig(character, ClientCharacterAppearance, OtherHumanoid.RigType == Enum.HumanoidRigType.R15)
		end
		
		ClientCharacterAppearance:Destroy()
		OtherCharacterAppearance:Destroy()
		if otherPlayer and client.Character:FindFirstChild'HumanoidRootPart' and character:FindFirstChild'HumanoidRootPart' and client.Character.HumanoidRootPart.Anchored == false and character.HumanoidRootPart.Anchored == false then
			local posA, posB = client.Character.HumanoidRootPart.CFrame, character.HumanoidRootPart.CFrame
			client.Character.HumanoidRootPart.CFrame = posB
			character.HumanoidRootPart.CFrame = posA
		end
		Tool.Enabled = false
		delay(5,function()
			Tool.Enabled = true
		end)
	end 
end)]]
	elseif v.Parent:FindFirstChild("HitFade") then
		source = [[--Rescripted by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
Speed = 100
Duration = 1
NozzleOffset = Vector3.new(0, 0.4, -1.1)
Sounds = {
	Fire = Handle:WaitForChild("Fire"),
	Reload = Handle:WaitForChild("Reload"),
	HitFade = Handle:WaitForChild("HitFade")
}
PointLight = Handle:WaitForChild("PointLight")
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
ServerControl.OnServerInvoke = (function(player, Mode, Value, arg)
	if player ~= Player or Humanoid.Health == 0 or not Tool.Enabled then
		return
	end
	if Mode == "Click" and Value then
		Activated(arg)
	end
end)
function InvokeClient(Mode, Value)
	pcall(function()
		ClientControl:InvokeClient(Player, Mode, Value)
	end)
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
function FindCharacterAncestor(Parent)
	if Parent and Parent ~= game:GetService("Workspace") then
		local humanoid = Parent:FindFirstChild("Humanoid")
		if humanoid then
			return Parent, humanoid
		else
			return FindCharacterAncestor(Parent.Parent)
		end
	end
	return nil
end
function GetTransparentsRecursive(Parent, PartsTable)
	local PartsTable = (PartsTable or {})
	for i, v in pairs(Parent:GetChildren()) do
		local TransparencyExists = false
		pcall(function()
			local Transparency = v["Transparency"]
			if Transparency then
				TransparencyExists = true
			end
		end)
		if TransparencyExists then
			table.insert(PartsTable, v)
		end
		GetTransparentsRecursive(v, PartsTable)
	end
	return PartsTable
end
function SelectionBoxify(Object)
	local SelectionBox = Instance.new("SelectionBox")
	SelectionBox.Adornee = Object
	SelectionBox.Color = BrickColor.new("Really red")
	SelectionBox.Parent = Object
	return SelectionBox
end
local function Light(Object)
	local Light = PointLight:Clone()
	Light.Range = (Light.Range + 2)
	Light.Parent = Object
end
function FadeOutObjects(Objects, FadeIncrement)
	repeat
		local LastObject = nil
		for i, v in pairs(Objects) do
			v.Transparency = (v.Transparency + FadeIncrement)
			LastObject = v
		end
		wait()
	until LastObject.Transparency >= 1 or not LastObject
end
function Dematerialize(character, humanoid, FirstPart)
	if not character or not humanoid then
		return
	end
	
	humanoid.WalkSpeed = 0
	local Parts = {}
	
	for i, v in pairs(character:GetChildren()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			table.insert(Parts, v)
		elseif v:IsA("LocalScript") or v:IsA("Script") then
			v:Destroy()
		end
	end
	local SelectionBoxes = {}
	local FirstSelectionBox = SelectionBoxify(FirstPart)
	Light(FirstPart)
	wait(0.05)
	for i, v in pairs(Parts) do
		if v ~= FirstPart then
			table.insert(SelectionBoxes, SelectionBoxify(v))
			Light(v)
		end
	end
	local ObjectsWithTransparency = GetTransparentsRecursive(character)
	FadeOutObjects(ObjectsWithTransparency, 0.1)
	wait(0.5)
	character:BreakJoints()
	humanoid.Health = 0
	
	Debris:AddItem(character, 2)
	local FadeIncrement = 0.05
	Delay(0.2, function()
		FadeOutObjects({FirstSelectionBox}, FadeIncrement)
		if character and character.Parent then
			character:Destroy()
		end
	end)
	FadeOutObjects(SelectionBoxes, FadeIncrement)
end
function Touched(Projectile, Hit)
	if not Hit or not Hit.Parent then
		return
	end
	local character, humanoid = FindCharacterAncestor(Hit)
	if character and humanoid and character ~= Character then
		local ForceFieldExists = false
		for i, v in pairs(character:GetChildren()) do
			if v:IsA("ForceField") then
				ForceFieldExists = true
			end
		end
		if not ForceFieldExists then
			if Projectile then
				local HitFadeSound = Projectile:FindFirstChild(Sounds.HitFade.Name)
				local torso = humanoid.Torso
				if HitFadeSound and torso then
					HitFadeSound.Parent = torso
					HitFadeSound:Play()
				end
			end
			Dematerialize(character, humanoid, Hit)
		end
		if Projectile and Projectile.Parent then
			Projectile:Destroy()
		end
	end
end
function Equipped()
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChild("Humanoid")
	if not Player or not Humanoid or Humanoid.Health == 0 then
		return
	end
end
function Activated(target)
	if Tool.Enabled and Humanoid.Health > 0 then
		Tool.Enabled = false
		InvokeClient("PlaySound", Sounds.Fire)
		local HandleCFrame = Handle.CFrame
		local FiringPoint = HandleCFrame.p + HandleCFrame:vectorToWorldSpace(NozzleOffset)
		local ShotCFrame = CFrame.new(FiringPoint, target)
		local LaserShotClone = BaseShot:Clone()
		LaserShotClone.CFrame = ShotCFrame + (ShotCFrame.lookVector * (BaseShot.Size.Z / 2))
		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.velocity = ShotCFrame.lookVector * Speed
		BodyVelocity.Parent = LaserShotClone
		LaserShotClone.Touched:connect(function(Hit)
			if not Hit or not Hit.Parent then
				return
			end
			Touched(LaserShotClone, Hit)
		end)
		Debris:AddItem(LaserShotClone, Duration)
		LaserShotClone.Parent = game:GetService("Workspace")
		wait(0.6) -- FireSound length
		InvokeClient("PlaySound", Sounds.Reload)
		
		wait(0.75) -- ReloadSound length
		Tool.Enabled = true
	end
end
function Unequipped()
	
end
BaseShot = Instance.new("Part")
BaseShot.Name = "Effect"
BaseShot.BrickColor = BrickColor.new("Really red")
BaseShot.Material = Enum.Material.Plastic
BaseShot.Shape = Enum.PartType.Block
BaseShot.TopSurface = Enum.SurfaceType.Smooth
BaseShot.BottomSurface = Enum.SurfaceType.Smooth
BaseShot.FormFactor = Enum.FormFactor.Custom
BaseShot.Size = Vector3.new(0.2, 0.2, 3)
BaseShot.CanCollide = false
BaseShot.Locked = true
SelectionBoxify(BaseShot)
Light(BaseShot)
BaseShotSound = Sounds.HitFade:Clone()
BaseShotSound.Parent = BaseShot
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v:FindFirstChild("AIScript") then
		source = [[--Made by Luckymaxer
--Updated for R15 avatar by StarWars
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
InsertService = game:GetService("InsertService")
AIScript = script:WaitForChild("AIScript")
Remover = script:WaitForChild("Remover")
NPCModel = InsertService:LoadAsset(257489726)
NPC = NPCModel:GetChildren()[1]:Clone()
if NPCModel and NPCModel.Parent then
	NPCModel:Destroy()
end
ReloadTime = 5
NPCSpawned = false
ToolEquipped = false
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
Handle.Transparency = 0
Tool.Enabled = true
function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end
function MakeNPC()
	if PlayerNPC and PlayerNPC.Parent then
		PlayerNPC:Destroy()
	end
	PlayerNPC = NPC:Clone()
	NPCHumanoid = PlayerNPC:FindFirstChild("Humanoid")
	NPCTorso = PlayerNPC:FindFirstChild("Torso")
	if not NPCHumanoid or not NPCTorso then
		return
	end
	NPCHumanoid.WalkSpeed = 18
	NPCHumanoid.MaxHealth = 200
	NPCHumanoid.Health = NPCHumanoid.MaxHealth
	local Values = {
		{Name = "Creator", Class = "ObjectValue", Value = Player},
		{Name = "Tool", Class = "ObjectValue", Value = Tool},
		{Name = "Mode", Class = "StringValue", Value = "Follow"},
		{Name = "MaxDistance", Class = "NumberValue", Value = 50},
		{Name = "Follow", Class = "ObjectValue", Value = Player},
		{Name = "Offset", Class = "Vector3Value", Value = Vector3.new(-3, 0, -0.5)},
		{Name = "Target", Class = "ObjectValue", Value = nil},
		{Name = "TargetPos", Class = "Vector3Value", Value = Vector3.new(0, 0, 0)},
		{Name = "Damage", Class = "NumberValue", Value = 0},
	}
	for i, v in pairs(Values) do
		local Value = Instance.new(v.Class)
		Value.Name = v.Name
		Value.Value = v.Value
		Value.Parent = PlayerNPC
	end
	for i, v in pairs({AIScript, Remover}) do
		local ScriptClone = v:Clone()
		ScriptClone.Disabled = false
		ScriptClone.Parent = PlayerNPC
	end
	NPCHumanoid.Died:connect(function()
		Debris:AddItem(PlayerNPC, 3)
	end)
	PlayerNPC.Changed:connect(function(Property)
		if Property == "Parent" and not PlayerNPC.Parent and NPCSpawned then
			Tool.Enabled = false
			NPCSpawned = false
			wait(ReloadTime)
			Tool.Enabled = true
		end
	end)
	NPCTorso.CFrame = (Torso.CFrame * CFrame.new(PlayerNPC.Offset.Value))
	PlayerNPC.Parent = game:GetService("Workspace")
	NPCHumanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	NPCSpawned = true
end
function SetTarget(Data)
	if not PlayerNPC or not PlayerNPC.Parent then
		return
	end
	local MousePosition = Data.MousePosition
	local Target = Data.Target
	local TargetValue = PlayerNPC:FindFirstChild("Target")
	local TargetPosValue = PlayerNPC:FindFirstChild("TargetPos")
	local ModeValue = PlayerNPC:FindFirstChild("Mode")
	local OffsetValue = PlayerNPC:FindFirstChild("Offset")
	if not TargetValue or not TargetPosValue or not ModeValue then
		return
	end
	if Target and Target.Parent then
		local character = Target.Parent
		if character:IsA("Hat") then
			character = character.Parent
		end
		local player = Players:GetPlayerFromCharacter(character)
		if player and IsTeamMate(player, Player) then
			return
		end
		local creator = character:FindFirstChild("Creator")
		local humanoid = character:FindFirstChild("Humanoid")
		if creator and (creator.Value == Player or IsTeamMate(Player, creator.Value)) then
			return
		end
		if humanoid and humanoid.Health > 0 then
			if TargetValue then
				TargetValue.Value = character
				ModeValue.Value = "Attack"
				return
			end
		else
			TargetPosValue.Value = MousePosition
			TargetValue.Value = nil
			ModeValue.Value = "MoveTo"
		end
	else
		ModeValue.Value = "Follow"
	end
end
function Activated()
	if not ToolEquipped or not CheckIfAlive() then
		return
	end
	if Tool.Enabled and (not PlayerNPC or not PlayerNPC.Parent) then
		Handle.Transparency = 1
		--MakeNPC()
	else
		local MouseData = InvokeClient("MousePosition")
		if not MouseData then
			return
		end
		local MousePosition = MouseData.Position
		local Target = MouseData.Target
		SetTarget({MousePosition = MousePosition, Target = Target})
	end
end
function CheckIfAlive()
	return (((Player and Player.Parent and Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent) and true) or false)
end
function Equipped()
	Handle.Transparency = 1
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChild("Humanoid")
	Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
	if not CheckIfAlive() then
		return
	end
	ToolEquipped = true
end
function Unequipped()
	--[[NPCSpawned = false
	if PlayerNPC then
		for i, v in pairs({PlayerNPC}) do
			if v and v.Parent then
				v:Destroy()
			end
		end
		PlayerNPC = nil
	end]
		ToolEquipped = false
	end
	function InvokeClient(Mode, Value)
		local ClientReturn = nil
		pcall(function()
			ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
		end)
		return ClientReturn
	end
	ServerControl.OnServerInvoke = (function(player, Mode, Value)
		if player ~= Player or not ToolEquipped or not CheckIfAlive() or not Mode or not Value then
			return
		end
	end)
	Tool.Changed:connect(function(Property)
		if not Tool.Parent then
			return
		end
		if Tool.Enabled and not NPCSpawned and ToolEquipped and CheckIfAlive() then
			MakeNPC()
		end
		Handle.Transparency = (((Tool.Parent:IsA("Backpack") or Players:GetPlayerFromCharacter(Tool.Parent) and (((not NPCSpawned and Tool.Enabled) and 0) or 1)) or 0))
	end)
	Tool.Activated:connect(Activated)
	Tool.Equipped:connect(Equipped)
	Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "AIScript" and v.Parent:FindFirstChild("Remover") then
		source = [[--Made by Luckymaxer
--Updated for R15 avatar by StarWars
Figure = script.Parent
Players = game:GetService("Players")
Debris = game:GetService("Debris")
RunService = game:GetService("RunService")
Functions = require(script:WaitForChild("Functions"))
DogeModule = require(191816425)
LastMove = 0
Rate = (1 / 60)
local function Create_PrivImpl(objectType)
	if type(objectType) ~= 'string' then
		error("Argument of Create must be a string", 2)
	end
	--return the proxy function that gives us the nice Create'string'{data} syntax
	--The first function call is a function call using Lua's single-string-argument syntax
	--The second function call is using Lua's single-table-argument syntax
	--Both can be chained together for the nice effect.
	return function(dat)
		--default to nothing, to handle the no argument given case
		dat = dat or {}
		--make the object to mutate
		local obj = Instance.new(objectType)
		local parent = nil
		--stored constructor function to be called after other initialization
		local ctor = nil
		for k, v in pairs(dat) do
			--add property
			if type(k) == 'string' then
				if k == 'Parent' then
					-- Parent should always be set last, setting the Parent of a new object
					-- immediately makes performance worse for all subsequent property updates.
					parent = v
				else
					obj[k] = v
				end
			--add child
			elseif type(k) == 'number' then
				if type(v) ~= 'userdata' then
					error("Bad entry in Create body: Numeric keys must be paired with children, got a: "..type(v), 2)
				end
				v.Parent = obj
			--event connect
			elseif type(k) == 'table' and k.__eventname then
				if type(v) ~= 'function' then
					error("Bad entry in Create body: Key `[Create.E\'"..k.__eventname.."\']` must have a function value\
							got: "..tostring(v), 2)
				end
				obj[k.__eventname]:connect(v)
			--define constructor function
			elseif k == t.Create then
				if type(v) ~= 'function' then
					error("Bad entry in Create body: Key `[Create]` should be paired with a constructor function, \
							got: "..tostring(v), 2)
				elseif ctor then
					--ctor already exists, only one allowed
					error("Bad entry in Create body: Only one constructor function is allowed", 2)
				end
				ctor = v
			else
				error("Bad entry ("..tostring(k).." => "..tostring(v)..") in Create body", 2)
			end
		end
		--apply constructor function if it exists
		if ctor then
			ctor(obj)
		end
		if parent then
			obj.Parent = parent
		end
		--return the completed object
		return obj
	end
end
--now, create the functor:
Create = setmetatable({}, {__call = function(tb, ...) return Create_PrivImpl(...) end})
--and create the "Event.E" syntax stub. Really it's just a stub to construct a table which our Create
--function can recognize as special.
Create.E = function(eventName)
	return {__eventname = eventName}
end
BasePart = Create("Part"){
	Shape = Enum.PartType.Block,
	Material = Enum.Material.Plastic,
	TopSurface = Enum.SurfaceType.Smooth,
	BottomSurface = Enum.SurfaceType.Smooth,
	FormFactor = Enum.FormFactor.Custom,
	Size = Vector3.new(0.2, 0.2, 0.2),
	CanCollide = true,
	Locked = true,
	Anchored = false,
}
Figures = {}
function IncludeFigure(Child)
	if not Child or not Child.Parent then
		return
	end
	local Player = Players:GetPlayerFromCharacter(Child)
	if Player then
		return
	end
	for i, v in pairs(Figures) do
		if v.Figure == Child then
			return
		end
	end
	local Figure = {Figure = Child, TouchDebounce = false, Connections = {}}
	local Humanoid = Child:FindFirstChild("Humanoid")
	local Head = Child:FindFirstChild("Head")
	local Torso = Child:FindFirstChild("Torso")
	if not Humanoid or not Humanoid:IsA("Humanoid") or Humanoid.Health == 0 or not Head or not Torso then
		return
	end
	local Neck = Torso:FindFirstChild("Neck")
	if not Neck then
		return
	end
	for i, v in pairs({Humanoid, Head, Torso, Neck}) do
		Figure[v.Name] = v
	end
	local Values = {"Creator", "Mode", "Follow", "Target", "TargetPos", "Offset", "Damage", "MaxDistance"}
	for i, v in pairs(Values) do
		local Value = Child:FindFirstChild(v)
		if not Value then
			return
		end
		Figure[v] = Value
	end
	local Sounds = {}
	for i, v in pairs(Head:GetChildren()) do
		if v:IsA("Sound") then
			Sounds[v.Name] = v
		end
	end
	local ModuleData = DogeModule.GetTable({Key = "Doge", Player = ((Figure.Creator and Figure.Creator.Value) or nil)})
	local DogeData = ModuleData.GetData({Character = Child})
	Spawn(function()
		DogeData.StartText()
	end)
	local Variables = {
		Bark = {LastBark = 0, Paused = false, TimeOut = 0.75},
		DogeData = DogeData,
	}
	for i, v in pairs(Variables) do
		Figure[i] = v
	end
	Figure.Sounds = Sounds
	local HumanoidChanged = Humanoid.Changed:connect(function(Property)
		if Property == "Sit" and Humanoid.Sit then
			Humanoid.Sit = false
			Humanoid.Jump = true
		end
	end)
	local FigureRemoved = Child.Changed:connect(function(Property)
		if Property == "Parent" and not Child.Parent then
			for i, v in pairs(Figures) do
				if v == Figure then
					for ii, vv in pairs(v.Connections) do
						if vv then
							vv:disconnect()
						end
					end
					table.remove(Figures, i)
				end
			end
		end
	end)
	for i ,v in pairs({HumanoidChanged, FigureRemoved}) do
		table.insert(Figure.Connections, v)
	end
	for i, v in pairs(Child:GetChildren()) do
		if v:IsA("BasePart") then
			local TouchedConnection
			TouchedConnection = v.Touched:connect(function(Hit)
				if not Hit or not Hit.Parent or Figure.TouchDebounce then
					return
				end
				local Connected = false
				local ConnectedParts = v:GetConnectedParts()
				if #ConnectedParts <= 1 then
					return
				end
				for i, v in pairs(ConnectedParts) do
					if v == Torso then
						Connected = true
					end
				end
				if not Connected then
					return
				end
				local character = Hit.Parent
				if character:IsA("Hat") then
					character = character.Parent
				end
				if character ~= Figure.Target.Value then
					return
				end
				local player = Players:GetPlayerFromCharacter(character)
				local CreatorValue = Figure.Creator.Value
				if not CreatorValue then
					return
				end
				local CreatorPlayer = ((CreatorValue:IsA("Player") and CreatorValue) or Players:GetPlayerFromCharacter(CreatorValue))
				if player then
					if player == CreatorPlayer then
						return
					end
					if player and CreatorPlayer and Functions.IsTeamMate(CreatorPlayer, player) then
						return
					end
				end
				local creator = character:FindFirstChild("Creator")
				if creator and creator:IsA("ObjectValue") and creator.Value == CreatorValue then
					return
				end
				local humanoid = character:FindFirstChild("Humanoid")
				if not humanoid or not humanoid:IsA("Humanoid") or humanoid.Health == 0 then
					return
				end
				Figure.TouchDebounce = true
				Functions.UntagHumanoid(humanoid)
				Functions.TagHumanoid(humanoid, CreatorPlayer)
				humanoid:TakeDamage(Figure.Damage.Value)
				wait(0.25)
				Figure.TouchDebounce = false
			end)
			table.insert(Figure.Connections, TouchedConnection)
		end
	end
	Figure.Sounds.Wow:Play()
	table.insert(Figures, Figure)
end
function SecureJump(Table)
	local Humanoid = Table.Humanoid
	local Torso = Table.Torso
	if not Humanoid or Humanoid.Jump or not Torso then
		return
	end
	local TargetPoint = Torso.Velocity.Unit
	local Blockage, BlockagePos = Functions.CastRay((Torso.CFrame + CFrame.new(Torso.Position, Vector3.new(TargetPoint.X, Torso.Position.Y, TargetPoint.Z)).lookVector * (Torso.Size.Z / 2)).p, Torso.CFrame.lookVector, (Torso.Size.Z * 2.5), {Figure, (((Creator and Creator.Value and Creator.Value:IsA("Player") and Creator.Value.Character) and Creator.Value.Character) or nil)}, false)
	local Jumpable = false
	if Blockage then
		Jumpable = true
		if Blockage:IsA("Terrain") then
			local CellPos = Blockage:WorldToCellPreferSolid((BlockagePos - Vector3.new(0, 2, 0)))
			local CellMaterial, CellShape, CellOrientation = Blockage:GetCell(CellPos.X, CellPos.Y, CellPos.Z)
			if CellMaterial == Enum.CellMaterial.Water then
				Jumpable = false
			end
		elseif Blockage.Parent:FindFirstChild("Humanoid") then
			Jumpable = false
		end
	end
	if Jumpable then
		Humanoid.Jump = true
	end
end
RunService.Stepped:connect(function()
	_, Time = wait(0.05)
	for i, v in pairs(Figures) do
		Spawn(function()
			pcall(function()
				if v and v.Figure and v.Figure.Parent then
					Spawn(function()
						SecureJump(v)
					end)
					local Disabled = v.Figure:FindFirstChild("Disabled")
					if not Disabled then
						local CreatorValue = v.Creator.Value
						if CreatorValue then
							local CreatorPlayer = ((CreatorValue:IsA("Player") and CreatorValue) or Players:GetPlayerFromCharacter(v.Creator.Value))
							if CreatorPlayer then
								local CreatorCharacter = CreatorPlayer.Character
								if CreatorCharacter and CreatorCharacter.Parent then
									local CreatorTorso = CreatorCharacter:FindFirstChild("Torso") or CreatorCharacter:FindFirstChild("UpperTorso")
									if CreatorTorso then
										local DistanceApart = (CreatorTorso.Position - v.Torso.Position).magnitude
										if DistanceApart > v.MaxDistance.Value then
											v.Mode.Value = "Follow"
										end
									end
								end
							end
						end
						if v.Mode.Value == "Follow" then
							local FollowValue = v.Follow.Value
							if FollowValue then
								if FollowValue:IsA("Player") and FollowValue.Character and FollowValue.Character.Parent then
									FollowValue = FollowValue.Character
								end
								local FollowHumanoid = FollowValue:FindFirstChild("Humanoid")
								local FollowTorso = FollowValue:FindFirstChild("Torso") or FollowValue:FindFirstChild("UpperTorso")
								if FollowHumanoid and FollowHumanoid.Health > 0 and FollowTorso then
									--if (v.Torso.Position - FollowTorso.Position).magnitude > 5 then
										v.Humanoid:MoveTo((FollowTorso.CFrame * CFrame.new(v.Offset.Value)).p)
									--end
								end
							end
						elseif v.Mode.Value == "MoveTo" then
							v.Humanoid:MoveTo(v.TargetPos.Value)
							LastMove = Time
							v.Mode.Value = "Nothing"
						elseif v.Mode.Value == "Attack" then
							local TargetCharacter = v.Target.Value
							local TargetDisabled = v.Target:FindFirstChild("Disabled")
							local NotFound = false
							if not TargetDisabled or not TargetDisabled.Value then
								if TargetCharacter and TargetCharacter.Parent then
									local TargetHumanoid = TargetCharacter:FindFirstChild("Humanoid")
									local TargetTorso = TargetCharacter:FindFirstChild("Torso") or TargetCharacter:FindFirstChild("UpperTorso")
									local creator = TargetCharacter:FindFirstChild("Creator")
									if TargetHumanoid and TargetHumanoid.Health > 0 and TargetTorso and (not creator or (creator and v.Creator.Value ~= creator.Value and not Functions.IsTeamMate(v.Creator.Value, creator.Value))) then
										local Direction = CFrame.new(v.Torso.Position, Vector3.new(TargetTorso.Position.X, v.Torso.Position.Y, TargetTorso.Position.Z))
										local ChaseOffset = 8
										local ChasePosition = (CFrame.new(TargetTorso.Position) - Direction.lookVector * ChaseOffset).p
										local Time = tick()
										local Distance = (v.Torso.Position - TargetTorso.Position).Magnitude
										if Distance <= (ChaseOffset + 1) and not v.Bark.Paused and (Time - v.Bark.LastBark) > v.Bark.TimeOut then
											v.Bark.Paused = true
											Spawn(function()
												for i = 1, math.random(1, 3) do
													local Sound = v.Sounds.Bark:Clone()
													Sound.Pitch = (math.random(900, 1150) * 0.001)
													Debris:AddItem(Sound, 1.5)
													Sound.Parent = v.Head
													v.Sounds.Bark:Play()
													wait(0.15)
												end
												v.Bark.TimeOut = (math.random(250, 750) * 0.001)
												v.Bark.LastBark = tick()
												v.Bark.Paused = false
											end)
											local TargetPlayer = Players:GetPlayerFromCharacter(TargetCharacter)
											if TargetPlayer then
												v.DogeData.ObscureScreen(TargetPlayer)
											end
  										end
										local BodyGyro = Create("BodyGyro"){
											maxTorque = Vector3.new(math.huge, math.huge, math.huge),
											cframe = Direction,
										}
										Debris:AddItem(BodyGyro, Rate)
										BodyGyro.Parent = v.Torso
										v.Humanoid:MoveTo(ChasePosition)
									else
										NotFound = true
									end
								else
									NotFound = true
								end
							end
							if NotFound then
								v.Target.Value = nil
								v.Mode.Value = "Follow"
							end
						elseif v.Mode.Value == "Nothing" then
							if (Time - LastMove) >= 30 then
								v.Mode.Value = "Follow"
							end
						end
					end
				end
			end)
		end)
	end
end)
IncludeFigure(Figure)]]
	elseif v.Name == "Remover" and v.Parent:FindFirstChild("AIScript") then
		source = [[--Made by Luckymaxer
Model = script.Parent
Humanoid = Model:FindFirstChild("Humanoid")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
Creator = Model:FindFirstChild("Creator")
Tool = Model:FindFirstChild("Tool")
function DestroyModel()
	Debris:AddItem(Model, 2)
end
if not Creator or not Creator.Value or not Creator.Value:IsA("Player") or not Creator.Value.Parent or not Tool or not Tool.Value or not Tool.Value.Parent then
	DestroyModel()
	return
end
Creator = Creator.Value
Tool = Tool.Value
Character = Creator.Character
if not Character then
	DestroyModel()
	return
end
Creator.Changed:connect(function(Property)
	if Property == "Parent" and not Creator.Parent then
		DestroyModel()
	end
end)
Character.Changed:connect(function(Property)
	if Property == "Parent" and not Character.Parent then
		DestroyModel()
	end
end)
Tool.Changed:connect(function(Property)
	if Property == "Parent" then
		local Player = ((Tool.Parent and ((Tool.Parent:IsA("Backpack") and Tool.Parent.Parent) or Players:GetPlayerFromCharacter(Tool.Parent))) or nil)
		if (not Player or (Player and Player ~= Creator)) then
			DestroyModel()
		end
	end
end)
if Humanoid then
	Humanoid.Died:connect(function()
		DestroyModel()
	end)
end]]
	elseif v.Name == "Server" and v:FindFirstChild("ShardContent") then
		source = [[--Rescripted by TakeoHonorable
--Revamped Periastrons: The Periastron of Rainbow Maelstrom
--The leader of the bunch, you know it well (get the reference?)
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
local Seed = Random.new(tick())
local Tool = script.Parent
Tool.Enabled = true
local Handle = Tool:WaitForChild("Handle",10)
local Region = require(script:WaitForChild("RegionModule",10))
local PointLight = Handle:WaitForChild("PointLight",10)
local Sparkles = Handle:FindFirstChildOfClass("Sparkles")
local Animations = Tool:WaitForChild("Animations",10)
local Deletables = {} --Send all deletables here
local Sounds = {
	LungeSound = Handle:WaitForChild("LungeSound",10),
	SlashSound = Handle:WaitForChild("SlashSound",10),
}
local PeriastronNames = {
	"Azure",
	"Grimgold",
	"Crimson",
	"Chartreuse",
	"Amethyst",
	"Ivory",
	"Noir",
}
local PeriastronNamesAlt = {
	"Azure",
	"Grimgold",
	"Crimson",
	"Chartreuse",
	"Amethyst",
	"Ivory",
	"Noir",
	"Hazel",
	"Fuchsia"
}
local AttackAnims
local Services = {
	Players = (game:FindService("Players") or game:GetService("Players")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris")),
	ServerScriptService = (game:FindService("ServerScriptService") or game:GetService("ServerScriptService"))
}
local Components = {
	PeriSparkle = Handle:WaitForChild("Sparkles",10),
	PeriTrail = Handle:WaitForChild("Trail",10),
	MouseInput = Tool:WaitForChild("MouseInput",10)
}
Components.PeriSparkle.Enabled = true
Components.PeriTrail.Enabled = false
PointLight.Enabled = true
local Player,Character,Humanoid,Root,Torso
local Properties = {
	BaseDamage = 40,
	SpecialCooldown = 90,
	GrimgoldRange = 40,
}
local Remote = (Tool:FindFirstChild("Remote") or Instance.new("RemoteEvent"));Remote.Name = "Remote";Remote.Parent = Tool
local Grips = {
	Normal = Tool:WaitForChild("NormalGrip").Value,
	--BackR6 = Tool:WaitForChild("BackGrip").Value,
	--BackR15 = Tool:WaitForChild("BackGrip").Value+Vector3.new(-.7,0,-.7)
}
Tool.Grip = Grips.Normal
local function Wait(para) -- bypasses the latency
	local Initial = tick()
	repeat
		Services.RunService.Heartbeat:Wait()
	until tick()-Initial >= para
end
function RayCast(Pos, Dir, Max, IgnoreList)
	return game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(Pos, Dir.unit * (Max or 999.999)), IgnoreList) 
end
function IsInTable(Table,Value)
	for _,v in pairs(Table) do
		if v == Value then
			return true
		end
	end
	return false
end
local function HasPeri(PeriName)
	return (Player:FindFirstChild("Backpack") and Player:FindFirstChild("Backpack"):FindFirstChild(PeriName.."Periastron")) or false
end
local function HasFullSet()
	for _,names in pairs(PeriastronNames) do
		if not HasPeri(names) then
			return false
		end
	end
	return true
end
function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end
function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Services.Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end
local function VisualizeRay(ray,RayLength)
	local RayCast = Create("Part"){
		Material = Enum.Material.Neon,
		Color = Color3.new(0,1,0),
		Size = Vector3.new(0.3,0.3,(RayLength or 5)),
		CFrame = CFrame.new(ray.Origin, ray.Origin+ray.Direction) * CFrame.new(0, 0, -(RayLength or 5) / 2),
		Anchored = true,
		CanCollide = false,
		Parent = workspace
	}
	game:GetService("Debris"):AddItem(RayCast,5)
end
function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end
function GetHumanoidsInRange(Range)
	local RecordedHumanoids = {}
	for _,parts in pairs(Region.new(Root.CFrame,Vector3.new(1,1,1)*Range):Cast(Character)) do
		if parts and parts.Parent and string.find(string.lower(parts.Name),"torso") or string.find(string.lower(parts.Name),"root") and (parts.CFrame.p-Root.CFrame.p).magnitude <= Range then
			local Hum = parts.Parent:FindFirstChildOfClass("Humanoid")
			if Hum and Hum.Health ~= 0 and not IsInTable(RecordedHumanoids,Hum) then
				RecordedHumanoids[#RecordedHumanoids+1] = Hum
			end
		end
	end
	return RecordedHumanoids
end
local function GetNearestTorso(MarkedPosition,TorsoPopulationTable)
	local ClosestDistance = math.huge
	local ClosestTorso
	for i=1,#TorsoPopulationTable do
		local distance = (TorsoPopulationTable[i].CFrame.p-MarkedPosition).magnitude
		if TorsoPopulationTable[i] and  distance < ClosestDistance then
			ClosestDistance = distance
			ClosestTorso = TorsoPopulationTable[i]
		end
	end
	--warn("The Closest Person is: "..ClosestTorso.Parent.Name)
	return ClosestTorso
end
local RedPillar = Create("Part"){
	Shape = Enum.PartType.Cylinder,
	Material = Enum.Material.Neon,
	Name = "CrimsonPillar",
	BrickColor = BrickColor.new("Crimson"),
	Size = Vector3.new(100,5,5),
	CanCollide = false,
	Anchored = true,
	Transparency = 0.3,
	Locked = true,
	TopSurface = Enum.SurfaceType.Smooth,
	BottomSurface = Enum.SurfaceType.Smooth
}
local Surfaces = {"Front","Back","Left","Right","Top","Bottom"}
local PillarLighting = Create("SurfaceLight"){
	Color = Color3.fromRGB(151, 0, 0),
	Angle = 180,
	Enabled = true,
	Range = 10,
	Shadows = true
}
for _,surfaces in pairs(Surfaces) do
	local Lighting = PillarLighting:Clone()
	Lighting.Face = Enum.NormalId[surfaces]
	Lighting.Parent = RedPillar
end
local CurrentTime,LastTime = tick(),tick()
function Activated()
	if not Tool.Enabled then return end
	Tool.Enabled = false
	CurrentTime = tick()
	if (CurrentTime-LastTime) <= 0.2 then
		--print("Lunge")
		Sounds.LungeSound:Play()
		Components.PeriTrail.Enabled = true
		local sucess,MousePosition = pcall(function() return Components.MouseInput:InvokeClient(Player) end)
		MousePosition = (sucess and MousePosition) or Vector3.new(0,0,0)
		
		local Direction = CFrame.new(Root.Position, Vector3.new(MousePosition.X, Root.Position.Y, MousePosition.Z))
		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
		BodyVelocity.Velocity = Direction.lookVector * ((HasPeri("Fuchsia") and 200) or 100)
		Services.Debris:AddItem(BodyVelocity, 0.5)
		BodyVelocity.Parent = Root
		delay(.5,function()
			Components.PeriTrail.Enabled = false
		end)
		Root.CFrame = CFrame.new(Root.CFrame.p,Root.CFrame.p+Direction.lookVector)
		wait(1.5)
	else
		local SwingAnims = {AttackAnims.Slash,AttackAnims.SlashAnim,AttackAnims.RightSlash}
		local AttackAnim = SwingAnims[Seed:NextInteger(1,#SwingAnims)]
		spawn(function()
			if AttackAnim ~= AttackAnims.SlashAnim then
				Sounds.SlashSound:Play()
				else
				Sounds.SlashSound:Play()
				wait(.5)
				Sounds.SlashSound:Play()
			end	
		end)
		AttackAnim:Play()
	--wait(.4)
	end
	LastTime = CurrentTime
	Tool.Enabled = true
end
local Touch
local EquippedPassives = {}
local IvoryDebounce,GrimgoldDebounce,CrimsonDebounce = false,false,false
function Equipped(Mouse)
	Character = Tool.Parent
	Root = Character:FindFirstChild("HumanoidRootPart")
	Player = Services.Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	AttackAnims = {
		Slash = Animations:WaitForChild(Humanoid.RigType.Name,10):WaitForChild("Slash",10),
		RightSlash = Animations:WaitForChild(Humanoid.RigType.Name,10):WaitForChild("RightSlash",10),
		SlashAnim = Animations:WaitForChild(Humanoid.RigType.Name,10):WaitForChild("SlashAnim",10),
	}
	for i,v in pairs(AttackAnims) do
		AttackAnims[i] = Humanoid:LoadAnimation(v)
	end
	Touch = Handle.Touched:Connect(function(hit)
		Damage(hit,Properties.BaseDamage,false)
	end)
	
	
	local IgnoreHealthChange = false
		local CurrentHealth = Humanoid.Health
		EquippedPassives[#EquippedPassives+1] = Humanoid.Changed:Connect(function(Property) -- Based on Azure Periastron
			local NewHealth = Humanoid.Health
			if not IgnoreHealthChange and NewHealth ~= Humanoid.MaxHealth then
				if NewHealth < CurrentHealth then
					local DamageDealt = (CurrentHealth - NewHealth)
					IgnoreHealthChange = true
					Humanoid.Health = Humanoid.Health + (DamageDealt * ((HasFullSet() and .5) or .33))
					--print((HasPeri("Azure") and "Has Azure") or "Does not have Azure")
					IgnoreHealthChange = false
				end
			end
			CurrentHealth = NewHealth
		end)
		
	if HasPeri("Grimgold") then
		EquippedPassives[#EquippedPassives+1] = Services.RunService.Heartbeat:Connect(function()
			if GrimgoldDebounce or not Tool:IsDescendantOf(Character) then return end
			repeat
				
				GrimgoldDebounce = true
				local TaggedHumanoids = {}
					for _,Hum in pairs(GetHumanoidsInRange((HasFullSet() and Properties.GrimgoldRange*1.5) or Properties.GrimgoldRange)) do
						if not IsInTable(TaggedHumanoids,Hum) and not IsTeamMate(Player,Services.Players:GetPlayerFromCharacter(Hum.Parent)) and not Hum.Parent:FindFirstChild("RevealRainbow")then
							TaggedHumanoids[#TaggedHumanoids+1] = Hum
							spawn(function()
								local RevealScript = script:WaitForChild("RevealRainbow",10):Clone()
								RevealScript:WaitForChild("Range").Value = (HasFullSet() and Properties.GrimgoldRange*1.5) or Properties.GrimgoldRange
								RevealScript:WaitForChild("Creator").Value = Character
								RevealScript:WaitForChild("Tool").Value = Tool
								RevealScript.Parent = Hum.Parent
								RevealScript.Disabled = false
							end)
							Hum.WalkSpeed = (HasFullSet() and 4) or 12
						end
					end
				wait(1/10)
				GrimgoldDebounce = false
				--Services.RunService.Heartbeat:Wait()
			until not Tool:IsDescendantOf(Character) or Humanoid.Health <= 0
		end)
	end
	
	if HasPeri("Crimson") then
		EquippedPassives[#EquippedPassives+1] = Services.RunService.Heartbeat:Connect(function()
			if CrimsonDebounce or not Tool:IsDescendantOf(Character) then return end
			repeat
				CrimsonDebounce = true
				Wait((HasFullSet() and Seed:NextNumber(.2,1)) or Seed:NextNumber(1,3))
				local NearbyPlayers = {}
				for _,player in pairs(Services.Players:GetPlayers()) do
					if player ~= Player and player.Character and player.Character.PrimaryPart then
						local Hum = player.Character:FindFirstChildOfClass("Humanoid")
						if Hum and Hum.Health <= 0 and Hum.Health ~= 0 and (player.Character.PrimaryPart.CFrame.p-Root.CFrame.p).Magnitude <=30 then
							NearbyPlayers[#NearbyPlayers+1] = player.Character.PrimaryPart
						end
					end
				end
				if #NearbyPlayers == 0 then
					local SpawnPos = (Root.CFrame*CFrame.new(Seed:NextInteger(-40,40),100,Seed:NextInteger(-40,40))).p
					local hit,pos = RayCast(SpawnPos,(SpawnPos-Vector3.new(0,1,0))-SpawnPos,150,{Character})
					if hit then
						local PillarClone = RedPillar:Clone()
						local PillarScript = script:WaitForChild("CrimsonPillar",5):Clone()
						PillarScript:WaitForChild("Creator",5).Value = Player
						PillarScript.Parent = PillarClone
						PillarClone.CFrame = CFrame.new(pos+Vector3.new(0,PillarClone.Size.X/2,0))*CFrame.Angles(0,0,math.rad(90))
						PillarClone.Parent = workspace
						PillarScript.Disabled = false
					end
				else
					local ChosenPlayer = NearbyPlayers[Seed:NextInteger(1,#NearbyPlayers)]
					if ChosenPlayer then
						local PillarClone = RedPillar:Clone()
						local PillarScript = script:WaitForChild("CrimsonPillar",5):Clone()
						PillarScript:WaitForChild("Creator",5).Value = Player
						PillarScript.Parent = PillarClone
						PillarClone.CFrame = CFrame.new(ChosenPlayer.CFrame.p+Vector3.new(0,(PillarClone.Size.X/2)-2.5,0))*CFrame.Angles(0,0,math.rad(90))
						PillarClone.Parent = workspace
						PillarScript.Disabled = false
					end
				end
				
				Services.RunService.Heartbeat:Wait()
				CrimsonDebounce = false
			until not Tool:IsDescendantOf(Character) or Humanoid.Health <= 0
		end)
	end
	
	if HasPeri("Ivory") then
		
		local ShardContent = script:WaitForChild("ShardContent",10):GetChildren()	
		
		local Shard = Create("Part"){
						Material = Enum.Material.Neon,
						Size = Vector3.new(1,1,1)*.5,
						Anchored = false,
						CanCollide = false,
						Name = "StarShard",
						Locked = true,
						Transparency = 0,
						Shape = Enum.PartType.Ball,
						CFrame = Handle.CFrame,
					}
					local TopAttachment = Create("Attachment"){
						Position = Vector3.new(0,Shard.Size.y/2,0),
						Name = "TopAttachment",
						Parent = Shard
					}
					local BottomAttachment = Create("Attachment"){
						Position = Vector3.new(0,-Shard.Size.y/2,0),
						Name = "BottomAttachment",
						Parent = Shard
					}
					for _,stuff in pairs(ShardContent) do
						if stuff:IsA("ParticleEmitter") then
							local particle = stuff:Clone()
							particle.Parent = Shard
						elseif stuff:IsA("Trail") then
							local trail = stuff:Clone()
							trail.Attachment0 = TopAttachment;
							trail.Attachment1 = BottomAttachment;
							trail.Parent = Shard
							trail.Enabled = true
						end
					end
		EquippedPassives[#EquippedPassives+1] = Services.RunService.Heartbeat:Connect(function()
	
				if IvoryDebounce or not Tool:IsDescendantOf(Character) then return end
				
				
				repeat
					--wait(Seed:NextNumber(.1,.5))
					IvoryDebounce = true
					local Proj = Shard:Clone()
					for _,v in pairs(Proj:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							v.Enabled = true
						end
					end
					local SparkleClone = script:WaitForChild("Sparkle",5):Clone()
					SparkleClone.Parent = Proj
					SparkleClone:Play()
					local ShardScript = script:WaitForChild("StarShard",10):Clone()
					ShardScript:WaitForChild("Creator").Value = Player
					ShardScript.Parent = Proj
					ShardScript.Disabled = false
					--Services.Debris:AddItem(Proj,7)
					Proj.CFrame = Handle.CFrame
					Proj.Parent = workspace
					Proj:SetNetworkOwner(nil)
					Proj.Velocity = CFrame.new(Handle.CFrame.p,Handle.CFrame.p+Vector3.new(Seed:NextNumber(-1,1),Seed:NextNumber(-1,1),Seed:NextNumber(-1,1))).lookVector*Seed:NextNumber(50,70)
					Wait((HasFullSet() and 1/3) or 1/2)
					IvoryDebounce = false
					--Services.RunService.Heartbeat:Wait()
				until not Tool:IsDescendantOf(Character) or Humanoid.Health <= 0
		end)
	end
	
end
function Unequipped()
	if Touch then Touch:Disconnect();Touch = nil end
	for i,v in pairs(AttackAnims) do
		v:Stop()
	end
	for index,passive in pairs(EquippedPassives) do
		if passive then 
			passive:Disconnect();EquippedPassives[index] = nil
		end 
	end
end
local HitHumanoids = {}
function Damage(hit,TotalDamage)
	if not hit or not hit.Parent then return end
	local Hum = hit.Parent:FindFirstChildOfClass("Humanoid")
	local ForceField = hit.Parent:FindFirstChildOfClass("ForceField")
	if not Hum or Hum.Health <=0 or Hum == Humanoid or ForceField then return end
	
	if IsTeamMate(Player,Services.Players:GetPlayerFromCharacter(Hum.Parent)) then return end
	
	if IsInTable(HitHumanoids,Hum) then return end
	
	spawn(function()
		UntagHumanoid(Hum)
		TagHumanoid(Hum,Player)
		HitHumanoids[#HitHumanoids+1]=Hum
		Hum:TakeDamage(TotalDamage)
		Humanoid.Health = math.clamp(Humanoid.Health + (TotalDamage * ((HasFullSet() and .3) or .2)),0,Humanoid.MaxHealth)--Noir life-steal
		--wait(.5)
		for i,v in pairs(HitHumanoids) do
			if v == Hum then
				HitHumanoids[i] = nil
			end
		end
	end)
end
Tool.Activated:Connect(Activated)
Tool.Equipped:Connect(Equipped)
Tool.Unequipped:Connect(Unequipped)
function SummonRainBeam()
	if not Sparkles.Enabled then return end
	Sparkles.Enabled = false
	local RainBeamScript = script:WaitForChild("RainBeam",5):Clone()
	RainBeamScript:WaitForChild("Creator",5).Value = Player
	RainBeamScript:WaitForChild("Tool",5).Value = Tool
	RainBeamScript.Parent = Services.ServerScriptService
	local PeriFormation = RainBeamScript:WaitForChild("PeriFormation",5)
	for _,name in pairs(PeriastronNamesAlt) do
		local Peri = HasPeri(name)
		if Peri then
			local PeriHandle = Peri:FindFirstChild("Handle",true)
			
			if PeriHandle then
				local PeriLight = PeriHandle:FindFirstChildOfClass("PointLight")
				local PeriMesh = PeriHandle:FindFirstChildOfClass("SpecialMesh")
				if PeriMesh and PeriLight then
					local PeriTag = Create("Color3Value"){
						Name = PeriMesh.TextureId,
						Value = PeriLight.Color,
						Parent = PeriFormation
					}
				end
			end
		
		end
	end
	RainBeamScript.Disabled = false
	
	repeat
		Services.RunService.Heartbeat:Wait()
	until not RainBeamScript or not RainBeamScript:IsDescendantOf(Services.ServerScriptService)
	
	wait((HasFullSet() and Properties.SpecialCooldown/2) or Properties.SpecialCooldown)
	Sparkles.Enabled = true
end
local ChartreuseReady,AmethystReady,HazelReady = true,true,true -- debounces for each one
function ShieldPulse()
	if not ChartreuseReady then return end
	ChartreuseReady = false
	--print("Shield Pulse")
	local ShieldScript = script:WaitForChild("ShieldScript",5):Clone()
	ShieldScript.Parent = Character
	ShieldScript.Disabled = false
	
	repeat
		Services.RunService.Heartbeat:Wait()
	until not ShieldScript or not ShieldScript.Parent
	
	delay((HasFullSet() and 7) or 7*2,function()
		ChartreuseReady = true
	end)
end
function Singularity()
	if not AmethystReady then return end
	AmethystReady = false
	--print("Singularity")
	
local Centre = Create("Part"){
	Size = Vector3.new(1,1,1)*1,
	CFrame = Root.CFrame,
	Transparency = 1,
	Anchored = true,
	Locked = true,
	CanCollide = false,
	TopSurface = Enum.SurfaceType.Smooth,
	BottomSurface = Enum.SurfaceType.Smooth	
}
Centre.Parent = workspace
local BlackHoleScript = script:WaitForChild("BlackHole"):Clone()
BlackHoleScript:WaitForChild("Creator",5).Value = Player
BlackHoleScript.Parent = Centre
BlackHoleScript.Disabled = false
	delay((HasFullSet() and 12) or 12*2,function()
		AmethystReady = true
	end)
end
function RockLift()
	if not HazelReady then return end
	HazelReady = false
	--print("Rock Lift")
	local hit,pos,mat = RayCast(Root.CFrame.p,(Root.CFrame.p+Vector3.new(0,-1,0))-Root.CFrame.p,10,{Character})
	
	local Rock = Create("Part"){
		Size = Vector3.new(1,1,1)*15,
		Material = Enum.Material.Slate,
		Anchored = true,
		Name = "Rock",
		Locked = true,
		CanCollide = true,
		Color = ((hit and hit.Color) or Color3.fromRGB(102, 51, 0)),
		CFrame = CFrame.new(Root.CFrame.p-Vector3.new(0,2,0))*CFrame.Angles(math.rad(Seed:NextInteger(0,360)),math.rad(Seed:NextInteger(0,360)),math.rad(Seed:NextInteger(0,360))),
		Parent = workspace
	}
	
	local RockSummon = script:WaitForChild("RockSummon",5):Clone()
	RockSummon:WaitForChild("Creator",5).Value = Player
	RockSummon.Parent = Rock
	RockSummon.Disabled = false
	
	local JumpForce = Create("BodyVelocity"){
		MaxForce = Vector3.new(1,1,1) * math.huge,
		Name = "JumpForce",
		Velocity = ((Root.CFrame.p + Vector3.new(0,1,0))-Root.CFrame.p).Unit*150,
		Parent = Root
	}
	Services.Debris:AddItem(JumpForce,.1)
	
	delay((HasFullSet() and 6) or 6*2,function()
		HazelReady = true
	end)
end
Remote.OnServerEvent:Connect(function(Client,Key)
	if not Player or not Client or Client ~= Player or not Key or not Tool.Enabled or Humanoid.Health <= 0 then return end
	if Key == Enum.KeyCode.Q then
		SummonRainBeam()
	elseif Key == Enum.KeyCode.E and HasPeri("Chartreuse") then
		ShieldPulse()
	elseif Key == Enum.KeyCode.X and HasPeri("Amethyst") then
		Singularity()	
	elseif Key == Enum.KeyCode.R and HasPeri("Hazel") then
		RockLift()
	end
end)]]
	elseif v.Name == "BlackHole" and v.Parent:FindFirstChild("ShardContent") then
		source = [[function Create(ty)
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
function IsInTable(Table,Value)
	for _,v in pairs(Table) do
		if v == Value then
			return true
		end
	end
	return false
end
function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end
local Black_Hole = script.Parent
local Creator = script:WaitForChild("Creator",5)
local ParticleFolder = script:WaitForChild("Particles",5)
local CenterAttachment = Create("Attachment"){
	Position = Vector3.new(0,0,0),
	Parent = Black_Hole
}
local Radius = 50
local Services = {
	Players = (game:FindService("Players") or game:GetService("Players")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris")),
	ServerScriptService = (game:FindService("ServerScriptService") or game:GetService("ServerScriptService"))
}
local function Wait(para) -- bypasses the latency
	local Initial = tick()
	repeat
		Services.RunService.Heartbeat:Wait()
	until tick()-Initial >= para
end
for _,particles in pairs(ParticleFolder:GetChildren()) do
	if particles:IsA("ParticleEmitter") then
		particles.Parent = CenterAttachment
		particles.Enabled = true
	end
end
local EffectSound = script:WaitForChild("Effect")
EffectSound.Parent = Black_Hole
EffectSound:Play()
local VeloForces = {}
local AffectedParts = {}
local Pulling = true
delay(5,function()
	Pulling = false
	for _,forces in pairs(VeloForces) do
		if forces then
			forces:Destroy()
		end
	end
	Black_Hole:Destroy()
end)
while Black_Hole and Black_Hole:IsDescendantOf(workspace) and Pulling do
	--spawn(function()
		local NegativeRegion = (Black_Hole.Position - Vector3.new(Radius,Radius,Radius))
		local PositiveRegion = (Black_Hole.Position + Vector3.new(Radius,Radius,Radius))
		local Region = Region3.new(NegativeRegion, PositiveRegion)
		local Parts = workspace:FindPartsInRegion3WithIgnoreList(Region,{Creator.Value.Character,Black_Hole},math.huge)
		for _,hit in pairs(Parts) do
			if hit and hit.Parent and not hit.Anchored and (hit.CFrame.p-Black_Hole.CFrame.p).Magnitude <= Radius and not IsInTable(AffectedParts,hit) and not hit:FindFirstAncestorWhichIsA("Tool") and not hit:FindFirstAncestorWhichIsA("Accoutrement") and not hit.Parent:FindFirstChildOfClass("ForceField") and not IsTeamMate(Creator.Value,Services.Players:GetPlayerFromCharacter(hit.Parent)) then
				AffectedParts[#AffectedParts+1] = hit
				local Pull = Create("BodyVelocity"){
					MaxForce = Vector3.new(1,1,1)*math.huge,
					Velocity = ((Black_Hole.CFrame.p-hit.CFrame.p).Unit*25),
					Name = "Pull",
					Parent = hit
				}
				VeloForces[#VeloForces+1] = Pull
				delay(.5,function()
				
						for index,v in pairs(VeloForces) do
							if v == Pull then
								table.remove(AffectedParts,index)
								if Pull then
									Pull:Destroy()
								end
							end
						end
						for index,v in pairs(AffectedParts) do
							if v == hit then
								table.remove(AffectedParts,index)
							end
						end
					
				end)
				--Services.Debris:AddItem(Pull,.5)
			end
		end
	--end)
	Wait(1/30)
	--Services.RunService.Heartbeat:Wait()
end]]
	elseif v.Name == "CrimsonPillar" then
		source = [[local Pillar = script.Parent
local Creator = script:WaitForChild("Creator",5).Value
local Services = {
	Players = (game:FindService("Players") or game:GetService("Players")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService"))
}
function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end
function IsInTable(Table,Value)
	for _,v in pairs(Table) do
		if v == Value then
			return true
		end
	end
	return false
end
function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Services.Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end
function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end
local LaserSound = script:WaitForChild("Laser",5)
LaserSound.Parent = Pillar
wait(.5)
local PillarTween = Services.TweenService:Create(Pillar,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Transparency = 1,Size = Vector3.new(Pillar.Size.X,30,30),Color = Color3.fromRGB(255, 0, 255)})
local SoundTween = Services.TweenService:Create(LaserSound,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Volume = 0})
for _,light in pairs(Pillar:GetChildren()) do
	if light:IsA("Light") then
		local LightTween = Services.TweenService:Create(light,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Color = Color3.fromRGB(255, 0, 255)})
		LightTween:Play()
	end
end
LaserSound:Play()
PillarTween:Play()
SoundTween:Play()
local TaggedHumanoids = {}
Pillar.Touched:Connect(function(hit)
	if not hit or not hit.Parent then return end
	local Humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return end
	if Creator == Services.Players:GetPlayerFromCharacter(Humanoid.Parent) or IsTeamMate(Creator,Services.Players:GetPlayerFromCharacter(Humanoid.Parent)) or IsInTable(TaggedHumanoids,Humanoid) then return end
	TaggedHumanoids[#TaggedHumanoids+1]=Humanoid
	UntagHumanoid(Humanoid)
	TagHumanoid(Humanoid,Creator)
	Humanoid:TakeDamage(40)
end)
SoundTween.Completed:Wait()
Pillar:Destroy()]]
	elseif v.Name == "RainBeam" then
		source = [[local Creator = script:WaitForChild("Creator",5)
local Tool = script:WaitForChild("Tool",5).Value
local PeriFormation = script:WaitForChild("PeriFormation",5):GetChildren()
if not Creator then script:Destroy() return end
local Humanoid,Root = Creator.Value.Character:FindFirstChildOfClass("Humanoid"),Creator.Value.Character:WaitForChild("HumanoidRootPart",5)
if not Humanoid or not Root then script:Destroy() return end
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
local Services = {
	Players = (game:FindService("Players") or game:GetService("Players")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService"))
}
local Properties = {
BaseUrl = "rbxassetid://"
}
local Deleteables = {}
local Periastron = Create("Part"){
	Locked = true,
	CanCollide = false,
	Anchored = true,
	Size = Vector3.new(1, 0.6, 5.2)*10,
	Material = Enum.Material.Neon,
	Color = Color3.new(1,1,1)
}
local PeriastronMesh = Create("SpecialMesh"){
	MeshType = Enum.MeshType.FileMesh,
	MeshId = Properties.BaseUrl.."80557857",
	Scale = Vector3.new(1,1,1)*10,
	Parent = Periastron
}
--[[local Surfaces = {"Front","Back","Left","Right","Top","Bottom"}
local BeamLighting = Create("SurfaceLight"){
	Color = Color3.fromRGB(1, 1, 1),
	Angle = 180,
	Enabled = true,
	Range = 100,
	Shadows = false
}
local SurfaceLights = {}]
		local rad = math.rad
		local info = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
		local Charging = true
		local Animation = script:WaitForChild("Animations",5):WaitForChild(Humanoid.RigType.Name,10):WaitForChild("Release")
		function IsTeamMate(Player1, Player2)
			return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
		end
		function TagHumanoid(humanoid, player)
			local Creator_Tag = Instance.new("ObjectValue")
			Creator_Tag.Name = "creator"
			Creator_Tag.Value = player
			Services.Debris:AddItem(Creator_Tag, 2)
			Creator_Tag.Parent = humanoid
		end
		function UntagHumanoid(humanoid)
			for i, v in pairs(humanoid:GetChildren()) do
				if v:IsA("ObjectValue") and v.Name == "creator" then
					v:Destroy()
				end
			end
		end
		local ReleaseAnim = Humanoid:LoadAnimation(Animation)
		ReleaseAnim:Play(nil,nil,2)
		local RainPeri = Periastron:Clone();RainPeri.Name = "RainbowPeriastron";RainPeri.Size = RainPeri.Size/10
		RainPeri:FindFirstChildOfClass("SpecialMesh").TextureId = Properties.BaseUrl .."157345185"
		RainPeri.CanCollide = false
		RainPeri.CFrame = CFrame.new(Tool:WaitForChild("Handle",5).CFrame.p)*CFrame.Angles(rad(90),0,0);RainPeri.Parent = workspace
		RainPeri.Anchored = true

		local Loc = Root.CFrame.p+Vector3.new(0,55,0)
		local Orientation = Loc + (Creator.Value.Character.PrimaryPart.CFrame.lookVector*-2)
		local PartSizeTween = Services.TweenService:Create(RainPeri,info,{Size = RainPeri.Size,CFrame = CFrame.new(Loc,Orientation)})
		local MeshSizeTween = Services.TweenService:Create(RainPeri:FindFirstChildOfClass("SpecialMesh"),info,{Scale = Vector3.new(1,1,1)*10})
		MeshSizeTween:Play()
		PartSizeTween:Play()PartSizeTween.Completed:Wait()
		local PeriRangers = {} --GO GO PERI RANGERS!!!!
		local FormationModel = Create("Model"){
			Name = "PeriRangers",
			Parent = workspace
		}
		Humanoid.Died:Connect(function()--remove the Giant Peri Formation if you happen to die
			FormationModel:Destroy()
			RainPeri:Destroy()
			for _,deletable in pairs(Deleteables) do
				deletable:Destroy()
			end
			script:Destroy()
			return
		end)
		local CenterPiece = Create("Part"){
			Anchored = true,
			CanCollide = false,
			Transparency = 1,
			Size = Vector3.new(1,1,1)*2,
			CFrame = RainPeri.CFrame*CFrame.new(0,0,-RainPeri.Size.z/2),
			Parent = FormationModel
		}
		FormationModel.PrimaryPart = CenterPiece 
		local spin = 0
		local amount = 10
		spawn(function()
			repeat
				RainPeri.CFrame = CFrame.new(Loc,Loc + (Root.CFrame.lookVector*-2))
				FormationModel:SetPrimaryPartCFrame((RainPeri.CFrame*CFrame.new(0,0,-RainPeri.Size.z/2))*CFrame.Angles(0,0,rad(spin)))
				Services.RunService.Stepped:Wait()
				spin = spin+amount
			until not Charging or not FormationModel or not FormationModel.PrimaryPart
		end)
		RainPeri.Touched:Connect(function(hit)--Spinning blades also kill!
			local Hum = hit.Parent:FindFirstChildOfClass("Humanoid")
			if not Hum then return end
			if Hum == Humanoid or IsTeamMate(Creator.Value,Services.Players:GetPlayerFromCharacter(Hum.Parent)) then return end
			UntagHumanoid(Hum)
			TagHumanoid(Hum,Creator.Value)
			Hum:TakeDamage(Hum.Health)
		end)
		for _,Val in pairs(PeriFormation) do
			local PeriClone = RainPeri:Clone();
			--[[for i,v in pairs(PeriClone:GetChildren()) do
				v:Destroy()
			end]
			PeriClone.Size = PeriClone.Size*10
			local Mesh = PeriClone:FindFirstChildOfClass("SpecialMesh")
			PeriClone.Color = Val.Value
			Mesh.TextureId = Val.Name;
			--Mesh.Scale = Mesh.Scale*10
			PeriClone.Name = "Periastron";
			PeriClone.Parent = FormationModel
			PeriRangers[#PeriRangers+1] = PeriClone
			PeriClone.Touched:Connect(function(hit)--Spinning blades also kill!
				local Hum = hit.Parent:FindFirstChildOfClass("Humanoid")
				if not Hum or Hum == Humanoid or IsTeamMate(Creator.Value,Services.Players:GetPlayerFromCharacter(Hum.Parent)) then return end
				Hum:TakeDamage(Hum.Health)
			end)
		end
		for i,v in pairs(PeriRangers) do
			local pos = (RainPeri.CFrame*CFrame.Angles(rad(90),i*rad(360/#PeriRangers),0))
			v.Anchored = true
			v.CFrame = pos*CFrame.new(0,-v.Size.Z/2,v.Size.Z/2)
		end
		local ChargeSound = script:WaitForChild("ChargeSound",5)
		ChargeSound.Parent = CenterPiece
		ChargeSound:Play()
		local Seed = Random.new(tick())
		local alottedTime = tick()
		--[[workspace.DescendantRemoving:Connect(function(d)
			if d == Tool then
			FormationModel:Destroy()
			RainPeri:Destroy()
			end
		end)]
		spawn(function()
			repeat
				wait(Seed:NextNumber(.05,.2))
				local Index = Seed:NextInteger(1,#PeriRangers)
				local Energy = Create("Part"){
					Material = Enum.Material.Neon,
					CanCollide = false,
					Size = Vector3.new(1,1,1)*Seed:NextInteger(3,10),
					CFrame = (RainPeri.CFrame*CFrame.Angles(rad(Seed:NextInteger(0,360)),rad(Seed:NextInteger(0,360)),rad(Seed:NextInteger(0,360))))*CFrame.new(0,0,Seed:NextInteger(20,50)),
					Color = (PeriRangers[Index] and PeriRangers[Index].Color) or Color3.new(Seed:NextNumber(0,1),Seed:NextNumber(0,1),Seed:NextNumber(0,1)),
					Shape = Enum.PartType.Ball,
					Transparency = 0.5,
					Parent = workspace,
				}
				Deleteables[#Deleteables+1] = Energy
				Energy:SetNetworkOwner(nil)-- So it wouldn't be so laggy looking :P
				local Aim = Create("RocketPropulsion"){
					Target = RainPeri,
					TargetRadius = 4,
					MaxThrust = 10^5,
					TurnD = 10,
					TurnP = 100,
					MaxSpeed = 100,
					CartoonFactor = .8,
					Parent = Energy	
				}
				Aim:Fire()
				spawn(function()
					Aim.ReachedTarget:Wait()
					Energy:Destroy()
				end)
				delay(2,function()--safety catch
					Energy:Destroy()
				end)
			until tick()-alottedTime >= ChargeSound.TimeLength-(.15*#PeriFormation)

			Charging = false
			spawn(function()
				repeat
					FormationModel:SetPrimaryPartCFrame(FormationModel.PrimaryPart.CFrame*CFrame.Angles(0,0,rad(amount)))
					Services.RunService.Stepped:Wait()
				until not FormationModel or not FormationModel.PrimaryPart
			end)

			ChargeSound:Stop()
			wait(1)
			--warn("FIRE!!!!!")

			local RainBeamEnd = Create("Part"){
				Material = Enum.Material.Neon,
				Anchored = true,
				CanCollide = false,
				Transparency = .2,
				Size = Vector3.new(1,1,1)*150,
				CFrame = (RainPeri.CFrame*CFrame.Angles(0,rad(90),0))*CFrame.new((-150/3)+(RainPeri.Size.Z/2),0,0),
				Shape = Enum.PartType.Ball,
				Parent = workspace
			}
			local RainBeam = Create("Part"){
				Material = Enum.Material.Neon,
				Anchored = true,
				CanCollide = false,
				Transparency = .2,
				Size = Vector3.new(0,150,150),
				CFrame = RainBeamEnd.CFrame * CFrame.new(0,0,0),
				Shape = Enum.PartType.Cylinder,
				Parent = workspace
			}

		--[[for _,surfaces in pairs(Surfaces) do
			local Lighting = BeamLighting:Clone()
			Lighting.Face = Enum.NormalId[surfaces]
			Lighting.Parent = RainBeamEnd
			SurfaceLights[#SurfaceLights+1]=Lighting
		end
		for _,surfaces in pairs(Surfaces) do
			local Lighting = BeamLighting:Clone()
			Lighting.Face = Enum.NormalId[surfaces]
			Lighting.Parent = RainBeam
			SurfaceLights[#SurfaceLights+1]=Lighting
		end]

			Deleteables[#Deleteables+1]=RainBeamEnd
			Deleteables[#Deleteables+1]=RainBeam
			RainBeam.Touched:Connect(function(hit)
				if not hit or not hit.Parent then return end
				local Hum = hit.Parent:FindFirstChildOfClass("Humanoid")
				local ForceField = hit.Parent:FindFirstChildOfClass("ForceField")
				if not Hum or ForceField then return end
				if Hum == Humanoid or IsTeamMate(Creator.Value,Services.Players:GetPlayerFromCharacter(Hum.Parent)) then return end
				UntagHumanoid(Hum)
				TagHumanoid(Hum,Creator.Value)
				Hum:TakeDamage(Hum.Health)
				hit:Destroy()
			end)
			RainBeamEnd.Touched:Connect(function(hit)
				if not hit or not hit.Parent then return end
				local Hum = hit.Parent:FindFirstChildOfClass("Humanoid")
				local ForceField = hit.Parent:FindFirstChildOfClass("ForceField")
				if not Hum or ForceField then return end
				if Hum == Humanoid or IsTeamMate(Creator.Value,Services.Players:GetPlayerFromCharacter(Hum.Parent)) then return end
				UntagHumanoid(Hum)
				TagHumanoid(Hum,Creator.Value)
				Hum:TakeDamage(Hum.Health)
				hit:Destroy()
			end)
			spawn(function()


				while RainBeam and RainBeamEnd do
					--RainBeamEnd.Color = PeriRangers[Seed:NextInteger(1,#PeriRangers)].Color
					--RainBeam.Color = RainBeamEnd.Color
					for _,PeriProperty in pairs(PeriFormation) do
						if PeriProperty.Value then
							local Tween = Services.TweenService:Create(RainBeam,TweenInfo.new(.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0),{Color = PeriProperty.Value})
							local Tween2 = Services.TweenService:Create(RainBeamEnd,TweenInfo.new(.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0),{Color = PeriProperty.Value})

						--[[for _,lights in pairs(SurfaceLights) do
							for _,PeriProperty in pairs(PeriFormation) do
								if PeriProperty.Value then
									local LightTween = Services.TweenService:Create(lights,TweenInfo.new(.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0),{Color = PeriProperty.Value})
									LightTween:Play()	
								end
							end
						end]

							Tween:Play();Tween2:Play()
							Tween2.Completed:Wait()
						end
					end
					Services.RunService.Stepped:Wait()
				end
			end)
			local FireSound = script:WaitForChild("FireSound",5)
			FireSound.Parent = CenterPiece
			local LoopSound = script:WaitForChild("LoopSound",5)
			LoopSound.Parent = CenterPiece
			FireSound:Play()
			LoopSound:Play()
		--[[local Velo = Create("BodyVelocity"){
			Velocity = -RainPeri.CFrame.lookVector*100,
			MaxForce = Vector3.new(1,1,1)*math.huge,
			Parent = RainBeam,
		}]
			local BeamInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
			local SizeTween = Services.TweenService:Create(RainBeam,BeamInfo,{Size = Vector3.new(500,RainBeam.Size.Y,RainBeam.Size.Z),CFrame = (RainBeamEnd.CFrame*CFrame.new(-500/2,0,0))})
			SizeTween:Play();SizeTween.Completed:Wait()
			--RainBeam.Anchored = false
			local CoolDownSound = Create("Sound"){
				SoundId = "rbxassetid://1899277236",
				Volume = 2,
				Looped = false,
				Parent = CenterPiece
			}
			local AlphaTween = Services.TweenService:Create(RainBeam,TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0),{Transparency = 1})
			AlphaTween:Play()
			local AlphaTween2 = Services.TweenService:Create(RainBeamEnd,TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0),{Transparency = 1})
			AlphaTween2:Play();
			AlphaTween2.Completed:Wait()
			FireSound:Destroy()
			LoopSound:Destroy()
			CoolDownSound:Play()
			spawn(function()
				repeat
					amount = math.clamp(amount-0.05,0,10)
					Services.RunService.Stepped:Wait()
				until not FormationModel
			end)
			RainBeamEnd:Destroy()
			RainBeam:Destroy()
			CoolDownSound.Ended:Wait()
			delay(1,function()
				RainPeri:Destroy()
				FormationModel:Destroy()
				script:Destroy()
			end)

		end)
		]]
	elseif v.Name == "RevealRainbow" then
		source = [[function Create(ty)
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
local Character = script.Parent
local Hum = Character:FindFirstChildOfClass("Humanoid")
local Center = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("HumanoidRootPart")
if not Center then script:Destroy() end
local Creator = script:WaitForChild("Creator",5)
local Tool = script:WaitForChild("Tool",5)
local Range = script:WaitForChild("Range",5)
if not Creator or not Tool or not Range then script:Destroy() return end
Creator = Creator.Value
Tool = Tool.Value
Range = Range.Value
local CreatorTorso = Creator:FindFirstChild("HumanoidRootPart") or Creator:FindFirstChild("Torso") or Creator:FindFirstChild("UpperTorso")
local Services = {
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris"))
}
local SONARPeri = Create("Part"){
	Name = "SONARPeri",
	Size = Vector3.new(1,0.6,5.2),
	Locked = true,
	Anchored = false,
	CanCollide = false,
	Material = Enum.Material.Plastic
}
local BaseUrl = "http://www.roblox.com/asset/?id="
local SONARPeriMesh = Create("SpecialMesh"){
	MeshType = Enum.MeshType.FileMesh,
	Offset = Vector3.new(0,0,0),
	Scale = Vector3.new(1,1,1),
	VertexColor = Vector3.new(1,1,1),
	MeshId = BaseUrl.."80557857",
	TextureId = BaseUrl.."73816926",
	Parent = SONARPeri
}
local Pos = Create("BodyPosition"){
	MaxForce = Vector3.new(1,1,1)*math.huge,
	Position = (Center.CFrame * CFrame .new(0,0,-3)).p,
	D = 1250,
	P = 10^4,
	Parent = SONARPeri
}
local Beep = script:WaitForChild("SONARBeep",5)
Beep.Parent = Center
Beep:Play()
SONARPeri.CFrame = CFrame.new(Center.CFrame.p+Vector3.new(0,10,0))*CFrame.Angles(math.rad(90),0,0)
Pos.Position = Center.CFrame.p + Vector3.new(0,10,0)
SONARPeri.Parent = Character
local Speed = Hum.WalkSpeed
for i=25,0,-1 do
	SONARPeri.Transparency = (i/60)
	Services.RunService.Heartbeat:Wait()
end
repeat
Pos.Position = Center.CFrame.p + Vector3.new(0,10,0)
Services.RunService.Heartbeat:Wait()
--print(Center)
until (Center.CFrame.p-CreatorTorso.CFrame.p).Magnitude > Range or not Tool:IsDescendantOf(Creator) or not Tool:IsDescendantOf(workspace) or Hum.WalkSpeed ~= Speed or Hum.Health <= 0 or not Center or not Center:IsDescendantOf(workspace) or not Character or not Character:IsDescendantOf(workspace)
for i=0,25,1 do
	SONARPeri.Transparency = (i/60)
	Services.RunService.Heartbeat:Wait()
end
SONARPeri:Destroy()
script:Destroy()]]
	elseif v.Name == "RockSummon" then
		source = [[function Create(ty)
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
local function VisualizeRay(ray,RayLength)
	local RayCast = Create("Part"){
		Material = Enum.Material.Neon,
		Color = Color3.new(0,1,0),
		Size = Vector3.new(0.3,0.3,(RayLength or 5)),
		CFrame = CFrame.new(ray.Origin, ray.Origin+ray.Direction) * CFrame.new(0, 0, -(RayLength or 5) / 2),
		Anchored = true,
		CanCollide = false,
		Parent = workspace
	}
	game:GetService("Debris"):AddItem(RayCast,5)
end
local Rock = script.Parent
local Seed = Random.new(tick())
local Creator = script:WaitForChild("Creator",5).Value
local RockCollection = {Rock}
function RayCast(Pos, Dir, Max, IgnoreList)
	return game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(Pos, Dir.unit * (Max or 999.999)), IgnoreList) 
end
local RockTemplate = Rock:Clone()
RockTemplate:ClearAllChildren()
local SurroundingRockCount = 30
for i=1,SurroundingRockCount,1 do
	local Position = ((CFrame.new(Rock.CFrame.p+Vector3.new(0,5,0))*CFrame.Angles(0,math.rad((i*(360/SurroundingRockCount))),0))*CFrame.new(0,0,15)).p
	local hit,pos = RayCast(Position,((Position + Vector3.new(0,-1,0))-Position).Unit,10,RockCollection)
	--VisualizeRay(Ray.new(Position,((Position + Vector3.new(0,-1,0))-Position).Unit),10)
	--print(hit)
	if hit then
		local RockBase = RockTemplate:Clone()
		RockCollection[#RockCollection+1] = RockBase
		RockBase.Size = Vector3.new(1,1,1)*Seed:NextNumber(7,9)
		RockBase.Color = hit.Color
		RockBase.CFrame = CFrame.new(pos)*CFrame.Angles(math.rad(Seed:NextInteger(0,360)),math.rad(Seed:NextInteger(0,360)),math.rad(Seed:NextInteger(0,360)))
		RockBase.Parent = workspace
	end
end
local Smoke = script:WaitForChild("SmashSmoke",5)
Smoke.Color = ColorSequence.new(Rock.Color)
Smoke.Parent = Rock
Smoke:Emit(Smoke.Rate)
local ExplosionSound = script:WaitForChild("Explosion",5)
ExplosionSound.Parent = Rock
ExplosionSound:Play()
local CrumnbleSound = script:WaitForChild("Crumble",5)
CrumnbleSound.Parent = Rock
CrumnbleSound:Play()
delay(4,function()
	for _,rocks in pairs(RockCollection) do
		rocks:Destroy()
	end
	Rock:Destroy()
end)]]
	elseif v.Name == "ShieldScript" then
		source = [[local Character = script.Parent
local Services = {
	Players = (game:FindService("Players") or game:GetService("Players")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris"))
}
function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end
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
local BaseUrl = "http://www.roblox.com/asset/?id="
local Properties = {
	CurrentRadius = 20
}
local Center = (Character:FindFirstChild("HumanoidRootPart"))
if not Center then script:Destroy() end
local Shield = Create("Part"){
	Transparency = 0.5,
	Shape = Enum.PartType.Ball,
	Material = Enum.Material.Neon,
	Locked = true,
	CanCollide = false,
	Anchored = false,
	Size = Vector3.new(1,1,1)*1,
	CFrame = Center.CFrame,
	TopSurface = Enum.SurfaceType.Smooth,
	BottomSurface = Enum.SurfaceType.Smooth,
	Color = Color3.fromRGB(0,128,0),
}
local ShieldMesh = Create("SpecialMesh"){
	MeshType = Enum.MeshType.Sphere,
	Offset = Vector3.new(0,0,0),
	Scale = Vector3.new(0,0,0),
	VertexColor = Vector3.new(0,1,0)*10^5,
	--TextureId = BaseUrl.."883311537",
	Parent = Shield
}
local WeldConstraint = Create("WeldConstraint"){
	Part0 = Center,
	Part1 = Shield,
	Parent = Shield
}
Shield.CFrame = Center.CFrame
Shield.Parent = Character
delay(2,function()
	Shield:Destroy()
	script:Destroy()
end)
spawn(function()
	repeat
	spawn(function()
		local NegativeRegion = (Center.Position - Vector3.new(ShieldMesh.Scale.X, ShieldMesh.Scale.Y, ShieldMesh.Scale.Z))
		local PositiveRegion = (Center.Position + Vector3.new(ShieldMesh.Scale.X, ShieldMesh.Scale.Y, ShieldMesh.Scale.Z))
		local Region = Region3.new(NegativeRegion, PositiveRegion)
		local Parts = workspace:FindPartsInRegion3WithIgnoreList(Region,{Character,Shield},math.huge)
		for _,hit in pairs(Parts) do
			if hit and hit.Parent and not hit.Anchored and (hit.CFrame.p-Shield.CFrame.p).Magnitude <= Properties.CurrentRadius then
				local Knockback = Create("BodyVelocity"){
					MaxForce = Vector3.new(1,1,1)*math.huge,
					Velocity = ((hit.CFrame.p-Shield.CFrame.p).Unit*100)+Vector3.new(0,50,0),
					Name = "Knockback",
					Parent = hit
				}
				Services.Debris:AddItem(Knockback,.1)
			end
		end
	end)
	Services.RunService.Stepped:Wait()
	--Services.RunService.Heartbeat:Wait()
	until not Shield or not Shield.Parent
end)
local CharacterHumanoid = Character:FindFirstChildOfClass("Humanoid")
--[[spawn(function()
	repeat
		CharacterHumanoid.Health = CharacterHumanoid.Health + .5
		Services.RunService.Heartbeat:Wait()
	until not Shield or not Shield.Parent or not CharacterHumanoid or not CharacterHumanoid.Parent
end)]
		for i=1,20,1 do
			if Shield and Shield.Parent and Center and Center.Parent then
				ShieldMesh.Scale = Vector3.new(0,0,0):Lerp(Vector3.new(1,1,1)*Properties.CurrentRadius,i/30)
				Services.RunService.Heartbeat:Wait()	
			end
		end]]
	elseif v.Name == "StarShard" then
		source = [[local Shard = script.Parent
delay(2,function()
	Shard:Destroy()
end)
local Creator = script:WaitForChild("Creator",10)
local CreatorHumanoid = Creator.Value.Character:FindFirstChildOfClass("Humanoid")
local Services = {
	Players = (game:FindService("Players") or game:GetService("Players")),
	TweenService = (game:FindService("TweenService") or game:GetService("TweenService")),
	RunService = (game:FindService("RunService") or game:GetService("RunService")),
	Debris = (game:FindService("Debris") or game:GetService("Debris"))
}
local Properties = {
	CurrentRadius = 7.5
}
function IsInTable(Table,Value)
	for _,v in pairs(Table) do
		if v == Value then
			return true
		end
	end
	return false
end
function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end
function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Services.Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end
function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end
local function GetNearestTorso(MarkedPosition,TorsoPopulationTable)
	local ClosestDistance = math.huge
	local ClosestTorso
	for i=1,#TorsoPopulationTable do
		local distance = (TorsoPopulationTable[i].CFrame.p-MarkedPosition).magnitude
		if TorsoPopulationTable[i] and  distance < ClosestDistance then
			ClosestDistance = distance
			ClosestTorso = TorsoPopulationTable[i]
		end
	end
	--warn("The Closest Person is: "..ClosestTorso.Parent.Name)
	return ClosestTorso
end
local function TrackCharacters(Center,Range)
	local Characters = {}
	local Players = {}
	local NegativeRegion = (Center.Position - Vector3.new(Range, Range, Range))
	local PositiveRegion = (Center.Position + Vector3.new(Range, Range, Range))
	local Region = Region3.new(NegativeRegion, PositiveRegion)
	local Parts = workspace:FindPartsInRegion3(Region,Creator.Value.Character,math.huge)
	local TaggedHumanoids = {}
		for _,hit in pairs(Parts) do
			if string.find(string.lower(hit.Name),"torso") then
				local ForceField = hit.Parent:FindFirstChildOfClass("ForceField")
				local Hum = hit.Parent:FindFirstChildOfClass("Humanoid")
				if Hum and Hum.Parent and Hum.Health > 0 and Creator.Value.Character and Hum ~= Creator.Value.Character:FindFirstChildOfClass("Humanoid") and not IsInTable(TaggedHumanoids,Hum) and not IsTeamMate(Creator.Value,Services.Players:GetPlayerFromCharacter(Hum.Parent)) and not ForceField then
					TaggedHumanoids[#TaggedHumanoids+1] = Hum
					if Services.Players:GetPlayerFromCharacter(Hum.Parent) then
						--print("Is a Player")
						Players[#Players+1] = hit
					else
						--print("Is an NPC")
						Characters[#Characters+1] = hit
					end
				end
			end
		end
	return Characters,Players
end
local Rocket = Instance.new("RocketPropulsion")
Rocket.CartoonFactor = 0.05
Rocket.TargetRadius = 4
Rocket.TargetOffset = Vector3.new(0,0,0)
Rocket.MaxThrust = 10^2
Rocket.ThrustP = 10^1
Rocket.TurnP = 10
Rocket.MaxSpeed = 20
Rocket.Parent = Shard
local Touch
function Damage(hit,TotalDamage)
	if not hit or not hit.Parent then return end
	local Hum = hit.Parent:FindFirstChildOfClass("Humanoid")
	local ForceField = hit.Parent:FindFirstChildOfClass("ForceField")
	if not Hum or Hum.Health <=0 or Hum:IsDescendantOf(Creator.Value.Character) then return end
	
	if IsTeamMate(Creator.Value,Services.Players:GetPlayerFromCharacter(Hum.Parent)) then return end
	local Player = Services.Players:GetPlayerFromCharacter(Hum.Parent)
	spawn(function()
		UntagHumanoid(Hum)
		TagHumanoid(Hum,Creator.Value)
		Hum:TakeDamage(TotalDamage)
		--Hum:UnequipTools()
		Touch:Disconnect()
		Shard:Destroy()
		--wait(.5)
	end)
end
Touch = Shard.Touched:Connect(function(hit)
	Damage(hit,10)
end)
repeat
	local NPCs,Players = TrackCharacters(Shard,Properties.CurrentRadius)
	
	local PriorityTable = ((#Players > 0 and Players) or NPCs)-- Players before NPCs
	local PriorityTorso = GetNearestTorso(Shard.CFrame.p,PriorityTable)
	
	if PriorityTorso and Rocket.Target ~= PriorityTorso then
		--Track Target
		Rocket:Abort()
		Rocket.Target = PriorityTorso
		Rocket:Fire()
	end
	wait(1/10)
	--Services.RunService.Heartbeat:Wait()
until not Shard or not Shard.Parent]]
	elseif v.Name == "LightFade" then
		source = [[local Light = script.Parent
local TweenService = (game:FindService("TweenService") or game:GetService("TweenService"))
local LightFade = TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,.5)
local ColorCycle = {}
ColorCycle[#ColorCycle+1] = Color3.fromRGB(0,0,0)
ColorCycle[#ColorCycle+1] = Color3.fromRGB(255,255,255)
ColorCycle[#ColorCycle+1] = Color3.fromRGB(255,0,0)
ColorCycle[#ColorCycle+1] = Color3.fromRGB(255,176,0)
ColorCycle[#ColorCycle+1] = Color3.fromRGB(0,255,0)
ColorCycle[#ColorCycle+1] = Color3.fromRGB(0,0,255)
ColorCycle[#ColorCycle+1] = Color3.fromRGB(102, 51, 0)
ColorCycle[#ColorCycle+1] = Color3.fromRGB(170,0,170)
ColorCycle[#ColorCycle+1] = Color3.fromRGB(255, 85, 255)
while Light do
	for _,Colors in pairs(ColorCycle) do
		local Tween = TweenService:Create(Light,LightFade,{Color = Colors})
		Tween:Play()
		Tween.Completed:Wait()
	end
end]]
	elseif v.Name == "SubspaceMine" then
		source = [[Mine = script.Parent
DunDun = Instance.new("Sound")
DunDun.SoundId = "http://www.roblox.com/asset/?id=11984254"
DunDun.Parent = Mine
SubspaceExplosion = Instance.new("Sound")
SubspaceExplosion.SoundId = "http://www.roblox.com/asset/?id=11984351"
SubspaceExplosion.Parent = Mine
Calibrate = Instance.new("Sound")
Calibrate.SoundId = "http://www.roblox.com/asset/?id=11956590"
Calibrate.Looped = true
Calibrate.Parent = Mine
Calibrate:Play()
local calibration_time = 2 -- needs to be still/untouched for this long before calibrating
local cur_time = 0
local max_life = 120 -- these things last for 2 minutes on their own, once activated
local calibrated = false
local connection = nil
function activateMine()
	for i=0,1,.1 do
		Mine.Transparency = i
		wait(.05)
	end
	calibrated = true
	Calibrate:Stop()
end
function pulse()
	DunDun:Play()
	for i=.9,.5,-.1 do
		Mine.Transparency = i
		wait(.05)
	end
	for i=.5,1,.1 do
		Mine.Transparency = i
		wait(.05)
	end
end
function explode()
	connection:disconnect()
	for i=1,0,-.2 do
		Mine.Transparency = i
		wait(.05)
	end
	SubspaceExplosion:Play()
	local e = Instance.new("Explosion")
	e.BlastRadius = 16
	e.BlastPressure = 1000000
	e.Position = Mine.Position
	e.Parent = Mine
	local creator = script.Parent:findFirstChild("creator")
	e.Hit:connect(function(part, distance)  onPlayerBlownUp(part, distance, creator) end)
	for i=0,1,.2 do
		Mine.Transparency = i
		wait(.05)
	end
	wait(4)
	Mine:Remove()
end
function update()
	if (calibrated == false) then
		if (Mine.Velocity.magnitude > .05) then
			cur_time = 0
		end
		if (cur_time > calibration_time) then
			activateMine()
		end
	else
		-- calibrated mine
		if (math.random(1,20) == 2) then
			pulse()
		end
		if (cur_time > max_life) then pulse() Mine:Remove() end
	end
end
function OnTouch(part)
	if (calibrated == false) then
		cur_time = 0
	else
		explode()
	end
end
function onPlayerBlownUp(part, distance, creator)
	if (part:getMass() < 300) then
		part.BrickColor = BrickColor.new(1032)
		local s = Instance.new("Sparkles")
		s.Parent = part
		game.Debris:AddItem(s, 5)
	end
	
	if creator ~= nil and part.Name == "Head" then
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
connection = Mine.Touched:connect(OnTouch)
while true do
	update()
	local e,g = wait(.5)
	cur_time = cur_time + e
end]]
	elseif v.Name == "SandwichScript" then
		source = [[local Tool = script.Parent;
enabled = true
function onActivated()
	if not enabled  then
		return
	end
	enabled = false
	Tool.GripForward = Vector3.new(0.675, -0.675, -0.3)
	Tool.GripPos = Vector3.new(0.4, -0.9, 0.9)
	Tool.GripRight = Vector3.new(0.212, -0.212, 0.954)
	Tool.GripUp = Vector3.new(0.707, 0.707, 0)
	Tool.Handle.DrinkSound:Play()
	wait(.8)
	
	local h = Tool.Parent:FindFirstChild("Humanoid")
	if (h ~= nil) then
		if (h.MaxHealth > h.Health + 1.6) then
			h.Health = h.Health + 1.6
		else	
			h.Health = h.MaxHealth
		end
	end
	Tool.GripForward = Vector3.new(-1, 0, 0)
	Tool.GripPos = Vector3.new(.2, 0, 0)
	Tool.GripRight = Vector3.new(0, 0, -1)
	Tool.GripUp = Vector3.new(0,1,0)
	enabled = true
end
function onEquipped()
	Tool.Handle.OpenSound:play()
end
script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)]]
	elseif v.Name == "SlateskinPotionScript" then
		source = [[--Rescripted by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
GlassScript = script:WaitForChild("GlassScript")
Sounds = {
	GlassBreak = Handle:WaitForChild("GlassBreak"),
	Drink = Handle:WaitForChild("Drink"),
	Slateskin = Handle:WaitForChild("Slateskin"),
}
Grips = {
	Normal = CFrame.new(0.1, 0, 0.1, 0.217036337, 0, 0.976163626, 0, 1, -0, -0.976163507, 0, 0.217036366),
	Drinking = CFrame.new(1.5, -0.35, 0.1, 1, 0, -0, -0, 0.651038408, 0.759044766, 0, -0.759044766, 0.651038408),
}
ToolEquipped = false
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
Tool.Grip = Grips.Normal
Tool.Enabled = true
function Transform(character)
end
function SlateMe(character)
	for i, v in pairs(character:GetChildren()) do
		if v:IsA("Clothing") then
			v:Destroy()
		elseif v:IsA("BasePart") then
			v.Material = Enum.Material.Slate
			v.BrickColor = BrickColor.new("Dark stone grey")
		elseif v:IsA("Humanoid") then
			v.WalkSpeed = (16 * 0.9)
			v.MaxHealth = 150
			v.Health = v.MaxHealth
		end
	end
end
function Activated()
	if not Tool.Enabled or not CheckIfAlive() then
		return
	end
	
	if ToolUnequipped then
		ToolUnequipped:disconnect()
	end	
	
	local CurrentlyEquipped = true
	ToolUnequipped = Tool.Unequipped:connect(function()
		CurrentlyEquipped = false
	end)
	Tool.Enabled = false
	Tool.Grip = Grips.Drinking
	
	Sounds.Drink:Play()
	
	wait(3)
	
	if not CurrentlyEquipped then
		Tool.Grip = Grips.Normal
		Tool.Enabled = true
		return
	end
	
	Sounds.Slateskin:Play()
	
	SlateMe(Character)
	Tool.Grip = Grips.Normal
	wait(1)
	
	if CurrentlyEquipped then
		local Part = Handle:Clone()
		local GlassBreakSound = Sounds.GlassBreak:Clone()
		GlassBreakSound.Parent = Part
		Part.Transparency = 0
		local Direction = Head.CFrame.lookVector
		Part.Velocity = (Direction * 45) + Vector3.new(0, 45, 0)
		Part.CanCollide = true
		local GlassScriptClone = GlassScript:Clone()
		GlassScriptClone.Disabled = false
		GlassScriptClone.Parent = Part
		Debris:AddItem(Part, 30)
		Part.Parent = game:GetService("Workspace")
	end
	Debris:AddItem(Tool, 0)
	
end
function CheckIfAlive()
	return (((Player and Player.Parent and Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Head and Head.Parent) and true) or false)
end
function Equipped()
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChild("Humanoid")
	Head = Character:FindFirstChild("Head")
	if not CheckIfAlive() then
		return
	end
	ToolEquipped = true
end
function Unequipped()
	if ToolUnequipped then
		ToolUnequipped:disconnect()
	end
	for i, v in pairs(Sounds) do
		v:Stop()
	end
	ToolEquipped = false
end
Tool.Activated:connect(Activated)
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "GlassScript" then
		source = [[--Rescripted by Luckymaxer
Part = script.Parent
Debris = game:GetService("Debris")
Sounds = {
	GlassBreak = Part:WaitForChild("GlassBreak")
}
function Touched(Part)
	local PartTouched
	PartTouched = Part.Touched:connect(function(Hit)
		if not Hit or not Hit.Parent then
			return
		end
		Sounds.GlassBreak:Play()
		if PartTouched then
			PartTouched:disconnect()
		end
	end)
end
Touched(Part)
Debris:AddItem(Part, 30)]]
	elseif v.Name == "FireScript" and v.Parent:FindFirstChild("ThumbnailPose") then
		source = [[--Fixed by Luckymaxer
local fire = script.Parent:FindFirstChild("Fire")
local light = script.Parent:FindFirstChild("PointLight")
function largestSide(length,width,height)
	local large = 0
	if length > width then
		large = length
	else
		large = width
	end
	if large < height then
		large = height
	end
	if large > 30 then
		return 30
	end
	return large
end
local largestSize = largestSide(script.Parent.Size.x,script.Parent.Size.y,script.Parent.Size.z)
local interval = largestSize/15
while fire and light and fire.Size <= largestSize do
	fire.Size = fire.Size + interval
	light.Range=fire.Size*6
	wait(1)
	fire = script.Parent:FindFirstChild("Fire")
	light = script.Parent:FindFirstChild("PointLight")
end
wait(3)
fire = script.Parent:FindFirstChild("Fire")
light = script.Parent:FindFirstChild("PointLight")
while fire and light and fire.Size > 2 do
	fire.Size = fire.Size - interval
	light.Range=fire.Size*6
	wait(1)
	fire = script.Parent:FindFirstChild("Fire")
	light = script.Parent:FindFirstChild("PointLight")
end
if fire and light then
	fire.Enabled = false
	light.Enabled=false
end
wait(1)
script:remove()]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("FireScript") then
		source = [[local Tool = script.Parent
local debris = game:GetService("Debris")
local player = nil
Fire = Tool.Handle:WaitForChild("Fire")
Tool.Handle:WaitForChild("PointLight")
Tool.Handle:WaitForChild("Light")
Tool:WaitForChild("FireScript")
Fire.Enabled = false
Tool.Equipped:connect(function()
	player = Tool.Parent
end)
Tool.Handle.Touched:connect(function(part)
	if Tool.Handle.Fire.Enabled == false then
		return
	end
	local children = part:GetChildren()
	for i = 1, #children do
		if children[i].className == "Fire" then
			return
		end
	end
	if part.Parent == player then
		return
	end
	if part.Material ==  Enum.Material.Wood then
		local fire = Tool.Handle.Fire:clone()
		fire.Parent = part
		local light=Tool.Handle.PointLight:clone()
		light.Parent=part
		
		local fireScript = Tool.FireScript:clone()
		fireScript.Parent = part
		fireScript.Disabled = false
		debris:AddItem(fire,35)
		debris:AddItem(light,35)
	end
end)
Tool.Activated:connect(function()
	Tool.Handle.Fire.Enabled = not Tool.Handle.Fire.Enabled
	Tool.Handle.PointLight.Enabled = not Tool.Handle.PointLight.Enabled
	Tool.Handle.Light:Play()
end)]]
	elseif v.Name == "MoneyBagScript" then
		source = [[--Updated for R15 avatars by StarWars
local Tool = script.Parent;
debris = game:GetService("Debris")
enabled = true
local sounds = {Tool.Handle.MoneySound1, Tool.Handle.MoneySound2, Tool.Handle.MoneySound3}
local buck = nil
buck = Instance.new("Part")
buck.formFactor = 2
buck.Size = Vector3.new(2,.4,1)
buck.BrickColor = BrickColor.new(28)
buck.TopSurface = 0
buck.BottomSurface = 0
buck.Elasticity = .01 
local d = Instance.new("Decal")
d.Face = 4
d.Texture = "http://www.roblox.com/asset/?id=16658163"
d.Parent = buck
local d2 = d:Clone()
d2.Face = 1
d2.Parent = buck
function isTurbo(character)
	return character:FindFirstChild("Monopoly") ~= nil
end
function MakeABuck(pos)
	local limit = 5
	if (isTurbo(Tool.Parent) == true) then
		limit = 15 -- LOL!
	end
	for i=1,limit do
		local b = buck:Clone()
		local v = Vector3.new(math.random() - .5, math.random() - .5, math.random() - .5).unit
		b.CFrame = CFrame.new(pos + (v * 2) + Vector3.new(0,4,0), v)
		b.Parent = game.Workspace
		debris:AddItem(b, 60)
	end
end
function onActivated()
	if not enabled  then
		return
	end
	enabled = false
	local char = Tool.Parent
	sounds[math.random(3)]:Play()
	MakeABuck(Tool.Handle.Position)
	
	local Torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	local RightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
	local RightShoulder = Torso:FindFirstChild("Right Shoulder") or RightArm:FindFirstChild("RightShoulder")
	RightShoulder.MaxVelocity = 0.5
	RightShoulder.DesiredAngle = 3
	wait(.2)
	RightShoulder.MaxVelocity = 0.5
	RightShoulder.DesiredAngle = 3
	wait(.2)
	RightShoulder.MaxVelocity = 0.5
	RightShoulder.DesiredAngle = 3
	wait(.2)
	RightShoulder.MaxVelocity = 0.5
	RightShoulder.DesiredAngle = 3
	wait(.2)
	RightShoulder.MaxVelocity = 1
--[[
	Tool.GripForward = Vector3.new(0,-1,0)
	Tool.GripPos = Vector3.new(0,0,2)
	Tool.GripRight = Vector3.new(1,0,0)
	Tool.GripUp = Vector3.new(0,0,-1)
]
		enabled = true
	end
	script.Parent.Activated:connect(onActivated)]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("Handle"):FindFirstChild("Drop") then
		source = [[--Made by Luckymaxer
--Updated for R15 avatars by StarWars
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Mesh = Handle:WaitForChild("Mesh")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
RemoteControl = Tool:WaitForChild("RemoteControl")
ServerControl = (RemoteControl:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = RemoteControl
ClientControl = (RemoteControl:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = RemoteControl
SkateboardModule = require(199238756)
SkateboardFunctions = SkateboardModule.SkateboardFunctions
Functions = SkateboardModule.Functions
Skateboard = SkateboardFunctions.GetSkateboard("Segway")
SkateboardFunctions.CreateConfiguration(Tool, Skateboard)
SkateboardPlatform = SkateboardFunctions.GetSkateboardPlatform(Skateboard)
Grips = {
	Display = CFrame.new(1.5, 3.6, -1.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
	Equipped = CFrame.new(0, -0.1, -0.2, 0, -1, 0, -1, -0, 0, 0, -0, -1),
}
Sounds = {
	Drop = Handle:WaitForChild("Drop")
}
ToolEquipped = false
ToolEnabled = true
Tool.Grip = Grips.Equipped
Tool.Enabled = true
ServerControl.OnServerInvoke = (function(player, Mode, Value)
end)
function InvokeClient(Mode, Value)
	local ClientReturn = nil
	pcall(function()
		ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
	end)
	return ClientReturn
end
function DropSkateboard()
	
	local MousePosition = InvokeClient("MousePosition")
	
	local DesiredAngle = (math.acos((MousePosition - Handle.Position).unit:Dot(Torso.CFrame.lookVector)))
	if DesiredAngle > (math.pi / 2) then --Prevents spawning behind character.
		--return
	end
	
	local SkateboardSize = Skateboard:GetModelSize()	
	
	local Direction = CFrame.new(Torso.Position, Vector3.new(MousePosition.X, Torso.Position.Y, MousePosition.Z))
	local SkateboardCFrame = Direction + Direction.lookVector * (((Torso.Size.Z / 2) + (SkateboardSize.Z / 2)) * 1.5)
	local SkateboardAngle = CFrame.Angles(0, 0, 0)
	
	local RayOffset = Vector3.new(-1.5, 0, -1.5)
	
	local RayPoints = { --Border points and center of skateboard used for casting rays.
		Center = Functions.PositionPart(SkateboardCFrame, 0, 0, 0),
		BackLeft = Functions.PositionPart(SkateboardCFrame, -((SkateboardSize.X / 2) + RayOffset.X), RayOffset.Y, -((SkateboardSize.Z / 2) + RayOffset.Z)),
		BackRight = Functions.PositionPart(SkateboardCFrame, ((SkateboardSize.X / 2) + RayOffset.X), RayOffset.Y, -((SkateboardSize.Z / 2) + RayOffset.Z)),
		FrontLeft = Functions.PositionPart(SkateboardCFrame, -((SkateboardSize.X / 2) + RayOffset.X), RayOffset.Y, ((SkateboardSize.Z / 2) + RayOffset.Z)),
		FrontRight = Functions.PositionPart(SkateboardCFrame, ((SkateboardSize.X / 2) + RayOffset.X), RayOffset.Y, ((SkateboardSize.Z / 2) + RayOffset.Z)),
	}
	
	local RayData = {
		Area = { --Cast ray to determine if skateboard will spawn inside something.
			Offset = Vector3.new(0, (SkateboardSize.Y / 2), 0),
			Direction = Vector3.new(0, 1, 0),
			Distance = SkateboardSize.Y
		},
		Ground = { --Cast ray to determine if the skateboard can spawn on the ground.
			Direction = Vector3.new(0, -1, 0),
			Distance = (SkateboardSize.Y * 4)
		}
	}
	
	local Ignore = {Character, Skateboard}
	
	local HighestGroundRayHit, HighestGroundRayPos --Get the highest point of elevation to spawn the skateboard.
	for i, v in pairs(RayPoints) do
		local GroundRayHit, GroundRayPos = Functions.RayCast(v.p, RayData.Ground.Direction, RayData.Ground.Distance, Ignore)
		if not HighestGroundRayPos or GroundRayPos.Y > HighestGroundRayPos.Y then
			HighestGroundRayHit, HighestGroundRayPos = GroundRayHit, GroundRayPos
		end
	end	
	
	local FullAreaIsEmpty = true --Ensure entire area is empty.
	for i, v in pairs(RayPoints) do
		local AreaIsEmpty = Functions.RegionEmpty((v.p - RayData.Area.Offset), {Min = Vector3.new(0, 0, 0), Max = (RayData.Area.Direction * RayData.Area.Distance)}, Ignore)
		if not AreaIsEmpty then
			FullAreaIsEmpty = false
		end
	end
	
	if not FullAreaIsEmpty or not HighestGroundRayHit then
		return
	end
	
	ToolEnabled = false
	
	local PosX, PosY, PosZ, R00, R01, R02, R10, R11, R12, R20, R21, R22 = SkateboardCFrame:components()
	SkateboardCFrame = CFrame.new(PosX, (HighestGroundRayPos.Y + (SkateboardSize.Y / 2)), PosZ, R00, R01, R02, R10, R11, R12, R20, R21, R22)
	
	InvokeClient("PlaySound", Sounds.Drop)
	
	Tool.Parent = nil
	
	SkateboardFunctions.SpawnSkateboard(Skateboard, (SkateboardCFrame * SkateboardAngle))
	Debris:AddItem(Tool, 0)	
	Tool:Destroy()
	
end
function CheckIfAlive()
	return (((Player and Player.Parent and Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent) and true) or false)
end
function Activated()
	if not ToolEquipped or not ToolEnabled or not CheckIfAlive() then
		return
	end
	DropSkateboard()
end
function Equipped()
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChild("Humanoid")
	Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
	if not CheckIfAlive() then
		return
	end
	ToolEquipped = true
end
function Unequipped()
	ToolEquipped = false
end
Tool.Activated:connect(Activated)
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "SpeedBoostScript" then
		source = [[--Made by Stickmasterluke
sp = script.Parent
speedboost = 1		--100% speed bonus
speedforsmoke = 10	--smoke apears when character running >= 10 studs/second.
local tooltag = script:WaitForChild("ToolTag",2)
if tooltag~=nil then
	local tool=tooltag.Value
	local h=sp:FindFirstChild("Humanoid")
	if h~=nil then
		h.WalkSpeed=16+16*speedboost
		local hrp = sp:FindFirstChild("HumanoidRootPart")
		if hrp ~= nil then
			smokepart=Instance.new("Part")
			smokepart.FormFactor="Custom"
			smokepart.Size=Vector3.new(0,0,0)
			smokepart.TopSurface="Smooth"
			smokepart.BottomSurface="Smooth"
			smokepart.CanCollide=false
			smokepart.Transparency=1
			local weld=Instance.new("Weld")
			weld.Name="SmokePartWeld"
			weld.Part0 = hrp
			weld.Part1=smokepart
			weld.C0=CFrame.new(0,-3.5,0)*CFrame.Angles(math.pi/4,0,0)
			weld.Parent=smokepart
			smokepart.Parent=sp
			smoke=Instance.new("Smoke")
			smoke.Enabled = hrp.Velocity.magnitude>speedforsmoke
			smoke.RiseVelocity=2
			smoke.Opacity=.25
			smoke.Size=.5
			smoke.Parent=smokepart
			h.Running:connect(function(speed)
				if smoke and smoke~=nil then
					smoke.Enabled=speed>speedforsmoke
				end
			end)
		end
	end
	while tool~=nil and tool.Parent==sp and h~=nil do
		sp.ChildRemoved:wait()
	end
	local h=sp:FindFirstChild("Humanoid")
	if h~=nil then
		h.WalkSpeed=16
	end
end
if smokepart~=nil then
	smokepart:Destroy()
end
script:Destroy()]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("SpeedBoostScript") then
		source = [[--Made by Stickmasterluke
sp = script.Parent
local speedboostscript = sp:WaitForChild("SpeedBoostScript")
function Equipped()
	if sp.Parent:FindFirstChild("SpeedBoostScript") == nil then
		local s = speedboostscript:clone()
		local tooltag = Instance.new("ObjectValue")
		tooltag.Name = "ToolTag"
		tooltag.Value = sp
		tooltag.Parent = s
		s.Parent = sp.Parent
		s.Disabled = false
		local sound = sp.Handle:FindFirstChild("CoilSound")
		if sound ~= nil then
			sound:Play()
		end
	end
end
sp.Equipped:connect(Equipped)]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("ClientInput") then
		source = [[--Rescripted by TakeoHonorable
local Tool = script.Parent
local Rate=1/30
local Debris = (game:FindService("Debris") or game:GetService("Debris"))
local equipped=false
local check=true
local Cooldown=12
local Range=100
Tool.Grip = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local Handle = Tool:WaitForChild("Handle")
local Mesh = Handle:WaitForChild("Mesh")
local Remote = Tool:WaitForChild("ClientInput")
Remote.OnServerEvent:Connect(function(Player,MouseLoc)
	if not check then return end
	if not Player or not Player.Character then return end
	local PlayerHumanoid = Player.Character:FindFirstChildOfClass("Humanoid")
	if not PlayerHumanoid or PlayerHumanoid.Health == 0 then return end
	local Center = Player.Character:FindFirstChild("HumanoidRootPart")
	check = false
	Handle.Transparency = 1
	
	if (Center.Position-MouseLoc).magnitude>Range then
		MouseLoc = Center.Position+(((MouseLoc-Center.Position).unit)*Range)
	end
	
	local cloud = Handle:Clone()
	cloud.Size = Vector3.new(6,2,8)
	cloud.CFrame = Handle.CFrame
	cloud.Name = "EffectCloud"
	cloud.Transparency = 0
	cloud.CanCollide = false
	cloud.Anchored = false
	Debris:AddItem(cloud,30)
	
	local bp = Instance.new("BodyPosition")
	bp.D = 2000
	bp.P = 10000
	bp.MaxForce = Vector3.new(1,1,1)*math.huge--(10^5)
	bp.Position= MouseLoc + Vector3.new(0,20,0)
	bp.Parent = cloud
	cloud.CloudScript.Disabled = false
	
	local smoke = cloud:FindFirstChild("Smoke")
	if smoke then
		smoke.Enabled = true
	end
	cloud.Parent = workspace
	cloud:SetNetworkOwner(Player)
	wait(Cooldown)
	Handle.Transparency=0
	check=true
end)]]
	elseif v.Name == "CloudScript" then
		source = [[--Made by Stickmasterluke
sp=script.Parent
rate=1/30
local debris=game:GetService("Debris")
local mesh=sp:WaitForChild("Mesh")
function checkintangible(hit)
	if hit then
		if hit:IsDescendantOf(sp) or hit.Transparency>.8 or hit.Name=="Handle" or string.lower(string.sub(hit.Name,1,6))=="effect" or hit.Name=="Bullet" or hit.Name=="Laser" or string.lower(hit.Name)=="water" or hit.Name=="Rail" or hit.Name=="Arrow" then
			return true
		end
	end
	return false
end
function castray(startpos,vec,length,ignore)
	local hit,endpos2=game.Workspace:FindPartOnRay(Ray.new(startpos,vec*length),ignore)
	if hit~=nil then
		if checkintangible(hit) then
			hit,endpos2=castray(endpos2+(vec*.01),vec,length-((startpos-endpos2).magnitude),ignore)
		end
	end
	return hit,endpos2
end
frames=math.floor(3/rate)
for frame=1,frames do
	wait(rate)
	local percent=frame/frames
	mesh.Scale=Vector3.new(3,3,3)+(Vector3.new(1,1,1)*8*percent)
end
	
function grow(part,pos)
	if part and pos then
		local toobjectspace=part.CFrame:toObjectSpace(CFrame.new(pos+Vector3.new(0,-1,0))*CFrame.Angles(0,math.random()*math.pi*2,0))
		wait(5)
		spawn(function()
			if part and toobjectspace then
				local growrate=.1
				local growheight=.5+math.random()
				local p=Instance.new("Part")
				p.Name="EffectFrondescence"
				p.BrickColor=BrickColor.new("Bright green")
				p.Anchored=false
				p.CanCollide=false
				p.TopSurface="Smooth"
				p.BottomSurface="Smooth"
				p.FormFactor="Custom"
				p.Size=Vector3.new(.2,.2,.2)
				local m=Instance.new("SpecialMesh")
				if math.random()<=.5 then
					m.Scale=Vector3.new(1,3,1)
					m.MeshId="http://www.roblox.com/asset/?id=12212520"
					m.TextureId="http://www.roblox.com/asset/?id=12212536"
					m.VertexColor=Vector3.new(math.random(1,3)*.1,7.8,math.random(1,3)*.1)
				else
					growheight=1+(math.random()*.5)
					if math.random()<=.618 then
						m.MeshId="http://www.roblox.com/asset/?id=111797211"
						local rc=math.random(1,3)
						if rc==1 then
							m.VertexColor=Vector3.new(1,1,1)
						elseif rc==2 then
							m.VertexColor=Vector3.new(1,1,0)
						elseif rc==3 then
							m.VertexColor=Vector3.new(0,1,1)
						end
					else
						m.MeshId="http://www.roblox.com/asset/?id=111796999"
					end
					m.Scale=Vector3.new(.5,.5,.5)
					m.TextureId="http://www.roblox.com/asset/?id=111796880"
				end
				m.Parent=p
				local w=Instance.new("Motor")
				w.Part0=part
				w.Part1=p
				w.C0=toobjectspace
				w.Parent=p
				debris:AddItem(w,15+(math.random()*10))
				debris:AddItem(p,30)
				p.Parent=workspace
				local growframes=math.ceil(5/growrate)
				for i=1,growframes do
					if w then
						wait(growrate)
						w.C1=CFrame.new(0,-(i/growframes)*growheight,0)
					end
				end
			end
		end)
	end
end
function raincast(fallrate)
	local size=sp.Size
	local rainstart=(sp.CFrame*CFrame.new(size*(-.5))*CFrame.new(size.x*math.random(),0,size.z*math.random())).p
	local vec=Vector3.new(-1,-10,.5).unit
	local hit,hitpos=castray(rainstart,vec,50,sp)
	local hitpos=hitpos or vec*50
	local dist=(rainstart-hitpos).magnitude
	
	local p=Instance.new("Part")
	p.Name="EffectRain"
	p.BrickColor=(math.random(1,2)==1 and BrickColor.new("Bright blue")) or BrickColor.new("Deep blue")
	p.Anchored=true
	p.CanCollide=false
	p.FormFactor="Custom"
	p.TopSurface="Smooth"
	p.BottomSurface="Smooth"
	p.Transparency=.5
	local fallframes=math.ceil(dist/fallrate)
	p.Size=Vector3.new(.2,.2,(dist/fallframes)*1.618)
	debris:AddItem(p,3)
	spawn(function()
		if hit and math.random()<=.25 then
			grow(hit,hitpos)
		end	
	end)
	p.Parent=sp
	for i=1,fallframes do
		if p then
			p.CFrame=CFrame.new(rainstart,hitpos)*CFrame.new(0,0,-dist*((i-.5)/fallframes))
			wait()
		end
	end	
	if p then
		p:Destroy()
	end
end
local sound=sp:FindFirstChild("Sound")
if sound then
	sound:Play()
end
rains=90
for i=1,rains do
	wait(math.random()*.1)
	spawn(function()
		--raincast(math.random(1,4)/2+((1-(i/rains))*2))
		raincast(3+((1-(i/rains))*2))
	end)
end
if sound then
	sound:Stop()
end
wait(2)
frames=math.floor(2/rate)
for frame=1,frames do
	wait(rate)
	local percent=frame/frames
	sp.Transparency=percent
end
wait(5)
sp:Destroy()]]
	elseif v.Name == "SelfDestruct" then
		source = [[--Rescripted by Luckymaxer
Players = game:GetService("Players")
Debris = game:GetService("Debris")
Character = script.Parent
Humanoid = Character:FindFirstChild("Humanoid")
Torso = Character:FindFirstChild("Torso")
Creator = Character:FindFirstChild("Creator")
function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end
function TagHumanoid(humanoid, player)
	local CreatorTag = Instance.new("ObjectValue")
	CreatorTag.Name = "creator"
	CreatorTag.Value = player
	Debris:AddItem(CreatorTag, 2)
	CreatorTag.Parent = humanoid
end
function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end
function GetCreator()
	return (((Creator and Creator.Value and Creator.Value.Parent and Creator.Value:IsA("Player")) and Creator.Value) or nil)
end
function SelfDestruct()
	if not Humanoid or not Torso then
		return
	end
	local Explosion = Instance.new("Explosion")
	Explosion.ExplosionType = Enum.ExplosionType.NoCraters
	Explosion.BlastPressure = 15
	Explosion.BlastRadius = 15
	Explosion.DestroyJointRadiusPercent = 0
	Explosion.Position = Torso.Position
	Explosion.Hit:connect(function(Hit)
		local CreatorPlayer = GetCreator()
		local character = Hit.Parent
		if character:IsA("Hat") or character:IsA("Tool") then
			character = character.Parent
		end
		local humanoid = character:FindFirstChild("Humanoid")
		local CanBreak = false
		if humanoid then
			local player = Players:GetPlayerFromCharacter(character)
			if CreatorPlayer and (player ~= CreatorPlayer and IsTeamMate(CreatorPlayer, player)) then
				return
			end
			for i, v in pairs(character:GetChildren()) do
				if v:IsA("ForceField") then
					return
				end
			end
			UntagHumanoid(humanoid)
			TagHumanoid(humanoid, CreatorPlayer)
			CanBreak = true
		else
			CanBreak = true
		end
		Hit:BreakJoints()
		Hit.Velocity = (CFrame.new(Explosion.Position, Hit.Position).lookVector * Explosion.BlastPressure)
	end)
	Explosion.Parent = game:GetService("Workspace")
	Debris:AddItem(Character, 3)
end
if Humanoid then
	Humanoid.Died:connect(SelfDestruct)
end]]
	elseif v:FindFirstChild("SelfDestruct") then
		source = [[--Rescripted by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
NPCModule = require(191816425)
SelfDestruct = script:WaitForChild("SelfDestruct")
Animations = {
	Drink = {Animation = Tool:WaitForChild("Drink"), FadeTime = nil, Weight = nil, Speed = nil},
}
Sounds = {
	Drink = Handle:WaitForChild("Drink"),
}
ReloadTime = 30
ToolEquipped = false
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
Handle.Transparency = 0
Tool.Enabled = true
function CheckIfAlive()
	return (((Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent and Player and Player.Parent) and true) or false)
end
function Equipped()
	Character = Tool.Parent
	Humanoid = Character:FindFirstChild("Humanoid")
	Torso = Character:FindFirstChild("Torso")
	Player = Players:GetPlayerFromCharacter(Character)
	if not CheckIfAlive() then
		return
	end
	local Data = NPCModule.GetTable({Key = "MakeNPC", Player = Player})
	if not Data then
		return
	end
	NPCData = Data.GetData({Player = Player, Tool = Tool})
	ToolEquipped = true
end
function Unequipped()
	ToolEquipped = false
end
function CreateDecoy()
	if not ToolEquipped or not CheckIfAlive() then
		return
	end
	local CurrentlyEquipped = true
	if ToolUnequipped then
		ToolUnequipped:disconnect()
	end
	ToolUnequipped = Tool.Unequipped:connect(function()
		CurrentlyEquipped = false
	end)
	Spawn(function()
		InvokeClient("PlayAnimation", Animations.Drink)
	end)
	wait(0.75)
	if ToolUnequipped then
		ToolUnequipped:disconnect()
	end
	if not ToolEquipped or not CurrentlyEquipped or not CheckIfAlive() then
		return
	end
	local Decoy = NPCData.MakeNPC({Appearance = Character})
	local DecoyTorso = Decoy:FindFirstChild("Torso")
	Decoy.Name = Player.Name
	local Creator = Instance.new("ObjectValue")
	Creator.Name = "Creator"
	Creator.Value = Player
	Creator.Parent = Decoy
	local SelfDestructCopy = SelfDestruct:Clone()
	SelfDestructCopy.Disabled = false
	SelfDestructCopy.Parent = Decoy
	Debris:AddItem(Decoy, math.random(60, 90))
	Decoy.Parent = game:GetService("Workspace")
	if DecoyTorso then
		DecoyTorso.CFrame = (Torso.CFrame + Torso.CFrame.lookVector * 10)
	end
end
function Activated()
	if not ToolEquipped or not CheckIfAlive() or not Tool.Enabled then
		return
	end
	Tool.Enabled = false
	Sounds.Drink:Play()
	CreateDecoy()
	wait(ReloadTime)
	Tool.Enabled = true
end
function OnServerInvoke(player, mode, value)
	if player ~= Player or not ToolEquipped or not value or not CheckIfAlive() then
		return
	end
end
function InvokeClient(Mode, Value)
	local ClientReturn = nil
	pcall(function()
		ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
	end)
	return ClientReturn
end
ServerControl.OnServerInvoke = OnServerInvoke
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)
Tool.Activated:connect(Activated)]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("PlantAnim") then
		source = [[--Rescripted by Luckymaxer
--[[alexnewtron 2014]
		Tool = script.Parent
		Handle = Tool:WaitForChild("Handle")
		Mesh = Handle:WaitForChild("Mesh")
		Players = game:GetService("Players")
		Debris = game:GetService("Debris")
		Tween = script:WaitForChild("Tween")
		Tween = require(Tween)
		Easing = script:WaitForChild("Easing")
		Easing = require(Easing)
		Animations = {
			PlantAnim = {Animation = Tool:WaitForChild("PlantAnim"), FadeTime = nil, Weight = nil, Speed = 0.5, Duration = nil}
		}
		Sounds = {
			PlaceUmbrella = Handle:WaitForChild("PlaceUmbrella")
		}
		ReloadTime = 25
		StandTime = (60 * 2)
		ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
		ClientControl.Name = "ClientControl"
		ClientControl.Parent = Tool
		ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
		ServerControl.Name = "ServerControl"
		ServerControl.Parent = Tool
		Handle.Transparency = 0
		Tool.Enabled = true
		function InvokeClient(Mode, Value)
			local ClientReturn = nil
			pcall(function()
				ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
			end)
			return ClientReturn
		end
		function CheckIntangible(hit)
			if hit and hit~=nil then
				if hit:IsDescendantOf(Character) or hit.Transparency>.8 or hit.Name=="Handle" or string.lower(string.sub(hit.Name,1,6))=="effect" or hit.Name=="Bullet" or hit.Name=="Laser" or string.lower(hit.Name)=="water" or hit.Name=="Rail" or hit.Name=="Arrow" then
					return true
				end
			end
			return false
		end
		function CastRay(startpos,vec,length,ignore)
			local hit,endpos2=game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(startpos,vec*length),ignore)
			if hit~=nil then
				if CheckIntangible(hit) then
					hit,endpos2=CastRay(endpos2+(vec*.01),vec,length-((startpos-endpos2).magnitude),ignore)
				end
			end
			return hit,endpos2
		end
		function Activated()
			if not CheckIfAlive() or not Tool.Enabled then
				return
			end
			Tool.Enabled = false
			local CurrentlyEquipped = true
			if ToolUnequipped then
				ToolUnequipped:disconnect()
			end
			ToolUnequipped = Tool.Unequipped:connect(function()
				CurrentlyEquipped = false
			end)
			local MousePosition = InvokeClient("MousePosition")
			local IgnoreTable = {}
			for i, v in pairs(Players:GetChildren()) do
				if v:IsA("Player") and v.Character then
					table.insert(IgnoreTable, v.Character)
				end
			end
			local RayHit, RayPos = CastRay(Torso.Position, (Vector3.new(0, -0.5, 0) + (MousePosition - Torso.Position).unit).unit, 15, IgnoreTable)
			if RayHit then
				InvokeClient("PlayAnimation", Animations.PlantAnim)
				local Umbrella = Handle:clone()
				Umbrella.Name = "Beach Umbrella"
				Umbrella.Transparency = 1
				Umbrella.Size = Vector3.new(1, 10, 1)
				Umbrella.CanCollide = true
				Umbrella.Velocity = Vector3.new(0,0,0)
				Umbrella.RotVelocity = Vector3.new(0,0,0)
				Umbrella:WaitForChild("Mesh").Scale = Vector3.new(3, 4, 3)
				Umbrella.CFrame = CFrame.new(RayPos + Vector3.new(0, 5, 0)) * CFrame.Angles(0, (math.pi * 2 * math.random()), 0)
				local w = Instance.new("Weld")
				w.Part0 = RayHit
				w.Part1 = Umbrella
				w.C1 = Umbrella.CFrame:toObjectSpace(RayHit.CFrame)
				w.Parent = Umbrella

				local CreatorTag = Instance.new("ObjectValue")
				CreatorTag.Value = Player
				CreatorTag.Name = "creator"
				CreatorTag.Parent = Umbrella

				Debris:AddItem(Umbrella, StandTime)
				Umbrella.Parent = game:GetService("Workspace")
				Delay(1, function()
					if not CurrentlyEquipped then
						return
					end
					if Handle then
						Handle.Transparency = 1
					end
					if Umbrella then
						Umbrella.Transparency = 0
						Delay(3, function()
							if not CurrentlyEquipped then
								return
							end
							if Umbrella then
								Sounds.PlaceUmbrella:Play()
								local lounge = Instance.new("Seat")
								lounge.Friction = 1
								lounge.Elasticity = 0
								lounge.TopSurface = Enum.SurfaceType.Smooth
								lounge.BottomSurface = Enum.SurfaceType.Smooth
								lounge.FormFactor = Enum.FormFactor.Custom
								local m = Instance.new("SpecialMesh")
								m.MeshId = "http://www.roblox.com/asset/?id=162383507"
								m.TextureId = "http://www.roblox.com/asset/?id=162383599"
								m.Scale = Vector3.new(1.6,0.05,1.6)
								m.Parent = lounge
								lounge.Size = Vector3.new(3, 1, 5)
								lounge.CFrame = Umbrella.CFrame * CFrame.new(3, -2, 3) * CFrame.Angles(0, 0.4, 0)
								local bg = Instance.new("BodyGyro")
								Debris:AddItem(bg, 3)
								bg.Parent = lounge
								Debris:AddItem(lounge, StandTime)
								lounge.Parent = game:GetService("Workspace")
								local a=Tween("forward")a.add(1,{x=0.05},Easing.inOutQuad)a.add(1,{x=1.6},Easing.inOutBack)for x=1,200 do local b=a.getCurrentProperties()m.Scale=Vector3.new(1.6,b.x,1.6)a.update(0.025)wait(0.025)if b.x>=1.6 then break end end
								local c = Instance.new("Part")
								c.TopSurface=Enum.SurfaceType.Smooth
								c.BottomSurface=Enum.SurfaceType.Smooth
								c.FormFactor=Enum.FormFactor.Custom
								c.CanCollide = false
								c.Size = Vector3.new(4.25,1.59,7.72)
								c.Anchored = true							
								local cm = Instance.new("SpecialMesh")
								cm.MeshId = "http://www.roblox.com/asset/?id=162383569"
								cm.TextureId = "http://www.roblox.com/asset/?id=162383633"
								cm.Scale = Vector3.new(1, 0.05, 1)
								cm.Parent = c
								c.CFrame = Umbrella.CFrame * CFrame.new(-4, -4.1, 4) * CFrame.Angles(0, -0.4, 0)
								Debris:AddItem(c, StandTime)
								c.Parent=game:GetService("Workspace")
								local a=Tween("forward")a.add(1,{x=0.05},Easing.inOutQuad)a.add(1,{x=1},Easing.inOutBack)for x=1,200 do local b=a.getCurrentProperties()cm.Scale=Vector3.new(1,b.x,1)a.update(0.025)wait(0.025)if b.x>=1 then break end end
							end
						end)
					end
				end)
			end
			wait(ReloadTime)
			Handle.Transparency = 0
			Tool.Enabled = true
		end
		function CheckIfAlive()
			return (Player and Player.Parent and Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent)
		end
		function Equipped()
			Character = Tool.Parent
			Player = Players:GetPlayerFromCharacter(Character)
			Humanoid = Character:FindFirstChild("Humanoid")
			Torso = Character:FindFirstChild("Torso")
			if not CheckIfAlive() then
				return
			end
			if ToolUnequipped then
				ToolUnequipped:disconnect()
			end
		end
		function Unequipped()
			for i, v in pairs(Animations) do
				InvokeClient("StopAnimation", v)
			end
			if ToolUnequipped then
				ToolUnequipped:disconnect()
			end
			Handle.Transparency = 0
		end
		Tool.Activated:connect(Activated)
		Tool.Equipped:connect(Equipped)
		Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("Handle"):FindFirstChild("RopeAttachment") then
		source = [[--Rescripted by Luckymaxer
--Updated for R15 avatars by StarWars
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Mesh = Handle:WaitForChild("Mesh")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
RbxUtility = LoadLibrary("RbxUtility")
Create = RbxUtility.Create
BaseUrl = "http://www.roblox.com/asset/?id="
Meshes = {
	GrappleWithHook = 33393806,
	Grapple = 30308256,
	Hook = 30307623,
}
Animations = {
	Crouch = {Animation = Tool:WaitForChild("Crouch"), FadeTime = 0.25, Weight = nil, Speed = nil},
	R15Crouch = {Animation = Tool:WaitForChild("R15Crouch"), FadeTime = 0.25, Weight = nil, Speed = nil}
}
Sounds = {
	Fire = Handle:WaitForChild("Fire"),
	Connect = Handle:WaitForChild("Connect"),
	Hit = Handle:WaitForChild("Hit"),
}
for i, v in pairs(Meshes) do
	Meshes[i] = (BaseUrl .. v)
end
local BaseRopeConstraint = Instance.new("RopeConstraint")
BaseRopeConstraint.Thickness = 0.2
BaseRopeConstraint.Restitution = 1
BaseRopeConstraint.Color = BrickColor.new("Really black")
BasePart = Create("Part"){
	Material = Enum.Material.Plastic,
	Shape = Enum.PartType.Block,
	TopSurface = Enum.SurfaceType.Smooth,
	BottomSurface = Enum.SurfaceType.Smooth,
	Size = Vector3.new(0.2, 0.2, 0.2),
	CanCollide = true,
	Locked = true,
}
BaseRope = BasePart:Clone()
BaseRope.Name = "Effect"
BaseRope.BrickColor = BrickColor.new("Really black")
BaseRope.Anchored = true
BaseRope.CanCollide = false
Create("CylinderMesh"){
	Scale = Vector3.new(1, 1, 1),
	Parent = BaseRope,
}
BaseGrappleHook = BasePart:Clone()
BaseGrappleHook.Name = "Projectile"
BaseGrappleHook.Transparency = 0
BaseGrappleHook.Size = Vector3.new(1, 0.4, 1)
BaseGrappleHook.Anchored = false
BaseGrappleHook.CanCollide = true
Create("SpecialMesh"){
	MeshType = Enum.MeshType.FileMesh,
	MeshId = (BaseUrl .. "30307623"),
	TextureId = (BaseUrl .. "30307531"),
	Scale = Mesh.Scale,
	VertexColor = Vector3.new(1, 1, 1),
	Offset = Vector3.new(0, 0, 0),
	Parent = BaseGrappleHook,
}
local RopeAttachment = Instance.new("Attachment")
RopeAttachment.Name = "RopeAttachment"
RopeAttachment.Parent = BaseGrappleHook
Create("BodyGyro"){
	Parent = BaseGrappleHook,
}
for i, v in pairs({Sounds.Connect, Sounds.Hit}) do
	local Sound = v:Clone()
	Sound.Parent = BaseGrappleHook
end
Rate = (1 / 60)
MaxDistance = 200
CanFireWhileGrappling = true
Crouching = false
ToolEquipped = false
ServerControl = (Tool:FindFirstChild("ServerControl") or Create("RemoteFunction"){
	Name = "ServerControl",
	Parent = Tool,
})
ClientControl = (Tool:FindFirstChild("ClientControl") or Create("RemoteFunction"){
	Name = "ClientControl",
	Parent = Tool,
})
for i, v in pairs(Tool:GetChildren()) do
	if v:IsA("BasePart") and v ~= Handle then
		v:Destroy()
	end
end
Mesh.MeshId = Meshes.GrappleWithHook
Handle.Transparency = 0
Tool.Enabled = true
function CheckTableForString(Table, String)
	for i, v in pairs(Table) do
		if string.find(string.lower(String), string.lower(v)) then
			return true
		end
	end
	return false
end
function CheckIntangible(Hit)
	local ProjectileNames = {"Water", "Arrow", "Projectile", "Effect", "Rail", "Laser", "Bullet", "GrappleHook"}
	if Hit and Hit.Parent then
		if ((not Hit.CanCollide or CheckTableForString(ProjectileNames, Hit.Name)) and not Hit.Parent:FindFirstChild("Humanoid")) then
			return true
		end
	end
	return false
end
function CastRay(StartPos, Vec, Length, Ignore, DelayIfHit)
	local Ignore = ((type(Ignore) == "table" and Ignore) or {Ignore})
	local RayHit, RayPos, RayNormal = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(StartPos, Vec * Length), Ignore)
	if RayHit and CheckIntangible(RayHit) then
		if DelayIfHit then
			wait()
		end
		RayHit, RayPos, RayNormal = CastRay((RayPos + (Vec * 0.01)), Vec, (Length - ((StartPos - RayPos).magnitude)), Ignore, DelayIfHit)
	end
	return RayHit, RayPos, RayNormal
end
function AdjustRope()
	if not Rope or not Rope.Parent or not CheckIfGrappleHookAlive() then
		return
	end
	local StartPosition = Handle.RopeAttachment.WorldPosition
	local EndPosition = GrappleHook.RopeAttachment.WorldPosition
	local RopeLength = (StartPosition - EndPosition).Magnitude
	
	Rope.Size = Vector3.new(1, 1, 1)
	Rope.Mesh.Scale = Vector3.new(0.1, RopeLength, 0.1)
	Rope.CFrame = (CFrame.new(((StartPosition + EndPosition) / 2), EndPosition) * CFrame.Angles(-(math.pi / 2), 0, 0))
end
function DisconnectGrappleHook(KeepBodyObjects)
	for i, v in pairs({Rope, GrappleHook, GrappleHookChanged}) do
		if v then
			if tostring(v) == "Connection" then
				v:disconnect()
			elseif type(v) == "userdata" and v.Parent then
				v:Destroy()
			end
		end
	end
	if CheckIfAlive() and not KeepBodyObjects then
		for i, v in pairs(Torso:GetChildren()) do
			if string.find(string.lower(v.ClassName), string.lower("Body")) then
				v:Destroy()
			end
		end	
	end
	Connected = false
	Mesh.MeshId = Meshes.GrappleWithHook
end
function TryToConnect()
	if not ToolEquipped or not CheckIfAlive() or not CheckIfGrappleHookAlive() or Connected then
		DisconnectGrappleHook()
		return
	end
	local DistanceApart = (Torso.Position - GrappleHook.Position).Magnitude
	if DistanceApart > MaxDistance then
		DisconnectGrappleHook()
		return
	end
	local Directions = {Vector3.new(0, 1, 0), Vector3.new(0, -1, 0), Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1)}
	local ClosestRay = {DistanceApart = math.huge}
	for i, v in pairs(Directions) do
		local Direction = CFrame.new(GrappleHook.Position, (GrappleHook.CFrame + v * 2).p).lookVector
		local RayHit, RayPos, RayNormal = CastRay((GrappleHook.Position + Vector3.new(0, 0, 0)), Direction, 2, {Character, GrappleHook, Rope}, false)
		if RayHit then
			local DistanceApart = (GrappleHook.Position - RayPos).Magnitude
			if DistanceApart < ClosestRay.DistanceApart then
				ClosestRay = {Hit = RayHit, Pos = RayPos, Normal = RayNormal, DistanceApart = DistanceApart}
			end
		end
	end
	if ClosestRay.Hit then
		Connected = true
		local GrappleCFrame = CFrame.new(ClosestRay.Pos, (CFrame.new(ClosestRay.Pos) + ClosestRay.Normal * 2).p) * CFrame.Angles((math.pi / 2), 0, 0)
		GrappleCFrame = (GrappleCFrame * CFrame.new(0, -(GrappleHook.Size.Y / 1.5), 0))
		GrappleCFrame = (CFrame.new(GrappleCFrame.p, Handle.Position) * CFrame.Angles(0, math.pi, 0))
		local Weld = Create("Motor6D"){
			Part0 = GrappleHook,
			Part1 = ClosestRay.Hit,
			C0 = GrappleCFrame:inverse(),
			C1 = ClosestRay.Hit.CFrame:inverse(),
			Parent = GrappleHook,
		}
		for i, v in pairs(GrappleHook:GetChildren()) do
			if string.find(string.lower(v.ClassName), string.lower("Body")) then
				v:Destroy()
			end
		end	
		local HitSound = GrappleHook:FindFirstChild("Hit")
		if HitSound then
			HitSound:Play()
		end
		local BackUpGrappleHook = GrappleHook
		wait(0.4)
		if not CheckIfGrappleHookAlive() or GrappleHook ~= BackUpGrappleHook then
			return
		end
		Sounds.Connect:Play()
		local ConnectSound = GrappleHook:FindFirstChild("Connect")
		if ConnectSound then
			ConnectSound:Play()
		end
		
		for i, v in pairs(Torso:GetChildren()) do
			if string.find(string.lower(v.ClassName), string.lower("Body")) then
				v:Destroy()
			end
		end	
		
		local TargetPosition = GrappleHook.Position
		local BackUpPosition = TargetPosition
		
		local BodyPos = Create("BodyPosition"){
			D = 1000,
			P = 3000,
			maxForce = Vector3.new(1000000, 1000000, 1000000),
			position = TargetPosition,
			Parent = Torso,
		}
		
		local BodyGyro = Create("BodyGyro"){
			maxTorque = Vector3.new(100000, 100000, 100000),
			cframe = CFrame.new(Torso.Position, Vector3.new(GrappleCFrame.p.X, Torso.Position.Y, GrappleCFrame.p.Z)),
			Parent = Torso,
		}
	
		Spawn(function()
			while TargetPosition == BackUpPosition and CheckIfGrappleHookAlive() and Connected and ToolEquipped and CheckIfAlive() do
				BodyPos.position = GrappleHook.Position
				wait()
			end
		end)
		
	end
end
function CheckIfGrappleHookAlive()
	return (((GrappleHook and GrappleHook.Parent --[[and Rope and Rope.Parent]) and true) or false)
		end
		function CheckIfAlive()
	return (((Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent and Player and Player.Parent) and true) or false)
end
function Activated()
	if not Tool.Enabled or not ToolEquipped or not CheckIfAlive() then
		return
	end
	local MousePosition = InvokeClient("MousePosition")
	if not MousePosition then
		return
	end
	MousePosition = MousePosition.Position
	if CheckIfGrappleHookAlive() then
		if not CanFireWhileGrappling then
			return
		end
		if GrappleHookChanged then
			GrappleHookChanged:disconnect()
		end
		DisconnectGrappleHook(true)
	end
	if GrappleHookChanged then
		GrappleHookChanged:disconnect()
	end
	Tool.Enabled = false
	Sounds.Fire:Play()
	Mesh.MeshId = Meshes.Grapple
	GrappleHook = BaseGrappleHook:Clone()
	GrappleHook.CFrame = (CFrame.new((Handle.Position + (MousePosition - Handle.Position).Unit * 5), MousePosition) * CFrame.Angles(0, 0, 0))
	local Weight = 70
	GrappleHook.Velocity = (GrappleHook.CFrame.lookVector * Weight)
	local Force = Create("BodyForce"){
		force = Vector3.new(0, workspace.Gravity * 0.98 * GrappleHook:GetMass(), 0),
		Parent = GrappleHook,
	}
	GrappleHook.Parent = Tool
	GrappleHookChanged = GrappleHook.Changed:connect(function(Property)
		if Property == "Parent" then
			DisconnectGrappleHook()
		end
	end)
	Rope = BaseRope:Clone()
	Rope.Parent = Tool
	Spawn(function()
		while CheckIfGrappleHookAlive() and ToolEquipped and CheckIfAlive() do
			AdjustRope()
			Spawn(function()
				if not Connected then
					TryToConnect()
				end
			end)
			wait()
		end
	end)
	wait(2)
	Tool.Enabled = true
end
function Equipped(Mouse)
	Character = Tool.Parent
	Humanoid = Character:FindFirstChild("Humanoid")
	Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
	Player = Players:GetPlayerFromCharacter(Character)
	if not CheckIfAlive() then
		return
	end
	Spawn(function()
		DisconnectGrappleHook()
		if HumanoidJumping then
			HumanoidJumping:disconnect()
		end
		HumanoidJumping = Humanoid.Jumping:connect(function()
			DisconnectGrappleHook()
		end)
	end)
	Crouching = false
	ToolEquipped = true
end
function Unequipped()
	if HumanoidJumping then
		HumanoidJumping:disconnect()
	end
	DisconnectGrappleHook()
	Crouching = false
	ToolEquipped = false
end
function OnServerInvoke(player, mode, value)
	if player ~= Player or not ToolEquipped or not value or not CheckIfAlive() then
		return
	end
	if mode == "KeyPress" then
		local Key = value.Key
		local Down = value.Down
		if Key == "q" and Down then
			DisconnectGrappleHook()
		elseif Key == "c" and Down then
			Crouching = not Crouching
			Spawn(function()
				local Animation = Animations.Crouch
				if Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R15 then
					Animation = Animations.R15Crouch
				end 
				InvokeClient(((Crouching and "PlayAnimation") or "StopAnimation"), Animation)
			end)
		end
	end
end
function InvokeClient(Mode, Value)
	local ClientReturn = nil
	pcall(function()
		ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
	end)
	return ClientReturn
end
ServerControl.OnServerInvoke = OnServerInvoke
Tool.Activated:connect(Activated)
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("ArmMesh") then
		source = [[local Tool = script.Parent
local Remote = Tool:WaitForChild("Remote")
local Handle = Tool:WaitForChild("Handle")
local FriendlyFire = false
local ArmMesh
local HitAble = false
local HitWindup = 0.15
local HitWindow = 0.75
local HitDamage = 15
local HitVictims = {}
local SwingAble = true
local SwingRestTime = 1
--returns the wielding player of this tool
function getPlayer()
	local char = Tool.Parent
	return game:GetService("Players"):GetPlayerFromCharacter(char)
end
--helpfully checks a table for a specific value
function contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end
--tags a human for the ROBLOX KO system
function tagHuman(human)
	local tag = Instance.new("ObjectValue")
	tag.Value = getPlayer()
	tag.Name = "creator"
	tag.Parent = human
	game:GetService("Debris"):AddItem(tag)
end
--used by checkTeams
function sameTeam(otherHuman)
	local player = getPlayer()
	local otherPlayer = game:GetService("Players"):GetPlayerFromCharacter(otherHuman.Parent)
	if player and otherPlayer then
		if player == otherPlayer then
			return true
		end
		if otherPlayer.Neutral then
			return false
		end
		return player.TeamColor == otherPlayer.TeamColor
	end
	return false
end
--use this to determine if you want this human to be harmed or not, returns boolean
function checkTeams(otherHuman)
	return not (sameTeam(otherHuman) and not FriendlyFire)
end
function onTouched(part)
	if part:IsDescendantOf(Tool.Parent) then return end
	if not HitAble then return end
	
	if part.Parent and part.Parent:FindFirstChild("Humanoid") then
		local human = part.Parent.Humanoid
		
		if contains(HitVictims, human) then return end
		
		local root = part.Parent:FindFirstChild("HumanoidRootPart")
		if root and not root.Anchored then
			local myRoot = Tool.Parent:FindFirstChild("HumanoidRootPart")
			if myRoot and checkTeams(human) then
				local delta = root.Position - myRoot.Position
				
				human.Sit = true
				tagHuman(human)
				human:TakeDamage(HitDamage)
				table.insert(HitVictims, human)
				
				local bv = Instance.new("BodyVelocity")
				bv.maxForce = Vector3.new(1e9, 1e9, 1e9)
				bv.velocity = delta.unit * 128
				bv.Parent = root
				game:GetService("Debris"):AddItem(bv, 0.05)
				
				Handle.Smack.Pitch = math.random(90, 110)/100
				Handle.Smack.TimePosition = 0.15
				Handle.Smack:Play()
			end
		end
	end
end
function onEquip()
	--put in our right arm
	local char = Tool.Parent
	local arm = Tool.ArmMesh:Clone()
	arm.Parent = char:FindFirstChild("Right Arm")
	ArmMesh = arm
end
function onUnequip()
	if ArmMesh then
		ArmMesh:Destroy()
		ArmMesh = nil
	end
end
function onLeftDown()
	if not SwingAble then return end
	
	SwingAble = false
	delay(SwingRestTime, function()
		SwingAble = true
	end)
	
	delay(HitWindup, function()
		HitAble = true
		delay(HitWindow, function()
			HitAble = false
		end)
	end)
	
	HitVictims = {}
	
	Remote:FireClient(getPlayer(), "PlayAnimation", "Swing")
	
	wait(0.25)
	Handle.Boom.Pitch = math.random(80, 100)/100
	Handle.Boom:Play()
end
function onRemote(player, func, ...)
	if player ~= getPlayer() then return end
	
	if func == "LeftDown" then
		onLeftDown(...)
	end
end
Tool.Equipped:connect(onEquip)
Tool.Unequipped:connect(onUnequip)
Handle.Touched:connect(onTouched)
Remote.OnServerEvent:connect(onRemote)]]
	elseif v.Name == "BalloonScript" then
		source = [[local Tool = script.Parent
local upAndAway = false
local humanoid = nil
local head = nil
local upAndAwayForce = Instance.new("BodyForce")
local equalizingForce = 236 / 1.2 -- amount of force required to levitate a mass
local gravity = 1.05 -- things float at > 1
local height = nil
local maxRise =  150
function onTouched(part)
	local h = part.Parent:FindFirstChild("Humanoid")
	if h ~= nil then
		upAndAway = true
		Tool.Handle.Anchored = false
	end
end
function onEquipped()
	Tool.Handle.Mesh.MeshId = "http://www.roblox.com/asset/?id=146063878"
	Tool.Handle.Mesh.TextureId="http://www.roblox.com/asset/?id=146063910"
	upAndAway = true
	upAndAwayForce.Parent = Tool.Handle
	Tool.GripPos = Vector3.new(0,-1,0)
	Tool.GripForward = Vector3.new(0,1,0)
	Tool.GripRight = Vector3.new(0,0,-1)
	Tool.GripUp = Vector3.new(1,0,0)
	height = Tool.Parent.Torso.Position.y
	local lift = recursiveGetLift(Tool.Parent)
	float(lift)
end
function onUnequipped()
	upAndAway = false
	Tool.GripForward = Vector3.new(1,0,0)
	Tool.GripRight = Vector3.new(0,0,1)
	Tool.GripUp = Vector3.new(0,1,0)
	Tool.Handle.Mesh.Scale = Vector3.new(2,2,2)
end
Tool.Unequipped:connect(onUnequipped)
Tool.Equipped:connect(onEquipped)
Tool.Handle.Touched:connect(onTouched)
function recursiveGetLift(node)
	local m = 0
	local c = node:GetChildren()
	if (node:FindFirstChild("Head") ~= nil) then head = node:FindFirstChild("Head") end -- nasty hack to detect when your parts get blown off
	for i=1,#c do
		if c[i].className == "Part" then	
			if (head ~= nil and (c[i].Position - head.Position).magnitude < 10) then -- GROSS
				if c[i].Name == "Handle" then
					m = m + (c[i]:GetMass() * equalizingForce * 1) -- hack that makes hats weightless, so different hats don't change your jump height
				else
					m = m + (c[i]:GetMass() * equalizingForce * gravity)
				end
			end
		end
		m = m + recursiveGetLift(c[i])
	end
	return m
end
function updateBalloonSize()
	local range = (height + maxRise) - Tool.Handle.Position.y
	print(range)
	
	if range > 100 then
		Tool.Handle.Mesh.Scale = Vector3.new(2,2,2)
	elseif range < 100 and range > 50 then
		Tool.Handle.Mesh.Scale = Vector3.new(3,3,3)
	elseif range < 50 then
		Tool.Handle.Mesh.Scale = Vector3.new(4,4,4)
	end
end
function float(lift)
	while upAndAway do
		upAndAwayForce.force = Vector3.new(0,lift * 0.98,0)
		upAndAwayForce.Parent = Tool.Handle
		wait(3)
		upAndAwayForce.force = Vector3.new(0,lift * 0.92,0)
		wait(2)
		if Tool.Handle.Position.y > height + maxRise then
			upAndAway = false
			Tool.Handle.Pop:Play()
			Tool.GripPos = Vector3.new(0,-0.4,0)
			Tool.Handle.Mesh.MeshId = "http://www.roblox.com/asset/?id=26725510"
			Tool.Handle.Mesh.TextureId=""
			Tool.Handle.Mesh.Scale=Vector3.new(2.5,2.5,2.5)
			upAndAwayForce.Parent = nil
		end
		updateBalloonSize()
	end
end]]
	elseif v.Name == "WeldArm" then
		source = [[Tool = script.Parent;
local arms = nil
local torso = nil
local welds = {}
function Equip(mouse)
wait(0.01)
arms = {Tool.Parent:FindFirstChild("Left Arm"), Tool.Parent:FindFirstChild("Right Arm")}
torso = Tool.Parent:FindFirstChild("Torso")
if arms ~= nil and torso ~= nil then
local sh = {torso:FindFirstChild("Left Shoulder"), torso:FindFirstChild("Right Shoulder")}
if sh ~= nil then
local yes = true
if yes then
yes = false
sh[1].Part1 = nil
sh[2].Part1 = nil
local weld1 = Instance.new("Weld")
weld1.Part0 = torso
weld1.Parent = torso
weld1.Part1 = arms[1]
weld1.C1 = CFrame.new(1.5,0, 0) 
welds[1] = weld1
local weld2 = Instance.new("Weld")
weld2.Part0 = torso
weld2.Parent = torso
weld2.Part1 = arms[2]
weld2.C1 = CFrame.new(-1.5,1.5,0) * CFrame.fromEulerAnglesXYZ(math.pi, 0, 0)
welds[2] = weld2
end
else
print("sh")
end
else
print("arms")
end
end
function Unequip(mouse)
if arms ~= nil and torso ~= nil then
local sh = {torso:FindFirstChild("Left Shoulder"), torso:FindFirstChild("Right Shoulder")}
if sh ~= nil then
local yes = true
if yes then
yes = false
sh[1].Part1 = arms[1]
sh[2].Part1 = arms[2]
welds[1].Parent = nil
welds[2].Parent = nil
end
else
print("sh")
end
else
print("arms")
end
end
Tool.Equipped:connect(Equip)
Tool.Unequipped:connect(Unequip)]]
	elseif v.Parent.Name == "PaintBucket" then
		source = [[-- // Recreated by StarWars
local Tool = script.Parent
local GearService = require(1075123174)
local Gear = GearService:BindGear(Tool)
Gear:SetupRemoteFunctions()
local Remotes = Tool:WaitForChild("Remotes")
local ClientControls = Remotes:WaitForChild("ClientControls") 
local ServerControls = Remotes:WaitForChild("ServerControls")
ServerControls.OnServerInvoke = function(player, mode, value)
	if player ~= Gear.Player then return end 
	if not mode then return end
	
	if mode == "PaintPart" and value then
		if value.Part and value.Color then
			value.Part.Color = value.Color
		end
	end
end]]
	elseif v.Name == "PinataScript" then
		source = [[local pinata = script.Parent
local theWholeThing = pinata.Parent
local health = 100
local gears = {29100543, 10472779, 34399428, 20056642, 25695001, 16214845, 20056642, 12848902} --Fix implemented by Luckymaxer
local debris = game:GetService("Debris")
local scale = 1
local increment = 0.1
while scale < 1.6 do
	pinata.Mesh.Scale = Vector3.new(scale,scale,scale)
	scale = scale + increment
	wait()
end
function pinataPieces()
	for i = 1, 20 do
		local pinataPart = Instance.new("Part")
		pinataPart.Name = "Pinata Piece"
		pinataPart.formFactor  = 2
		pinataPart.Size = Vector3.new(1,0.4,1)
		local color = math.random(1,3)
		if color == 1 then pinataPart.BrickColor = BrickColor.new("Bright red")
		elseif color == 2 then pinataPart.BrickColor = BrickColor.new("Bright yellow")
		else pinataPart.BrickColor = BrickColor.new("Bright orange") end
		pinataPart.BottomSurface = 0
		pinataPart.TopSurface = 0
		pinataPart.Material = Enum.Material.Grass
		pinataPart.Position = Vector3.new(pinata.Position.x + math.random(-1,1),pinata.Position.y + math.random(-1,1),pinata.Position.z + math.random(-1,1))
		pinataPart.Parent = game.Workspace
		debris:AddItem(pinataPart,4)
	end
end
local breaking = false
function checkHealth()
	print(health)
	-- time to break out some gear!
	if health <= 0 then
		if breaking then return end
		breaking = true
		local gearInstances = {}
		for i = 1, #gears do
			--This call will cause a "wait" until the data comes back
			local root = game:GetService("InsertService"):LoadAsset(gears[i])
			local instances = root:GetChildren()
			if #instances == 0 then
				root:Remove()
				return
			end
			root = root:GetChildren()
			root[1].Handle.Position = Vector3.new(pinata.Position.x + math.random(-1,1),pinata.Position.y + math.random(-1,1),pinata.Position.z + math.random(-1,1))
			table.insert(gearInstances,root[1])
		end
		pinata.Transparency = 1
		pinata.CanCollide = false
		local co = coroutine.create(pinataPieces)
		coroutine.resume(co)
		for i = 1, #gearInstances do
			gearInstances[i].Parent = game.Workspace
		end
		
		pinata.BrokenSound:Play()
		theWholeThing:remove()
		breaking = false
	end
end
local touching = false
function onTouched(part)
	if touching then return end
	touching = true
	
	if part.CanCollide then
		health = health - part.Velocity.magnitude/50
		checkHealth()
		wait(0.1)
	end
	touching = false
end
pinata.Touched:connect(onTouched)]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("PinataScript") then
		source = [[local Tool = script.Parent
local torso = nil
function onEquipped()
	torso = Tool.Parent:FindFirstChild("Torso") or Tool.Parent:FindFirstChild("UpperTorso")
end
Tool.Equipped:connect(onEquipped)
function onUnequipped()
	if Tool.Handle.Transparency == 1 then
		Tool.Parent = game.Players:GetPlayerFromCharacter(torso.Parent).Backpack
	end
end
Tool.Unequipped:connect(onUnequipped)
function pinataExists()
	return game.Workspace:FindFirstChild(torso.Parent.Name .. "'s Pinata")
end
local enabled = false
function onActivated()
	if pinataExists() == nil then
		enabled = false
	end
	if enabled then return end
	enabled = true
	local pinata = Tool.Handle:clone()
	pinata.Name = "Head"
	pinata.CanCollide = true
	pinata.Size = Vector3.new(3,3,1)
	pinata.Position = Vector3.new(torso.Position.x + (torso.CFrame.lookVector.unit.x * 8),torso.Position.y,torso.Position.z + (torso.CFrame.lookVector.unit.z * 8))
	local model = Instance.new("Model")
	model.Name = torso.Parent.Name .. "'s Pinata"
	pinata.Parent = model
	model.Parent = game.Workspace
	local sound = Instance.new("Sound")
	sound.Name = "BrokenSound"
	sound.SoundId = "http://www.roblox.com/asset/?id=34300463"
	sound.Parent = pinata
	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = 0
	humanoid.Parent = model
	Tool.Handle.Transparency = 1
	
	local script = Tool.PinataScript:clone()
	script.Parent = pinata
	script.Disabled = false
	
	local bodyPos = Instance.new("BodyPosition")
	bodyPos.position = Vector3.new(pinata.Position.x,torso.Position.y + 5, pinata.Position.z)
	bodyPos.P = 8000
	bodyPos.D = bodyPos.P
	bodyPos.maxForce = Vector3.new(bodyPos.P,bodyPos.P,bodyPos.P)
	bodyPos.Parent = pinata
	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 50
	bodyGyro.D = bodyGyro.P
	bodyGyro.maxTorque = Vector3.new(bodyGyro.P,0,0)
	bodyGyro.cframe = pinata.CFrame
	bodyGyro.Parent = pinata
	Tool:Destroy()
	checkForTransparency()
end
Tool.Activated:connect(onActivated)
function checkForTransparency()
	while pinataExists() do wait(0.5) end
	Tool.Handle.Transparency = 0
end]]
	elseif v:FindFirstChild("Airstrike") then
		source = [[--Rescripted by StarWars
local Tool = script.Parent
local Airstrike = require(script.Airstrike)
local COOL_DOWN = 20
local LastStrike = 0
local OnMouseClickEvent = Instance.new("RemoteEvent")
OnMouseClickEvent.Name = "OnMouseClick"
OnMouseClickEvent.OnServerEvent:connect(function(player, location)
	if tick() - LastStrike > COOL_DOWN then
		LastStrike = tick()
		Airstrike:Spawn(player, location)
	end
end)
OnMouseClickEvent.Parent = Tool]]
	elseif v.Name == "Script" and v:FindFirstChild("SpeedEffect") then
		source = [[--Rescripted by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
BaseUrl = "http://www.roblox.com/asset/?id="
Sounds = {
	Drink = Handle:WaitForChild("Drink"),
}
Grips = {
	Normal = CFrame.new(0.200000003, -0.100000001, 0, 0.217036337, 0, 0.976163626, 0, 1, -0, -0.976163507, 0, 0.217036366),
	Active = CFrame.new(1.39999998, -0.400000006, 0.300000012, 0.995685041, 0.0927979201, -9.8362565e-005, -0.0508967601, 0.546987712, 0.835591972, 0.0775950029, -0.831981361, 0.54935056),
}
SpeedEffect = script:WaitForChild("SpeedEffect")
ToolEquipped = false
Handle.Transparency = 0
Tool.Enabled = true
function CheckIfAlive()
	return (((Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Player and Player.Parent) and true) or false)
end
function Activated()
	if not ToolEquipped or not CheckIfAlive() or not Tool.Enabled then
		return
	end
	Tool.Enabled = false
	Tool.Grip = Grips.Active
	Sounds.Drink:Play()
	wait(3)
	if CheckIfAlive() then
		local EffectCopy = Character:FindFirstChild(SpeedEffect.Name)
		if not EffectCopy then
			EffectCopy = SpeedEffect:Clone()
			EffectCopy.Disabled = false
			EffectCopy.Parent = Character
		end
	end
	Tool.Grip = Grips.Normal
	wait(60)
	Tool.Enabled = true
end
function Equipped()
	Character = Tool.Parent
	Humanoid = Character:FindFirstChild("Humanoid")
	Player = Players:GetPlayerFromCharacter(Character)
	if not CheckIfAlive() then
		return
	end
	ToolEquipped = true
end
function Unequipped()
	ToolEquipped = false
end
Tool.Activated:connect(Activated)
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "SpeedEffect" and v:FindFirstChild("Explosion") then
		source = [[--Rescripted by Luckymaxer
--Updated for R15 avatars by StarWars
Character = script.Parent
Humanoid = Character:FindFirstChild("Humanoid")
Head = Character:FindFirstChild("Head")
Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
Player = Players:GetPlayerFromCharacter(Character)
Sounds = {
	Explosion = script:WaitForChild("Explosion"),
}
function DestroyScript()
	Debris:AddItem(script, 0.5)
	script:Destroy()
end
if not Head or not Torso or not Humanoid or Humanoid.Health == 0 or not Player then
	DestroyScript()
	return
end
Duration = 30
Humanoid.WalkSpeed = (16 * 1.6)
Sparkles = Instance.new("Sparkles")
Sparkles.SparkleColor = Color3.new(0.8, 0, 0.8)
Sparkles.Enabled = true
Debris:AddItem(Sparkles, Duration)
Sparkles.Parent = Torso
Count = script:FindFirstChild("CoffeeCount")
if not Count then
	Count = Instance.new("IntValue")
	Count.Name = "CoffeeCount"
	Count.Value = 1
	Count.Parent = script
else
	if (Count.Value > 3) then
		if (math.random() > 0.5) then
			ExplosionSound = Sounds.Explosion:Clone()
			Debris:AddItem(ExplosionSound, 5)
			ExplosionSound.Parent = Head
			ExplosionSound:Play()
			local Explosion = Instance.new("Explosion")
			Explosion.ExplosionType = Enum.ExplosionType.NoCraters
			Explosion.BlastRadius = 2
			Explosion.BlastPressure = 1000000
			Explosion.Position = Torso.Position
			Explosion.Parent = game:GetService("Workspace")
			
		end
	end
	Count.Value = (Count.Value + 1)
end
wait(Duration)
Humanoid.WalkSpeed = 16
DestroyScript()]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("AnimationPlayerScript") then
		source = [[function FindAttachedHumanoid(part)
	local tpart = part
	while tpart.Parent do
		if tpart.Parent:FindFirstChild('Humanoid') then return tpart.Parent.Humanoid end
		tpart = tpart.Parent
	end
	return nil
end
function MakeValue(class,name,value,parent)
	local temp = Instance.new(class)
	temp.Name = name
	temp.Value = value
	temp.Parent = parent
	return temp
end	
local Tool = script.Parent
local Handle = Tool:WaitForChild('Handle')
local YellSound = Handle:WaitForChild('Sound')
local AniScript = Tool:WaitForChild('AnimationPlayerScript')
--http://www.roblox.com/Asset?ID=111898513'--http://www.roblox.com/Asset?ID=111880514'
local ThrowAnimation = 'http://www.roblox.com/Asset?ID=111898867'
local ThrowFace = 'http://www.roblox.com/asset?id=111882478'
local ThrowTable= Instance.new('Part')
do
	--ThrowTable.Shape = 'Ball'
	ThrowTable.FormFactor='Custom'
	ThrowTable.Size = Vector3.new(4.8, 2.43, 3.63)
	ThrowTable.CanCollide = true
	local tmesh = Instance.new('SpecialMesh')
	tmesh.MeshId = 'http://www.roblox.com/asset/?id=111868131'
	tmesh.TextureId = 'http://www.roblox.com/asset/?id=111867655'
	tmesh.Parent = ThrowTable
end
local LookGyro= Instance.new('BodyGyro')
LookGyro.maxTorque = Vector3.new(0,math.huge,0) 
local ActivateLock=false
Tool.Activated:connect(function()
	if ActivateLock then return end
	ActivateLock = true
	local character = Tool.Parent
	local humanoid = character:WaitForChild('Humanoid')
	local torso = character:WaitForChild('Torso')
	local head = character:WaitForChild('Head')
	local face = head:FindFirstChild('face')
	local oldFace =''
	if face then oldFace = face.Texture end
	humanoid.WalkSpeed = 0
	LookGyro.cframe = torso.CFrame - torso.CFrame.p
	LookGyro.Parent = torso
	
	local ntable =  ThrowTable:Clone()
	ntable.CFrame = torso.CFrame+(torso.CFrame.lookVector*3)
	ntable.Parent = Workspace	
	
	MakeValue('StringValue','aniId',ThrowAnimation,AniScript)	
	wait(.5)
	YellSound:play()
	wait(.5)	
	if face then	
		face.Texture=ThrowFace
	end
	
	
	
	local bAVel = Instance.new('BodyAngularVelocity')
	bAVel.maxTorque = Vector3.new(math.huge,math.huge,math.huge)
	bAVel.angularvelocity = ((torso.CFrame*CFrame.Angles(0,math.pi/2,0)).lookVector*10)
	bAVel.Parent = ntable
	
	local bVel = Instance.new('BodyVelocity')
	bVel.maxForce = Vector3.new(math.huge,0,math.huge)
	bVel.velocity = (torso.CFrame.lookVector*25)
	bVel.Parent = ntable
	ntable.Touched:connect(function(part)
		--print('GotTouched:' .. part.Name)
		Spawn(function()
			if part.Name == 'Terrain' then return end
			if part.Anchored then return end
			local hitHumanoid = FindAttachedHumanoid(part)
			if hitHumanoid then
				--print('HumanoidParent:'..hitHumanoid.Parent.Name)
				if hitHumanoid==humanoid then return end
				hitHumanoid.PlatformStand =true 
			end
			if part.Size.x*part.Size.y*part.Size.z<=5*9*5 then
				part.Velocity = (Vector3.new((math.random()-.5)*2,math.random(),(math.random()-.5)*2).unit)*150
			end
			wait(3)
			print('got past wait')
			if hitHumanoid then
				print('unplatformstanding')
				hitHumanoid.PlatformStand=false 
				hitHumanoid.Jump = true 
			end
		end)
	end)
	wait(6)
	LookGyro.Parent = nil
	humanoid.WalkSpeed = 16
	if face then	
		face.Texture=oldFace
	end
	ntable.CanCollide = false
	game.Debris:AddItem(ntable,5)
	ActivateLock = false
end)]]
	elseif v.Name == "BananaScript" then
		source = [[wait(0.5)
local banana = script.Parent
local touched = false
function onTouched(part)
	if touched then
		return
	end
	
	touched = true
	local humanoid = part.Parent:FindFirstChild("Humanoid")
	if humanoid ~= nil then
		banana.SlipSound:Play()
		humanoid.Jump = true
		humanoid.Sit = true
		wait(0.9)
		humanoid.Sit = false
	end
	touched = false
end
banana.Touched:connect(onTouched)]]
	elseif v.Name == "CompassEffect" then
		source = [[--Updated for R15 avatars by StarWars
--print("do compass")
debris = game:GetService("Debris")
-- create arrow
local p = Instance.new("Part")
p.formFactor = 2
p.Size = Vector3.new(1,.4,1)
p.Transparency = .5
p.BrickColor = BrickColor.new(119)
p.CanCollide = false
p.Locked = true
p.RotVelocity = Vector3.new(math.random(), math.random(), math.random()) * 10
local Torso = script.Parent:FindFirstChild("Torso") or script.Parent:FindFirstChild("UpperTorso")
local v = Vector3.new(Torso.CFrame.lookVector.x, 0, Torso.CFrame.lookVector.z)
p.CFrame = CFrame.new(Torso.CFrame.p + v * 8, v.unit)
local m = script.ArrowMesh:Clone() -- NASTY......... I agree
m.Parent = p
local b = Instance.new("BodyPosition")
b.position = p.Position
b.Parent = p
local g = Instance.new("BodyGyro")
g.cframe = CFrame.new(Vector3.new(0,0,0), Vector3.new(0,0,1)) -- point North
g.maxTorque = Vector3.new(7e7, 7e7, 7e7)
g.Parent = p
p.Parent = game.Workspace
debris:AddItem(p, 10)
wait(5)
script.Parent = nil]]
	elseif v.Name == "CompassScript" then
		source = [[local Tool = script.Parent;

enabled = true




function onActivated()
	if not enabled  then
		return
	end

	enabled = false


	Tool.Handle.OpenSound:play()
	
	local h = Tool.Parent:FindFirstChild("Humanoid")
	if (h ~= nil) then
		local s = script.Parent.CompassEffect:Clone()
		s.Disabled = false
		s.Parent = Tool.Parent			
	end


	wait(3)

	enabled = true

end

function onEquipped()
	Tool.Handle.OpenSound:play()
end

script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)
]]
	elseif v.Parent.Parent.Name == "Fake Bomb" then
		source = [[--Stickmasterluke
sp=script.Parent
timer=20
soundinterval=1
starttime=tick()
attached=false
debris=game:GetService("Debris")
function makeconfetti()
	local cp=Instance.new("Part")
	cp.Name="Effect"
	cp.FormFactor="Custom"
	cp.Size=Vector3.new(0,0,0)
	cp.CanCollide=false
	cp.Transparency=1
	cp.CFrame=sp.CFrame
	cp.Velocity=Vector3.new((math.random()-.5),math.random(),(math.random()-.5)).unit*20
	delay(.25+(math.random()*.2),function()
		if cp~=nil then
			cp.Velocity=cp.Velocity*.1
			wait(.5)
		end
		if cp~=nil then
			cp.Velocity=Vector3.new(0,-1,0)
			wait(1)
		end
		if cp~=nil then
			cp.Velocity=Vector3.new(0,-2,0)
		end
	end)
	local cbbg=Instance.new("BillboardGui")
	cbbg.Adornee=cp
	cbbg.Size=UDim2.new(7,0,4,0)
	local cil=Instance.new("ImageLabel")
	cil.BackgroundTransparency=1
	cil.BorderSizePixel=0
	cil.Size=UDim2.new(1,0,1,0)
	cil.Image="http://www.roblox.com/asset/?id=104606998"
	cil.Parent=cbbg
	cbbg.Parent=cp
	local bf=Instance.new("BodyForce")
	bf.force=Vector3.new(0,cp:GetMass()*196.2,0)
	bf.Parent=cp
	debris:AddItem(cp,7+math.random())
	cp.Parent=game.Workspace
end
sp.Touched:connect(function(hit)
	if (not attached) and hit and hit~=nil and sp~=nil then
		local ct=sp:FindFirstChild("creator")
		if ct.Value~=nil and ct.Value.Character~=nil then
			if hit.Parent~=ct.Value.Character and hit.Name~="Handle" and hit.Name~="Effect" then
				local h=hit.Parent:FindFirstChild("Humanoid")
				local t=hit.Parent:FindFirstChild("Torso")
				if h~=nil and t~=nil and h.Health>0 then
					attached=true
					local w=Instance.new("Weld")
					w.Part0=t
					w.Part1=sp
					w.C0=CFrame.new(0,0,.8)*CFrame.Angles(math.pi/2,3.5,0)
					w.Parent=sp
				end
			end
		end
	end
end)
while true do
	local percent=(tick()-starttime)/timer
	t1,t2=wait(((1-percent)*soundinterval))
	local beep=sp:FindFirstChild("Beep")
	if beep~=nil then
		beep:Play()
	end
	local bbg=sp:FindFirstChild("BillboardGui")
	if bbg~=nil then
		bbg.Adornee=sp
		li=bbg:FindFirstChild("LightImage")
		if li~=nil then
			li.Visible=true
		end
	end
	if percent>1 then
		break
	end
	wait(.1)
	if li then
		li.Visible=false
	end
end
wait(.5)
local smoke=sp:FindFirstChild("Smoke")
if smoke then
	smoke.Enabled=true
end
wait(.5)
local fusesound=sp:FindFirstChild("Fuse")
if fusesound~=nil then
	fusesound:Play()
end
local bbg=sp:FindFirstChild("BillboardGui")
if bbg~=nil then
	bbg.Adornee=sp
	li=bbg:FindFirstChild("LightImage")
	if li~=nil then
		li.Visible=false
	end
end
local partysound=sp:FindFirstChild("PleaseNo")
if partysound~=nil then
	partysound:Play()
end
for i=1,7 do
	makeconfetti()
end
wait(.5)
if smoke then
	smoke.Enabled=false
end
wait(2.5)
sp:remove()]]
	elseif v.Name == "ToolDropped" then
		source = [[--Made by Luckymaxer
Tool = script.Parent
Players = game:GetService("Players")
CurrentUFO = Tool:WaitForChild("CurrentUFO")
Tool.Changed:connect(function(Property)
	if Property == "Parent" then
		local Player = Players:GetPlayerFromCharacter(Tool.Parent)
		if not Tool.Parent:IsA("Backpack") and not Player and CurrentUFO and CurrentUFO.Value and CurrentUFO.Value.Parent then
			CurrentUFO.Value:Destroy()
		end
	end
end)]]
	elseif v.Name == "ToolDisplay" then
		source = [[--Made by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Mesh = Handle:WaitForChild("Mesh")
ToolDisplays = {
	Normal = {
		Grip = CFrame.new(0, -0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
		MeshScale = Vector3.new(0.25, 0.25, 0.25)
	},
	Display = {
		Grip = CFrame.new(1.5, 2.54999995, -1.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
		MeshScale = Vector3.new(3, 3, 3)
	}
}
Tool.Grip = ToolDisplays.Normal.Grip
Mesh.Scale = ToolDisplays.Normal.MeshScale]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("ToolDropped") then
		source = [[--Made by Luckymaxer
--[[
	Fixed by ArceusInator
	2/23 - The UFO now replicates properly
--]
		Tool = script.Parent
		Handle = Tool:WaitForChild("Handle")
		Players = game:GetService("Players")
		Debris = game:GetService("Debris")
		InsertService = game:GetService("InsertService")
		UFOModel = InsertService:LoadAsset(162741606)
		UFO = UFOModel:GetChildren()[1]:Clone()
		UFOModel:Destroy()
		CurrentUFO = Tool:WaitForChild("CurrentUFO")
		SpawnUFO = Tool:WaitForChild("SpawnUFO")
		RemoverScript = script:WaitForChild("Remover")
		Grips = {
			NormalGrip = CFrame.new(0, -0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
			SummoningGrip = CFrame.new(0.25, -0.75, 0, 1.12500096e-007, 1, -0, -0.99999994, 1.12500111e-007, 0, 0, 0, 1),
		}
		Equipped = false
		ReloadTime = 15
		function TransformModel(Parent, NewCFrame)
			local Origins = {}
			for i, v in pairs(Parent:GetChildren()) do
				if v:IsA("BasePart") then
					Origins[v] = Parent:GetModelCFrame():toObjectSpace(v.CFrame)
				end
			end
			for i, v in pairs(Origins) do
				i.CFrame = NewCFrame:toWorldSpace(v)
			end
		end
		function onMouse1Down()
			if Tool.Enabled and Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
				Tool.Enabled = false
				SpawnUFOAnim = Humanoid:LoadAnimation(SpawnUFO)
				if SpawnUFOAnim then
					SpawnUFOAnim:Play()
					wait(0.1)
					Tool.Grip = Grips.SummoningGrip
					wait(0.25)
					if Equipped then
						local TorsoCFrame = Torso.CFrame
						Handle.Transparency = 1
						UFODeploy = Handle:Clone()
						UFODeploy.Name = "MiniUFO"
						UFODeploy.Transparency = 0
						UFODeploy.CanCollide = true
						UFODeploy.CFrame = CFrame.new(Handle.Position)
						local UFOCloneY = UFODeploy:Clone()
						UFOCloneY.CFrame = UFOCloneY.CFrame * CFrame.Angles(math.rad(90), 0, 0)
						local BodyVelocity = Instance.new("BodyVelocity")
						BodyVelocity.maxForce = Vector3.new((UFODeploy:GetMass() * 196.20), (UFODeploy:GetMass() * 196.20) * 2, (UFODeploy:GetMass() * 196.20))
						BodyVelocity.velocity = UFOCloneY.CFrame.lookVector * 1.25
						BodyVelocity.Parent = UFODeploy
						local BodyGyro = Instance.new("BodyGyro")
						BodyGyro.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
						BodyGyro.cframe = UFODeploy.CFrame
						BodyGyro.Parent = UFODeploy
						Debris:AddItem(UFODeploy, 20)
						UFODeploy.Parent = game:GetService("Workspace")
						UFODeploy.CFrame = CFrame.new(Handle.Position) + Vector3.new(0, 0.1, 0)
						Delay(3, function()
							if UFODeploy and UFODeploy.Parent and BodyVelocity and BodyVelocity.Parent then
								BodyVelocity.velocity = TorsoCFrame.lookVector * 2.5
								wait(5)
								UFODeploy.Anchored = true
								UFODeploy.CanCollide = false
								Spawn(function()
									while UFODeploy and UFODeploy.Parent and UFODeploy.Mesh.Scale.Y < 3 do
										local NewScale = (UFODeploy.Mesh.Scale.Y + 0.05)
										UFODeploy.Mesh.Scale = Vector3.new(NewScale, NewScale, NewScale)
										wait()
									end
									if UFODeploy and UFODeploy.Parent then
										local UFOVehicle = UFO:Clone()
										local Creator = Instance.new("ObjectValue")
										Creator.Name = "Creator"
										Creator.Value = Player
										Creator.Parent = UFOVehicle
										local RemoverScriptClone = RemoverScript:Clone()
										RemoverScriptClone.Disabled = false
										RemoverScriptClone.Parent = UFOVehicle
										CurrentUFO.Value = UFOVehicle
										UFOVehicle.Parent = game:GetService("Workspace")
										UFOVehicle.Changed:connect(function(Property)
											if Property == "Parent" and not UFOVehicle.Parent then
												wait(ReloadTime)
												Handle.Transparency = 0
												Tool.Enabled = true
											end
										end)
										TransformModel(UFOVehicle, CFrame.new(UFODeploy.CFrame.p))
										if UFOVehicle.Engine.Position.Y < UFOVehicle.BeamPart.Position.Y then
											TransformModel(UFOVehicle, UFOVehicle:GetModelCFrame() * CFrame.Angles(0, math.pi, 0))
										end
										UFODeploy:Destroy()
									end
								end)
							end
						end)
						wait(2)
						Tool.Grip = Grips.NormalGrip
					end
				end
			end		
		end
		function onKeyDown(key)
			if key == "x" then
				if CurrentUFO.Value then
					CurrentUFO.Value:Destroy()
				end
			end
		end
		Tool.Input.OnServerEvent:connect(function(client, action, ...)
			if client.Character == Tool.Parent then
				if action == 'Mouse1Down' then
					onMouse1Down()
				elseif action == 'KeyDown' then
					onKeyDown(...)
				end
			end
		end)
		function Equipped()
			Character = Tool.Parent
			Player = Players:GetPlayerFromCharacter(Character)
			Humanoid = Character:FindFirstChild("Humanoid")
			Torso = Character:FindFirstChild("Torso")
			if not Player or not Humanoid and Humanoid.Health == 0 or not Torso then
				return
			end
			if not Tool.Enabled and not CurrentUFO.Value then
				wait(ReloadTime)
				Tool.Enabled = true
			end
			Equipped = true
			Tool.Grip = Grips.NormalGrip
		end
		function Unequipped()
			Equipped = false
			if SpawnUFOAnim then
				SpawnUFOAnim:Stop()
			end
			if UFODeploy and UFODeploy.Parent then
				UFODeploy:Destroy()
			end
			Handle.Transparency = 0
		end
		Tool.Equipped:connect(Equipped)
		Tool.Unequipped:connect(Unequipped)]]
	elseif v.Parent:FindFirstChild("DrumGui") then
		source = [[--Rescripted by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
function Equipped(Mouse)
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChild("Humanoid")
	Head = Character:FindFirstChild("Head")
	if not Player or not Humanoid or Humanoid.Health == 0 or not Head then
		return
	end
	Head.Anchored = true
	ForceSit = Humanoid.Changed:connect(function(Property)
		if Property == "Sit" and not Humanoid[Property] then
			Humanoid[Property] = true
		end
	end)
	Humanoid.Sit = true
end
function Unequipped()
	if ForceSit then
		ForceSit:disconnect()
	end
	if Humanoid and Humanoid.Parent then
		Humanoid.Sit = false
	end
	if Head and Head.Parent then
		Head.Anchored = false
	end
end
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("DisplayModel") then
		source = [[--Made by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
Assets = require(Tool:WaitForChild("Assets"))
Data = Assets.Data
ColorValue = Tool:WaitForChild("CurrentColor")
BaseUrl = Assets.BaseUrl
BasePart = Instance.new("Part")
BasePart.Material = Enum.Material.Plastic
BasePart.Shape = Enum.PartType.Block
BasePart.TopSurface = Enum.SurfaceType.Smooth
BasePart.BottomSurface = Enum.SurfaceType.Smooth
BasePart.FormFactor = Enum.FormFactor.Custom
BasePart.Size = Vector3.new(0.2, 0.2, 0.2)
BasePart.Anchored = false
BasePart.CanCollide = true
BasePart.Locked = true
Colors = {
	{Texture = 212640675, Color = BrickColor.new("Bright red")}, --Red
	{Texture = 212640593, Color = BrickColor.new("Bright orange")}, --Orange
	{Texture = 204410898, Color = BrickColor.new("Bright green")}, --Green
	{Texture = 212640633, Color = BrickColor.new("Bright blue")}, --Blue
	{Texture = 212640526, Color = BrickColor.new("Light blue")}, --Light Blue
	{Texture = 212640552, Color = BrickColor.new("Magenta")}, --Magenta
}
CurrentColor = 0
CycleTick = 0
CycleTime = 1
Animations = {
	Hold = {Animation = Tool:WaitForChild("Hold"), FadeTime = nil, Weight = nil, Speed = nil}
}
Sounds = {
	Honk = Handle:WaitForChild("Honk"),
	Engine = Handle:WaitForChild("Running")
}
Controls = {
	Forward = {Key = "w", ByteKey = 17, Mode = false},
	Backward = {Key = "s", ByteKey = 18, Mode = false},
	Left = {Key = "a", ByteKey = 20, Mode = false},
	Right = {Key = "d", ByteKey = 19, Mode = false}
}
	
Rate = (1 / 60)
	
Gravity = 196.20
	
PoseOffset = CFrame.new(0, -2, 0.5) * CFrame.Angles(0, 0, 0) --The offset your character is from the center of the vehicle.
SpeedBoost = {
	Allowed = false,
	Active = false,
	Enabled = true,
	Duration = 10,
	ReloadTime = 30
}
Special = {
	Allowed = false,
	Enabled = true,
	Active = false,
	Duration = 0,
	ReloadTime = 60
}
Speed = {
	Acceleration = {
		Normal = 40,
		Boost = 40
	},
	Deceleration = {
		Normal = 40,
		Boost = 40
	},
	MovementSpeed = {
		Normal = {Min = 20, Max = 70},
		Boost = {Min = 20, Max = 70}
	},
	TurnSpeed = {
		Speed = {Min = 5, Max = 5},
		TurnAlpha = 0.30,
		AlphaDampening = 0.2
	},
}
MaxSpeed = { --Maximum speed which the vehicle can move and turn at.
	Movement = Speed.MovementSpeed.Normal,
	Turn = Speed.TurnSpeed.Speed,
	Acceleration = Speed.Acceleration.Normal,
	Deceleration = Speed.Deceleration.Normal
}
CurrentSpeed = { --The speed which the vehicle is moving and turning at.
	Movement = 0,
	Turn = 0
}
Honk = {
	Honking = false,
	LastHonk = 0,
	ReloadTime = 1
}
Jump = {
	Jumping = false,
	LastJump = 0,
	ReloadTime = 1.9,
	JumpForce = 30
}
ToolEquipped = false
DisplayModel = Tool:FindFirstChild("DisplayModel")
if DisplayModel then
	DisplayModel:Destroy()
end
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
Tool.Enabled = true
function RayCast(Position, Direction, MaxDistance, IgnoreList)
	local IgnoreList = ((type(IgnoreList) == "table" and IgnoreList) or {IgnoreList})
	return game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(Position, Direction.unit * (MaxDistance or 999.999)), IgnoreList)
end
function GetAllConnectedParts(Object)
	local Parts = {}
	local function GetConnectedParts(Object)
		for i, v in pairs(Object:GetConnectedParts()) do
			local Ignore = false
			for ii, vv in pairs(Parts) do
				if v == vv then
					Ignore = true
				end
			end
			if not Ignore then
				table.insert(Parts, v)
				GetConnectedParts(v)
			end
		end
	end
	GetConnectedParts(Object)
	return Parts
end
function EnableFirstPersonView()
	if not CheckIfAlive() or not ToolEquipped then
		return
	end
	local Limbs = {"Left Arm", "Right Arm"}
	for i, v in pairs(Limbs) do
		local Limb = Character:FindFirstChild(v)
		if Limb:IsA("BasePart") then
			Spawn(function()
				InvokeClient("SetLocalTransparencyModifier", {Object = Limb, Transparency = 0, AutoUpdate = false})
			end)
		end
	end
end
function ThrustUpdater()
	
	for i, v in pairs(CurrentSpeed) do
		CurrentSpeed[i] = 0
	end
	for i, v in pairs(Controls) do
		Controls[i].Mode = false
	end
	while ToolEquipped and Body and Body.Parent and CheckIfAlive() and RotationForce and RotationForce.Parent and ThrustForce and ThrustForce.Parent and TurnGyro and TurnGyro.Parent do
		
		RotationForce.angularvelocity = Vector3.new(0, CurrentSpeed.Turn, 0)
		if math.abs(CurrentSpeed.Turn) > Speed.TurnSpeed.AlphaDampening then
			CurrentSpeed.Turn = (CurrentSpeed.Turn - (Speed.TurnSpeed.AlphaDampening * (math.abs(CurrentSpeed.Turn) / CurrentSpeed.Turn)))
		else 
			CurrentSpeed.Turn = 0		
		end
				
		if not Controls.Forward.Mode or Controls.Backward.Mode then --Slow down if not controlling.
			CurrentSpeed.Movement = (CurrentSpeed.Movement * 0.99)
		end
		
		local MySpeed = Vector3.new(Body.Velocity.X, 0, Body.Velocity.Z).magnitude
		local VelocityDifference = math.abs((MySpeed - (ThrustForce.velocity.magnitude)))
		if MySpeed > 3 and ThrustForce.velocity.magnitude > 3 and VelocityDifference > (0.7 * ThrustForce.velocity.magnitude) then
			CurrentSpeed.Movement = (CurrentSpeed.Movement * 0.9)
		end
		
		if Controls.Forward.Mode then --Handle acceleration
			CurrentSpeed.Movement = math.min(MaxSpeed.Movement.Max, (CurrentSpeed.Movement + (MaxSpeed.Acceleration * Rate)))
		end
		if Controls.Backward.Mode then --Handle deceleration, if speed is more than 0, decrease quicker.
			CurrentSpeed.Movement = math.max(-MaxSpeed.Movement.Min, (CurrentSpeed.Movement - (MaxSpeed.Deceleration * ((CurrentSpeed.Movement > 0 and 2.8) or 1) * Rate)))
		end
		
		if Controls.Left.Mode then --Handle left turn speed
			CurrentSpeed.Turn = math.min(Speed.TurnSpeed.Speed.Max, (CurrentSpeed.Turn + (Speed.TurnSpeed.TurnAlpha)))
		end
		if Controls.Right.Mode then --Handle right turn speed
			CurrentSpeed.Turn = math.max(-Speed.TurnSpeed.Speed.Min, (CurrentSpeed.Turn - (Speed.TurnSpeed.TurnAlpha)))
		end
		
		local Direction = Torso.CFrame.lookVector
		Direction = Vector3.new(Direction.x, 0, Direction.z).unit
		
		local Velocity = (Direction * CurrentSpeed.Movement) --The thrust force which you move.
		ThrustForce.velocity = Vector3.new(Velocity.X, ThrustForce.velocity.Y, Velocity.Z)
		
		local LeanAmount = (-CurrentSpeed.Turn * (math.pi / 6) / 4) --Amount your character leans over.
		local XZAngle = math.atan2(Torso.CFrame.lookVector.z, 0, Torso.CFrame.lookVector.x) --Handle rotation
		TurnGyro.cframe = CFrame.Angles((LeanAmount * Direction.x), 0, (LeanAmount * Direction.z))
		
		--Wheel animation
		local DesiredAngle = (999999999 * (-CurrentSpeed.Movement / math.abs(CurrentSpeed.Movement)))
		local MaxVelocity = (CurrentSpeed.Movement / 250)
		for i, v in pairs({FrontMotor, BackMotor, LeftMotor, RightMotor}) do
			if v and v.Parent then
				v.DesiredAngle = DesiredAngle
				v.MaxVelocity = MaxVelocity
			end
		end
		
		--Smoke exhaust from vehicle running.
		for i, v in pairs(ExhaustSmoke) do
			if v and v.Parent then
				v.Opacity = ((math.min(math.abs(CurrentSpeed.Movement), 10) / 10) * 0.5)
			end
		end
		
		--Engine running sound which pitch changes while in motion.
		Sounds.Engine.Pitch = (1 + (math.abs(CurrentSpeed.Movement / MaxSpeed.Movement.Max) * 1))
		
		if (tick() - CycleTick) >= CycleTime then
			CycleTick = tick()
			CurrentColor = (CurrentColor + 1)
			CurrentColor = ((CurrentColor > #Colors and 1) or CurrentColor)
			local ColorTable = Colors[CurrentColor]
			ColorValue.Value = ColorTable.Color.Color
			local Parts = {Body}
			for i, v in pairs(Body:GetChildren()) do
				if v:IsA("BasePart") then
					table.insert(Parts, v)
				end
			end
			for i, v in pairs(Parts) do
				if v ~= Body then
					v.BrickColor = ColorTable.Color
				end
				for ii, vv in pairs(v:GetChildren()) do
					if vv:IsA("FileMesh") then
						vv.TextureId = (BaseUrl .. ColorTable.Texture)
					elseif vv:IsA("Light") then
						vv.Color = ColorTable.Color.Color
					elseif vv:IsA("BasePart") then
					end
				end
			end
		end
		
		wait(Rate)
		
	end
end
function SpawnVehicle()
	
	Handle.Transparency = 1
	
	Spawn(function()
		InvokeClient("PlaySound", Sounds.Engine)
		InvokeClient("PlayAnimation", Animations.Hold)
	end)	
	
	Humanoid.PlatformStand = true
	
	CurrentColor = math.random(1, #Colors)
	ColorValue.Value = Colors[CurrentColor].Color.Color
	
	local OrigCF = Torso.CFrame
	
	local VehicleData = Assets.CreateVehicle()
	Body = VehicleData.Vehicle
	local ParticleTable = VehicleData.Tables
	
	FrontMotor = Body.FrontMotor
	BackMotor = Body.BackMotor
	LeftMotor = Body.LeftMotor
	RightMotor = Body.RightMotor
	
	Seat = Body.Seat
	Seat.ChildAdded:connect(function(Child)
		if Child:IsA("Weld") and Child.Name == "SeatWeld" then
			Child.C1 = (CFrame.new(0, 0.75, -1) * CFrame.Angles(Child.C1:toEulerAnglesXYZ()))
		end
	end)
	
	ExhaustSmoke = ParticleTable.ExhaustSmoke
	Lights = ParticleTable.Lights
	Sparkles = ParticleTable.Sparkles
	
	if SpeedBoost.Active then
		for i, v in pairs(Sparkles) do
			if v and v.Parent then
				v.Enabled = true
			end
		end
	end
	
	local TorsoWeld = Instance.new("Weld")
	TorsoWeld.C0 = PoseOffset
	TorsoWeld.Part0 = Torso
	TorsoWeld.Part1 = Body
	TorsoWeld.Parent = Body
	
	Body.CanCollide = true
	RotationForce = Instance.new("BodyAngularVelocity")
	RotationForce.maxTorque = Vector3.new(0, math.huge, 0)
	RotationForce.angularvelocity = Vector3.new(0, 0, 0)
	RotationForce.Parent = Torso
	
	ThrustForce = Instance.new("BodyVelocity")
	ThrustForce.maxForce = Vector3.new(math.huge, 0, math.huge)
	ThrustForce.velocity = Vector3.new(0, 0, 0)
	ThrustForce.P = 100
	ThrustForce.Parent = Torso
	
	TurnGyro = Instance.new("BodyGyro")
	TurnGyro.maxTorque = Vector3.new(5000, 0, 5000)
	TurnGyro.P = 300
	TurnGyro.D = 100
	TurnGyro.Parent = Torso
	
	Body.Parent = Tool
	
	Torso.CFrame = OrigCF
	
	local RayHit, RayPos, RayNormal = RayCast(Torso.Position, Vector3.new(0, -1, 0), (Torso.Size.Y * 2), {Character})
	if RayHit then
		Torso.CFrame = Torso.CFrame + Vector3.new(0, ((Character:GetModelSize().Y / 2) + 1.5), 0)
	end
	
	Spawn(ThrustUpdater)
	
end
function FreezePlayer()
	if CheckIfAlive() then
		local FreezePart = BasePart:Clone()
		FreezePart.Name = "FreezePart"
		FreezePart.Transparency = 1
		FreezePart.Anchored = true
		FreezePart.CanCollide = false
		local FreezeWeld = Instance.new("Weld")
		FreezeWeld.Part0 = Torso
		FreezeWeld.Part1 = FreezePart
		FreezeWeld.Parent = FreezePart
		Debris:AddItem(FreezePart, 0.125)
		FreezePart.Parent = Character
		Torso.Velocity = Vector3.new(0, -25, 0)
		Torso.RotVelocity = Vector3.new(0, 0, 0)
	end
end
function CleanUp()
	Handle.Velocity = Vector3.new(0, 0, 0)
	Handle.RotVelocity = Vector3.new(0, 0, 0)
	for i, v in pairs({}) do
		if v then
			v:disconnect()
		end
	end
	if Seat and Seat.Parent and Seat.Occupant then
		local humanoid = Seat.Occupant
		if humanoid and humanoid:IsA("Humanoid") then
			humanoid.Sit = false
		end
	end
	for i, v in pairs({Body, RotationForce, ThrustForce, TurnGyro}) do
		if v and v.Parent then
			v:Destroy()
		end
	end
	for i, v in pairs(Tool:GetChildren()) do
		if v:IsA("BasePart") and v ~= Handle then
			v:Destroy()
		end
	end
end
function CheckIfAlive()
	return (((Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent and Player and Player.Parent) and true) or false)
end
function Equipped(Mouse)
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChild("Humanoid")
	Torso = Character:FindFirstChild("Torso")
	if not CheckIfAlive() then
		return
	end
	for i, v in pairs(Colors) do
		Spawn(function()
			InvokeClient("Preload", (BaseUrl .. v.Texture))
		end)
	end
	Spawn(CleanUp)
	Spawn(EnableFirstPersonView)
	Spawn(SpawnVehicle)
	ToolEquipped = true
end
function Unequipped()
	Spawn(CleanUp)
	Spawn(FreezePlayer)
	for i, v in pairs(Sounds) do
		v:Stop()
		Spawn(function()
			InvokeClient("StopSound", v)
		end)
	end
	if CheckIfAlive() then
		Humanoid.PlatformStand = false
	end
	Handle.Transparency = 0
	ToolEquipped = false
end
function OnServerInvoke(player, mode, value)
	if player == Player and ToolEquipped and value and CheckIfAlive() then
		if mode == "KeyPress" then
			local Down = value.Down
			local Key = value.Key
			local ByteKey = string.byte(Key)
			for i, v in pairs(Controls) do
				if Key == v.Key or ByteKey == v.ByteKey then
					Controls[i].Mode = Down
				end
			end
			if Key == " " and Down then --Jump controller
				if math.abs(tick() - Jump.LastJump) > Jump.ReloadTime and not Jump.Jumping and ThrustForce and ThrustForce.Parent then
					Jump.Jumping = true
					local Parts = GetAllConnectedParts(Body)
					local Mass = 0
					for i, v in pairs(Parts) do
						Mass = (Mass + v:GetMass())
					end
					ThrustForce.maxForce = Vector3.new(ThrustForce.maxForce.X, ((Mass * Gravity) * 100), ThrustForce.maxForce.Z)
					ThrustForce.velocity = (Vector3.new(0, 1, 0) * Jump.JumpForce) + Vector3.new(ThrustForce.velocity.X, 0, ThrustForce.velocity.Z)
					wait(0.1)
					ThrustForce.maxForce = Vector3.new(ThrustForce.maxForce.X, 0, ThrustForce.maxForce.Z)
					ThrustForce.velocity = Vector3.new(ThrustForce.velocity.X, 0, ThrustForce.velocity.Z)
					Jump.LastJump = tick()
					Jump.Jumping = false
				end
			elseif Key == "x" and Down then --Toggle light(s) on/off.
				for i, v in pairs(Lights) do
					if v and v.Parent then
						v.Enabled = not v.Enabled
					end
				end
			elseif Key == "h" and Down then --Play honk sound.
				local Sound = Sounds.Honk
				if (tick() - Honk.LastHonk) >= (Sound.TimeLength + Honk.ReloadTime) and not Honk.Honking then
					Honk.Honking = true
					local TempSound = Sound:Clone()
					Debris:AddItem(TempSound, Sound.TimeLength)
					TempSound.Parent = Body
					TempSound:Play()
					Honk.LastHonk = tick()
					Honk.Honking = false
				end
			elseif Key == "q" and Down then --Activate special.
				if not Special.Allowed or not Special.Enabled or Special.Active then
					return
				end
				Special.Enabled = false
				Special.Active = true
				wait(Special.Duration)
				Special.Active = false
				wait(Special.ReloadTime)
				Special.Enabled = true
			elseif ByteKey == 48 and Down then --Activate speed boost.
				if not SpeedBoost.Allowed or not SpeedBoost.Enabled or SpeedBoost.Active then
					return
				end
				SpeedBoost.Enabled = false
				SpeedBoost.Active = true
				for i, v in pairs(Sparkles) do
					if v and v.Parent then
						v.Enabled = true
					end
				end
				MaxSpeed.Acceleration = Speed.Acceleration.Boost
				MaxSpeed.Deceleration = Speed.Deceleration.Boost
				MaxSpeed.Movement = Speed.MovementSpeed.Boost
				wait(SpeedBoost.Duration)
				MaxSpeed.Acceleration = Speed.Acceleration.Normal
				MaxSpeed.Deceleration = Speed.Deceleration.Normal
				MaxSpeed.Movement = Speed.MovementSpeed.Normal
				for i, v in pairs(Sparkles) do
					if v and v.Parent then
						v.Enabled = false
					end
				end
				SpeedBoost.Active = false
				wait(SpeedBoost.ReloadTime)
				SpeedBoost.Enabled = true
			end
		end
	end
end
function InvokeClient(Mode, Value)
	local ClientReturn = nil
	pcall(function()
		ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
	end)
	return ClientReturn
end
Spawn(CleanUp)
ServerControl.OnServerInvoke = OnServerInvoke
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "TrailScript" and v.Parent:FindFirstChild("DisplayModel") then
		source = [[--Made by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Debris = game:GetService("Debris")
CurrentColor = Tool:WaitForChild("CurrentColor")
BasePart = Instance.new("Part")
BasePart.Shape = Enum.PartType.Block
BasePart.Material = Enum.Material.Plastic
BasePart.TopSurface = Enum.SurfaceType.Smooth
BasePart.BottomSurface = Enum.SurfaceType.Smooth
BasePart.FormFactor = Enum.FormFactor.Custom
BasePart.Anchored = false
BasePart.CanCollide = true
BasePart.Locked = true
BaseTrailPart = BasePart:Clone()
BaseTrailPart.Name = "LaserTrail"
BaseTrailPart.Transparency = 0.2
BaseTrailPart.Size = Vector3.new(0.5, 5, 3)
BaseTrailPart.Material = Enum.Material.SmoothPlastic
BaseTrailPart.TopSurface = Enum.SurfaceType.SmoothNoOutlines
BaseTrailPart.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
BaseTrailPart.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
BaseTrailPart.RightSurface = Enum.SurfaceType.SmoothNoOutlines
BaseTrailPart.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
BaseTrailPart.BackSurface = Enum.SurfaceType.SmoothNoOutlines
BaseTrailPart.Anchored = true
BaseTrailPart.CanCollide = false
TrailLight = Instance.new("PointLight")
TrailLight.Name = "Light"
TrailLight.Brightness = 10
TrailLight.Range = 8
TrailLight.Shadows = false
TrailLight.Enabled = true
TrailLight.Parent = BaseTrailPart
Rate = (1 / 60)
function StartTrail(Source, Parent)
	
	local TrailParts = {}
	
	local SourceAlive = true
	local NumberOfParts = 60
	local LastPoint = (Source.CFrame * CFrame.new(0, 0, 4)).p
	
	Source.Changed:connect(function(Property)
		if Property == "Parent" and not Source.Parent then
			SourceAlive = false
		end
	end)
	
	while SourceAlive do
		local CurrentPoint = (Source.CFrame * CFrame.new(-1.125, 0, 4)).p
		if Source.Velocity.magnitude > 20 then
			local TrailPart = BaseTrailPart:Clone()
			TrailPart.BrickColor = BrickColor.new(CurrentColor.Value)
			TrailPart.Light.Color = CurrentColor.Value
			TrailPart.Size = Vector3.new(TrailPart.Size.X, TrailPart.Size.Y, (CurrentPoint - LastPoint).magnitude)
			table.insert(TrailParts, TrailPart)
			TrailPart.Parent = Parent
			TrailPart.CFrame = CFrame.new(((CurrentPoint + LastPoint) * 0.5), LastPoint)
			if #TrailParts > NumberOfParts then
				local TrailPart = TrailParts[1]
				if TrailPart and TrailPart.Parent then
					TrailPart:Destroy()
				end
				table.remove(TrailParts, 1)
			end
		else
			local TrailPart = TrailParts[1]
			if TrailPart and TrailPart.Parent then
				TrailPart:Destroy()
			end
			table.remove(TrailParts, 1)
		end
		LastPoint = CurrentPoint
		wait(Rate)
	end
	
	for i, v in pairs(TrailParts) do
		if v and v.Parent then
			v:Destroy()
		end
	end
	
end
Tool.ChildAdded:connect(function(Child)
	if Child.Name == "Body" then
		Spawn(function()
			StartTrail(Child, Tool)
		end)
	end
end)]]
	elseif v.Name == "BlowDryer" then
		source = [[--Rescripted by Luckymaxer
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Players = game:GetService("Players")
Debris = game:GetService("Debris")
AirScript = script:WaitForChild("AirScript")
Colors = {"White", "Light stone grey", "Light blue", "Pastel Blue"} 
BasePart = Instance.new("Part")
BasePart.Shape = Enum.PartType.Block
BasePart.Material = Enum.Material.Plastic
BasePart.TopSurface = Enum.SurfaceType.Smooth
BasePart.BottomSurface = Enum.SurfaceType.Smooth
BasePart.FormFactor = Enum.FormFactor.Custom
BasePart.Size = Vector3.new(0.2, 0.2, 0.2)
BasePart.CanCollide = true
BasePart.Locked = true
BasePart.Anchored = false
AirBubble = BasePart:Clone()
AirBubble.Name = "Effect"
AirBubble.Shape = Enum.PartType.Ball
AirBubble.Size = Vector3.new(2, 2, 2)
AirBubble.CanCollide = false
Gravity = 196.20
Sounds = {
	DryerSound = Handle:WaitForChild("DryerSound")
}
MouseDown = false
ToolEquipped = false
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
Tool.Enabled = true
function Fire(Direction)
	
	if not Tool.Enabled or not CheckIfAlive() then
		return
	end
	
	local SpawnPos = Handle.Position + (Direction * 7.5)
	
	local Offset = Vector3.new(
		((math.random() - 0.5) * 50),
		((math.random() - 0.5) * 50),
		((math.random() - 0.5) * 50)
	)
	local Force = 80
	local Air = AirBubble:Clone()
	Air.Transparency = (math.random() * 0.5)
	Air.CFrame = CFrame.new(SpawnPos, Vector3.new(Offset.X, Offset.Y, Offset.Z))
	Air.Velocity = (Direction * Force)
	Air.BrickColor = BrickColor.new(Colors[math.random(1, #Colors)])
	
	local Mass = (Air:GetMass() * Gravity)
	
	local BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.maxForce = Vector3.new(Mass, Mass, Mass)
	BodyVelocity.velocity = (Direction * Force)
	BodyVelocity.Parent = Air
	
	local Creator = Instance.new("ObjectValue")
	Creator.Name = "Creator"
	Creator.Value = Player
	Creator.Parent = Air
	
	local AirScriptClone = AirScript:Clone()
	AirScriptClone.Disabled = false
	AirScriptClone.Parent = Air
	
	Debris:AddItem(Air, 2)
	
	Air.Parent = game:GetService("Workspace")
end
function CheckIfAlive()
	return (((Player and Player.Parent and Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0) and true) or false)
end
function Equipped()
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChild("Humanoid")
	if not CheckIfAlive() then
		return
	end
	ToolEquipped = true
end
function Unequipped()
	MouseDown = false
	ToolEquipped = false
end
function InvokeClient(Mode, Value)
	local ClientReturn = nil
	pcall(function()
		ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
	end)
	return ClientReturn
end
ServerControl.OnServerInvoke = (function(player, Mode, Value)
	if player ~= Player or not ToolEquipped or not CheckIfAlive() or not Mode or not Value then
		return
	end
	if Mode == "Button1Click" then
		local Down = Value.Down
		if Down and not MouseDown and Tool.Enabled then
			MouseDown = true
			Spawn(function()
				Sounds.DryerSound:Play()
				local Rate = (1 / 60)
				local MaxDuration = 2
				local StartTime = tick()
				if ToolUnequipped then
					ToolUnequipped:disconnect()
				end
				local CurrentlyEquipped = true
				ToolUnequipped = Tool.Unequipped:connect(function()
					CurrentlyEquipped = false
				end)
				while MouseDown and ToolEquipped and CheckIfAlive() and (tick() - StartTime) < MaxDuration do
					local TargetPos = InvokeClient("MousePosition")
					if TargetPos then
						TargetPos = TargetPos.Position
						Spawn(function()
							for i = 1, math.random(2, 3) do
								if CurrentlyEquipped then
									local Direction = (TargetPos - Handle.Position).unit
									local Offset = Vector3.new(
										((math.random() - 0.5) * 0.3),
										((math.random() - 0.5) * 0.3),
										((math.random() - 0.5) * 0.3)
									)
									Fire(Vector3.new((Direction.X + Offset.X), (Direction.Y + Offset.Y), (Direction.Z + Offset.Z)))
									wait(0.1)
								end
							end
						end)
					end
					wait(Rate)
				end
				Sounds.DryerSound:Stop()
				Tool.Enabled = false
				wait(1)
				Tool.Enabled = true
			end)
		elseif not Down and MouseDown then
			MouseDown = false
		end
	end
end)
Tool.Equipped:connect(Equipped)
Tool.Unequipped:connect(Unequipped)]]
	elseif v.Name == "AirScript" then
		source = [[--Rescripted by Luckymaxer
--Updated for R15 avatar by StarWars
Part = script.Parent
Players = game:GetService("Players")
Debris = game:GetService("Debris")
Creator = Part:FindFirstChild("Creator")
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
function Touched(Hit)
	if not Hit or not Hit.Parent then
		return
	end
	local character = Hit.Parent
	if character:IsA("Hat") then
		character = character.Parent
	end
	for i, v in pairs(character:GetChildren()) do
		if v:IsA("ForceField") then
			return
		end
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid or humanoid.Health == 0 then
		return
	end
	local CreatorPlayer = (((Creator and Creator.Value and Creator.Value:IsA("Player")) and Creator.Value) or nil)
	local player = Players:GetPlayerFromCharacter(character)
	if CreatorPlayer and player and (CreatorPlayer == player or IsTeamMate(CreatorPlayer, player)) then
		return
	end
	local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
	if not torso then
		return
	end
	local WindEffect = torso:FindFirstChild("WindEffect")
	if WindEffect then
		return
	end
	local Direction = Part.Velocity.unit
	local WindEffect = Instance.new("BodyVelocity")
	WindEffect.Name = "WindEffect"
	WindEffect.maxForce = Vector3.new(1e7, 1e7, 1e7)
	WindEffect.P = 125
	WindEffect.velocity = ((Direction * 75) + Vector3.new(0, 30, 0))
	Debris:AddItem(WindEffect, 0.5)
	WindEffect.Parent = torso
	Debris:AddItem(Part, 0)
	Part:Destroy()
end
Part.Touched:connect(Touched)
Debris:AddItem(Part, 2)]]
	elseif v.Parent:FindFirstChild("R15CoastingPose") then
		source = [[--Rescripted by Luckymaxer
--Made by Stickmasterluke
--// Fixed for R15 avatars by StarWars
-- Fixed for mobile support by Luke, again
Tool = script.Parent
Handle = Tool:WaitForChild("Handle")
Mesh = Handle:WaitForChild("Mesh")
local Cloud
Players = game:GetService("Players")
Debris = game:GetService("Debris")
BasePart = Instance.new("Part")
BasePart.Shape = Enum.PartType.Block
BasePart.Material = Enum.Material.Plastic
BasePart.TopSurface = Enum.SurfaceType.Smooth
BasePart.BottomSurface = Enum.SurfaceType.Smooth
BasePart.FormFactor = Enum.FormFactor.Custom
BasePart.Anchored = false
BasePart.Locked = true
BasePart.CanCollide = true
Sounds = {
	Wind = Handle:WaitForChild("Wind")
}
BaseScale = Vector3.new(3, 3, 3)
Rate = (1 / 60)
Flying = false
ToolEquipped = false
ServerControl = (Tool:FindFirstChild("ServerControl") or Instance.new("RemoteFunction"))
ServerControl.Name = "ServerControl"
ServerControl.Parent = Tool
ClientControl = (Tool:FindFirstChild("ClientControl") or Instance.new("RemoteFunction"))
ClientControl.Name = "ClientControl"
ClientControl.Parent = Tool
Mesh.Scale = BaseScale
Handle.Transparency = 0
Tool.Enabled = true
function RemoveFlyStuff()
	for i, v in pairs(Tool:GetChildren()) do
		if v:IsA("BasePart") and v.Name == "EffectCloud" then
			v:Destroy()
		end
		for i, v in pairs(Sounds) do
			v:Stop()
		end
	end
end
function CheckIfAlive()
	return (((Player and Player.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent) and true) or false)
end
function Equipped()
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChild("Humanoid")
	Torso = Character:FindFirstChild("HumanoidRootPart")
	if not CheckIfAlive() then
		return
	end
	spawn(function()
		Handle.Transparency = 0
		RemoveFlyStuff()
	end)
	Flying = false
	ToolEquipped = true
end
function Unequipped()
	Handle.Transparency = 0
	RemoveFlyStuff()
	Flying = false
	ToolEquipped = false
end
function OnServerInvoke(player, mode, value)
	if player ~= Player or not value or not CheckIfAlive() or not ToolEquipped then
		return
	end
	print(mode)
	if mode == "Fly" then
		local Fly = value.Flying
		Flying = Fly
		if Cloud and Cloud.Parent then
			Cloud:Destroy()
		end
		Handle.Transparency = ((Flying and 1) or 0)
		if Flying then
			Cloud = Handle:Clone()
			Cloud.Name = "EffectCloud"
			Cloud.Transparency = 0
			Cloud.CanCollide = false
			--[[local Wind = Cloud:FindFirstChildOfClass("Sound")
			if Wind then
				Wind:Play()
			end]
		local Smoke = Cloud:FindFirstChild("Smoke")
		if Smoke then
			Smoke.Enabled = true
		end
		local Weld = Instance.new("Weld")
		Weld.Part0 = Torso
		Weld.Part1 = Cloud
		Weld.C0 = (CFrame.new(1, -4, 0) * CFrame.Angles(0, (math.pi / 2), 0))
		Weld.C1 = CFrame.new(0, 0, 0)
		Weld.Parent = Cloud
		Cloud.Parent = Tool
		return Cloud
	end
	elseif mode == "SetSound" then
	if Sounds.Wind then
		--print("Changing Sound")
		Sounds.Wind.Pitch = ((value * 2) + 1)
		Sounds.Wind.Volume = (value + 0.1)
	end

elseif mode == "SetMesh" then
	local CloudMesh = Cloud:FindFirstChildOfClass("SpecialMesh")
	if Cloud and CloudMesh then
		print("Changing Mesh")
		CloudMesh.Scale = Vector3.new(4, 4, (4 + (value * 4)))
	end

elseif mode == "ToggleSound" then
	local Sound = Sounds.Wind
	local Playing = value
	if not Sound then
		return
	end
	if Playing then
		Sound:Play()
	else
		Sound:Stop()
	end
end
end
function InvokeClient(Mode, Value)
	local ClientReturn = nil
	pcall(function()
		ClientReturn = ClientControl:InvokeClient(Player, Mode, Value)
	end)
	return ClientReturn
end
for i, v in pairs(Tool:GetChildren()) do
	if v:IsA("BasePart") and v ~= Handle then
		v:Destroy()
	end
end
ServerControl.OnServerInvoke = OnServerInvoke
Tool.Equipped:Connect(Equipped)
Tool.Unequipped:Connect(Unequipped)]]
	elseif v.Name == "SpeedEffect" then
		source = [[-- assume we are in the character, let's check
function sepuku()
	script.Parent = nil
end
local debris = game:GetService("Debris")
local h = script.Parent:FindFirstChild("Humanoid")
if (h == nil) then sepuku() end
local torso = script.Parent:FindFirstChild("Torso") or script.Parent:FindFirstChild("UpperTorso")
if (torso == nil) then sepuku() end
local head = script.Parent:FindFirstChild("Head")
if (head == nil) then head = torso end
local equalizingForce = 236 / 1.2 -- amount of force required to levitate a mass
local gravity = .75 -- things float at > 1
local fire = Instance.new("Fire")
fire.Parent = head
fire.Heat = 10
fire.Size = 3
function recursiveGetLift(node)
	local m = 0
	local c = node:GetChildren()
	if (node:FindFirstChild("Head") ~= nil) then head = node:FindFirstChild("Head") end -- nasty hack to detect when your parts get blown off
	for i=1,#c do
		if c[i].className == "Part" then
			if (head ~= nil and (c[i].Position - head.Position).magnitude < 10) then -- GROSS
				if c[i].Name == "Handle" then
					m = m + (c[i]:GetMass() * equalizingForce * 1) -- hack that makes hats weightless, so different hats don't change your jump height
				else
					m = m + (c[i]:GetMass() * equalizingForce * gravity)
				end
			end
		end
		m = m + recursiveGetLift(c[i])
	end
	return m
end
function jumpIt()
	local mass = recursiveGetLift(h.Parent)
	local force = Instance.new("BodyForce")
	force.force = Vector3.new(0,mass * 2,0)
	force.Parent = torso
	debris:AddItem(force,0.5)
end
local con = h.Jumping:connect(jumpIt)
local oldSpeed = h.WalkSpeed
h.WalkSpeed = h.WalkSpeed * 1.6
local oldMaxHealth = h.MaxHealth
h.MaxHealth = oldMaxHealth * 1.5
h.Health = h.MaxHealth
local bodySpin = Instance.new("BodyAngularVelocity")
bodySpin.P = 200000
bodySpin.angularvelocity = Vector3.new(0,15,0)
bodySpin.maxTorque = Vector3.new(bodySpin.P,bodySpin.P,bodySpin.P)
bodySpin.Parent = torso
wait(30)
fire:Destroy()
h.WalkSpeed = oldSpeed
h.MaxHealth = oldMaxHealth
if h.Health > 60 then
	h.Health = 60
end
con:disconnect()
bodySpin:Destroy()
sepuku()]]
	elseif v.Name == "Script" and v.Parent:FindFirstChild("Lobby") and v.Parent:FindFirstChild("Lobby"):IsA("SpawnLocation") then
		source = [[local Players=game:GetService("Players")
local plrFromChar=Players.GetPlayerFromCharacter
local BadgeService=game:GetService("BadgeService")
local Lobby=script.Parent
local BadgeId=2124450213

for i,v in pairs(Lobby:GetChildren()) do
	if v:IsA("BasePart") then
		if v.Name=="Wall" then
			v.Touched:Connect(function(part)
				local c=part:FindFirstAncestorWhichIsA("Model")
				if c then
					local p=plrFromChar(Players,c)
					if p then
						BadgeService:AwardBadge(p.UserId,BadgeId)
					end
				end
			end)
		end
	end
end]]
	elseif v.Name == "Kill" and v.Parent.Name == "Baseplate" then
		source = [[script.Parent.Touched:connect(function(Part)
	if Part.Parent then
		local h=Part.Parent:FindFirstChild("Humanoid")
		if h then
			h:TakeDamage(h.MaxHealth) -- forcefielded people can pass through
		end
	end
end)
]]
	elseif v.Name == "onDied" and v.Parent:FindFirstChildOfClass("Humanoid") then
		source = [[local char=script.Parent
local humanoid=char:WaitForChild("Humanoid")
local hrp=char:WaitForChild("HumanoidRootPart")
local Alive = true -- since it's copied to the player everytime, everytime this script will run the player will be alive
local BadgeId=2124444600
local GroupService=game:GetService("GroupService")
local BadgeService=game:GetService("BadgeService")

humanoid.Died:connect(function()
	if Alive == true then -- if the player is alive
		Alive = false -- then don't let it fire multiple times
		wait(0.25) -- sometimes the explosion creator values are given after death, so this wait time allows those values to be provided before checking for a creator value (line 12)
		local player=game.Players:GetPlayerFromCharacter(char)
		local WOs=player.leaderstats.WOs
		local KOs=player.leaderstats.KOs
		local killer=humanoid:FindFirstChild("creator")
		
		WOs.Value=WOs.Value+1
		if killer then
			print(humanoid.Parent.Name.." was killed by "..killer.Value.Name.."!")
			if player~=killer.Value then
				killer.Value.leaderstats.KOs.Value=killer.Value.leaderstats.KOs.Value+1
				pcall(function()
					if player.Name==GroupService:GetGroupInfoAsync(game.CreatorId).Owner.Name then
						if not BadgeService:UserHasBadgeAsync(killer.Value.UserId,BadgeId) then
							BadgeService:AwardBadge(killer.Value.UserId,BadgeId)
						end
					end
				end)
			end
		end
		local x=workspace:GetDescendants()
		for i=1,#x do
			if x[i].Name=="GameValues" then
				local y=x[i].Teams:GetChildren()
				for s=1,#y do
					if y[s].Value==player.TeamColor then
						if y[s].Spawns.Value==0 then
							player.TeamColor=BrickColor.new(1001)
							game.ReplicatedStorage.Remotes.ChangeTeam:FireClient(player,player.TeamColor)
							player:WaitForChild("AntiTeamKill",5).Value=false
						end
					end
				end
			end
		end
		wait(1) -- -0.5 because of line 7
		player:LoadCharacter()
	end
end)

humanoid.ChildAdded:connect(function(Obj)
	if Obj.Name=="creator" then
		wait(.5)
		Obj:Destroy()
	end
end)

hrp.ChildAdded:connect(function(Obj)
	if Obj:IsA("BodyMover") then
		wait(.5)
		Obj:Destroy()
	end
end)]]
	elseif v.Parent:FindFirstChild("RocketDestroyEvent") then
		source = [[local Rocket = Instance.new("Part")
Rocket.Locked = true
Rocket.BackSurface = 3
Rocket.BottomSurface = 3
Rocket.FrontSurface = 3
Rocket.LeftSurface = 3
Rocket.RightSurface = 3
Rocket.TopSurface = 3
Rocket.Size = Vector3.new(1,1,4)
Rocket.BrickColor = BrickColor.new(23)
Rocket.CanCollide = false

local ModFx=require(game.ReplicatedStorage.Other)
local Tool=script.Parent
local Reload_Enabled=false --Go to StarterPlayer.StarterPlayerScripts.LocalScript for an explnation of why this works
--local Player=ModFx.GetPlayerFromTool(Tool) --[[This will be refreshed throughout the script 
--											so that if someone wanted to make the tools 
--											droppable, itd work with other players	]
		-- commented cause its useless as a global variable, however not deleted so as to keep the above comments
		local ColSer=game:GetService("CollectionService")
		local Debris=game:GetService("Debris")

		local function FireWep(plr,targetPos)
			if Tool.Enabled==false then return end
			local Player=ModFx.GetPlayerFromTool(Tool)
			if plr~=Player then return end
			local c=plr.Character
			if not c then return end
			local h=c:FindFirstChildWhichIsA("Humanoid")
			local plrTool=c:FindFirstChildWhichIsA("Tool")
			local Head=c:FindFirstChild("Head")
			if not Head or not plrTool or not h then return end
			if plrTool~=Tool then return end
			if h.Health<=0 then return end

			Tool.Enabled=false

			local dir = targetPos - Head.Position
			dir = dir*(1/dir.magnitude)

			local pos = Head.Position + (dir * 8)
			local ad=5000

			local missile = Rocket:clone()
			missile.Name="Rocket"

			local BV=Instance.new("BodyVelocity")
			BV.Parent=missile
			BV.P=12500
			BV.MaxForce=Vector3.new(ad,ad,ad)
			BV.Velocity=dir*60
			missile.CFrame = CFrame.new(pos,  pos + dir)

			local creator_tag = Instance.new("ObjectValue")
			creator_tag.Value = plr
			creator_tag.Name = "creator"
			creator_tag.Parent = missile

			local exp=Tool.Handle.exp:Clone()
			exp.PlaybackSpeed=math.random(90,110)/100
			exp.PlayOnRemove=true
			exp.Parent=missile

			local swoosh=Tool.Handle.swoosh:Clone()
			swoosh.PlaybackSpeed=math.random(95,105)/100
			swoosh.Parent=missile

			missile.Parent = workspace
			ColSer:AddTag(missile,missile.Name) 
			ColSer:AddTag(missile,plr.Name)
			missile:SetNetworkOwner(plr)
			swoosh:Play()

			local effect=plr:FindFirstChild("Effect")
			if effect and effect.Value~="None" then
				if effect.Value=="Fire" then
					Instance.new("Fire",missile)
				else
					spawn(function()
						require(game:GetService("ReplicatedStorage").TrailModule).AddTrail(missile,effect.Value,.5,.5,1)
					end)
				end
			end
			Debris:AddItem(missile,10)
			if Reload_Enabled then
				wait(7)
			end
			Tool.Enabled=true
		end

		Tool.Fire.OnServerEvent:Connect(FireWep)

		local function DestroyRocket(plr,Obj,ClientPos)
			local x=true
			local succ,err=pcall(function() 
				if Obj:GetNetworkOwner()~=plr then x=false end 
			end) 
			if err then warn(plr.Name.." may be exploiting") return end -- Not sure how this would happen.
			if x==false then warn(plr.Name.." is definitely exploiting") --[[plr:Kick("Possible exploit detected")] return end
			local ServerPos=Obj.Position
			local creator=Obj:FindFirstChild("creator")
			local CreatorValue
			if creator then
				CreatorValue=creator.Value
			end
			local Player=ModFx.GetPlayerFromTool(Tool)
			if CreatorValue~=nil and CreatorValue==plr and Player and Player==plr and (ServerPos - ClientPos).magnitude < 20 and ColSer:HasTag(Obj,Obj.Name) 
				and ColSer:HasTag(Obj,plr.Name) then -- all these to ensure that it's a rocket, and its their rocket, and its from their tool
				-- "(ServerPos - ClientPos).magnitude" = the distance between the serverside and clientside missile on hit
				Obj:ClearAllChildren()
				Debris:AddItem(Obj,0)
				ModFx.Explosion(CreatorValue,"Rocket",ClientPos)
			end
		end

		Tool.RocketDestroyEvent.OnServerEvent:connect(DestroyRocket)]]
	elseif v.Name == "Script" and v.Parent.Name == "Slingshot" then
		source = [[local Debris = game:GetService("Debris")
local ball = script.Parent
local damage = 8
local Players=game.Players
local plrFromChar=Players.GetPlayerFromCharacter

local function tagHumanoid(humanoid)
	local tag = ball:FindFirstChild("creator")
	if not tag then return end
	local hc=humanoid:FindFirstChild("creator")
	if hc then
		Debris:AddItem(hc,0)
	end
	local new_tag = tag:Clone()
	new_tag.Parent = humanoid
	Debris:AddItem(new_tag,1)
end

local function Kill(p1,p2)
	if not p1 or not p2 then return true end
	local ATK=p1:FindFirstChild("AntiTeamKill")
	local eATK=p2:FindFirstChild("AntiTeamKill")
	if not ATK or not eATK then return true end
	if ATK.Value==false or eATK.Value==false then return true end
	if p1.Neutral==true or p2.Neutral==true then return true end
	if p1.Team==p2.Team then return false end
end

local function onTouched(hit)
	
	local creator=ball:FindFirstChild("creator")
	if not creator then return end
	local p=creator.Value
	if not p then return end
	local c=creator.Value.Character
	if not c then return end
	local h=c:FindFirstChild("Humanoid")
	if not h then return end
	local humanoid=hit.Parent:FindFirstChild("Humanoid")
	
	if humanoid then

		if humanoid==h then return end
		if Kill(p,plrFromChar(Players,humanoid.Parent))==false then return end
		
		tagHumanoid(humanoid)
		humanoid:TakeDamage(damage)

		return
	end
	damage = damage / 2 -- this doesnt execute if a humanoid exists
	if damage > 1 then
		return
	end
	connection:disconnect()
	Debris:AddItem(ball,0)
end

connection = ball.Touched:connect(onTouched)

r = game:GetService("RunService")
t, s = r.Stepped:wait()
d = t + 2.0 - s
while t < d do
	t = r.Stepped:wait()
end

ball:ClearAllChildren()
Debris:AddItem(ball,0)]]
	elseif v.Name == "Server" and v.Parent.Name == "Slingshot" then
		source = [[local Pellet = Instance.new("Part")
Pellet.Name="Pellet"
Pellet.Locked = true
Pellet.BackSurface = 0
Pellet.BottomSurface = 0
Pellet.FrontSurface = 0
Pellet.LeftSurface = 0
Pellet.RightSurface = 0
Pellet.TopSurface = 0
Pellet.Shape = 0
Pellet.Size = Vector3.new(1,1,1)
Pellet.BrickColor = BrickColor.new(2)

local ModFx=require(game.ReplicatedStorage.Other)
local Tool=script.Parent
local Reload_Enabled=false

local VELOCITY = 85 -- constant

local function FireWep(plr,targetPos)
	if Tool.Enabled==false then return end
	if ModFx.GetPlayerFromTool(Tool)~=plr then return end
	local c=plr.Character
	if not c then return end
	local h=c:FindFirstChildWhichIsA("Humanoid")
	local plrTool=c:FindFirstChildWhichIsA("Tool")
	local torso=c:FindFirstChild("HumanoidRootPart")
	local head=c:FindFirstChild("Head")
	if not h or not plrTool or not torso or not head then return end
	if plrTool~=Tool then return end
	if h.Health<=0 then return end
	
	Tool.Enabled=false
	
	local dir=targetPos-head.Position
	--start confusing stuff
	dir=dir*(1/dir.magnitude)
	local launch=torso.Position+(5*dir)
	local delta = targetPos - launch
	local dy = delta.y
	local new_delta = Vector3.new(delta.x, 0, delta.z)
	delta = new_delta

	local dx = delta.magnitude
	local unit_delta = delta.unit
	
	local function computeLaunchAngle(dx,dy,grav)
		local g = math.abs(grav)
		local inRoot = (VELOCITY^4) - (g*(g*(dx^2) + (2*dy)*(VELOCITY^2)))
		if inRoot <= 0 then
			return math.pi/4
		end
		local root = math.sqrt(inRoot)
		local inATan1 = ((VELOCITY^2) + root) / (g*dx)
	
		local inATan2 = ((VELOCITY^2) - root) / (g*dx)
		local answer1 = math.atan(inATan1)
		local answer2 = math.atan(inATan2)
		if answer1 < answer2 then return answer1 end
		return answer2
	end
	
	local theta = computeLaunchAngle(dx, dy, workspace.Gravity)

	local vy = math.sin(theta)
	local xz = math.cos(theta)
	local vx = unit_delta.x * xz
	local vz = unit_delta.z * xz	
	
	local vel=Vector3.new(vx,vy,vz) * VELOCITY
	--end confusing stuff
	local missile = Pellet:clone()
	missile.Position=launch
	missile.Velocity=vel
	missile.Parent = workspace
	missile:SetNetworkOwner(plr)
	
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = plr
	creator_tag.Name = "creator"
	creator_tag.Parent = missile
	
	local damage_value=Instance.new("IntValue")
	damage_value.Value=8
	damage_value.Name="damage"
	damage_value.Parent=missile
	
	local l=Tool.Handle.Sound:Clone()
	l.Parent=Tool.Handle
	l:Play()
	l.Ended:connect(function()
		l:Destroy()
	end)
	
	local newscript=Tool.Script:Clone()
	newscript.Parent=missile
	newscript.Disabled=false
	
	if Reload_Enabled then
		wait(0.2)
	end
	Tool.Enabled=true
end

Tool.Fire.OnServerEvent:Connect(FireWep)]]
	elseif v.Name == "Script" and v.Parent.Name == "Superball" then
		source = [[local Debris = game:GetService("Debris")
local ball = script.Parent
local damage = 55
local r = game:GetService("RunService")
local last_sound_time=r.Stepped:wait()
local Players=game.Players
local plrFromChar=Players.GetPlayerFromCharacter

local function tagHumanoid(humanoid)
	local tag = ball:FindFirstChild("creator")
	if not tag then return end
	local hc=humanoid:FindFirstChild("creator")
	if hc then
		Debris:AddItem(hc,0)
	end
	local new_tag = tag:Clone()
	new_tag.Parent = humanoid
	Debris:AddItem(new_tag,1)
end

local function Kill(p1,p2)
	if not p1 or not p2 then return true end
	local ATK=p1:FindFirstChild("AntiTeamKill")
	local eATK=p2:FindFirstChild("AntiTeamKill")
	if not ATK or not eATK then return true end
	if ATK.Value==false or eATK.Value==false then return true end
	if p1.Neutral==true or p2.Neutral==true then return true end
	if p1.Team==p2.Team then return false end
end

local function onTouched(hit)
	local now = r.Stepped:wait()
	if now - last_sound_time <= .1 then return end--[[ this seems to be a debounce that doesnt allow the 	
											sound to play more than once during a 0.1s interval]
		last_sound_time = now
		if ball.Boing.Playing==false then
			ball.Boing.PlaybackSpeed=math.random(85,115)/100
			ball.Boing:play()
		end

		local creator=ball:FindFirstChild("creator")
		if not creator then return end
		local p=creator.Value
		if not p then return end
		local c=creator.Value.Character
		if not c then return end
		local h=c:FindFirstChild("Humanoid")
		if not h then return end
		local humanoid=hit.Parent:FindFirstChild("Humanoid")

		if humanoid then
			if humanoid==h then return end
			if Kill(p,plrFromChar(Players,humanoid.Parent))==false then return end
			tagHumanoid(humanoid)
			humanoid:TakeDamage(damage)
			return
		end
		damage = damage / 2 -- this doesnt execute if a humanoid exists
		if damage > 2 then
			return
		end
		connection:disconnect()
		Debris:AddItem(ball,0)
	end

	connection = ball.Touched:connect(onTouched)

	t, s = r.Stepped:wait()
	d = t + 2.0 - s
	while t < d do
		t = r.Stepped:wait()
	end

	ball:ClearAllChildren()
	Debris:AddItem(ball,0)]]
	elseif v.Name == "Server" and v.Parent.Name == "Superball" then
		source = [[local missile = Instance.new("Part")
missile.Size = Vector3.new(2,2,2)
missile.Shape = 0
missile.BottomSurface = 0
missile.TopSurface = 0 
missile.Name = "Cannon Shot"
missile.Elasticity = 1
missile.Reflectance = .2
missile.Friction = 0

local ModFx=require(game.ReplicatedStorage.Other)
local TrailFx=require(game.ReplicatedStorage.TrailModule)
local Tool=script.Parent
local Reload_Enabled=false
local Debris=game:GetService("Debris")

local function FireWep(plr,targetPos)
	if Tool.Enabled==false then return end
	local Player=ModFx.GetPlayerFromTool(Tool)
	if plr~=Player then return end
	local c=plr.Character
	if not c then return end
	local h=c:FindFirstChildWhichIsA("Humanoid")
	local Head=c:FindFirstChild("Head")
	local plrTool=c:FindFirstChildWhichIsA("Tool")
	if not h or not Head or not plrTool then return end
	if plrTool~=Tool then return end
	if h.Health<=0 then return end
	
	Tool.Enabled=false
	
	local lookAt=(targetPos - Head.Position).unit
	local spawnPos=Head.Position
	spawnPos=spawnPos+(lookAt*5)
	
	local missile2 = missile:Clone()
	missile2.BrickColor = BrickColor.Random()
	missile2.Position = spawnPos
	missile2.Velocity = (lookAt*200)
	missile2.Parent = workspace
	missile2:SetNetworkOwner(plr)
	Tool.Handle.Boing:Play()
	
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = plr
	creator_tag.Name = "creator"
	creator_tag.Parent = missile2
	
	local newscript=Tool.Script:Clone()
	newscript.Parent=missile2
	newscript.Disabled=false
	
	local l=Tool.Handle.Boing:Clone()
	l.Parent=missile2
	
	local effect=plr:FindFirstChild("Effect")
	if effect and effect.Value~="None" then
		if effect.Value=="Fire" then
			Instance.new("Fire",missile2)
		else
			spawn(function()
				TrailFx.AddTrail(missile2,effect.Value,1,.4,1)
			end)
		end
	end
	Debris:AddItem(missile2,5)
	if Reload_Enabled then
		wait(2)
	end
	Tool.Enabled=true
end

Tool.Fire.OnServerEvent:Connect(FireWep)
]]
	elseif v.Name == "Server" and v.Parent.Name == "Sword" then
		source = [[local Tool=script.Parent
local Reload_Enabled=false
local Damage=Tool:WaitForChild("damage")
local sword=Tool:WaitForChild("Handle")
local r = game:service("RunService")

local base_damage = 5
local slash_damage = 10
local lunge_damage = 30

local ModFx=require(game.ReplicatedStorage.Other)
local Player=ModFx.GetPlayerFromTool(Tool)

local trails={
	["Rainbow"]=function()
		return game.ServerStorage.Trails.RainbowKeypoints.Color
	end,
	["RisingSun"]=function()
		return game.ServerStorage.Trails.RisingSunKeypoints.Color
	end,
	["Arctic"]=function()
		return game.ServerStorage.Trails.ArcticKeypoints.Color
	end,
	["TeamColor"]=function()
		return ColorSequence.new(Player.TeamColor.Color)
	end,
	["Fire"]=function()
		sword.Trail.Enabled=false -- just in case
		for i,v in pairs(sword:GetChildren()) do
			if v:IsA("Attachment") then
				Instance.new("Fire",v)
			end
		end
	end
}

local function swordUp()
	Tool.GripForward = Vector3.new(-1,0,0)
	Tool.GripRight = Vector3.new(0,1,0)
	Tool.GripUp = Vector3.new(0,0,1)
end

local function swordOut()
	Tool.GripForward = Vector3.new(0,0,1)
	Tool.GripRight = Vector3.new(0,-1,0)
	Tool.GripUp = Vector3.new(-1,0,0)
end

local function IsEffect(str)
	local a=false
	for i,v in pairs(trails) do
		if str==i then
			a=true
		end
	end
	return a
end

local function applyTrail(typ)
	if IsEffect(typ)==false then
		return
	end
	if typ=="Fire" then
		trails[typ]()
	else
		sword.Trail.Enabled=true
		sword.Trail.Color=trails[typ]()
	end
end

local function removeTrail()
	sword.Trail.Enabled=false
	for i,v in pairs(sword:GetChildren()) do
		if v:IsA("Attachment") then
			v:ClearAllChildren()
		end
	end
end

local function dmg(humanoid,me,ePlayer)
	humanoid:TakeDamage(Tool.damage.Value) -- cover all humanoids, npc or other
	if ePlayer then
		if 	(not humanoid:FindFirstChild("creator")) and 
			me:FindFirstChild("leaderstats") then
			local creator = Instance.new("ObjectValue")
			creator.Value = me
			creator.Name = "creator"
			creator.Parent = humanoid
		end
		--humanoid:TakeDamage(Tool.damage.Value)
	end
end

sword.Touched:connect(function(hit)
	if hit.Parent then 
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		local vCharacter = Player.Character
		local hum = vCharacter:FindFirstChild("Humanoid")
		
		if humanoid and hum and humanoid~=hum and hum.Health>0 then
			local ePlayer = game.Players:GetPlayerFromCharacter(humanoid.Parent)
			if ePlayer then
				local ATK=Player:FindFirstChild("AntiTeamKill")
				if 	(ATK and ATK.Value==true) and
					(Player.Neutral==false and ePlayer.Neutral==false) and
					Player.TeamColor==ePlayer.TeamColor then
					return -- force-end the function
				end
				dmg(humanoid,Player,ePlayer)
			else
				dmg(humanoid,Player)
			end
		end

	end 
end)

local function attack(plr)
	Damage.Value=slash_damage
	sword.SwordSlash:Play()
	local anim = Instance.new("StringValue")
	anim.Name = "toolanim"
	anim.Value = "Slash"
	anim.Parent = Tool
	Damage.Value=base_damage
end

local function lunge(plr)

	local effect=Player:FindFirstChild("Effect")
	if effect then
		applyTrail(effect.Value)
	end
	sword.SwordLunge:Play()
	Damage.Value=lunge_damage
	local anim = Instance.new("StringValue")
	anim.Name = "toolanim"
	anim.Value = "Lunge"
	anim.Parent = Tool
	
	local vCharacter = Player.Character
	
	local force = Instance.new("BodyVelocity")
	force.velocity = Vector3.new(0,14.5,0) 
	force.maxForce = Vector3.new(0,5000,0)
	
	if Tool.Parent.Name~="Backpack" then
		force.Parent = vCharacter.HumanoidRootPart
	end	
	
	wait(.25)
	swordOut()
--	wait(.25)
--	force:Destroy() -- now in onDied
--	wait(.5)
	wait(.75)
	swordUp()
	removeTrail()
	Damage.Value=base_damage
end

Tool.Enabled = true
local last_attack = 0

Tool.Activated:connect(function()
	if Tool.Enabled==false then return end
	if Reload_Enabled then
		Tool.Enabled = false
	end
	local humanoid = Player.Character.Humanoid
	if not humanoid then
		return
	end
	local t = r.Stepped:wait()
	if humanoid.Health~=0 then
		if (t - last_attack < .2) then
			lunge()
		else
			attack()
		end
	end
	last_attack = t
	--wait(.5)
	Tool.Enabled = true
end)

Tool.Equipped:connect(function(mouse)
	sword.Unsheath:Play()
end)
]]
	elseif v.Name == "Server" and v.Parent:FindFirstChild("ResetTime") then
		source = [[local bomb = Instance.new("Part")
bomb.Size = Vector3.new(2,2,2)
bomb.BrickColor = BrickColor.new("Really black")
bomb.Shape = 0
bomb.BottomSurface = 0
bomb.TopSurface = 0
bomb.Name = "Bomb"
bomb.Locked = true

local ModFx=require(game.ReplicatedStorage.Other)
local Tool=script.Parent
local Reload_Enabled=false
--To change the blast radius, go to ReplicatedStorage.Other

local function FireWep(plr,cf) -- cant use .activated cause we need the camera orientation in localscript
	if Tool.Enabled==false then return end
	local Player=ModFx.GetPlayerFromTool(Tool)
	if plr~=Player then return end
	local c=plr.Character
	if not c then return end
	local h=c:FindFirstChildWhichIsA("Humanoid")
	local plrTool=c:FindFirstChildWhichIsA("Tool")
	if not h or not plrTool then return end
	if plrTool~=Tool then return end
	if h.Health<=0 then return end
	if plr:DistanceFromCharacter(cf.p)>30 then return end -- jan 11 2019 - changed from 20 to 30 studs
		
	Tool.Enabled=false
		
	local bomb2=bomb:Clone()
	
	local exp=Tool.Handle.exp:Clone()
	exp.PlaybackSpeed=math.random(90,110)/100
	exp.PlayOnRemove=true
	exp.Parent=bomb2
	
	local click=Tool.Handle.Click:Clone()
	click.PlaybackSpeed=math.random(95,105)/100
	click.Parent=bomb2
	
--	local creator_tag = Instance.new("ObjectValue") -- Don't need this anymore, as the module only needs the player value
--	creator_tag.Value = plr
--	creator_tag.Name = "creator"
--	creator_tag.Parent = bomb2
	
	bomb2.CFrame=cf
	bomb2.Parent=workspace.BombHolder
	
	game.ServerScriptService.b:Fire(plr,"Bomb",bomb2.Position,bomb2)
	
	if Reload_Enabled then
		wait(6)
	end
	
	Tool.Enabled=true
end

Tool.Fire.OnServerEvent:Connect(FireWep)]]
	elseif v.Parent.Name == "Trowel" then
		source = [[local wallHeight = 4
local brickSpeed = 0.04
local wallWidth = 12
local int=1

local ModFx=require(game.ReplicatedStorage.Other)
local Tool=script.Parent
local Reload_Enabled=false

local Player=ModFx.GetPlayerFromTool(Tool)

local effectTable={
	["RisingSun"]={
		BrickColor.new(21),
		BrickColor.new(106),
		BrickColor.new(333),
		BrickColor.new(24)
	},
	["Arctic"]={
		BrickColor.new(104),
		BrickColor.new(110--[[219]),
		BrickColor.new(213),
BrickColor.new(1013)
},
["TeamColor"]={
	Player.TeamColor,
}
}

local brick = Instance.new("Part")
brick.BottomSurface="Weld"
brick.Name="Trowel Wall"

local function snap(v)
	local absX=math.abs(v.x)
	local absZ=math.abs(v.z)
	if absX>absZ then
		return Vector3.new(v.x/absX,0,0)
	else
		return Vector3.new(0,0,v.z/absZ)
	end
end

local function placeBrick(cf, pos, color,f)
	local newbrick=brick:Clone()
	newbrick.BrickColor = color
	newbrick.CFrame = cf * CFrame.new(pos + newbrick.Size / 2)
	newbrick.Parent = f
	newbrick:MakeJoints()
	return newbrick, pos +  newbrick.Size
end


local function FireWep(plr,targetPos)	
	if Tool.Enabled==false then return end
	Player=ModFx.GetPlayerFromTool(Tool) -- refresh it
	if plr~=Player then return end
	local c=plr.Character
	if not c then return end
	local h=c:FindFirstChildWhichIsA("Humanoid") 
	if not h then return end
	if h.Health<=0 then return end
	local plrTool=c:FindFirstChildWhichIsA("Tool")
	if not plrTool then return end
	if plrTool~=Tool then return end
	if Reload_Enabled then
		Tool.Enabled=false
	end

	Tool.Handle.BuildSound:Play()
	local lookAt = snap((targetPos - plr.Character.Head.Position).unit)
	local cf = CFrame.new(targetPos, targetPos + lookAt)
	local color = BrickColor.Random()
	local bricks = {}

	local effect=plr:FindFirstChild("Effect")
	local fx=nil
	if effect and effect.Value and effectTable[effect.Value] then
		fx=effect.Value -- dont want people switching trails mid-build
	end

	assert(wallWidth>0)
	local y = 0
	local folder=Instance.new("Folder")
	folder.Name="WallHolder"
	folder.Parent=workspace
	game.Debris:AddItem(folder, 15) -- Roblox starts a coroutine outside the script, so no need to make your own cleanup scripts
	--game:GetService("CollectionService"):AddTag(folder,plr.Name)
	while y < wallHeight do
		if fx then
			for i,v in pairs(effectTable[fx]) do
				if int==i then
					color=v
				end
			end
			int=int+1
		end
		local p
		local x = -wallWidth/2
		while x < wallWidth/2 do
			local brick
			brick, p = placeBrick(cf, Vector3.new(x, y, 0), color, folder)
			x = p.x
			table.insert(bricks, brick)
			wait(brickSpeed)
		end
		y = p.y
	end
	int=1

	wait(5)
	Tool.Enabled=true
end

Tool.Fire.OnServerEvent:Connect(FireWep)]]
	elseif v.Name == "Amura Made This" then
		source = [[Amura initially made this island for Stickmasterluke's disaster game.
Props to him. ;D
]]
	elseif v.Name == "Weather Machine Power" then
		source = [[--Made by Stickmasterluke


local sp = script.Parent


--todo: steam particles form stacks
--todo: spinning turbine
--todo: adjustable speed of globespin
--todo: engine colors
--todo: tube colors

local powerLevelTag = sp:WaitForChild('PowerLevel')
local globeTag = sp:WaitForChild('Globe'):WaitForChild('SpinGlobeEnabled')
local screenFrame = sp:WaitForChild('Screen'):WaitForChild('SurfaceGui'):WaitForChild('TextLabelFull')
local tube1 = sp:WaitForChild('Tube1')
local tube2 = sp:WaitForChild('Tube2')
local engineColor = sp:WaitForChild('EngineColor')
local emitter1 = sp:WaitForChild('Stacks'):WaitForChild('Union1'):WaitForChild('ParticleEmitter')
local emitter2 = sp:WaitForChild('Stacks'):WaitForChild('Union2'):WaitForChild('ParticleEmitter')

local mainPart = sp:WaitForChild('MainPart')
local letterSorting = mainPart:WaitForChild('LetterSorting')
local powerDown = mainPart:WaitForChild('PowerDown')
local powerUpSound = mainPart:WaitForChild('PowerUpSound')


local engineColors = {
	[0] = 'Black',
	[1] = 'Pastel Blue',
	[2] = 'Pastel violet',
	[3] = 'Alder',
	[4] = 'Carnation pink',
	[5] = 'Persimmon',
	[6] = 'Bright red',
	[7] = 'Really red',
	[8] = 'Toothpaste',
	[9] = 'Lime green',
}

local lastValue = powerLevelTag.Value
function updateState()
	local val = powerLevelTag.Value
	if val > lastValue then
		powerUpSound:Play()
	end
	lastValue = val

	screenFrame.Text = tostring(val)

	tube1.BrickColor = BrickColor.new(val >= 1 and 'Cyan' or 'Light blue')
	tube2.BrickColor = BrickColor.new(val >= 3 and 'Cyan' or 'Light blue')
	engineColor.BrickColor = BrickColor.new(engineColors[val] or 'Institutional white')
	emitter2.Enabled = val >= 2
	emitter1.Enabled = val >= 4

	if val <= 0 then
		globeTag.Value = false
		powerDown:Play()
		letterSorting:Stop()
	else
		letterSorting.Pitch = val*.5
		letterSorting:Play()
		globeTag.Value = true
	end
end

updateState()

powerLevelTag.Changed:connect(updateState)


]]
	elseif v.Name == "OrbSpinyScript" then
		source = [[--Made by Stickmasterluke


local sp = script.Parent

local frame = sp:WaitForChild('Frame')
local spinGlobeValue = sp:WaitForChild('SpinGlobeEnabled')
random = math.random

local ringAVs = {}

for _,ring in pairs(sp:GetChildren()) do
	if ring.Name == 'SpinningRingUnion' then
		local bp = Instance.new('BodyPosition',ring)
		bp.maxForce = Vector3.new(1,1,1)*40000
		bp.Position = frame.Position
		local bav = Instance.new('BodyAngularVelocity',ring)
		ring.Anchored = false
		table.insert(ringAVs,bav)
	end
end

while true do
	wait(2)
	if spinGlobeValue.Value then
		for _,ringAV in pairs(ringAVs) do
			ringAV.AngularVelocity = Vector3.new(random(-2,2),random(-2,2),random(-2,2)) * 3
		end
	else
		for _,ringAV in pairs(ringAVs) do
			ringAV.AngularVelocity = Vector3.new(0,0,0)
		end
	end
end


]]
	elseif v.Parent.Name == "WaterLevel" then
		source = [[--Made by Stickmasterluke

sp=script.Parent
midhight=16
radius=4.5		--hight
wavetime=10		--seconds
shakeradius=6
phi=.618033988
a=0
while true do
	wait()
	a=a+1
	sp.CFrame=CFrame.new(math.sin((a/(wavetime*30/phi))*math.pi)*shakeradius,midhight+math.sin((a/(wavetime*30))*math.pi)*radius,math.sin((a/(wavetime*30*phi))*math.pi)*shakeradius)
end
]]
	elseif v.Name == "CompassScript" then
		source = [[
--


--todo:this could and should all be in a local script, with a bindable event

local sp = script.Parent
local event = game:GetService("ReplicatedStorage"):WaitForChild('Event')
local player = nil

local equipped = false
local equipCount = 0

sp.Equipped:connect(function()
	equipCount = equipCount + 1
	local thisEquip = equipCount
	equipped = true
	while equipped and thisEquip == equipCount do
		local character = sp.Parent
		player = game.Players:GetPlayerFromCharacter(character)
		if player then
			event:FireClient(player, 'OpenCompass')
		end
		wait(1)
	end
end)
sp.Unequipped:connect(function()
	equipped = false
	if player then
		event:FireClient(player, 'CloseCompass')
	end
end)


]]
	elseif v.Name == "BalloonScript" then
		source = [[--


local Tool = script.Parent
local handle=Tool:WaitForChild("Handle",5)
local upAndAway = false
local humanoid = nil
local head = nil
local upAndAwayForce=handle.BodyForce
isfloating=false

local equalizingForce = 236 / 1.2 -- amount of force required to levitate a mass
local gravity = 1.05 -- things float at > 1

local height = nil
local maxRise =  75

function float(lift)
	if not isfloating then
		isfloating=true
		while equipped do
			lift=recursiveGetLift(Tool.Parent)
			upAndAwayForce.force=Vector3.new(0,lift*.8,0)
			--if Tool.Handle.Position.y > height + maxRise then
			if Tool.Handle.Position.y>300 then
				equipped=false
				Tool.Handle.Pop:Play()
				Tool.GripPos=Vector3.new(0,-.4,0)
				Tool.Handle.Mesh.MeshId = "http://www.roblox.com/asset/?id=26725510"
			end
			for i=1,4 do
				updateBalloonSize()
				wait(1/20)
			end
		end
		upAndAwayForce.force=Vector3.new(0,0,0)
		isfloating=false
	end
end

function onEquipped()
	Tool.Handle.Mesh.MeshId="http://www.roblox.com/asset/?id=25498565"
	equipped = true
	--[[Tool.GripPos = Vector3.new(0,-1,0)
	Tool.GripForward = Vector3.new(0,1,0)
	Tool.GripRight = Vector3.new(0,0,-1)
	Tool.GripUp = Vector3.new(1,0,0)]
		Tool.Grip = CFrame.new(0,-1,0,0,1,0,0,0,-1,-1,0,0)
		local hrp = Tool.Parent:FindFirstChild('HumanoidRootPart')
		if hrp then
			height = hrp.Position.y
		else
			height = 0
		end
		lift=recursiveGetLift(Tool.Parent)
		float(lift)
	end

	function onUnequipped()
		equipped = false
	--[[Tool.GripForward = Vector3.new(1,0,0)
	Tool.GripRight = Vector3.new(0,0,1)
	Tool.GripUp = Vector3.new(0,1,0)]
		handle.Mesh.Scale = Vector3.new(1,1,1)
	end

	Tool.Unequipped:connect(onUnequipped)
	Tool.Equipped:connect(onEquipped)

	function recursiveGetLift(node)
		local m = 0
		local c = node:GetChildren()
		if (node:FindFirstChild("Head") ~= nil) then head = node:FindFirstChild("Head") end -- nasty hack to detect when your parts get blown off

		for i=1,#c do
			if c[i]:IsA("BasePart") then	
				if (head ~= nil and (c[i].Position - head.Position).magnitude < 10) then -- GROSS
					if c[i].Name == "Handle" then
						m = m + (c[i]:GetMass() * equalizingForce * 1) -- hack that makes hats weightless, so different hats don't change your jump height
					else
						m = m + (c[i]:GetMass() * equalizingForce * gravity)
					end
				end
			end
			m = m + recursiveGetLift(c[i])
		end
		return m
	end

	function updateBalloonSize()
		local range=(height+maxRise)-Tool.Handle.Position.y
	--[[if range<maxRise/3 then
		Tool.Handle.Mesh.Scale=Vector3.new(1,1,1)*2
	elseif range<maxRise*(2/3) then
		Tool.Handle.Mesh.Scale=Vector3.new(1,1,1)*1.5
	else
		Tool.Handle.Mesh.Scale=Vector3.new(1,1,1)
	end]
		Tool.Handle.Mesh.Scale=Vector3.new(1,1,1)*(2-math.min(1,math.max(0,range/maxRise)))
	end

--[[
while true do
	wait(1)
	script.Parent.Handle.BillboardGui.TextLabel1.Text = 'Server: '..tostring(script.Parent.Handle.BodyForce.force.Y)
	randomshade = .8+math.random()*.2
	script.Parent.Handle.BillboardGui.TextLabel1.BackgroundColor3 = Color3.new(randomshade,randomshade,randomshade)
end
]


	]]
	elseif v.Name == "AppleScript" then
		source = [[--Made by Stickmasterluke


local sp=script.Parent


local healamount=15
local extrawait=6

local handle=sp:WaitForChild('Handle',5)
local eatsound=handle:WaitForChild('EatSound',5)
local sparkles=handle:WaitForChild('Sparkles',5)
local event=sp:WaitForChild('Event')

local equipped=false
local check=true
local chr=nil
local h=nil
local plr=nil
local equipinstant=nil


sp.Activated:connect(function()
	if check and equipped and h and h.Health>0 then
		check=false
		event:FireClient(plr,'EatAnim')
		wait(1)
		if h.Health>0 and equipped then
			--print('Healing',h.Parent,h.Health,'to',h.Health+healamount)
			if h.Health < 100 then	--Will overheal without this check
				h:TakeDamage(-healamount)
			end
			--h.Health=h.Health+healamount
			if eatsound then
				eatsound:Play()
			end
		end
		wait(.62+extrawait)
		check=true
	end
end)

sp.Equipped:connect(function(mouse)
	equipped=true
	chr=sp.Parent
	plr=game.Players:GetPlayerFromCharacter(chr)
	h=chr:FindFirstChild('Humanoid')

	local myequipinstant={}
	equipinstant=myequipinstant
	wait(2)
	if equipped and myequipinstant==equipinstant then
		sparkles.Enabled=true
		wait(.3)
		sparkles.Enabled=false
	end
end)

sp.Unequipped:connect(function()
	equipped=false
end)


]]
	elseif v.Name == "Bounce" and v.Parent.Parent:FindFirstChild("SMallRailing") then
		source = [[function onTouched(part)
	if part.Parent ~= nil then
		local h = part.Parent:findFirstChild("Humanoid")
		local hrp = part.Parent:FindFirstChild('HumanoidRootPart')
		if h~=nil and hrp and h.Health > 0 then
			hrp.Velocity=Vector3.new(0,58,0)
			wait(0.5)
		end			
	end
end

script.Parent.Touched:connect(onTouched)
]]
	elseif v.Name == "Script" and v.Parent.Parent:FindFirstChild("MissileSystem1") then
		source = [[function onChildAdded(child)
	if child.Name == "SeatWeld" then
		child.C0 = CFrame.new(0,(script.Parent.Size.y/2 + 1.5),0)
		child.C1 = CFrame.new(0,0,0)
	end
end

script.Parent.ChildAdded:connect(onChildAdded)]]
	elseif v.Name == "Script" and v.Parent.Parent:FindFirstChild("TopSeat") then
		source = [[--Made by Stickmasterluke
]]
	elseif v.Name == "MusicScript" and v.Parent.Name == "Music" and v.Parent:IsA("Sound") then
		source = [[--


local sp = script.Parent

wait(5)

sp:Play()
]]
	elseif v.Name == "FountianScript" then
		source = [[--Made by Stickmasterluke
	--OLD CODE


local sp = script.Parent

local debris = game:GetService("Debris")

local baseupvelocity = 40
local variety = 15
local colors = {"Bright blue", "Medium blue", "Pastel Blue"}

local originalPosition = Vector3.new(0,0,0)


wait(1)
if sp and sp.Parent then
	originalPosition = sp.Position
end

while sp and sp.Parent and ((sp.Position-originalPosition).magnitude<2) do
	local p = Instance.new("Part")
	p.Name = "FountainWater"
	p.formFactor = "Symmetric"
	p.Shape = "Ball"
	p.Material = 'Foil'
	p.Transparency = .5
	if math.random()<.5 then
		p.CanCollide = false
	end
	p.Size = Vector3.new(1,1,1)
	p.BrickColor = BrickColor.new(colors[math.random(1,#colors)])
	p.TopSurface = "Smooth"
	p.BottomSurface = "Smooth"
	p.CFrame = CFrame.new(sp.Position+Vector3.new(0,1.5,0))
	p.Velocity = Vector3.new((math.random()-.5)*variety,baseupvelocity+((math.random()-.5)*variety),(math.random()-.5)*variety)
	p.RotVelocity = Vector3.new((math.random()-.5)*variety,(math.random()-.5)*variety,(math.random()-.5)*variety)
	p.Elasticity = 0
	p.Friction = 1
	debris:AddItem(p, 2.5)
	p.Parent = sp
	wait(.2+(math.random()*.1))
end



]]
	elseif v.Name == "HammerGame" and v.Parent.Name == "HammerGame" then
		source = [[--Made by Stickmasterluke


local sp = script.Parent

local button = sp:WaitForChild('Button')

local debounce = false

button.Touched:connect(function(hit)
	if hit and hit.Parent and not debounce and button and button.Velocity.magnitude == 0 then
		local strength = math.abs(hit.Velocity.y)
		local hitSound = button:FindFirstChild('HitSound')
		if strength > 10 and hitSound then
			hitSound:Play()
		end
		wait(.1)
		if strength > 65 then
			debounce = true
			local bell = sp:FindFirstChild('Bell')
			if bell then
				local bellSound = bell:FindFirstChild('BellSound')
				if bellSound then
					bellSound:Play()
				end
				local bellMesh = bell:FindFirstChild('Mesh')
				if bellMesh then
					bellMesh.Scale = Vector3.new(1.25,1.25,1.25)
				end
				wait(1)
				if bellMesh then
					bellMesh.Scale = Vector3.new(1,1.25,1)
				end
			end
			wait(1)
			debounce = false
		end
	end
end)


]]
	elseif v.Name == "SwingScript" and v.Parent.Name == "MotorPiece" then
		source = [[--Made by Stickmasterluke

local sp = script.Parent


while sp and sp.Parent and sp:IsDescendantOf(game.Workspace) do
	sp.FrontParamB = .05
	for i=1,2 do
		sp.FrontParamB = sp.FrontParamB * -1
		wait(2)
	end
	sp.FrontParamB = .1
	for i=1,4 do
		sp.FrontParamB = sp.FrontParamB * -1
		wait(2)
	end
	sp.FrontParamB = .2
	for i=1,2 do
		sp.FrontParamB = sp.FrontParamB * -1
		wait(2)
	end
	sp.FrontParamB = .05
	for i=1,2 do
		sp.FrontParamB = sp.FrontParamB * -1
		wait(2)
	end
	sp.FrontParamB = 0
	wait(10)
end

]]
	elseif v.Name == "WhackAMoleScript" then
		source = [[--Made by Stickmasterluke


local sp = script.Parent

local clickDistance = 16
local difficultyCycle = 60 --seconds

wait(1)

local points = 0
local moles = {}
local startTime = tick()

for _,part in pairs(sp:GetChildren()) do
	if part.Name == 'Mole' then
		local clickDetector = part:FindFirstChild('ClickDetector')
		local hitSound = part:FindFirstChild('HitSound')
		if clickDetector and hitSound then
			table.insert(moles, part)
			clickDetector.MouseClick:connect(function()
				if part.Transparency == 0 and part.CanCollide then
					part.Transparency = 1
					part.CanCollide = false
					if hitSound then
						hitSound.Pitch = .8+math.random()*.4
						hitSound:Play()
					end
					if clickDetector then
						clickDetector.MaxActivationDistance = 0
					end
					points = points + 1
				end
			end)
		end
	end
end

while sp and sp.Parent and sp:IsDescendantOf(game.Workspace) do
	local difficulty = (math.sin(((startTime-tick())*math.pi)/difficultyCycle)+1)/2

	local adjustedDifficulty = .25+difficulty*.75
	if #moles > 0 then
		local mole = moles[math.random(#moles)]
		if mole then
			local clickDetector = mole:FindFirstChild('ClickDetector')
			if mole.CanCollide or mole.Transparency < 1 or not clickDetector then
				mole.CanCollide = false
				mole.Transparency = 1
				if clickDetector then
					clickDetector.MaxActivationDistance = 0
				end
			else
				mole.CanCollide = true
				mole.Transparency = 0
				clickDetector.MaxActivationDistance = clickDistance
				delay((2+math.random()*5)*adjustedDifficulty,function()
					if mole then
						mole.CanCollide = false
						mole.Transparency = 1
						if clickDetector then
							clickDetector.MaxActivationDistance = 0
						end
					end
				end)
			end
		end
	end
	wait((.5+math.random()*3)*adjustedDifficulty)
end


]]
	elseif v.Name == "Weld" and v.Parent.Name == "GasLamp" then
		source = [[--

t = script.Parent

function stick(x, y)
	weld = Instance.new("Weld") 
	weld.Part0 = x
	weld.Part1 = y
	local HitPos = x.Position
	local CJ = CFrame.new(HitPos) 
	local C0 = x.CFrame:inverse() *CJ 
	local C1 = y.CFrame:inverse() * CJ 
	weld.C0 = C0 
	weld.C1 = C1 
	weld.Parent = x
end

function Weldnow()
	c = t:children()
	for n = 1, #c do
		if (c[n].className == "Part") then
			if (c[n].Name ~= "MainPart") then
				stick(c[n], t.MainPart)
			end
		end
		if (c[n].className == "WedgePart") then
			if (c[n].Name ~= "MainPart") then
				stick(c[n], t.MainPart)
				wait()
			end
		end
		if (c[n].className == "VehicleSeat") then
			if (c[n].Name ~= "MainPart") then
				stick(c[n], t.MainPart)
			end
		end
		if (c[n].className == "Seat") then
			if (c[n].Name ~= "MainPart") then
				stick(c[n], t.MainPart)
			end
		end
	end
end

wait()
Weldnow()
]]
	elseif v.Name == "Script" and v.Parent.Name == "toaster1" then
		source = [[humanoid = nil

function onTouched(part)
	if part.Parent ~= nil then
	local h = part.Parent:findFirstChild("Humanoid")
		if h~=nil then
			if isenabled~=0 then
				if h==humanoid then
					return
				end

				local toast=script.Parent.toast:clone()
				isenabled=0
				toast.Parent=game.Workspace
				toast.Transparency=0
				toast.Locked=false
				toast.Anchored=false
				toast.CanCollide=false
				toast.RotVelocity=Vector3.new(math.random(1,10)/5,math.random(1,10)/5,math.random(1,10)/5)
----TODO>: toast.position
				local toastrot=CFrame.new(0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 1, 0)
				toast.CFrame = script.Parent.toaster.CFrame * CFrame.new(Vector3.new(.75,1,0)) * toastrot
				wait(0.4)
				toast.CanCollide=true

				wait(1)
				isenabled=1

				--IF YOU WANT TOAST TO DISAPPEAR AFTER A WHILE, REMOVE THE -- before next two lines.
				
				--wait(120)
				--toast:destroy()
				

			end
		end
	end
end


script.Parent.toaster.Touched:connect(onTouched)]]
	elseif v.Name == "animate" and v.Parent.Name == "LightsHolder" then
		source = [[-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

local v0 = require(game.ReplicatedStorage.Library.Functions);
local _ = require(game.ReplicatedStorage.Library.Util.ZonesUtil);
local v2 = require(game.ReplicatedStorage.Library.Client.FFlags);
if require(game.ReplicatedStorage.Library.Modules.Platform).GetQualityLevel() < 7 then
    return;
else
    local l_Parent_0 = script.Parent;
    local function v13(v4) --[[ Line: 13 ] --[[ Name: init ]
		local l_v4_Pivot_0 = v4:GetPivot();
		local v6 = math.random();
		local function _(v7) --[[ Line: 17 ] --[[ Name: apply ]
			local v8 = math.sin(v7) * 3;
			v4:PivotTo(l_v4_Pivot_0 * CFrame.Angles(math.rad(v8), 0, (math.rad(v8))));
		end;
		local v10 = math.sin(v6) * 3;
		v4:PivotTo(l_v4_Pivot_0 * CFrame.Angles(math.rad(v10), 0, (math.rad(v10))));
		v0.DistanceRenderStepped(v4, function(v11) --[[ Line: 23 ]
			if v2.Get(v2.Keys.DisableWorldFrontend) then
				return;
			else
				v6 = v6 + v11;
				local v12 = math.sin(v6) * 3;
				v4:PivotTo(l_v4_Pivot_0 * CFrame.Angles(math.rad(v12), 0, (math.rad(v12))));
				return;
			end;
		end);
	end;
	for _, v15 in pairs(l_Parent_0:GetChildren()) do
		if not v15:IsA("Script") then
			v13(v15);
		end;
	end;
	return;
end;]]
	elseif v.Name == "animate" and v.Parent.Name == "Arms" then
		source = [[-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

local l_RunService_0 = game:GetService("RunService");
local l_Parent_0 = script.Parent;
local l_l_Parent_0_Pivot_0 = l_Parent_0:GetPivot();
if require(game.ReplicatedStorage.Library.Modules.Platform).GetQualityLevel() <= 3 then
    return;
else
    local v3 = 0;
    l_RunService_0.RenderStepped:Connect(function(v4) --[[ Line: 13 ]
		v3 = v3 + v4;
		l_Parent_0:PivotTo(l_l_Parent_0_Pivot_0 * CFrame.Angles(0, 0, v3));
	end);
	return;
	end;]]
	end
	return source
end
