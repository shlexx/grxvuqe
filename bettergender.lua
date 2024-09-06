local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Better Gender", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})
local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "RNG"
})
Section:AddTextbox({
	Name = "Roll Number",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		game.ReplicatedStorage.Remotes.UpdateHighestNumber:FireServer(Value)
	end	  
})
local Section2 = Tab:AddSection({
	Name = "Obby"
})
Section2:AddButton({
	Name = "Instant Win",
	Callback = function()
      		local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = CFrame.new(533, 228, -257)
            wait(.5)
            hrp.CFrame = CFrame.new(554, 291, -162)
  	end    
})
Section2:AddButton({
	Name = "Delete Barrier",
	Callback = function()
      		workspace.Obby.Barrier:Destroy()
  	end    
})
Section2:AddButton({
	Name = "Break Timer",
	Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(554, 291, -162)
  	end    
})
local Section3 = Tab:AddSection({
	Name = "Color Picker"
})
Section3:AddButton({
	Name = "Anti-Void",
	Callback = function()
      		workspace.ColorMemory.FallBrick:Destroy()
  	end    
})
Section3:AddButton({
	Name = "Reveal Color",
	Callback = function()
      		for _,v in pairs(workspace.ColorMemory.Tiles:GetChildren()) do
     			v.Color = v.OriginalColor.Value
     			v.PartBorder:Destroy()
 			end
  	end    
})
local Section4 = Tab:AddSection({
	Name = "Glass Bridge"
})
Section4:AddButton({
	Name = "Delete Barrier",
	Callback = function()
      		workspace.GlassBridge.Barrier:Destroy()
  	end    
})
Section4:AddButton({
	Name = "Instant Win",
	Callback = function()
      		if game.Players.LocalPlayer.Team == game.Teams.Boys then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.GlassBridge.BoysGlassBridge.WinDetector.CFrame
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.GlassBridge.GirlsGlassBridge.WinDetector.CFrame
            end
  	end    
})
local Section5 = Tab:AddSection({
	Name = "Red Light Green Light"
})
Section5:AddButton({
	Name = "Delete Barrier",
	Callback = function()
      		workspace.RedLightGreenLight.Barrier:Destroy()
  	end    
})
Section5:AddButton({
	Name = "Instant Win",
	Callback = function()
      		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.RedLightGreenLight.WinDetector.CFrame
  	end    
})
local Section6 = Tab:AddSection({
	Name = "Friendliest"
})
Section6:AddButton({
	Name = "Show Chat History",
	Callback = function()
      		game:GetService("TextChatService").ChatWindowConfiguration.Enabled = true
  	end    
})
local Tab2 = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Tab2:AddTextbox({
	Name = "Walk Speed",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end	  
})
Tab2:AddTextbox({
	Name = "Jump Power",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
	end	  
})
Tab2:AddTextbox({
	Name = "Gravity",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		workspace.Gravity = Value
	end	  
})
Tab2:AddButton({
	Name = "Become A Boy (LOBBY)",
	Callback = function()
      		game.ReplicatedStorage.Remotes.SetGender:FireServer("L")
  	end    
})
Tab2:AddButton({
	Name = "Become A Girl (LOBBY)",
	Callback = function()
      		game.ReplicatedStorage.Remotes.SetGender:FireServer("R")
  	end    
})
Tab2:AddButton({
	Name = "Switch Gender (LOBBY)",
	Callback = function()
      		if game.Players.LocalPlayer.Team == game.Teams.Boys then
                game.ReplicatedStorage.Remotes.SetGender:FireServer("R")
            else
                game.ReplicatedStorage.Remotes.SetGender:FireServer("L")
            end
  	end    
})
Tab2:AddButton({
	Name = "Baseplate",
	Callback = function()
      		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(119, -8, -224)
  	end    
})
Tab2:AddButton({
	Name = "Infinite Yield",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
  	end    
})
OrionLib:Init()
