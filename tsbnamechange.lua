local ultimatename = "ultimate"
local firstmovename = "Move 1"
local secondmovename = "Move 2"
local thirdmovename = "Move 3"
local fourthmovename = "Move 4"

local hb = game.Players.LocalPlayer.PlayerGui.Hotbar.Backpack.Hotbar
local mh = game.Players.LocalPlayer.PlayerGui.ScreenGui.MagicHealth
local uum = ultimatename:upper()

mh.TextLabel.Text = uum
mh.TextLabel.TextLabel.Text = uum
hb:WaitForChild("1").Base.ToolName.Text = firstmovename
hb:WaitForChild("2").Base.ToolName.Text = secondmovename
hb:WaitForChild("3").Base.ToolName.Text = thirdmovename
hb:WaitForChild("4").Base.ToolName.Text = fourthmovename
