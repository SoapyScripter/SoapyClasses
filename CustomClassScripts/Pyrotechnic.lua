local classname = "Pyrotechnic"

ListenToEvent("RoundStarted", function()
    for i, player in ipairs(GetPlayerChars()) do
        if player.CustomClassString == classname then
            SetTimer(1.0, "PyroFireCheck", player)
        end
    end
end)

ListenToEvent("PyroFireCheck", function(player)
    for i, plant in ipairs(GetAllActorsOfClass("IgniteablePlant")) do
        if plant.burning == true then
            GetGameState():SpawnLuaPingSV("pyrofire.png", plant:GetActorLocation(), player)
        end
    end
    for i, safe in ipairs(GetAllActorsOfClass("SafeDoor")) do
        if safe.bombPlanted == true then
            GetGameState():SpawnLuaPingSV("pyrobomb.png", safe:GetActorLocation(), player)
        end
    end
    SetTimer(1.0, "PyroFireCheck", player)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:startAbilityCooldown(45.0)
		
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
		SpawnActor("MolotovPart", playerActor:GetActorLocation())
	end
end)