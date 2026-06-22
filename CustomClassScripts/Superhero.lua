local classname = "Superhero"

local function addPos(pos1, pos2)
    local returnpos = {X=0,Y=0,Z=0}
	returnpos.X = pos1.X + pos2.X
	returnpos.Y = pos1.Y + pos2.Y
	returnpos.Z = pos1.Z + pos2.Z
	return returnpos
end

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(45.0)

        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        AddActorTag(playerActor, "LaserBeam")
        SetTimer(5.0, "SuperheroEndLaser", playerActor)
    end
end)

ListenToEvent("SuperheroEndLaser", function(playerActor)
    RemoveActorTag(playerActor, "LaserBeam")
end)

ListenToEvent("RoundTick", function()
    for i, player in ipairs(GetPlayerChars()) do
        if ActorHasTag(player, "LaserBeam") then
            local startPos = player:GetActorLocation()
            local forward = player:GetActorForwardVector()
            local endPos = addPos(startPos, {X=forward.X*100000, Y=forward.Y*100000, Z=forward.Z*100000})

            local laser = LineMultiTrace(startPos, endPos, {player})
                
            for i, hit in ipairs(laser) do
                if GetActorClassName(hit.Actor) == "SafeDoor" then
                    hit.Actor:Explode()
                elseif GetActorClassName(hit.Actor) ~= "MolotovPart" then
                    SpawnActor("MolotovPart", hit.Location)
                end
             end
        end
     end
end)

ListenToEvent("PreReceiveDamage", function(targetActor, sourceActor, damage)
    if sourceActor then
        if sourceActor.CustomClassString == classname then
            targetActor.HP = 0
        end
    end
end)