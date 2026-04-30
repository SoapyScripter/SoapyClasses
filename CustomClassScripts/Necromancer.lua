local classname = "Necromancer"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(60.0)

        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
		local plrpos = playerActor:GetActorLocation()
		for i=1,2 do
			local closest = GetClosestActor("Ragdoll", plrpos)

            if closest then
                local closestpos = closest:GetActorLocation()

                GetGameState():LuaDestroyActor(closest)

                SpawnActor("PlayerAI_Rob",closestpos,nil,nil,"Necromanced")
            end
        end
    end
end)

ListenToEvent("RoundTick", function()
    for i, npc in ipairs(GetAllActorsWithTag("Necromanced")) do
        npc:SlowDownTimeSV(0.55)
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
                if target.HP - damage <= 0 then
                    if damtype == 2 then
                        if math.random(1,6) == 1 then
                            local targetpos = target:GetActorLocation()
    
                            target.dontSpawnRagdoll = true
                            GetGameState():LuaDestroyActor(target)
    
                            SpawnActor("PlayerAI_Rob",targetpos,nil,nil,"Necromanced")
                        end
                    end
                end
            end
		end
	end
end)