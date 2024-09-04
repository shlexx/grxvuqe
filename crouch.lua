local crouching = false
local crouchkey = Enum.KeyCode.C
local player = game.Players.LocalPlayer
repeat wait() until player.Character.Humanoid
local humanoid = player.Character.Humanoid
local character = player.Character or player.CharacterAdded:Wait()
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://182724289"
local playAnim = humanoid:LoadAnimation(anim)
game:GetService("UserInputService").InputBegan:Connect(function(input)
if input.KeyCode == crouchkey then
if crouching then
playAnim:Stop()
crouching = false
else
playAnim:Play()
crouching = true
end
end
end)
