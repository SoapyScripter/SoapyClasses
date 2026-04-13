local classname = "GoonMaster"

-- Key Ability fired on client
ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:startAbilityCooldown(10.0) -- Cooldown
		
		playerActor:AbilitySV()
	end
end)

-- Key Ability fired on server
ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
		local gs = GetGameState()

		for i, player in ipairs(GetPlayerChars()) do
			if player.robber == true then
				gs:SpawnLuaPingSV("objective_ping.png", player:GetActorLocation(), playerActor) -- Gets icon, Pings at actor location for the players team
			end
		end
	end
end)


--[[
ListenToEvent("KevlarVestOff", function(playerActor)
	playerActor:SetReplicatedVar("KevlarVest", "false")
	playerActor.preventShooting = false
	playerActor.ActionComponent:SlowDownTimeSV(1)
end)

ListenToEvent("RoundTick", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
			if player:GetReplicatedVar("KevlarVest") == "true" then
				player.ActionComponent:SlowDownTimeSV(0)
			else
				player.ActionComponent:SlowDownTimeSV(1 + ((1/16) * tonumber(player:GetReplicatedVar("KillStreak"))))
			end
		end
	end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if target.PlayersName and source.PlayersName then
		if source then
			if source.CustomClassString == classname then
				target.HP = target.HP - ((damage/16) * tonumber(source:GetReplicatedVar("KillStreak")))
				if target.HP - damage <= 0 then
					source:SetReplicatedVar("KillStreak", tostring(tonumber(source:GetReplicatedVar("KillStreak")) + 1))
					if tonumber(source:GetReplicatedVar("KillStreak")) > 16 then
						source:SetReplicatedVar("KillStreak", "16")
					end
				end
			end
		end
		if target.CustomClassString == classname then
			if target:GetReplicatedVar("KevlarVest") == "true" then
				target.HP = target.HP + damage
			else
				target.HP = target.HP + ((damage/17) * tonumber(target:GetReplicatedVar("KillStreak")))
				if target.HP - damage <= 0 then
					target:SetReplicatedVar("KillStreak", "0")
				end
			end
		end
	end
end)
]]