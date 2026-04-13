local classname = "Undercover"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:startAbilityCooldown(45.0)
		
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
		local plrpos = playerActor:GetActorLocation()
		for i=1,3 do
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
				closest.dontSpawnRagdoll = true
				GetGameState():LuaDestroyActor(closest)
			end
		end
	end
end)

ListenToEvent("PreReceiveDamage", function(targetActor, sourceActor, damage)
	local cop = nil
	for i,player in ipairs(GetPlayerChars()) do
		if player.robber == false then
			if player.CustomClassString == classname then
				cop = player
			end
			break
		end
	end
	if sourceActor then
		if targetActor.HP - damage <= 0 and sourceActor.robber == true and cop then
			GetGameState():SpawnLuaPingSV("undercoverlife.png", targetActor:GetActorLocation(),cop)
		end
	end
end)