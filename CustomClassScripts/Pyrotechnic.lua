local classname = "Pyrotechnic"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

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
    for i, bag in ipairs(GetAllActorsWithTag("PyroDecoy")) do
        for _, player in ipairs(GetPlayerChars()) do
            if player.robber == true then
                if GetDistance(bag, player) <= 500 then
                    SpawnActor("BoomBarrell", bag:GetActorLocation(), nil, nil, "PyroBarrel")
                    GetActorWithTag("PyroBarrel"):ExplodeDelaySV(0)
                end
            end
        end
    end
    SetTimer(1.0, "PyroFireCheck", player)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
        local closest = GetClosestActor("BombBag", playerActor:GetActorLocation())
        
        if closest and GetDistance(closest, playerActor) <= 500 then
            playerActor:startAbilityCooldown(25.0)
		
            playerActor:AbilitySV()
        end
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
        local closest = GetClosestActor("BombBag", playerActor:GetActorLocation())
        
        if closest and GetDistance(closest, playerActor) <= 500 then
            AddActorTag(closest, "PyroDecoy")
        end
	end
end)