local classname = "Tycoon"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(45.0)

        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        for i, player in ipairs(GetPlayerChars()) do
            if player.robber == false then
                GetGameState():SpawnLuaPingSV("tycoonwindfall", playerActor:GetActorLocation(),player)
                break
            end
        end
        playerActor.ActionComponent:setStealMulti(1.35,4.0)
    end
end)

ListenToEvent("RoundTick", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
            local moneyPercentage = player.ActionComponent.moneyAmount/16000

            player.ActionComponent:SlowDownTimeSV(1 + moneyPercentage)
		end
	end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if source then
		if source.CustomClassString == classname then
			target.HP = target.HP - math.ceil(damage * (source.ActionComponent.moneyAmount/16000))
		end
	end
end)