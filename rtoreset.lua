game:GetService("UserInputService").InputBegan:Connect(function(input,e)
if e then return end
if input.KeyCode == Enum.KeyCode.R then
if game.Players.LocalPlayer.Character then
game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
end
end
end)
