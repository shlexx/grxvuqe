local isblessing = false
local isopened = false
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Name = Instance.new("TextLabel")
local moni1 = Instance.new("TextBox")
local getmoni1 = Instance.new("TextButton")
local moni2 = Instance.new("TextBox")
local getmoni2 = Instance.new("TextButton")
local pleyer = Instance.new("TextBox")
local blesing = Instance.new("TextButton")
local stopblesing = Instance.new("TextButton")
local neutral = Instance.new("TextButton")
local kilears = Instance.new("TextButton")
local zomber = Instance.new("TextButton")
local walkis = Instance.new("TextButton")
local sumface = Instance.new("TextBox")
local acesory = Instance.new("TextButton")
local filllot = Instance.new("TextButton")
local getface = Instance.new("TextButton")
local acesoryget = Instance.new("TextBox")
local changeshirte = Instance.new("TextButton")
local shirtes = Instance.new("TextBox")
local changepantse = Instance.new("TextButton")
local ar = Instance.new("TextBox")
local chattag = Instance.new("TextButton")
local pantes = Instance.new("TextBox")
local gi = Instance.new("TextBox")
local bi = Instance.new("TextBox")
local bodi = Instance.new("TextButton")
local bodichos = Instance.new("TextButton")
local arrow = Instance.new("ImageLabel")
local bodyfrem = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local man = Instance.new("TextButton")
local woman = Instance.new("TextButton")
local robloxian = Instance.new("TextButton")
local superhero = Instance.new("TextButton")
local coolkid = Instance.new("TextButton")
local bountyhunter = Instance.new("TextButton")
local thecaptain = Instance.new("TextButton")
local footballplayer = Instance.new("TextButton")
local gunslinger = Instance.new("TextButton")
local pirate = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Frame.BackgroundTransparency = 0.500
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.295570076, 0, 0.325376898, 0)
Frame.Size = UDim2.new(0, 725, 0, 250)

UICorner.Parent = Frame

Name.Name = "Name"
Name.Parent = Frame
Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Name.BackgroundTransparency = 1.000
Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Name.BorderSizePixel = 0
Name.Size = UDim2.new(0, 725, 0, 50)
Name.Font = Enum.Font.FredokaOne
Name.Text = "hotel elephant mod menu"
Name.TextColor3 = Color3.fromRGB(0, 0, 0)
Name.TextScaled = true
Name.TextSize = 14.000
Name.TextWrapped = true

moni1.Name = "moni1"
moni1.Parent = Frame
moni1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
moni1.BorderColor3 = Color3.fromRGB(0, 0, 0)
moni1.BorderSizePixel = 0
moni1.Position = UDim2.new(0.0114655169, 0, 0.228, 0)
moni1.Size = UDim2.new(0, 170, 0, 20)
moni1.ClearTextOnFocus = false
moni1.Font = Enum.Font.SourceSansBold
moni1.PlaceholderText = "money"
moni1.Text = ""
moni1.TextColor3 = Color3.fromRGB(0, 0, 0)
moni1.TextSize = 14.000

getmoni1.Name = "getmoni1"
getmoni1.Parent = Frame
getmoni1.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
getmoni1.BorderColor3 = Color3.fromRGB(0, 0, 0)
getmoni1.BorderSizePixel = 0
getmoni1.Position = UDim2.new(0.0116780456, 0, 0.330000013, 0)
getmoni1.Size = UDim2.new(0, 169, 0, 20)
getmoni1.Font = Enum.Font.SourceSans
getmoni1.Text = "get money"
getmoni1.TextColor3 = Color3.fromRGB(0, 0, 0)
getmoni1.TextSize = 14.000

moni2.Name = "moni2"
moni2.Parent = Frame
moni2.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
moni2.BorderColor3 = Color3.fromRGB(0, 0, 0)
moni2.BorderSizePixel = 0
moni2.Position = UDim2.new(0.0103448275, 0, 0.460000008, 0)
moni2.Size = UDim2.new(0, 170, 0, 20)
moni2.ClearTextOnFocus = false
moni2.Font = Enum.Font.SourceSansBold
moni2.PlaceholderText = "money"
moni2.Text = ""
moni2.TextColor3 = Color3.fromRGB(0, 0, 0)
moni2.TextSize = 14.000

getmoni2.Name = "getmoni2"
getmoni2.Parent = Frame
getmoni2.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
getmoni2.BorderColor3 = Color3.fromRGB(0, 0, 0)
getmoni2.BorderSizePixel = 0
getmoni2.Position = UDim2.new(0.0119654164, 0, 0.698000014, 0)
getmoni2.Size = UDim2.new(0, 169, 0, 22)
getmoni2.Font = Enum.Font.SourceSans
getmoni2.Text = "give money"
getmoni2.TextColor3 = Color3.fromRGB(0, 0, 0)
getmoni2.TextSize = 14.000

