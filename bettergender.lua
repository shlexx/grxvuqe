local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Better Gender",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "gender"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})
local Tab = Window:CreateTab("Main", 4483362458)
local Section = Tab:CreateSection("RNG")
local Input = Tab:CreateInput({
   Name = "Roll Number",
   PlaceholderText = "",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.Remotes.UpdateHighestNumber:FireServer(Text)
   end,
})
local Section2 = Tab:CreateSection("Obby")
local Button = Tab:CreateButton({
   Name = "Instant Win",
   Callback = function()
   local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
   hrp.CFrame = CFrame.new(533, 228, -257)
   wait(.5)
   hrp.CFrame = CFrame.new(554, 291, -162)
   end,
})
local Button2 = Tab:CreateButton({
   Name = "Delete Barrier",
   Callback = function()
   workspace.Obby.Barrier:Destroy()
   end,
})
local Button3 = Tab:CreateButton({
   Name = "Break Timer",
   Callback = function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(554, 291, -162)
   end,
})
local Section3 = Tab:CreateSection("Color Picker")
local Button4 = Tab:CreateButton({
   Name = "Anti-Void",
   Callback = function()
   workspace.ColorMemory.FallBrick:Destroy()
   end,
})
local Button5 = Tab:CreateButton({
   Name = "Reveal Color",
   Callback = function()
   for _,v in pairs(workspace.ColorMemory.Tiles:GetChildren()) do
   v.Color = v.OriginalColor.Value
   v.PartBorder:Destroy()
   end
   end,
})
local Section4 = Tab:CreateSection("Glass Bridge")
local Button6 = Tab:CreateButton({
   Name = "Delete Barrier",
   Callback = function()
   workspace.GlassBridge.Barrier:Destroy()
   end,
})
local Button7 = Tab:CreateButton({
   Name = "Instant Win",
   Callback = function()
   if game.Players.LocalPlayer.Team == game.Teams.Boys then
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.GlassBridge.BoysGlassBridge.WinDetector.CFrame
   else
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.GlassBridge.GirlsGlassBridge.WinDetector.CFrame
   end
   end,
})
local Section5 = Tab:CreateSection("Red Light Green Light")
local Button8 = Tab:CreateButton({
   Name = "Delete Barrier",
   Callback = function()
   workspace.RedLightGreenLight.Barrier:Destroy()
   end,
})
local Button9 = Tab:CreateButton({
   Name = "Instant Win",
   Callback = function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.RedLightGreenLight.WinDetector.CFrame
   end,
})
local Section6 = Tab:CreateSection("Friendliest")
local Button10 = Tab:CreateButton({
   Name = "Show Chat History",
   Callback = function()
   game:GetService("TextChatService").ChatWindowConfiguration.Enabled = true
   end,
})
local Section7 = Tab:CreateSection("Teddy")
local Button11 = Tab:CreateButton({
   Name = "ESP",
   Callback = function()
   if Value then
   local obj = workspace.FindMap.Teddy
   local hl = Instance.new("BoxHandleAdornment",obj)
   hl.Adornee = obj
   hl.AlwaysOnTop = true
   hl.ZIndex = 1
   hl.Size = Vector3.new(4,4,4)
   hl.Color3 = Color3.new(255,255,255)
   else
   workspace.FindMap.Teddy.BoxHandleAdornment:Destroy()
   end
   end,
})
local Button12 = Tab:CreateButton({
   Name = "Find Teddy",
   Callback = function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.FindMap.Teddy
   end,
})
local Tab2 = Window:CreateTab("Misc", 4483362458)
local Input2 = Tab2:CreateInput({
   Name = "Walk Speed",
   PlaceholderText = "",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Text
   end,
})
local Input3 = Tab2:CreateInput({
   Name = "Jump Power",
   PlaceholderText = "",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.Players.LocalPlayer.Character.Humanoid.JumpPower = Text
   end,
})
local Input4 = Tab2:CreateInput({
   Name = "Gravity",
   PlaceholderText = "",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   workspace.Gravity = Text
   end,
})
local Button13 = Tab2:CreateButton({
   Name = "Became A Boy (LOBBY)",
   Callback = function()
   game.ReplicatedStorage.Remotes.SetGender:FireServer("L")
   end,
})
local Button14 = Tab2:CreateButton({
   Name = "Became A Girl (LOBBY)",
   Callback = function()
   game.ReplicatedStorage.Remotes.SetGender:FireServer("R")
   end,
})
local Button15 = Tab2:CreateButton({
   Name = "Switch Gender (LOBBY)",
   Callback = function()
   if game.Players.LocalPlayer.Team == game.Teams.Boys then
   game.ReplicatedStorage.Remotes.SetGender:FireServer("R")
   else
   game.ReplicatedStorage.Remotes.SetGender:FireServer("L")
   end
   end,
})
local Button16 = Tab2:CreateButton({
   Name = "Baseplate",
   Callback = function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(119, -8, -224)
   end,
})
local Button17 = Tab2:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   end,
})
Rayfield:LoadConfiguration()
