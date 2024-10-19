local UIS = game:GetService("UserInputService")
local mainremote = game.ReplicatedStorage.AllRemoteEvents.CLientToServerR
local ScreenGui = Instance.new("ScreenGui")
local AdminFrame = Instance.new("Frame")
local Commands = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local By = Instance.new("TextLabel")
local CommandBar = Instance.new("TextBox")

ScreenGui.Name = "୨ৎ"
ScreenGui.Parent = gethui() or game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

AdminFrame.Name = "AdminFrame"
AdminFrame.Parent = ScreenGui
AdminFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
AdminFrame.BackgroundTransparency = 0.500
AdminFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
AdminFrame.BorderSizePixel = 0
AdminFrame.Position = UDim2.new(0.36601308, 0, 0.26758793, 0)
AdminFrame.Size = UDim2.new(0, 200, 0, 240)

Commands.Name = "Commands"
Commands.Parent = AdminFrame
Commands.Active = true
Commands.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Commands.BackgroundTransparency = 1.000
Commands.BorderColor3 = Color3.fromRGB(0, 0, 0)
Commands.BorderSizePixel = 0
Commands.Position = UDim2.new(0, 0, 0.0833333358, 0)
Commands.Size = UDim2.new(0, 200, 0, 200)
Commands.CanvasSize = UDim2.new(0,0,89,0)

UIListLayout.Parent = Commands
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

By.Name = "By"
By.Parent = AdminFrame
By.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
By.BackgroundTransparency = 0.500
By.BorderColor3 = Color3.fromRGB(0, 0, 0)
By.BorderSizePixel = 0
By.Size = UDim2.new(0, 200, 0, 20)
By.Font = Enum.Font.Code
By.Text = "Made By LOUDAUDlOS"
By.TextColor3 = Color3.fromRGB(255, 255, 255)
By.TextSize = 14.000

CommandBar.Name = "CommandBar"
CommandBar.Parent = AdminFrame
CommandBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CommandBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
CommandBar.BorderSizePixel = 0
CommandBar.Position = UDim2.new(0, 0, 0.916666687, 0)
CommandBar.Size = UDim2.new(0, 200, 0, 20)
CommandBar.Font = Enum.Font.Code
CommandBar.PlaceholderText = "type commands here (:)"
CommandBar.Text = ""
CommandBar.TextColor3 = Color3.fromRGB(0, 0, 0)
CommandBar.TextSize = 14.000
CommandBar.TextXAlignment = Enum.TextXAlignment.Left
CommandBar.ClearTextOnFocus = false
CommandBar.TextColor3 = Color3.fromRGB(255, 255, 255)

local function dragify(Frame,boool)
	local frametomove = Frame
	local dragToggle,dragInput,dragStart,startPos
	local dragSpeed = 0
	local function updateInput(input)
		local Delta = input.Position - dragStart
		frametomove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
	end
	Frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = frametomove.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)	
		end
	end)
	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			updateInput(input)
		end
	end)
end
dragify(AdminFrame)

function addcmd(cmd)
	local COMMAND = Instance.new("TextLabel")
	COMMAND.Name = "COMMAND"
	COMMAND.Parent = Commands
	COMMAND.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	COMMAND.BackgroundTransparency = 1.000
	COMMAND.BorderColor3 = Color3.fromRGB(0, 0, 0)
	COMMAND.BorderSizePixel = 0
	COMMAND.Size = UDim2.new(0, 200, 0, 25)
	COMMAND.Font = Enum.Font.Code
	COMMAND.Text = " " .. cmd
	COMMAND.TextColor3 = Color3.fromRGB(255, 255, 255)
	COMMAND.TextSize = 12.000
	COMMAND.TextXAlignment = Enum.TextXAlignment.Left
end

