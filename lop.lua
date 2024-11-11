local isheadless = false
local iskorblox = false
local emotes = {}
local tags = {}
local booths = {}
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Like Or Pass",
   LoadingTitle = "Hub",
   LoadingSubtitle = "by LOUDAUDlOS",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image
local Input = Tab:CreateInput({
   Name = "Get Super Likes",
   PlaceholderText = "Number",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   for i = 1, Text do
   game.ReplicatedStorage.RewardEvents.GiveReward:FireServer("3")
   end
   end,
})
local Input5 = Tab:CreateInput({
   Name = "Get Money",
   PlaceholderText = "Number",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ShrinkPlayer",Key="x5",Cash=-Text})
   end,
})
local Button = Tab:CreateButton({
   Name = "Infinite Money",
   Callback = function()
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ShrinkPlayer",Key="x5",Cash=-9223372036854774000})
   end,
})
local Button2 = Tab:CreateButton({
   Name = "Get Everything",
   Callback = function()
   for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Shop.Tabs.Tags.Holder:GetChildren()) do
   if v.Name ~= "UIGridLayout" then
   table.insert(tags,v.Name)
   end
   end
   for _,v in pairs(workspace.newemotes.AnimSaves:GetChildren()) do
   table.insert(emotes,v.Name)
   end
   for _,v in pairs(workspace.Booths:GetChildren()) do
   table.insert(booths,v.Name)
   end
   game:GetService("ReplicatedStorage").Events.Buy:FireServer("Blow A Kiss","Emote",emotes,tags,booths)
   end,
})
local Button3 = Tab:CreateButton({
   Name = "Money Bomb",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="GiveMoney",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end,
})
local Button4 = Tab:CreateButton({
   Name = "Lag Server",
   Callback = function()
   for i = 1,100 do
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="GiveMoney",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(game.Players.LocalPlayer.Name)
   end
   end,
})
local Input3 = Tab:CreateInput({
   Name = "Money Bomb Player",
   PlaceholderText = "Name",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   for i = 1,10 do
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="GiveMoney",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(Text)
   end
   end,
})
local Dropdown = Tab:CreateDropdown({
   Name = "Equip Unreleased Booths",
   Options = {"Shoot for the stars","Halloween Booth","Freaky booth","Cute Unicorn"},
   CurrentOption = {"Option 1"},
   MultipleOptions = false,
   Flag = "Dropdown1",
   Callback = function(Option)
   game.ReplicatedStorage.Events.SetEquippedBooth:FireServer(Option)
   end,
})
local Button5 = Tab:CreateButton({
   Name = "Enlarge All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="EnlargePlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end
   end,
})
local Button6 = Tab:CreateButton({
   Name = "Shrink All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ShrinkPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end
   end,
})
local Button7 = Tab:CreateButton({
   Name = "Slap All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="SlapPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end
   end,
})
local Button8 = Tab:CreateButton({
   Name = "Explode All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ExplodePlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end
   end,
})
local Button9 = Tab:CreateButton({
   Name = "Clown All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ClownPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end
   end,
})
local Button13 = Tab:CreateButton({
   Name = "Big Head All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="BigHead",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end
   end,
})
local Button14 = Tab:CreateButton({
   Name = "Bacon Hair All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="BaconHead",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end
   end,
})
local Button10 = Tab:CreateButton({
   Name = "Kill All (~4 secs)",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ShrinkPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   task.wait(.1)
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="SlapPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   task.wait(.1)
   end
   end
   end,
})
local Input4 = Tab:CreateInput({
   Name = "Kill Player",
   PlaceholderText = "Name",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ShrinkPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(Text)
   task.wait(.1)
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="SlapPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(Text)
   end,
})
local Button15 = Tab:CreateButton({
   Name = "TP to VC servers",
   Callback = function()
   game:GetService("TeleportService"):Teleport(89586208269430)
   end,
})
local Button16 = Tab:CreateButton({
   Name = "TP to Normal servers",
   Callback = function()
   game:GetService("TeleportService"):Teleport(107640846225330)
   end,
})
local Button11 = Tab:CreateButton({
   Name = "Atom",
   Callback = function()
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({BodyScale={BodyTypeScale=0,HeadScale=0.10000000149011612,HeightScale=0.10000000149011612,WidthScale=0.10000000149011612,ProportionScale=0}})
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ShrinkPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(game.Players.LocalPlayer.Name)
   end,
})
local ColorPicker = Tab:CreateColorPicker({
    Name = "Body Color3",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ColorPicker1",
    Callback = function(Value)
    game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({BodyColor=Value})
    end
})
local Button12 = Tab:CreateButton({
   Name = "Headless On/Off",
   Callback = function()
   if isheadless then
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=0,Property="Head"})
   isheadless = false
   else
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=15093053680,Property="Head"})
   isheadless = true
   end
   end,
})
local Button12 = Tab:CreateButton({
   Name = "Korblox On/Off",
   Callback = function()
   if iskorblox then
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=0,Property="RightLeg"})
   iskorblox = false
   else
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=139607718,Property="RightLeg"})
   iskorblox = true
   end
   end,
})
local Input5 = Tab:CreateInput({
   Name = "Apply Accessory",
   PlaceholderText = "ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AccessoryData={Order=1,AccessoryType=Enum.AccessoryType.Unknown,AssetId=Text}})
   end,
})
local Input6 = Tab:CreateInput({
   Name = "Apply Shirt",
   PlaceholderText = "ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=Text,Property="Shirt"})
   end,
})
local Input7 = Tab:CreateInput({
   Name = "Apply T-Shirt",
   PlaceholderText = "ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=Text,Property="GraphicTShirt"})
   end,
})
local Input8 = Tab:CreateInput({
   Name = "Apply Pants",
   PlaceholderText = "ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=Text,Property="Pants"})
   end,
})
local Input9 = Tab:CreateInput({
   Name = "Remove Accessory",
   PlaceholderText = "ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=Text})
   end,
})
local Input6 = Tab:CreateInput({
   Name = "Remove Shirt",
   PlaceholderText = "ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=0,Property="Shirt"})
   end,
})
local Input7 = Tab:CreateInput({
   Name = "Remove T-Shirt",
   PlaceholderText = "ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=0,Property="GraphicTShirt"})
   end,
})
local Input8 = Tab:CreateInput({
   Name = "Remove Pants",
   PlaceholderText = "ID",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   game.ReplicatedStorage.BloxbizRemotes.CatalogOnApplyToRealHumanoid:FireServer({AssetId=0,Property="Pants"})
   end,
})
Rayfield:LoadConfiguration()
