for _,v in pairs(workspace.segmentSystem.Segments:GetDescendants()) do
    if v:IsA("BasePart") and v.Parent:IsA("Folder") then
        if v.CanCollide == true then
            local sb = Instance.new("SelectionBox")
            sb.Parent = v
            sb.Adornee = v
        end
    end
end
