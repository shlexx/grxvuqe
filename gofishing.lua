local areanames = {}
local areas = {}
for i,v in pairs(workspace.Storage:GetChildren()) do
if v.Name == "Part" and v:FindFirstChild("oceanNameTemplate") then
table.insert(areanames,v.oceanNameTemplate.oceanName.Text:lower())
table.insert(areas,v)
end
end
local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window = Library:NewWindow("funny fishing")
local Fishing = Window:NewSection("main")
Fishing:CreateTextbox("set size to equipped fish", function(text)
local fish = game.Players.LocalPlayer.Backpack:FindFirstChild("Fish") or game.Players.LocalPlayer.Character:FindFirstChild("Fish")
game:GetService("ReplicatedStorage").events.fishing.canEquipItem:InvokeServer("fishes",fish:GetAttribute("itemId"),{kg=tonumber(text),tier="default",itemId=fish:GetAttribute("itemId")})
game:GetService("ReplicatedStorage").events.fishing.canEquipItem:InvokeServer("fishes",fish:GetAttribute("itemId"),{kg=tonumber(text),tier="default",itemId=fish:GetAttribute("itemId")})
end)
Fishing:CreateButton("redeem all codes", function()
for i,v in pairs(game.Players.LocalPlayer.rewards.codes:GetChildren()) do
game:GetService("ReplicatedStorage").events.gui.canRedeemCode:InvokeServer(v.Name)
end
end)
Fishing:CreateDropdown("equip selected fish as..", {"default", "gold", "diamond"}, 1, function(text)
local fish = game.Players.LocalPlayer.Backpack:FindFirstChild("Fish") or game.Players.LocalPlayer.Character:FindFirstChild("Fish")
local kg1 = 0
for i,v in pairs(fish:GetChildren()) do
if v:IsA("Model") then
local kg2 = v:GetChildren()[1].fishBillboard.kgWeight
kg1 = string.sub(kg2.Text,0,string.len(kg2.Text)-2)
end
end
game:GetService("ReplicatedStorage").events.fishing.canEquipItem:InvokeServer("fishes",fish:GetAttribute("itemId"),{kg=kg1,tier=text,itemId=fish:GetAttribute("itemId")})
game:GetService("ReplicatedStorage").events.fishing.canEquipItem:InvokeServer("fishes",fish:GetAttribute("itemId"),{kg=kg1,tier=text,itemId=fish:GetAttribute("itemId")})
end)
Fishing:CreateDropdown("teleport to area", areanames, 1, function(text)
for i,v in pairs(workspace.Storage:GetChildren()) do
if v:IsA("Model") and string.match(v.Name:lower(),text:split(" ")[1]) then
for n,x in pairs(areas) do
if string.match(x.oceanNameTemplate.oceanName.Text:lower(),text:split(" ")[1]) then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.CFrame
end
end
end
end
end)
