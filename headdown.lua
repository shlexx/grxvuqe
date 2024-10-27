local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://68433924"
local tweenInfo = TweenInfo.new(0.5,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out)
local animationTrack = humanoid:LoadAnimation(animation)
animationTrack:Play()
animationTrack:AdjustSpeed(0)
