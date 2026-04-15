local classname = "ArmsMaster"

ListenToEvent("RoundStarted", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
			player:SetReplicatedVar("KillStreak", "0")
		end
	end
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
		local maxkillstreakmoney = math.floor(playerActor.ActionComponent.MoneyAmount/5000)
		if (tonumber(playerActor:GetReplicatedVar("KillStreak")) + maxkillstreakmoney) > 16 then
			maxkillstreakmoney = 16 - tonumber(playerActor:GetReplicatedVar("KillStreak"))
		end
		if maxkillstreakmoney >= 1 then
			playerActor:startAbilityCooldown(15.0)
			playerActor.ActionComponent.MoneyAmount = playerActor.ActionComponent.MoneyAmount - (maxkillstreakmoney*5000)
			playerActor:SetReplicatedVar("KillStreak", tostring(tonumber(playerActor:GetReplicatedVar("KillStreak")) + maxkillstreakmoney))
		end
	end
end)

ListenToEvent("RoundTick", function()
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
			player.ActionComponent:SlowDownTimeSV(1 + ((1/16) * tonumber(player:GetReplicatedVar("KillStreak"))))
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
			target.HP = target.HP + ((damage/17) * tonumber(target:GetReplicatedVar("KillStreak")))
			if target.HP - damage <= 0 then
				target:SetReplicatedVar("KillStreak", "0")
			end
		end
	end
end)