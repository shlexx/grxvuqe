for i,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
    if v:FindFirstChild("__FUNCTION") then
        v:Destroy()
    end
end
