local classname = "Gambler"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        if playerActor.ActionComponent.moneyAmount > 0 then
            playerActor:startAbilityCooldown(25.0)
            PlaySound(player, "GamblerScroll.mp3")

            SetTimer(3.3, "GamblerGamble", playerActor)
        end
    end
end)

ListenToEvent("GamblerGamble", function(playerActor)
    local coinflip = math.random(1,2)
    local jackpot = math.random(1,100)

    if jackpot == 1 then
        PlaySound(player, "GamblerWin.mp3")
        playerActor.ActionComponent.moneyAmount = playerActor.ActionComponent.moneyAmount*100
    else
        if coinflip == 1 then
            PlaySound(player, "GamblerWin.mp3")
            playerActor.ActionComponent.moneyAmount = playerActor.ActionComponent.moneyAmount*2
        else  
            PlaySound(player, "GamblerLose.mp3")
            playerActor.ActionComponent.moneyAmount = 0
        end
    end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
    if target.CustomClassString == classname then
        local multi = math.random(1,6) - 3

        target.HP = target.HP + (damage * multi)
    end
    if source.CustomClassString == classname then
        local multi = math.random(1,6) - 3

        target.HP = target.HP + (damage * multi)
    end
end)