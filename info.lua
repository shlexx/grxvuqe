local ScreenGui = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local maintxt = Instance.new("TextLabel")
local UICorner_2 = Instance.new("UICorner")
local otherside = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")
local fillins = Instance.new("Folder")
local fillin = Instance.new("TextLabel")
local fillin_2 = Instance.new("TextLabel")
local fillin_3 = Instance.new("TextLabel")
local fillin_4 = Instance.new("TextLabel")
local user = Instance.new("Frame")
local _input = Instance.new("TextBox")
local send = Instance.new("ImageButton")
local UICorner_4 = Instance.new("UICorner")
local scroll = Instance.new("ScrollingFrame")
local show = Instance.new("TextBox")

ScreenGui.Name = "⟡˖"
ScreenGui.Parent = gethui() or game.CoreGui

main.Name = "main"
main.Parent = ScreenGui
main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
main.BorderColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.335999995, 0, 0.342964828, 0)
main.Size = UDim2.new(0, 450, 0, 250)

UICorner.Parent = main

maintxt.Name = "maintxt"
maintxt.Parent = main
maintxt.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
maintxt.BorderColor3 = Color3.fromRGB(0, 0, 0)
maintxt.BorderSizePixel = 0
maintxt.Size = UDim2.new(0, 450, 0, 20)
maintxt.Font = Enum.Font.Code
maintxt.Text = "   pging"
maintxt.TextColor3 = Color3.fromRGB(255, 255, 255)
maintxt.TextSize = 14.000
maintxt.TextXAlignment = Enum.TextXAlignment.Left

UICorner_2.Parent = maintxt

otherside.Name = "otherside"
otherside.Parent = main
otherside.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
otherside.BorderColor3 = Color3.fromRGB(0, 0, 0)
otherside.BorderSizePixel = 0
otherside.Position = UDim2.new(0, 0, 0.0799999982, 0)
otherside.Size = UDim2.new(0, 20, 0, 230)
otherside.Font = Enum.Font.Code
otherside.Text = ""
otherside.TextColor3 = Color3.fromRGB(255, 255, 255)
otherside.TextSize = 14.000
otherside.TextXAlignment = Enum.TextXAlignment.Left

UICorner_3.Parent = otherside

fillins.Name = "fillins"
fillins.Parent = main

fillin.Name = "fillin"
fillin.Parent = fillins
fillin.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
fillin.BorderColor3 = Color3.fromRGB(0, 0, 0)
fillin.BorderSizePixel = 0
fillin.Position = UDim2.new(0.0222222228, 0, 0.89200002, 0)
fillin.Size = UDim2.new(0, 10, 0, 27)
fillin.Font = Enum.Font.SourceSans
fillin.Text = ""
fillin.TextColor3 = Color3.fromRGB(0, 0, 0)
fillin.TextSize = 14.000

fillin_2.Name = "fillin"
fillin_2.Parent = fillins
fillin_2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
fillin_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
fillin_2.BorderSizePixel = 0
fillin_2.Position = UDim2.new(0.0222222228, 0, 0.0799999982, 0)
fillin_2.Size = UDim2.new(0, 10, 0, 26)
fillin_2.Font = Enum.Font.SourceSans
fillin_2.Text = ""
fillin_2.TextColor3 = Color3.fromRGB(0, 0, 0)
fillin_2.TextSize = 14.000

fillin_3.Name = "fillin"
fillin_3.Parent = fillins
fillin_3.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
fillin_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
fillin_3.BorderSizePixel = 0
fillin_3.Position = UDim2.new(0.977777779, 0, 0.0120000001, 0)
fillin_3.Size = UDim2.new(0, 10, 0, 17)
fillin_3.Font = Enum.Font.SourceSans
fillin_3.Text = ""
fillin_3.TextColor3 = Color3.fromRGB(0, 0, 0)
fillin_3.TextSize = 14.000

fillin_4.Name = "fillin"
fillin_4.Parent = fillins
fillin_4.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
fillin_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
fillin_4.BorderSizePixel = 0
fillin_4.Position = UDim2.new(0, 0, 0.0560000017, 0)
fillin_4.Size = UDim2.new(0, 10, 0, 26)
fillin_4.Font = Enum.Font.SourceSans
fillin_4.Text = ""
fillin_4.TextColor3 = Color3.fromRGB(0, 0, 0)
fillin_4.TextSize = 14.000

user.Name = "user"
user.Parent = main
user.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
user.BorderColor3 = Color3.fromRGB(0, 0, 0)
user.BorderSizePixel = 0
user.Position = UDim2.new(0.0666666701, 0, 0.851999998, 0)
user.Size = UDim2.new(0, 410, 0, 25)

_input.Name = "_input"
_input.Parent = user
_input.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
_input.BackgroundTransparency = 1.000
_input.BorderColor3 = Color3.fromRGB(0, 0, 0)
_input.BorderSizePixel = 0
_input.Position = UDim2.new(0.0230352636, 0, -0.0199999996, 0)
_input.Size = UDim2.new(0, 400, 0, 25)
_input.Font = Enum.Font.Code
_input.PlaceholderText = "insert command here"
_input.Text = ""
_input.TextColor3 = Color3.fromRGB(255, 255, 255)
_input.TextSize = 14.000
_input.TextXAlignment = Enum.TextXAlignment.Left

