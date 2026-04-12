ListenToEvent("ActorSpawned", function(actor)
	if actor.LuaFileName == "LingeringPoison.lua" then
		SetTimer(0.5, "LingeringPoison", actor)
		GetGameState():LuaSpawnFX_ALL("Teargas",actor:GetActorLocation(), {X = 1, Y = 1, Z = 1}, "Potion")
		SetTimer(30, "LingeringPoisonEnd", actor)
	end
end)

ListenToEvent("ActorSpawned_OnClient", function(actor)
	if actor.LuaFileName == "LingeringPoison.lua" then
		SetTimer(15, "LingeringPoisonEndClient", actor)
	end
end)

ListenToEvent("LingeringPoisonEnd", function(actor)
	GetGameState():LuaDestroyActor(actor)
end)

ListenToEvent("LingeringPoisonEndClient", function(actor)
	GetGameState():LuaDestroyAllParticlesWithTag("Potion")
end)

ListenToEvent("LingeringPoison", function(actor)
	local boxoverlap = BoxOverlap(actor:GetActorLocation(), 350/2, 350/2, 25/2)
	for i, overlap in ipairs(boxoverlap) do
		if overlap.HP and overlap.robber == false then
			overlap:DealDmgSV(5, actor, 11)
		end
	end
	SetTimer(0.5, "LingeringPoison", actor)
end)