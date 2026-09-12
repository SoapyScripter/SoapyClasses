local classname = "Mimic"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor:startAbilityCooldown(75.0)

        playerActor:AbilitySV()
    end
end)

ListenToEvent("AbilitySV", function(playerActor)
    if playerActor.CustomClassString == classname then
        playerActor.teamnameWidget:SetHiddenIngame(false)
    end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if target.robber == false then
		if source then
			if source.CustomClassString == classname then
                if target.HP - damage <= 0 then
                    source.WeaponComponent:AddWepToSlotSV(target.WeaponComponent.LastEquippedSlot, target.WeaponComponent.CurrentWeaponID)
                end
            end
        end
    end
end)