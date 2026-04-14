local classname = "Celebrity"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("RoundStarted", function()
    for i, player in ipairs(GetPlayerChars()) do
        if player.CustomClassString == classname then
            SetTimer(0.1, "CelebrityTenTicks", player)
        end
    end
end)

ListenToEvent("CelebrityTenTicks", function(playerActor)
    if ActorHasTag(playerActor, "PaparazziCoolDown") == false then
        for i, player in ipairs(GetPlayerChars()) do
            if player.robber == false then
                if player.ActionComponent.CurrentCCTV then
                    local cctv = player.ActionComponent.CurrentCCTV
    
                    if cctv then
                        local list = {cctv, playerActor}
                        local boxoverlap = BoxOverlap(cctv:GetActorLocation(), 150, 150, 150)
                        for i, overlap in ipairs(boxoverlap) do
                            table.insert(list,overlap)
                        end
                        local ray = LineMultiTrace(playerActor:GetActorLocation(), cctv:GetActorLocation(), list)
                        if #ray <= 0 then
                            GetGameState().savedMoney = GetGameState().savedMoney + 1000
                            AddActorTag(playerActor, "PaparazziCoolDown")
                            SetTimer(10.0, "PaparazziCoolDown", playerActor)
                        end
                    end
                end
            end
        end
    end

    for i, npc in ipairs(GetAllActorsWithTag("CelebrityFan")) do
        npc:OverwriteMovementTarget(playerActor:GetActorLocation(), 0.1)
    end
    SetTimer(0.1, "CelebrityTenTicks", playerActor)
end)

ListenToEvent("CelebrityCamera", function(playerActor)
    RemoveActorTag(playerActor, "PaparazziCoolDown")
end)


ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(45.0)
        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        local plrpos = playerActor:GetActorLocation()
        for i=1,15 do
            local closestcustomer = nil
            local customerdis = math.huge

            for x, npc in ipairs(GetAllActorsOfClass("AI_Customer")) do
                if GetDistance(npc, playerActor) < customerdis and ActorHasTag(npc, "CelebrityFan") == false then
                    closestcustomer = npc
                    customerdis = GetDistance(npc, playerActor)
                end
            end
			local closestemployee = nil
            local employeedis = math.huge

            for x, npc in ipairs(GetAllActorsOfClass("AI_Employee")) do 
                if GetDistance(npc, playerActor) < employeedis and ActorHasTag(npc, "CelebrityFan") == false then
                    closestemployee = npc
                    employeedis = GetDistance(npc, playerActor)
                end
            end
            local closestcook = nil
            local cookdis = math.huge

            for x, npc in ipairs(GetAllActorsOfClass("AI_KitchenStaff")) do
                if GetDistance(npc, playerActor) < cookdis and ActorHasTag(npc, "CelebrityFan") == false then
                    closestcook = npc
                    cookdis = GetDistance(npc, playerActor)
                end
            end
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
                AddActorTag(closest,"CelebrityFan")
                SetTimer(15.0, "RemoveFan", closest)
			end
		end
    end
end)

ListenToEvent("RemoveFan", function(npc)
    if ActorHasTag(npc, "CelebrityFan") then
        RemoveActorTag(npc, "CelebrityFan")
    end
end)