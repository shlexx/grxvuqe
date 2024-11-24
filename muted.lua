local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextBox = Instance.new("TextBox")
local UICorner_2 = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local TextButton2 = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui.RobloxGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.20955883, 0, 0.388190955, 0)
Frame.Size = UDim2.new(0, 250, 0, 225)

UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = Frame

TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.100000001, 0, 0.0688888878, 0)
TextBox.Size = UDim2.new(0, 200, 0, 50)
TextBox.ClearTextOnFocus = false
TextBox.Font = Enum.Font.FredokaOne
TextBox.PlaceholderText = "text"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextScaled = true
TextBox.TextSize = 14.000
TextBox.TextWrapped = true

UICorner_2.CornerRadius = UDim.new(0, 16)
UICorner_2.Parent = TextBox

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.100000001, 0, 0.386222333, 0)
TextButton.Size = UDim2.new(0, 200, 0, 50)
TextButton.Font = Enum.Font.FredokaOne
TextButton.Text = "send message"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true

UICorner_3.CornerRadius = UDim.new(0, 16)
UICorner_3.Parent = TextButton

TextButton2.Name = "TextButton2"
TextButton2.Parent = Frame
TextButton2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextButton2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton2.BorderSizePixel = 0
TextButton2.Position = UDim2.new(0.100000001, 0, 0.710666776, 0)
TextButton2.Size = UDim2.new(0, 200, 0, 50)
TextButton2.Font = Enum.Font.FredokaOne
TextButton2.Text = "anti chat logger"
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.TextScaled = true
TextButton2.TextSize = 14.000
TextButton2.TextWrapped = true

UICorner_4.CornerRadius = UDim.new(0, 16)
UICorner_4.Parent = TextButton2

TextButton.MouseButton1Click:Connect(function()
	if game.TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
		game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(TextBox.Text, "All")
	else
		game.TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(TextBox.Text)
	end
end)

TextButton.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/scripts/AntiChatLogger.lua", true))()
end)
