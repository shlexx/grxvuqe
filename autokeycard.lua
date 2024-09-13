game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
    game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(.2)
        local giver = workspace.Prison_ITEMS.giver:GetChildren()[9].ITEMPICKUP
        local hrp = char:WaitForChild("HumanoidRootPart")
        getgenv().op = hrp.CFrame
        hrp.CFrame = giver.CFrame
        task.wait(.2)
        game.ReplicatedStorage.Events.Interact:InvokeServer(giver,"GetTool")
        task.wait(.1)
        hrp.CFrame = getgenv().op
    end)
end)
