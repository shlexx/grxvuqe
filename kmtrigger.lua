local mouse = game.Players.LocalPlayer:GetMouse()
function kill(txt)
	local args = {
		[1] = "Revolver",
		[2] = txt,
		[3] = {
			[1] = "GunDefault",
			[2] = "Torso",
			[3] = Vector3.new(0,0,0),
			[4] = "Default"
		}
	}
	workspace.GameMain.Triggers.ServerRequest.Damage:FireServer(unpack(args))
end

while task.wait() do
    if mouse then
        if mouse.Target then
            pcall(function()
                if mouse.Target.Parent.Humanoid then
                    kill(mouse.Target.Parent.Name)
                end
            end)
        end
    end
end
