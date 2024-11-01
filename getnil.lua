local t = {}
game.DescendantRemoving:Connect(function(d)
table.insert(t,d)
end)
_G.getnilinstances = function()
return t
end
