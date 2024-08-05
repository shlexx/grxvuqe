for _,v in pairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") then
		print("game." .. v:GetFullName() .. " [RemoteEvent]")
	elseif v:IsA("RemoteFunction") then
		print("game." .. v:GetFullName() .. " [RemoteFunction]")
end
