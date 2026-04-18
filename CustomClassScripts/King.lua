local classname = "King"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        local plrpos = playerActor:GetActorLocation()
        local closestcustomer = GetClosestActor("AI_Customer", plrpos)
        local closestemployee = GetClosestActor("AI_Employee", plrpos)
        local closestcook = GetClosestActor("AI_KitchenStaff", plrpos)
        local closest = closestcustomer
        
        if closestcustomer and closestemployee then
            if GetDistance(playerActor, closestemployee) < GetDistance(playerActor, closestcustomer) then
                closest = closestemployee
                if closestemployee and closestcook then
                    if GetDistance(playerActor, closestcook) < GetDistance(playerActor, closestemployee) then
                        closest = closestcook
                    end
                end
            end
        end

        if closest then
            if GetDistance(playerActor,closest) <= 350 then
                playerActor:startAbilityCooldown(45.0)
                AddActorTag(closest,"Snitch")
            end
        end
    end
end)

ListenToEvent("RoundTick", function()
    local teammates = 0
    local robber = nil

    for i, player in ipairs(GetPlayerChars()) do
        if player.robber == false then
            teammates = teammates + 1
            if player.ClassID == 27 then
                teammates = teammates + 4
            end
        else
            robber = player
        end
    end
    teammates = teammates - 1

	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
            player.ActionComponent:SlowDownTimeSV(1 + (teammates/6))
		end
	end

    if robber then
        for i, npc in ipairs(GetAllActorsWithTag("Snitch")) do
            if GetDistance(npc,robber) <= 350 then
                RemoveActorTag(npc,"Snitch")
            else
                npc:OverwriteMovementTarget(robber:GetActorLocation(),0.1)
            end
        end
    end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if source then
		if source.CustomClassString == classname then
            local teammates = 0

            for i, player in ipairs(GetPlayerChars()) do
                if player.robber == false then
                    teammates = teammates + 1
                    if player.ClassID == 27 then
                        teammates = teammates + 4
                    end
                end
            end
            teammates = teammates - 1

			target.HP = target.HP - math.ceil(damage * (teammates/6))
		end
	end
end)