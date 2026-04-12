
-- PASSIVE: Start HP regeneration when the round starts
ListenToEvent("RoundStarted", function()
    local players = GetPlayerChars()
    for i, player in ipairs(players) do
        if player.CustomClassString == "Assassin" then
            SetTimer(1.0, "AssassinPassiveHeal", player)
            LogMessage("Assassin passive started for " .. GetActorName(player))
        end
    end
end)

-- PASSIVE: Heal 1 HP every second, repeat
ListenToEvent("AssassinPassiveHeal", function(playerActor)
    if playerActor.HP < 100 then
        playerActor.HP = playerActor.HP + 1
    end
    -- Repeat the timer to create a loop
    SetTimer(1.0, "AssassinPassiveHeal", playerActor)
end)

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == "Assassin" then
        LogMessage("CLIENT: Assassin cloaking!")

        playerActor:StartAbilityCooldown(6.0)

        -- AbilitySV is called on the client player, but the function executes on the server, which can then handle the logic and replication to all other clients
        playerActor:AbilitySV()

        -- Play a sound locally only for this player, so he knows he activated his ability
        PlaySound(playerActor, "disguiservanish.mp3")

    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == "Assassin" then
        LogMessage("SERVER: Assassin cloaking!")
        end
        -- Setting the .preventShooting variable of the player character class to true, so he can't fire while invisible
		playerActor.preventShooting=true
        
        -- Starting a timer on the playerActor object so he will call LUA back in 5 seconds with the "AssassinUncloak" function
        SetTimer(5.0, "AssassinUncloak", playerActor)
    end
end)

-- When AbilitySV gets called on the server, Ability_ALL gets called for all clients
ListenToEvent("AbilityALL_OnClient", function(playerActor)
    if playerActor.CustomClassString == "Assassin" then
        LogMessage("ALL CLIENTS: Assassin cloaking!")
        -- Setting the .Mesh of the playerActor to hidden on all clients. We don't want to set the whole player character hidden, since this logic is getting overwritten by the game code.
        playerActor.Mesh:SetHiddenIngame(true)

        -- Setting his FP_Arms (the first-person view model) to hidden as well, so the player who used the ability can see something happen on his screen for additional feedback
		playerActor.FP_Arms:SetHiddenIngame(true)

        SetTimer(5.0, "AssassinUncloak_ALL", playerActor)

    end
end)

ListenToEvent("AssassinUncloak", function(playerActor)
	playerActor.preventShooting=false
    LogMessage("SERVER: Assassin visible again!")
end)

ListenToEvent("AssassinUncloak_ALL", function(playerActor)
    playerActor.Mesh:SetHiddenIngame(false)
	playerActor.FP_Arms:SetHiddenIngame(false)
    LogMessage("ALL CLIENTS: Assassin visible again!")
end)