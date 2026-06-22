local classname = "AgentSmith"

local function addPos(pos1, pos2)
    local returnpos = {X=0,Y=0,Z=0}
	returnpos.X = pos1.X + pos2.X
	returnpos.Y = pos1.Y + pos2.Y
	returnpos.Z = pos1.Z + pos2.Z
	return returnpos
end

ListenToEvent("RoundStarted", function()
    for i, player in ipairs(GetPlayerChars()) do
        if player.CustomClassString == classname then
            SetTimer(45.0, "AgentSmithSixthSense", player)
        end
    end
end)

ListenToEvent("AgentSmithSixthSense", function(playerActor)
    for i, player in ipairs(GetPlayerChars()) do
        if player.robber == true then
            if player.ActionComponent.moneyAmount > 0 then
                GetGameState():SpawnLuaPingSV("agentsmithsixth.png", player:GetActorLocation(), playerActor.ActionComponent.lastCCTV)
            end
        end
    end

    SetTimer(45.0, "AgentSmithSixthSense", playerActor)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        if playerActor.ActionComponent.lastCCTV then
            playerActor:SendMulticastRPCWithActors("AgentSmithCameraWarp", playerActor)
            playerActor:startAbilityCooldown(45.0)
        end
    end
end)

ListenToEvent("AgentSmithCameraWarp", function(playerActor, camera)
    PlaySound(playerActor, "agentsmithwarp.mp3")
    local normal = camera:GetActorForwardVector()
    local origin, extent = playerActor:GetActorBounds(true)
    
    playerActor:SetActorLocation(addPos(camera:GetActorLocation(), {X=normal.Y*-250,Y=normal.X*250,Z=normal.Z*-250 -extent.Z}))
    for i, player in ipairs(GetPlayerChars()) do
        if player.robber == true then
            GetGameState():SpawnLuaPingSV("agentsmithcamera.png", camera:GetActorLocation(), player)
            break
        end
    end
    RemoveActorTag(camera, "AgentSmithCam")
    PlaySound(playerActor, "agentsmithwarp.mp3")
end)

