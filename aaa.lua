local ignoretable = {
  "http://www.roblox.com/asset/?id=178130996",
  "http://www.roblox.com/asset/?id=180436148",
  "http://www.roblox.com/asset/?id=182393478",
  "http://www.roblox.com/asset/?id=180436334",
  "http://www.roblox.com/asset/?id=125750702",
  "http://www.roblox.com/asset/?id=180426354",
  "http://www.roblox.com/asset/?id=180435792",
  "http://www.roblox.com/asset/?id=180435571",
  "http://www.roblox.com/asset/?id=507770677",
  "http://www.roblox.com/asset/?id=507765644",
  "http://www.roblox.com/asset/?id=507771019",
  "http://www.roblox.com/asset/?id=507771955",
  "http://www.roblox.com/asset/?id=507772104",
  "http://www.roblox.com/asset/?id=507776043",
  "http://www.roblox.com/asset/?id=507776720",
  "http://www.roblox.com/asset/?id=507776879",
  "http://www.roblox.com/asset/?id=507777268",
  "http://www.roblox.com/asset/?id=507777451",
  "http://www.roblox.com/asset/?id=507777623",
  "http://www.roblox.com/asset/?id=507767968",
  "http://www.roblox.com/asset/?id=507766388",
  "http://www.roblox.com/asset/?id=507766666",
  "http://www.roblox.com/asset/?id=507765000",
  "http://www.roblox.com/asset/?id=507770818",
  "http://www.roblox.com/asset/?id=507770453",
  "http://www.roblox.com/asset/?id=2506281703",
  "http://www.roblox.com/asset/?id=522638767",
  "http://www.roblox.com/asset/?id=507768375",
  "http://www.roblox.com/asset/?id=522635514",
  "http://www.roblox.com/asset/?id=507770239",
  "http://www.roblox.com/asset/?id=913376220",
  "http://www.roblox.com/asset/?id=913384386",
  "http://www.roblox.com/asset/?id=913389285",
  "http://www.roblox.com/asset/?id=913402848",
  "http://www.roblox.com/asset/?id=7715096377"
}
for _,v in pairs(game:GetDescendants()) do
  if v:IsA("Animation") then
    local nono = false
    for i = 1,#ignoretable do
      if (v.AnimationId == ignoretable[i]) or (v.Parent.Parent.Name == "Animate") then
        nono = true
      end
    end
    if nono == false then
      print("@ game." .. v:GetFullName() .. " / " .. v.AnimationId)
    end
  end
end
game.DescendantAdded:Connect(function(v)
  if v:IsA("Animation") then
    local nono = false
    for i = 1,#ignoretable do
      if (v.AnimationId == ignoretable[i]) or (v.Parent.Parent.Name == "Animate") then
        nono = true
      end
    end
    if nono == false then
      print("@/ game." .. v:GetFullName() .. " / " .. v.AnimationId)
    end
  end
end)
