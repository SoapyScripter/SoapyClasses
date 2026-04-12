ListenToEvent("ActorSpawned", function(actor)
	if actor.LuaFileName == "LingeringWeakness.lua" then
		SetTimer(0.1, "LingeringWeakness", actor)
		GetGameState():LuaSpawnFX_ALL("SmokeCloud",actor:GetActorLocation(), {X = 1, Y = 1, Z = 1}, "Potion")
		SetTimer(25, "LingeringWeaknessEnd", actor)
	end
end)

ListenToEvent("ActorSpawned_OnClient", function(actor)
	if actor.LuaFileName == "LingeringWeakness.lua" then
		SetTimer(15, "LingeringWeaknessEndClient", actor)
	end
end)

ListenToEvent("LingeringWeaknessEnd", function(actor)
	GetGameState():LuaDestroyActor(actor)
end)

ListenToEvent("LingeringWeaknessEndClient", function(actor)
	GetGameState():LuaDestroyAllParticlesWithTag("Potion")
end)

ListenToEvent("LingeringWeakness", function(actor)
	local boxoverlap = BoxOverlap(actor:GetActorLocation(), 350/2, 350/2, 25/2)
	for i, overlap in ipairs(boxoverlap) do
		if overlap.robber == false then
			AddActorTag(overlap, "Weakness")
			SetTimer(15.0, "WeaknessPlayerEnd", overlap)
		end
	end
	SetTimer(0.1, "LingeringWeakness", actor)
end)

ListenToEvent("WeaknessPlayerEnd", function(actor)
	RemoveActorTag(actor, "Weakness")
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if source then
		if ActorHasTag(target, "Weakness") then
			target.HP = target.HP - math.ceil(damage/2)
		end
		
		if ActorHasTag(source, "Weakness") then
			target.HP = target.HP + math.ceil((damage/4) * 3)
		end
	end
end)