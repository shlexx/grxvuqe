for _,v in pairs(game:GetDescendants()) do
  if v:IsA("Animation") then
    print("@ game." .. v:GetFullName() .. " / " .. v.AnimationId)
  end
end
