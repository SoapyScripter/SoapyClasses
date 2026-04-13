local classname = "Juggernaut"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("RoundStarted", function()
    local players = GetPlayerChars()
    for i, player in ipairs(players) do
        if player.CustomClassString == classname then
            SetTimer(1.0, "JuggernautAmmo", player)
        end
    end
end)

ListenToEvent("JuggernautAmmo", function(playerActor)
	playerActor.WeaponComponent:GainReserveAmmoForAllWeps()
	SetTimer(1.0, "JuggernautAmmo", playerActor)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:StartAbilityCooldown(35.0)
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:SetReplicatedVar("FMJ", "true")
		SetTimer(15.0, "FMJOff",playerActor)
	end
end)

ListenToEvent("FMJOff", function(playerActor)
	playerActor:SetReplicatedVar("FMJ", "false")
end)

ListenToEvent("PreReceiveDamage", function(targetActor, sourceActor, damage)
	if sourceActor then
		if sourceActor.CustomClassString == classname then
			if sourceActor:GetReplicatedVar("FMJ") == "true" then
				targetActor.HP = targetActor.HP - (damage)
			end
		end
	end
	if targetActor.CustomClassString == classname then
		targetActor.HP = targetActor.HP + math.ceil(damage/4)
	end
end)