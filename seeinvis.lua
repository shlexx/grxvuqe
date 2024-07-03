for i,v in pairs(workspace:GetDescendants()) do
	if v:IsA("BasePart") and v.Transparency <= 1 then
		if not table.find(shownParts,v) then
			table.insert(shownParts,v)
		end
		v.Transparency = 0
	end
end