pleyer.Name = "pleyer"
pleyer.Parent = Frame
pleyer.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
pleyer.BorderColor3 = Color3.fromRGB(0, 0, 0)
pleyer.BorderSizePixel = 0
pleyer.Position = UDim2.new(0.0103448275, 0, 0.583999991, 0)
pleyer.Size = UDim2.new(0, 170, 0, 20)
pleyer.ClearTextOnFocus = false
pleyer.Font = Enum.Font.SourceSansBold
pleyer.PlaceholderText = "player"
pleyer.Text = ""
pleyer.TextColor3 = Color3.fromRGB(0, 0, 0)
pleyer.TextSize = 14.000

blesing.Name = "blesing"
blesing.Parent = Frame
blesing.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
blesing.BorderColor3 = Color3.fromRGB(0, 0, 0)
blesing.BorderSizePixel = 0
blesing.Position = UDim2.new(0.26348272, 0, 0.228, 0)
blesing.Size = UDim2.new(0, 180, 0, 20)
blesing.Font = Enum.Font.SourceSans
blesing.Text = "start blessing"
blesing.TextColor3 = Color3.fromRGB(0, 0, 0)
blesing.TextSize = 14.000

stopblesing.Name = "stopblesing"
stopblesing.Parent = Frame
stopblesing.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
stopblesing.BorderColor3 = Color3.fromRGB(0, 0, 0)
stopblesing.BorderSizePixel = 0
stopblesing.Position = UDim2.new(0.26348272, 0, 0.328000009, 0)
stopblesing.Size = UDim2.new(0, 180, 0, 20)
stopblesing.Font = Enum.Font.SourceSans
stopblesing.Text = "stop blessing"
stopblesing.TextColor3 = Color3.fromRGB(0, 0, 0)
stopblesing.TextSize = 14.000

neutral.Name = "neutral"
neutral.Parent = Frame
neutral.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
neutral.BorderColor3 = Color3.fromRGB(0, 0, 0)
neutral.BorderSizePixel = 0
neutral.Position = UDim2.new(0.26348272, 0, 0.460000008, 0)
neutral.Size = UDim2.new(0, 180, 0, 20)
neutral.Font = Enum.Font.SourceSans
neutral.Text = "become neutral team"
neutral.TextColor3 = Color3.fromRGB(0, 0, 0)
neutral.TextSize = 14.000

kilears.Name = "kilears"
kilears.Parent = Frame
kilears.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
kilears.BorderColor3 = Color3.fromRGB(0, 0, 0)
kilears.BorderSizePixel = 0
kilears.Position = UDim2.new(0.26348272, 0, 0.583999991, 0)
kilears.Size = UDim2.new(0, 180, 0, 20)
kilears.Font = Enum.Font.SourceSans
kilears.Text = "annoying sounds gui"
kilears.TextColor3 = Color3.fromRGB(0, 0, 0)
kilears.TextSize = 14.000

zomber.Name = "zomber"
zomber.Parent = Frame
zomber.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
zomber.BorderColor3 = Color3.fromRGB(0, 0, 0)
zomber.BorderSizePixel = 0
zomber.Position = UDim2.new(0.26348272, 0, 0.69599998, 0)
zomber.Size = UDim2.new(0, 180, 0, 20)
zomber.Font = Enum.Font.SourceSans
zomber.Text = "goofy zombie"
zomber.TextColor3 = Color3.fromRGB(0, 0, 0)
zomber.TextSize = 14.000

walkis.Name = "walkis"
walkis.Parent = Frame
walkis.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
walkis.BorderColor3 = Color3.fromRGB(0, 0, 0)
walkis.BorderSizePixel = 0
walkis.Position = UDim2.new(0.26348272, 0, 0.828000009, 0)
walkis.Size = UDim2.new(0, 180, 0, 20)
walkis.Font = Enum.Font.SourceSans
walkis.Text = "inf yield"
walkis.TextColor3 = Color3.fromRGB(0, 0, 0)
walkis.TextSize = 14.000

sumface.Name = "sumface"
sumface.Parent = Frame
sumface.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sumface.BorderColor3 = Color3.fromRGB(0, 0, 0)
sumface.BorderSizePixel = 0
sumface.Position = UDim2.new(0.533362091, 0, 0.460000008, 0)
sumface.Size = UDim2.new(0, 170, 0, 20)
sumface.ClearTextOnFocus = false
sumface.Font = Enum.Font.SourceSansBold
sumface.PlaceholderText = "face id/web"
sumface.Text = ""
sumface.TextColor3 = Color3.fromRGB(0, 0, 0)
sumface.TextSize = 14.000

acesory.Name = "acesory"
acesory.Parent = Frame
acesory.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
acesory.BorderColor3 = Color3.fromRGB(0, 0, 0)
acesory.BorderSizePixel = 0
acesory.Position = UDim2.new(0.533861995, 0, 0.330000013, 0)
acesory.Size = UDim2.new(0, 169, 0, 20)
acesory.Font = Enum.Font.SourceSans
acesory.Text = "get acesory (hat remove)"
acesory.TextColor3 = Color3.fromRGB(0, 0, 0)
acesory.TextSize = 14.000

