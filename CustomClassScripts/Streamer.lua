local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end


ListenToEvent("RoundStarted", function()
    local players = GetPlayerChars()
    for i, player in ipairs(players) do
        if player.CustomClassString == "Streamer" then
            SetTimer(5.0, "StreamerDono", player)
			GetGameState().requiredSavedMoney = GetGameState().requiredSavedMoney + 10000
        end
    end
end)

ListenToEvent("StreamerDono", function(playerActor)
	local players = GetPlayerChars()
	local streamingpcs = GetAllActorsWithTag("Streaming")
	for i, player in ipairs(players) do
		if player.robber == true then
			for _, pc in ipairs(streamingpcs) do
				if pc and GetDistance(player, pc) <= 1000 then
					if player.ActionComponent.moneyAmount >= 1000 then
						PlaySound(player, "streamercash.mp3")
						GetGameState():SpawnLuaPingSV("streamerping.png", pc:GetActorLocation())
						player.ActionComponent.moneyAmount = player.ActionComponent.moneyAmount - 1000
					end
				end
			end
		end
	end
	SetTimer(5.0, "StreamerDono", playerActor)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == "Streamer" then
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == "Streamer" then
		local plrpos = playerActor:GetActorLocation()
		local closest = GetClosestActor("HackablePC", plrpos)
		local numofstreamers = 0
		
		for i, player in ipairs(GetPlayerChars()) do
			if player.CustomClassString == "Streamer" then
				numofstreamers = numofstreamers + 1
			end
		end
			
		if closest and GetDistance(playerActor, closest) <= 500 and not ActorHasTag(closest, "Streaming") and #GetAllActorsWithTag("Streaming") < (5 * numofstreamers) then
			playerActor:StartAbilityCooldown(45.0)
			PlaySound(closest, "streamerstart.mp3",0.5)
			AddActorTag(closest, "Streaming")
		end
	end
end)