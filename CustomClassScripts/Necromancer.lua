local classname = "Necromancer"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(60.0)

        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
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

        for i, char in ipairs(chars) do
            AddActorTag(char,"Hysteric")
        end

        SetTimer(10.0, "EndHystericNpcs", playerActor)
    end
end)

ListenToEvent("RoundTick", function()
    for i, npc in ipairs(GetAllActorsWithTag("Necromanced")) do
        npc:SlowDownTimeSV(0.7)
    end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage, damtype)
    local targetnpc = true
    
    for i, player in ipairs(GetPlayerChars()) do
        if player == target then
            targetnpc = false
        end
    end

	if source then
		if source.CustomClassString == classname then
            if targetnpc then
                if damtype == 2 then
                    if math.random(1,4) == 1 then
                        SpawnActor("PlayerAI_Rob",target:GetActorLocation(),nil,nil,"Necromanced")
                    end
                end
            end
		end
	end
end)