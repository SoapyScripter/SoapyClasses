local classname = "BioHacker"

ListenToEvent("RoundTick", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
			if ActorHasTag(player, "SuperSerum") then
				player.ActionComponent:SlowDownTimeSV(1.8)
			else
				player.ActionComponent:SlowDownTimeSV(0.85)
			end
			GetGameState().hackedPCs = 0
			if GetGameState().cryptoPCs > 3 then
				GetGameState().cryptoPCs = 3
			end
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
		AddActorTag(playerActor, "SuperSerum")
		PlaySound(playerActor, "superserum.ogg", 1)
		SetTimer(15.0, "EndSuperSerum", playerActor)
	end
end)

ListenToEvent("EndSuperSerum", function(playerActor)
	RemoveActorTag(playerActor, "SuperSerum")
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if source then
		if source.CustomClassString == classname then
			if ActorHasTag(player, "SuperSerum") then
				target.HP = target.HP - math.ceil((damage/5) * 4)
			else
				target.HP = target.HP + math.ceil(damage/5)
			end
		end
	end
end)