local classname = "Physicist"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(60.0)

        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        SpawnActor("SM_Act", playerActor:GetActorLocation())
    end
end)