send.Name = "send"
send.Parent = user
send.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
send.BorderColor3 = Color3.fromRGB(0, 0, 0)
send.BorderSizePixel = 0
send.Position = UDim2.new(0.947560966, 0, 0.0799999982, 0)
send.Size = UDim2.new(0, 20, 0, 20)
send.Image = "rbxassetid://18990899796"

UICorner_4.CornerRadius = UDim.new(0, 4)
UICorner_4.Parent = send

scroll.Name = "scroll"
scroll.Parent = main
scroll.Active = true
scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scroll.BackgroundTransparency = 1.000
scroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
scroll.BorderSizePixel = 0
scroll.Position = UDim2.new(0.0666666701, 0, 0.119999997, 0)
scroll.Size = UDim2.new(0, 409, 0, 173)

show.Name = "show"
show.Parent = scroll
show.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
show.BorderColor3 = Color3.fromRGB(0, 0, 0)
show.BorderSizePixel = 0
show.Size = UDim2.new(0, 409, 0, 346)
show.ClearTextOnFocus = false
show.Font = Enum.Font.Code
show.MultiLine = true
show.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
show.PlaceholderText = "info here"
show.Text = ""
show.TextColor3 = Color3.fromRGB(255, 255, 255)
show.TextSize = 14.000
show.TextWrapped = true
show.TextXAlignment = Enum.TextXAlignment.Left
show.TextYAlignment = Enum.TextYAlignment.Top

-- // Credits to ComplexMetatable for the drag
local UserInputService = game:GetService("UserInputService")
local runService = (game:GetService("RunService"));

local gui = main

local dragging
local dragInput
local dragStart
local startPos

function Lerp(a, b, m)
	return a + (b - a) * m
end;

local lastMousePos
local lastGoalPos
local DRAG_SPEED = (8);
function Update(dt)
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


send.MouseButton1Click:Connect(function()
	local args = _input.Text:split(" ")
	if args[1] == "-info" then
		if string.match(args[2],"user:") then
			local username = string.gsub(args[2],"user:","")

			local success,_error = pcall(function()
				game.Players:GetUserIdFromNameAsync(username)
				local decode = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://users.roblox.com/v1/users/" .. game.Players:GetUserIdFromNameAsync(username)))
				print(decode.description)
			end)

			if success then
				local decode = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://users.roblox.com/v1/users/" .. game.Players:GetUserIdFromNameAsync(username)))
				show.Text = "Player Found!\n\nCurrent Description: " .. decode.description .. "\nJoin Date: " .. decode.created .. "\nBanned: " .. tostring(decode.isBanned) .. "\nId: " .. decode.id .. "\nName: " .. decode.name .. "\n\nCommon Passwords: " .. username .. ", " .. username .. "123" .. ", " .. string.gsub(username,"%d","") .. ", " .. string.gsub(username,"%d","") .. ", " .. username .. "321" .. ", " .. string.gsub(username,"%d","") .. "123" .. ", " .. string.gsub(username,"%d","") .. "321" .. ", " .. string.gsub(username,"%d","") .. string.sub(decode.created,3,4) .. ", " .. string.gsub(username,"%d","") .. string.sub(decode.created,1,4) .. "\nAll Info Found!!"
			else
				show.Text = "Error occured: Player not found  //  " .. _error
			end
		elseif string.match(args[2],"id:") then
			local id = string.gsub(args[2],"id:","")

			local success,_error = pcall(function()
				game.Players:GetNameFromUserIdAsync(tonumber(id))
				local decode = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://users.roblox.com/v1/users/" .. id))
				print(decode.description)
			end)

			if success then
				local username = game.Players:GetNameFromUserIdAsync(tonumber(id))
				local decode = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://users.roblox.com/v1/users/" .. tonumber(id)))
				show.Text = "Player Found!\n\nCurrent Description: " .. decode.description .. "\nJoin Date: " .. decode.created .. "\nBanned: " .. tostring(decode.isBanned) .. "\nId: " .. decode.id .. "\nName: " .. decode.name .. "\n\nCommon Passwords: " .. username .. ", " .. username .. "123" .. ", " .. string.gsub(username,"%d","") .. ", " .. string.gsub(username,"%d","") .. ", " .. username .. "321" .. ", " .. string.gsub(username,"%d","") .. "123" .. ", " .. string.gsub(username,"%d","") .. "321" .. ", " .. string.gsub(username,"%d","") .. string.sub(decode.created,3,4) .. ", " .. string.gsub(username,"%d","") .. string.sub(decode.created,1,4) .. "\nAll Info Found!!"
			else
				show.Text = "Error occured: Player not found  //  " .. _error
			end
		end
		task.wait()
		_input.Text = ""
	elseif args[1] == "-clear" then
		show.Text = ""
		_input.Text = ""
	end
end)
