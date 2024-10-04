local name = "name here"

local player = game.Players[name]
local _settings = game.Players.LocalPlayer.PlayerGui.Gui.Frame.ImageButton.Frame
local part = game.ReplicatedStorage["Part File"]
function action(settingname,name,isevent2)
	if isevent2 then
		_settings[settingname].ScrollingFrame[name].LocalScript.Event2:FireServer()
	else
		_settings[settingname].ScrollingFrame[name].LocalScript.Event:FireServer()
	end
end

player.Chatted:Connect(function(message)
	local args = message:split(" ")
	if message == "/bring" then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(3,1,2)
	elseif args[1] == "/spawn" then
		if args[2] .. args[3] == "normaldummy" then
			action("Spawn Dummy Frame","Spawn Norma")
		elseif args[2] .. args[3] == "attackingdummy" then
			action("Spawn Dummy Frame","Spawn Attack")
		elseif args[2] .. args[3] == "infinitydummy" then
			action("Spawn Dummy Frame","Spawn Infinity Dummy")
		elseif args[2] .. args[3] == "onehp" then
			action("Spawn Dummy Frame","Spawn 1 HP")
		elseif args[2] .. args[3] == "counterhunter" then
			action("Spawn Dummy Frame","Spawn Counter Hunter")
		elseif args[2] .. args[3] == "walkingdummy" then
			action("Spawn Dummy Frame","Spawn Walk Dummy")
		end
	elseif args[1] == "/cooldown" then
		if args[2] == "off" then
			action("Skill Setings","Cooldown")
		elseif args[2] == "on" then
			action("Skill Setings","Cooldown",true)
		end
	elseif args[1] == "/stun" then
		if args[2] == "off" then
			action("Skill Setings","Srun Off")
		elseif args[2] == "on" then
			action("Skill Setings","Srun Off",true)
		end
	elseif args[1] == "/brickwall" then
		action("Setting Map","Spawn Blick")
		task.wait()
		part.SaveEvent:FireServer()
	elseif args[1] == "/deadlywall" then
		action("Setting Map","Spawn Death Blick")
		task.wait()
		part.SaveEvent:FireServer()
	elseif args[1] == "/clearwalls" then
		action("Setting Map","Clear Blick")
	elseif args[1] == "/removeult" then
		local plr = game.Players:FindFirstChild(args[2])
		if plr.ChecingYourCharacter.Value == 1 then
			plr.Character["Death = Remove Ult"]["SAITAMA REMOVE ULT EVENT"]:FireServer()
		elseif plr.ChecingYourCharacter.Value == 2 then
			plr.Character["Death = Remove Ult"]["GAROU REMOVE ULT EVENT"]:FireServer()
		elseif plr.ChecingYourCharacter.Value == 3 then
			plr.Character["Death = Remove Ult"]["KJ REMOVE ULT EVENT"]:FireServer()
		else
			print("failed, player may be an admin or a p2w :(")
		end
	end
end)
