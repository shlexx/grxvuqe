local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local mouse = player:GetMouse()
 
local tool = Instance.new("Tool")
tool.Name = "delete"
tool.ToolTip = ":troll:"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = backpack
 
local function onActivated()
    local target = mouse.Target
    if target and target:IsA("BasePart") then
        target:Destroy()
    end
end
 
tool.Activated:Connect(onActivated)
