local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

local function aiRobberAction(ai, iscustomer, playerActor)
	local aipos = ai:GetActorLocation()
	
	if iscustomer then
		local bombBag = GetClosestActor("BombBag", aipos)
			
		if not bombBag then
			return
		end
		AddActorTag(ai, "Bribed")
		ai.dontFire = true
		playerActor:startAbilityCooldown(45.0)
		playerActor.ActionComponent.moneyAmount = playerActor.ActionComponent.moneyAmount - 7500
		ai:OverwriteMovementTarget(bombBag:GetActorLocation(),math.huge)
		SetTimer(1.0, "CheckBombBagAI", ai)
	else
		local safeDoor = GetClosestActor("SafeDoor", aipos)
			
		if not safeDoor then
			return
		end
		AddActorTag(ai, "Bribed")
		ai.dontFire = true
		playerActor:startAbilityCooldown(45.0)
		playerActor.ActionComponent.moneyAmount = playerActor.ActionComponent.moneyAmount - 15000
		ai:OverwriteMovementTarget(safeDoor:GetActorLocation(),math.huge)
		SetTimer(1.0, "CheckSafeDoorAI", ai)
	end
end

ListenToEvent("CheckSafeDoorAI", function(ai)
	local aipos = ai:GetActorLocation()
	local safeDoor = GetClosestActor("SafeDoor", aipos)
	
	if GetDistance(ai,safeDoor) < 500 then
		safeDoor:Explode()
	else
		SetTimer(1.0, "CheckSafeDoorAI", ai)
	end
end)

ListenToEvent("CheckBombBagAI", function(ai)
	local aipos = ai:GetActorLocation()
	local bombBag = GetClosestActor("BombBag", aipos)
	
	if GetDistance(ai,bombBag) < 300 then
		GetGameState():LuaDestroyActor(bombBag)
		AddActorTag(ai, "HasBombBag")
		for i,player in ipairs(GetPlayerChars()) do
			if player.CustomClassString == "Briber" then
				ai:OverwriteMovementTarget(player:GetActorLocation(), 1.0)
				SetTimer(1.0, "CheckPlayerAI", ai)
				break
			end
		end
	else
		SetTimer(1.0, "CheckBombBagAI", ai)
	end
end)

ListenToEvent("CheckPlayerAI", function(ai)
	local player = nil
	for i,playerv in ipairs(GetPlayerChars()) do
		if playerv.CustomClassString == "Briber" then
			player = playerv
			break
		end
	end
	
	if GetDistance(ai,player) < 200 then
		SpawnActor("BombBag", ai:GetActorLocation())
		RemoveActorTag(ai, "HasBombBag")
		ai:OverwriteMovementTarget(player:GetActorLocation(),0.1)
	else
		ai:OverwriteMovementTarget(player:GetActorLocation(), 1.0)
		SetTimer(1.0, "CheckPlayerAI", ai)
	end
end)


ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == "Briber" then
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == "Briber" then
		local plrpos = playerActor:GetActorLocation()
		local closestcustomer = GetClosestActor("AI_Customer", plrpos)
		local closestemployee = GetClosestActor("AI_Employee", plrpos)
		local closest = closestcustomer
		local customer = true
		local requiredmoney = 7500
		
		if GetDistance(playerActor, closestemployee) < GetDistance(playerActor, closestcustomer) then
			closest = closestemployee
			requiredmoney = 15000
			customer = false
		end
		
		if closest and GetDistance(closest, playerActor) < 250 and playerActor.ActionComponent.moneyAmount >= requiredmoney then
			aiRobberAction(closest, customer, playerActor)
		end
	end
end)

ListenToEvent("PreReceiveDamage", function(targetActor, sourceActor, damage)
	if ActorHasTag(targetActor, "HasBombBag") then
		if targetActor.HP - damage <= 0 then
			SpawnActor("BombBag", targetActor:GetActorLocation())
		end
	end
	if sourceActor then
		if targetActor.HP - damage <= 0 then
			if sourceActor.CustomClassString == "Briber" and targetActor.PlayersName then
				SpawnActor("MoneyBag", targetActor:GetActorLocation(), "FreshSpawnBriber")
				for i,v in ipairs(GetAllActorsWithTag("FreshSpawnBriber")) do
					v.moneyValue = 3000
					RemoveActorTag(v, "FreshSpawnBriber")
				end
			end
		end
	end
end)