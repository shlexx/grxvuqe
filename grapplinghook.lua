local grappling = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
grappling.CanBeDropped = false
grappling.RequiresHandle = false
grappling.TextureId = "rbxassetid://30327988"
local mouse = game.Players.LocalPlayer:GetMouse()
local equipped = false
local tweenSpeed = 1
local TweenService = game:GetService("TweenService")

grappling.Equipped:Connect(function()
	equipped = true
end)

grappling.Unequipped:Connect(function()
	equipped = false
end)

grappling.Activated:Connect(function()
	if equipped == true then
		TweenService:Create(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = mouse.Hit + Vector3.new(0, 2, 0)}):Play()
	else end
end)
