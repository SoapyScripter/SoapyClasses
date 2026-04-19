local classname = "AgentSmith"

local function addPos(pos1, pos2)
	pos1.X = pos1.X + pos2.X
	pos1.Y = pos1.Y + pos2.Y
	pos1.Z = pos1.Z + pos2.Z
	return pos1
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
                GetGameState():SpawnLuaPingSV("agentsmithsixth.png", player:GetActorLocation(), playerActor)
            end
        end
    end

    SetTimer(45.0, "AgentSmithSixthSense", playerActor)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        if playerActor.ActionComponent.lastCCTV then
            playerActor:startAbilityCooldown(45.0)
            
            AddActorTag(playerActor.ActionComponent.lastCCTV, "AgentSmithCam"..playerActor.PlayersName)
            playerActor:AbilitySV()
        end
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        SetTimer(1.75, "AgentSmithCameraWarp", playerActor)
    end
end)

ListenToEvent("AgentSmithCameraWarp", function(playerActor)
    PlaySound(playerActor, "agentsmithwarp.mp3")
    local camera = nil
    for i, v in ipairs(GetAllActorsWithTag("AgentSmithCam"..playerActor.PlayersName)) do
        camera = v
        break
    end
    local normal = camera:GetActorForwardVector()
    local origin, extent = playerActor:GetActorBounds(true)
    
    playerActor:SetActorLocation(addPos(camera:GetActorLocation(), {X=normal.Y*-250,Y=normal.X*250,Z=normal.Z*-250 -extent.Z}))
    for i, player in ipairs(GetPlayerChars()) do
        if player.robber == true then
            GetGameState():SpawnLuaPingSV("agentsmithcamera.png", camera:GetActorLocation(), player)
            break
        end
    end
    PlaySound(playerActor, "agentsmithwarp.mp3")
end)