function apply(callback)
	local args = CommandBar.Text:split(" ")
	local player = args[2]
	local players = game:GetService("Players"):GetPlayers()
	if player == "all" then
		for _,v in pairs(players) do
			callback(v)
		end
	elseif player == "others" then
		for _,v in pairs(players) do
			if v.Name ~= game.Players.LocalPlayer.Name then
				callback(v)
			end
		end
	elseif player == "me" then
		callback(game.Players.LocalPlayer)
	else
		callback(game.Players:FindFirstChild(player))
	end
end

addcmd(":speed <player> <num>")
addcmd(":force <player> <x,y,z>")
addcmd(":rocket <player>")
addcmd(":rocks <player> <distance>")
addcmd(":slashfx")
addcmd(":trail <player>")
addcmd(":nohit <player>")
addcmd(":enablehit <player>")
addcmd(":playsound <player> <name>")
addcmd(":listsounds")
addcmd(":infpunish <player>")
addcmd(":gameplaypaused <player>")
addcmd(":ragdoll <player>")
addcmd(":unragdoll <player>")
addcmd(":stopforce <player>")
addcmd(":untrail <player>")
addcmd(":respawn")
addcmd(":flash")
addcmd(":smoke")
addcmd(":dashback <player>")
addcmd(":nosmoke")
addcmd(":kickback <player>")
addcmd(":fling <player>")
addcmd(":superfling <player>")
addcmd(":lag <player>")
addcmd(":monster")
addcmd(":superexplode <player>")
addcmd(":explode <player>")
addcmd(":kill <player>")
addcmd(":cut <player>")
addcmd(":worldshot")
addcmd(":funnyaura")
addcmd(":bring <player>")
addcmd(":loopbring <player>")
addcmd(":stopbring <player>")
addcmd(":pistol")
addcmd(":invis <player>")
addcmd(":vis <player>")
addcmd(":gocrazy")
addcmd(":flashaura")
addcmd(":bring2 <player>")
addcmd(":loopbring2 <player>")
addcmd(":stopbring2 <player>")
addcmd(":wolf <player>")
addcmd(":dogs")
addcmd(":frog")
addcmd(":bird")
addcmd(":elephant")
addcmd(":snake <player>")
addcmd(":totalitydog")
addcmd(":darkness")
addcmd(":supercut")
addcmd(":stun <player>")
addcmd(":unstun <player>")
addcmd(":nocollision")
addcmd(":collision")
addcmd(":blob")
addcmd(":invismap")
addcmd(":restoremap")
addcmd(":smalltornado")
addcmd(":guitar <player>")
addcmd(":kill2 <player>")
addcmd(":loopbring3 <player>")
addcmd(":stopbring3 <player>")
addcmd(":bring3 <player>")
addcmd(":dragonsbreath")
addcmd(":jumpscare <player>")
addcmd(":eyesjumpscare <player>")
addcmd(":damage <player> <number>")
addcmd(":heal <player>")
addcmd(":addaccessory <name>")
addcmd(":removeaccessory <name>")
addcmd(":listaccessories")
addcmd(":addaura <name>")
addcmd(":removeaura <name>")
addcmd(":listauras")
addcmd(":hidekillstreak <player>")
addcmd(":showkillstreak <player>")
addcmd(":hidechathistory")
addcmd(":showchathistory")

