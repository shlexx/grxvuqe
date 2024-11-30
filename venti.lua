pcall(function()
   for i,v in pairs(workspace.Kitchen.Base["Ice Cream Machine"]["Ice Cream Machine"]:GetChildren()) do
      if v.Name == "ICV" then
         if v.PresentScript:FindFirstChild("iColor2") then
            v.Name = "CAVSIC"
         else
            if v.PresentScript.iColor.Value == BrickColor.new("Medium brown") then
               v.Name = "CIC"
            elseif v.PresentScript.iColor.Value == BrickColor.new("Dark blue") then
               v.Name = "BIC"
            elseif v.PresentScript.iColor.Value == BrickColor.new("Institutional White") then
               v.Name = "VIC"
            elseif v.PresentScript.iColor.Value == BrickColor.new("Carnation pink") then
               v.Name = "SIC"
            end
         end
      end
   end
   for i,v in pairs(workspace.Kitchen.Misc:GetChildren()) do
      if v.Name == "Soda Flavor" then
         if v.ColorPart.Color == Color3.fromRGB(86,66,54) then
            v.Name = "Cola"
         elseif v.ColorPart.Color == Color3.fromRGB(105,64,40) then
            v.Name = "Root Beer"
         elseif v.ColorPart.Color == Color3.fromRGB(75,151,75) then
            v.Name = "Lemon-Lime"
         end
      end
   end
end)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Venti Menu",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })
 function checkpos(posx,posy,posz,obj)
   if obj.Position == Vector3.new(posx,posy,posz) then
      return true
   else
      return false
   end
 end
 local Tab = Window:CreateTab("Items", 4483362458) -- Title, Image
 local Section = Tab:CreateSection("Cups")
 local Button = Tab:CreateButton({
    Name = "Tall Cup",
    Callback = function()
    local giver = workspace.Kitchen.Base.Cups
    for _,v in pairs(giver:GetChildren()) do
    if checkpos(-14.099135398864746, 16.056093215942383, 92.70189666748047,v.Cups.Tall.Giver) then
    fireclickdetector(v.Cups.Tall.Giver.ClickDetector)
    end
    end
    end,
 })
 local Button2 = Tab:CreateButton({
    Name = "Grande Cup",
    Callback = function()
    local giver = workspace.Kitchen.Base.Cups
    for _,v in pairs(giver:GetChildren()) do
    if checkpos(-14.944214820861816, 16.166091918945312, 92.76334381103516,v.Cups.Grande.Giver) then
    fireclickdetector(v.Cups.Grande.Giver.ClickDetector)
    end
    end
    end,
 })
 local Button3 = Tab:CreateButton({
    Name = "Venti Cup",
    Callback = function()
    local giver = workspace.Kitchen.Base.Cups
    for _,v in pairs(giver:GetChildren()) do
    if checkpos(-15.89919376373291, 16.108858108520508, 92.7633285522461,v.Cups.Venti.Giver) then
    fireclickdetector(v.Cups.Venti.Giver.ClickDetector)
    end
    end
    end,
 })
 local Button4 = Tab:CreateButton({
    Name = "Jar",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Seasonal.Mugs.Mugs.Giver.ClickDetector)
    end,
 })
 local Section2 = Tab:CreateSection("Pastries")
 local Button5 = Tab:CreateButton({
    Name = "Cake",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries.Cake.Click.ClickDetector)
    end,
 })
 local Button6 = Tab:CreateButton({
    Name = "Birthday Cakepop",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries.Cakepops.BirthdayCakepop.Giver.ClickDetector)
    end,
 })
 local Button7 = Tab:CreateButton({
    Name = "Chocolate Cakepop",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries.Cakepops.ChocolateCakepop.Giver.ClickDetector)
    end,
 })
 local Button8 = Tab:CreateButton({
    Name = "Strawberry Cakepop",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries.Cakepops.StrawberryCakepop.Giver.ClickDetector)
    end,
 })
 local Button9 = Tab:CreateButton({
    Name = "Vanilla Cakepop",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries.Cakepops.VanillaCakepop.Giver.ClickDetector)
    end,
 })
 local Button10 = Tab:CreateButton({
    Name = "Chocolate Chip Cookie",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries["Chocolate Chip Cookie"].Click.ClickDetector)
    end,
 })
 local Button11 = Tab:CreateButton({
    Name = "Muffin",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries.Muffin.Click.ClickDetector)
    end,
 })
 local Button12 = Tab:CreateButton({
    Name = "Pie",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries.Pie.Click.ClickDetector)
    end,
 })
 local Button13 = Tab:CreateButton({
    Name = "Smore",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries.Smore.Click.ClickDetector)
    end,
 })
 local Button14 = Tab:CreateButton({
    Name = "Sugar Cookie",
    Callback = function()
        fireclickdetector(workspace.Kitchen.Base.Pastries.Pastries.Pastries["Sugar Cookie"].Click.ClickDetector)
    end,
 })
 local Section3 = Tab:CreateSection("Other Stuff")
 function apply(obj)
    getgenv().op = obj.CFrame
    obj.CFrame = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Handle.CFrame
    task.wait()
    obj.CFrame = getgenv().op
 end
 local Button15 = Tab:CreateButton({
    Name = "Blender",
    Callback = function()
        apply(workspace.Kitchen.Base.Blender.Blender.Touch)
    end,
 })
 local Button16 = Tab:CreateButton({
   Name = "Cream",
   Callback = function()
       apply(workspace.Kitchen.Base.Cream.Cream.Touch)
   end,
})
local Button17 = Tab:CreateButton({
   Name = "Cappuccino",
   Callback = function()
       apply(workspace.Kitchen.Base["Hot Drink Dispenser"].Cappuccino.Touch)
   end,
})
local Button18 = Tab:CreateButton({
   Name = "Decaf",
   Callback = function()
       apply(workspace.Kitchen.Base["Hot Drink Dispenser"].Decaf.Touch)
   end,
})
local Button19 = Tab:CreateButton({
   Name = "Espresso",
   Callback = function()
       apply(workspace.Kitchen.Base["Hot Drink Dispenser"].Espresso.Touch)
   end,
})
local Button20 = Tab:CreateButton({
   Name = "Frappe",
   Callback = function()
       apply(workspace.Kitchen.Base["Hot Drink Dispenser"].Frappe.Touch)
   end,
})
local Button21 = Tab:CreateButton({
   Name = "Hot Water",
   Callback = function()
       apply(workspace.Kitchen.Base["Hot Drink Dispenser"]["Hot Water"].Touch)
   end,
})
local Button22 = Tab:CreateButton({
   Name = "Latte",
   Callback = function()
       apply(workspace.Kitchen.Base["Hot Drink Dispenser"].Latte.Touch)
   end,
})
local Button23 = Tab:CreateButton({
   Name = "Mocha",
   Callback = function()
       apply(workspace.Kitchen.Base["Hot Drink Dispenser"].Mocha.Touch)
   end,
})
local Button24 = Tab:CreateButton({
   Name = "Regular",
   Callback = function()
       apply(workspace.Kitchen.Base["Hot Drink Dispenser"].Regular.Touch)
   end,
})
local Button25 = Tab:CreateButton({
   Name = "Chocolate Ice Cream",
   Callback = function()
       apply(workspace.Kitchen.Base["Ice Cream Machine"]["Ice Cream Machine"].CIC)
   end,
})
local Button26 = Tab:CreateButton({
   Name = "Chocolate And Vanilla Swirl Ice Cream",
   Callback = function()
       apply(workspace.Kitchen.Base["Ice Cream Machine"]["Ice Cream Machine"].CAVSIC)
   end,
})
local Button27 = Tab:CreateButton({
   Name = "Blueberry Ice Cream",
   Callback = function()
       apply(workspace.Kitchen.Base["Ice Cream Machine"]["Ice Cream Machine"].BIC)
   end,
})
local Button28 = Tab:CreateButton({
   Name = "Vanilla Ice Cream",
   Callback = function()
       apply(workspace.Kitchen.Base["Ice Cream Machine"]["Ice Cream Machine"].VIC)
   end,
})
local Button29 = Tab:CreateButton({
   Name = "Strawberry Ice Cream",
   Callback = function()
       apply(workspace.Kitchen.Base["Ice Cream Machine"]["Ice Cream Machine"].SIC)
   end,
})
local Button30 = Tab:CreateButton({
   Name = "Ice",
   Callback = function()
       apply(workspace.Kitchen.Base["Ice Dispenser"].Ice.Touch)
   end,
})
local Button31 = Tab:CreateButton({
   Name = "Microwave",
   Callback = function()
       apply(workspace.Kitchen.Base.Microwave.Microwave.Touch)
   end,
})
local Button32 = Tab:CreateButton({
   Name = "Choco Milk",
   Callback = function()
       apply(workspace.Kitchen.Base.Milk["Choco Milk"].Touch)
   end,
})
local Button33 = Tab:CreateButton({
   Name = "Milk",
   Callback = function()
       apply(workspace.Kitchen.Base.Milk.Milk.Touch)
   end,
})
local Button34 = Tab:CreateButton({
   Name = "Strawberry Milk",
   Callback = function()
       apply(workspace.Kitchen.Base.Milk["Straw Milk"].Touch)
   end,
})
local Button35 = Tab:CreateButton({
   Name = "Butterscotch Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Butterscotch.Touch)
   end,
})
local Button36 = Tab:CreateButton({
   Name = "Caramel Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Caramel.Touch)
   end,
})
local Button37 = Tab:CreateButton({
   Name = "Chocolate Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Chocolate.Touch)
   end,
})
local Button38 = Tab:CreateButton({
   Name = "Cinnamon Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Cinnamon.Touch)
   end,
})
local Button40 = Tab:CreateButton({
   Name = "Lavender Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Lavender.Touch)
   end,
})
local Button41 = Tab:CreateButton({
   Name = "Lemon Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Lemon.Touch)
   end,
})
local Button42 = Tab:CreateButton({
   Name = "Oreo Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Oreo.Touch)
   end,
})
local Button43 = Tab:CreateButton({
   Name = "Strawberry Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Strawberry.Touch)
   end,
})
local Button44 = Tab:CreateButton({
   Name = "Vanilla Milkshake",
   Callback = function()
       apply(workspace.Kitchen.Base["Milkshake Flavor"].Vanilla.Touch)
   end,
})
local Button45 = Tab:CreateButton({
   Name = "Banana Smoothie",
   Callback = function()
       apply(workspace.Kitchen.Base.Smoothie.Banana.Touch)
   end,
})
local Button46 = Tab:CreateButton({
   Name = "Caribbean Getaway Smoothie",
   Callback = function()
       apply(workspace.Kitchen.Base.Smoothie["Caribbean Getaway"].Touch)
   end,
})
local Button47 = Tab:CreateButton({
   Name = "Kiwi Blast Smoothie",
   Callback = function()
       apply(workspace.Kitchen.Base.Smoothie["Kiwi Blast"].Touch)
   end,
})
local Button48 = Tab:CreateButton({
   Name = "Lemon Dash Smoothie",
   Callback = function()
       apply(workspace.Kitchen.Base.Smoothie["Lemon Dash"].Touch)
   end,
})
local Button49 = Tab:CreateButton({
   Name = "Mango Smoothie",
   Callback = function()
       apply(workspace.Kitchen.Base.Smoothie.Mango.Touch)
   end,
})
local Button50 = Tab:CreateButton({
   Name = "Strawberry Smoothie",
   Callback = function()
       apply(workspace.Kitchen.Base.Smoothie.Strawberry.Touch)
   end,
})
local Button51 = Tab:CreateButton({
   Name = "Tropical Paradise Smoothie",
   Callback = function()
       apply(workspace.Kitchen.Base.Smoothie["Tropical Paradise"].Touch)
   end,
})
local Button52 = Tab:CreateButton({
   Name = "Sugar",
   Callback = function()
       apply(workspace.Kitchen.Base.Sugar.Sugar.Touch)
   end,
})
local Button53 = Tab:CreateButton({
   Name = "Tea",
   Callback = function()
       apply(workspace.Kitchen.Base.Tea.Tea.Tea)
   end,
})
local Button54 = Tab:CreateButton({
   Name = "Water",
   Callback = function()
       apply(workspace.Kitchen.Base.Water.Water.Part)
   end,
})
local Button55 = Tab:CreateButton({
   Name = "Carbonated Water",
   Callback = function()
       local touch = nil
       for _,v in pairs(workspace.Kitchen.Misc["Carbonated Water"].Water:GetChildren()) do
         if v:FindFirstChild("PresentScript") then
            touch = v
         end
       end
       apply(touch)
   end,
})
local Button56 = Tab:CreateButton({
   Name = "Orange Juice",
   Callback = function()
       apply(workspace.Kitchen.Misc["Orange Juice"].Touch)
   end,
})
local Button57 = Tab:CreateButton({
   Name = "Pancake Milk",
   Callback = function()
       apply(workspace.Kitchen.Misc["Pancake Milk"].Touch)
   end,
})
local Button58 = Tab:CreateButton({
   Name = "Cola Soda",
   Callback = function()
       apply(workspace.Kitchen.Misc.Cola.t)
   end,
})
local Button59 = Tab:CreateButton({
   Name = "Root Beer Soda",
   Callback = function()
       apply(workspace.Kitchen.Misc["Root Beer"].t)
   end,
})
local Button60 = Tab:CreateButton({
   Name = "Lemon-Lime Soda",
   Callback = function()
       apply(workspace.Kitchen.Misc["Lemon-Lime"].t)
   end,
})
local Button61 = Tab:CreateButton({
   Name = "Chocolate Toppings",
   Callback = function()
       apply(workspace.Kitchen.Seasonal["Chocolate Toppings"]["Chocolate Toppings"].Touch)
   end,
})
local Button62 = Tab:CreateButton({
   Name = "Cinnamon Toppings",
   Callback = function()
       apply(workspace.Kitchen.Seasonal["Cinnamon Toppings"]["Cinnamon Toppings"].Touch)
   end,
})
local Button63 = Tab:CreateButton({
   Name = "Pumpkin Spice",
   Callback = function()
       apply(workspace.Kitchen.Seasonal["Pumpkin Spice"]["Pumpkin Spice"].Touch)
   end,
})
local Button64 = Tab:CreateButton({
   Name = "Strawberry Toppings",
   Callback = function()
       apply(workspace.Kitchen.Seasonal["Strawberry Toppings"]["Strawberry Toppings"].Touch)
   end,
})
local Tab2 = Window:CreateTab("Others", 4483362458) -- Title, Image
local Button65 = Tab2:CreateButton({
   Name = "Teleport To Venti Cafe V4 Walkthrough Teaser",
   Callback = function()
      game["Teleport Service"]:Teleport(97975225016396)
   end,
})
local Button66 = Tab2:CreateButton({
   Name = "Teleport To Events",
   Callback = function()
      game["Teleport Service"]:Teleport(15591145480)
   end,
})
local Button67 = Tab2:CreateButton({
   Name = "Teleport To Training Servers",
   Callback = function()
      game["Teleport Service"]:Teleport(8809708977)
   end,
})
local Button68 = Tab2:CreateButton({
   Name = "Delete Gamepass Barriers",
   Callback = function()
      for i,v in pairs(workspace["Gamepass Access"]:GetChildren()) do
         v:ClearAllChildren()
      end
   end,
})
local Button69 = Tab2:CreateButton({
   Name = "Get Thanksgiving Turkey",
   Callback = function()
      fireclickdetector(workspace["Tanksgiving Turkey"].ClickDetector)
   end,
})
local Button70 = Tab2:CreateButton({
   Name = "Get Cave Badge",
   Callback = function()
      firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,workspace.CaveBadge,0)
   end,
})
local Button71 = Tab2:CreateButton({
   Name = "Get Uniform (Barista)",
   Callback = function()
      firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,workspace["Staff Access"]["Uniform Givers"].Giver,0)
   end,
})
local Input = Tab2:CreateInput({
   Name = "Spoof Weekly Minutes",
   CurrentValue = "",
   PlaceholderText = "Number",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
   game.Players.LocalPlayer.WeeklyMinutes.Value = Text
   end,
})
local Button72 = Tab2:CreateButton({
   Name = "Teleport To Premium Lounge",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-76.3866272, -307.768921, 719.287659)
   end,
})
local Button73 = Tab2:CreateButton({
   Name = "Get Ice Cream",
   Callback = function()
    local giver = workspace.Kitchen.Base["Ice Cream Machine"]
    for _,v in pairs(giver:GetChildren()) do
    if checkpos(-97.60598754882812, -15.197429656982422, 56.89369201660156,v.Model["Empty Cone"]) then
    fireclickdetector(v.Model["Empty Cone"].ClickDetector)
    end
    end
   end,
})
local Input = Tab2:CreateInput({
   Name = "Fill Player's Inventory",
   CurrentValue = "",
   PlaceholderText = "Player Name",
   RemoveTextAfterFocusLost = false,
   Flag = "Input2",
   Callback = function(Text)
      for i = 1,100 do
         fireclickdetector(workspace.Kitchen.Seasonal.Mugs.Mugs.Giver.ClickDetector)
         task.wait(.1)
      end
      game.ReplicatedStorage.HandTo:FireServer(game.Players[Text],{"Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar","Jar"})
   end,
})
local Input = Tab2:CreateInput({
   Name = "Spam Notifications",
   CurrentValue = "",
   PlaceholderText = "Player Name",
   RemoveTextAfterFocusLost = false,
   Flag = "Input3",
   Callback = function(Text)
      while task.wait() do
      game.ReplicatedStorage.HandTo:FireServer(game.Players[Text],{"i"})
      end
   end,
})
Rayfield:LoadConfiguration()
