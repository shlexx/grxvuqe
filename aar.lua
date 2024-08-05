print("🟢 - RemoteEvent, 🔵 - RemoteFunction")
for _,v in pairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") then
		print("game." .. v:GetFullName() .. "  🟢")
	elseif v:IsA("RemoteFunction") then
		print("game." .. v:GetFullName() .. " 🔵")
	end
end