CommandBar.FocusLost:Connect(function(e)
	if e then
		local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
		local t = CommandBar.Text
		local args = t:split(" ")
		if args[1] == ":speed" then
			apply(function(v)
				mainremote:FireServer("ChangeAtribbe",v.Character,"SpeedChanger",tonumber(args[3]))
			end)
		elseif args[1] == ":force" then
			apply(function(v)
				mainremote:FireServer("Force",v.Character.HumanoidRootPart.HighQualtyPush,Vector3.new(tonumber(args[3]),tonumber(args[4]),tonumber(args[5])))
			end)
		elseif args[1] == ":rocket" then
			apply(function(v)
				mainremote:FireServer("Force",v.Character.HumanoidRootPart.HighQualtyPush,Vector3.new(0,1000,0))
			end)
		elseif args[1] == ":rocks" then
			apply(function(v)
				mainremote:FireServer("Rockkkk","RockPathV1",v.Character.HumanoidRootPart,{["Delay"] = 0,["Distance"] = tonumber(args[3])})
			end)
		elseif t == ":slashfx" then
			mainremote:FireServer("Chain of a thousand MilesGOOOO")
		elseif args[1] == ":trail" then
			apply(function(v)
				mainremote:FireServer("EnableTrailOnPart",v.Character.HumanoidRootPart,true)
			end)
		elseif args[1] == ":nohit" then
			apply(function(v)
				mainremote:FireServer("ChangeAtribbe",v.Character,"CantHit",true)
			end)
		elseif args[1] == ":enablehit" then
			apply(function(v)
				mainremote:FireServer("ChangeAtribbe",v.Character,"CantHit",false)
			end)
		elseif args[1] == ":playsound" then
			apply(function(v)
				mainremote:FireServer("Play",v.Character.HumanoidRootPart.RootAttachment[args[3]],args[3])
			end)
		elseif t == ":listsounds" then
			print("SOUNDS:\n")
			for _,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart.RootAttachment:GetChildren()) do
				print(v.Name)
			end
		elseif args[1] == ":infpunish" then
			apply(function(v)
				mainremote:FireServer("Force",v.Character.HumanoidRootPart.HighQualtyPush,Vector3.new(0,-1000,0))
			end)
		elseif args[1] == ":gameplaypaused" then
			apply(function(v)
				mainremote:FireServer("Force",v.Character.HumanoidRootPart.HighQualtyPush,Vector3.new(0,-math.huge,0))
			end)
		elseif args[1] == ":ragdoll" then
			apply(function(v)
				mainremote:FireServer("ChangeValue",v.Character.IsRagdoll,true)
			end)
		elseif args[1] == ":unragdoll" then
			apply(function(v)
				mainremote:FireServer("ChangeValue",v.Character.IsRagdoll,false)
			end)
		elseif args[1] == ":stopforce" then
			apply(function(v)
				mainremote:FireServer("Force",v.Character.HumanoidRootPart.HighQualtyPush,Vector3.new(0,0,0))
			end)
		elseif args[1] == ":untrail" then
			apply(function(v)
				mainremote:FireServer("EnableTrailOnPart",v.Character.HumanoidRootPart,false)
			end)
		elseif t == ":respawn" then
			mainremote:FireServer("LoadChar")
		elseif t == ":flash" then
			mainremote:FireServer("CollateralRuin")
		elseif t == ":smoke" then
			mainremote:FireServer("DashSmokeStart",1)
		elseif args[1] == ":dashback" then
			apply(function(v)
				mainremote:FireServer("Force",v.Character.HumanoidRootPart.HighQualtyPush,Vector3.new(0,-1000,0))
			end)
		elseif t == ":nosmoke" then
			mainremote:FireServer("DashSmokeEnd",1)
		elseif args[1] == ":kickback" then
			apply(function(v)
				mainremote:FireServer("DropKick20MoveEndd",v.Character)
			end)
		elseif args[1] == ":superfling" then
			apply(function(v)
				mainremote:FireServer("ChangeValue",v.Character.IsRagdoll,true)
				mainremote:FireServer("Force",v.Character.HumanoidRootPart.HighQualtyPush,Vector3.new(1000,1000,1000))
			end)
		elseif args[1] == ":lag" then
			apply(function(v)
				for i = 1,10 do
					mainremote:FireServer("DropKick20Move3",v.Character)
				end
			end)
		elseif t == ":monster" then
			mainremote:FireServer("Malevolent ShrineStart")
		elseif args[1] == ":superexplode" then
			apply(function(v)
				for i = 1,11 do
					mainremote:FireServer("Fury BarrageThrow",v.Character)
				end
			end)
		elseif args[1] == ":explode" then
			apply(function(v)
				for i = 1,5 do
					mainremote:FireServer("ThunderClapHitEnd",v.Character)
				end
			end)
		elseif args[1] == ":kill" then
			apply(function(v)
				for i = 1,10 do
					mainremote:FireServer("ThunderClapHitKnockback",v.Character)
				end
				mainremote:FireServer("ThunderClapHitEnd",v.Character)
			end)
		elseif args[1] == ":cut" then
			apply(function(v)
				mainremote:FireServer("SukunaSplitHit",v.Character)
			end)
		elseif t == ":worldshot" then
			mainremote:FireServer("WorldCutHitt")
		elseif t == ":funnyaura" then
			mainremote:FireServer("FugaArrow")
		elseif args[1] == ":bring" then
			apply(function(v)
				mainremote:FireServer("ShadowStab",v.Character,"ShadowStabEnemy")
				task.wait()
				mainremote:FireServer("ShadowStabThrow",v.Character)
			end)
		elseif args[1] == ":loopbring" then
			apply(function(v)
				mainremote:FireServer("ShadowStab",v.Character,"ShadowStabEnemy")
			end)
		elseif args[1] == ":stopbring" then
			apply(function(v)
				mainremote:FireServer("ShadowStabThrow",v.Character)
			end)
		elseif t == ":pistol" then
			mainremote:FireServer("ChangeTojiWapeon","Pistol")
		elseif args[1] == ":invis" then
			apply(function(v)
				mainremote:FireServer("SetTranspancyyyyyy",v.Character,true)
			end)
		elseif args[1] == ":vis" then
			apply(function(v)
				mainremote:FireServer("SetTranspancyyyyyy",v.Character,false)
			end)
		elseif t == ":gocrazy" then
			mainremote:FireServer("flashSlashDash")
		elseif t == ":flashaura" then
			mainremote:FireServer("DomainBreakerStartCutting")
		elseif args[1] == ":bring2" then
			apply(function(v)
				mainremote:FireServer("crossSlashHit",v.Character)
				task.wait()
				mainremote:FireServer("crossSlashHitSlashEnd",v.Character)
			end)
		elseif args[1] == ":loopbring2" then
			apply(function(v)
				mainremote:FireServer("crossSlashHit",v.Character)
			end)
		elseif args[1] == ":stopbring2" then
			apply(function(v)
				mainremote:FireServer("crossSlashHitSlashEnd",v.Character)
			end)
		elseif args[1] == ":wolf" then
			apply(function(v)
				mainremote:FireServer("Shadow Stlaker Start",v.Character)
			end)
		elseif t == ":dogs" then
			mainremote:FireServer("SpawnDivineDogss")
		elseif t == ":frog" then
			mainremote:FireServer("SpawnGammaaaa")
		elseif t == ":bird" then
			mainremote:FireServer("SummonNueEEEEEE",game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
		elseif t == ":elephant" then
			mainremote:FireServer("Max Elephanttttt",game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
		elseif args[1] == ":snake" then
			apply(function(v)
				mainremote:FireServer("TempestComboWELDDD",v.Character)
			end)
		elseif t == ":totalitydog" then
			mainremote:FireServer("SpawnDivineDogTotality",hrp.CFrame)
		elseif t == ":darkness" then
			mainremote:FireServer("ShadowGardenopennnnn",hrp.CFrame)
		elseif t == ":supercut" then
			mainremote:FireServer("WorldSlashSUPERCUT",hrp.CFrame)
		elseif args[1] == ":stun" then
			apply(function(v)
				mainremote:FireServer("ChangeAtribbe",v.Character,"Stun",true)
			end)
		elseif args[1] == ":unstun" then
			apply(function(v)
				mainremote:FireServer("ChangeAtribbe",v.Character,"Stun",false)
			end)
		elseif t == ":nocollision" then
			for _,v in pairs(game.Players:GetPlayers()) do
				mainremote:FireServer("CanColiideCharsssssssss",v.Character,false)
			end
		elseif t == ":collision" then
			for _,v in pairs(game.Players:GetPlayers()) do
				mainremote:FireServer("CanColiideCharsssssssss",v.Character,true)
			end
		elseif t == ":blob" then
			mainremote:FireServer("HornCeroShoottt",hrp.CFrame)
		elseif t == ":invismap" then
			for _,v in pairs(workspace:GetDescendants()) do
				mainremote:FireServer("SetTranspancyyyyyy",v,true)
			end
		elseif t == ":restoremap" then
			for _,v in pairs(workspace:GetDescendants()) do
				mainremote:FireServer("SetTranspancyyyyyy",v,false)
			end
		elseif t == ":smalltornado" then
			mainremote:FireServer("GunabiTwisterTORNADO",hrp.CFrame)
		elseif args[1] == ":guitar" then
			apply(function(v)
				mainremote:FireServer("ChangeMadraFanWelds",v.Character.MadraFan,true)
			end)
		elseif args[1] == ":kill2" then
			apply(function(v)
				mainremote:FireServer("TOPIMPORTANT_CharHater",v.Character,100,0,nil,true,0)
			end)
		elseif args[1] == ":loopbring3" then
			apply(function(v)
				mainremote:FireServer("AirCascadeHITTT",v.Character)
			end)
		elseif args[1] == ":stopbring3" then
			apply(function(v)
				mainremote:FireServer("AirCascadeEnddddd",v.Character)
			end)
		elseif args[1] == ":bring3" then
			apply(function(v)
				mainremote:FireServer("AirCascadeHITTT",v.Character)
				mainremote:FireServer("AirCascadeEnddddd",v.Character)
			end)
		elseif t == ":dragonsbreath" then
			mainremote:FireServer("GreatestFireFIREE")
		elseif args[1] == ":jumpscare" then
			apply(function(v)
				mainremote:FireServer("FIREOTHERCLIENTTTTT",v.Character,"PlayFunCtionsTableEFunction","SkullCrusherImpactFrames")
			end)
		elseif args[1] == ":eyesjumpscare" then
			apply(function(v)
				mainremote:FireServer("FIREOTHERCLIENTTTTT",v.Character,"PlayFunCtionsTableEFunction","SkullCrusherPullEyes")
			end)
		elseif args[1] == ":damage" then
			apply(function(v)
				mainremote:FireServer("DamgeHumanoidDDDDD",v.Character.Humanoid,tonumber(args[3]))
			end)
		elseif args[1] == ":heal" then
			apply(function(v)
				mainremote:FireServer("DamgeHumanoidDDDDD",v.Character.Humanoid,-math.huge)
			end)
		elseif args[1] == ":addaccessory" then
			mainremote:FireServer("addACCESSORIE",args[2])
		elseif args[1] == ":removeaccessory" then
			mainremote:FireServer("RemoveACCESSORIE",args[2])
		elseif t == ":listaccessories" then
			for _,v in pairs(game.ReplicatedStorage.AllACCESSORIES:GetChildren()) do
				print(v.Name)
			end
		elseif args[1] == ":addaura" then
			mainremote:FireServer("addACCESSORIE",args[2] .. " " .. args[3]),"AllAURAS")
		elseif args[1] == ":removeaura" then
			mainremote:FireServer("RemoveACCESSORIE",args[2] .. " " .. args[3])
		elseif args[1] == ":listauras" then
			for _,v in pairs(game.ReplicatedStorage.AllAURAS:GetChildren()) do
				print(v.Name)
			end
		elseif args[1] == ":hidekillstreak" then
			apply(function(v)
				mainremote:FireServer("EnabledSomeThing",v.Character.Killstreak,false)
				mainremote:FireServer("EnabledSomeThing",v.Character.THEGOLDENHIGHLIGHTTTT,false)
			end)
		elseif args[1] == ":showkillstreak" then
			apply(function(v)
				mainremote:FireServer("EnabledSomeThing",v.Character.Killstreak,true)
				mainremote:FireServer("EnabledSomeThing",v.Character.THEGOLDENHIGHLIGHTTTT,true)
			end)
		end
	end
end)
