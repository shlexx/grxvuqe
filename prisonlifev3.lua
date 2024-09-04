if not getgenv then
	print("The script doesn't work on your executor.")
end

function giverfunc(giv)
	local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	getgenv().op = hrp.CFrame
	hrp.CFrame = giver.CFrame
	task.wait(.1)
	game.ReplicatedStorage.Events.Interact:InvokeServer(giver,"GetTool")
	task.wait(.1)
	hrp.CFrame = getgenv().op
	task.wait(.1)
	hrp.Parent.Humanoid.PlatformStand = false
end

local prefix = "."
local speedlooped = false
local jumppowerlooped = false
local hostileesp = false
local teamesp = false
local noclipping = false
local floatName
getgenv().oldws = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed

local MainCmds = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonHolder = Instance.new("Frame")
local Close = Instance.new("ImageButton")
local Minimize = Instance.new("ImageButton")
local Input = Instance.new("TextBox")
local Execute = Instance.new("TextButton")
local Open = Instance.new("ImageButton")
local CommandsFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local CMD = Instance.new("TextLabel")
local CMD_2 = Instance.new("TextLabel")
local CMD_3 = Instance.new("TextLabel")
local CMD_4 = Instance.new("TextLabel")
local CMD_5 = Instance.new("TextLabel")
local CMD_6 = Instance.new("TextLabel")
local CMD_7 = Instance.new("TextLabel")
local CMD_8 = Instance.new("TextLabel")
local CMD_9 = Instance.new("TextLabel")
local CMD_10 = Instance.new("TextLabel")
local CMD_11 = Instance.new("TextLabel")
local CMD_12 = Instance.new("TextLabel")
local CMD_13 = Instance.new("TextLabel")
local CMD_14 = Instance.new("TextLabel")
local CMD_15 = Instance.new("TextLabel")
local CMD_16 = Instance.new("TextLabel")
local CMD_17 = Instance.new("TextLabel")
local CMD_18 = Instance.new("TextLabel")
local CMD_19 = Instance.new("TextLabel")
local CMD_20 = Instance.new("TextLabel")
local CMD_21 = Instance.new("TextLabel")
local CMD_22 = Instance.new("TextLabel")
local CMD_23 = Instance.new("TextLabel")
local CMD_24 = Instance.new("TextLabel")
local CMD_25 = Instance.new("TextLabel")
local CMD_26 = Instance.new("TextLabel")
local CMD_27 = Instance.new("TextLabel")
local CMD_28 = Instance.new("TextLabel")
local CMD_29 = Instance.new("TextLabel")
local CMD_30 = Instance.new("TextLabel")
local CMD_31 = Instance.new("TextLabel")
local CMD_32 = Instance.new("TextLabel")
local CMD_33 = Instance.new("TextLabel")
local CMD_34 = Instance.new("TextLabel")
local CMD_35 = Instance.new("TextLabel")
local CMD_36 = Instance.new("TextLabel")
local CMD_37 = Instance.new("TextLabel")
local CMD_38 = Instance.new("TextLabel")
local CMD_39 = Instance.new("TextLabel")
local CMD_40 = Instance.new("TextLabel")
local CMD_41 = Instance.new("TextLabel")
local UIStroke = Instance.new("UIStroke")
local UIStroke_2 = Instance.new("UIStroke")
local UIStroke_3 = Instance.new("UIStroke")
local UIStroke_4 = Instance.new("UIStroke")
local UIStroke_5 = Instance.new("UIStroke")
local UIStroke_6 = Instance.new("UIStroke")
MainCmds.Name = "MainCmds"
MainCmds.Parent = game.CoreGui
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainCmds
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3931624, 0, 0.370801032, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
ButtonHolder.Name = "ButtonHolder"
ButtonHolder.Parent = MainFrame
ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonHolder.BackgroundTransparency = 1.000
ButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtonHolder.BorderSizePixel = 0
ButtonHolder.Position = UDim2.new(0.866666675, 0, 0, 0)
ButtonHolder.Size = UDim2.new(0, 40, 0, 20)
Close.Name = "Close"
Close.Parent = ButtonHolder
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundTransparency = 1.000
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.5, 0, 0, 0)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Image = "rbxassetid://10747384394"
Minimize.Name = "Minimize"
Minimize.Parent = ButtonHolder
Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Minimize.BackgroundTransparency = 1.000
Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
Minimize.BorderSizePixel = 0
Minimize.Size = UDim2.new(0, 20, 0, 20)
Minimize.Image = "rbxassetid://10734896206"
Input.Name = "Input"
Input.Parent = MainFrame
Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Input.BackgroundTransparency = 1.000
Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
Input.BorderSizePixel = 0
Input.Position = UDim2.new(0.0666666701, 0, 0.25, 0)
Input.Size = UDim2.new(0, 260, 0, 50)
Input.Font = Enum.Font.FredokaOne
Input.PlaceholderText = "input command here"
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextSize = 24.000
Execute.Name = "Execute"
Execute.Parent = MainFrame
Execute.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Execute.BackgroundTransparency = 1.000
Execute.BorderColor3 = Color3.fromRGB(0, 0, 0)
Execute.BorderSizePixel = 0
Execute.Position = UDim2.new(0.0666666701, 0, 0.625, 0)
Execute.Size = UDim2.new(0, 260, 0, 50)
Execute.Font = Enum.Font.FredokaOne
Execute.Text = "execute!"
Execute.TextColor3 = Color3.fromRGB(255, 255, 255)
Execute.TextSize = 24.000
Open.Name = "Open"
Open.Parent = MainCmds
Open.AnchorPoint = Vector2.new(0, 1)
Open.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Open.BorderColor3 = Color3.fromRGB(0, 0, 0)
Open.BorderSizePixel = 0
Open.Position = UDim2.new(0, 0, 1, 0)
Open.Size = UDim2.new(0, 50, 0, 50)
Open.Visible = false
Open.Image = "rbxassetid://10709813281"
CommandsFrame.Name = "CommandsFrame"
CommandsFrame.Parent = MainCmds
CommandsFrame.Active = true
CommandsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CommandsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
CommandsFrame.BorderSizePixel = 0
CommandsFrame.Position = UDim2.new(0.7236467, 0, 0.467700273, 0)
CommandsFrame.Size = UDim2.new(0, 200, 0, 250)
CommandsFrame.Visible = false
CommandsFrame.CanvasPosition = Vector2.new(0, 150)
UIListLayout.Parent = CommandsFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
CMD.Name = "CMD"
CMD.Parent = CommandsFrame
CMD.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD.BackgroundTransparency = 1.000
CMD.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD.BorderSizePixel = 0
CMD.Size = UDim2.new(0, 200, 0, 20)
CMD.Font = Enum.Font.FredokaOne
CMD.Text = "  cmds"
CMD.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD.TextSize = 14.000
CMD.TextXAlignment = Enum.TextXAlignment.Left
CMD_2.Name = "CMD"
CMD_2.Parent = CommandsFrame
CMD_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_2.BackgroundTransparency = 1.000
CMD_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_2.BorderSizePixel = 0
CMD_2.Size = UDim2.new(0, 200, 0, 20)
CMD_2.Font = Enum.Font.FredokaOne
CMD_2.Text = "  arrest <player> (police)"
CMD_2.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_2.TextSize = 14.000
CMD_2.TextXAlignment = Enum.TextXAlignment.Left
CMD_3.Name = "CMD"
CMD_3.Parent = CommandsFrame
CMD_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_3.BackgroundTransparency = 1.000
CMD_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_3.BorderSizePixel = 0
CMD_3.Size = UDim2.new(0, 200, 0, 20)
CMD_3.Font = Enum.Font.FredokaOne
CMD_3.Text = "  escape"
CMD_3.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_3.TextSize = 14.000
CMD_3.TextXAlignment = Enum.TextXAlignment.Left
CMD_4.Name = "CMD"
CMD_4.Parent = CommandsFrame
CMD_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_4.BackgroundTransparency = 1.000
CMD_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_4.BorderSizePixel = 0
CMD_4.Size = UDim2.new(0, 200, 0, 20)
CMD_4.Font = Enum.Font.FredokaOne
CMD_4.Text = "  ak47"
CMD_4.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_4.TextSize = 14.000
CMD_4.TextXAlignment = Enum.TextXAlignment.Left
CMD_5.Name = "CMD"
CMD_5.Parent = CommandsFrame
CMD_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_5.BackgroundTransparency = 1.000
CMD_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_5.BorderSizePixel = 0
CMD_5.Size = UDim2.new(0, 200, 0, 20)
CMD_5.Font = Enum.Font.FredokaOne
CMD_5.Text = "  db"
CMD_5.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_5.TextSize = 14.000
CMD_5.TextXAlignment = Enum.TextXAlignment.Left
CMD_6.Name = "CMD"
CMD_6.Parent = CommandsFrame
CMD_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_6.BackgroundTransparency = 1.000
CMD_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_6.BorderSizePixel = 0
CMD_6.Size = UDim2.new(0, 200, 0, 20)
CMD_6.Font = Enum.Font.FredokaOne
CMD_6.Text = "  glock17"
CMD_6.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_6.TextSize = 14.000
CMD_6.TextXAlignment = Enum.TextXAlignment.Left
CMD_7.Name = "CMD"
CMD_7.Parent = CommandsFrame
CMD_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_7.BackgroundTransparency = 1.000
CMD_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_7.BorderSizePixel = 0
CMD_7.Size = UDim2.new(0, 200, 0, 20)
CMD_7.Font = Enum.Font.FredokaOne
CMD_7.Text = "  m82"
CMD_7.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_7.TextSize = 14.000
CMD_7.TextXAlignment = Enum.TextXAlignment.Left
CMD_8.Name = "CMD"
CMD_8.Parent = CommandsFrame
CMD_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_8.BackgroundTransparency = 1.000
CMD_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_8.BorderSizePixel = 0
CMD_8.Size = UDim2.new(0, 200, 0, 20)
CMD_8.Font = Enum.Font.FredokaOne
CMD_8.Text = "  m9"
CMD_8.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_8.TextSize = 14.000
CMD_8.TextXAlignment = Enum.TextXAlignment.Left
CMD_9.Name = "CMD"
CMD_9.Parent = CommandsFrame
CMD_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_9.BackgroundTransparency = 1.000
CMD_9.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_9.BorderSizePixel = 0
CMD_9.Size = UDim2.new(0, 200, 0, 20)
CMD_9.Font = Enum.Font.FredokaOne
CMD_9.Text = "  medkit"
CMD_9.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_9.TextSize = 14.000
CMD_9.TextXAlignment = Enum.TextXAlignment.Left
CMD_10.Name = "CMD"
CMD_10.Parent = CommandsFrame
CMD_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_10.BackgroundTransparency = 1.000
CMD_10.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_10.BorderSizePixel = 0
CMD_10.Size = UDim2.new(0, 200, 0, 20)
CMD_10.Font = Enum.Font.FredokaOne
CMD_10.Text = "  remington870"
CMD_10.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_10.TextSize = 14.000
CMD_10.TextXAlignment = Enum.TextXAlignment.Left
CMD_11.Name = "CMD"
CMD_11.Parent = CommandsFrame
CMD_11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_11.BackgroundTransparency = 1.000
CMD_11.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_11.BorderSizePixel = 0
CMD_11.Size = UDim2.new(0, 200, 0, 20)
CMD_11.Font = Enum.Font.FredokaOne
CMD_11.Text = "  hk416"
CMD_11.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_11.TextSize = 14.000
CMD_11.TextXAlignment = Enum.TextXAlignment.Left
CMD_12.Name = "CMD"
CMD_12.Parent = CommandsFrame
CMD_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_12.BackgroundTransparency = 1.000
CMD_12.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_12.BorderSizePixel = 0
CMD_12.Size = UDim2.new(0, 200, 0, 20)
CMD_12.Font = Enum.Font.FredokaOne
CMD_12.Text = "  remington700 (level 4 required)"
CMD_12.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_12.TextSize = 14.000
CMD_12.TextXAlignment = Enum.TextXAlignment.Left
CMD_13.Name = "CMD"
CMD_13.Parent = CommandsFrame
CMD_13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_13.BackgroundTransparency = 1.000
CMD_13.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_13.BorderSizePixel = 0
CMD_13.Size = UDim2.new(0, 200, 0, 20)
CMD_13.Font = Enum.Font.FredokaOne
CMD_13.Text = "  scar (level 2 required)"
CMD_13.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_13.TextSize = 14.000
CMD_13.TextXAlignment = Enum.TextXAlignment.Left
CMD_14.Name = "CMD"
CMD_14.Parent = CommandsFrame
CMD_14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_14.BackgroundTransparency = 1.000
CMD_14.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_14.BorderSizePixel = 0
CMD_14.Size = UDim2.new(0, 200, 0, 20)
CMD_14.Font = Enum.Font.FredokaOne
CMD_14.Text = "  spas12 (level 2 required)"
CMD_14.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_14.TextSize = 14.000
CMD_14.TextXAlignment = Enum.TextXAlignment.Left
CMD_15.Name = "CMD"
CMD_15.Parent = CommandsFrame
CMD_15.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_15.BackgroundTransparency = 1.000
CMD_15.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_15.BorderSizePixel = 0
CMD_15.Size = UDim2.new(0, 200, 0, 20)
CMD_15.Font = Enum.Font.FredokaOne
CMD_15.Text = "  uzi"
CMD_15.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_15.TextSize = 14.000
CMD_15.TextXAlignment = Enum.TextXAlignment.Left
CMD_16.Name = "CMD"
CMD_16.Parent = CommandsFrame
CMD_16.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_16.BackgroundTransparency = 1.000
CMD_16.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_16.BorderSizePixel = 0
CMD_16.Size = UDim2.new(0, 200, 0, 20)
CMD_16.Font = Enum.Font.FredokaOne
CMD_16.Text = "  hammer (if exists) (prisoner)"
CMD_16.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_16.TextSize = 14.000
CMD_16.TextXAlignment = Enum.TextXAlignment.Left
CMD_17.Name = "CMD"
CMD_17.Parent = CommandsFrame
CMD_17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_17.BackgroundTransparency = 1.000
CMD_17.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_17.BorderSizePixel = 0
CMD_17.Size = UDim2.new(0, 200, 0, 20)
CMD_17.Font = Enum.Font.FredokaOne
CMD_17.Text = "  redguitar (if exists) (prisoner)"
CMD_17.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_17.TextSize = 14.000
CMD_17.TextXAlignment = Enum.TextXAlignment.Left
CMD_18.Name = "CMD"
CMD_18.Parent = CommandsFrame
CMD_18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_18.BackgroundTransparency = 1.000
CMD_18.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_18.BorderSizePixel = 0
CMD_18.Size = UDim2.new(0, 200, 0, 20)
CMD_18.Font = Enum.Font.FredokaOne
CMD_18.Text = "  spoofkillstreak <number>"
CMD_18.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_18.TextSize = 14.000
CMD_18.TextXAlignment = Enum.TextXAlignment.Left
CMD_19.Name = "CMD"
CMD_19.Parent = CommandsFrame
CMD_19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_19.BackgroundTransparency = 1.000
CMD_19.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_19.BorderSizePixel = 0
CMD_19.Size = UDim2.new(0, 200, 0, 20)
CMD_19.Font = Enum.Font.FredokaOne
CMD_19.Text = "  loopspeed <number>"
CMD_19.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_19.TextSize = 14.000
CMD_19.TextXAlignment = Enum.TextXAlignment.Left
CMD_20.Name = "CMD"
CMD_20.Parent = CommandsFrame
CMD_20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_20.BackgroundTransparency = 1.000
CMD_20.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_20.BorderSizePixel = 0
CMD_20.Size = UDim2.new(0, 200, 0, 20)
CMD_20.Font = Enum.Font.FredokaOne
CMD_20.Text = "  loopjumppower <number>"
CMD_20.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_20.TextSize = 14.000
CMD_20.TextXAlignment = Enum.TextXAlignment.Left
CMD_21.Name = "CMD"
CMD_21.Parent = CommandsFrame
CMD_21.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_21.BackgroundTransparency = 1.000
CMD_21.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_21.BorderSizePixel = 0
CMD_21.Size = UDim2.new(0, 200, 0, 20)
CMD_21.Font = Enum.Font.FredokaOne
CMD_21.Text = "  craftingitem <name>"
CMD_21.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_21.TextSize = 14.000
CMD_21.TextXAlignment = Enum.TextXAlignment.Left
CMD_22.Name = "CMD"
CMD_22.Parent = CommandsFrame
CMD_22.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_22.BackgroundTransparency = 1.000
CMD_22.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_22.BorderSizePixel = 0
CMD_22.Size = UDim2.new(0, 200, 0, 20)
CMD_22.Font = Enum.Font.FredokaOne
CMD_22.Text = "  guardspawn"
CMD_22.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_22.TextSize = 14.000
CMD_22.TextXAlignment = Enum.TextXAlignment.Left
CMD_23.Name = "CMD"
CMD_23.Parent = CommandsFrame
CMD_23.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_23.BackgroundTransparency = 1.000
CMD_23.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_23.BorderSizePixel = 0
CMD_23.Size = UDim2.new(0, 200, 0, 20)
CMD_23.Font = Enum.Font.FredokaOne
CMD_23.Text = "  wardenspawn"
CMD_23.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_23.TextSize = 14.000
CMD_23.TextXAlignment = Enum.TextXAlignment.Left
CMD_24.Name = "CMD"
CMD_24.Parent = CommandsFrame
CMD_24.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_24.BackgroundTransparency = 1.000
CMD_24.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_24.BorderSizePixel = 0
CMD_24.Size = UDim2.new(0, 200, 0, 20)
CMD_24.Font = Enum.Font.FredokaOne
CMD_24.Text = "  prisonerspawn"
CMD_24.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_24.TextSize = 14.000
CMD_24.TextXAlignment = Enum.TextXAlignment.Left
CMD_25.Name = "CMD"
CMD_25.Parent = CommandsFrame
CMD_25.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_25.BackgroundTransparency = 1.000
CMD_25.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_25.BorderSizePixel = 0
CMD_25.Size = UDim2.new(0, 200, 0, 20)
CMD_25.Font = Enum.Font.FredokaOne
CMD_25.Text = "  criminalspawn"
CMD_25.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_25.TextSize = 14.000
CMD_25.TextXAlignment = Enum.TextXAlignment.Left
CMD_26.Name = "CMD"
CMD_26.Parent = CommandsFrame
CMD_26.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_26.BackgroundTransparency = 1.000
CMD_26.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_26.BorderSizePixel = 0
CMD_26.Size = UDim2.new(0, 200, 0, 20)
CMD_26.Font = Enum.Font.FredokaOne
CMD_26.Text = "  neutralspawn"
CMD_26.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_26.TextSize = 14.000
CMD_26.TextXAlignment = Enum.TextXAlignment.Left
CMD_27.Name = "CMD"
CMD_27.Parent = CommandsFrame
CMD_27.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_27.BackgroundTransparency = 1.000
CMD_27.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_27.BorderSizePixel = 0
CMD_27.Size = UDim2.new(0, 200, 0, 20)
CMD_27.Font = Enum.Font.FredokaOne
CMD_27.Text = "  hostileesp"
CMD_27.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_27.TextSize = 14.000
CMD_27.TextXAlignment = Enum.TextXAlignment.Left
CMD_28.Name = "CMD"
CMD_28.Parent = CommandsFrame
CMD_28.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_28.BackgroundTransparency = 1.000
CMD_28.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_28.BorderSizePixel = 0
CMD_28.Size = UDim2.new(0, 200, 0, 20)
CMD_28.Font = Enum.Font.FredokaOne
CMD_28.Text = "  unhostileesp"
CMD_28.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_28.TextSize = 14.000
CMD_28.TextXAlignment = Enum.TextXAlignment.Left
CMD_29.Name = "CMD"
CMD_29.Parent = CommandsFrame
CMD_29.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_29.BackgroundTransparency = 1.000
CMD_29.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_29.BorderSizePixel = 0
CMD_29.Size = UDim2.new(0, 200, 0, 20)
CMD_29.Font = Enum.Font.FredokaOne
CMD_29.Text = "  craft <name>"
CMD_29.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_29.TextSize = 14.000
CMD_29.TextXAlignment = Enum.TextXAlignment.Left
CMD_30.Name = "CMD"
CMD_30.Parent = CommandsFrame
CMD_30.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_30.BackgroundTransparency = 1.000
CMD_30.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_30.BorderSizePixel = 0
CMD_30.Size = UDim2.new(0, 200, 0, 20)
CMD_30.Font = Enum.Font.FredokaOne
CMD_30.Text = "  spoofkills <number>"
CMD_30.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_30.TextSize = 14.000
CMD_30.TextXAlignment = Enum.TextXAlignment.Left
CMD_31.Name = "CMD"
CMD_31.Parent = CommandsFrame
CMD_31.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_31.BackgroundTransparency = 1.000
CMD_31.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_31.BorderSizePixel = 0
CMD_31.Size = UDim2.new(0, 200, 0, 20)
CMD_31.Font = Enum.Font.FredokaOne
CMD_31.Text = "  spoofarrests <number>"
CMD_31.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_31.TextSize = 14.000
CMD_31.TextXAlignment = Enum.TextXAlignment.Left
CMD_32.Name = "CMD"
CMD_32.Parent = CommandsFrame
CMD_32.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_32.BackgroundTransparency = 1.000
CMD_32.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_32.BorderSizePixel = 0
CMD_32.Size = UDim2.new(0, 200, 0, 20)
CMD_32.Font = Enum.Font.FredokaOne
CMD_32.Text = "  closecmds"
CMD_32.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_32.TextSize = 14.000
CMD_32.TextXAlignment = Enum.TextXAlignment.Left
CMD_33.Name = "CMD"
CMD_33.Parent = CommandsFrame
CMD_33.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_33.BackgroundTransparency = 1.000
CMD_33.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_33.BorderSizePixel = 0
CMD_33.Size = UDim2.new(0, 200, 0, 20)
CMD_33.Font = Enum.Font.FredokaOne
CMD_33.Text = "  aug (police)"
CMD_33.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_33.TextSize = 14.000
CMD_33.TextXAlignment = Enum.TextXAlignment.Left
CMD_34.Name = "CMD"
CMD_34.Parent = CommandsFrame
CMD_34.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_34.BackgroundTransparency = 1.000
CMD_34.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_34.BorderSizePixel = 0
CMD_34.Size = UDim2.new(0, 200, 0, 20)
CMD_34.Font = Enum.Font.FredokaOne
CMD_34.Text = "  teamesp"
CMD_34.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_34.TextSize = 14.000
CMD_34.TextXAlignment = Enum.TextXAlignment.Left
CMD_35.Name = "CMD"
CMD_35.Parent = CommandsFrame
CMD_35.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_35.BackgroundTransparency = 1.000
CMD_35.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_35.BorderSizePixel = 0
CMD_35.Size = UDim2.new(0, 200, 0, 20)
CMD_35.Font = Enum.Font.FredokaOne
CMD_35.Text = "  unteamesp"
CMD_35.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_35.TextSize = 14.000
CMD_35.TextXAlignment = Enum.TextXAlignment.Left
CMD_36.Name = "CMD"
CMD_36.Parent = CommandsFrame
CMD_36.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_36.BackgroundTransparency = 1.000
CMD_36.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_36.BorderSizePixel = 0
CMD_36.Size = UDim2.new(0, 200, 0, 20)
CMD_36.Font = Enum.Font.FredokaOne
CMD_36.Text = "  infiniteyield"
CMD_36.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_36.TextSize = 14.000
CMD_36.TextXAlignment = Enum.TextXAlignment.Left
CMD_37.Name = "CMD"
CMD_37.Parent = CommandsFrame
CMD_37.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_37.BackgroundTransparency = 1.000
CMD_37.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_37.BorderSizePixel = 0
CMD_37.Size = UDim2.new(0, 200, 0, 20)
CMD_37.Font = Enum.Font.FredokaOne
CMD_37.Text = "  view <player>"
CMD_37.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_37.TextSize = 14.000
CMD_37.TextXAlignment = Enum.TextXAlignment.Left
CMD_38.Name = "CMD"
CMD_38.Parent = CommandsFrame
CMD_38.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_38.BackgroundTransparency = 1.000
CMD_38.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_38.BorderSizePixel = 0
CMD_38.Size = UDim2.new(0, 200, 0, 20)
CMD_38.Font = Enum.Font.FredokaOne
CMD_38.Text = "  unview <player>"
CMD_38.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_38.TextSize = 14.000
CMD_38.TextXAlignment = Enum.TextXAlignment.Left
CMD_39.Name = "CMD"
CMD_39.Parent = CommandsFrame
CMD_39.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_39.BackgroundTransparency = 1.000
CMD_39.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_39.BorderSizePixel = 0
CMD_39.Size = UDim2.new(0, 200, 0, 20)
CMD_39.Font = Enum.Font.FredokaOne
CMD_39.Text = "  noclip"
CMD_39.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_39.TextSize = 14.000
CMD_39.TextXAlignment = Enum.TextXAlignment.Left
CMD_40.Name = "CMD"
CMD_40.Parent = CommandsFrame
CMD_40.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_40.BackgroundTransparency = 1.000
CMD_40.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_40.BorderSizePixel = 0
CMD_40.Size = UDim2.new(0, 200, 0, 20)
CMD_40.Font = Enum.Font.FredokaOne
CMD_40.Text = "  clip"
CMD_40.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_40.TextSize = 14.000
CMD_40.TextXAlignment = Enum.TextXAlignment.Left
CMD_41.Name = "CMD"
CMD_41.Parent = CommandsFrame
CMD_41.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMD_41.BackgroundTransparency = 1.000
CMD_41.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMD_41.BorderSizePixel = 0
CMD_41.Size = UDim2.new(0, 200, 0, 20)
CMD_41.Font = Enum.Font.FredokaOne
CMD_41.Text = "  removedoors"
CMD_41.TextColor3 = Color3.fromRGB(255, 255, 255)
CMD_41.TextSize = 14.000
CMD_41.TextXAlignment = Enum.TextXAlignment.Left
UIStroke.Parent = MainFrame
UIStroke.Thickness = 6
UIStroke_2.Parent = MainFrame
UIStroke_2.Thickness = 6
UIStroke_3.Parent = MainFrame
UIStroke_3.Thickness = 6
UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_4.Parent = MainFrame
UIStroke_4.Thickness = 6
UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_5.Parent = MainFrame
UIStroke_5.Thickness = 6
UIStroke_6.Parent = MainFrame
UIStroke_6.Thickness = 6

