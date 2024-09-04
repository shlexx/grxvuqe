local bodyGyro = Instance.new("BodyGyro", game.Players.LocalPlayer.Character.HumanoidRootPart)
local force = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
Instance.new("Fire", game.Players.LocalPlayer.Character.HumanoidRootPart)
bodyGyro.cframe = workspace.CurrentCamera.CoordinateFrame
force.velocity = Vector3.new(0,math.huge,0)
wait(5)
Instance.new("Explosion",game.Players.LocalPlayer.Character.HumanoidRootPart)
game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
