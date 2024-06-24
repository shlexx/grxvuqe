-- Gui to Lua
-- Version: 3.2

-- Instances:

local mainadmin = Instance.new("ScreenGui")
local passframe = Instance.new("Frame")
local uic1 = Instance.new("UICorner")
local passlabel = Instance.new("TextLabel")
local passinput = Instance.new("TextBox")
local uic3 = Instance.new("UICorner")
local submitpass = Instance.new("TextButton")
local uic2 = Instance.new("UICorner")
local cmdsframe = Instance.new("Frame")
local uic4 = Instance.new("UICorner")
local adminname = Instance.new("TextLabel")
local uic5 = Instance.new("UICorner")
local cmdslist = Instance.new("ScrollingFrame")
local cmd1 = Instance.new("TextLabel")
local cmd2 = Instance.new("TextLabel")
local cmd3 = Instance.new("TextLabel")
local cmd4 = Instance.new("TextLabel")
local cmd5 = Instance.new("TextLabel")
local cmd6 = Instance.new("TextLabel")
local cmd7 = Instance.new("TextLabel")
local cmd8 = Instance.new("TextLabel")
local cmd9 = Instance.new("TextLabel")
local cmd10 = Instance.new("TextLabel")
local cmd11 = Instance.new("TextLabel")
local cmd12 = Instance.new("TextLabel")
local cmd13 = Instance.new("TextLabel")
local cmd14 = Instance.new("TextLabel")
local cmd15 = Instance.new("TextLabel")
local cmd16 = Instance.new("TextLabel")
local cmd17 = Instance.new("TextLabel")
local cmd18 = Instance.new("TextLabel")
local cmd19 = Instance.new("TextLabel")
local cmd20 = Instance.new("TextLabel")
local cmdbarframe = Instance.new("Frame")
local cmdinput = Instance.new("TextBox")
local execmdbutton = Instance.new("TextButton")

--Properties:

mainadmin.Name = "mainadmin"
mainadmin.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

passframe.Name = "passframe"
passframe.Parent = mainadmin
passframe.AnchorPoint = Vector2.new(0.5, 0.5)
passframe.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
passframe.BackgroundTransparency = 0.200
passframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
passframe.BorderSizePixel = 0
passframe.Position = UDim2.new(0.5, 0, 0.5, 0)
passframe.Size = UDim2.new(0, 300, 0, 200)

uic1.Name = "uic1"
uic1.Parent = passframe

passlabel.Name = "passlabel"
passlabel.Parent = passframe
passlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
passlabel.BackgroundTransparency = 1.000
passlabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
passlabel.BorderSizePixel = 0
passlabel.Position = UDim2.new(0.226666674, 0, 0.25, 0)
passlabel.Size = UDim2.new(0, 50, 0, 50)
passlabel.Font = Enum.Font.SourceSansBold
passlabel.Text = "password:"
passlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
passlabel.TextSize = 14.000

passinput.Name = "passinput"
passinput.Parent = passframe
passinput.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
passinput.BorderColor3 = Color3.fromRGB(0, 0, 0)
passinput.BorderSizePixel = 0
passinput.Position = UDim2.new(0.434447646, 0, 0.309110254, 0)
passinput.Size = UDim2.new(0, 100, 0, 25)
passinput.Font = Enum.Font.SourceSansBold
passinput.Text = ""
passinput.TextColor3 = Color3.fromRGB(255, 255, 255)
passinput.TextSize = 14.000

uic3.Name = "uic3"
uic3.Parent = passinput

submitpass.Name = "submitpass"
submitpass.Parent = passframe
submitpass.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
submitpass.BorderColor3 = Color3.fromRGB(0, 0, 0)
submitpass.BorderSizePixel = 0
submitpass.Position = UDim2.new(0.333333343, 0, 0.589999974, 0)
submitpass.Size = UDim2.new(0, 100, 0, 25)
submitpass.Font = Enum.Font.SourceSansBold
submitpass.Text = "submit"
submitpass.TextColor3 = Color3.fromRGB(255, 255, 255)
submitpass.TextSize = 14.000
submitpass.MouseButton1Click:Connect(function()
	if passinput.Text == "gravity" then
		cmdbarframe.Visible = true
		passframe.Visible = false
	end
end)

uic2.Name = "uic2"
uic2.Parent = submitpass

cmdsframe.Name = "cmdsframe"
cmdsframe.Parent = mainadmin
cmdsframe.AnchorPoint = Vector2.new(0.5, 0.5)
cmdsframe.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
cmdsframe.BackgroundTransparency = 0.200
cmdsframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmdsframe.BorderSizePixel = 0
cmdsframe.Position = UDim2.new(0.5, 0, 0.5, 0)
cmdsframe.Size = UDim2.new(0, 250, 0, 350)
cmdsframe.Visible = false

uic4.Name = "uic4"
uic4.Parent = cmdsframe

adminname.Name = "adminname"
adminname.Parent = cmdsframe
adminname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
adminname.BackgroundTransparency = 1.000
adminname.BorderColor3 = Color3.fromRGB(0, 0, 0)
adminname.BorderSizePixel = 0
adminname.Position = UDim2.new(-0.000318847655, 0, -0.00215541292, 0)
adminname.Size = UDim2.new(0, 250, 0, 24)
adminname.Font = Enum.Font.SourceSansBold
adminname.Text = "fenx admin beta"
adminname.TextColor3 = Color3.fromRGB(255, 255, 255)
adminname.TextSize = 14.000

uic5.Name = "uic5"
uic5.Parent = adminname

cmdslist.Name = "cmdslist"
cmdslist.Parent = cmdsframe
cmdslist.Active = true
cmdslist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmdslist.BackgroundTransparency = 1.000
cmdslist.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmdslist.BorderSizePixel = 0
cmdslist.Position = UDim2.new(-0.00400000019, 0, 0.0885714293, 0)
cmdslist.Size = UDim2.new(0, 251, 0, 319)

cmd1.Name = "cmd1"
cmd1.Parent = cmdslist
cmd1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd1.BackgroundTransparency = 1.000
cmd1.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd1.BorderSizePixel = 0
cmd1.Size = UDim2.new(0, 251, 0, 20)
cmd1.Font = Enum.Font.SourceSansBold
cmd1.Text = "infjump"
cmd1.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd1.TextSize = 14.000

cmd2.Name = "cmd2"
cmd2.Parent = cmdslist
cmd2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd2.BackgroundTransparency = 1.000
cmd2.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd2.BorderSizePixel = 0
cmd2.Position = UDim2.new(0, 0, 0.0350000001, 0)
cmd2.Size = UDim2.new(0, 251, 0, 20)
cmd2.Font = Enum.Font.SourceSansBold
cmd2.Text = "speed <number>"
cmd2.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd2.TextSize = 14.000

cmd3.Name = "cmd3"
cmd3.Parent = cmdslist
cmd3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd3.BackgroundTransparency = 1.000
cmd3.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd3.BorderSizePixel = 0
cmd3.Position = UDim2.new(0.00398406386, 0, 0.0700000003, 0)
cmd3.Size = UDim2.new(0, 251, 0, 20)
cmd3.Font = Enum.Font.SourceSansBold
cmd3.Text = "jumppower <number>"
cmd3.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd3.TextSize = 14.000

cmd4.Name = "cmd4"
cmd4.Parent = cmdslist
cmd4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd4.BackgroundTransparency = 1.000
cmd4.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd4.BorderSizePixel = 0
cmd4.Position = UDim2.new(0, 0, 0.104999997, 0)
cmd4.Size = UDim2.new(0, 251, 0, 20)
cmd4.Font = Enum.Font.SourceSansBold
cmd4.Text = "fly"
cmd4.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd4.TextSize = 14.000

