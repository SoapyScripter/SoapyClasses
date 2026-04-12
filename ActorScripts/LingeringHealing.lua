ListenToEvent("ActorSpawned", function(actor)
	if actor.LuaFileName == "LingeringHealing.lua" then
		SetTimer(0.1, "LingeringHealing", actor)
		GetGameState():LuaSpawnFX_ALL("HP_Regeneration",actor:GetActorLocation(), {X = 1, Y = 1, Z = 1}, "Potion")
		SetTimer(15, "LingeringHealingEnd", actor)
	end
end)

ListenToEvent("ActorSpawned_OnClient", function(actor)
	if actor.LuaFileName == "LingeringHealing.lua" then
		SetTimer(15, "LingeringHealingEndClient", actor)
	end
end)

ListenToEvent("LingeringHealingEnd", function(actor)
	GetGameState():LuaDestroyActor(actor)
end)

ListenToEvent("LingeringHealingEndClient", function(actor)
	GetGameState():LuaDestroyAllParticlesWithTag("Potion")
end)

ListenToEvent("LingeringHealing", function(actor)
	local boxoverlap = BoxOverlap(actor:GetActorLocation(), 350/2, 350/2, 25/2)
	for i, overlap in ipairs(boxoverlap) do
		if overlap.HP and overlap.robber then
			overlap:HealPlayer(1)
		end
	end
	SetTimer(0.1, "LingeringHealing", actor)
end)