local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local mouse = player:GetMouse()
local main = game.ReplicatedStorage.AllRemoteEvents.CLientToServerR
local equipped = false
local _delay = .05
local block = {18602616902,18602631213,18602634269,17751557797,8602636202,17751496769}
local humanoid = player.Character.Humanoid

local text = "Press V to equip/unequip the gun"
local popup = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        if equipped then
            main:FireServer("ChangeTojiWapeon","")
            playAnim:Stop()
            equipped = false
            TextLabel.Visible = true
            wait(.5)
            local _text = "Unequipped"
            for i = 1,#text do
                TextLabel.Text = string.sub(_text,1,i)
                wait(_delay)
            end
            wait(1)
            TextLabel.Visible = false
        else
            main:FireServer("ChangeTojiWapeon","Pistol")
	        local anim = Instance.new("Animation")
	        anim.AnimationId = "rbxassetid://95383474"
	        playAnim = humanoid:LoadAnimation(anim)
	        playAnim:Play()
            equipped = true
            TextLabel.Visible = true
            wait(.5)
            local _text = "Equipped"
            for i = 1,#text do
                TextLabel.Text = string.sub(_text,1,i)
                wait(_delay)
            end
            wait(1)
            TextLabel.Visible = false
        end
    end
end)

mouse.Button1Down:Connect(function()
    if equipped then
        main:FireServer("PistolShot")
	    local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://95383474"
	    local playAnim = humanoid:LoadAnimation(anim)
	    playAnim:Play()
        if mouse.Target then
            if mouse.Target.Parent.Humanoid then
                for i = 1,10 do
	    			main:FireServer("ThunderClapHitKnockback",mouse.Target.Parent)
	    		end
	    		main:FireServer("ThunderClapHitEnd",mouse.Target.Parent)
            end
        end
    end
end)

while task.wait() do
    if equipped then
        for _,v in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
            for i = 1,6 do
                if v.Animation.AnimationId:match(tostring(block[i])) then
                    v:Stop()
                end
            end
        end
    end
end

popup.Name = ".popup"
popup.Parent = gethui() or game.CoreGui
TextLabel.Name = " "
TextLabel.Parent = popup
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BackgroundTransparency = 0.500
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.0639070421, 0, 0.0527638197, 0)
TextLabel.Size = UDim2.new(0, 1200, 0, 100)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = ""
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
for i = 1,#text do
    TextLabel.Text = string.sub(text,1,i)
    wait(_delay)
end
wait(1)
TextLabel.Visible = false