filllot.Name = "filllot"
filllot.Parent = Frame
filllot.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
filllot.BorderColor3 = Color3.fromRGB(0, 0, 0)
filllot.BorderSizePixel = 0
filllot.Position = UDim2.new(0.0116780456, 0, 0.822000027, 0)
filllot.Size = UDim2.new(0, 169, 0, 22)
filllot.Font = Enum.Font.SourceSans
filllot.Text = "fill boat lot"
filllot.TextColor3 = Color3.fromRGB(0, 0, 0)
filllot.TextSize = 14.000

getface.Name = "getface"
getface.Parent = Frame
getface.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
getface.BorderColor3 = Color3.fromRGB(0, 0, 0)
getface.BorderSizePixel = 0
getface.Position = UDim2.new(0.533861995, 0, 0.574000001, 0)
getface.Size = UDim2.new(0, 169, 0, 22)
getface.Font = Enum.Font.SourceSans
getface.Text = "get face"
getface.TextColor3 = Color3.fromRGB(0, 0, 0)
getface.TextSize = 14.000

acesoryget.Name = "acesoryget"
acesoryget.Parent = Frame
acesoryget.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
acesoryget.BorderColor3 = Color3.fromRGB(0, 0, 0)
acesoryget.BorderSizePixel = 0
acesoryget.Position = UDim2.new(0.533294022, 0, 0.228, 0)
acesoryget.Size = UDim2.new(0, 170, 0, 20)
acesoryget.ClearTextOnFocus = false
acesoryget.Font = Enum.Font.SourceSansBold
acesoryget.PlaceholderText = "accessory id"
acesoryget.Text = ""
acesoryget.TextColor3 = Color3.fromRGB(0, 0, 0)
acesoryget.TextSize = 14.000

changeshirte.Name = "changeshirte"
changeshirte.Parent = Frame
changeshirte.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
changeshirte.BorderColor3 = Color3.fromRGB(0, 0, 0)
changeshirte.BorderSizePixel = 0
changeshirte.Position = UDim2.new(0.53219527, 0, 0.818000019, 0)
changeshirte.Size = UDim2.new(0, 169, 0, 22)
changeshirte.Font = Enum.Font.SourceSans
changeshirte.Text = "change shirt"
changeshirte.TextColor3 = Color3.fromRGB(0, 0, 0)
changeshirte.TextSize = 14.000

shirtes.Name = "shirtes"
shirtes.Parent = Frame
shirtes.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
shirtes.BorderColor3 = Color3.fromRGB(0, 0, 0)
shirtes.BorderSizePixel = 0
shirtes.Position = UDim2.new(0.531408131, 0, 0.703999996, 0)
shirtes.Size = UDim2.new(0, 170, 0, 20)
shirtes.ClearTextOnFocus = false
shirtes.Font = Enum.Font.SourceSansBold
shirtes.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
shirtes.PlaceholderText = "id/web"
shirtes.Text = ""
shirtes.TextColor3 = Color3.fromRGB(0, 0, 0)
shirtes.TextSize = 14.000

changepantse.Name = "changepantse"
changepantse.Parent = Frame
changepantse.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
changepantse.BorderColor3 = Color3.fromRGB(0, 0, 0)
changepantse.BorderSizePixel = 0
changepantse.Position = UDim2.new(0.780471087, 0, 0.326000005, 0)
changepantse.Size = UDim2.new(0, 150, 0, 22)
changepantse.Font = Enum.Font.SourceSans
changepantse.Text = "change pants"
changepantse.TextColor3 = Color3.fromRGB(0, 0, 0)
changepantse.TextSize = 14.000

ar.Name = "ar"
ar.Parent = Frame
ar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ar.BorderColor3 = Color3.fromRGB(0, 0, 0)
ar.BorderSizePixel = 0
ar.Position = UDim2.new(0.780190587, 0, 0.460000008, 0)
ar.Size = UDim2.new(0, 30, 0, 20)
ar.ClearTextOnFocus = false
ar.Font = Enum.Font.SourceSansBold
ar.PlaceholderText = "R"
ar.Text = ""
ar.TextColor3 = Color3.fromRGB(0, 0, 0)
ar.TextSize = 14.000

chattag.Name = "chattag"
chattag.Parent = Frame
chattag.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
chattag.BorderColor3 = Color3.fromRGB(0, 0, 0)
chattag.BorderSizePixel = 0
chattag.Position = UDim2.new(0.779091775, 0, 0.574000001, 0)
chattag.Size = UDim2.new(0, 150, 0, 22)
chattag.Font = Enum.Font.SourceSans
chattag.Text = "change chattag"
chattag.TextColor3 = Color3.fromRGB(0, 0, 0)
chattag.TextSize = 14.000

