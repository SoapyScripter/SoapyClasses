local classname = "Tycoon"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(45.0)

        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor.ActionComponent:setStealMulti(1.35,3.0)
    end
end)

ListenToEvent("RoundTick", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
            local moneyPercentage = GetGameState().savedMoney/GetGameState().requiredSavedMoney

            player.ActionComponent:SlowDownTimeSV(1 + (moneyPercentage/2))
		end
	end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if source then
		if source.CustomClassString == classname then
			target.HP = target.HP - math.ceil(damage * ((GetGameState().savedMoney/GetGameState().requiredSavedMoney)/2))
		end
	end
end)