cmd5.Name = "cmd5"
cmd5.Parent = cmdslist
cmd5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd5.BackgroundTransparency = 1.000
cmd5.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd5.BorderSizePixel = 0
cmd5.Position = UDim2.new(0, 0, 0.140000001, 0)
cmd5.Size = UDim2.new(0, 251, 0, 20)
cmd5.Font = Enum.Font.SourceSansBold
cmd5.Text = "unctest"
cmd5.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd5.TextSize = 14.000

cmd6.Name = "cmd6"
cmd6.Parent = cmdslist
cmd6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd6.BackgroundTransparency = 1.000
cmd6.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd6.BorderSizePixel = 0
cmd6.Position = UDim2.new(0, 0, 0.174999997, 0)
cmd6.Size = UDim2.new(0, 251, 0, 20)
cmd6.Font = Enum.Font.SourceSansBold
cmd6.Text = "cmds"
cmd6.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd6.TextSize = 14.000

cmd7.Name = "cmd7"
cmd7.Parent = cmdslist
cmd7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd7.BackgroundTransparency = 1.000
cmd7.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd7.BorderSizePixel = 0
cmd7.Position = UDim2.new(0, 0, 0.209999993, 0)
cmd7.Size = UDim2.new(0, 251, 0, 20)
cmd7.Font = Enum.Font.SourceSansBold
cmd7.Text = "rejoin"
cmd7.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd7.TextSize = 14.000

cmd8.Name = "cmd8"
cmd8.Parent = cmdslist
cmd8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd8.BackgroundTransparency = 1.000
cmd8.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd8.BorderSizePixel = 0
cmd8.Position = UDim2.new(0, 0, 0.245000005, 0)
cmd8.Size = UDim2.new(0, 251, 0, 20)
cmd8.Font = Enum.Font.SourceSansBold
cmd8.Text = "infyield"
cmd8.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd8.TextSize = 14.000

cmd9.Name = "cmd9"
cmd9.Parent = cmdslist
cmd9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd9.BackgroundTransparency = 1.000
cmd9.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd9.BorderSizePixel = 0
cmd9.Position = UDim2.new(0, 0, 0.280000001, 0)
cmd9.Size = UDim2.new(0, 251, 0, 20)
cmd9.Font = Enum.Font.SourceSansBold
cmd9.Text = "nameless"
cmd9.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd9.TextSize = 14.000

cmd10.Name = "cmd10"
cmd10.Parent = cmdslist
cmd10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd10.BackgroundTransparency = 1.000
cmd10.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd10.BorderSizePixel = 0
cmd10.Position = UDim2.new(0, 0, 0.314999998, 0)
cmd10.Size = UDim2.new(0, 251, 0, 20)
cmd10.Font = Enum.Font.SourceSansBold
cmd10.Text = "exit"
cmd10.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd10.TextSize = 14.000

cmd11.Name = "cmd11"
cmd11.Parent = cmdslist
cmd11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd11.BackgroundTransparency = 1.000
cmd11.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd11.BorderSizePixel = 0
cmd11.Position = UDim2.new(0, 0, 0.349999994, 0)
cmd11.Size = UDim2.new(0, 251, 0, 20)
cmd11.Font = Enum.Font.SourceSansBold
cmd11.Text = "noclip"
cmd11.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd11.TextSize = 14.000

cmd12.Name = "cmd12"
cmd12.Parent = cmdslist
cmd12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd12.BackgroundTransparency = 1.000
cmd12.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd12.BorderSizePixel = 0
cmd12.Position = UDim2.new(0, 0, 0.38499999, 0)
cmd12.Size = UDim2.new(0, 251, 0, 20)
cmd12.Font = Enum.Font.SourceSansBold
cmd12.Text = "destroy"
cmd12.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd12.TextSize = 14.000

cmd13.Name = "cmd13"
cmd13.Parent = cmdslist
cmd13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd13.BackgroundTransparency = 1.000
cmd13.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd13.BorderSizePixel = 0
cmd13.Position = UDim2.new(0, 0, 0.419999987, 0)
cmd13.Size = UDim2.new(0, 251, 0, 20)
cmd13.Font = Enum.Font.SourceSansBold
cmd13.Text = "deletetool"
cmd13.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd13.TextSize = 14.000

cmd14.Name = "cmd14"
cmd14.Parent = cmdslist
cmd14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd14.BackgroundTransparency = 1.000
cmd14.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd14.BorderSizePixel = 0
cmd14.Position = UDim2.new(0, 0, 0.455000013, 0)
cmd14.Size = UDim2.new(0, 251, 0, 20)
cmd14.Font = Enum.Font.SourceSansBold
cmd14.Text = "respawn"
cmd14.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd14.TextSize = 14.000

cmd15.Name = "cmd15"
cmd15.Parent = cmdslist
cmd15.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd15.BackgroundTransparency = 1.000
cmd15.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd15.BorderSizePixel = 0
cmd15.Position = UDim2.new(0, 0, 0.49000001, 0)
cmd15.Size = UDim2.new(0, 251, 0, 20)
cmd15.Font = Enum.Font.SourceSansBold
cmd15.Text = "load <link>"
cmd15.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd15.TextSize = 14.000

cmd16.Name = "cmd16"
cmd16.Parent = cmdslist
cmd16.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd16.BackgroundTransparency = 1.000
cmd16.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd16.BorderSizePixel = 0
cmd16.Position = UDim2.new(0, 0, 0.524999976, 0)
cmd16.Size = UDim2.new(0, 251, 0, 20)
cmd16.Font = Enum.Font.SourceSansBold
cmd16.Text = "telekinesis"
cmd16.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd16.TextSize = 14.000

cmd17.Name = "cmd17"
cmd17.Parent = cmdslist
cmd17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd17.BackgroundTransparency = 1.000
cmd17.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd17.BorderSizePixel = 0
cmd17.Position = UDim2.new(0, 0, 0.560000002, 0)
cmd17.Size = UDim2.new(0, 251, 0, 20)
cmd17.Font = Enum.Font.SourceSansBold
cmd17.Text = "savegame"
cmd17.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd17.TextSize = 14.000

cmd18.Name = "cmd18"
cmd18.Parent = cmdslist
cmd18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd18.BackgroundTransparency = 1.000
cmd18.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd18.BorderSizePixel = 0
cmd18.Position = UDim2.new(0, 0, 0.595000029, 0)
cmd18.Size = UDim2.new(0, 251, 0, 20)
cmd18.Font = Enum.Font.SourceSansBold
cmd18.Text = "to <player>"
cmd18.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd18.TextSize = 14.000

cmd19.Name = "cmd19"
cmd19.Parent = cmdslist
cmd19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd19.BackgroundTransparency = 1.000
cmd19.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd19.BorderSizePixel = 0
cmd19.Position = UDim2.new(0, 0, 0.629999995, 0)
cmd19.Size = UDim2.new(0, 251, 0, 20)
cmd19.Font = Enum.Font.SourceSansBold
cmd19.Text = "swim"
cmd19.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd19.TextSize = 14.000

cmd20.Name = "cmd20"
cmd20.Parent = cmdslist
cmd20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd20.BackgroundTransparency = 1.000
cmd20.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmd20.BorderSizePixel = 0
cmd20.Position = UDim2.new(0, 0, 0.665000021, 0)
cmd20.Size = UDim2.new(0, 251, 0, 20)
cmd20.Font = Enum.Font.SourceSansBold
cmd20.Text = "nolag"
cmd20.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd20.TextSize = 14.000

