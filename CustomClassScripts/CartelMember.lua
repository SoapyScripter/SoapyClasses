local classname = "CartelMember"

ListenToEvent("AbilityKeyPressed_OnClient", function(playerActor)
	if playerActor.CustomClassString == classname then
		playerActor:startAbilityCooldown(60.0)
		
		playerActor:AbilitySV()
	end
end)

ListenToEvent("AbilitySV", function(playerActor)
	if playerActor.CustomClassString == classname then
		PlaySound(playerActor, "cartelspawn.mp3",0.3)
		local plrpos = playerActor:GetActorLocation()
		local forward = playerActor:GetActorForwardVector()
		local behindPos = {
			X = plrpos.X - forward.X * 50,
			Y = plrpos.Y - forward.Y * 50,
			Z = plrpos.Z - forward.Z * 50
		}
		
		SpawnActor("PlayerAI_Rob",behindPos,nil,nil,"FreshCartel")
		SpawnActor("PlayerAI_Rob",behindPos,nil,nil,"FreshCartel")

		for i, npc in ipairs(GetAllActorsWithTag("FreshCartel")) do
			npc.difficulty = 1
			RemoveActorTag(npc,"FreshCartel")
		end
	end
end)

ListenToEvent("PreReceiveDamage", function(target, source, damage)
	if source then
		if target.HP - damage <= 0 then
			if source.CustomClassString == classname and target.PlayersName then
				SpawnActor("PlayerAI_Rob",target:GetActorLocation())
			end
		end
	end
end)