pantes.Name = "pantes"
pantes.Parent = Frame
pantes.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
pantes.BorderColor3 = Color3.fromRGB(0, 0, 0)
pantes.BorderSizePixel = 0
pantes.Position = UDim2.new(0.780190587, 0, 0.228, 0)
pantes.Size = UDim2.new(0, 150, 0, 20)
pantes.ClearTextOnFocus = false
pantes.Font = Enum.Font.SourceSansBold
pantes.PlaceholderText = "id/web"
pantes.Text = ""
pantes.TextColor3 = Color3.fromRGB(0, 0, 0)
pantes.TextSize = 14.000

gi.Name = "gi"
gi.Parent = Frame
gi.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
gi.BorderColor3 = Color3.fromRGB(0, 0, 0)
gi.BorderSizePixel = 0
gi.Position = UDim2.new(0.861569881, 0, 0.460000008, 0)
gi.Size = UDim2.new(0, 30, 0, 20)
gi.ClearTextOnFocus = false
gi.Font = Enum.Font.SourceSansBold
gi.PlaceholderText = "G"
gi.Text = ""
gi.TextColor3 = Color3.fromRGB(0, 0, 0)
gi.TextSize = 14.000

bi.Name = "bi"
bi.Parent = Frame
bi.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
bi.BorderColor3 = Color3.fromRGB(0, 0, 0)
bi.BorderSizePixel = 0
bi.Position = UDim2.new(0.944328547, 0, 0.460000008, 0)
bi.Size = UDim2.new(0, 30, 0, 20)
bi.ClearTextOnFocus = false
bi.Font = Enum.Font.SourceSansBold
bi.PlaceholderText = "B"
bi.Text = ""
bi.TextColor3 = Color3.fromRGB(0, 0, 0)
bi.TextSize = 14.000

bodi.Name = "bodi"
bodi.Parent = Frame
bodi.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
bodi.BorderColor3 = Color3.fromRGB(0, 0, 0)
bodi.BorderSizePixel = 0
bodi.Position = UDim2.new(0.777712464, 0, 0.825999975, 0)
bodi.Size = UDim2.new(0, 150, 0, 22)
bodi.Font = Enum.Font.SourceSans
bodi.Text = "nothing"
bodi.TextColor3 = Color3.fromRGB(0, 0, 0)
bodi.TextSize = 14.000

bodichos.Name = "bodichos"
bodichos.Parent = Frame
bodichos.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
bodichos.BorderColor3 = Color3.fromRGB(0, 0, 0)
bodichos.BorderSizePixel = 0
bodichos.Position = UDim2.new(0.777712464, 0, 0.702000022, 0)
bodichos.Size = UDim2.new(0, 150, 0, 22)
bodichos.Font = Enum.Font.SourceSans
bodichos.Text = "choose body"
bodichos.TextColor3 = Color3.fromRGB(0, 0, 0)
bodichos.TextSize = 14.000

arrow.Name = "arrow"
arrow.Parent = bodichos
arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
arrow.BackgroundTransparency = 1.000
arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
arrow.BorderSizePixel = 0
arrow.Position = UDim2.new(0.866666675, 0, 0.0681818202, 0)
arrow.Size = UDim2.new(0, 20, 0, 20)
arrow.Image = "rbxassetid://10709767827"
arrow.ImageColor3 = Color3.fromRGB(0, 0, 0)

bodyfrem.Name = "bodyfrem"
bodyfrem.Parent = Frame
bodyfrem.Active = true
bodyfrem.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
bodyfrem.BorderColor3 = Color3.fromRGB(0, 0, 0)
bodyfrem.BorderSizePixel = 0
bodyfrem.Position = UDim2.new(0.777712464, 0, 0.787999988, 0)
bodyfrem.Size = UDim2.new(0, 150, 0, 100)
bodyfrem.Visible = false
bodyfrem.CanvasSize = UDim2.new(0, 0, 1, 0)

UIListLayout.Parent = bodyfrem
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

man.Name = "man"
man.Parent = bodyfrem
man.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
man.BorderColor3 = Color3.fromRGB(0, 0, 0)
man.BorderSizePixel = 0
man.Size = UDim2.new(0, 150, 0, 20)
man.Font = Enum.Font.SourceSans
man.Text = "man"
man.TextColor3 = Color3.fromRGB(0, 0, 0)
man.TextSize = 14.000

woman.Name = "woman"
woman.Parent = bodyfrem
woman.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
woman.BorderColor3 = Color3.fromRGB(0, 0, 0)
woman.BorderSizePixel = 0
woman.Size = UDim2.new(0, 150, 0, 20)
woman.Font = Enum.Font.SourceSans
woman.Text = "woman"
woman.TextColor3 = Color3.fromRGB(0, 0, 0)
woman.TextSize = 14.000

robloxian.Name = "robloxian"
robloxian.Parent = bodyfrem
robloxian.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
robloxian.BorderColor3 = Color3.fromRGB(0, 0, 0)
robloxian.BorderSizePixel = 0
robloxian.Size = UDim2.new(0, 150, 0, 20)
robloxian.Font = Enum.Font.SourceSans
robloxian.Text = "robloxian 2.0"
robloxian.TextColor3 = Color3.fromRGB(0, 0, 0)
robloxian.TextSize = 14.000

