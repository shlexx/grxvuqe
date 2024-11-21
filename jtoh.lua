local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://9105892431"
local anim2 = Instance.new("Animation")
anim2.AnimationId = "rbxassetid://9105897084"
local p = game.Players.LocalPlayer
local tpose = Instance.new("Tool",p.Backpack)
local heli = Instance.new("Tool",p.Backpack)
tpose.Name = "T-Pose"
tpose.RequiresHandle = false
tpose.CanBeDropped = false
tpose.TextureId = "rbxassetid://6869582429"
tpose.ToolTip = "Assert dominance"
heli.Name = "Helicopter Powers"
heli.RequiresHandle = false
heli.CanBeDropped = false
heli.TextureId = "rbxassetid://6235245591"
heli.ToolTip = "I can see my house from here!"
tpose.Activated:Connect(function()
p.Character.CharacterScripts.TouchScript.Disabled = true
local play = p.Character.Humanoid:LoadAnimation(anim)
play:Play()
end)
tpose.Deactivated:Connect(function()
p.Character.CharacterScripts.TouchScript.Disabled = false
for _,v in pairs(p.Character.Humanoid:GetPlayingAnimationTracks()) do
if v.Animation.AnimationId == anim.AnimationId then
v:Stop()
end
end
end)
tpose.Unequipped:Connect(function()
p.Character.CharacterScripts.TouchScript.Disabled = false
for _,v in pairs(p.Character.Humanoid:GetPlayingAnimationTracks()) do
if v.Animation.AnimationId == anim.AnimationId then
v:Stop()
end
end
end)
heli.Activated:Connect(function()
p.Character.CharacterScripts.TouchScript.Disabled = true
local play = p.Character.Humanoid:LoadAnimation(anim2)
play:Play()
end)
heli.Deactivated:Connect(function()
p.Character.CharacterScripts.TouchScript.Disabled = false
for _,v in pairs(p.Character.Humanoid:GetPlayingAnimationTracks()) do
if v.Animation.AnimationId == anim2.AnimationId then
v:Stop()
end
end
end)
heli.Unequipped:Connect(function()
p.Character.CharacterScripts.TouchScript.Disabled = falsew
for _,v in pairs(p.Character.Humanoid:GetPlayingAnimationTracks()) do
if v.Animation.AnimationId == anim2.AnimationId then
v:Stop()
end
end
end)
