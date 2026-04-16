local classname = "X-Rayer"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:startAbilityCooldown(40.0)
		local customers = GetAllActorsOfClass("AI_Customer")
		local employees = GetAllActorsOfClass("AI_Employee")
		local cooks = GetAllActorsOfClass("AI_KitchenStaff")
		local chars = {}	
		
		for i, customer in ipairs(customers) do
			table.insert(chars,customer)
		end
		for i, employee in ipairs(employees) do
			table.insert(chars,employee)
		end
		for i, cook in ipairs(cooks) do
			table.insert(chars,cook)
		end
		
		for i, character in ipairs(chars) do
			if i%3 ~= 0 then
				character.Mesh:SetHiddenIngame(true)
			end
		end
		
		PlaySound(playerActor, "xrayeractivate.wav", 0.75)
		GetGameState():ShowLuaImage("xrayersight", "xrayerblue.png", 0, 0, 7.0, 10000, 10000)
		playerActor.preventShooting = true
		SetTimer(7.0, "XRayVisionOff", playerActor)
	end
end)

ListenToEvent("XRayVisionOff", function(playerActor)
	local customers = GetAllActorsOfClass("AI_Customer")
	local employees = GetAllActorsOfClass("AI_Employee")
	local cooks = GetAllActorsOfClass("AI_KitchenStaff")
	local chars = {}	
		
	for i, customer in ipairs(customers) do
		table.insert(chars,customer)
	end
	for i, employee in ipairs(employees) do
		table.insert(chars,employee)
	end
	for i, cook in ipairs(cooks) do
		table.insert(chars,cook)
	end
	
	for i, character in ipairs(chars) do
		character.Mesh:SetHiddenIngame(false)
	end

	playerActor.preventShooting = false
end)

ListenToEvent("PreReceiveDamage_OnClient", function(targetActor, sourceActor)
	if sourceActor then
		if sourceActor.CustomClassString == classname then
			local customers = GetAllActorsOfClass("AI_Customer")
			local employees = GetAllActorsOfClass("AI_Employee")
			local cooks = GetAllActorsOfClass("AI_KitchenStaff")
			local chars = {}	
				
			for i, customer in ipairs(customers) do
				table.insert(chars,customer)
			end
			for i, employee in ipairs(employees) do
				table.insert(chars,employee)
			end
			for i, cook in ipairs(cooks) do
				table.insert(chars,cook)
			end
			
			for i, character in ipairs(chars) do
				if i%2 == 0 then
					character.Mesh:SetHiddenIngame(true)
				end
			end
			SetTimer(5.0, "XRayVisionOff", sourceActor)
		end
	end
end)