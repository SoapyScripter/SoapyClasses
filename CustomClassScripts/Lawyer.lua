local classname = "Lawyer"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

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
            player:SetReplicatedVar("LawyerNPCsKilled", "0")
        end
    end
    for i, npc in ipairs(GetAllActorsOfClass("AI_Customer")) do
        npc.dontFire = true
    end
    for i, npc in ipairs(GetAllActorsOfClass("AI_Employee")) do
        npc.dontFire = true
    end
    for i, npc in ipairs(GetAllActorsOfClass("AI_KitchenStaff")) do
        npc.dontFire = true
    end
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
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
        
        if closest and GetDistance(closest, playerActor) <= 500 then
            playerActor:startAbilityCooldown(25.0)
		
            playerActor:AbilitySV()
        end
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
        
        if closest and GetDistance(closest, playerActor) <= 500 then
            for i=0, 2, 1 do
                GetGameState():SpawnLuaPingSV("lawyerwitness.png", addPos(closest:GetActorLocation(), {X=math.random(-3000,3000), Y=math.random(0,3000), Z=math.random(-3000,3000)}), playerActor)
            end
            for i, player in ipairs(GetPlayerChars()) do
                if player.robber == true then
                    GetGameState():SpawnLuaPingSV("lawyerwitness.png", player:GetActorLocation(), playerActor)
                end
            end
        end
    end
end)

ListenToEvent("PreReceiveDamage", function(target, source)
    local targetnpc = true
    
    for i, player in ipairs(GetPlayerChars()) do
        if player == target then
            targetnpc = false
        end
    end

	if source then
        if source.robber == false then
            if targetnpc then
                GetGameState().savedMoney = GetGameState().savedMoney + 1000
            end
        end
	end
end)