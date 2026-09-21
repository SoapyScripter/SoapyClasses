local classname = "President"

ListenToEvent("RoundStarted", function()
    for i, player in ipairs(GetPlayerChars()) do
        if player.CustomClassString == classname then
            SetTimer(0.25, "President25Ticks", player)
        end
    end
end)

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

ListenToEvent("EndHystericNpcs", function(player)
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
        RemoveActorTag(char,"Hysteric")
    end
end)

ListenToEvent("President25Ticks", function(player)
    for i, npc in ipairs(GetAllActorsWithTag("Hysteric")) do
        local pos = npc:GetActorLocation()
        local forward = npc:GetActorForwardVector()
        local randomPos = {
            X = pos.X + forward.X * math.random(-1000,1000),
            Y = pos.Y + forward.Y * math.random(-1000,1000),
            Z = pos.Z + forward.Z * math.random(-1000,1000)
        }

        npc:OverwriteMovementTarget(randomPos,0.25)
     end

    SetTimer(0.25, "President25Ticks", player)
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if target then
		if target.CustomClassString == classname then
            if target.HP - damage <= 0 then
                local plrpos = target:GetActorLocation()
                local forward = target:GetActorForwardVector()
                local behindPos = {
                    X = plrpos.X - forward.X * 50,
                    Y = plrpos.Y - forward.Y * 50,
                    Z = plrpos.Z - forward.Z * 50
                }
                
                SpawnActor("PlayerAI_Cop",behindPos,nil,nil,"FreshPresident")
                for i, npc in ipairs(GetAllActorsWithTag("FreshPresident")) do
                    npc.difficulty = 2
                    RemoveActorTag(npc,"FreshPresident")
                    SetTimer(5.0,"DespawnBodyguardPresident",npc)
                end
            end
		end
	end
end)

ListenToEvent("DespawnBodyguardPresident", function(npc)
    GetGameState():LuaDestroyActor(npc)
end)