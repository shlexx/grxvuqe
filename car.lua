local hum = game.Players.LocalPlayer.Character.Humanoid
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://129342287"
local playAnim = hum:LoadAnimation(anim)
playAnim:Play()
hum.WalkSpeed = 64
