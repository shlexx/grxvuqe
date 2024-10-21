local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui
TextButton.Parent = ScreenGui
TextButton.AnchorPoint = Vector2.new(1, 1)
TextButton.Position = UDim2.new(1, 0, 1, 0)
TextButton.Size = UDim2.new(0, 200, 0, 50)
TextButton.Text = "autofarm button ! !"
TextButton.MouseButton1Click:Connect(function()
	for _,v in pairs(workspace["Easter001!"]:GetChildren()[1]:GetChildren()) do
		if not v.EggTouched.Value then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
			wait(.5)
		end
	end
end)