local UserInputService = game:GetService("UserInputService")
local runService = (game:GetService("RunService"));
local dragging
local dragInput
local dragStart
local startPos

local gui = MainFrame

local function Lerp(a, b, m)
	return a + (b - a) * m
end;

local lastMousePos
local lastGoalPos
local DRAG_SPEED = (8); -- // The speed of the UI drag.
local function Update(dt)
	if not (startPos) then return end;
	if not (dragging) and (lastGoalPos) then
		gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
		return 
	end;

	local delta = (lastMousePos - UserInputService:GetMouseLocation())
	local xGoal = (startPos.X.Offset - delta.X);
	local yGoal = (startPos.Y.Offset - delta.Y);
	lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
	gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
end;

gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Position
		lastMousePos = UserInputService:GetMouseLocation()

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

gui.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

runService.Heartbeat:Connect(Update)

Close.MouseButton1Click:Connect(function()
	MainCmds:Destroy()
end)

Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	Open.Visible = true
end)

Open.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	Open.Visible = false
end)

Execute.MouseButton1Click:Connect(function()
	local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local command = Input.Text
	local args = command:split(" ")
	if command == prefix .. "cmds" then
		CommandsFrame.Visible = true
	elseif args[1] == prefix .. "arrest" then
		game.ReplicatedStorage.Events.Arrest:InvokeServer(game.Players:FindFirstChild(tostring(args[2])))
	elseif command == prefix .. "escape" then
		hrp.CFrame = workspace["NEUTRAL SPAWNLOCATIONS"].SpawnLocation.CFrame
		wait(.25)
		game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
	elseif command == prefix .. "ak47" then
		local giver = workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP
		giverfunc(giver)
	elseif command == prefix .. "db" then
		local giver = workspace.Prison_ITEMS.giver.DB.Part
		giverfunc(giver)
	elseif command == prefix .. "glock17" then
		local giver = workspace.Prison_ITEMS.giver["Glock-17"].ITEMPICKUP
		giverfunc(giver)
	elseif command == prefix .. "m82" then
		local giver = workspace.Prison_ITEMS.giver.M82.ITEMPICKUP
		giverfunc(giver)
	elseif command == prefix .. "m9" then
		local giver = workspace.Prison_ITEMS.giver.M9.ITEMPICKUP
		giverfunc(giver)
	elseif command == prefix .. "medkit" then
		local giver = workspace.Prison_ITEMS.giver.Medkit.ITEMPICKUP
		giverfunc(giver)
	elseif command == prefix .. "remington870" then
		local giver = workspace.Prison_ITEMS.giver["Remington 870"].Part
		giverfunc(giver)
	elseif command == prefix .. "hk416" then
		local giver = workspace.Prison_ITEMS.giver.HK416.Part
		giverfunc(giver)
	elseif command == prefix .. "remington700" then
		local giver = workspace.Prison_ITEMS.giver["Remington 700"].Part
		giverfunc(giver)
	elseif command == prefix .. "scar" then
		local giver = workspace.Prison_ITEMS.giver.SCAR.ITEMPICKUP
		giverfunc(giver)
	elseif command == prefix .. "spas12" then
		local giver = workspace.Prison_ITEMS.giver["SPAS-12"].ITEMPICKUP
		giverfunc(giver)
	elseif command == prefix .. "uzi" then
		local giver = workspace.Prison_ITEMS.giver.UZI.Part
		giverfunc(giver)
	elseif command == prefix .. "hammer" then
		-- UNFINISHED
	elseif command == prefix .. "redguitar" then
		-- UNFINISHED
	elseif args[1] == prefix .. "spoofkillstreak" then
		game.Players.LocalPlayer.PlayerGui.Home.HUD.streak.Text = "Streak : " .. tostring(args[2])
	elseif args[1] == prefix .. "loopspeed" then
		speedlooped = true
		while speedlooped do
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(args[2])
		end
	elseif args[1] == prefix .. "loopjumppower" then
		jumppowerlooped = true
		while jumppowerlooped do
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(args[2])
		end
	elseif args[1] == prefix .. "craftingitem" then
		local nospace = {
			"Mirror",
			"Pipe",
			"Stick"
		}
		
		local space = {
			"Duct Tape",
			"Metal Shard"
		}
		
		local special = "Bedsheets"
		for _,v in nospace do
			if tostring(args[2]) == v then
				local giver = workspace.Prison_ITEMS.crafting:FindFirstChild(v).craftingitem
				getgenv().op = hrp.CFrame
				hrp.CFrame = giver.CFrame
				game.ReplicatedStorage.Events.Interact:InvokeServer(giver,"CraftingItem")
				task.wait(.1)
				hrp.CFrame = getgenv().op
			end
		end
		for _,v in space do
			if tostring(args[2] .. " " .. args[3]) == v then
				local giver = workspace.Prison_ITEMS.crafting:FindFirstChild(v).craftingitem
				getgenv().op = hrp.CFrame
				hrp.CFrame = giver.CFrame
				game.ReplicatedStorage.Events.Interact:InvokeServer(giver,"CraftingItem")
				task.wait(.1)
				hrp.CFrame = getgenv().op
			end
		end
		if tostring(args[2]) == special then
			local giver = workspace.Prison_ITEMS.crafting:FindFirstChild(special).Part
			getgenv().op = hrp.CFrame
			hrp.CFrame = giver.CFrame
			game.ReplicatedStorage.Events.Interact:InvokeServer(giver,"CraftingItem")
			task.wait(.1)
			hrp.CFrame = getgenv().op
		end
	elseif command == prefix .. "guardspawn" then
		hrp.CFrame = CFrame.new(1855, 155, 2679)
	elseif command == prefix .. "wardenspawn" then
		hrp.CFrame = CFrame.new(1730, 156, 2759)
	elseif command == prefix .. "prisonerspawn" then
		hrp.CFrame = CFrame.new(1903, 170, 2899)
	elseif command == prefix .. "criminalspawn" then
		hrp.CFrame = CFrame.new(105, 151, 2552)
	elseif command == prefix .. "neutralspawn" then
		hrp.CFrame = CFrame.new(2926, 227, 3407)
	elseif command == prefix .. "hostileesp" then
		hostileesp = true
		while hostileesp do
			for _,v in pairs(game.Players:GetPlayers()) do
				if not v.Character.Head:FindFirstChild("BoxHandleAdornment") then
					if v.Status.Hostile.Value == true then
						local bha = Instance.new("BoxHandleAdornment",v)
						bha.Transparency = 0.5
						bha.AlwaysOnTop = true
						bha.Size = Vector3.new(1.5,1.5,1.5)
						bha.Adornee = v
						bha.Color3 = Color3.fromRGB(0,255,0)
					else
						local bha = Instance.new("BoxHandleAdornment",v)
						bha.Transparency = 0.5
						bha.AlwaysOnTop = true
						bha.Size = Vector3.new(1.5,1.5,1.5)
						bha.Adornee = v
						bha.Color3 = Color3.fromRGB(255,0,0)
					end
				end
			end
		end
	elseif command == prefix .. "unhostileesp" then
		hostileesp = false
	elseif args[1] == prefix .. "craft" then
		-- UNFINISHED
	elseif args[1] == prefix .. "spoofkills" then
		game.Players.LocalPlayer.leaderstats.Kills.Value = tonumber(args[2])
	elseif args[1] == prefix .. "spoofarrests" then
		game.Players.LocalPlayer.leaderstats.Arrests.Value = tonumber(args[2])
	elseif command == prefix .. "closecmds" then
		CommandsFrame.Visible = false
	elseif command == prefix .. "aug" then
		local giver = workspace.Prison_ITEMS.giver.AUG.Part
		giverfunc(giver)
	elseif command == prefix .. "teamesp" then
		teamesp = true
		while teamesp do
			for _,v in pairs(game.Players:GetPlayers()) do
				if not v.Character.Head:FindFirstChild("BoxHandleAdornment") then
					if v.Team == game.Teams.Criminals then
						local bha = Instance.new("BoxHandleAdornment",v)
						bha.Transparency = 0.5
						bha.AlwaysOnTop = true
						bha.Size = Vector3.new(1.5,1.5,1.5)
						bha.Adornee = v
						bha.Color3 = Color3.fromRGB(255,0,0)
					elseif v.Team == game.Teams.Guards then
						local bha = Instance.new("BoxHandleAdornment",v)
						bha.Transparency = 0.5
						bha.AlwaysOnTop = true
						bha.Size = Vector3.new(1.5,1.5,1.5)
						bha.Adornee = v
						bha.Color3 = Color3.fromRGB(0,0,255)
					elseif v.Team == game.Teams.Inmates then
						local bha = Instance.new("BoxHandleAdornment",v)
						bha.Transparency = 0.5
						bha.AlwaysOnTop = true
						bha.Size = Vector3.new(1.5,1.5,1.5)
						bha.Adornee = v
						bha.Color3 = Color3.fromRGB(255,100,0)
					elseif v.Team == game.Teams.Neutral then
						local bha = Instance.new("BoxHandleAdornment",v)
						bha.Transparency = 0.5
						bha.AlwaysOnTop = true
						bha.Size = Vector3.new(1.5,1.5,1.5)
						bha.Adornee = v
						bha.Color3 = Color3.fromRGB(125,125,125)
					elseif v.Team == game.Teams.Spectators then
						local bha = Instance.new("BoxHandleAdornment",v)
						bha.Transparency = 0.5
						bha.AlwaysOnTop = true
						bha.Size = Vector3.new(1.5,1.5,1.5)
						bha.Adornee = v
						bha.Color3 = Color3.fromRGB(0,0,0)
					elseif v.Team == game.Teams.Warden then
						local bha = Instance.new("BoxHandleAdornment",v)
						bha.Transparency = 0.5
						bha.AlwaysOnTop = true
						bha.Size = Vector3.new(1.5,1.5,1.5)
						bha.Adornee = v
						bha.Color3 = Color3.fromRGB(0,0,125)
					end
				end
			end
		end
	elseif command == prefix .. "unteamesp" then
		teamesp = false
	elseif command == prefix .. "infiniteyield" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	elseif args[1] == prefix .. "view" then
		workspace.CurrentCamera.CameraSubject = game.Players:FindFirstChild(tostring(args[2])).Character
	elseif args[1] == prefix .. "unview" then
		workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
	elseif command == prefix .. "noclip" then
		noclipping = true
		while noclipping do
			for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true then
					child.CanCollide = false
				end
			end
		end
	elseif command == prefix .. "clip" then
		noclipping = false
	end
end)
