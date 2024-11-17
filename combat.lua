local m1 = true
local m2 = false
local m3 = false
local block = false

local anim1 = Instance.new("Animation")
anim1.AnimationId = "rbxassetid://243827693"
local anim2 = Instance.new("Animation")
anim2.AnimationId = "rbxassetid://218504594"
local anim3 = Instance.new("Animation")
anim3.AnimationId = "rbxassetid://74813494"
local anim4 = Instance.new("Animation")
anim4.AnimationId = "rbxassetid://97884040"

game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if not block then
if m1 and not m2 and not m3 then
local playanim = hum:LoadAnimation(anim1)
playanim:Play(0,1,1.5)
m1 = false
m2 = true
m3 = false
elseif not m1 and m2 and not m3 then
local playanim = hum:LoadAnimation(anim2)
playanim:Play(0,1,1.5)
m1 = false
m2 = false
m3 = true
elseif not m1 and not m2 and m3 then
local playanim = hum:LoadAnimation(anim3)
playanim:Play(0,1,1.5)
m1 = true
m2 = false
m3 = false
end
end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input,chat)
if chat then return end
if input.KeyCode == Enum.KeyCode.F then
block = true
local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local playanim = hum:LoadAnimation(anim4)
playanim:Play()
Instance.new("ForceField",hum.Parent)
end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input,chat)
if chat then return end
if input.KeyCode == Enum.KeyCode.F then
block = false
local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
for _,v in pairs(hum:GetPlayingAnimationTracks()) do
if v.Animation.AnimationId == anim4.AnimationId then
v:Stop()
end
if hum.Parent:FindFirstChild("ForceField") then
hum.Parent:FindFirstChild("ForceField"):Destroy()
end
end
end
end)
