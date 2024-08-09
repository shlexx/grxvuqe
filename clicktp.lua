local lp = game.Players.LocalPlayer
local hrp = lp.Character.HumanoidRootPart
local mouse = lp:GetMouse()
local tool = Instance.new("Tool", lp:FindFirstChildOfClass("Backpack"))
local equipped = false

tool.Name = "Click Teleport"
tool.RequiresHandle = false
tool.CanBeDropped = false

tool.Equipped:Connect(function()
	equipped = true
end)

tool.Activated:Connect(function()
	if equipped then
		hrp.CFrame = CFrame.new(mouse.Hit.p.X, mouse.Hit.p.Y + 2, mouse.Hit.p.Z)
	end
end)

tool.Unequipped:Connect(function()
	equipped = false
end)
