local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Like Or Pass",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
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
   local args = {
    [1] = "Blow a Kiss",
    [2] = "Emote",
    [3] = {
        [1] = "Salute",
        [2] = "Sleepy",
        [3] = "Facepalm",
        [4] = "Clapping",
        [5] = "Sobbing",
        [6] = "Shhh",
        [7] = "Hairflip",
        [8] = "Skibidi Toilet",
        [9] = "Pushup",
        [10] = "Hairflip 2",
        [11] = "Muscle Flex",
        [12] = "Handstand",
        [13] = "Cheerleading",
        [14] = "Sparring",
        [15] = "Blow a Kiss"
    },
    [4] = {
        [1] = "Broke Boy",
        [2] = "Homeless",
        [3] = "L Rizz",
        [4] = "Unspoken Rizz",
        [5] = "Sigma Rizzler",
        [6] = "Ohio Gyatt",
        [7] = "Smooth Operator",
        [8] = "Angel \240\159\152\135",
        [9] = "Certified Rizzler",
        [10] = "Queen",
        [11] = "Dread Shaker",
        [12] = "The Baddest",
        [13] = "Bands Generator"
    },
    [5] = {
        [1] = "My Fast Food",
        [2] = "Lego",
        [3] = "Early Halloween",
        [4] = "Infinite Luck",
        [5] = "Bandz Generator",
        [6] = "Mr Richest",
        [7] = "The Queen",
        [8] = "Candy Booth",
        [9] = "Galactico",
        [10] = "Hearts",
        [11] = "Cute Flower",
        [12] = "Mr Aura",
        [13] = "Web Booth",
        [14] = "Black Hole",
        [15] = "Shoot for the stars",
        [16] = "Halloween Booth",
        [17] = "Freaky booth",
        [18] = "Cute Unicorn"
    }
}

game:GetService("ReplicatedStorage").Events.Buy:FireServer(unpack(args))
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
   Name = "Lag/Crash Server",
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
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="EnlargePlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end,
})
local Button6 = Tab:CreateButton({
   Name = "Shrink All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ShrinkPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end,
})
local Button7 = Tab:CreateButton({
   Name = "Slap All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="SlapPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end,
})
local Button8 = Tab:CreateButton({
   Name = "Explode All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ExplodePlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end,
})
local Button9 = Tab:CreateButton({
   Name = "Clown All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ClownPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   end
   end,
})
local Button9 = Tab:CreateButton({
   Name = "Kill All",
   Callback = function()
   for _,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="ShrinkPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
   task.wait(.1)
   game.ReplicatedStorage.Events.PurchaseTroll:InvokeServer({ItemName="SlapPlayer",Key="x5",Cash=0})
   game.ReplicatedStorage.Events.TrollPlayer:FireServer(v.Name)
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
Rayfield:LoadConfiguration()
