print("🟢 - RemoteEvent, 🔵 - RemoteFunction")
for _,v in pairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") then
		print("game." .. v:GetFullName() .. "  🟢")
	elseif v:IsA("RemoteFunction") then
		print("game." .. v:GetFullName() .. " 🔵")
	end
end
task.wait()
print('\n[[Added/Removed]]\n➕ - New Remote, ➖ - Removed Remote')
game.DescendantAdded:Connect(function(v)
	if v:IsA("RemoteEvent") then
		print("game." .. v:GetFullName() .. " ➕🟢")
	elseif v:IsA("RemoteFunction") then
		print("game." .. v:GetFullName() .. " ➕🔵")
	end
end)
game.DescendantRemoving:Connect(function(v)
	if v:IsA("RemoteEvent") then
		print("game." .. v:GetFullName() .. " ➖🟢")
	elseif v:IsA("RemoteFunction") then
		print("game." .. v:GetFullName() .. " ➖🔵")
	end
end)
