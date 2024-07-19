local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(1, 1)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(1, 0, 1.00100005, 0)
Frame.Size = UDim2.new(0, 150, 0, 50)

TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(-4.2317708e-05, 0, -0.0245114136, 0)
TextBox.Size = UDim2.new(0, 150, 0, 25)
TextBox.Font = Enum.Font.SourceSansBold
TextBox.PlaceholderText = "ENTER CHEAT CODE"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14.000
TextBox.ClearTextOnFocus = false

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(-4.2317708e-05, 0, 0.474089652, 0)
TextButton.Size = UDim2.new(0, 150, 0, 25)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "execute"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14.000
TextButton.MouseButton1Click:Connect(function()
	local t = TextBox.Text
	local args = t:split(" ")
	local auras = {
		"Ancient",
		"Ancient Prophecy",
		"The Conceited, Devourer of Gods",
		"Arcade",
		"Gluttony",
		"Baseplate",
		"Bey, The Gambling One",
		"Nebula",
		"Earth",
		"Rifter : Classic",
		"Wishing Star : Classic",
		"Supreme Calamitas",
		"Abomination",
		"Polychrome",
		"Asgore",
		"Brick Wall",
		"Cubed",
		"Arcade : Classic",
		"Greed",
		"Divinity",
		"Elderic",
		"Epic",
		"Exotica",
		"Exotica : FULL POWER",
		"Exotica Maxinus",
		"Exotica : OVERDRIVE",
		"The Bloxxer",
		"Brick Wall : Legacy",
		"Black Flame",
		"1x1x1x1x1",
		"Fractal",
		"Fractal : Singularity",
		"Singularity Point : TON 618",
		"Fractured Time",
		"Gabriel Judge Of Hell",
		"Gabriel The Apostate Of Hate",
		"Gambler",
		"1 Grand : 2009",
		"Void : Chaos",
		"Void",
		"Brick Wall : Nature",
		"Jazz Zone",
		"Pride",
		"Legendary",
		"Limbo",
		"Portal",
		"Exotica : APEX",
		"Arcade : グラインド地区",
		"Made In Heaven",
		"Menacing",
		"Exotica : PRIME APEX",
		"Moyai",
		"Mythic",
		"Mythical",
		"Mythical Constellations",
		"Formatical : BEAT BREAKER",
		"Wishing Star",
		"Godlike",
		"Sakura",
		"Rare",
		"Remarkable",
		"Exotica : TAKEOVER",
		"Flame",
		"Solar System",
		"Speedster",
		"Speedy",
		"Steve",
		"The Brick Wall",
		"Wave - Form",
		"Sloth",
		"The Rifter",
		"The Seven Deadly Sins",
		"Uncommon",
		"Unusual",
		"Unusual : Cosmical",
		"V2",
		"Cosmical",
		"Brick Gate",
		"Wrath",
		"Pi",
		"Rizzy",
		"Abomination : BoyKisser",
		"Envy",
		"Cheese",
		"Ruler",
		"Uranus",
		"Jupiter",
		"Neptune",
		"Mercury",
		"Venus",
		"Saturn",
		"Mars",
		"Smited",
		"FORMATICAL : BARRACUDA",
		"Planet",
		"Flaming Overseer",
		"Justice",
		"[Accurate : TON 618]",
		"BoyKisser",
		"1 Grand : Robux",
		"The Angel of Death",
		"Light House",
		"Devourer of Gods",
		"Brick Gate : Legacy",
		"Lust",
		"Cold",
		"Jazzy Hazard",
		"Gear : 5th",
		"Arcade : BOSSFIGHT",
		"Common",
		"1 Grand",
		"ArchAngle, The Geometric Degrees",
		"Bad To The Bone",
		"Cheese : Moon",
		"Cosmic Being",
		"Cupid",
		"Darken Heart : Illuminated Illumina",
		"Fish Hunter",
		"Fisher",
		"Formatical : Jokester",
		"Formatical : Lover",
		"Formatical : Singularity Point",
		"Formatical : Thank You!",
		"Fractured Reality : Singularity Point",
		"HELP ME", -- not a message lol, its an aura
		"Im Peached",
		"Imaginary Technique : The 2nd Amendment",
		"Insanity",
		"Jimbo : Big Stick",
		"Limbo : Isolation",
		"Liquified",
		"MSpaint",
		"Mr. BEASTT!!!!!!!!!!!!!!",
		"19 Dolla Giftcard",
		"Ommetaphobia",
		"Peached",
		"Poseidon's Wrath",
		"Rancher",
		"Retro Baller",
		"SK8R B01!",
		"Sand Castle",
		"!!THE WATCHER!!",
		"The Aegleseeker",
		"The Almighty Divine",
		"The Leviathan Hunter",
		"The Leviathan Slayer",
		"Timeless",
		"Waltuh",
		"The True Common, The Conquerer of all",
		"Cosmical Planet : Shaper",
		"ClutterFunk",
		"Liquified : Waste",
		"<[DEBUGGER]>",
		"Soul Snatcher",
		"The Myth Of Demise",
		"Arcade : Hallowed",
		"Restless Gambler",
		"Insanity v2",
		"Insanity : Lost Soul",
		"Arcade : Fireworks",
		"Arcade : Chroma",
		"Fireworks",
		"Sparkler",
		"Fractal Ruling",
		"Divinity : Biblically Accurate",
		"Liquified : Surfer",
		"Barbaque",
	}
	if args[1] == "equip" then
		for i, v in auras do
			if v == args[2] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
	elseif t == "unequip" then
		game:GetService("ReplicatedStorage").Remotes.AuraUnequipAll:FireServer()
	elseif args[1] == "cash" then
		game:GetService("ReplicatedStorage").Remotes.AddCash:FireServer(tonumber(args[2]))
	end
end)
