local classname = "NikolaTesla"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        local closest = GetClosestActor("CCTV", playerActor:GetActorLocation())

		if closest and GetDistance(playerActor, closest) <= 500 then
            playerActor:startAbilityCooldown(30.0)

            playerActor:AbilitySV()
        end
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        local closest = GetClosestActor("CCTV", playerActor:GetActorLocation())

		if closest and GetDistance(playerActor, closest) <= 500 then
            AddActorTag(closest, "TeslaTurret")
            LogMessage("ada")
        end
    end
end)

ListenToEvent("PreReceiveDamage", function(targetActor, sourceActor, damage)
    if sourceActor then
        if sourceActor.CustomClassString == classname then
            targetActor.HP = targetActor.HP + math.ceil(damage/2)
            targetActor:TaseredSV(1.0)
        end
    end
end)