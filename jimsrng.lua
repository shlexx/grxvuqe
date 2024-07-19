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
	local nsauras = {
		"Ancient",
		"Arcade",
		"Gluttony",
		"Baseplate",
		"Nebula",
		"Earth",
		"Abomination",
		"Polychrome",
		"Asgore",
		"Cubed",
		"Greed",
		"Divinity",
		"Elderic",
		"Epic",
		"Exotica",
		"1x1x1x1x1",
		"Fractal",
		"Gambler",
		"Void",
		"Pride",
		"Legendary",
		"Limbo",
		"Portal",
		"Menacing",
		"Moyai",
		"Mythic",
		"Mythical",
		"Godlike",
		"Sakura",
		"Rare",
		"Remarkable",
		"Flame",
		"Speedster",
		"Speedy",
		"Steve",
		"Sloth",
		"Uncommon",
		"Unusual",
		"V2",
		"Cosmical",
		"Wrath",
		"Pi",
		"Rizzy",
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
		"Planet",
		"Justice",
		"BoyKisser",
		"Lust",
		"Cold",
		"Common",
		"Cupid",
		"Fisher",
		"Insanity",
		"Liquified",
		"MSpaint",
		"Ommetaphobia",
		"Peached",
		"Rancher",
		"Timeless",
		"Waltuh",
		"ClutterFunk",
		"<[DEBUGGER]>",
		"Fireworks",
		"Sparkler",
		"Barbaque",
	}

	local onesauras = {
		"Ancient Prophecy",
		"Supreme Calamitas",
		"Brick Wall",
		"Exotica Maxinus",
		"The Bloxxer",
		"Black Flame",
		"Jazz Zone",
		"Wishing Star",
		"Solar System",
		"The Rifter",
		"Brick Gate",
		"Flaming Overseer",
		"Light House",
		"Jazzy Hazard",
		"Mythical Constellations",
		"HELP ME", -- not a message lol, its an aura
		"Fractal Ruling",
		"Restless Gambler",
		"Insanity v2",
		"Soul Snatcher",
		"The Aegleseeker",
		"Sand Castle",
		"!!THE WATCHER!!",
		"Retro Baller",
		"SK8R B01!",
		"Poseidon's Wrath",
		"Mr. BEASTT!!!!!!!!!!!!!!",
		"Im Peached",
		"Fish Hunter",
		"Cosmic Being",
		"1 Grand",
		"Fractured Time",
	}
	
	local twosauras = {
		"Liquified : Surfer",
		"Arcade : Fireworks",
		"Arcade : Chroma",
		"Arcade : Hallowed",
		"Liquified : Waste",
		"The Almighty Divine",
		"The Leviathan Hunter",
		"The Leviathan Slayer",
		"19 Dolla Giftcard",
		"Limbo : Isolation",
		"Formatical : Jokester",
		"Formatical : Lover",
		"Cheese : Moon",
		"Gear : 5th",
		"Arcade : BOSSFIGHT",
		"Devourer of Gods",
		"FORMATICAL : BARRACUDA",
		"Abomination : BoyKisser",
		"Unusual : Cosmical",
		"The Brick Wall",
		"Wave - Form",
		"Exotica : TAKEOVER",
		"Exotica : APEX",
		"Arcade : グラインド地区",
		"Made In Heaven",
		"Void : Chaos",
		"Fractal : Singularity",
		"Exotica : OVERDRIVE",
		"Arcade : Classic",
		"Rifter : Classic",
	}
	
	local threesauras = {
		"Divinity : Biblically Accurate",
		"The Myth Of Demise",
		"Insanity : Lost Soul",
		"Cosmical Planet : Shaper",
		"Jimbo : Big Stick",
		"Formatical : Singularity Point",
		"Formatical : Thank You!",
		"ArchAngle, The Geometric Degrees",
		"Bad To The Bone",
		"1 Grand : Robux",
		"The Angel of Death",
		"Brick Gate : Legacy",
		"[Accurate : TON 618]",
		"The Seven Deadly Sins",
		"Formatical : BEAT BREAKER",
		"Exotica : PRIME APEX",
		"Brick Wall : Nature",
		"1 Grand : 2009",
		"Gabriel Judge Of Hell",
		"Exotica : FULL POWER",
		"Brick Wall : Legacy",
		"Wishing Star : Classic",
		"Bey, The Gambling One",
	}

	local foursauras = {
		"Fractured Reality : Singularity Point",
		"Darken Heart : Illuminated Illumina",
		"Singularity Point : TON 618",
		"Gabriel The Apostate Of Hate",
		"The Conceited, Devourer of Gods",
	}

	local fivesauras = {
		"Imaginary Technique : The 2nd Amendment",
	}

	local sixsauras = {
		"The True Common, The Conquerer of all",
	}
	if args[1] == "equip" then
		for i, v in nsauras do
			if v == args[2] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
		for i, v in onesauras do
			if v == args[2] .. " " .. args[3] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
		for i, v in twosauras do
			if v == args[2] .. " " .. args[3] .. " " .. args[4] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
		for i, v in threesauras do
			if v == args[2] .. " " .. args[3] .. " " .. args[4] .. " " .. args[5] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
		for i, v in foursauras do
			if v == args[2] .. " " .. args[3] .. " " .. args[4] .. " " .. args[5] .. " " .. args[6] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
		for i, v in fivesauras do
			if v == args[2] .. " " .. args[3] .. " " .. args[4] .. " " .. args[5] .. " " .. args[6] .. " " .. args[7] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
		for i, v in sixsauras do
			if v == args[2] .. " " .. args[3] .. " " .. args[4] .. " " .. args[5] .. " " .. args[6] .. " " .. args[7] .. " " .. args[8] then
				game:GetService("ReplicatedStorage").Remotes.AuraEquip:FireServer(game:GetService("ReplicatedStorage").Auras:FindFirstChild(v))
			end
		end
	elseif t == "unequip" then
		game:GetService("ReplicatedStorage").Remotes.AuraUnequipAll:FireServer()
	elseif args[1] == "cash" then
		game:GetService("ReplicatedStorage").Remotes.AddCash:FireServer(tonumber(args[2]))
	end
end)
