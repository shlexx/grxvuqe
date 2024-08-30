if game.CoreGui.SelectorGUI then
    game.CoreGui.SelectorGUI:Destroy()
end
local Players = game:GetService("Players")
local mouse = Players.LocalPlayer:GetMouse()
local selectionbox = Instance.new("SelectionBox", workspace)
local equipped = false
local selectortool = Instance.new("Tool", Players.LocalPlayer:FindFirstChildOfClass("Backpack"))
local SelectorGUI = Instance.new("ScreenGui")
local SelectorText = Instance.new("TextLabel")
SelectorGUI.Name = "SelectorGUI"
SelectorGUI.Parent = game.CoreGui
SelectorText.Name = "SelectorText"
SelectorText.Parent = SelectorGUI
SelectorText.AnchorPoint = Vector2.new(1, 1)
SelectorText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectorText.BackgroundTransparency = 1.000
SelectorText.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectorText.BorderSizePixel = 0
SelectorText.Position = UDim2.new(1, 0, 1, 0)
SelectorText.Size = UDim2.new(0, 1, 0, 50)
SelectorText.Font = Enum.Font.ArimoBold
SelectorText.TextColor3 = Color3.fromRGB(0, 0, 0)
SelectorText.TextSize = 35.000
SelectorText.Text = ""
SelectorText.TextXAlignment = Enum.TextXAlignment.Right
SelectorText.Visible = false
selectortool.RequiresHandle = false
selectortool.Name = "Selector"
selectortool.TextureId = "rbxasset://textures\\ArrowCursor.png"
selectortool.CanBeDropped = false
selectortool.Equipped:Connect(function()
	equipped = true
	SelectorText.Visible = true
	while equipped do
		selectionbox.Adornee = mouse.Target
		SelectorText.Text = "game." .. mouse.Target:GetFullName()
		task.wait()
	end
end)
selectortool.Unequipped:Connect(function()
	equipped = false
	selectionbox.Adornee = nil
	SelectorText.Visible = false
end)
game:GetService("StarterGui"):SetCoreGuiEnabled('Backpack', true)