superhero.Name = "superhero"
superhero.Parent = bodyfrem
superhero.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
superhero.BorderColor3 = Color3.fromRGB(0, 0, 0)
superhero.BorderSizePixel = 0
superhero.Size = UDim2.new(0, 150, 0, 20)
superhero.Font = Enum.Font.SourceSans
superhero.Text = "superhero"
superhero.TextColor3 = Color3.fromRGB(0, 0, 0)
superhero.TextSize = 14.000

coolkid.Name = "coolkid"
coolkid.Parent = bodyfrem
coolkid.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
coolkid.BorderColor3 = Color3.fromRGB(0, 0, 0)
coolkid.BorderSizePixel = 0
coolkid.Size = UDim2.new(0, 150, 0, 20)
coolkid.Font = Enum.Font.SourceSans
coolkid.Text = "cool kid"
coolkid.TextColor3 = Color3.fromRGB(0, 0, 0)
coolkid.TextSize = 14.000

bountyhunter.Name = "bountyhunter"
bountyhunter.Parent = bodyfrem
bountyhunter.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
bountyhunter.BorderColor3 = Color3.fromRGB(0, 0, 0)
bountyhunter.BorderSizePixel = 0
bountyhunter.Size = UDim2.new(0, 150, 0, 20)
bountyhunter.Font = Enum.Font.SourceSans
bountyhunter.Text = "bounty hunter"
bountyhunter.TextColor3 = Color3.fromRGB(0, 0, 0)
bountyhunter.TextSize = 14.000

thecaptain.Name = "thecaptain"
thecaptain.Parent = bodyfrem
thecaptain.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
thecaptain.BorderColor3 = Color3.fromRGB(0, 0, 0)
thecaptain.BorderSizePixel = 0
thecaptain.Size = UDim2.new(0, 150, 0, 20)
thecaptain.Font = Enum.Font.SourceSans
thecaptain.Text = "the captain"
thecaptain.TextColor3 = Color3.fromRGB(0, 0, 0)
thecaptain.TextSize = 14.000

footballplayer.Name = "footballplayer"
footballplayer.Parent = bodyfrem
footballplayer.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
footballplayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
footballplayer.BorderSizePixel = 0
footballplayer.Size = UDim2.new(0, 150, 0, 20)
footballplayer.Font = Enum.Font.SourceSans
footballplayer.Text = "football player"
footballplayer.TextColor3 = Color3.fromRGB(0, 0, 0)
footballplayer.TextSize = 14.000

gunslinger.Name = "gunslinger"
gunslinger.Parent = bodyfrem
gunslinger.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
gunslinger.BorderColor3 = Color3.fromRGB(0, 0, 0)
gunslinger.BorderSizePixel = 0
gunslinger.Size = UDim2.new(0, 150, 0, 20)
gunslinger.Font = Enum.Font.SourceSans
gunslinger.Text = "gunslinger"
gunslinger.TextColor3 = Color3.fromRGB(0, 0, 0)
gunslinger.TextSize = 14.000

pirate.Name = "pirate"
pirate.Parent = bodyfrem
pirate.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
pirate.BorderColor3 = Color3.fromRGB(0, 0, 0)
pirate.BorderSizePixel = 0
pirate.Size = UDim2.new(0, 150, 0, 20)
pirate.Font = Enum.Font.SourceSans
pirate.Text = "pirate"
pirate.TextColor3 = Color3.fromRGB(0, 0, 0)
pirate.TextSize = 14.000

function isalink(txt)
	if string.match(txt,"://") then
		return true
	else
		return false
	end
end

local UIS = game:GetService("UserInputService")
local function dragify(Frame,boool)
	local frametomove = Frame
	local dragToggle,dragInput,dragStart,startPos
	local dragSpeed = 0
	local function updateInput(input)
		local Delta = input.Position - dragStart
		frametomove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
	end
	Frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = frametomove.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)	
		end
	end)
	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			updateInput(input)
		end
	end)
end
dragify(Frame)

getmoni1.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.MoneyRequest:FireServer(false,tonumber(moni1.Text),"Cash")
end)

getmoni2.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.MoneyRequest:FireServer(false,tonumber(moni2.Text),"Cash",game.Players:WaitForChild(pleyer.Text))
end)

filllot.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.BoatSpawner:InvokeServer("Transport Boat")
	game.ReplicatedStorage.BoatSpawner:InvokeServer("Transport Boat")
end)

blesing.MouseButton1Click:Connect(function()
	isblessing = true
	while isblessing do
		for _,v in pairs(game.Players:GetPlayers()) do
			local rand = math.random(1000,1000000)
			game.ReplicatedStorage.MoneyRequest:FireServer(false,rand,"Cash",v)
		end
		task.wait()
	end
end)

