local classname = "Chameleon"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:startAbilityCooldown(30.0)
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor.preventShooting = true
	end
end)

ListenToEvent("AbilityALL_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor.Mesh:SetHiddenIngame(true)
	end
end)

ListenToEvent("RoundTick_OnClient", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
			if player.ActionComponent.moneyAmount > 0 or (player:GetVelocity().X + player:GetVelocity().Z) > 0 then
				SetTimer(0.01, "ChameleonStop", player)
			end
		end
	end
end)

ListenToEvent("RoundTick", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
			if player.ActionComponent.moneyAmount > 0 or (player:GetVelocity().X + player:GetVelocity().Z) > 0 then
				player.preventShooting = false
			end
		end
	end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if target.CustomClassString == classname then
		target.ActionComponent:SlowDownTimeSV(1.5)
		SetTimer(2.0, "ChameleonSpeedStop", target)
		target.preventShooting = false
		SetTimer(0.01, "ChameleonStop",target)
	end
end)

ListenToEvent("ChameleonSpeedStop", function(playerActor)
	playerActor.ActionComponent:SlowDownTimeSV(1)
end)

ListenToEvent("ChameleonStop", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor.Mesh:SetHiddenIngame(false)
	end
end)