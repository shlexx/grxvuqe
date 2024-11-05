local char = game.Players.LocalPlayer.Character
local torso = char.Torso or char.UpperTorso
local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(i,g)
if not g and i.KeyCode == Enum.KeyCode.Q then
local bv = Instance.new("BodyVelocity")
bv.Parent = torso
bv.P = 1250
bv.MaxForce = Vector3.one*math.huge
if uis:IsKeyDown(Enum.KeyCode.W) then
bv.Velocity = torso.CFrame.lookVector*50
elseif uis:IsKeyDown(Enum.KeyCode.A) then
bv.Velocity = -torso.CFrame.RightVector*50
elseif uis:IsKeyDown(Enum.KeyCode.S) then
bv.Velocity = -torso.CFrame.lookVector*50
elseif uis:IsKeyDown(Enum.KeyCode.D) then
bv.Velocity = torso.CFrame.RightVector*50
else
bv.Velocity = torso.CFrame.lookVector*50
end
game:GetService("Debris"):AddItem(bv,0.2)
end
end)