stopblesing.MouseButton1Click:Connect(function()
	isblessing = false
end)

neutral.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ChangeTeam:InvokeServer("Medium stone gray")
end)

kilears.MouseButton1Click:Connect(function()
	--[[
Made By Scripty#2063
If You Gonna showcase this , make sure to Credit me , do not take that you are owner of the script
This Gui is Undetectable
RespectFilteringEnabled must be false to use it
--]]

	local ScreenGui = Instance.new("ScreenGui")
	local Draggable = Instance.new("Frame")
	local Frame = Instance.new("Frame")
	local Frame_2 = Instance.new("Frame")
	local Time = Instance.new("TextLabel")
	local _1E = Instance.new("TextButton")
	local UICorner = Instance.new("UICorner")
	local _3E = Instance.new("TextButton")
	local UICorner_2 = Instance.new("UICorner")
	local SE = Instance.new("TextButton")
	local UICorner_3 = Instance.new("UICorner")
	local Path = Instance.new("TextLabel")
	local Top = Instance.new("Frame")
	local Top_2 = Instance.new("Frame")
	local ImageLabel = Instance.new("ImageLabel")
	local TextLabel = Instance.new("TextLabel")
	local Exit = Instance.new("TextButton")
	local Minizum = Instance.new("TextButton")
	local Stop = Instance.new("TextButton")
	local UICorner_4 = Instance.new("UICorner")
	local IY = Instance.new("TextButton")
	local UICorner_5 = Instance.new("UICorner")
	local TextLabel_2 = Instance.new("TextLabel")
	local Wait = Instance.new("TextBox")

	--Properties:

	ScreenGui.Name = ". Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ"
	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	Draggable.Name = "Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ."
	Draggable.Parent = ScreenGui
	Draggable.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Draggable.BackgroundTransparency = 1.000
	Draggable.BorderSizePixel = 0
	Draggable.Position = UDim2.new(0.35026139, 0, 0.296158612, 0)
	Draggable.Size = UDim2.new(0, 438, 0, 277)

	Frame.Name = ". . Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ. "
	Frame.Parent = Draggable
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 1.000
	Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(-0.00133678317, 0, -0.00348037481, 0)
	Frame.Size = UDim2.new(0, 438, 0, 277)

	Frame_2.Name = " . Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ. "
	Frame_2.Parent = Frame
	Frame_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Frame_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Frame_2.BorderSizePixel = 0
	Frame_2.Position = UDim2.new(-0.00133678142, 0, -0.0179207586, 0)
	Frame_2.Size = UDim2.new(0, 438, 0, 238)
	Frame_2.Active = true
	Frame_2.Draggable = true

	Time.Name = "Time"
	Time.Parent = Frame_2
	Time.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Time.BackgroundTransparency = 1.000
	Time.Position = UDim2.new(0, 0, 0.0126050422, 0)
	Time.Size = UDim2.new(0, 437, 0, 31)
	Time.Font = Enum.Font.GothamSemibold
	Time.Text = "RespectFilteringEnabled(RFE) : nil"
	Time.TextColor3 = Color3.fromRGB(255, 255, 255)
	Time.TextScaled = true
	Time.TextSize = 14.000
	Time.TextWrapped = true

	_1E.Name = "1E"
	_1E.Parent = Frame_2
	_1E.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	_1E.BorderSizePixel = 0
	_1E.Position = UDim2.new(0.0182648394, 0, 0.676470578, 0)
	_1E.Size = UDim2.new(0, 208, 0, 33)
	_1E.Font = Enum.Font.SourceSans
	_1E.Text = "Mute Game"
	_1E.TextColor3 = Color3.fromRGB(255, 255, 255)
	_1E.TextScaled = true
	_1E.TextSize = 30.000
	_1E.TextWrapped = true

	UICorner.Parent = _1E

	_3E.Name = "3E"
	_3E.Parent = Frame_2
	_3E.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	_3E.BorderSizePixel = 0
	_3E.Position = UDim2.new(0.0159817357, 0, 0.142857149, 0)
	_3E.Size = UDim2.new(0, 209, 0, 33)
	_3E.Font = Enum.Font.SourceSans
	_3E.Text = "Annoying  Sound"
	_3E.TextColor3 = Color3.fromRGB(255, 255, 255)
	_3E.TextSize = 30.000
	_3E.TextWrapped = true

	UICorner_2.Parent = _3E

	SE.Name = "SE"
	SE.Parent = Frame_2
	SE.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	SE.BorderSizePixel = 0
	SE.Position = UDim2.new(0.509132445, 0, 0.142857149, 0)
	SE.Size = UDim2.new(0, 209, 0, 33)
	SE.Font = Enum.Font.SourceSans
	SE.Text = "Kill Sound Service"
	SE.TextColor3 = Color3.fromRGB(255, 255, 255)
	SE.TextSize = 30.000
	SE.TextWrapped = true

	UICorner_3.Parent = SE

	Path.Name = "Path"
	Path.Parent = Frame_2
	Path.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	Path.BackgroundTransparency = 1.000
	Path.Position = UDim2.new(0.00684931502, 0, 0.815126061, 0)
	Path.Size = UDim2.new(0, 435, 0, 44)
	Path.Font = Enum.Font.GothamSemibold
	Path.Text = "Dev Note : This Script is FE and it only FE when RespectFilteringEnabled(RFE) is disabled , elseif RespectFilteringEnabled(RFE) is true then it only be client , mostly RespectFilteringEnabled(RFE) disabled game are classic game"
	Path.TextColor3 = Color3.fromRGB(255, 0, 0)
	Path.TextScaled = true
	Path.TextSize = 14.000
	Path.TextWrapped = true

	Top.Name = "Top"
	Top.Parent = Frame_2
	Top.BackgroundColor3 = Color3.fromRGB(41, 60, 157)
	Top.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Top.BorderSizePixel = 0
	Top.Position = UDim2.new(-0.00133678142, 0, -0.128059402, 0)
	Top.Size = UDim2.new(0, 438, 0, 30)
	Top_2.Name = "Top"
	Top_2.Parent = Top
	Top_2.BackgroundColor3 = Color3.fromRGB(30, 45, 118)
	Top_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Top_2.BorderSizePixel = 0
	Top_2.Position = UDim2.new(0, 0, 0.967638671, 0)
	Top_2.Size = UDim2.new(0, 438, 0, 5)

	ImageLabel.Parent = Top
	ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel.BackgroundTransparency = 1.000
	ImageLabel.Position = UDim2.new(0, 0, 0.0666666701, 0)
	ImageLabel.Size = UDim2.new(0, 29, 0, 27)
	ImageLabel.Image = "http://www.roblox.com/asset/?id=8798286232"

	TextLabel.Parent = ImageLabel
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Position = UDim2.new(0.997245014, 0, 0, 0)
	TextLabel.Size = UDim2.new(0, 397, 0, 30)
	TextLabel.Font = Enum.Font.GothamSemibold
	TextLabel.Text = "FEAG"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextWrapped = true

	Exit.Name = "Exit"
	Exit.Parent = Top
	Exit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Exit.BackgroundTransparency = 1.000
	Exit.Position = UDim2.new(0.924657524, 0, 0, 0)
	Exit.Size = UDim2.new(0, 32, 0, 25)
	Exit.Font = Enum.Font.GothamSemibold
	Exit.Text = "x"
	Exit.TextColor3 = Color3.fromRGB(255, 255, 255)
	Exit.TextScaled = true
	Exit.TextSize = 14.000
	Exit.TextWrapped = true

	Minizum.Name = "Minizum"
	Minizum.Parent = Top
	Minizum.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Minizum.BackgroundTransparency = 1.000
	Minizum.Position = UDim2.new(0.851598203, 0, 0, 0)
	Minizum.Size = UDim2.new(0, 32, 0, 23)
	Minizum.Font = Enum.Font.GothamSemibold
	Minizum.Text = "_"
	Minizum.TextColor3 = Color3.fromRGB(255, 255, 255)
	Minizum.TextScaled = true
	Minizum.TextSize = 14.000
	Minizum.TextWrapped = true

	Stop.Name = "Stop"
	Stop.Parent = Frame_2
	Stop.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Stop.BorderSizePixel = 0
	Stop.Position = UDim2.new(0.0182648394, 0, 0.310924381, 0)
	Stop.Size = UDim2.new(0, 424, 0, 33)
	Stop.Font = Enum.Font.SourceSans
	Stop.Text = "Stop"
	Stop.TextColor3 = Color3.fromRGB(255, 255, 255)
	Stop.TextSize = 30.000
	Stop.TextWrapped = true

	UICorner_4.Parent = Stop

	IY.Name = "IY"
	IY.Parent = Frame_2
	IY.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	IY.BorderSizePixel = 0
	IY.Position = UDim2.new(0.509132445, 0, 0.676470578, 0)
	IY.Size = UDim2.new(0, 209, 0, 33)
	IY.Font = Enum.Font.SourceSans
	IY.Text = "Unmute Game"
	IY.TextColor3 = Color3.fromRGB(255, 255, 255)
	IY.TextScaled = true
	IY.TextSize = 30.000
	IY.TextWrapped = true

	UICorner_5.Parent = IY

	TextLabel_2.Parent = Frame_2
	TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.BackgroundTransparency = 1.000
	TextLabel_2.Position = UDim2.new(0.0182648394, 0, 0.466386557, 0)
	TextLabel_2.Size = UDim2.new(0, 426, 0, 50)
	TextLabel_2.Font = Enum.Font.GothamSemibold
	TextLabel_2.Text = "Wait Speed       :"
	TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextSize = 30.000
	TextLabel_2.TextWrapped = true
	TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

	Wait.Name = "Wait()"
	Wait.Parent = Frame_2
	Wait.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Wait.BackgroundTransparency = 1.000
	Wait.Position = UDim2.new(0.531963468, 0, 0.466386557, 0)
	Wait.Size = UDim2.new(0, 199, 0, 50)
	Wait.ZIndex = 99999
	Wait.ClearTextOnFocus = false
	Wait.Font = Enum.Font.GothamSemibold
	Wait.Text = "0.5"
	Wait.TextColor3 = Color3.fromRGB(255, 255, 255)
	Wait.TextSize = 30.000
	Wait.TextWrapped = true

	--Sound Service:
	local notification = Instance.new("Sound")
	notification.Parent = game:GetService("SoundService")
	notification.SoundId = "rbxassetid://9086208751"
	notification.Volume = 5
	notification.Name = ". Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ"

	--funuction:
	Exit.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)
	local Mute = false
	IY.MouseButton1Click:Connect(function()
		Mute = false
	end)

	_1E.MouseButton1Click:Connect(function()
		Mute = true
		while Mute == true do 
			wait()
			for _, sound in next, workspace:GetDescendants() do
				if sound:IsA("Sound") then
					sound:Stop()
				end
			end
		end
	end)

	_3E.MouseButton1Click:Connect(function()
		for _, sound in next, workspace:GetDescendants() do
			if sound:IsA("Sound") then
				sound:Play()
			end
		end
	end)

	local Active = true
	SE.MouseButton1Click:Connect(function()
		Active = true
		while Active == true do
			local StringValue = Wait.Text
			wait(StringValue)
			for _, sound in next, workspace:GetDescendants() do
				if sound:IsA("Sound") then
					sound:Play()
				end
			end
		end
	end)

	Stop.MouseButton1Click:Connect(function()
		Active = false
	end)
	--Credit:
	notification:Play()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "FEAG";
		Text = "FEAG Has Been Loaded , Made By Scripty#2063 (gamer14_123)";
		Icon = "";
		Duration = 10; 
		Button1 = "Yes Sir";
	})
	--Check:
	while true do
		wait(0.5)
		local setting = game:GetService("SoundService").RespectFilteringEnabled
		if setting == true then
			Time.TextColor = BrickColor.new(255,0,0)
			Time.Text ="RespectFilteringEnabled(RFE) : true"
		elseif setting == false then
			Time.Text ="RespectFilteringEnabled(RFE) : false"
			Time.TextColor = BrickColor.new(0,255,0)
		end
	end
