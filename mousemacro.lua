local UIS = game:GetService("UserInputService")
local enabled = true
local enabled2 = false
UIS.InputBegan:Connect(function(input,e)
    if e then return end
    if input.KeyCode == Enum.KeyCode.Z then
      if enabled then
        if enabled2 then
          enabled2 = false
        else
          enabled2 = true
          while task.wait() do
            workspace.CurrentCamera:PanUnits(-.5)
            task.wait()
            workspace.CurrentCamera:PanUnits(.5)
            task.wait()
          end
        end
      end
    end
  elseif input.KeyCode == Enum.KeyCode.F2 then
    enabled = false
  end
end
game.StarterGui:SetCore({Title = "Loaded successfully!",Text = "Mouse Macro loaded! Press Z to enable/disable or F2 to completely disable."})
