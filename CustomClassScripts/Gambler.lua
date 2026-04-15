local classname = "Gambler"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        if playerActor.ActionComponent.moneyAmount > 0 then
            playerActor:startAbilityCooldown(math.ceil(25.0 * (math.random(1,6)/3)))
            PlaySound(playerActor, "GamblerScroll.mp3")

            SetTimer(3.5, "GamblerGamble", playerActor)
        end
    end
end)

ListenToEvent("GamblerGamble", function(playerActor)
    local coinflip = math.random(1,2)
    local jackpot = math.random(1,100)

    if jackpot == 1 then
        PlaySound(playerActor, "GamblerWin.mp3", 4)
        playerActor.ActionComponent.moneyAmount = playerActor.ActionComponent.moneyAmount*100
    else
        if coinflip == 1 then
            PlaySound(playerActor, "GamblerWin.mp3")
            playerActor.ActionComponent.moneyAmount = playerActor.ActionComponent.moneyAmount*2
        else  
            PlaySound(playerActor, "GamblerLose.mp3", 2.3)
            playerActor.ActionComponent.moneyAmount = 0
        end
    end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
    if source.CustomClassString == classname or target.CustomClassString == classname then
        local multi = math.random(1,6) - 3

        target.HP = target.HP + (damage * multi)
    end
end)