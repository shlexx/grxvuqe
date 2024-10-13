for _,v in pairs(game.ReplicatedStorage.Items:GetChildren()) do
if v.Configuration.Price.Value == 0 then
game.ReplicatedStorage.Events.Buy:FireServer(v.Name)
end
task.wait()
end
