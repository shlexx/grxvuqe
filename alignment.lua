game.UserInputService.InputBegan:Connect(function(key,e)
if e then return end
if key.KeyCode == Enum.KeyCode.Comma then workspace.CurrentCamera:PanUnits(-.5) end
if key.KeyCode == Enum.KeyCode.Period then workspace.CurrentCamera:PanUnits(.5) end
end)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu,false)
