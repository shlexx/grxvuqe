local Players = game:GetService("Players")
local mouse = game.Players.LocalPlayer:GetMouse()
local selectionbox = Instance.new("SelectionBox", workspace)
local equipped = false
local oldmouse = mouse.Icon
local destroytool = Instance.new("Tool", Players.LocalPlayer:FindFirstChildOfClass("Backpack"))
destroytool.RequiresHandle = false
destroytool.Name = "Delete"
destroytool.TextureId = "http://www.roblox.com/asset/?id=12223874"
destroytool.CanBeDropped = false
destroytool.Equipped:connect(function()
	equipped = true
	mouse.Icon = "rbxasset://textures\\HammerCursor.png"
	while equipped do
		selectionbox.Adornee = mouse.Target
		wait()
	end
end)
destroytool.Unequipped:connect(function()
	equipped = false
	selectionbox.Adornee = nil
	mouse.Icon = oldmouse
	print(oldmouse)
end)
destroytool.Activated:connect(function()
	local explosion = Instance.new("Explosion", workspace)
	explosion.BlastPressure = 0
	explosion.BlastRadius = 0
	explosion.DestroyJointRadiusPercent = 0
	explosion.ExplosionType = Enum.ExplosionType.NoCraters
	explosion.Position = mouse.Target.Position
	Destroy(mouse.Target)
end)
game:GetService("StarterGui"):SetCoreGuiEnabled('Backpack', true)
