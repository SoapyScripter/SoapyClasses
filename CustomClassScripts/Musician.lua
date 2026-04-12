local function GetDistance(actor1, actor2)
    local a = actor1:GetActorLocation()
    local b = actor2:GetActorLocation()
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

ListenToEvent("RoundStarted", function()
    local players = GetPlayerChars()
    for i, player in ipairs(players) do
        if player.CustomClassString == "Musician" then
            SetTimer(5.0, "MusicianKeen", player)
        end
    end
end)

ListenToEvent("MusicianKeen", function(playerActor)
	for i, player in ipairs(GetPlayerChars()) do
		if player.robber == true then
			if math.random(1,15) == 1 then
				GetGameState():SpawnLuaPingSV("musiciankeen.png", player:GetActorLocation(),playerActor)
			end
		end
	end
	SetTimer(5.0, "MusicianKeen", playerActor)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == "Musician" then
		playerActor:StartAbilityCooldown(20.0)
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == "Musician" then
		PlaySound(playerActor, "musiciansong.mp3", 0.75)
		for i, player in ipairs(GetPlayerChars()) do
			if player.robber == false then
				if GetDistance(player,playerActor) <= 1500 then
					if player.HP + 50 > 100 then
						player.HP = 100
					else
						player.HP = player.HP + 50
					end
					if player.WeaponComponent then
						for i=0, 4 do
							player.WeaponComponent:GainReserveAmmoForAllWeps()
						end
					end
				end
			end
		end
	end
end)