cmdbarframe.Name = "cmdbarframe"
cmdbarframe.Parent = mainadmin
cmdbarframe.AnchorPoint = Vector2.new(1, 1)
cmdbarframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmdbarframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmdbarframe.BorderSizePixel = 0
cmdbarframe.Position = UDim2.new(1, 0, 1, 0)
cmdbarframe.Size = UDim2.new(0, 200, 0, 50)
cmdbarframe.Visible = false

cmdinput.Name = "cmdinput"
cmdinput.Parent = cmdbarframe
cmdinput.BackgroundColor3 = Color3.fromRGB(74, 74, 74)
cmdinput.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmdinput.BorderSizePixel = 0
cmdinput.Size = UDim2.new(0, 200, 0, 25)
cmdinput.Font = Enum.Font.SourceSansBold
cmdinput.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
cmdinput.PlaceholderText = "command bar"
cmdinput.Text = ""
cmdinput.TextColor3 = Color3.fromRGB(255, 255, 255)
cmdinput.TextSize = 14.000
cmdinput.TextWrapped = true

execmdbutton.Name = "execmdbutton"
execmdbutton.Parent = cmdbarframe
execmdbutton.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
execmdbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
execmdbutton.BorderSizePixel = 0
execmdbutton.Position = UDim2.new(0, 0, 0.5, 0)
execmdbutton.Size = UDim2.new(0, 200, 0, 25)
execmdbutton.Font = Enum.Font.SourceSansBold
execmdbutton.Text = "execute command"
execmdbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
execmdbutton.TextSize = 14.000
execmdbutton.MouseButton1Click:Connect(function()
	local args = cmdinput.Text:split(" ")
	if args[1] == "infjump" then
		game:GetService("UserInputService").JumpRequest:Connect(function()
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end)
	elseif args[1] == "speed" then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(args[2])
	elseif args[1] == "jumppower" then
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(args[2])
	elseif args[1] == "fly" then
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

			-- Create BodyGyro and BodyVelocity instances
			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.P = 9e4
			bodyGyro.Parent = humanoidRootPart
			bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			bodyGyro.CFrame = humanoidRootPart.CFrame

			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Parent = humanoidRootPart
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

			-- Disable gravity
			character.Humanoid.PlatformStand = true

			-- Disable collisions
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end

			-- Update the flying movement
			runService.Heartbeat:Connect(function()
				if flying then
					bodyGyro.CFrame = workspace.CurrentCamera.CFrame
					local cameraCFrame = workspace.CurrentCamera.CFrame
					bodyVelocity.Velocity = (cameraCFrame.LookVector * direction.Z 
						+ cameraCFrame.RightVector * direction.X) * speed
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
	elseif args[1] == "unctest" then
		local passes, fails, undefined = 0, 0, 0
		local running = 0

		local function getGlobal(path)
			local value = getfenv(0)

			while value ~= nil and path ~= "" do
				local name, nextValue = string.match(path, "^([^.]+)%.?(.*)$")
				value = value[name]
				path = nextValue
			end

			return value
		end

		local function test(name, aliases, callback)
			running += 1

			task.spawn(function()
				if not callback then
					print("⏺️ " .. name)
				elseif not getGlobal(name) then
					fails += 1
					warn("⛔ " .. name)
				else
					local success, message = pcall(callback)

					if success then
						passes += 1
						print("✅ " .. name .. (message and " • " .. message or ""))
					else
						fails += 1
						warn("⛔ " .. name .. " failed: " .. message)
					end
				end

				local undefinedAliases = {}

				for _, alias in ipairs(aliases) do
					if getGlobal(alias) == nil then
						table.insert(undefinedAliases, alias)
					end
				end

				if #undefinedAliases > 0 then
					undefined += 1
					warn("⚠️ " .. table.concat(undefinedAliases, ", "))
				end

				running -= 1
			end)
		end

		-- Header and summary

		print("\n")

		print("UNC Environment Check")
		print("✅ - Pass, ⛔ - Fail, ⏺️ - No test, ⚠️ - Missing aliases\n")

		task.defer(function()
			repeat task.wait() until running == 0

			local rate = math.round(passes / (passes + fails) * 100)
			local outOf = passes .. " out of " .. (passes + fails)

			print("\n")

			print("UNC Summary")
			print("✅ Tested with a " .. rate .. "% success rate (" .. outOf .. ")")
			print("⛔ " .. fails .. " tests failed")
			print("⚠️ " .. undefined .. " globals are missing aliases")
		end)

		-- Cache

		test("cache.invalidate", {}, function()
			local container = Instance.new("Folder")
			local part = Instance.new("Part", container)
			cache.invalidate(container:FindFirstChild("Part"))
			assert(part ~= container:FindFirstChild("Part"), "Reference `part` could not be invalidated")
		end)

		test("cache.iscached", {}, function()
			local part = Instance.new("Part")
			assert(cache.iscached(part), "Part should be cached")
			cache.invalidate(part)
			assert(not cache.iscached(part), "Part should not be cached")
		end)

		test("cache.replace", {}, function()
			local part = Instance.new("Part")
			local fire = Instance.new("Fire")
			cache.replace(part, fire)
			assert(part ~= fire, "Part was not replaced with Fire")
		end)

		test("cloneref", {}, function()
			local part = Instance.new("Part")
			local clone = cloneref(part)
			assert(part ~= clone, "Clone should not be equal to original")
			clone.Name = "Test"
			assert(part.Name == "Test", "Clone should have updated the original")
		end)

		test("compareinstances", {}, function()
			local part = Instance.new("Part")
			local clone = cloneref(part)
			assert(part ~= clone, "Clone should not be equal to original")
			assert(compareinstances(part, clone), "Clone should be equal to original when using compareinstances()")
		end)

		-- Closures

		local function shallowEqual(t1, t2)
			if t1 == t2 then
				return true
			end

			local UNIQUE_TYPES = {
				["function"] = true,
				["table"] = true,
				["userdata"] = true,
				["thread"] = true,
			}

			for k, v in pairs(t1) do
				if UNIQUE_TYPES[type(v)] then
					if type(t2[k]) ~= type(v) then
						return false
					end
				elseif t2[k] ~= v then
					return false
				end
			end

			for k, v in pairs(t2) do
				if UNIQUE_TYPES[type(v)] then
					if type(t2[k]) ~= type(v) then
						return false
					end
				elseif t1[k] ~= v then
					return false
				end
			end

			return true
		end

		test("checkcaller", {}, function()
			assert(checkcaller(), "Main scope should return true")
		end)

		test("clonefunction", {}, function()
			local function test()
				return "success"
			end
			local copy = clonefunction(test)
			assert(test() == copy(), "The clone should return the same value as the original")
			assert(test ~= copy, "The clone should not be equal to the original")
		end)

		test("getcallingscript", {})

		test("getscriptclosure", {"getscriptfunction"}, function()
			local module = game:GetService("CoreGui").RobloxGui.Modules.Common.Constants
			local constants = getrenv().require(module)
			local generated = getscriptclosure(module)()
			assert(constants ~= generated, "Generated module should not match the original")
			assert(shallowEqual(constants, generated), "Generated constant table should be shallow equal to the original")
		end)

		test("hookfunction", {"replaceclosure"}, function()
			local function test()
				return true
			end
			local ref = hookfunction(test, function()
				return false
			end)
			assert(test() == false, "Function should return false")
			assert(ref() == true, "Original function should return true")
			assert(test ~= ref, "Original function should not be same as the reference")
		end)

		test("iscclosure", {}, function()
			assert(iscclosure(print) == true, "Function 'print' should be a C closure")
			assert(iscclosure(function() end) == false, "Executor function should not be a C closure")
		end)

		test("islclosure", {}, function()
			assert(islclosure(print) == false, "Function 'print' should not be a Lua closure")
			assert(islclosure(function() end) == true, "Executor function should be a Lua closure")
		end)

		test("isexecutorclosure", {"checkclosure", "isourclosure"}, function()
			assert(isexecutorclosure(isexecutorclosure) == true, "Did not return true for an executor global")
			assert(isexecutorclosure(newcclosure(function() end)) == true, "Did not return true for an executor C closure")
			assert(isexecutorclosure(function() end) == true, "Did not return true for an executor Luau closure")
			assert(isexecutorclosure(print) == false, "Did not return false for a Roblox global")
		end)

		test("loadstring", {}, function()
			local animate = game:GetService("Players").LocalPlayer.Character.Animate
			local bytecode = getscriptbytecode(animate)
			local func = loadstring(bytecode)
			assert(type(func) ~= "function", "Luau bytecode should not be loadable!")
			assert(assert(loadstring("return ... + 1"))(1) == 2, "Failed to do simple math")
			assert(type(select(2, loadstring("f"))) == "string", "Loadstring did not return anything for a compiler error")
		end)

		test("newcclosure", {}, function()
			local function test()
				return true
			end
			local testC = newcclosure(test)
			assert(test() == testC(), "New C closure should return the same value as the original")
			assert(test ~= testC, "New C closure should not be same as the original")
			assert(iscclosure(testC), "New C closure should be a C closure")
		end)

		-- Console

		test("rconsoleclear", {"consoleclear"})

		test("rconsolecreate", {"consolecreate"})

		test("rconsoledestroy", {"consoledestroy"})

		test("rconsoleinput", {"consoleinput"})

		test("rconsoleprint", {"consoleprint"})

		test("rconsolesettitle", {"rconsolename", "consolesettitle"})

		-- Crypt

		test("crypt.base64encode", {"crypt.base64.encode", "crypt.base64_encode", "base64.encode", "base64_encode"}, function()
			assert(crypt.base64encode("test") == "dGVzdA==", "Base64 encoding failed")
		end)

		test("crypt.base64decode", {"crypt.base64.decode", "crypt.base64_decode", "base64.decode", "base64_decode"}, function()
			assert(crypt.base64decode("dGVzdA==") == "test", "Base64 decoding failed")
		end)

		test("crypt.encrypt", {}, function()
			local key = crypt.generatekey()
			local encrypted, iv = crypt.encrypt("test", key, nil, "CBC")
			assert(iv, "crypt.encrypt should return an IV")
			local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")
			assert(decrypted == "test", "Failed to decrypt raw string from encrypted data")
		end)

		test("crypt.decrypt", {}, function()
			local key, iv = crypt.generatekey(), crypt.generatekey()
			local encrypted = crypt.encrypt("test", key, iv, "CBC")
			local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")
			assert(decrypted == "test", "Failed to decrypt raw string from encrypted data")
		end)

		test("crypt.generatebytes", {}, function()
			local size = math.random(10, 100)
			local bytes = crypt.generatebytes(size)
			assert(#crypt.base64decode(bytes) == size, "The decoded result should be " .. size .. " bytes long (got " .. #crypt.base64decode(bytes) .. " decoded, " .. #bytes .. " raw)")
		end)

		test("crypt.generatekey", {}, function()
			local key = crypt.generatekey()
			assert(#crypt.base64decode(key) == 32, "Generated key should be 32 bytes long when decoded")
		end)

		test("crypt.hash", {}, function()
			local algorithms = {'sha1', 'sha384', 'sha512', 'md5', 'sha256', 'sha3-224', 'sha3-256', 'sha3-512'}
			for _, algorithm in ipairs(algorithms) do
				local hash = crypt.hash("test", algorithm)
				assert(hash, "crypt.hash on algorithm '" .. algorithm .. "' should return a hash")
			end
		end)

		--- Debug

		test("debug.getconstant", {}, function()
			local function test()
				print("Hello, world!")
			end
			assert(debug.getconstant(test, 1) == "print", "First constant must be print")
			assert(debug.getconstant(test, 2) == nil, "Second constant must be nil")
			assert(debug.getconstant(test, 3) == "Hello, world!", "Third constant must be 'Hello, world!'")
		end)

		test("debug.getconstants", {}, function()
			local function test()
				local num = 5000 .. 50000
				print("Hello, world!", num, warn)
			end
			local constants = debug.getconstants(test)
			assert(constants[1] == 50000, "First constant must be 50000")
			assert(constants[2] == "print", "Second constant must be print")
			assert(constants[3] == nil, "Third constant must be nil")
			assert(constants[4] == "Hello, world!", "Fourth constant must be 'Hello, world!'")
			assert(constants[5] == "warn", "Fifth constant must be warn")
		end)

		test("debug.getinfo", {}, function()
			local types = {
				source = "string",
				short_src = "string",
				func = "function",
				what = "string",
				currentline = "number",
				name = "string",
				nups = "number",
				numparams = "number",
				is_vararg = "number",
			}
			local function test(...)
				print(...)
			end
			local info = debug.getinfo(test)
			for k, v in pairs(types) do
				assert(info[k] ~= nil, "Did not return a table with a '" .. k .. "' field")
				assert(type(info[k]) == v, "Did not return a table with " .. k .. " as a " .. v .. " (got " .. type(info[k]) .. ")")
			end
		end)

		test("debug.getproto", {}, function()
			local function test()
				local function proto()
					return true
				end
			end
			local proto = debug.getproto(test, 1, true)[1]
			local realproto = debug.getproto(test, 1)
			assert(proto, "Failed to get the inner function")
			assert(proto() == true, "The inner function did not return anything")
			if not realproto() then
				return "Proto return values are disabled on this executor"
			end
		end)

		test("debug.getprotos", {}, function()
			local function test()
				local function _1()
					return true
				end
				local function _2()
					return true
				end
				local function _3()
					return true
				end
			end
			for i in ipairs(debug.getprotos(test)) do
				local proto = debug.getproto(test, i, true)[1]
				local realproto = debug.getproto(test, i)
				assert(proto(), "Failed to get inner function " .. i)
				if not realproto() then
					return "Proto return values are disabled on this executor"
				end
			end
		end)

		test("debug.getstack", {}, function()
			local _ = "a" .. "b"
			assert(debug.getstack(1, 1) == "ab", "The first item in the stack should be 'ab'")
			assert(debug.getstack(1)[1] == "ab", "The first item in the stack table should be 'ab'")
		end)

		test("debug.getupvalue", {}, function()
			local upvalue = function() end
			local function test()
				print(upvalue)
			end
			assert(debug.getupvalue(test, 1) == upvalue, "Unexpected value returned from debug.getupvalue")
		end)

		test("debug.getupvalues", {}, function()
			local upvalue = function() end
			local function test()
				print(upvalue)
			end
			local upvalues = debug.getupvalues(test)
			assert(upvalues[1] == upvalue, "Unexpected value returned from debug.getupvalues")
		end)

		test("debug.setconstant", {}, function()
			local function test()
				return "fail"
			end
			debug.setconstant(test, 1, "success")
			assert(test() == "success", "debug.setconstant did not set the first constant")
		end)

		test("debug.setstack", {}, function()
			local function test()
				return "fail", debug.setstack(1, 1, "success")
			end
			assert(test() == "success", "debug.setstack did not set the first stack item")
		end)

		test("debug.setupvalue", {}, function()
			local function upvalue()
				return "fail"
			end
			local function test()
				return upvalue()
			end
			debug.setupvalue(test, 1, function()
				return "success"
			end)
			assert(test() == "success", "debug.setupvalue did not set the first upvalue")
		end)

		-- Filesystem

		if isfolder and makefolder and delfolder then
			if isfolder(".tests") then
				delfolder(".tests")
			end
			makefolder(".tests")
		end

		test("readfile", {}, function()
			writefile(".tests/readfile.txt", "success")
			assert(readfile(".tests/readfile.txt") == "success", "Did not return the contents of the file")
		end)

		test("listfiles", {}, function()
			makefolder(".tests/listfiles")
			writefile(".tests/listfiles/test_1.txt", "success")
			writefile(".tests/listfiles/test_2.txt", "success")
			local files = listfiles(".tests/listfiles")
			assert(#files == 2, "Did not return the correct number of files")
			assert(isfile(files[1]), "Did not return a file path")
			assert(readfile(files[1]) == "success", "Did not return the correct files")
			makefolder(".tests/listfiles_2")
			makefolder(".tests/listfiles_2/test_1")
			makefolder(".tests/listfiles_2/test_2")
			local folders = listfiles(".tests/listfiles_2")
			assert(#folders == 2, "Did not return the correct number of folders")
			assert(isfolder(folders[1]), "Did not return a folder path")
		end)

		test("writefile", {}, function()
			writefile(".tests/writefile.txt", "success")
			assert(readfile(".tests/writefile.txt") == "success", "Did not write the file")
			local requiresFileExt = pcall(function()
				writefile(".tests/writefile", "success")
				assert(isfile(".tests/writefile.txt"))
			end)
			if not requiresFileExt then
				return "This executor requires a file extension in writefile"
			end
		end)

		test("makefolder", {}, function()
			makefolder(".tests/makefolder")
			assert(isfolder(".tests/makefolder"), "Did not create the folder")
		end)

		test("appendfile", {}, function()
			writefile(".tests/appendfile.txt", "su")
			appendfile(".tests/appendfile.txt", "cce")
			appendfile(".tests/appendfile.txt", "ss")
			assert(readfile(".tests/appendfile.txt") == "success", "Did not append the file")
		end)

		test("isfile", {}, function()
			writefile(".tests/isfile.txt", "success")
			assert(isfile(".tests/isfile.txt") == true, "Did not return true for a file")
			assert(isfile(".tests") == false, "Did not return false for a folder")
			assert(isfile(".tests/doesnotexist.exe") == false, "Did not return false for a nonexistent path (got " .. tostring(isfile(".tests/doesnotexist.exe")) .. ")")
		end)

		test("isfolder", {}, function()
			assert(isfolder(".tests") == true, "Did not return false for a folder")
			assert(isfolder(".tests/doesnotexist.exe") == false, "Did not return false for a nonexistent path (got " .. tostring(isfolder(".tests/doesnotexist.exe")) .. ")")
		end)

		test("delfolder", {}, function()
			makefolder(".tests/delfolder")
			delfolder(".tests/delfolder")
			assert(isfolder(".tests/delfolder") == false, "Failed to delete folder (isfolder = " .. tostring(isfolder(".tests/delfolder")) .. ")")
		end)

		test("delfile", {}, function()
			writefile(".tests/delfile.txt", "Hello, world!")
			delfile(".tests/delfile.txt")
			assert(isfile(".tests/delfile.txt") == false, "Failed to delete file (isfile = " .. tostring(isfile(".tests/delfile.txt")) .. ")")
		end)

		test("loadfile", {}, function()
			writefile(".tests/loadfile.txt", "return ... + 1")
			assert(assert(loadfile(".tests/loadfile.txt"))(1) == 2, "Failed to load a file with arguments")
			writefile(".tests/loadfile.txt", "f")
			local callback, err = loadfile(".tests/loadfile.txt")
			assert(err and not callback, "Did not return an error message for a compiler error")
		end)

		test("dofile", {})

		-- Input

		test("isrbxactive", {"isgameactive"}, function()
			assert(type(isrbxactive()) == "boolean", "Did not return a boolean value")
		end)

		test("mouse1click", {})

		test("mouse1press", {})

		test("mouse1release", {})

		test("mouse2click", {})

		test("mouse2press", {})

		test("mouse2release", {})

		test("mousemoveabs", {})

		test("mousemoverel", {})

		test("mousescroll", {})

		-- Instances

		test("fireclickdetector", {}, function()
			local detector = Instance.new("ClickDetector")
			fireclickdetector(detector, 50, "MouseHoverEnter")
		end)

		test("getcallbackvalue", {}, function()
			local bindable = Instance.new("BindableFunction")
			local function test()
			end
			bindable.OnInvoke = test
			assert(getcallbackvalue(bindable, "OnInvoke") == test, "Did not return the correct value")
		end)

		test("getconnections", {}, function()
			local types = {
				Enabled = "boolean",
				ForeignState = "boolean",
				LuaConnection = "boolean",
				Function = "function",
				Thread = "thread",
				Fire = "function",
				Defer = "function",
				Disconnect = "function",
				Disable = "function",
				Enable = "function",
			}
			local bindable = Instance.new("BindableEvent")
			bindable.Event:Connect(function() end)
			local connection = getconnections(bindable.Event)[1]
			for k, v in pairs(types) do
				assert(connection[k] ~= nil, "Did not return a table with a '" .. k .. "' field")
				assert(type(connection[k]) == v, "Did not return a table with " .. k .. " as a " .. v .. " (got " .. type(connection[k]) .. ")")
			end
		end)

		test("getcustomasset", {}, function()
			writefile(".tests/getcustomasset.txt", "success")
			local contentId = getcustomasset(".tests/getcustomasset.txt")
			assert(type(contentId) == "string", "Did not return a string")
			assert(#contentId > 0, "Returned an empty string")
			assert(string.match(contentId, "rbxasset://") == "rbxasset://", "Did not return an rbxasset url")
		end)

		test("gethiddenproperty", {}, function()
			local fire = Instance.new("Fire")
			local property, isHidden = gethiddenproperty(fire, "size_xml")
			assert(property == 5, "Did not return the correct value")
			assert(isHidden == true, "Did not return whether the property was hidden")
		end)

		test("sethiddenproperty", {}, function()
			local fire = Instance.new("Fire")
			local hidden = sethiddenproperty(fire, "size_xml", 10)
			assert(hidden, "Did not return true for the hidden property")
			assert(gethiddenproperty(fire, "size_xml") == 10, "Did not set the hidden property")
		end)

		test("gethui", {}, function()
			assert(typeof(gethui()) == "Instance", "Did not return an Instance")
		end)

		test("getinstances", {}, function()
			assert(getinstances()[1]:IsA("Instance"), "The first value is not an Instance")
		end)

		test("getnilinstances", {}, function()
			assert(getnilinstances()[1]:IsA("Instance"), "The first value is not an Instance")
			assert(getnilinstances()[1].Parent == nil, "The first value is not parented to nil")
		end)

		test("isscriptable", {}, function()
			local fire = Instance.new("Fire")
			assert(isscriptable(fire, "size_xml") == false, "Did not return false for a non-scriptable property (size_xml)")
			assert(isscriptable(fire, "Size") == true, "Did not return true for a scriptable property (Size)")
		end)

		test("setscriptable", {}, function()
			local fire = Instance.new("Fire")
			local wasScriptable = setscriptable(fire, "size_xml", true)
			assert(wasScriptable == false, "Did not return false for a non-scriptable property (size_xml)")
			assert(isscriptable(fire, "size_xml") == true, "Did not set the scriptable property")
			fire = Instance.new("Fire")
			assert(isscriptable(fire, "size_xml") == false, "⚠️⚠️ setscriptable persists between unique instances ⚠️⚠️")
		end)

		test("setrbxclipboard", {})

		-- Metatable

		test("getrawmetatable", {}, function()
			local metatable = { __metatable = "Locked!" }
			local object = setmetatable({}, metatable)
			assert(getrawmetatable(object) == metatable, "Did not return the metatable")
		end)

		test("hookmetamethod", {}, function()
			local object = setmetatable({}, { __index = newcclosure(function() return false end), __metatable = "Locked!" })
			local ref = hookmetamethod(object, "__index", function() return true end)
			assert(object.test == true, "Failed to hook a metamethod and change the return value")
			assert(ref() == false, "Did not return the original function")
		end)

		test("getnamecallmethod", {}, function()
			local method
			local ref
			ref = hookmetamethod(game, "__namecall", function(...)
				if not method then
					method = getnamecallmethod()
				end
				return ref(...)
			end)
			game:GetService("Lighting")
			assert(method == "GetService", "Did not get the correct method (GetService)")
		end)

		test("isreadonly", {}, function()
			local object = {}
			table.freeze(object)
			assert(isreadonly(object), "Did not return true for a read-only table")
		end)

		test("setrawmetatable", {}, function()
			local object = setmetatable({}, { __index = function() return false end, __metatable = "Locked!" })
			local objectReturned = setrawmetatable(object, { __index = function() return true end })
			assert(object, "Did not return the original object")
			assert(object.test == true, "Failed to change the metatable")
			if objectReturned then
				return objectReturned == object and "Returned the original object" or "Did not return the original object"
			end
		end)

		test("setreadonly", {}, function()
			local object = { success = false }
			table.freeze(object)
			setreadonly(object, false)
			object.success = true
			assert(object.success, "Did not allow the table to be modified")
		end)

		-- Miscellaneous

		test("identifyexecutor", {"getexecutorname"}, function()
			local name, version = identifyexecutor()
			assert(type(name) == "string", "Did not return a string for the name")
			return type(version) == "string" and "Returns version as a string" or "Does not return version"
		end)

		test("lz4compress", {}, function()
			local raw = "Hello, world!"
			local compressed = lz4compress(raw)
			assert(type(compressed) == "string", "Compression did not return a string")
			assert(lz4decompress(compressed, #raw) == raw, "Decompression did not return the original string")
		end)

		test("lz4decompress", {}, function()
			local raw = "Hello, world!"
			local compressed = lz4compress(raw)
			assert(type(compressed) == "string", "Compression did not return a string")
			assert(lz4decompress(compressed, #raw) == raw, "Decompression did not return the original string")
		end)

		test("messagebox", {})

		test("queue_on_teleport", {"queueonteleport"})

		test("request", {"http.request", "http_request"}, function()
			local response = request({
				Url = "https://httpbin.org/user-agent",
				Method = "GET",
			})
			assert(type(response) == "table", "Response must be a table")
			assert(response.StatusCode == 200, "Did not return a 200 status code")
			local data = game:GetService("HttpService"):JSONDecode(response.Body)
			assert(type(data) == "table" and type(data["user-agent"]) == "string", "Did not return a table with a user-agent key")
			return "User-Agent: " .. data["user-agent"]
		end)

		test("setclipboard", {"toclipboard"})

		test("setfpscap", {}, function()
			local renderStepped = game:GetService("RunService").RenderStepped
			local function step()
				renderStepped:Wait()
				local sum = 0
				for _ = 1, 5 do
					sum += 1 / renderStepped:Wait()
				end
				return math.round(sum / 5)
			end
			setfpscap(60)
			local step60 = step()
			setfpscap(0)
			local step0 = step()
			return step60 .. "fps @60 • " .. step0 .. "fps @0"
		end)

		-- Scripts

		test("getgc", {}, function()
			local gc = getgc()
			assert(type(gc) == "table", "Did not return a table")
			assert(#gc > 0, "Did not return a table with any values")
		end)

		test("getgenv", {}, function()
			getgenv().__TEST_GLOBAL = true
			assert(__TEST_GLOBAL, "Failed to set a global variable")
			getgenv().__TEST_GLOBAL = nil
		end)

		test("getloadedmodules", {}, function()
			local modules = getloadedmodules()
			assert(type(modules) == "table", "Did not return a table")
			assert(#modules > 0, "Did not return a table with any values")
			assert(typeof(modules[1]) == "Instance", "First value is not an Instance")
			assert(modules[1]:IsA("ModuleScript"), "First value is not a ModuleScript")
		end)

		test("getrenv", {}, function()
			assert(_G ~= getrenv()._G, "The variable _G in the executor is identical to _G in the game")
		end)

		test("getrunningscripts", {}, function()
			local scripts = getrunningscripts()
			assert(type(scripts) == "table", "Did not return a table")
			assert(#scripts > 0, "Did not return a table with any values")
			assert(typeof(scripts[1]) == "Instance", "First value is not an Instance")
			assert(scripts[1]:IsA("ModuleScript") or scripts[1]:IsA("LocalScript"), "First value is not a ModuleScript or LocalScript")
		end)

		test("getscriptbytecode", {"dumpstring"}, function()
			local animate = game:GetService("Players").LocalPlayer.Character.Animate
			local bytecode = getscriptbytecode(animate)
			assert(type(bytecode) == "string", "Did not return a string for Character.Animate (a " .. animate.ClassName .. ")")
		end)

		test("getscripthash", {}, function()
			local animate = game:GetService("Players").LocalPlayer.Character.Animate:Clone()
			local hash = getscripthash(animate)
			local source = animate.Source
			animate.Source = "print('Hello, world!')"
			task.defer(function()
				animate.Source = source
			end)
			local newHash = getscripthash(animate)
			assert(hash ~= newHash, "Did not return a different hash for a modified script")
			assert(newHash == getscripthash(animate), "Did not return the same hash for a script with the same source")
		end)

		test("getscripts", {}, function()
			local scripts = getscripts()
			assert(type(scripts) == "table", "Did not return a table")
			assert(#scripts > 0, "Did not return a table with any values")
			assert(typeof(scripts[1]) == "Instance", "First value is not an Instance")
			assert(scripts[1]:IsA("ModuleScript") or scripts[1]:IsA("LocalScript"), "First value is not a ModuleScript or LocalScript")
		end)

		test("getsenv", {}, function()
			local animate = game:GetService("Players").LocalPlayer.Character.Animate
			local env = getsenv(animate)
			assert(type(env) == "table", "Did not return a table for Character.Animate (a " .. animate.ClassName .. ")")
			assert(env.script == animate, "The script global is not identical to Character.Animate")
		end)

		test("getthreadidentity", {"getidentity", "getthreadcontext"}, function()
			assert(type(getthreadidentity()) == "number", "Did not return a number")
		end)

		test("setthreadidentity", {"setidentity", "setthreadcontext"}, function()
			setthreadidentity(3)
			assert(getthreadidentity() == 3, "Did not set the thread identity")
		end)

		-- Drawing

		test("Drawing", {})

		test("Drawing.new", {}, function()
			local drawing = Drawing.new("Square")
			drawing.Visible = false
			local canDestroy = pcall(function()
				drawing:Destroy()
			end)
			assert(canDestroy, "Drawing:Destroy() should not throw an error")
		end)

		test("Drawing.Fonts", {}, function()
			assert(Drawing.Fonts.UI == 0, "Did not return the correct id for UI")
			assert(Drawing.Fonts.System == 1, "Did not return the correct id for System")
			assert(Drawing.Fonts.Plex == 2, "Did not return the correct id for Plex")
			assert(Drawing.Fonts.Monospace == 3, "Did not return the correct id for Monospace")
		end)

		test("isrenderobj", {}, function()
			local drawing = Drawing.new("Image")
			drawing.Visible = true
			assert(isrenderobj(drawing) == true, "Did not return true for an Image")
			assert(isrenderobj(newproxy()) == false, "Did not return false for a blank table")
		end)

		test("getrenderproperty", {}, function()
			local drawing = Drawing.new("Image")
			drawing.Visible = true
			assert(type(getrenderproperty(drawing, "Visible")) == "boolean", "Did not return a boolean value for Image.Visible")
			local success, result = pcall(function()
				return getrenderproperty(drawing, "Color")
			end)
			if not success or not result then
				return "Image.Color is not supported"
			end
		end)

		test("setrenderproperty", {}, function()
			local drawing = Drawing.new("Square")
			drawing.Visible = true
			setrenderproperty(drawing, "Visible", false)
			assert(drawing.Visible == false, "Did not set the value for Square.Visible")
		end)

		test("cleardrawcache", {}, function()
			cleardrawcache()
		end)

		-- WebSocket

		test("WebSocket", {})

		test("WebSocket.connect", {}, function()
			local types = {
				Send = "function",
				Close = "function",
				OnMessage = {"table", "userdata"},
				OnClose = {"table", "userdata"},
			}
			local ws = WebSocket.connect("ws://echo.websocket.events")
			assert(type(ws) == "table" or type(ws) == "userdata", "Did not return a table or userdata")
			for k, v in pairs(types) do
				if type(v) == "table" then
					assert(table.find(v, type(ws[k])), "Did not return a " .. table.concat(v, ", ") .. " for " .. k .. " (a " .. type(ws[k]) .. ")")
				else
					assert(type(ws[k]) == v, "Did not return a " .. v .. " for " .. k .. " (a " .. type(ws[k]) .. ")")
				end
			end
			ws:Close()
		end)
	elseif args[1] == "cmds" then
		cmdsframe.Visible = true
	elseif args[1] == "rejoin" then
		local PlaceId = game.PlaceId
		local Players = game:GetService("Players")
		local TeleportService = game:GetService("TeleportService")
		local JobId = game.JobId
		if #Players:GetPlayers() <= 1 then
			Players.LocalPlayer:Kick("\nRejoining...")
			wait()
			TeleportService:Teleport(PlaceId, Players.LocalPlayer)
		else
			TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
		end
	elseif args[1] == "infyield" then
		loadstring(game:HttpGet("https://raw.githubsercontent.com/EdgeIY/infiniteyield/master/source"))()
	elseif args[1] == "nameless" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
	elseif args[1] == "exit" then
		game:Shutdown()
	elseif args[1] == "noclip" then
		local speaker = game.Players.LocalPlayer
		local RunService = game:GetService("RunService")
		function randomString()
			local length = math.random(10,20)
			local array = {}
			for i = 1, length do
				array[i] = string.char(math.random(32, 126))
			end
			return table.concat(array)
		end
		local floatName = randomString()
		Clip = false
		wait(0.1)
		local function NoclipLoop()
			if Clip == false and speaker.Character ~= nil then
				for _, child in pairs(speaker.Character:GetDescendants()) do
					if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
						child.CanCollide = false
					end
				end
			end
		end
		Noclipping = RunService.Stepped:Connect(NoclipLoop)
	elseif args[1] == "destroy" then
		mainadmin:Destroy()
	elseif args[1] == "deletetool" then
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		local backpack = player:WaitForChild("Backpack")
		local mouse = player:GetMouse()

		-- Create the tool
		local tool = Instance.new("Tool")
		tool.Name = "delete"
		tool.ToolTip = ":troll:"
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = backpack

		-- Function to handle part deletion
		local function onActivated()
			local target = mouse.Target
			if target and target:IsA("BasePart") then
				target:Destroy()
			end
		end

		-- Connect the tool activation to the deletion function
		tool.Activated:Connect(onActivated)
	elseif args[1] == "respawn" then
		local plr = game.Players.LocalPlayer
		local char = plr.Character
		if char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):ChangeState(15) end
		char:ClearAllChildren()
		local newChar = Instance.new("Model")
		newChar.Parent = workspace
		plr.Character = newChar
		wait()
		plr.Character = char
		newChar:Destroy()
	elseif args[1] == "load" then
		loadstring(game:HttpGet(tostring(args[2])))()
	elseif args[1] == "telekinesis" then
		-- Q & E - bring closer and further
		-- R - Roates Block
		-- T - Tilts Block
		-- Y - Throws Block
		local function a(b, c)
			local d = getfenv(c)
			local e =
				setmetatable(
					{},
					{__index = function(self, f)
						if f == "script" then
						return b
					else
						return d[f]
					end
					end}
				)
			setfenv(c, e)
			return c
		end
		local g = {}
		local h = Instance.new("Model", game:GetService("Lighting"))
		local i = Instance.new("Tool")
		local j = Instance.new("Part")
		local k = Instance.new("Script")
		local l = Instance.new("LocalScript")
		local m = sethiddenproperty or set_hidden_property
		i.Name = "Telekinesis"
		i.Parent = h
		i.Grip = CFrame.new(0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0)
		i.GripForward = Vector3.new(-0, -1, -0)
		i.GripRight = Vector3.new(0, 0, 1)
		i.GripUp = Vector3.new(1, 0, 0)
		j.Name = "Handle"
		j.Parent = i
		j.CFrame = CFrame.new(-17.2635937, 15.4915619, 46, 0, 1, 0, 1, 0, 0, 0, 0, -1)
		j.Orientation = Vector3.new(0, 180, 90)
		j.Position = Vector3.new(-17.2635937, 15.4915619, 46)
		j.Rotation = Vector3.new(-180, 0, -90)
		j.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
		j.Transparency = 1
		j.Size = Vector3.new(1, 1.20000005, 1)
		j.BottomSurface = Enum.SurfaceType.Weld
		j.BrickColor = BrickColor.new("Really black")
		j.Material = Enum.Material.Metal
		j.TopSurface = Enum.SurfaceType.Smooth
		j.brickColor = BrickColor.new("Really black")
		k.Name = "LineConnect"
		k.Parent = i
		table.insert(
			g,
			a(
				k,
				function()
					wait()
					local n = script.Part2
					local o = script.Part1.Value
					local p = script.Part2.Value
					local q = script.Par.Value
					local color = script.Color
					local r = Instance.new("Part")
					r.TopSurface = 0
					r.BottomSurface = 0
					r.Reflectance = .5
					r.Name = "Laser"
					r.Locked = true
					r.CanCollide = false
					r.Anchored = true
					r.formFactor = 0
					r.Size = Vector3.new(1, 1, 1)
					local s = Instance.new("BlockMesh")
					s.Parent = r
					while true do
						if n.Value == nil then
							break
						end
						if o == nil or p == nil or q == nil then
							break
						end
						if o.Parent == nil or p.Parent == nil then
							break
						end
						if q.Parent == nil then
							break
						end
						local t = CFrame.new(o.Position, p.Position)
						local dist = (o.Position - p.Position).magnitude
						r.Parent = q
						r.BrickColor = color.Value.BrickColor
						r.Reflectance = color.Value.Reflectance
						r.Transparency = color.Value.Transparency
						r.CFrame = CFrame.new(o.Position + t.lookVector * dist / 2)
						r.CFrame = CFrame.new(r.Position, p.Position)
						s.Scale = Vector3.new(.25, .25, dist)
						wait()
					end
					r:remove()
					script:remove()
				end
			)
		)
		k.Disabled = true
		l.Name = "MainScript"
		l.Parent = i
		table.insert(
			g,
			a(
				l,
				function()
					wait()
					tool = script.Parent
					lineconnect = tool.LineConnect
					object = nil
					mousedown = false
					found = false
					BP = Instance.new("BodyPosition")
					BP.maxForce = Vector3.new(math.huge * math.huge, math.huge * math.huge, math.huge * math.huge)
					BP.P = BP.P * 1.1
					dist = nil
					point = Instance.new("Part")
					point.Locked = true
					point.Anchored = true
					point.formFactor = 0
					point.Shape = 0
					point.BrickColor = BrickColor.Black()
					point.Size = Vector3.new(1, 1, 1)
					point.CanCollide = false
					local s = Instance.new("SpecialMesh")
					s.MeshType = "Sphere"
					s.Scale = Vector3.new(.7, .7, .7)
					s.Parent = point
					handle = tool.Handle
					front = tool.Handle
					color = tool.Handle
					objval = nil
					local u = false
					local v = BP:clone()
					v.maxForce = Vector3.new(30000, 30000, 30000)
					function LineConnect(o, p, q)
						local w = Instance.new("ObjectValue")
						w.Value = o
						w.Name = "Part1"
						local x = Instance.new("ObjectValue")
						x.Value = p
						x.Name = "Part2"
						local y = Instance.new("ObjectValue")
						y.Value = q
						y.Name = "Par"
						local z = Instance.new("ObjectValue")
						z.Value = color
						z.Name = "Color"
						local A = lineconnect:clone()
						A.Disabled = false
						w.Parent = A
						x.Parent = A
						y.Parent = A
						z.Parent = A
						A.Parent = workspace
						if p == object then
							objval = x
						end
					end
					function onButton1Down(B)
						if mousedown == true then
							return
						end
						mousedown = true
						coroutine.resume(
							coroutine.create(
								function()
									local C = point:clone()
									C.Parent = tool
									LineConnect(front, C, workspace)
									while mousedown == true do
										C.Parent = tool
										if object == nil then
											if B.Target == nil then
												local t = CFrame.new(front.Position, B.Hit.p)
												C.CFrame = CFrame.new(front.Position + t.lookVector * 1000)
											else
												C.CFrame = CFrame.new(B.Hit.p)
											end
										else
											LineConnect(front, object, workspace)
											break
										end
										wait()
									end
									C:remove()
								end
							)
						)
						while mousedown == true do
							if B.Target ~= nil then
								local D = B.Target
								if D.Anchored == false then
									object = D
									dist = (object.Position - front.Position).magnitude
									break
								end
							end
							wait()
						end
						while mousedown == true do
							if object.Parent == nil then
								break
							end
							local t = CFrame.new(front.Position, B.Hit.p)
							BP.Parent = object
							BP.position = front.Position + t.lookVector * dist
							wait()
						end
						BP:remove()
						object = nil
						objval.Value = nil
					end
					function onKeyDown(E, B)
						local E = E:lower()
						local F = false
						if E == "q" then
							if dist >= 5 then
								dist = dist - 10
							end
						end
						if E == "r" then
							if object == nil then
								return
							end
							for G, H in pairs(object:children()) do
								if H.className == "BodyGyro" then
									return nil
								end
							end
							BG = Instance.new("BodyGyro")
							BG.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
							BG.cframe = CFrame.new(object.CFrame.p)
							BG.Parent = object
							repeat
								wait()
							until object.CFrame == CFrame.new(object.CFrame.p)
							BG.Parent = nil
							if object == nil then
								return
							end
							for G, H in pairs(object:children()) do
								if H.className == "BodyGyro" then
									H.Parent = nil
								end
							end
							object.Velocity = Vector3.new(0, 0, 0)
							object.RotVelocity = Vector3.new(0, 0, 0)
							object.Orientation = Vector3.new(0, 0, 0)
						end
						if E == "e" then
							dist = dist + 10
						end
						if E == "t" then
							if dist ~= 10 then
								dist = 10
							end
						end
						if E == "y" then
							if dist ~= 200 then
								dist = 200
							end
						end
						if E == "=" then
							BP.P = BP.P * 1.5
						end
						if E == "-" then
							BP.P = BP.P * 0.5
						end
					end
					function onEquipped(B)
						keymouse = B
						local I = tool.Parent
						human = I.Humanoid
						human.Changed:connect(
							function()
								if human.Health == 0 then
									mousedown = false
									BP:remove()
									point:remove()
									tool:remove()
								end
							end
						)
						B.Button1Down:connect(
							function()
								onButton1Down(B)
							end
						)
						B.Button1Up:connect(
							function()
								mousedown = false
							end
						)
						B.KeyDown:connect(
							function(E)
								onKeyDown(E, B)
							end
						)
						B.Icon = "rbxasset://textures\\GunCursor.png"
					end
					tool.Equipped:connect(onEquipped)
				end
			)
		)
		for J, H in pairs(h:GetChildren()) do
			H.Parent = game:GetService("Players").LocalPlayer.Backpack
			pcall(
				function()
					H:MakeJoints()
				end
			)
		end
		h:Destroy()
		for J, H in pairs(g) do
			spawn(
				function()
					pcall(H)
				end
			)
		end
	elseif args[1] == "savegame" then
		saveinstance()
	elseif args[1] == "to" then
		local Players = game.Players
		local otherplr = Players:FindFirstChild(tostring(args[2]))
		local speaker = Players.LocalPlayer
		local players = Players:GetPlayers()
		function getRoot(char)
			local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
			return rootPart
		end
		for i,v in pairs(players) do
			if Players[v].Character ~= nil then
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
					wait(.1)
				end
				getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3,1,0)
			end
		end
	elseif args[1] == "swim" then
		swimming = false
		local oldgrav = workspace.Gravity
		local swimbeat = nil
		local speaker = game.Players.LocalPlayer
		local RunService = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		if not swimming and speaker and speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
			oldgrav = workspace.Gravity
			workspace.Gravity = 0
			local swimDied = function()
				workspace.Gravity = oldgrav
				swimming = false
			end
			local Humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			gravReset = Humanoid.Died:Connect(swimDied)
			local enums = Enum.HumanoidStateType:GetEnumItems()
			table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
			for i, v in pairs(enums) do
				Humanoid:SetStateEnabled(v, false)
			end
			Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
			swimbeat = RunService.Heartbeat:Connect(function()
				pcall(function()
					speaker.Character.HumanoidRootPart.Velocity = ((Humanoid.MoveDirection ~= Vector3.new() or UserInputService:IsKeyDown(Enum.KeyCode.Space)) and speaker.Character.HumanoidRootPart.Velocity or Vector3.new())
				end)
			end)
			swimming = true
		end
	elseif args[1] == "nolag" then
		local Terrain = workspace:FindFirstChildOfClass('Terrain')
		local Lighting = game.Lighting
		local RunService = game:GetService("RunService")
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		settings().Rendering.QualityLevel = 1
		for i,v in pairs(game:GetDescendants()) do
			if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
				v.Material = "Plastic"
				v.Reflectance = 0
			elseif v:IsA("Decal") then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)
			elseif v:IsA("Explosion") then
				v.BlastPressure = 1
				v.BlastRadius = 1
			end
		end
		for i,v in pairs(Lighting:GetDescendants()) do
			if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
				v.Enabled = false
			end
		end
		workspace.DescendantAdded:Connect(function(child)
			task.spawn(function()
				if child:IsA('ForceField') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				elseif child:IsA('Sparkles') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				elseif child:IsA('Smoke') or child:IsA('Fire') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				end
			end)
		end)
	end
end)
