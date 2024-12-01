local loopkill = false
local loopheal = false
local damage = game.ReplicatedStorage.Remotes.TakeDamage
local crate = game.ReplicatedStorage.ObbyFramework.Shared.SpinFunction
local admin = Instance.new("ScreenGui")
local command = Instance.new("TextBox")
admin.Name = "admin"
admin.Parent = game.CoreGui.RobloxGui
command.Name = "command"
command.Parent = admin
command.AnchorPoint = Vector2.new(0, 1)
command.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
command.BorderColor3 = Color3.fromRGB(0, 0, 0)
command.BorderSizePixel = 0
command.Position = UDim2.new(0, 0, 1, 0)
command.Size = UDim2.new(0, 200, 0, 50)
command.ClearTextOnFocus = false
command.Font = Enum.Font.SourceSans
command.Text = ""
command.TextColor3 = Color3.fromRGB(0, 0, 0)
command.TextSize = 14.000
command.PlaceholderText = "command bar"
function apply(callback)
	local args = command.Text:split(" ")
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
command.FocusLost:Connect(function(enter)
	if enter then
		local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
		local t = command.Text
		local args = t:split(" ")
		if args[1] == "kill" then
			apply(function(v)
				damage:FireServer(v.Character.Humanoid,math.huge)
			end)
		elseif args[1] == "heal" then
			apply(function(v)
				damage:FireServer(v.Character.Humanoid,-math.huge)
			end)
		elseif args[1] == "loopkill" then
			apply(function(v)
				loopkill = true
                pcall(function()
				    repeat
						damage:FireServer(v.Character.Humanoid,math.huge)
						task.wait(.1)
				    until loopkill == false
                end)
			end)
		elseif args[1] == "loopheal" then
			apply(function(v)
				loopheal = true
				pcall(function()
				    repeat
						damage:FireServer(v.Character.Humanoid,-math.huge)
						task.wait(.1)
				    until loopheal == false
                end)
			end)
		elseif t == "unloopkill" then
			loopkill = false
		elseif t == "unloopheal" then
			loopheal = false
		elseif t == "easymode" then
			hrp.Parent.TouchScript.Disabled = true
		elseif t == "skipstage" then
			firetouchinterest(hrp,workspace.Stages:FindFirstChild(tostring(game.Players.LocalPlayer.CurrentStage.Value+1)),0)
		elseif t == "skiptoend" then
			repeat
                firetouchinterest(hrp,workspace.Stages:FindFirstChild(tostring(game.Players.LocalPlayer.CurrentStage.Value+1)),0)
                task.wait(.1)
            until game.Players.LocalPlayer.CurrentStage.Value == 181
		elseif t == "coils" then
			local spcoil = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
			local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
			getgenv().speed = hum.WalkSpeed
			spcoil.Name = "_SpeedCoil"
			spcoil.RequiresHandle = false
			spcoil.CanBeDropped = false
			spcoil.TextureId = "rbxassetid://99170415"
			spcoil.Equipped:Connect(function()
				hum.WalkSpeed = getgenv().speed*2
			end)
			spcoil.Unequipped:Connect(function()
				hum.WalkSpeed = getgenv().speed
			end)
			local gravcoil = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
			getgenv().gravity = workspace.Gravity
			gravcoil.Name = "_GravityCoil"
			gravcoil.RequiresHandle = false
			gravcoil.CanBeDropped = false
			gravcoil.TextureId = "rbxassetid://16619617"
			gravcoil.Equipped:Connect(function()
				workspace.Gravity = getgenv().gravity/4
			end)
			gravcoil.Unequipped:Connect(function()
				workspace.Gravity = getgenv().gravity
			end)
			local fusioncoil = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
			fusioncoil.Name = "_FusionCoil"
			fusioncoil.RequiresHandle = false
			fusioncoil.CanBeDropped = false
			fusioncoil.TextureId = "rbxassetid://510572817"
			fusioncoil.Equipped:Connect(function()
				workspace.Gravity = getgenv().gravity/4
				hum.WalkSpeed = getgenv().speed*2
			end)
			fusioncoil.Unequipped:Connect(function()
				workspace.Gravity = getgenv().gravity
				hum.WalkSpeed = getgenv().speed
			end)
        elseif args[1] == "opencrate" then
            if args[2] == "1" then
                crate:InvokeServer("Crate1","Trail",true)
            elseif args[2] == "2" then
                crate:InvokeServer("Crate2","Trail",true)
            elseif args[2] == "3" then
                crate:InvokeServer("Crate1","Halo",true)
            elseif args[2] == "4" then
                crate:InvokeServer("Crate2","Halo",true)
            end
        elseif t == "crates" then
            print("1 - Trail Crate #1\n2 - Trail Crate #2\n3 - Halo Crate #1\n4 - Halo Crate #2")
		elseif t == "cmds" then
			print("\ncmds\nkill <name>\nheal <name>\nloopkill <name>\nloopheal <name>\nunloopkill\nunloopheal\neasymode\nskipstage\nskiptoend\ncoils\nopencrate <number>\ncrates")
        end
		task.wait()
		command.Text = ""
	end
end)