end)

zomber.MouseButton1Click:Connect(function()
	local player = game.Players.LocalPlayer
	repeat wait() until player.Character.Humanoid
	local humanoid = player.Character.Humanoid
	local character = player.Character or player.CharacterAdded:Wait()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://178130996"

	local playAnim = humanoid:LoadAnimation(anim)
	playAnim:Play()
end)

walkis.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

acesory.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceHair:FireServer({acesoryget.Text})
	game.ReplicatedStorage.ReplaceHair:FireServer("rename")
end)

getface.MouseButton1Click:Connect(function()
	if isalink(sumface.Text) then
		game.ReplicatedStorage.ReplaceFace:FireServer(sumface.Text)
	else
		game.ReplicatedStorage.ReplaceFace:FireServer("http://www.roblox.com/asset/?id=" .. sumface.Text)
	end
end)

changeshirte.MouseButton1Click:Connect(function()
	if isalink(shirtes.Text) then
		game.ReplicatedStorage.ClothesChanger:FireServer(true,"Shirt",shirtes.Text)
	else
		game.ReplicatedStorage.ClothesChanger:FireServer(true,"Shirt","http://www.roblox.com/asset/?id=" .. shirtes.Text)
	end
end)

changepantse.MouseButton1Click:Connect(function()
	if isalink(pantes.Text) then
		game.ReplicatedStorage.ClothesChanger:FireServer(true,"Pants",pantes.Text)
	else
		game.ReplicatedStorage.ClothesChanger:FireServer(true,"Pants","http://www.roblox.com/asset/?id=" .. pantes.Text)
	end
end)

chattag.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ChangeTeam:InvokeServer(tostring(BrickColor.new(Color3.new(tonumber(ar.Text),tonumber(gi.Text),tonumber(bi.Text)))))
end)

bodichos.MouseButton1Click:Connect(function()
	if isopened then
		arrow.Image = "rbxassetid://10709767827"
		bodyfrem.Visible = false
		isopened = false
	else
		arrow.Image = "rbxassetid://10709768939"
		bodyfrem.Visible = true
		isopened = true
	end
end)

man.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Man"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)

woman.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Woman"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)

robloxian.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Robloxian 2.0"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)
	
superhero.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Superhero"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)

coolkid.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Cool Kid"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)

bountyhunter.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Bounty Hunter"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)

thecaptain.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"The Captain"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)

footballplayer.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Football Player"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)

gunslinger.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Gunslinger"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)

pirate.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.ReplaceBody:FireServer({"Pirate"})
	game.ReplicatedStorage.ReplaceBody:FireServer("rename")
	bodyfrem.Visible = false
end)
