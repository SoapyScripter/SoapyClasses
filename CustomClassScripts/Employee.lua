local classname = "Employee"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        for i, pc in ipairs(GetAllActorsOfClass("HackablePC")) do
            if GetDistance(pc,playerActor) <= 1000 then
                playerActor:startAbilityCooldown(30.0)
                playerActor:AbilitySV()
                break
            end
        end
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        for i, pc in ipairs(GetAllActorsOfClass("HackablePC")) do
            if GetDistance(pc,playerActor) <= 1000 then
                if GetGameState().requiredSavedMoney > 1000 then
                    GetGameState().requiredSavedMoney = GetGameState().requiredSavedMoney - 1000
                    GetGameState().savedMoney = GetGameState().savedMoney + 1000
                    GetGameState():SpawnLuaPingSV("employeeembezzlement.png", pc:GetActorLocation())
                end
            end
        end
    end
end)

ListenToEvent("RoundTick", function()
    for i, player in ipairs(GetPlayerChars()) do
        if player.CustomClassString == classname then
            if player.CurrentZone == 1 then
                player.ActionComponent:setStealMulti(1.5,0.05)
            end
        end
    end
end)