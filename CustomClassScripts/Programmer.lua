local classname = "Programmer"

local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

local tick = 0
ListenToEvent("RoundTick", function()
	tick = tick + 1
	for i, player in ipairs(GetPlayerChars()) do
		if player.CustomClassString == classname then
			GetGameState().hackedPCs = 0
			if GetGameState().cryptoPCs > 3 then
				GetGameState().cryptoPCs = 3
			end

			if tick%100 == 0 then
				for i, tracked in ipairs(GetAllActorsWithTag("Tracked")) do
					for i, playerx in ipairs(GetPlayerChars()) do
						if playerx.robber == true then
							if GetDistance(playerx, tracked) <= 750 then
								GetGameState():SpawnLuaPingSV("programmertracker.png", tracked:GetActorLocation(), player)
							end
						end
					end
				end
			end
		end
	end
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
		local closest = GetClosestActor("MoneyBag", playerActor:GetActorLocation())

		if closest then
			playerActor:startAbilityCooldown(60.0)
			AddActorTag(closest, "Tracked")
		end
	end
end)
