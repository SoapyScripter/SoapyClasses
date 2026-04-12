ListenToEvent("RoundStarted", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == "ArmsMaster" then
			player:SetReplicatedVar("KillStreak", "0")
		end
	end
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == "ArmsMaster" then
		playerActor:startAbilityCooldown(25.0)
		
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == "ArmsMaster" then
		playerActor:SetReplicatedVar("KevlarVest", "true")
		playerActor.preventShooting = true
		
		SetTimer(10.0, "KevlarVestOff",playerActor)
	end
end)

ListenToEvent("KevlarVestOff", function(playerActor)
	playerActor:SetReplicatedVar("KevlarVest", "false")
	playerActor.preventShooting = false
	playerActor.ActionComponent:SlowDownTimeSV(1)
end)

ListenToEvent("RoundTick", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == "ArmsMaster" then
			if player:GetReplicatedVar("KevlarVest") == "true" then
				player.ActionComponent:SlowDownTimeSV(0)
			else
				player.ActionComponent:SlowDownTimeSV(1 + (0.125 * tonumber(player:GetReplicatedVar("KillStreak"))))
			end
		end
	end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if target.PlayersName and source.PlayersName then
		if source then
			if source.CustomClassString == "ArmsMaster" then
				target.HP = target.HP - ((damage/8) * tonumber(source:GetReplicatedVar("KillStreak")))
				if target.HP - damage <= 0 then
					source:SetReplicatedVar("KillStreak", tostring(tonumber(source:GetReplicatedVar("KillStreak")) + 1))
					if tonumber(source:GetReplicatedVar("KillStreak")) > 8 then
						source:SetReplicatedVar("KillStreak", 8)
					end
				end
			end
		end
		if target.CustomClassString == "ArmsMaster" then
			if target:GetReplicatedVar("KevlarVest") == "true" then
				target.HP = target.HP + damage
			else
				target.HP = target.HP + ((damage/9) * tonumber(target:GetReplicatedVar("KillStreak")))
				if target.HP - damage <= 0 then
					target:SetReplicatedVar("KillStreak", 0)
				end
			end
		end
	end
end)