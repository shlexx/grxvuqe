game:GetService("UserInputService").JumpRequest:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
