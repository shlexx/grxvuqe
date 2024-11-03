while task.wait() do
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            pcall(function()
                for n,x in pairs(v.Character:GetChildren()) do
                    if x:IsA("BasePart") then
                        x.CanCollide = false
                    end
                end
            end)
        end
    end
end
