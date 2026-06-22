local classname = "Kingpin"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("RoundStarted", function()
    for i, player in ipairs(GetPlayerChars()) do
        if player.CustomClassString == classname then
            SetTimer(5.0, "KingpinLaunder", player)
        end
    end
end)

ListenToEvent("RoundTick", function()
    local lucky = false

    for i, player in ipairs(GetPlayerChars()) do
        if ActorHasTag(player, "KingpinLucky") then
            lucky = true
            break
        end
    end

    for i, player in ipairs(GetPlayerChars()) do
        if lucky and player.robber == false then
            player.WeaponComponent.CurrentInaccMovPart = 100
            player.WeaponComponent.CurrentInacc = 100
        end
    end
end)

ListenToEvent("KingpinLaunder", function(playerActor)
    for i, pc in ipairs(GetAllActorsOfClass("HackablePC")) do
        if GetDistance(pc,playerActor) <= 1000 then
            if playerActor.ActionComponent.moneyAmount >= 1000 then
                playerActor.ActionComponent.moneyAmount = playerActor.ActionComponent.moneyAmount - 1000
                GetGameState().savedMoney = GetGameState().savedMoney + 1000
                GetGameState():SpawnLuaPingSV("kingpinlaunder.png", pc:GetActorLocation())
            end
        end
    end
    SetTimer(5.0, "KingpinLaunder", playerActor)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(30.0)

        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        AddActorTag(playerActor, "KingpinLucky")
        SetTimer(15.0, "EndKingpinLucky", playerActor)
    end
end)

ListenToEvent("EndKingpinLucky", function(playerActor)
    RemoveActorTag(playerActor, "KingpinLucky")
end)