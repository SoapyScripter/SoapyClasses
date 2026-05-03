local classname = "Witch"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		StartPieMenu(playerActor, {
            {Name = "Poison Potion",    Description = "Makes a lingering pool that damages enimes.",    Icon = "WitchPoisonPotion.png"},
            {Name = "Revive Potion",   Description = "Revives the nearest dead teammate.",   Icon = "WitchRevivePotion.png"},
            {Name = "Healing Potion",  Description = "Makes a lingering pool that heals teammates.",  Icon = "WitchHealPotion.png"},
            {Name = "Weakness Potion",    Description = "Makes a lingering pool that makes enimes weak.",     Icon = "WitchWeakPotion.png"}
        })
	end
end)

ListenToEvent("PieMenuSelected_OnClient", function(playerActor, selectedIndex)
    if playerActor.CustomClassString == classname then
        if selectedIndex == 0 then
            SpawnLuaActor("LingeringPoison.lua", playerActor:GetActorLocation())
			playerActor:startAbilityCooldown(60.0)
        elseif selectedIndex == 1 then
			for i, player in ipairs(GetPlayerChars()) do
				if player.robber == true and robber.dead == true then
					if GetDistance(player, playerActor) < 350 then
						player:SupriseRespawnSV(player, 50)
					end
				end
			end
			playerActor:startAbilityCooldown(30.0)
        elseif selectedIndex == 2 then
            SpawnLuaActor("LingeringHealing.lua", playerActor:GetActorLocation())
			playerActor:startAbilityCooldown(30.0)
        elseif selectedIndex == 3 then
            SpawnLuaActor("LingeringWeakness.lua", playerActor:GetActorLocation())
			playerActor:startAbilityCooldown(45.0)
        end
    end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if target.PlayersName and source.PlayersName then
		if source.CustomClassString == classname then
			if source.HP + math.ceil(damage/2) > 100 then
				source.HP = 100
			else
				source.HP = source.HP + math.ceil(damage/2)
			end
		end
	end
end)