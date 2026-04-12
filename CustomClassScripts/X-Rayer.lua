ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == "X-Rayer" then
		playerActor:startAbilityCooldown(35.0)
		
		local customers = GetAllActorsOfClass("AI_Customer")
		local employees = GetAllActorsOfClass("AI_Employee")
		local chars = {}	
		
		for i, customer in ipairs(customers) do
			table.insert(chars,customer)
		end
		for i, employee in ipairs(employees) do
			table.insert(chars,employee)
		end
		
		for i, character in ipairs(chars) do
			character.Mesh:SetHiddenIngame(true)
		end
		
		PlaySound(playerActor, "xrayeractivate.wav", 0.75)
		GetGameState():ShowLuaImage("xrayersight", "xrayerblue.png", 0, 0, 10.0, 10000, 10000)
		SetTimer(10.0, "XRayVisionOff", playerActor)
	end
end)

ListenToEvent("XRayVisionOff", function(playerActor)
	local customers = GetAllActorsOfClass("AI_Customer")
	local employees = GetAllActorsOfClass("AI_Employee")
	local chars = {}	
		
	for i, customer in ipairs(customers) do
		table.insert(chars,customer)
	end
	for i, employee in ipairs(employees) do
		table.insert(chars,employee)
	end
	
	for i, character in ipairs(chars) do
		character.Mesh:SetHiddenIngame(false)
	end
end)

ListenToEvent("PreReceiveDamage", function(targetActor, sourceActor)
	if sourceActor then
		if sourceActor.CustomClassString == "X-Rayer" then
			local customers = GetAllActorsOfClass("AI_Customer")
			local employees = GetAllActorsOfClass("AI_Employee")
			local chars = {}	
				
			for i, customer in ipairs(customers) do
				table.insert(chars,customer)
			end
			for i, employee in ipairs(employees) do
				table.insert(chars,employee)
			end
			
			for i, character in ipairs(chars) do
				character.Mesh:SetHiddenIngame(true)
			end
			SetTimer(5.0, "XRayVisionOff", sourceActor)
		end
	end
end)