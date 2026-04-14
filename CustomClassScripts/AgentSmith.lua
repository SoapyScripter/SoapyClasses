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
            SetTimer(2.0, "AgentSmithCheckCameras", player)
        end
    end
end)

ListenToEvent("AgentSmithCheckCameras", function(playerActor)
    if playerActor.inCCTV == true then
        for i, player in ipairs(playerActor.ActionComponent.CurrentCCTV.players) do
            if player.robber == false then
                GetGameState():SpawnLuaPingSV("agentsmithsixth.png", player:GetActorLocation(), playerActor)
            end
        end
    end

    SetTimer(2.0, "AgentSmithCheckCameras", playerActor)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        if playerActor.ActionComponent.lastCCTV then
            playerActor:startAbilityCooldown(45.0)

            SetTimer(3.0, "AgentSmithCameraWarp", playerActor)
        end
    end
end)

ListenToEvent("AgentSmithCameraWarp", function(playerActor)
    PlaySound(playerActor, "agentsmithwarp.mp3")
    local normal = playerActor.ActionComponent.lastCCTV:GetActorForwardVector()
    local origin, extent = playerActor:GetActorBounds(true)
    
    playerActor:SetActorLocation(addPos(playerActor.ActionComponent.lastCCTV:GetActorLocation(), {X=normal.X*250,Y=normal.Y*250,Z=normal.Z*250 -extent.Z}))
    for i, player in ipairs(GetPlayerChars()) do
        if player.robber == true then
            GetGameState():SpawnLuaPingSV("agentsmithcamera.png", playerActor.ActionComponent.lastCCTV:GetActorLocation(), player)
            break
        end
    end
    PlaySound(playerActor, "agentsmithwarp.mp3")
end)

